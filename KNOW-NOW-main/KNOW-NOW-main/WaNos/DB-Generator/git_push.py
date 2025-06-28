
import subprocess
import os, yaml

def manage_github_repo(repo_url, file_path, git_token, user_email, user_name):
    """
    Clones the repo, checks git configuration, adds the .yml file, pushes the changes, and deletes the cloned repo.
    
    :param repo_url: HTTPS URL of the GitHub repository.
    :param file_path: Path to the .yml file to be added.
    :param git_token: Git token for authentication.
    :param user_email: User's email for git configuration.
    :param user_name: User's name for git configuration.
    """
    try:
        # Clone the repo
        repo_name = repo_url.split('/')[-1].replace('.git', '')
        subprocess.run(f'git clone {repo_url}', check=True, shell=True)

        # Change working directory to the cloned repo
        os.chdir(repo_name)

        # Check and set Git configuration if needed
        git_email = subprocess.run('git config --global user.email', capture_output=True, text=True, shell=True).stdout.strip()
        git_name = subprocess.run('git config --global user.name', capture_output=True, text=True, shell=True).stdout.strip()

        if git_email != user_email:
            subprocess.run(f'git config --global user.email "{user_email}"', shell=True, check=True)

        if git_name != user_name:
            subprocess.run(f'git config --global user.name "{user_name}"', shell=True, check=True)

        # Copy the .yml file to the repo
        subprocess.run(f'cp ../{file_path} .', shell=True, check=True)

        # Add, commit, and push the file
        subprocess.run('git add -A', shell=True, check=True)
        subprocess.run('git commit -m "Add .yml file"', shell=True, check=True)
        subprocess.run(f'git push https://{git_token}@{repo_url[8:]}', shell=True, check=True)

    except subprocess.CalledProcessError as e:
        print(f"An error occurred: {e}")
    finally:
        # Change back to the original directory and delete the cloned repo
        os.chdir('..')
        subprocess.run(f'rm -rf {repo_name}', shell=True, check=True)

if __name__ == '__main__':
    
    with open('rendered_wano.yml') as file:
        wano_file = yaml.full_load(file)
    
    if wano_file["GitHub-push"]:
        
        with open('git_file.yml') as file:
            git_file = yaml.full_load(file)

        file_path = f"{wano_file['DB-Name']}.yml"

        repo_url = git_file["repo_url"] 
        git_token = git_file["git_token"] 
        user_email = git_file["user_email"] 
        user_name = git_file["user_name"]

        # Usage example 
        manage_github_repo(repo_url, file_path, git_token, user_email, user_name)