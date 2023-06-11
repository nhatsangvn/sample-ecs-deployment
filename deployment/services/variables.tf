variable "app_port" {
  description = "The port the contaienr will use for HTTP requests"
  type        = number
  default     = 3000
}

variable "auth_user" {
  description = "The user to authenticate with the requests"
  type        = string
  sensitive   = true
}

variable "auth_password" {
  description = "The user's password to authenticate with the requests"
  type        = string
  sensitive   = true
}

variable "default_env_variables" {
  type    = list(object({
    name  = string
    value = string
  }))
  default = [
        { "name": "environment", "value": "production" },
        { "name": "app", "value": "rg-ops" }
      ]
}

