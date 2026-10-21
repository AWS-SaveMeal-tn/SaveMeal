variable "name_prefix" {
  type = string
}

variable "subnet_id" {
  description = "Subnet privé frontend (AZ-a)"
  type        = string
}

variable "security_group_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "key_name" {
  description = "Key pair EC2 optionnelle (SSM est le chemin recommandé)"
  type        = string
  default     = null
}

variable "app_repo_url" {
  type    = string
  default = ""
}
