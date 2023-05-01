variable "account_name" {
  description = "Name of the Aws account"
  type        = string
}

variable "product_name" {
  description = "Name of the Product"
  type        = string
}

variable "provisioning_artifact_name" {
  description = "Name of the provisioning artifact name"
  type        = string
}

variable "managed_organisational_unit" {
    description = "Managed Organisational Unit"
    type = string
}
variable "sso_user_email" {
    description = "SSO User Email"
    type = string
}
variable "sso_user_firstname" {
    description = "SSO User First Name"
    type = string
}
variable "sso_user_lastname" {
    description = "SSO User Last Name"
    type = string
}

variable "tags" {
  type = map(string)
}

