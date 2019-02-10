variable "network-name" { type = "string" default = "training" }

resource "google_compute_network" "training" {
  name = "${var.network-name}"
}

resource "google_compute_subnetwork" "training-subnetwork" {
  name          = "${var.network-name}-subnetwork"
  region        = "${var.region}"
  project       = "${var.project-id}"
  network       = "${google_compute_network.training.self_link}"
  ip_cidr_range = "10.0.0.0/24"
}

resource "google_compute_firewall" "default" {
  name    = "ssh"
  network = "${google_compute_network.training.name}"

  allow {
    protocol  = "tcp"
    ports     = ["22", "80", "443"]
  }
}