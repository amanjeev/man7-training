provider "google" {
  project     = "${var.project-id}"
  zone        = "${var.zone}"
  credentials = "${var.training-key}"
}

provider "random" {}