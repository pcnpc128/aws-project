output "endpoint" {
  value = var.create_primary ? aws_db_instance.primary[0].endpoint : aws_db_instance.replica[0].endpoint
}

output "db_instance_id" {
  value = var.create_primary ? aws_db_instance.primary[0].id : aws_db_instance.replica[0].id
}

output "primary_rds_arn" {
  value = var.create_primary ? aws_db_instance.primary[0].arn : aws_db_instance.replica[0].arn
}

output "db_instance_identifier" {
  value = var.create_primary ? aws_db_instance.primary[0].id : aws_db_instance.replica[0].id
}
