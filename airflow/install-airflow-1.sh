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
mkdir $HOME/airflow_env && cd $_
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

echo "Airflow installed successfully"
echo "Remember to configure the airflow.cfg file with the correct database connection string. before continuing."
echo "Once complete, run the install-openmetadata-2.sh script to finish the setup."