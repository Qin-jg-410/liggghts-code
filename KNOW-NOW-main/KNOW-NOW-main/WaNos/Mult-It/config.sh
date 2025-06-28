#!/bin/bash

# read the values of source and conda keys from the YAML file
# source_path=$(grep -Po '(?<=source": ")[^"]*' conda_env.yml)
# conda_activate=$(grep -Po '(?<=conda": ")[^"]*' conda_env.yml)

# execute the command using the extracted values
source /home/mieller/mambaforge/etc/profile.d/conda.sh
conda activate

python var_generator.py
