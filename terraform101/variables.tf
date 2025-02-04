variable "application_name" {}
variable "environment_name" {}

# For secure variables to not be displayed in the terraform output logs
variable "api_key" {
  sensitive = true
}