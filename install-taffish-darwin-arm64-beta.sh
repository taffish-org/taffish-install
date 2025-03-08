#!/bin/bash

url="https://github.com/taffish-org/taffish-install/blob/main/taffish-darwin-arm64-beta.tar.gz"
# 创建一个临时文件夹
temp_dir=$(mktemp -d)

# 定义清理函数，在脚本结束时删除临时文件夹
cleanup() {
    echo "Cleaning up..."
    rm -rf "$temp_dir"
    echo "Temporary directory $temp_dir deleted."
}

check_cmd() {
    which $1 > /dev/null 2>&1
}

if (ls /opt/homebrew/opt/zstd/lib/libzstd.1.dylib > /dev/null 2>&1)
then
    :
else
    if (which brew > /dev/null 2>&1)
    then
        echo "[Warning] lib not found: /opt/homebrew/opt/zstd/lib/libzstd.1.dylib"
        echo ">>> Start to install zstd ..."
        brew install zstd
    else
        echo "[Warning] lib not found: /opt/homebrew/opt/zstd/lib/libzstd.1.dylib"
        read -p "> Do you want to install brew (then you can install zstd)? (y/n): " answer < /dev/tty
        if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
        then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            echo ">>> Start to install zstd ..."
            brew install zstd
        else
            echo "[Warning] You have to use brew to install zstd or you can't use taffish, you can install it by yourself then reinstall taffish."
            echo "[fail to install and quit]"
            exit 1
        fi
    fi
fi

if (which podman > /dev/null 2>&1)
then
    :
else
    echo "[Warning] Command not found: podman"
    read -p "> Do you want to use brew to install podman? (y/n): " answer < /dev/tty
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
    then
        brew install podman
    else
        echo "[Warning] You may need podman/docker to use taffish, you can install it by yourself."
    fi
fi

# 使用 trap 命令确保脚本结束时执行清理函数
trap cleanup EXIT

# 进入临时文件夹
cd "$temp_dir" || exit 1
echo "Executing commands inside $temp_dir"

# 在这里执行你想在临时文件夹中运行的命令
curl -L -O -A "Mozilla/5.0" -# $url
tar -zxvf ./taffish-darwin-arm64-beta.tar.gz
cd ./taffish-darwin-arm64-beta
sh install.sh $0 $@

echo "Commands executed in $temp_dir"

# 脚本正常结束时将自动调用 trap，执行清理操作
