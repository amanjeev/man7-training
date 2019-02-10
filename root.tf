// enable serial port at project level
module "serial-port-metadata" {
  source = "./project"
}


// Add a new module for each VM, with a unique name
module "tux-01" {
  name        = "training-vm-tux-01"
  source      = "./vm"
  project-id  = "${var.project-id}"
  zone        = "${var.zone}"
  region      = "${var.region}"
}


// all the outputs, add a line for each VM module you add above
output "provision" {
  value = {
    "tux-01" = "${module.tux-01.outputs}"
  }
}

