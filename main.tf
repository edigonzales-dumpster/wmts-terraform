variable "environment" {
}

variable "floating_ip" {
}

variable "subdomain" {
}

provider "digitalocean" {}

resource "digitalocean_droplet" "wmts" {
    name  = "wmts-${var.environment}"
    image = "docker-18-04"
    region = "fra1"
    #size = "s-3vcpu-1gb"
    size = "s-2vcpu-4gb"
    ssh_keys = [25503420,24397269]
	#user_data = "${file("./user-data.yml")}"
	user_data = << EOF
		#! /bin/bash
        sudo apt-get update
		sudo apt-get install -y apache2
		sudo systemctl start apache2
		sudo systemctl enable apache2
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
	EOF
    monitoring = true
    backups = false
}

resource "digitalocean_project" "wmts" {
    name        = "WMTS-${var.environment}"
    description = "WMTS"
    purpose     = "Web Application"
    resources   = [digitalocean_droplet.wmts.urn]
}

#resource "digitalocean_floating_ip_assignment" "wmts" {
#    ip_address = "${var.floating_ip}"
#    droplet_id = digitalocean_droplet.wmts.id
#}