#======================================
#  Elastic IP
#======================================
resource "aws_eip" "nat" {
  count = 3
  vpc   = true
}

#======================================
#  VPC
#======================================

module "vpc" {
  source              = "terraform-aws-modules/vpc/aws"
  name                = "${local.project}-${local.environment}"
  cidr                = local.vpc.cidr
  azs                 = data.aws_availability_zones.available.names
  public_subnets      = local.vpc.public_subnets  # 残 10.7.96.0/19
  private_subnets     = local.vpc.private_subnets # 残 10.7.224.0/19
  enable_nat_gateway  = true
  enable_vpn_gateway  = true
  single_nat_gateway  = false
  reuse_nat_ips       = true
  external_nat_ip_ids = aws_eip.nat.*.id
}

#======================================
#  Security Group
#======================================

module "security_group" {
  source           = "../../../modules/aws/security_group"
  vpc_id           = module.vpc.vpc_id
  alb_sg_name      = "${local.project}-${local.environment}-alb"
  common_sg_name   = "${local.project}-${local.environment}-common"
  internal_sg_name = "${local.project}-${local.environment}-ínternal"
  cidr_blocks      = local.vpc.cidr
}

#======================================
#  Backend App ECS
#======================================

#======================================
# ECS Cluster
#======================================

resource "aws_ecs_cluster" "main" {
  name = "${local.project}-${local.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

#======================================
# ECS Service
#======================================

module "backend_ecs" {
  source                = "../../../modules/aws/ecs"
  cluster_name          = aws_ecs_cluster.main.name
  cluster_id            = aws_ecs_cluster.main.id
  ecs_task_role_name    = "${local.project}-${local.environment}-backend-task-execution"
  task_name             = "backend"
  retention_in_days     = 30
  environment           = local.environment
  project               = local.project
  security_groups       = [module.security_group.common_id]
  subnet_ids            = module.vpc.private_subnets
  port                  = 8000
  fargate_cpu           = 512
  fargate_memory        = 1024
  repository_name       = "${local.aws_image_registry}/${local.project}/${local.environment}/backend"
  image_tag             = ":latest"
  aws_region            = local.aws_region
  schedule_task         = 0
  target_group_arn      = module.backend_alb.target_group_arns[0]
  http_tcp_listener_arn = module.backend_alb.http_tcp_listener_arns[0]
}

#======================================
# Application LoadBalance
#======================================

module "backend_alb" {
  source                     = "terraform-aws-modules/alb/aws"
  version                    = "~> 6.0"
  name                       = "${local.project}-${local.environment}-backend"
  load_balancer_type         = "application"
  vpc_id                     = module.vpc.vpc_id
  subnets                    = module.vpc.public_subnets
  enable_deletion_protection = false
  security_groups            = module.security_group.ids
  access_logs                = {
    bucket = module.backend_alb_access_log_bucket.bucket
  }

  target_groups = [
    {
      name             = "${local.project}-${local.environment}-backend"
      backend_protocol = "HTTP"
      backend_port     = 8000
      target_type      = "ip"
      health_check     = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect    = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = local.alb_acm
      target_group_index = 0
    }
  ]
}

#======================================
# Application LoadBalance Log
#======================================

module "backend_alb_access_log_bucket" {
  source      = "../../../modules/aws/alb_access_log"
  bucket_name = "${local.project}-${local.environment}-backend-alb-logs"
}

#======================================
# Application LoadBalance Route53 Alias
#======================================

resource "aws_route53_record" "backend" {
  type    = "A"
  name    = local.backend_domain_name
  zone_id = local.zone_id

  alias {
    name                   = module.backend_alb.lb_dns_name
    zone_id                = module.backend_alb.lb_zone_id
    evaluate_target_health = true
  }
}

#======================================
# ECS Task Auto Scaling
#======================================

module "backend_auto_scaling" {
  source                  = "../../../modules/aws/auto_scaling"
  cluster_name            = "${local.project}-${local.environment}"
  task_name               = "backend"
  service_name            = "${local.project}-${local.environment}-backend-service"
  scaling_up_adjustment   = 1
  scaling_down_adjustment = -1
  cpu_high_threshold      = "85"
  cpu_low_threshold       = "10"
}

#======================================
# WAF WEB ACL For ALB
#======================================

resource "aws_wafv2_web_acl" "waf_acl" {
  name  = "${local.project}-${local.environment}-web_acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "RateLimit"
    priority = 1

    action {
      block {}
    }

    statement {

      rate_based_statement {
        aggregate_key_type = "IP"
        limit              = 500
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimit"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "${local.project}-${local.environment}-web_acl"
    sampled_requests_enabled   = false
  }
}

#======================================
# WAF WEB ACL Association
#======================================

resource "aws_wafv2_web_acl_association" "web_acl_association_my_lb" {
  resource_arn = module.backend_alb.lb_arn
  web_acl_arn  = aws_wafv2_web_acl.waf_acl.arn
}

#======================================
#  Elastic Cache: Redis CLuster
#======================================

module "elastic_cache" {
  source                     = "../../../modules/aws/elasticache"
  cluster_name               = "${local.project}-${local.environment}-elasticache"
  node_type                  = "cache.t2.micro"
  engine_version             = "6.x"
  family                     = "redis6.0"
  parameter_group_name       = "default.redis6.x.cluster.on"
  number_cache_clusters      = 2
  replicas_per_node_group    = 1
  automatic_failover_enabled = true
  multi_az_enabled           = true
  vpc_id                     = module.vpc.vpc_id
  subnet_ids                 = module.vpc.private_subnets
  aws_security_group_ids     = [module.security_group.internal_id]
}

#======================================
#  Blockchain EC2 Instance
#======================================

module "ec2" {
  source                      = "../../../modules/aws/ec2"
  vpc_id                      = module.vpc.vpc_id
  subnet_id                   = module.vpc.private_subnets.0
  environment                 = local.environment
  instance_name               = "${local.project}-${local.environment}-BLC"
  instance_type               = "t3.xlarg"
  project                     = local.project
  associate_public_ip_address = false
  volume_size                 = 32
  vpc_cidr                    = local.vpc.cidr
  key_pair_name               = "${local.project}-${local.environment}-BLC"
}

#======================================
#  VPC Client VPN
#======================================

module "client-vpn" {
  source                 = "../../../modules/aws/client-vpn"
  vpc_id                 = module.vpc.vpc_id
  client_cidr            = local.vpn.vpn_client_cidr
  allowed_cidr_ranges    = local.vpc.private_subnets
  name                   = "${local.project}-${local.environment}-client-vpn"
  subnet_ids             = module.vpc.private_subnets
  client_certificate_arn = local.vpn.client_certificate_arn
  server_certificate_arn = local.vpn.server_certificate_arn
}

#======================================
#  S3 Bucket
#======================================

module "cloudtrail" {
  source      = "../../../modules/aws/cloudtrail"
  environment = local.environment
  project     = local.project
}


module "static-metadata-file" {
  source        = "../../../modules/aws/s3"
  bucket_name   = "${local.project}-${local.environment}-metadata"
  attach_policy = 0
}
