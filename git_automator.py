import subprocess
import os

def run_git_command(command, cwd=None):
    """
    运行 Git 命令并处理其输出。
    """
    try:
        # 使用 check=True 确保如果命令返回非零退出码，会抛出 CalledProcessError
        # capture_output=True 捕获标准输出和标准错误
        # text=True 解码输出为文本
        result = subprocess.run(command, cwd=cwd, check=True, capture_output=True, text=True, shell=True)
        print(f"✅ 成功执行: {' '.join(command)}")
        if result.stdout:
            print("--- Git 输出 ---")
            print(result.stdout)
            print("-----------------")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Git 命令执行失败: {' '.join(command)}")
        print(f"错误码: {e.returncode}")
        print(f"标准输出:\n{e.stdout}")
        print(f"标准错误:\n{e.stderr}")
        return False
    except FileNotFoundError:
        print(f"❌ 错误: Git 命令未找到。请确保 Git 已安装并添加到 PATH。")
        return False

def automate_git_workflow(repo_path, commit_message="Automated commit from Python script"):
    """
    自动化 Git pull, add, commit, push 工作流。

    Args:
        repo_path (str): 本地 Git 仓库的路径。
        commit_message (str): 提交信息。
    """
    if not os.path.isdir(os.path.join(repo_path, '.git')):
        print(f"错误: '{repo_path}' 不是一个有效的 Git 仓库。请提供正确的路径。")
        return

    print(f"🚀 开始自动化 Git 工作流在: {repo_path}")

    # 1. 设置安全目录 (如果之前遇到过所有权问题)
    # 这一步只需执行一次，为了避免重复添加，我们先检查
    print("--- 检查并设置 Git 安全目录 ---")
    safe_dir_command = ["git", "config", "--global", "--add", "safe.directory", repo_path]
    # 我们不严格要求这一步必须成功，因为可能已经设置了
    subprocess.run(safe_dir_command, shell=True, capture_output=True, text=True)
    print("----------------------------")

    # 2. 拉取最新更改
    print("\n--- 步骤 1: 拉取远程更改 ---")
    if not run_git_command(["git", "pull", "origin", "main"], cwd=repo_path):
        print("停止: 拉取失败，请检查网络连接或分支配置。")
        return

    # 3. 添加所有更改 (包括新增和修改的文件)
    print("\n--- 步骤 2: 添加所有文件到暂存区 ---")
    if not run_git_command(["git", "add", "."], cwd=repo_path):
        print("停止: 添加文件失败。")
        return

    # 4. 提交更改
    print("\n--- 步骤 3: 提交更改 ---")
    # 检查是否有需要提交的更改
    status_result = subprocess.run(["git", "status", "--porcelain"], cwd=repo_path, capture_output=True, text=True, shell=True)
    if not status_result.stdout.strip():
        print("ℹ️ 没有检测到需要提交的更改。跳过提交步骤。")
    else:
        if not run_git_command(["git", "commit", "-m", commit_message], cwd=repo_path):
            print("停止: 提交失败。")
            return

    # 5. 推送更改
    print("\n--- 步骤 4: 推送更改到远程仓库 ---")
    if not run_git_command(["git", "push", "origin", "main"], cwd=repo_path):
        print("停止: 推送失败，请检查你的凭据或权限。")
        return

    print("\n✅ Git 工作流自动化完成！")

# --- 使用示例 ---
if __name__ == "__main__":
    # !!! 请将这里替换为你的实际 Git 仓库路径 !!!
    your_repo_path = "F:/liggghts-code"
    
    # 你可以自定义提交信息
    your_commit_message = "Update files via Python script"

    automate_git_workflow(your_repo_path, your_commit_message)