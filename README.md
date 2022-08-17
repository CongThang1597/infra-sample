# rbo-infra
【RBO】インフラ
### Development

#### Init for first time
1. Create s3 bucket with name `rbo-check-ag-local-development-tfstate`
2. Create dynamotable with name `rbo-check-ag-local-development-tfstate` with key is LockID

#### Run terraform template
```shell
cd tf/initial/development
terraform init
terraform plan
terraform apply
```
