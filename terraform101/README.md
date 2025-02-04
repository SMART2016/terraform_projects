# Terraform get started
- Consistent and Predictable creation of infra environment via code
- The format of IAC can be JSON,YAMl or HCL(Hashicorp config Language)
- **Imperative vs Declarative**
  - **Declaration IAC**
    - Telling just what we want and not the details on how to achieve that
    - Terraform uses declarative approach to define what to do.
  - I**mperative IAC**
    - Telling the exact set of steps to do something is called imperative.
- **Idempotency**
  - Same request return same response every time and doesnt change.
  - Terraform follows idempotency.
  - If we haven't change a config and try to apply it in the same env , it will not do anything because nothing changed in the configs.
- **Push Vs Pull**
  - Terraform uses push model to push configs to the target env.
- **Advantages**
  - Reusability
  - Automated Deployment
  - Documented Architecture
- Terraform can work with any service that has an API exposed.
- **State Data**
  - https://developer.hashicorp.com/terraform/language/state
  - For every execution of terraform configuration to a target environment , it creates a state for the execution , 
    which is the target state.
  - When we apply new configs terraform compares the new config with the current state and if there are diffs in the new
     config it applies to the target env.
  - Once applied updates the states data.

- Providers
  - The Provider to use to create an environment
  - Resources
    - The resources like vm etc to be created in a provider
  - Datasources
    - Query a provider for information

## **Defining a Object**
- Object Definition
 ```
  block_type "block_type_label" "name_label" {
    attribute_key = "value"
    nested_block {
        key = "value"
      }
  }
  ```
  
  - Eg: 
    ```
    resource "aws_instance" "web_server" {
      name = "web-server"
      ebs_volume {
          size = 40
        }
    }

    ```
- **Referencing an object:**
  - `{block_type_label}.{name_label}.{attribute_key}`
- Bash heredoc syntax to define large scripts inline:
  - https://linuxize.com/post/bash-heredoc/
    - Eg:
      ``` 
      # INSTANCES #
        resource "aws_instance" "nginx1" {
            ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
            instance_type          = "t3.micro"
            subnet_id              = aws_subnet.public_subnet1.id
            vpc_security_group_ids = [aws_security_group.nginx_sg.id]
             Bash heredocs
            user_data = <<EOF
            #! /bin/bash
            sudo amazon-linux-extras install -y nginx1
            sudo service nginx start
            sudo rm /usr/share/nginx/html/index.html
            echo '<html><head><title>Taco Team Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
            EOF
        }
      ```
      
  
## Terraform Workflow
- **INIT**
  - https://developer.hashicorp.com/terraform/cli/commands/init
  - https://www.env0.com/blog/terraform-init
  - Command: `terraform init`
  - Initializes provider plugins and the initializing the state data backend
- **PLAN**
  - https://www.env0.com/blog/terraform-plan
  - Command: `terraform plan`
  - Terraform always forms an execution plan before it executes the changes on the target env.
  - Reads the current configs and state data to find the difference between the two and makes a plan of what needs to be
     applied in the target environment.
- **Apply**
  - https://www.env0.com/blog/terraform-apply-guide-command-options-and-examples
  - Command: `terraform apply`
  - Terraform executes the changes with the provider plugins to the target environment.

## Dependency Management
- https://www.scalr.com/blog/terraform-resource-dependencies-explained
- https://developer.hashicorp.com/terraform/internals/graph
- https://docs.google.com/document/d/1D9Sfkzs3hUxnIesQSII-Me4G71oGqiZs-nTjUvpCpzQ/edit?usp=share_link
- **Dependency Graph:**
  Terraform builds a directed acyclic graph (DAG) based on these dependencies, where each node represents a resource,
   and edges represent dependencies between them. During the terraform apply process, Terraform traverses this graph, 
   creating or modifying resources in the appropriate order to satisfy their dependencies.


## Input Variables
- Different ways to provide values to input variables
  1. **Command-Line Flags (-var)**
     - Provide variable values directly in the terraform plan or terraform apply commands:
       - `terraform apply -var="instance_type=t2.large"
     - Use Case
       - Useful for one-off changes without modifying variable files.
       - Ideal for quick testing.
     - Precedence
       - Command-line flags have the highest precedence.
  2. **Environment Variables (TF_VAR_<variable_name>)**
      - You can set input variables through environment variables prefixed with TF_VAR_. For example:
       - `export TF_VAR_instance_type=t2.micro`
       - Use Case 
         - Useful for CI/CD pipelines or when working across multiple environments. 
         - Ideal for sensitive variables stored in environment secrets. 
       - Precedence 
         - Environment variables have lower precedence than command-line flags but higher than variables defined in files.
  3. Files specified with -var-file flag have higher precedence than default .tfvars files.
  4. **terraform.auto.tfvars (or .tfvars.json)**
     - This file automatically provides variable values without needing explicit reference in the Terraform commands. 
     - Terraform automatically loads it during execution
     - Use Case 
       - Useful for default environment-specific configurations. 
       - Ideal for shared settings in multi-user environments without requiring -var-file flags.
     - Precedence 
       - terraform.auto.tfvars and terraform.auto.tfvars.json are loaded automatically and have higher precedence than terraform.
           tfvars but lower than -var-file and environment variables.
  5. **Variable Definition Files (.tfvars or .tfvars.json)**
      - You can define variables in files with .tfvars or .tfvars.json extensions:
        - variables.tfvars (HCL)
          - `instance_type = "t2.medium"
        - variables.json
          - ```
               {
                 "instance_type": "t2.medium"
               }
            ```
     - Use Case
       - Useful for managing configurations in a structured and reusable manner.
       - Ideal for different environment configurations.
     - Precedence
       - Files specified with -var-file flag have higher precedence than default .tfvars files.
     - Default File Locations
       - Terraform automatically loads these files:
         - terraform.tfvars 
         - terraform.tfvars.json
     - Specifying Custom Files
       - `terraform apply -var-file="prod.tfvars"`
  6. **Default Variable Values in variables.tf**
     - Define default values directly in the Terraform configuration file:
       ```azure
             variable "instance_type" {
                      default = "t2.micro"
            }
       ```
     - Use Case
       - Useful when most deployments share a common configuration.
       - Avoids the need for explicit user input.
     - Precedence
       - Lowest precedence; overridden by all other methods.
- **Precedence Order (From Highest to Lowest)**
  1. Command-Line Flags (-var)
  2. Environment Variables (TF_VAR_<variable_name>)
  3. Variable Definition Files (-var-file)
  4. Default Variable Values in variables.tf
  