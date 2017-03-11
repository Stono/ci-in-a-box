variable "gcp_project_name" {
  description = "The project name on GCP"
}

variable "network_name" {
  description = "The name for the network"
}

variable "stack_name" {
  description = "The stack name, used in prefixing"
}

variable "network_range" {
  description = "The maximum range of allocatable IPs for this network.  These are broken into /24 for each cluster subnet" 
  default = "10.34.96.0/19"
}

variable "preprod_container_cidr_range" {
  description = "The range for the PreProd kubernetes pods" 
  default = "10.37.64.0/19"
}

variable "prod_container_cidr_range" {
  description = "The range for the Prod kubernetes pods" 
  default = "10.35.96.0/19"
}
