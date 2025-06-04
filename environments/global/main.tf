provider "aws" {
  region  = "us-west-2"   # Global Accelerator는 리전리스, 하지만 관리 리전 명시
  profile = var.profile
}

module "global_accelerator" {
  source        = "../../modules/global-accelerator"
  name          = "myapp-dr-accelerator"
  seoul_alb_arn = var.seoul_alb_arn
  tokyo_alb_arn = var.tokyo_alb_arn
}
