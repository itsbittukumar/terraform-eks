cluster_name = "uat-eks-cluster"

vpc_id = "vpc-07b46a6bd77572f7b"

private_subnet_ids = [
  "subnet-051fba875b07215d5",
  "subnet-068e3bbe99d6107e1"
]

cluster_security_group_ids = [
  "sg-01f49adf02bc9dd25"
]

node_group_name = "uat-node-group"