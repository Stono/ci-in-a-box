provider "google" {
  credentials = ""
  project      = "${var.gcp_project_name}"
  region       = "${var.target_region}"
}

resource "google_compute_address" "gocd" {
  name   = "${var.stack_name}-gocd"
  region = "${var.target_region}"
}

resource "google_compute_address" "preprod" {
  name   = "${var.stack_name}-preprod"
  region = "${var.target_region}"
}

module "container" {
  source = "../modules/container"
  env = "preprod"
  ip_range = "10.34.96.0/24"
  container_cidr_range = "10.37.64.0/19"
  cluster_password = "${var.preprod_cluster_password}"
  network_name = "${var.network_name}"
  stack_name = "${var.stack_name}"
  target_region = "${var.target_region}"
  target_zone_a = "${var.target_zone_a}"
  target_zone_b = "${var.target_zone_b}"
}
