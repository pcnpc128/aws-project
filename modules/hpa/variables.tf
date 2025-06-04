variable "name" {}
variable "namespace" {}
variable "kind" { default = "Deployment" }
variable "target_name" {}
variable "min_replicas" { default = 3 }
variable "max_replicas" { default = 10 }
variable "target_cpu_utilization" { default = 30 }

