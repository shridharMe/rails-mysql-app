cluster-name = "dev-eks"

name = "myco"

cidr = "10.1.0.0/16"

private_subnets = ["10.1.3.0/24", "10.1.4.0/24"]

public_subnets = ["10.1.1.0/24", "10.1.2.0/24"]

azs = ["us-east-1a", "us-east-1b"]

environment = "dev"

owner = "devopsTeam"

terraform = "1"

node-instance-type = "m4.large"

desired-capacity = "2"

max-size = "2"

min-size = "1"

cluster-name = "dev-eks"
