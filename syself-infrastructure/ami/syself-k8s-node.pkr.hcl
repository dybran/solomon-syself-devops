packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "args" {
  type = object({
    access_key = string
    secret_key = string

    region          = string
    ami_name_prefix = string
    instance_type   = string
    ami             = string
    ssh_username    = string
    tags            = map(string)
  })
}



locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "syself_ami" {
  ami_name      = "${var.args.ami_name_prefix}-${local.timestamp}"
  instance_type = var.args.instance_type
  region        = var.args.region
  source_ami    = var.args.ami
  ssh_username  = var.args.ssh_username
  tags          = var.args.tags
  access_key    = var.args.access_key
  secret_key    = var.args.secret_key
}

build {
  sources = ["source.amazon-ebs.syself_ami"]

  provisioner "shell" {
    script = "./scripts/install-tools.sh"
  }

  provisioner "shell" {
    script = "./scripts/memory-metrics.sh"
  }

}
