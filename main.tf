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
      - mkdir --mode=0777 /tiles
      - openssl req -extensions v3_req -newkey rsa:2048 -nodes -keyout server.key -subj '/C=CH/ST=Solothurn/L=Solothurn/O=AGI/OU=SOGIS/CN=wmts-t.sogeo.services' -out server.csr
      - openssl x509 -req -extfile <(printf "subjectAltName=DNS:wmts-t.sogeo.services\nextendedKeyUsage=serverAuth,clientAuth") -days 365 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt
      - usermod -aG docker appuser      
      - chown -R appuser:appuser /certs
      - chown -R appuser:appuser /tiles
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