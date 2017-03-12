variable "env" {
  description = "The environment you are creating the cluster for"
}

variable "network_name" {
  description = "The network name to place the cluster subnet in"
}

variable "stack_name" {
  description = "The name of the stack"
}

variable "ip_range" {
  description = "The ip range for the cluster subnet"
}

variable "target_region" {
  description = "The project and compute target region"
}
