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

