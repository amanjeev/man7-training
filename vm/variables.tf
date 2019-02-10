variable "project-id"       { type = "string" description = "GCP Project ID"            }
variable "region"           { type = "string" description = "Region for the VMs"        }
variable "zone"             { type = "string" description = "Availability zone for VMs" }

variable "name"             { type = "string" description = "Name prefix for VMs"       default = "training" }
variable "vm-image-family"  { type = "string" description = "GCP Image Family"          default = "ubuntu-minimal-1810" }
variable "vm-image-project" { type = "string" description = "GCP Image Project"         default = "ubuntu-os-cloud" }
variable "machine-type"     { type = "string" description = "Class of VM"               default = "n1-standard-4" }

variable "common-user"      { type = "string" description = "Username for training"     default = "tux" }