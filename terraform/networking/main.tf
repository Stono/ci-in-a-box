provider "google" {
  credentials = ""
  project      = "${var.gcp_project_name}"
  region       = "${var.target_region}"
}

resource "google_compute_network" "network" {
  name       = "${var.network_name}"
}
