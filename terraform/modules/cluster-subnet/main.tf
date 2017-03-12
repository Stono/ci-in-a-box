resource "google_compute_subnetwork" "subnet" {
  name          = "${var.stack_name}-${var.env}-${var.target_region}"
  network       = "${var.network_name}"
  region        = "${var.target_region}"
  ip_cidr_range = "${var.ip_range}"
}
