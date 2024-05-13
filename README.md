# Prometheus-Security
#### After prometheus and exporter services was installed, and after config files in prometheus server and node exporter were configured, our main focus is to secure our metrics in exporter side to avoid any unwanted scraping.
## Using HTTPS to Secure our metrics

### Encryption
![image](https://github.com/MazenMoneim/Prometheus-Security/assets/135109542/c96a7c2a-1b81-4247-a6df-9f8018677f32)

* Certificates should be created first in node exporter<br>
`sudo openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout node_exporter.key -out node_exporter.crt -subj "/C=US/ST=California/L=Oakland/O=MyOrg/CN=localhost" -addext "subjectAltName = DNS:localhost"`<br>
* Create a folder in node_exporter in /etc<br>
`sudo mkdir /etc/node_exporter`<br>
* Move the generated keys to the above folder<br>
`sudo mv node_exporter.* /etc/node_exporter/`<br>
* Create a config.ymlfile with the below content in the same directory<br>
  `tls_server_config:<br>
      cert_file: node_exporter.crt<br>
      key_file: node_exporter.key`<br>
* Update the permission to the folder for the user node_exporter<br>
  `sudo chown -R node_exporter:node_exporter /etc/node_exporter`<br>
* Update the systemd service of node_exporter with TLS config as below<br>
`sudo vim /etc/systemd/system/node_exporter.service`<br>
* Reload the daemon and restart the node_exporter<br>
`sudo systemctl daemon-reload<br>
sudo systemctl restart node_exporter`<br>
* Now we need to update Prometheus conf to get metrics from nodes with HTTPS endpoints<br>
* Copy the `node_exporter.crt` file from the node exporter server to the Prometheus server at `/etc/prometheus`<br>
* Update the permission to the CRT file<br>
`sudo chown prometheus:prometheus node_exporter.crt`<br>
* Update the config at a specific target with scheme, tls changes in Prometheus configuration

### Authentication
![image](https://github.com/MazenMoneim/Prometheus-Security/assets/135109542/8f8f6c50-d7cd-4c66-a08a-473a79034f60)
* Run the below command to create hash, which will prompt for a password<br>
`sudo apt-get update && sudo apt install apache2-utils -y`<br>
`htpasswd -nBC 12 "" | tr -d ':\n'`<br>
* Go back to your node exporter server, and update the config.yml file at /etc/node_exporter<br>
* Restart the node_exporter<br>
`sudo systemctl restart node_exporter`<br>
* we need to update Prometheus conf with username and password at prometheus.yml file with basic_auth in specific job<br>
* Update the same as above in the Prometheus YAML file and restart the Prometheus server<br>
`sudo systemctl restart prometheus`


