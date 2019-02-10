# Terraform

This repository sets up Virtual Machines in Google Cloud Platform for man7.org training. This terraform module will output 

1. Private key (RSA PEM encoded) for the user account (default username `tux`).
2. Password for the user account (default username `tux`).
3. SSH commands via key and password.
4. SSH command to access Serial Console. This is needed to access GRUB menu or debug VM at boot time if needed.
5. Saves the Terraform state file in a bucket in your project.
6. A wrapper shell script `./tf.sh` which automatically downloads Terraform binary and sets up your environment etc.
7. Updates GRUB config for the machine.
8. Installs all the relevant tools (Ubuntu only).

## Setup

1. Create a new project in GCP or use an existing one. Note down the Project ID and update the variable `project-id` in `./variables.tf`. You may need to enable Compute Engine API if you are creating a new project.
2. Create a bucket with a unique name and update `backend.tf` variable `bucket`. This is because backend definition does not allow interpolation. :(
3. Create a service account with `Editor` and `Owner` permissions for Terraform. Default name for the account is `terraform`.
4. Create a key pair for the above service account and save it in `./credentials/key.json`. 
5. Also, save the key inside the heredoc in `./credentials/secret.auto.tfvars` by pasting the JSON document between the `EOF`s heredoc.

## GRUB menu access

Use the private RSA key and the serial console command to SSH into serial console in a separate terminal window.

Rebooting Virtual Machine and immediately switching to the serial console and pressiing SHIFT key will get you GRUB menu.

## Before the 1st use
```bash
$ ./tf.sh init
```

## Commands

### Graph

```bash
$ ./tf.sh graph | dot -Tpng > graph.png
```

### Plan

```bash
$ /tf.sh plan
```

### Apply

```bash
$ ./tf.sh apply
```

