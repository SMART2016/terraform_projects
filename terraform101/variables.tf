variable "application_name" {
  # Variable type definition
  type = string
  # input validation
  validation {
    # Any Boolean Expression, we can use anything in the condition variables, locals , datastores , resources.
    # It is recommeneded not to use resources here , because they will not exist until apply is run the first time
    condition = length(var.application_name) <= var.name_length

    # In case condition returns False use below error
    error_message = "Application Name greater than ${var.name_length} is not allowed"
  }
}

variable "name_length" {
  type = number
  default = 30
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

# Complex Object Variable
variable "skew_settings" {
  type = object({
    kind = string
    tier = string
  })
}