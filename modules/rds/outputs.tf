output "primary_rds_arn" { value = try(aws_db_instance.primary[0].arn, null) }
