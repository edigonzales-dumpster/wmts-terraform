provider "digitalocean" {}

resource "digitalocean_droplet" "wmts" {
    name  = "wmts"
    #image = "ubuntu-18-04-x64"
    image = "docker-18-04"
    region = "fra1"
    size   = "s-1vcpu-1gb"
    ssh_keys = [25503420,24397269]
	user_data = "${user-data.yml}"
}
