// serial port needs to be enabled for GRUB prompt
resource "google_compute_project_metadata_item" "default" {
  key   = "serial-port-enable"
  value = "yes"
}
