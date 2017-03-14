variable "prod_cluster_password" {
  description = "The password for logging into kubernetes ui"
}

variable "target_region" {
  description = "The project and compute target region"
}

variable "gcp_project_name" {
  description = "The project name on GCP"
}

variable "stack_name" {
  description = "The name of the stack"
}

variable "network_name" {
  description = "The name for the network"
}

variable "target_zone_a" {
  description = "HA Zone 1"
}

variable "target_zone_b" {
  description = "HA Zone 1"
}
