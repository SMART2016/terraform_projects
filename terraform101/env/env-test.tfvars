# Terraform doesn't load it automatically but needs to be passed as below
# terraform apply -var-file env-dev.tfvars
environment_name = "test"
instance_count = 3
regions = ["westus","eastus"]
region_instance_count = {
  "westus" = 4
  "eastus" = 3
}

region_set = ["westus","eastus"]