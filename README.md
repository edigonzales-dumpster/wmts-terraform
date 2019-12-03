# wmts-terraform

## Digitalocean API
Get list of ssh keys:
```
curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" "https://api.digitalocean.com/v2/account/keys" > ssh.json
```

Get list of images:
```
curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" "https://api.digitalocean.com/v2/images?type=distribution" > images.json
```
(How to get marketplace images?)

Get list of sizes:
```
curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" "https://api.digitalocean.com/v2/sizes" 
````






docker run -d -p 9443:9000 -p 8000:8000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v /certs:/certs -v portainer_data:/data portainer/portainer --ssl --sslcert /certs/portainer.crt --sslkey /certs/portainer.key


openssl genrsa -out /certs/portainer.key 2048
openssl ecparam -genkey -name secp384r1 -out /certs/portainer.key
openssl req -nodes -newkey rsa:2048 -keyout /certs/portainer.key -out /certs/portainer.crt -subj "/C=CH/ST=Solothurn/L=Solothurn/O=AGI/OU=SOGIS/CN=ssl.sogeo.services"
