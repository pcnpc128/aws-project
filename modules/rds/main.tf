# RDS 서브넷 그룹 생성 (프라이빗 서브넷에 DB 인스턴스 배치)
resource "aws_db_subnet_group" "main" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = { Name = "${var.db_name}-subnet-group" }
}

# MySQL utf8mb4 파라미터 그룹 생성 (한글/이모지 완벽 지원)
resource "aws_db_parameter_group" "mysql_utf8mb4" {
  name        = "${var.db_name}-utf8mb4"
  family      = "mysql8.0"
  description = "MySQL 8.0 utf8mb4 (유니코드/이모지/한글 완벽 지원)"
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }
  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }
}

# 서울 리전 Primary 인스턴스 생성
resource "aws_db_instance" "primary" {
  count                    = var.create_primary ? 1 : 0
  identifier               = "${var.db_name}-primary"
  engine                   = var.engine
  engine_version           = var.engine_version
  instance_class           = var.instance_class
  allocated_storage        = var.allocated_storage
  username                 = var.username
  password                 = var.password
  db_subnet_group_name     = aws_db_subnet_group.main.name
  parameter_group_name     = aws_db_parameter_group.mysql_utf8mb4.name
  vpc_security_group_ids   = var.security_group_ids
  multi_az                 = true                 # 다중 AZ 배포
  backup_retention_period  = 7
  skip_final_snapshot      = true
  tags = { Name = "${var.db_name}-primary" }
}

# 도쿄 리전 Cross-Region Read Replica (다중 AZ)
resource "aws_db_instance" "read_replica" {
  count                  = var.create_replica ? 1 : 0
  identifier             = "${var.db_name}-replica"
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_subnet_group_name   = aws_db_subnet_group.main.name
  parameter_group_name   = aws_db_parameter_group.mysql_utf8mb4.name
  vpc_security_group_ids = var.security_group_ids
  publicly_accessible    = false
  replicate_source_db    = var.replicate_source_arn
  skip_final_snapshot    = true
  multi_az               = true                 # 역시 다중 AZ 배포
  tags = { Name = "${var.db_name}-replica" }
}
