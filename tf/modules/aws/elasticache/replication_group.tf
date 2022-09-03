resource "aws_elasticache_replication_group" "main" {
  replication_group_id       = var.cluster_name
  description                = var.cluster_name
  engine                     = var.engine
  engine_version             = var.engine_version
  node_type                  = var.node_type
  num_node_groups            = var.number_cache_clusters
  replicas_per_node_group    = var.replicas_per_node_group
  parameter_group_name       = var.parameter_group_name
  port                       = var.port
  subnet_group_name          = aws_elasticache_subnet_group.main.name
  security_group_ids         = var.aws_security_group_ids
  snapshot_retention_limit   = var.snapshot_retention_limit
  snapshot_window            = var.snapshot_window
  maintenance_window         = var.maintenance_window
  automatic_failover_enabled = var.automatic_failover_enabled
  multi_az_enabled           = var.multi_az_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  auth_token                 = var.auth_token
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  apply_immediately          = var.apply_immediately

  lifecycle {
    ignore_changes = [num_cache_clusters]
  }

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.elasticache.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }
}


resource "aws_cloudwatch_log_group" "elasticache" {
  name              = var.cluster_name
  retention_in_days = var.log_retention_in_days
}
