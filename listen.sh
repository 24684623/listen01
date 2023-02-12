#!/bin/bash

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
PLAIN='\033[0m'

red() {
    echo -e "\033[31m\033[01m$1\033[0m"
}

green() {
    echo -e "\033[32m\033[01m$1\033[0m"
}

yellow() {
    echo -e "\033[33m\033[01m$1\033[0m"
}

clear


read -rp "是否安装脚本？ [Y/N]：" yesno

if [[ $yesno =~ "Y"|"y" ]]; then
    rm -f web config.json
    yellow "开始安装..."
    wget -O temp.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
    unzip temp.zip
    rm -f temp.zip
    mv v2ray web
    read -rp "请设置UUID（如无设置则使用脚本默认的）：" uuid
    if [[ -z $uuid ]]; then
        uuid="83f0ca0a-1069-4bdc-ae2d-a41739752b86"
    fi
    rm -f config.json
    cat << EOF > config.json
{
    "log": {
        "loglevel": "warning"
    },
    "routing": {
        "domainStrategy": "AsIs",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "block"
            }
        ]
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 8080,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$uuid"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none"
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        }
    ]
}
EOF
    nohup ./web run &>/dev/null &
    green "Deepnote 已安装完成！"
else
    red "已取消安装，脚本退出！"
    exit 1
fi