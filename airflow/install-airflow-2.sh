#!/bin/bash

# Update the sql_alchemy_conn line in airflow.cfg

airflow db migrate
pip install openmetadata-ingestion[all]==1.9.1
pip install openmetadata-managed-apis==1.9.1

echo "Creating airflow admin user"
read -p "Enter username: " username
read -p "Enter firstname: " firstname
read -p "Enter lastname: " lastname
read -p "Enter email: " email

airflow users create \
    --username ${username} \
    --firstname ${firstname} \
    --lastname ${lastname} \
    --role Admin \
    --email ${email}

sudo wget -P /etc/systemd/system/ https://raw.githubusercontent.com/FixingFox/om-iac/refs/heads/main/airflow/airflow-scheduler.service
sudo wget -P /etc/systemd/system/ https://raw.githubusercontent.com/FixingFox/om-iac/refs/heads/main/airflow/airflow-webserver.service

sudo systemctl daemon-reload
sudo systemctl enable airflow-scheduler.service
sudo systemctl enable airflow-webserver.service
sudo systemctl start airflow-scheduler.service
sudo systemctl start airflow-webserver.service

echo "Airflow configured successfully"
echo "You can access the Airflow webserver at http://<your-server-ip>:8080 with the username 'airflow_admin'. The password is the one you set during user creation."
echo "For status checks, use: sudo systemctl status airflow-scheduler.service and sudo systemctl status airflow-webserver.service"
echo "To view logs, use: journalctl -u airflow-scheduler.service and journalctl -u airflow-webserver.service"