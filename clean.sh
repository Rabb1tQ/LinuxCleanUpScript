#!/bin/bash

echo "--------------------------------------------------------------------------------"
echo "      Welcome to the Cleanup Script - Rabb1tQ     "
echo "
  ____              ____            _       _       _   _      ___  
 | __ )   _   _    |  _ \    __ _  | |__   | |__   / | | |_   / _ \ 
 |  _ \  | | | |   | |_) |  / _\` | | '_ \  | '_ \  | | | __| | | | |
 | |_) | | |_| |   |  _ <  | (_| | | |_) | | |_) | | | | |_  | |_| |
 |____/   \__, |   |_| \_\  \__,_| |_.__/  |_.__/  |_|  \__|  \__\_
          |___/ 
"
echo "--------------------------------------------------------------------------------"
echo -e "\n"


  
# 定义日志文件
LOGFILE="cleanup.log"
# 清空或创建日志文件
> "$LOGFILE"
{
echo "======== 清理临时文件 ========"
rm -rf /tmp/*
echo "======== 清理临时文件完成 ========"
echo -e "\n\n"

echo "======== 清理软件包缓存及不需要的软件包 ========"
apt clean
apt autoclean
apt autoremove
echo "======== 清理软件包缓存及不需要的软件包完成 ========"
echo -e "\n\n"


echo "======== 删除孤立的软件包 ========"
sudo apt-get autoremove --purge
echo "======== 删除孤立的软件包完成 ========"
echo -e "\n\n"

echo "======== 清理内存缓存 ========"
sync; echo 3 > /proc/sys/vm/drop_caches
echo "======== 清理内存缓存完成 ========"
echo -e "\n\n"

echo "======== 清理系统日志文件 ========"
journalctl --vacuum-time=1d
echo "======== 清理系统日志文件完成 ========"
echo -e "\n\n"

echo "======== 清理未使用的Docker镜像 ========"
docker image prune -a 
echo "======== 清理未使用的Docker镜像完成 ========"
echo -e "\n\n"

echo "======== 清理未使用的Docker容器 ========"
docker container prune 
echo "======== 清理未使用的Docker容器完成 ========"
echo -e "\n\n"

echo "======== 清理容器日志 ========"
logs=$(find /var/lib/docker/ -name *.log)
for log in $logs
        do
                #echo "clean containers logs : $log"
                cat /dev/null > $log
        done
echo "======== 清理容器日志完成 ========"
echo -e "\n\n"

echo "======== 清理旧内核文件 ========"
dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'.*/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt-get -y purge
echo "======== 清理旧内核文件完成 ========"
echo -e "\n\n"

echo "======== 清理缓存和日志 ========"
find /var/cache -type f -exec rm -rf {} \;
find /var/log -type f | while read f; do echo -n '' > $f; done
echo "======== 清理缓存和日志完成 ========"
echo -e "\n\n"

echo "======== 清理 APT 下载的包文件 ========"
rm -rf /var/cache/apt/archives/*
echo "======== 清理 APT 下载的包文件完成 ========"
echo -e "\n\n"

echo "======== 清理缩略图缓存 ========"
rm -rf ~/.cache/thumbnails/*
echo "======== 清理缩略图缓存完成 ========"
echo -e "\n\n"

echo "======== 清理孤立的库文件 ========"
sudo deborphan | xargs sudo apt-get -y remove --purge
echo "======== 清理孤立的库文件完成 ========"
echo -e "\n\n"

echo "======== 清理过时的内核头文件和头文档 ========"
sudo apt-get autoremove --purge
echo "======== 清理过时的内核头文件和头文档完成 ========"
echo -e "\n\n"

echo "======== 清理已卸载软件包的配置文件 ========"
dpkg -l | grep '^rc' | awk '{print $2}' | xargs sudo dpkg --purge
echo "======== 清理已卸载软件包的配置文件完成 ========"
echo -e "\n\n"

echo "======== 清理本地邮箱中的垃圾邮件 ========"
find ~/.local/share/mail/ -type f -name '*junk*' -delete
echo "======== 清理本地邮箱中的垃圾邮件完成"
echo -e "\n\n"

echo "======== 清理陈旧的备份文件 ========"
find / -type f -name '*.bak' -delete
echo "======== 清理陈旧的备份文件完成 ========"
echo -e "\n\n"

echo "======== 清理下载文件夹中的旧文件 ========"
find ~/Downloads/ -type f -atime +30 -delete
echo "======== 清理下载文件夹中的旧文件完成 ========"
echo -e "\n\n"

echo "======== 查找大文件（请自动删除） ========"
du -h / | grep '[0-9]G'
echo "======== 查找大文件完成 ========"
echo -e "\n\n"
}  2>&1 | tee -a "$LOGFILE"