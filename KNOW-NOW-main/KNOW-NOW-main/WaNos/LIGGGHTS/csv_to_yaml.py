import csv
import yaml
import tarfile
import os
import shutil

def tar_and_delete_folder(folder_name):
    """
    Tar a folder located in the current directory and then delete the original folder.

    Args:
    folder_name (str): Name of the folder to be tarred and deleted.

    Returns:
    bool: True if operation is successful, False otherwise.
    """

    # Check if the folder exists
    if not os.path.exists(folder_name):
        print(f"Folder '{folder_name}' does not exist.")
        return False

    # Tar the folder
    try:
        with tarfile.open(f"{folder_name}.tar.gz", "w:gz") as tar:
            tar.add(folder_name)
    except Exception as e:
        print(f"Error occurred while tarring the folder: {e}")
        return False

    # Delete the original folder
    try:
        shutil.rmtree(folder_name)
    except Exception as e:
        print(f"Error occurred while deleting the folder: {e}")
        return False

    return True

def csv_to_yaml(csv_file_path, yaml_file_path):
    with open(csv_file_path, mode='r', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        
        # Initialize a dictionary to store the data
        data = {column: [] for column in reader.fieldnames}

        # Populate the dictionary with data from the CSV
        for row in reader:
            for column in reader.fieldnames:
                try:
                    # Convert the value to float and append
                    data[column].append(float(row[column]))
                except ValueError:
                    # Handle the case where conversion to float is not possible
                    print(f"Warning: Cannot convert value '{row[column]}' in column '{column}' to float. Skipping this value.")
                    continue
    
    with open('rendered_wano.yml') as file:
        wano_file = yaml.full_load(file)
    
    # Get the current working directory
    current_path = os.getcwd()
    # Extract only the name of the current folder
    folder_name = os.path.basename(current_path)
    wano_file["id_folder"] = folder_name

    wano_file = {**wano_file, **data}

    with open(yaml_file_path, 'w', encoding='utf-8') as yamlfile:
        # Writing to the YAML file
        yaml.dump(wano_file, yamlfile, allow_unicode=True)


# Example usage
csv_file = 'forces.csv'  # Replace with your CSV file path
yaml_file = 'forces_inputs.yml'  # The output YAML file path
csv_to_yaml(csv_file, yaml_file)

folder = "vtk"
tar_and_delete_folder(folder)
#tar_folder(folder, f'{folder}.tar.gz')