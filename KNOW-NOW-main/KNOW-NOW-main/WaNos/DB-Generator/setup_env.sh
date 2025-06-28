#!/bin/bash

# Path to the environment.yml file
ENV_YML="environment.yml"

# Extract the environment name from the environment.yml file
ENV_NAME=$(grep 'name:' "$ENV_YML" | cut -d ' ' -f 2)

# Function to find the Conda/Mamba command
find_conda_command() {
    # Try to find Conda
    if which conda > /dev/null; then
        echo "conda"
        return
    fi

    # Try to find Mamba
    if which mamba > /dev/null; then
        echo "mamba"
        return
    fi

    echo ""
}

# Determine which command to use (Conda or Mamba)
CONDA_CMD=$(find_conda_command)

# If neither Conda nor Mamba is found, exit
if [ -z "$CONDA_CMD" ]; then
    echo "Neither Conda nor Mamba is installed or in the PATH."
    exit 1
fi

# Determine the base path for Conda/Mamba environments
CONDA_BASE=$($CONDA_CMD info --base)

# Function to activate the environment
activate_env() {
    # Source the Conda/Mamba configuration
    source "$CONDA_BASE/etc/profile.d/conda.sh"

    # Activate the environment
    conda activate "$ENV_NAME"
    echo "Activated environment $ENV_NAME."
}

echo "${CONDA_BASE}"

# Function to check if a package is installed in the environment
check_package() {
    package=$1
    conda list -n "$ENV_NAME" | grep "^$package " > /dev/null
    if [ $? -ne 0 ]; then
        echo "Package $package is not installed in $ENV_NAME. Installing with pip..."
        pip install "$package"
    fi
}

# Check if the environment exists
conda env list | grep -q "$ENV_NAME"
ENV_EXISTS=$?

if [ $ENV_EXISTS -ne 0 ]; then
    echo "Environment $ENV_NAME does not exist. Creating it..."
    $CONDA_CMD env create -f "$ENV_YML"
fi

activate_env

ALL_PACKAGES_INSTALLED=true

if [ $ENV_EXISTS -eq 0 ]; then
    echo "Environment $ENV_NAME exists. Checking for installed packages..."

    # Parsing the environment.yml file
    while IFS= read -r line; do
        # Ignore lines with "name:", "channels:", "dependencies:", and "-" (dependencies listed under pip)
        if [[ $line != name:* && $line != channels:* && $line != dependencies:* && $line != \ \ -\ * ]]; then
            # Extract package name (and optionally version)
            package=$(echo $line | cut -d= -f1 | xargs)
            check_package "$package"
            if [ $? -ne 0 ]; then
                ALL_PACKAGES_INSTALLED=false
            fi
        fi
    done < "$ENV_YML"
fi

if $ALL_PACKAGES_INSTALLED; then
    echo "All packages are installed in $ENV_NAME."
else
    echo "Some packages might not have been installed properly."
fi