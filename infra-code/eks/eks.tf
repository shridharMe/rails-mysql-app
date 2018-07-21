module "module" {
  source  = "WesleyCharlesBlake/eks/aws"
  version = "1.0.3"

  cluster-name       = "${var.cluster-name}"
  aws-region         = "${var.aws-region}"
  node-instance-type = "${var.node-instance-type}"
  desired-capacity   = "${var.desired-capacity}"
  max-size           = "${var.max-size}"
  min-size           = "${var.min-size}"
}