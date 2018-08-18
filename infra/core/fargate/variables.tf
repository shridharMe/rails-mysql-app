// module ALB

//vpc
variable "name_prefix" {
  default = "fargate"
}

variable "cidr" {
  default = "10.1.0.0/16"
}

variable "public_subnets_cidr" {
  type    = "list"
  default = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "private_subnets_cidr" {
  type    = "list"
  default = ["10.1.3.0/24", "10.1.4.0/24"]
}

variable "azs" {
  type    = "list"
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "environment" {
  default = "dev"
}


variable "owner" {
  default = "me@devopsTeam"
}

variable "terraform" {
  default = "true"
}
//alb

variable "hosted_zone_name" {
  default = ""
}

variable "route53type" {
  default = "CNAME"
}

variable "route53ttl" {
  default = "300"
}

variable "internal" {
  default = "false"
}

//alb-sg
variable "source_cidr_block_inbound" {
  default = ""
}

//target_group_task
variable "alb_health_check_path" {
  default = "/"
}

//listener
variable "certificate_arn" {
  default = ""
}

variable "ssl_policy" {
  default = "ELBSecurityPolicy-2016-08"
}

//listener-rule
variable "priority" {
  default = "100"
}

variable "path_pattern" {
  default = ""
}

//log_group
variable "log_retention_in_days" {
  default = "30"
}

//fargate service
variable "desired_count" {
  default = "1"
}

variable "minimum_healthy_percent" {
  default = ""
}

variable "maximum_healthy_percent" {
  default = ""
}

variable "health_check_grace_period_seconds" {
  default = "300"
}

variable "task_container_assign_public_ip" {
  default = "false"
}

variable "task_container_port" {
  default = "80"
}

// fargate task
variable "task_definition_memory" {
  default = "512"
}

variable "task_definition_cpu" {
  default = "256"
}

variable "container_port" {
  default = "443"
}

variable "host_port" {
  default = "443"
}

variable "image" {
  default = "rails-app"
}

variable "image_version" {
  default = "latest"
}
