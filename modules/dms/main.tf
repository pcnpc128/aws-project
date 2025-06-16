# DMS용 IAM 역할
resource "aws_iam_role" "dms_vpc_role" {
  name = "dms-vpc-role"
  assume_role_policy = data.aws_iam_policy_document.dms_assume_policy.json
}

data "aws_iam_policy_document" "dms_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["dms.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "dms_vpc_access" {
  role       = aws_iam_role.dms_vpc_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
}

# DMS Subnet Group
resource "aws_dms_replication_subnet_group" "subnet_group" {
  replication_subnet_group_id = "dms-subnet-group"
  subnet_ids                  = var.subnet_ids
  tags = {
    Name = "dms-subnet-group"
  }
}

# DMS 인스턴스
resource "aws_dms_replication_instance" "dms_instance" {
  replication_instance_id     = "dms-instance"
  replication_instance_class  = "dms.t3.medium"
  allocated_storage           = 50
  vpc_security_group_ids      = var.security_group_ids
  replication_subnet_group_id = aws_dms_replication_subnet_group.subnet_group.id
  multi_az                    = false
  publicly_accessible         = true
  tags = {
    Name = "dms-instance"
  }
}

# 소스 (온프레미스 MySQL)
resource "aws_dms_endpoint" "source" {
  endpoint_id               = "mysql-source"
  endpoint_type             = "source"
  engine_name               = "mysql"
  server_name               = var.source_db_host
  port                      = var.source_db_port
  username                  = var.source_db_username
  password                  = var.source_db_password
  database_name             = var.source_db_name
}

# 대상 (AWS RDS MySQL)
resource "aws_dms_endpoint" "target" {
  endpoint_id               = "mysql-target"
  endpoint_type             = "target"
  engine_name               = "mysql"
  server_name               = var.target_db_host
  port                      = var.target_db_port
  username                  = var.target_db_username
  password                  = var.target_db_password
  database_name             = var.target_db_name
}

# DMS 작업 (전체 로드 방식, Lob 포함)
resource "aws_dms_replication_task" "migration_task" {
  replication_task_id      = "migration-task"
  migration_type           = "full-load-and-cdc"
  replication_instance_arn = aws_dms_replication_instance.dms_instance.replication_instance_arn
  source_endpoint_arn      = aws_dms_endpoint.source.endpoint_arn
  target_endpoint_arn      = aws_dms_endpoint.target.endpoint_arn

  # 테이블 전체 마이그레이션
  table_mappings = jsonencode({
    rules: [
      {
        "rule-type"      = "selection"
        "rule-id"        = "1"
        "rule-name"      = "1"
        "object-locator" = {
          "schema-name" = "%"
          "table-name"  = "%"
        }
        "rule-action" = "include"
      }
    ]
  })

  # 작업 설정
  replication_task_settings = jsonencode({
    TargetMetadata = {
      TargetSchema        = ""
      SupportLobs         = true
      FullLobMode         = true
      LobChunkSize        = 64
      LimitedSizeLobMode  = false
      LoadMaxFileSize     = 0
      ParallelLoadThreads = 0
    }
  })

  tags = {
    Name = "migration-task"
  }
}

