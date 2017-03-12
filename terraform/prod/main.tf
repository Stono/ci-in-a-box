provider "google" {
  credentials = ""
  project      = "${var.gcp_project_name}"
  region       = "${var.target_region}"
}

resource "google_compute_address" "prod" {
  name   = "${var.stack_name}-prod"
  region = "${var.target_region}"
}

module "container" {
  source = "../modules/container"
  env = "prod"
  ip_range = "10.34.97.0/24"
  container_cidr_range = "10.35.96.0/19"
  cluster_password = "${var.prod_cluster_password}"
  network_name = "${var.network_name}"
  stack_name = "${var.stack_name}"
  target_region = "${var.target_region}"
  target_zone_a = "${var.target_zone_a}"
  target_zone_b = "${var.target_zone_b}"
}
