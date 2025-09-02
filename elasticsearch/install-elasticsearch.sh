#!/bin/bash

# Install java version 21

if type -p java; then
    echo "Java is already installed."
else
    echo "Installing Java 21..."
    sudo apt update
    sudo apt install -y openjdk-21-jdk
fi

# Install Elasticsearch
# Config at /etc/elasticsearch/elasticsearch.yml
if type -p elasticsearch-node; then
    echo "Elasticsearch is already installed. Starting service..."
    sudo systemctl start elasticsearch.service
else
    echo "Installing Elasticsearch..."
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    sudo apt-get install apt-transport-https
    echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
    sudo apt update
    sudo apt install -y elasticsearch=8.11.4
    sudo systemctl daemon-reload
    sudo systemctl enable elasticsearch.service
    sudo systemctl start elasticsearch.service
fi

echo "Elasticsearch installation and startup complete."
echo "You can check the status of the Elasticsearch service with: sudo systemctl status elasticsearch.service"
echo "Elasticsearch logs can be found at: /var/log/elasticsearch/"
echo "Elasticsearch configuration file is located at: /etc/elasticsearch/elasticsearch.yml"
echo "Remeber to change elastisearch default password."
