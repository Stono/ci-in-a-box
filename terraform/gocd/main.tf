provider "google" {
  credentials = ""
  project      = "${var.gcp_project_name}"
  region       = "${var.target_region}"
}

resource "google_compute_disk" "gocd-master" {
  name  = "${var.stack_name}-gocd-master"
  type  = "pd-standard"
  zone  = "${var.target_zone_a}"
  size  = "500"
}

resource "google_compute_disk" "gocd-master-config" {
  name  = "${var.stack_name}-gocd-master-config"
  type  = "pd-standard"
  zone  = "${var.target_zone_a}"
  size  = "1"
}

resource "google_compute_address" "gocd" {
  name   = "${var.stack_name}-gocd"
  region = "${var.target_region}"
}
