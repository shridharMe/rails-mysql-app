data "aws_region" "current" {}


data "aws_acm_certificate" "acm" {
  domain      = "*.${var.hosted_zone_name}"
  types       = ["AMAZON_ISSUED"]
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "route53" {
  name = "${var.hosted_zone_name}."
}


resource "aws_cloudwatch_log_group" "main" {
  name              = "${var.name_prefix}"
  retention_in_days = "${var.log_retention_in_days}"
  tags {
    Name        = "${var.name_prefix}-log-group"
    Environment = "${var.environment}"
    Terraform   = "${var.terraform}"
    Owner       = "${var.owner}"
  }
}

module "fargate" {
  source = "git::https://github.com/shridharMe/terraform-modules.git//modules/fargate?ref=master"

  //vpc
  name_prefix          = "${var.environment}-${var.name_prefix}"
  cidr                 = "${var.cidr}"
  public_subnets_cidr  = "${var.public_subnets_cidr}"
  private_subnets_cidr = "${var.private_subnets_cidr}"
  azs                  = "${var.azs}"
  environment          = "${var.environment}-"
  owner                = "${var.owner}"
  terraform            = "${var.terraform}"

  //alb-sg
  source_cidr_block_inbound = "${var.source_cidr_block_inbound}"

  //target_group_task
  alb-health_check_path = "${var.alb_health_check_path}"
  
  // alb
  route53zoneid   ="${data.aws_route53_zone.route53.zone_id}"
  route53type     ="${var.route53type}"
  route53ttl      ="${var.route53ttl}"
  internal        = "${var.internal}"

  //listener
  certificate_arn = "${data.aws_acm_certificate.acm.arn}"
  ssl_policy      = "${var.ssl_policy}"

  //listener-rule
  priority     = "${var.priority}"
  path_pattern = "${var.path_pattern}"

  //log_group
  log_retention_in_days = "${var.log_retention_in_days}"

  //fargate service
  desired_count                     = "${var.desired_count}"
  minimum_healthy_percent           = "${var.minimum_healthy_percent}"
  maximum_healthy_percent           = "${var.maximum_healthy_percent}"
  health_check_grace_period_seconds = "${var.health_check_grace_period_seconds}"
  task_container_assign_public_ip   = "${var.task_container_assign_public_ip}"
  task_container_port               = "${var.task_container_port}"

  // fargate task
  task_definition_memory = "${var.task_definition_memory}"
  task_definition_cpu    = "${var.task_definition_cpu}"

   container_definitions = <<EOF
[{
     "cpu": ${var.task_definition_cpu},
      "essential": true,    
      "image": "shridharpatil01/rails-app",
      "memory": ${var.task_definition_memory},
      "name": "rails-app",    
      "networkMode": "awsvpc",
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.main.name}",
            "awslogs-region": "${data.aws_region.current.name}",
            "awslogs-stream-prefix": "ecs"
          }
      },    
      "portMappings": [
        {
          "containerPort": ${var.container_port},
          "hostPort": ${var.host_port}
        }
      ]
}]
EOF
}
