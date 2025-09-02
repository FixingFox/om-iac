#!/bin/bash

export AIRFLOW_HOME=/home/azureuser/airflow
source $HOME/miniconda3/etc/profile.d/conda.sh
conda activate airflow_env
airflow scheduler --pid $HOME/airflow/scheduler.pid
