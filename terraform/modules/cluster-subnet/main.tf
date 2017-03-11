resource "google_compute_subnetwork" "subnet_europe" {
  name          = "${var.stack_name}-${var.env}-eu-west"
  network       = "${var.network_name}"
  region        = "europe-west1"
  ip_cidr_range = "${var.ip_range}"
}
