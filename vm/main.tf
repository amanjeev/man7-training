resource "tls_private_key" "rsa-key" {
  algorithm = "RSA"
}

data "google_compute_image" "image" {
  family  = "${var.vm-image-family}"
  project = "${var.vm-image-project}"
}

resource "random_string" "password" {
  length  = 16
  special = false
  lower   = false

  keepers {
    password = "${var.name}"
  }

  lifecycle {
    ignore_changes = ["length"]
  }
}

resource "google_compute_address" "instance" {
  name  = "${var.name}"
}

resource "google_compute_instance" "default" {
  name          = "${var.name}"
  machine_type  = "${var.machine-type}"
  zone          = "${var.zone}"

  allow_stopping_for_update = true

  metadata {
    sshKeys = "${var.common-user}:${tls_private_key.rsa-key.public_key_openssh}"
  }

  "boot_disk" {
    auto_delete   = true

    initialize_params {
      size  = "60"
      image = "${data.google_compute_image.image.self_link}"
    }
  }

  "network_interface" {
    subnetwork = "training"

    access_config { nat_ip = "${google_compute_address.instance.address}" }
  }

  connection {
    type        = "ssh"
    agent       = false
    user        = "${var.common-user}"
    private_key = "${tls_private_key.rsa-key.private_key_pem}"
    timeout     = "15m"
  }

  provisioner "file" { // send all config files needed
    destination = "/tmp/conf"
    source      = "${path.root}/conf"
  }

  provisioner "file" {
    destination = "/tmp/${var.name}.key"
    content     = "${tls_private_key.rsa-key.private_key_pem}"
  }

  provisioner "remote-exec" { // grub settings to enable serial console grub prompt
    inline = [
      "sudo cp /tmp/conf/grub.cfg /etc/default/grub.d/50-cloudimg-settings.cfg",
      "sudo update-grub",
    ]
  }

  provisioner "remote-exec" { // allow password authentication
    inline = [
      "sudo sed -i '/PasswordAuthentication no/c\\PasswordAuthentication yes' /etc/ssh/sshd_config",
      "sudo service ssh restart",
    ]
  }

  provisioner "remote-exec" { // setup user for password based login
    inline = [
      "sudo mkdir /home/${var.common-user}",
      "sudo useradd ${var.common-user}",
      "sudo chown -R ${var.common-user} /home/${var.common-user}",
      "sudo usermod -m -d /home/${var.common-user} ${var.common-user}",
      "sudo usermod -aG sudo ${var.common-user}",
      "sudo echo -e \"${random_string.password.result}\\n${random_string.password.result}\" | sudo passwd ${var.common-user}",
      "sudo usermod -s /bin/bash ${var.common-user}",
      "sudo cp /tmp/conf/.bashrc /home/${var.common-user}/.bashrc",
      "sudo cp /tmp/conf/.profile /home/${var.common-user}/.profile",
      "sudo cp /tmp/${var.name}.key /home/${var.common-user}/${var.name}.key"
    ]
  }

  provisioner "remote-exec" { // install updates and packages, check with Michael for more updates?
    inline = [
      "sudo apt update",
      "sudo apt -y upgrade",
      "sudo apt --assume-yes install emacs25 vim gcc make libseccomp-dev libcap-dev libacl1-dev libcap-ng-utils golang-go util-linux libncurses-dev libssl-dev libelf-dev git build-essential bison flex",
    ]
  }
}

output "outputs" {
  value = {
    access_serial_console           = "\nssh -i ${var.name}.key -p 9600 ${var.project-id}.${var.zone}.${var.name}.${var.common-user}@ssh-serialport.googleapis.com\n\n"
    ssh_with_key                    = "\nssh -i ${var.name}.key ${var.common-user}@${google_compute_instance.default.0.network_interface.0.access_config.0.nat_ip}\n\n"
    ssh                             = "\nssh ${var.common-user}@${google_compute_instance.default.0.network_interface.0.access_config.0.nat_ip}\n\n"
    password                        = "\n${random_string.password.result}\n\n"
    private_key_pem                 = "\n${tls_private_key.rsa-key.private_key_pem}\n"
  }
}
