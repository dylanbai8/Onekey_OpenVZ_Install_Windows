#!/bin/bash

#====================================================
#	System Request: Debian/Ubuntu
#	Author: dylanbai8
#	Dscription: OpenVZ虚拟化（架构）VPS 一键安装 Windows 系统
#	Open Source: https://github.com/dylanbai8/Onekey_OpenVZ_Install_Windows
#	Official document: https://v0v.bid
#====================================================




# 为Debian安装远程桌面
install_lxde_vnc(){

# 卸载或去除不必要的系统服务
apt-get purge apache2 -y

# 升级Debian
apt-get update -y

# 安装依赖、安装LXDE+VncServer桌面环境
apt-get install lxde -y
apt-get install xrdp -y
apt-get install curl -y
}




install_lxde_vnc_menu(){
local_ip=`curl -4 ip.sb`
clear
echo "----------------------------------------"
echo "  提示：安装 Lxde+VNC 远程桌面 成功"
echo ""
echo "  Windows远程桌面连接工具：${local_ip}:3389"
echo "  VNC客户端连接地址：${local_ip}:1"
echo "----------------------------------------"
echo ""

read -e -p "按任意键返回菜单 ..."
clear
menu
}




# 添加firefox浏览器和简体中文字体
add_firefox_ttf(){
apt-get install iceweasel -y
apt-get install flashplugin-nonfree -y
apt-get install ttf-arphic-ukai ttf-arphic-uming ttf-arphic-gbsn00lp ttf-arphic-bkai00mp ttf-arphic-bsmi00lp -y

clear
echo "----------------------------------------"
echo "  提示：安装 Firefox 浏览器 和 简体中文字体 成功"
echo "----------------------------------------"
echo ""

read -e -p "按任意键返回菜单 ..."
clear
menu
}




# 安装qemu+win虚拟机
install_qemu_win(){

# 安装qemu虚拟机
apt-get install qemu -y

# 安装win到虚拟机
wget https://www.dropbox.com/s/gq3e3feukskw72k/winxp.img
mkdir /root/IMG
mv winxp.img /root/IMG/win.img

# VNC启动时自动启动win虚拟机
sed -i '/qemu-system-x86_64/'d /root/.vnc/xstartup
echo 'qemu-system-x86_64 -hda /root/IMG/win.img -m 512M -net nic,model=virtio -net user -redir tcp:3388::3389' >> /root/.vnc/xstartup
chmod +x /root/.vnc/xstartup
}




install_qemu_win_menu(){
local_ip=`curl -4 ip.sb`
clear
echo "----------------------------------------"
echo "  提示：安装 Qemu+WindowsXP 虚拟机 成功"
echo "  WindowsXP 默认启动内存 512M 硬盘 4G"
echo "  远程桌面地址：${local_ip}:3388 未启动"
echo "----------------------------------------"
echo ""

read -e -p "按任意键返回菜单 ..."
clear
menu
}




check_vnc_install_qemu_win(){
if [[ -e /usr/bin/vncserver ]]; then
install_qemu_win
else
install_lxde_vnc
install_qemu_win
fi
}




# 启动 VNC+lxde/qemu_win
start_vnc(){
vncserver -kill :1
lsof -i:"3389" | awk '{print $2}'| grep -v "PID" | xargs kill -9
vncserver :1 -geometry 1024x768

local_ip=`curl -4 ip.sb`
clear
echo "----------------------------------------"
echo "  提示：启动 Lxde+VNC（+WindowsXP 如果已安装) 成功"
echo "  VNC服务器：${local_ip}:1"
echo ""
echo "  如果已安装 WindowsXP 预计15分钟后可以连接桌面"
echo "  远程桌面地址：${local_ip}:3389"
echo "  用户名：administrator 密码：abfan.com"
echo "----------------------------------------"
echo ""

read -e -p "按任意键返回菜单 ..."
clear
menu
}

# 关闭 VNC+lxde/qemu_win
stop_vnc(){
vncserver -kill :1
lsof -i:"3389" | awk '{print $2}'| grep -v "PID" | xargs kill -9

clear
echo "----------------------------------------"
echo "  提示：关闭 Lxde+VNC（+WindowsXP 如果已启动) 成功"
echo "----------------------------------------"
echo ""

read -e -p "按任意键返回菜单 ..."
clear
menu
}




# 设置Windows启动内存
set_win_ram(){
if [[ -e /root/IMG/win.img ]]; then

clear
echo "----------------------------------------"
echo "  请输入要设置的RAM值，如：1024"
echo "----------------------------------------"
echo ""

read -e -p "请输入：" ram
[[ -z ${ram} ]] && ram="none"
	if [ "${ram}" = "none" ];then
	set_win_ram
	fi

sed -i '/qemu-system-x86_64/'d /root/.vnc/xstartup
echo 'qemu-system-x86_64 -hda /root/IMG/win.img -m xxxxM -net nic,model=virtio -net user -redir tcp:3389::3389' >> /root/.vnc/xstartup
sed -i "s/xxxx/${ram}/g" "/root/.vnc/xstartup"
chmod +x /root/.vnc/xstartup

clear
echo "----------------------------------------"
echo "  操作已完成 当前 Windows 虚拟机内存为：${ram}M"
echo "  重启 Windows 虚拟机 生效"
echo "----------------------------------------"
echo ""

read -e -p "按任意键返回菜单 ..."
clear
menu

else

clear
echo "----------------------------------------"
echo "  未检查到 Windows 系统镜像 请先执行安装"
echo "----------------------------------------"
echo ""

read -e -p "按任意键返回菜单 ..."
clear
menu

fi
}




win_iso_install(){
clear
echo "----------------------------------------"
echo "  Note: This command must be executed inside the VNC Remote Desktop"
echo "  After the installation is complete, log in to the Windows system:"
echo "  1. My computer - right click property - allow remote desktop"
echo "  2. Add account password"
echo "----------------------------------------"
echo ""

read -e -p "Press any key to continue! Exit with 'Ctrl'+'C' !"

mv /root/*.iso /root/win.iso

if [[ -e /root/win.iso ]]; then

apt-get install qemu -y

win_iso_ram_disk

rm -rf /root/IMG
mkdir /root/IMG
qemu-img create /root/IMG/win.img ${ndisk}G

sed -i '/qemu-system-x86_64/'d /root/.vnc/xstartup
echo 'qemu-system-x86_64 -hda /root/IMG/win.img -m xxxxM -net nic,model=virtio -net user -redir tcp:3389::3389' >> /root/.vnc/xstartup
sed -i "s/xxxx/${nram}/g" "/root/.vnc/xstartup"
chmod +x /root/.vnc/xstartup

qemu-system-x86_64 -cdrom /root/win.iso -m ${nram}M -boot d /root/IMG/win.img -k en-us

clear
echo "----------------------------------------"
echo "  After the installation is complete, log in to the Windows system:"
echo "  1. My computer - right click property - allow remote desktop"
echo "  2. Add account password"
echo "  Back to shell Start VNC to run New Windows system in the background"
echo "----------------------------------------"

else

clear
echo "----------------------------------------"
echo "  No iso image file detected! Cancel installation"
echo "  Please manually download the iso system image into the /root/ directory"
echo "  Note: The image file extension must be .iso lowercase"
echo "----------------------------------------"

fi
}




win_iso_ram_disk(){

clear
echo "----------------------------------------"
echo "  Enter the RAM value to be set, for example: 1024"
echo "----------------------------------------"
echo ""

read -e -p "please enter (Default size 512):" nram
[[ -z ${nram} ]] && nram="512"

echo ""
echo "----------------------------------------"
echo "  Enter the hard disk value to be set, for example: 10"
echo "----------------------------------------"
echo ""

read -e -p "please enter (Default size 10):" ndisk
[[ -z ${ndisk} ]] && ndisk="10"

}




# 全部卸载
unstall_all(){

# 卸载lxde和vnc
vncserver -kill :1

apt-get purge xorg -y
apt-get purge lxde-core -y
apt-get purge vnc4server -y
apt-get purge curl -y

rm -rf /root/.vnc
rm -rf /root/Desktop

# 卸载firefox浏览器和简体中文字体
apt-get purge iceweasel -y
apt-get purge flashplugin-nonfree -y
apt-get purge ttf-arphic-ukai ttf-arphic-uming ttf-arphic-gbsn00lp ttf-arphic-bkai00mp ttf-arphic-bsmi00lp -y

# 卸载qemu虚拟机
lsof -i:"3389" | awk '{print $2}'| grep -v "PID" | xargs kill -9
apt-get purge qemu -y

# 卸载依赖
apt-get purge libsdl1.2-dev -y

# 删除IMG镜像
if [[ -e /root/IMG/win.img ]]; then

echo "----------------------------------------"
echo "  检测到已安装Windows系统镜像 是否删除？"
echo "----------------------------------------"
echo ""

read -e -p "请输入（y/n）：" rmIMG
case ${rmIMG} in
	[yY][eE][sS]|[yY])
	rm -rf /root/IMG
	echo "  已删除 /root/IMG/win.img 系统镜像"
	;;
	*)
	echo "  取消删除操作 镜像位置：/root/IMG/win.img"
esac

fi

clear
echo "----------------------------------------"
echo "  卸载 Lxde+VNC、FireFox+ttf、Qemu+Windows 成功"
echo "----------------------------------------"
echo ""

read -e -p "按任意键返回菜单 ..."
clear
menu
}




get_help(){
local_ip=`curl -4 ip.sb`
clear
echo "----------------------------------------"
echo "  **** 自定义安装 Windows 系统版本 ****"
echo "----------------------------------------"
echo ""
echo "  1.依次执行菜单中的 1、4 安装并启动 Lxde+VNC 服务"
echo ""
echo "  2.手动下载 Windows系统 iso镜像文件到 /root/ 目录内"
echo ""
echo "    以 深度精简版 WindowsXP 为例（支持原版安装和Ghost系统）"
echo "    cd /root"
echo "    wget https://www.dropbox.com/s/x20vw6bkwink0fm/winxp.iso"
echo ""
echo "  3.使用 Windows VNC 客户端连接远程桌面"
echo ""
echo "    a.VNC服务器地址：${local_ip}:1"
echo "    Windows客户端下载地址："
echo "    https://github.com/dylanbai8/Onekey_OpenVZ_Install_Windows/raw/master/VNC-4.0-x86_CN.exe"
echo ""
echo "    b.在 VNC 桌面内 打开终端（LXTerminal）执行以下命令："
echo ""
echo "    bash w.sh windows"
echo ""
echo "    注意：此命令必须在 VNC 远程桌面内执行"
echo "    按提示设置虚拟机内存和硬盘大小 默认512M内存10G硬盘"
echo "    按提示安装完系统后：1.我的电脑-右键属性-允许远程桌面 2.添加开机密码"
echo ""
echo "    调试完成后 返回 shell 执行脚本启动 VNC 即可在后台运行 新的Windows系统"
echo "----------------------------------------"
echo ""

read -e -p "按任意键返回菜单 ..."
clear
menu
}




# 安装菜单
menu(){
echo "----------------------------------------"
echo "  1.安装 Lxde+VNC 远程桌面"
echo "  2.添加 Firefox 浏览器 和 简体中文字体"
echo ""
echo "  3.一键安装 Qemu+WindowsXP 虚拟机"
echo ""
echo "  4.启动 Lxde+VNC（+WindowsXP 如果已安装)"
echo "  5.关闭 Lxde+VNC（+WindowsXP 如果已启动)"
echo ""
echo "  6.设置 WindowsXP 启动内存（默认512M）"
echo ""
echo "  7.自定义安装 Windows 系统版本"
echo ""
echo "  8.卸载所有"
echo "  9.退出脚本"
echo "----------------------------------------"
echo ""

read -e -p "请输入对应的数字：" num
case $num in
	1)
	install_lxde_vnc
	install_lxde_vnc_menu
	;;
	2)
	add_firefox_ttf
	;;
	3)
	check_vnc_install_qemu_win
	install_qemu_win_menu
	;;
	4)
	start_vnc
	;;
	5)
	stop_vnc
	;;
	6)
	set_win_ram
	;;
	7)
	get_help
	;;
	8)
	unstall_all
	;;
	9)
	exit 0
	;;
	*)
	clear
	menu
esac
}




# 检测root权限
if [ `id -u` == 0 ]; then
	echo "当前用户是 root 用户 开始安装流程"
else
	echo "当前用户不是root用户 请切换到 root 用户后重新执行脚本"
	exit 1
fi




# 脚本菜单
case "$1" in
	windows)
	win_iso_install
	;;
	*)
	clear
	menu
esac


# 转载请保留版权：https://github.com/dylanbai8/Onekey_OpenVZ_Install_Windows