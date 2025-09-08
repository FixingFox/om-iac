#!/bin/bash

cd $HOME

if type -p conda; then
    echo "Conda is already installed."
else
    echo "Installing conda"
    wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" -P downloads
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3
    $HOME/miniconda3/bin/conda tos accept
fi

# create conda environment
mkdir /home/auzreuser/airflow_env && cd $_
$HOME/miniconda3/bin/conda create -n airflow_env python=3.11 -y
$HOME/miniconda3/bin/conda init
exec bash --login

conda activate airflow_env

# Install Airflow 
pip install apache-airflow[postgres]==2.10.5
pip install psycopg2-binary
pip install sqlalchemy
pip install asyncpg

sudo apt-get install pkg-config python3-dev default-libmysqlclient-dev build-essential -y
sudo apt-get install libkrb5-dev -y

export AIRFLOW_HOME=/home/azureuser/airflow
touch $HOME/airflow/airflow.cfg
airflow config list --defaults > $HOME/airflow/airflow.cfg

# Update the sql_alchemy_conn line in airflow.cfg

#airflow db migrate
#pip install openmetadata-ingestion[all]==1.9.1
#pip install openmetadata-managed-apis==1.9.1
#
#airflow users create \
#    --username airflow_admin \
#    --firstname Gaute \
#    --lastname Tetlie \
#    --role Admin \
#    --email Gaute.tetlie@bouvet.no
#
#sudo wget -P /etc/systemd/system/ https://raw.githubusercontent.com/FixingFox/om-iac/refs/heads/main/airflow/airflow-scheduler.service
#sudo wget -P /etc/systemd/system/ https://raw.githubusercontent.com/FixingFox/om-iac/refs/heads/main/airflow/airflow-webserver.service
#
#sudo systemctl daemon-reload