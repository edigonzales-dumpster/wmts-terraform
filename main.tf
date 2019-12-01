variable "environment" {
}

provider "digitalocean" {}

resource "digitalocean_droplet" "wmts" {
    name  = "wmts-${var.environment}"
    #image = "ubuntu-18-04-x64"
    image = "docker-18-04"
    region = "fra1"
    #size   = "s-1vcpu-1gb"
    size   = "s-3vcpu-1gb"
    ssh_keys = [25503420,24397269]
	user_data = "${file("./user-data.yml")}"
    monitoring = true
}

resource "digitalocean_project" "playground" {
  name        = "WMTS-${var.environment}"
  description = "WMTS"
  purpose     = "Web Application"
  #environment = "Development"
  resources   = [digitalocean_droplet.wmts.urn]
}
