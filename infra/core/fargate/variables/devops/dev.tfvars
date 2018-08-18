//vpc
name_prefix = "myco"

cidr = "10.1.0.0/16"

public_subnets_cidr = ["10.1.1.0/24", "10.1.2.0/24"]

private_subnets_cidr = ["10.1.3.0/24", "10.1.4.0/24"]

azs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

environment = "dev"

owner = "me@devopsTeam"

terraform = "true"

source_cidr_block_inbound = ["86.183.157.120/32"]

alb_health_check_path = "/"

route53type = "CNAME"

route53ttl = "300"

internal = "false"

hosted_zone_name = ""

ssl_policy = "ELBSecurityPolicy-2016-08"

priority = "100"

log_retention_in_days = "30"

desired_count = "1"

minimum_healthy_percent = "1"

maximum_healthy_percent = "1"

health_check_grace_period_seconds = "300"

task_container_assign_public_ip = "false"

task_container_port = "3000"

task_definition_memory = "512"

task_definition_cpu = "256"
