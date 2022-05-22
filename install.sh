#!/usr/bin/env bash

ILOG=$PWD/logs/install.log
cwd=$PWD

status_check() {
    if [ $? -eq 0 ]
    then
        echo -e "$1 - Installed"
    else
        echo -e "$1 - Failed!"
    fi
}

debian_install() {
    echo -e '=====================\nINSTALLING FOR DEBIAN\n=====================\n' > "$ILOG"

    echo -ne 'Python3\r'
    sudo apt -y install python3 python3-pip &>> "$ILOG"
    status_check Python3
    echo -e '\n--------------------\n' >> "$ILOG"

    echo -ne 'PIP\r'
    sudo apt -y install python3-pip &>> "$ILOG"
    status_check Pip
    echo -e '\n--------------------\n' >> "$ILOG"

    echo -ne 'PHP\r'
    sudo apt -y install php &>> "$ILOG"
    status_check PHP
    echo -e '\n--------------------\n' >> "$ILOG"
    
    echo -ne 'WGET\r'
    sudo apt -y install wget &>> "$ILOG"
    status_check WGET
    echo -e '\n--------------------\n' >> "$ILOG"
    
    echo -ne 'UNZIP\r'
    sudo apt -y install unzip &>> "$ILOG"
    status_check UNZIP
    echo -e '\n--------------------\n' >> "$ILOG"
}

termux_install() {
    echo -e '=====================\nINSTALLING FOR TERMUX\n=====================\n' > "$ILOG"

    echo -ne 'Python3\r'
    apt -y install python &>> "$ILOG"
    status_check Python3
    echo -e '\n--------------------\n' >> "$ILOG"

    echo -ne 'PHP\r'
    apt -y install php &>> "$ILOG"
    status_check PHP
    echo -e '\n--------------------\n' >> "$ILOG"
    
    echo -ne 'WGET\r'
    apt -y install wget &>> "$ILOG"
    status_check WGET
    echo -e '\n--------------------\n' >> "$ILOG"

    echo -ne 'UNZIP\r'
    apt -y install unzip &>> "$ILOG"
    status_check UNZIP
    echo -e '\n--------------------\n' >> "$ILOG"
}

arch_install() {
    echo -e '=========================\nINSTALLING FOR ARCH LINUX\n=========================\n' > "$ILOG"

    echo -ne 'Python3\r'
    yes | sudo pacman -S python3 python-pip --needed &>> "$ILOG"
    status_check Python3
    echo -e '\n--------------------\n' >> "$ILOG"

    echo -ne 'PIP\r'
    yes | sudo pacman -S python-pip --needed &>> "$ILOG"
    status_check Pip
    echo -e '\n--------------------\n' >> "$ILOG"

    echo -ne 'PHP\r'
    yes | sudo pacman -S php --needed &>> "$ILOG"
    status_check PHP
    echo -e '\n--------------------\n' >> "$ILOG"
    
    echo -ne 'WGET\r'
    yes | sudo pacman -S wget --needed &>> "$ILOG"
    status_check WGET
    echo -e '\n--------------------\n' >> "$ILOG"

    echo -ne 'UNZIP\r'
    yes | sudo pacman -S unzip --needed &>> "$ILOG"
    status_check UNZIP
    echo -e '\n--------------------\n' >> "$ILOG"
}

echo -e '[!] Installing Dependencies...\n'

if [ -f '/etc/arch-release' ]; then
    arch_install
else
    if [ "$OSTYPE" == 'linux-android' ]; then
        termux_install
    else
        debian_install
    fi
fi

echo -ne 'Requests\r'
pip3 install requests &>> "$ILOG"
status_check Requests
echo -e '\n--------------------\n' >> "$ILOG"

echo -ne 'Packaging\r'
pip3 install packaging &>> "$ILOG"
status_check Packaging
echo -e '\n--------------------\n' >> "$ILOG"

# Download tunnlers
if ! [[ -f $HOME/.ngrokfolder/ngrok && -f $HOME/.cffolder/cloudflared ]] ; then
    if ! [[ -d $HOME/.ngrokfolder ]]; then
        cd $HOME && mkdir .ngrokfolder
    fi
    if ! [[ -d $HOME/.cffolder ]]; then
        cd $HOME && mkdir .cffolder
    fi
    p=`uname -m`
    d=`uname`
    while true; do
        echo -e "\nDownloading Tunnelers:\n"
        netcheck
        if [ -e ngrok.zip ];then
            rm -rf ngrok.zip
        fi
        cd "$cwd"
        if echo "$d" | grep -q "Darwin"; then
            if echo "$p" | grep -q "x86_64"; then
                wget -q --show-progress "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-stable-darwin-amd64.zip" -O "ngrok.zip"
                ngrokdel
                wget -q --show-progress "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-amd64.tgz" -O "cloudflared.tgz"
                tar -zxf cloudflared.tgz > /dev/null 2>&1
                rm -rf cloudflared.tgz
                break
            elif echo "$p" | grep -q "arm64"; then
                wget -q --show-progress "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-stable-arm64.zip" -O "ngrok.zip"
                ngrokdel
                echo -e "Cloudflared not available for device architecture!"
                sleep 3
                break
            else
                echo -e "Device architecture unknown. Download ngrok/cloudflared manually!"
                sleep 3
                break
            fi
        elif echo "$d" | grep -q "Linux"; then
            if echo "$p" | grep -q "aarch64"; then
                if [ -e ngrok-stable-linux-arm64.tgz ];then
                   rm -rf ngrok-stable-linux-arm64.tgz
                fi
                wget -q --show-progress "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-stable-linux-arm64.tgz" -O "ngrok.tgz"
                tar -zxf ngrok.tgz
                rm -rf ngrok.tgz
                wget -q --show-progress "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" -O "cloudflared"
                break
            elif echo "$p" | grep -q "arm"; then
                wget -q --show-progress "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-stable-linux-arm.zip" -O "ngrok.zip"
                ngrokdel
                wget -q --show-progress 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm' -O "cloudflared"
                break
            elif echo "$p" | grep -q "x86_64"; then
                wget -q --show-progress "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-stable-linux-amd64.zip" -O "ngrok.zip"
                ngrokdel
                wget -q --show-progress 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64' -O "cloudflared"
                break
            else
                wget -q --show-progress "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-stable-linux-386.zip" -O "ngrok.zip"
                ngrokdel
                wget -q --show-progress "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386" -O "cloudflared"
                break
            fi
        else
            echo -e "Unsupported Platform!"
            exit
        fi
    done
    sleep 1
    cd "$cwd"
    mv -f ngrok $HOME/.ngrokfolder
    mv -f cloudflared $HOME/.cffolder
    if [ `command -v sudo` ]; then
        sudo chmod +x $HOME/.ngrokfolder/ngrok
        sudo chmod +x $HOME/.cffolder/cloudflared
    else
        chmod +x $HOME/.ngrokfolder/ngrok
        chmod +x $HOME/.cffolder/cloudflared
    fi
fi

echo -e '=========\nCOMPLETED\n=========\n' >> "$ILOG"

echo -e '\n[+] Log Saved :' "$ILOG"
