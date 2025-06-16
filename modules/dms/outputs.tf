# DMS 인스턴스 ARN 출력
output "dms_replication_instance_arn" {
  value = aws_dms_replication_instance.this.replication_instance_arn
}

# 복제 태스크 ID 출력
output "dms_task_id" {
  value = aws_dms_replication_task.migration.replication_task_id
}

