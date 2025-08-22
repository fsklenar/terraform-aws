Managing Terraform code for different resources in separate folders while sharing a common VPC is a common and recommended practice for maintainability and scalability. Here's a breakdown of how to achieve this, focusing on modularity and reusability:

### Core Concepts

  * **Modularity:** Break down your infrastructure into logical, reusable modules. A module can encapsulate a set of related resources (e.g., an EC2 instance, its associated security groups, and an EBS volume).
  * **Remote State:** Store your Terraform state in a shared, remote backend (like Amazon S3, Azure Storage, or HashiCorp Consul). This allows multiple Terraform configurations to read and write to the same state, enabling cross-resource dependencies.
  * **Data Sources:** Use data sources to read information from existing infrastructure, including the common VPC created by another Terraform configuration.
  * **Folder Structure:** Organize your Terraform configurations into a logical folder hierarchy.

### Recommended Folder Structure

A common and effective folder structure looks something like this:

```
.
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── ec2-instance/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── rds-database/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── networking/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
└── backend.tf
```

### Step-by-Step Implementation

Let's assume you're using AWS for this example.

#### 1\. Define Your Common VPC Module (`modules/vpc/`)

This module will create your shared VPC and its core components (subnets, route tables, internet gateway, etc.).

**`modules/vpc/main.tf`:**

```terraform
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-main-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets_cidr[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name        = "${var.environment}-public-subnet-${count.index}"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

# ... other VPC resources like private subnets, route tables, NAT gateways, etc.
```

**`modules/vpc/variables.tf`:**

```terraform
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnets_cidr" {
  description = "A list of public subnet CIDR blocks."
  type        = list(string)
}

variable "azs" {
  description = "A list of availability zones to deploy subnets into."
  type        = list(string)
}

variable "environment" {
  description = "The environment name (e.g., dev, prod)."
  type        = string
}
```

**`modules/vpc/outputs.tf`:**

```terraform
output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "A list of public subnet IDs."
  value       = aws_subnet.public[*].id
}

# ... other VPC outputs you might need (e.g., private_subnet_ids, security_group_ids)
```

#### 2\. Configure Remote State Backend (`backend.tf` or within each environment)

It's common to define the backend configuration at a top level or within each environment folder. For shared VPCs, it's crucial that the *VPC configuration* uses a backend that other configurations can read from.

**`backend.tf` (in the root or `environments/dev/`):**

```terraform
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket" # Replace with your S3 bucket name
    key            = "vpc/terraform.tfstate"       # Key for the VPC state file
    region         = "us-east-1"                   # Replace with your AWS region
    dynamodb_table = "your-terraform-lock-table"   # Optional: For state locking
    encrypt        = true
  }
}
```

*Note: Each environment should have its own `key` for its state file, for example, `environments/dev/main.tf` would have `key = "dev/terraform.tfstate"`.*

#### 3\. Deploy the Common VPC (First)

Navigate to the directory where you define your VPC (e.g., `environments/dev/` if you directly deploy it there, or a dedicated `vpc` folder under `environments/`).

```bash
cd environments/dev # or wherever your VPC configuration resides
terraform init
terraform apply
```

This will create your VPC and store its state in the configured S3 bucket.

#### 4\. Create Resource Modules (e.g., `modules/ec2-instance/`)

Now, create modules for your other resources. These modules will *not* create a VPC but will expect VPC details as input.

**`modules/ec2-instance/main.tf`:**

```terraform
resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id       # Input from the common VPC
  vpc_security_group_ids = [var.security_group_id] # Input from the common VPC

  tags = {
    Name        = "${var.environment}-app-server"
    Environment = var.environment
  }
}
```

**`modules/ec2-instance/variables.tf`:**

```terraform
variable "ami_id" {
  description = "The AMI ID for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to deploy the EC2 instance into."
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group to associate with the EC2 instance."
  type        = string
}

variable "environment" {
  description = "The environment name."
  type        = string
}
```

#### 5\. Consume the Common VPC in Other Folders (Environments)

Now, in your environment-specific folders (e.g., `environments/dev/`), you'll use a `terraform_remote_state` data source to retrieve the VPC information.

**`environments/dev/main.tf`:**

```terraform
# Use the common VPC module
module "vpc" {
  source = "../../modules/vpc" # Adjust path based on your structure

  vpc_cidr_block    = "10.0.0.0/16"
  public_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
  azs                 = ["us-east-1a", "us-east-1b"]
  environment         = var.environment
}


# Example: Deploying an EC2 instance into the common VPC
module "app_server" {
  source = "../../modules/ec2-instance" # Adjust path

  ami_id          = "ami-0abcdef1234567890" # Replace with a valid AMI for your region
  instance_type   = "t2.micro"
  subnet_id       = module.vpc.public_subnet_ids[0] # Use the output from the VPC module
  security_group_id = module.vpc.default_security_group_id # Assuming you output this from VPC module
  environment     = var.environment
}

# Example: Deploying an RDS database (assuming you have an RDS module)
# module "rds_database" {
#   source = "../../modules/rds-database"
#   vpc_id = module.vpc.vpc_id
#   subnet_ids = module.vpc.private_subnet_ids # Assuming private subnets are also output
#   # ... other RDS specific variables
# }
```

**`environments/dev/variables.tf`:**

```terraform
variable "environment" {
  description = "The environment name (e.g., dev)."
  type        = string
  default     = "dev"
}
```

#### Explanation of Key Parts:

  * **`module "vpc"`:** This block in `environments/dev/main.tf` directly calls your `modules/vpc` to provision the VPC. This is good if the VPC is managed *per environment*. If you truly have *one common VPC* across all environments (e.g., a shared services VPC), then you would *not* have this `module "vpc"` block in `environments/dev/main.tf`. Instead, you would manage the "common VPC" in its own dedicated Terraform configuration and then use `terraform_remote_state` in `environments/dev/main.tf` to *read* its outputs. Let's refine for a truly *common* VPC:

### Refined Approach for a TRULY Common VPC

If you have a single VPC that multiple, independently managed resource sets will share, you'd structure it more like this:

**1. Dedicated VPC Configuration (e.g., `shared-vpc/main.tf`)**

This folder is solely responsible for the common VPC.

```
.
├── shared-vpc/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
└── modules/
    ├── ec2-instance/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
```

**`shared-vpc/main.tf` (similar to `modules/vpc/main.tf` but deployed independently):**

```terraform
# Define your backend for this specific VPC state
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "shared-vpc/terraform.tfstate" # Unique key for shared VPC
    region         = "us-east-1"
    dynamodb_table = "your-terraform-lock-table"
    encrypt        = true
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  # ... other VPC resources
  tags = {
    Name = "CommonSharedVPC"
  }
}

# Define outputs for the VPC that other configurations will need
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "default_security_group_id" {
  value = aws_vpc.main.default_security_group_id
}
```

**2. Deploy the Shared VPC:**

```bash
cd shared-vpc
terraform init
terraform apply
```

**3. Consume Shared VPC in Other Configurations (e.g., `environments/dev/main.tf`)**

Now, in your `environments/dev/main.tf` (and `environments/prod/main.tf`), you will use the `terraform_remote_state` data source to read the outputs from the `shared-vpc` configuration's state file.

**`environments/dev/main.tf`:**

```terraform
# Define backend for this environment's state
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "environments/dev/terraform.tfstate" # Unique key for dev environment
    region         = "us-east-1"
    dynamodb_table = "your-terraform-lock-table"
    encrypt        = true
  }
}

# Data source to read the shared VPC state
data "terraform_remote_state" "shared_vpc" {
  backend = "s3"
  config = {
    bucket = "your-terraform-state-bucket"
    key    = "shared-vpc/terraform.tfstate" # The key where the shared VPC state is stored
    region = "us-east-1"
  }
}

# Example: Deploying an EC2 instance into the shared VPC
module "app_server" {
  source = "../../modules/ec2-instance" # Adjust path

  ami_id          = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = data.terraform_remote_state.shared_vpc.outputs.public_subnet_ids[0] # Use output
  security_group_id = data.terraform_remote_state.shared_vpc.outputs.default_security_group_id # Use output
  environment     = var.environment
}
```

### Advantages of this approach:

  * **Clear Separation of Concerns:** The VPC is managed independently of the resources deployed within it.
  * **Reduced Blast Radius:** Changes to the VPC configuration are less likely to directly impact application deployments (unless the VPC itself is deleted or fundamentally altered).
  * **Reusability:** Resource modules (e.g., `ec2-instance`) are generic and can be used with any VPC, simply by providing the correct `vpc_id`, `subnet_id`, etc.
  * **Collaboration:** Different teams can manage different parts of the infrastructure without stepping on each other's toes, as long as they agree on the shared VPC outputs.
  * **Scalability:** Easily add new environments or resource types without modifying the core VPC configuration.

### Important Considerations:

  * **State Management:** Always use a remote backend for your Terraform state. S3 with DynamoDB for locking is a robust choice for AWS.
  * **IAM Permissions:** Ensure your Terraform execution role has the necessary IAM permissions to read from the remote state bucket and create/manage resources in your AWS account.
  * **Dependency Management:** While `terraform_remote_state` handles implicit dependencies, be mindful of the order of operations. The common VPC *must* be deployed and its state stored before other configurations can read from it.
  * **Security Groups:** Often, security groups are closely tied to the resources they protect. You might choose to define common, shared security groups within the VPC configuration and reference them, or define application-specific security groups within your resource modules.
  * **Terragrunt:** For more complex multi-environment and multi-account setups, consider using Terragrunt. It's a thin wrapper over Terraform that helps manage remote state, backend configurations, and working with modules more effectively, reducing boilerplate.

By following these principles, you can build a highly organized, maintainable, and scalable Terraform infrastructure.
