provider "digitalocean" {}

resource "digitalocean_droplet" "wmts" {
    name  = "wmts"
    #image = "ubuntu-18-04-x64"
    image = "docker-18-04"
    region = "fra1"
    size   = "s-1vcpu-1gb"
    ssh_keys = [25503420,24397269]
	user_data = << EOF
		#! /bin/bash
                sudo apt-get update
		sudo apt-get install -y apache2
		sudo systemctl start apache2
		sudo systemctl enable apache2
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
	EOF
}
