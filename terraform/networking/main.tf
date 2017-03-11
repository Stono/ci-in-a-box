provider "google" {
  credentials = ""
  project      = "${var.gcp_project_name}"
  region       = "europe-west1"
}

resource "google_compute_network" "network" {
  name       = "${var.network_name}"
}

resource "google_compute_firewall" "standard-ports" {
  name    = "${var.stack_name}-standard-ports"
  network = "${google_compute_network.network.name}"

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "web-ports" {
  name    = "${var.stack_name}-web-ports"
  network = "${google_compute_network.network.name}"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_tags = ["http-server", "https-server"]
}


resource "google_compute_address" "gocd" {
  name   = "${var.stack_name}-gocd"
  region = "europe-west1"
}

resource "google_compute_address" "preprod" {
  name   = "${var.stack_name}-preprod"
  region = "europe-west1"
}

resource "google_compute_address" "prod" {
  name   = "${var.stack_name}-prod"
  region = "europe-west1"
}
