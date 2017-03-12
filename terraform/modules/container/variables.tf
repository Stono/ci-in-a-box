variable "env" {
  description = "The environment you are creating the cluster for"
}

variable "ip_range" {
  description = "The ip range for the cluster subnet"
}

variable "container_cidr_range" {
  description = "The range for the network"
}

variable "cluster_username" {
  description = "The username for logging into kubernetes ui"
  default = "admin" 
}

variable "cluster_password" {
  description = "The password for logging into kubernetes ui"
}

variable "stack_name" {
  description = "The name of the stack"
}

variable "network_name" {
  description = "The name for the network"
}

variable "target_region" {
  description = "The project and compute target region"
}

variable "target_zone_a" {
  description = "HA Zone 1"
}

variable "target_zone_b" {
  description = "HA Zone 1"
}
