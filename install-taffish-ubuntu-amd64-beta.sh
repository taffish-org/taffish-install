#!/bin/bash

# >= 18.04.1-LTS (18.04.1-LTS, 20.04-LTS, 22.04-LTS, 24.04-LTS)
# 创建一个临时文件夹
temp_dir=$(mktemp -d)

# 定义清理函数，在脚本结束时删除临时文件夹
cleanup() {
    echo "Cleaning up..."
    rm -rf "$temp_dir"
    echo "Temporary directory $temp_dir deleted."
}

# 使用 trap 命令确保脚本结束时执行清理函数
trap cleanup EXIT

# 进入临时文件夹
cd "$temp_dir" || exit 1
echo "Executing commands inside $temp_dir"

# 在这里执行你想在临时文件夹中运行的命令
curl -O -# https://taffish.com/download/taffish-ubuntu-amd64-beta.tar.gz
tar -zxvf ./taffish-ubuntu-amd64-beta.tar.gz
cd ./taffish-ubuntu-amd64-beta
sh install.sh $0 $@

echo "Commands executed in $temp_dir"

# 脚本正常结束时将自动调用 trap，执行清理操作
