output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "frontend_subnet_ids" {
  value = aws_subnet.frontend[*].id
}

output "backend_subnet_ids" {
  value = aws_subnet.backend[*].id
}

output "db_subnet_ids" {
  value = aws_subnet.db[*].id
}

output "nat_gateway_ids" {
  value = var.nat_mode == "regional" ? aws_nat_gateway.regional[*].id : aws_nat_gateway.zonal[*].id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}
