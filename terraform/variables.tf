variable "access_token" {
  type      = string
  sensitive = true
}

variable "environment" {
  type    = string
  default = "production"
}