
resource "random_string" "suffix" {
  length = 6
  special = false
  upper = false
}


locals {
  environment_suffix = "${var.application_name}-${var.environment_name}-${random_string.suffix.result}"
}

