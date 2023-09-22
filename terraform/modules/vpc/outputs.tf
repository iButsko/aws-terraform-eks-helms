# VPC Output Values

output "vpc_id" {
  value = aws_vpc.devtest_vpc.id

}

output "gateway_id" {
  value = aws_internet_gateway.devtest_ig.id
}

output "subnet_id" {
  description = "public subnet network"
  value       = aws_subnet.devtest_public.id

}

output "private_subnet_id" {
  description = "private subnet network"
  value       = aws_subnet.devtest_private.id
}

output "private_eks_subnet" {
  description = "private subnet for eks modules"
  value       = aws_subnet.devtest_eks_private.id
}

output "private_eks_subnet2" {
  description = "second private subnet for eks modules"
  value       = aws_subnet.devtest_eks_private2.id
}


output "vpc_security_group_ids" {
  value = aws_security_group.bastion_ssh.id

}

output "route_table_id" {
  value = aws_route_table.devtest-public.id
}

output "allocation_id" {
  value = aws_eip.bastion_eip.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.devtest_nat.id

}

output "aws_eip_bastion" {
  value = aws_eip.bastion_eip.id
}