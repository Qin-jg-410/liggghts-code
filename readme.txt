#本地同步到云端
cd x:/liggghts-code
git config --global core.autocrlf false		#希望 Git 不自动修改换行符（保持文件原样）
git status; git add .; git commit -m "change"; git push origin main

#云端同步到本地
cd x:/liggghts-code
git pull origin main


#同步到新电脑 
# 切换到存储库文件夹，需要将 ${folder} 替换为存储库文件夹
cd ${folder}

 #变成一个新的 Git 仓库
git init

# 设置远程存储库地址，需要将 ${url} 替换为存储库网址
git remote set-url origin ${url}
 
# 同步代码
git pull origin main


#终端运行
python git_automator.py