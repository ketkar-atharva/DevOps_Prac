output "vpc_id" {
  value = aws_vpc.main.id
}

output "web_public_ip" {
  value = aws_instance.web.public_ip
}

output "app_private_ip" {
  value = try(aws_instance.app[0].private_ip, "app server not created (enable_nat = false)")
}

output "rds_endpoint" {
  value = aws_db_instance.main.address
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "db_subnet_ids" {
  value = [for s in aws_subnet.db : s.id]
}