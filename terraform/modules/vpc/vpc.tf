resource "aws_vpc" "devtest_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "DevTest_VPC"
  }
}

#Subnets public
resource "aws_subnet" "devtest_public" {
  cidr_block              = var.DevTest_subnetpub
  vpc_id                  = aws_vpc.devtest_vpc.id
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name                                        = "DevTest_public_subnet"
    "kubernetes.io/role/elb"                    = ""
    "kubernetes.io/cluster/devtest-eks-cluster" = "shared"
  }
}

resource "aws_subnet" "devtest_public_alb" {
  cidr_block              = var.DevTest_subnetpub_alb
  vpc_id                  = aws_vpc.devtest_vpc.id
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name                                        = "DevTest_public_subnet_alb"
    "kubernetes.io/role/elb"                    = ""
    "kubernetes.io/cluster/devtest-eks-cluster" = "owned"
  }
}

#Private subnet
resource "aws_subnet" "devtest_private" {
  vpc_id                  = aws_vpc.devtest_vpc.id
  cidr_block              = var.DevTest_subnetprivate
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"
  tags = {
    Name                                        = "DevTest_private_subnet"
    "kubernetes.io/role/internal-elb"           = ""
    "kubernetes.io/cluster/devtest-eks-cluster" = "shared"
  }
}

#eks private networks (2)

resource "aws_subnet" "devtest_eks_private" {
  vpc_id                  = aws_vpc.devtest_vpc.id
  cidr_block              = var.devtest_eks_private
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "DevTest_eks_private_subnet"
  }
}

resource "aws_subnet" "devtest_eks_private2" {
  vpc_id                  = aws_vpc.devtest_vpc.id
  cidr_block              = var.devtest_eks_private2
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "DevTest_eks_private_subnet2"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "devtest_ig" {
  vpc_id = aws_vpc.devtest_vpc.id
  tags = {
    Name = "DevTest_public-igw"

  }
}

#route table
resource "aws_route_table" "devtest-public" {
  vpc_id = aws_vpc.devtest_vpc.id
  tags = {
    Name = "DevTest-public-route"
  }
}

resource "aws_route" "devtest_internet_access" {
  route_table_id         = aws_route_table.devtest-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.devtest_ig.id

}

#route associations public
resource "aws_route_table_association" "devtest-public-1" {
  subnet_id      = aws_subnet.devtest_public.id
  route_table_id = aws_route_table.devtest-public.id

}

resource "aws_route_table_association" "devtest-public-2" {
  subnet_id      = aws_subnet.devtest_public_alb.id
  route_table_id = aws_route_table.devtest-public.id

}

#security group for bastion
resource "aws_security_group" "bastion_ssh" {
  name       = "ssh_only_bastion"
  depends_on = [aws_subnet.devtest_public]
  vpc_id     = aws_vpc.devtest_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh_only_bastion"
  }
}

#EIP block
resource "aws_eip" "nat_eip" {

  public_ipv4_pool = "amazon"
}

resource "aws_eip" "bastion_eip" {
  public_ipv4_pool = "amazon"
}


resource "aws_nat_gateway" "devtest_nat" {
  depends_on    = [aws_eip.nat_eip]
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.devtest_public.id
  tags = {
    Name = "DevTest_Nat"
  }

}

resource "aws_route_table" "devTest_private_subnet_route_table" {
  depends_on = [aws_nat_gateway.devtest_nat]
  vpc_id     = aws_vpc.devtest_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.devtest_nat.id
  }
  tags = {
    Name = "DevTest_private_subnet_route_table"
  }

}

resource "aws_route_table" "devTest_eks_private_subnet_route_table" {
  depends_on = [aws_nat_gateway.devtest_nat]
  vpc_id     = aws_vpc.devtest_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.devtest_nat.id
  }
  tags = {
    Name = "DevTest__eks_private_subnet_route_table"
  }

}

resource "aws_route_table_association" "devtest_private_route_table_association" {
  depends_on     = [aws_route_table.devTest_private_subnet_route_table]
  subnet_id      = aws_subnet.devtest_private.id
  route_table_id = aws_route_table.devTest_private_subnet_route_table.id

}

resource "aws_route_table_association" "devtest_eks_private_route_table_association" {
  depends_on     = [aws_route_table.devTest_eks_private_subnet_route_table]
  subnet_id      = aws_subnet.devtest_eks_private.id
  route_table_id = aws_route_table.devTest_eks_private_subnet_route_table.id

}

resource "aws_route_table_association" "devtest_eks_private_route_table_association2" {
  depends_on     = [aws_route_table.devTest_eks_private_subnet_route_table]
  subnet_id      = aws_subnet.devtest_eks_private2.id
  route_table_id = aws_route_table.devTest_eks_private_subnet_route_table.id

}