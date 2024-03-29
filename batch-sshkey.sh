#!/bin/bash
# __author__:

# 自动配置SSH免密登录脚本

# yum install -y sshpass

echo "前提，需要安装sshpass，已经安装直接回车，否则ctrl+c终止脚本"
read -p "" xxxxxx
# 传参检测
[ $# -ne 3 ] && echo -e "Usage: $0 rootpasswd netnum nethosts\nexample: bash $0 123456 192.168.133 131\ 132\ 133" && exit 11 

rootpasswd=$1
netnum=$2
nethosts=$3

#在deploy机器做其他node的ssh免密操作
for host in `echo "${nethosts}"`
do
    echo "============ ${netnum}.${host} ===========";

    if [[ ${USER} == 'root' ]];then
        [ ! -f /${USER}/.ssh/id_rsa ] &&\
        ssh-keygen -t rsa -P '' -f /${USER}/.ssh/id_rsa
    else
        [ ! -f /home/${USER}/.ssh/id_rsa ] &&\
        ssh-keygen -t rsa -P '' -f /home/${USER}/.ssh/id_rsa
    fi
    sshpass -p ${rootpasswd} ssh-copy-id -o StrictHostKeyChecking=no ${USER}@${netnum}.${host}

    if cat /etc/redhat-release &>/dev/null;then
        ssh -o StrictHostKeyChecking=no ${USER}@${netnum}.${host} "yum update -y"
    else
        ssh -o StrictHostKeyChecking=no ${USER}@${netnum}.${host} "apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y"
        [ $? -ne 0 ] && ssh -o StrictHostKeyChecking=no ${USER}@${netnum}.${host} "apt-get -yf install"
    fi
done
