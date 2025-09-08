#!/bin/bash

export AIRFLOW_HOME=$HOME/airflow
source $HOME/miniconda3/etc/profile.d/conda.sh
conda activate airflow_env
airflow webserver --pid $HOME/airflow/webserver.pid
