variable "db_password" {
  description = "PostgreSQL_pass"
  type        = string
  sensitive   = true
}

variable "namespace" {
  default = "felhoalapu-lab"
}