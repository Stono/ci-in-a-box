provider "google" {
  credentials = ""
  project      = "${var.gcp_project_name}"
  region       = "europe-west1"
}

resource "google_compute_disk" "gocd-master" {
  name  = "${var.stack_name}-gocd-master"
  type  = "pd-standard"
  zone  = "europe-west1-c"
  size  = "500"
}

resource "google_compute_disk" "gocd-master-config" {
  name  = "${var.stack_name}-gocd-master-config"
  type  = "pd-standard"
  zone  = "europe-west1-c"
  size  = "1"
}
