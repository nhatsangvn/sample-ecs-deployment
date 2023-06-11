locals {
  http_port           = 80
  https_port          = 443
  any_port            = 0
  any_protocol        = "-1"
  tcp_protocol        = "tcp"
  all_ips             = ["0.0.0.0/0"]

  app_port            = 3000
  app_env_variables   = setunion(
    [{ name  = "BASIC_AUTH_USER", value = var.auth_user },
     { name  = "BASIC_AUTH_PASSWORD", value = var.auth_password }], 
    var.default_env_variables)
}
