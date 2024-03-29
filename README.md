## 前提

    # 需要安装sshpass
    yum install -y sshpass


## SSH主机批量互信认证
    
    # 授权
    chmod +x batch-sshkey.sh

    ./batch-sshkey.sh 123456 192.168.133 131\ 132\ 133
