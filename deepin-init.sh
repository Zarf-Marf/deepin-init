#!/bin/bash

#先进到用户下载目录
cd ~/Downloads

# 关闭控制中心自动更新
busctl call com.deepin.lastore /com/deepin/lastore com.deepin.lastore.Updater SetAutoCheckUpdates b 0
busctl call com.deepin.lastore /com/deepin/lastore com.deepin.lastore.Updater SetAutoDownloadUpdates b 0
busctl call com.deepin.lastore /com/deepin/lastore com.deepin.lastore.Updater SetUpdateNotify b 0
busctl call com.deepin.lastore /com/deepin/lastore com.deepin.lastore.Manager SetAutoClean b 0

# 系统设置
gsettings set com.deepin.xsettings dtk-window-radius 8  # 窗口圆角-中

gsettings set com.deepin.dde.dock display-mode 'efficient'  # dock-高效模式
gsettings set com.deepin.dde.dock window-size-efficient 46  # dock-高度增加

gsettings set com.deepin.dde.dock.module.multitasking enable true  # dock-禁用多任务窗口插件（待调整为只关闭，不禁用）
gsettings set com.deepin.dde.dock.module.show-desktop enable true  # dock-禁用显示桌面插件（待调整为只关闭，不禁用）

gsettings set com.deepin.dde.mouse disable-touchpad false  #插入鼠标时禁用触控板

gsettings set com.deepin.dde.power battery-lid-closed-action 'turnOffScreen' #使用电池-笔记本合盖时-关闭屏幕
gsettings set com.deepin.dde.power battery-press-power-button 'showSessionUI' #使用电池-按电源按钮时-不做任何操作
gsettings set com.deepin.dde.power battery-lock-delay 0  #使用电池-自动锁屏 从不
gsettings set com.deepin.dde.power battery-screen-black-delay 300  #使用电池-关闭显示器 5分钟
gsettings set com.deepin.dde.power battery-sleep-delay 0  #使用电池-进入待机模式 从不

gsettings set com.deepin.dde.power line-power-lid-closed-action 'turnOffScreen' #连接电源-笔记本合盖时-关闭屏幕
gsettings set com.deepin.dde.power line-power-press-power-button 'showSessionUI' #连接电源-按电源按钮时-不做任何操作
gsettings set com.deepin.dde.power line-power-lock-delay 0  #连接电源-自动锁屏 从不
gsettings set com.deepin.dde.power line-power-screen-black-delay 900  #连接电源-关闭显示器 15分钟
gsettings set com.deepin.dde.power line-power-sleep-delay 0  #连接电源-进入待机模式 从不




#卸载自己不需要的软件

sudo apt-get purge -y libreoffice*


#更新20.4后，卸载这个会导致无法右键跳转到设置，酌情卸载
#sudo apt-get purge -y onboard-common

#清理一下
sudo apt-get autoremove -y --purge

#安装软件
sudo apt-get update && sudo apt-get dist-upgrade -y
sudo apt-get install -y curl
sudo apt-get install -y git
sudo apt-get install -y console-setup
sudo apt-get install -y qt5-qmake
sudo apt-get install -y code
sudo apt-get install -y com.qq.weixin.deepin


#卸载fcitx时会同时卸载qdbus，导致截图录屏无法使用快捷键呼出，重新安装修复(安装 qdbus-qt5 也可以，不知道有什么区别)
sudo apt-get install -y qdbus


#修复命令行安装TIM、微信、向日葵、WPS，启动器中没有图标
mkdir -p ~/.local/share/applications/

cp -r /opt/apps/com.qq.weixin.deepin/entries/icons/* ~/.local/share/icons/
cp -r /opt/apps/com.qq.weixin.deepin/entries/applications/* ~/.local/share/applications/


#修复卸载多个软件后重启，启动器中又出现已卸载的图标
rm -rf ~/.config/deepin/dde-launcher-app-used-sorted-list.conf


#使用自己编译的深度音乐
wget -t 3 -T 15 https://storage.deepin.org/thread/202202072120231211_deepin-music.zip
unzip 202202072120231211_deepin-music.zip
rm -rf ~/.cache/deepin/deepin-music/
sudo mv /usr/bin/deepin-music /usr/bin/deepin-music.bak
sudo cp deepin-music /usr/bin/deepin-music



#更新微信到最新版本
sh -c  '/opt/apps/com.qq.weixin.deepin/files/run.sh -c'
export WINEPREFIX=$HOME/.deepinwine/Deepin-WeChat
rm WeChatSetup.exe
wget -t 3 -T 15 https://dldir1.qq.com/weixin/Windows/WeChatSetup.exe
deepin-wine6-stable WeChatSetup.exe

#清理一下
sudo apt-get autoremove -y --purge


#最后重启一下
reboot
