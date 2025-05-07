#本地同步到云端
git status && git add . && git commit -m "change" && git push origin main

#云端同步到本地
git pull origin main

#同步到新电脑
# 下载数据，需要将 ${url} 替换为存储库网址
git clone ${url}
 
# 切换到存储库文件夹，需要将 ${folder} 替换为存储库文件夹
cd ${folder}
 
# 设置远程存储库地址，需要将 ${url} 替换为存储库网址
git remote set-url origin ${url}
 
# 同步代码
git pull origin main