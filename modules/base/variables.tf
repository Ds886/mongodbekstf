variable "cidr_subnet_public" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.12.1.0/24", "10.12.2.0/24", "10.12.3.0/24"]
}

variable "cidr_subnet_private" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.12.4.0/24", "10.12.5.0/24", "10.12.6.0/24"]
}
