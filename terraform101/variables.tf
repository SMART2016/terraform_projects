variable "application_name" {
  # Variable type definition
  type = string
}
variable "environment_name" {
  type = string
}

# For secure variables to not be displayed in the terraform output logs
variable "api_key" {
  sensitive = true
  type = string
}

variable "instance_count" {
  type = number
}

# Indexed List variable
variable "regions" {
  type = list(string)
}

# Map Variables
variable "region_instance_count"{
  type = map(string)
}

# Unordered / unindexed Set Variable
# Cannot be accessed via index and can only be iterated
variable "region_set" {
  type = set(string)
}