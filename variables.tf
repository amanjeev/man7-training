variable "training-key" {}

variable "project-id"   { type = "string" description = "GCP Project ID"            default = "" }
variable "region"       { type = "string" description = "Region for the VMs"        default = "us-east4" }
variable "zone"         { type = "string" description = "Availability zone for VMs" default = "us-east4-a" }
