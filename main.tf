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
	user_data = "#cloud-config\n${jsonencode({
    package_update  = true
    package_upgrade = true
    packages = ["nginx"]
    })}"
    monitoring = false
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