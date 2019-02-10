// Where to save the state
// backend config cannot contain interpolations so have to hardcode
terraform {
  backend "gcs" {
    bucket      = "man7-training"
    credentials = "./credentials/key.json"
    prefix      = "terraform/state"
  }
}