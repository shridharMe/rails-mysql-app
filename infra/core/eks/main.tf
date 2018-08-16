module "fargagte" {
  source = "git::https://github.com/shridharMe/terraform-modules.git//modules/fargate?ref=master"
}

module "eks" {
  source             = "git::https://github.com/shridharMe/terraform-modules.git//modules/fargate?ref=master"
  cluster-name       = "${var.name}"
  cidr               = "${var.cidr}"
  public_subnets     = "${var.public_subnets}"
  private_subnets    = "${var.private_subnets}"
  azs                = "${var.azs}"
  owner              = "${var.owner}"
  environment        = "${var.environment}"
  terraform          = "${var.terraform}"
  node-instance-type = "${var.node-instance-type}"
  desired-capacity   = "${var.desired-capacity}"
  max-size           = "${var.node-max-size}"
  min-size           = "${var.node-min-size}"
}
