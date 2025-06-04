# 생성된 VPC의 ID 출력
output "vpc_id" {
  description = "생성된 VPC의 ID"
  value       = aws_vpc.this.id
}

# 생성된 퍼블릭 서브넷들의 ID 목록 출력
output "public_subnet_ids" {
  description = "퍼블릭 서브넷 ID 리스트"
  value       = aws_subnet.public[*].id
}

# 생성된 프라이빗 서브넷들의 ID 목록 출력
output "private_subnet_ids" {
  description = "프라이빗 서브넷 ID 리스트"
  value       = aws_subnet.private[*].id
}

