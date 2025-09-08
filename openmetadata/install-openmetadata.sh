#!/bin/bash

# Install PostgreSQL

if command -v psql &> /dev/null; then
    echo "PostgreSQL (psql) is already installed."
else
    echo "Installing PostgreSQL (psql)"
    sudo apt install postgresql -y

    read -p "Enter om_db_user password: " om_db_user_password
    sudo -u postgres -H -- psql -c "CREATE USER openmetadata_user WITH PASSWORD '$om_db_user_password';"
    sudo -u postgres -H -- psql -c "CREATE DATABASE openmetadata_db OWNER openmetadata_user;"
    sudo -u postgres -H -- psql -c "GRANT ALL PRIVILEGES ON DATABASE openmetadata_db TO openmetadata_user;"

    read -p "Enter airflow_db_user password: " airflow_db_user_password
    sudo -u postgres -H -- psql -c "CREATE USER airflow_user WITH PASSWORD '$airflow_db_user_password';"
    sudo -u postgres -H -- psql -c "CREATE DATABASE airflow_db OWNER airflow_user;"
    sudo -u postgres -H -- psql -c "GRANT ALL PRIVILEGES ON DATABASE airflow_db TO airflow_user;"
fi

sudo systemctl enable postgresql
sudo systemctl start postgresql

# Install OpenMetadata
mkdir downloads
wget "https://github.com/open-metadata/OpenMetadata/releases/download/1.9.1-release/openmetadata-1.9.1.tar.gz" -P downloads
mkdir openmetadata
tar -zxvf downloads/openmetadata-*.tar.gz -C openmetadata

sudo wget "https://raw.githubusercontent.com/FixingFox/om-iac/refs/heads/main/openmetadata/openmetadata.service" -P /etc/systemd/system
sudo systemctl daemon-reload

echo "OpenMetadata installation complete."
echo "Remember to configure OpenMetadata by editing the configuration file located at: openmetadata-*/conf/openmetadata.yaml"
echo "Ensure that the database and elasticsearch settings are correctly set in the configuration file."
echo "Once configured, you can migrate the database schema with: ./bootstrap/openmetadata-ops.sh drop-create"
echo "You can start OpenMetadata with: sudo systemctl start openmetadata.service"
echo "You can check the status of OpenMetadata with: sudo systemctl status openmetadata.service"

