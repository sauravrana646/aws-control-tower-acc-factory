provider "aws" {
  profile = "dumdum"
  region = "us-east-1"
}

locals{
    parameters = [
    {
    key   = "AccountEmail"
    value = "test-member-${var.account_name}@gmail.com"
    },
    {
    key   = "AccountName"
    value = var.account_name
    },
    {
    key   = "ManagedOrganizationalUnit"
    value = var.managed_organisational_unit
    },
    {
    key   = "SSOUserEmail"
    value = var.sso_user_email
    },
    {
    key   = "SSOUserFirstName"
    value = var.sso_user_firstname
    },
    {
    key   = "SSOUserLastName"
    value = var.sso_user_lastname
    }
    ]
}


resource "aws_servicecatalog_provisioned_product" "account" {
  name                       = var.account_name
  product_name               = var.product_name
  provisioning_artifact_name = var.provisioning_artifact_name

  dynamic "provisioning_parameters" {
    for_each = local.parameters
    content {
      key   = provisioning_parameters.value.key
      value = provisioning_parameters.value.value
    }
  }

  tags = var.tags
}

data aws_caller_identity "current" {}
data "aws_organizations_organization" "current" {}

resource "aws_iam_role" "s3_role" {
  name = "s3-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action    = "sts:AssumeRole"
        # Condition = {
        #   StringEquals = {
        #     "aws:PrincipalArn": "arn:aws:organizations::${data.aws_organizations_organization.current.id}:root/${[for item in aws_servicecatalog_provisioned_product.account.outputs : item.value if item.key == "AccountId"][0]}"
        #   }
        # }
      }
    ]
  })
  inline_policy {
    name = "s3_test"
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = "*"
      }
    ]
  })
}
}


provider "aws" {
  alias = "member"
  region = "us-east-1"
  profile = "dumdum"
  assume_role {
    role_arn = "arn:aws:iam::854611383816:role/OrganizationAccountAccessRole"
  }
}

# resource "aws_s3_bucket" "example_bucket" {

#   provider = aws.member
#   bucket = "example-bucket-123fsf"
#   timeouts {
#     create = "2m"
#   }
# }

resource "aws_vpc" "main" {
  provider = aws.member
  cidr_block = "10.100.0.0/16"
}
  