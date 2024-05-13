#!/bin/bash

#====== First, update your package list to ensure you access the most recent versions available =====#
sudo apt update

#==========  install the Prometheus package ======#
sudo apt install prometheus prometheus-node-exporter prometheus-pushgateway prometheus-alertmanager -y

#==== Enable Prometheus to start on boot and start the service ============#
sudo systemctl enable --now prometheus

#-----> You can also access Prometheus in a browser using the server’s IP address:
#-----> http://<PROMETHEUS_SERVER_IP>:9090

sudo hostnamectl hostname prometheus