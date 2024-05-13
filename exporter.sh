#!/bin/bash


#== Create a user for Node Exporter =====#
sudo useradd -M -r -s /bin/false node_exporter

#=== Download and extract the Node Exporter binary ===#
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xvfz node_exporter-1.5.0.linux-amd64.tar.gz

#=== Copy the Node Exporter binary to the appropriate location and set ownership ===#
sudo cp node_exporter-1.5.0.linux-amd64/node_exporter  /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

#=== Create a systemd unit file for Node Exporter ===#
#===== Define the Node Exporter service in the unit file ===#

sudo echo "[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target


[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter


[Install]
WantedBy=multi-user.target" >  /home/ubuntu/node_exporter.service
sudo mv /home/ubuntu/node_exporter.service /etc/systemd/system/ 



#==== Start and enable the node_exporter service ===#
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter