#!/bin/bash

# execute the command using the extracted values
#bash setup_env.sh

source ./setup_env.sh

python db_generator.py
python git_push.py