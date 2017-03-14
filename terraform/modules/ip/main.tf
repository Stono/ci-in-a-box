resource "google_compute_address" "root" {
  name   = "${var.stack_name}-${var.env}-root"
  region = "${var.target_region}"
}
