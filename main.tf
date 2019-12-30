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
	user_data = <<-EOF
    #cloud-config
    users:
      - name: appuser
        shell: /bin/bash
    package_upgrade: false
    runcmd:
      - apt update
      - mkdir --mode=0777 /pgdata
      - mkdir /certs
      - mkdir --mode=0777 /tiles
      - usermod -aG docker appuser
      - openssl genrsa -out /certs/ca.key 2048
      - openssl req -extensions v3_req -new -x509 -days 365 -key /certs/ca.key -subj '/C=CH/ST=Solothurn/L=Solothurn/O=AGI/OU=SOGIS/CN=${var.subdomain}-t.sogeo.services' -out /certs/ca.crt
      - openssl req -extensions v3_req -newkey rsa:2048 -nodes -keyout /certs/server.key -subj '/C=CH/ST=Solothurn/L=Solothurn/O=AGI/OU=SOGIS/CN=${var.subdomain}-t.sogeo.services' -out /certs/server.csr
      - echo "subjectAltName=DNS:${var.subdomain}-t.sogeo.services\nextendedKeyUsage=serverAuth,clientAuth" > /certs/config.file
      - openssl x509 -req -extfile /certs/config.file -days 365 -in /certs/server.csr -CA /certs/ca.crt -CAkey /certs/ca.key -CAcreateserial -out /certs/server.crt
      - usermod -aG docker appuser      
      - chown -R appuser:appuser /certs
      - chown -R appuser:appuser /tiles
      - su - appuser -c "docker swarm init --advertise-addr $(hostname -I | awk '{print $1}')"
      - su - appuser -c "docker volume create portainer_data" 
      - su - appuser -c "docker run -d -p 9443:9000 -p 8000:8000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v /certs:/certs -v portainer_data:/data portainer/portainer --ssl --sslcert /certs/server.crt --sslkey /certs/server.key"
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