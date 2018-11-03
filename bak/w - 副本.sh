#!/bin/bash


# 为Debian安装远程桌面
install_lxde_vnc(){

# 卸载或去除不必要的系统服务
apt-get purge apache2* bind9* samba* -y

# 升级Debian
apt-get update -y

# 安装LXDE+TightVncServer桌面环境
apt-get install xorg lxde-core tightvncserver -y

# 设置VNC密码
echo "----------------------------------------"
echo "  按提示设置 VNC Password 远程桌面密码"
echo "----------------------------------------"
/usr/bin/tightvncpasswd
tightvncserver -kill :1

# VNC启动时自动启动LXDE桌面
sed -i '/lxterminal/'d /root/.vnc/xstartup
echo "lxterminal &" >> /root/.vnc/xstartup
echo "/usr/bin/lxsession -s LXDE &" >> /root/.vnc/xstartup

clear
echo "----------------------------------------"
echo "  提示：安装 Lxde+VNC 远程桌面 成功"
echo "  启动命令：tightvncserver :1 -geometry 1024x768"
echo "----------------------------------------"
echo ""
menu
}




# 添加开机自启动VNC
auto_lxde_vnc(){

	#添加自启动 加载配置文件
	touch /etc/init.d/vnc
	cat <<EOF > /etc/init.d/vnc
#!/bin/sh
### BEGIN INIT INFO
# Provides: vnc
# Required-Start: $syslog $remote_fs $network
# Required-Stop: $syslog $remote_fs $network
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Starts VNC Server on system start.
# Description: Starts tight VNC Server.
### END INIT INFO
# /etc/init.d/vnc

case "\$1" in
        start)
        su root -c '/usr/bin/tightvncserver :1 -geometry 1024x768'
        ;;
        stop)
        su root -c '/usr/bin/tightvncserver -kill :1'
        ;;
        *)
        echo "Usage: /etc/init.d/vnc {start|stop}"
        exit 1
        ;;
esac
exit 0
EOF

chmod 755 /etc/init.d/vnc
update-rc.d vnc defaults
service vnc start

clear
echo "----------------------------------------"
echo "  提示：添加 Lxde+VNC 开机自启动 成功"
echo "----------------------------------------"
echo ""
menu
}




# 添加firefox浏览器和简体中文字体
add_firefox(){
apt-get install iceweasel -y
apt-get install flashplugin-nonfree -y
apt-get install ttf-arphic-ukai ttf-arphic-uming ttf-arphic-gbsn00lp ttf-arphic-bkai00mp ttf-arphic-bsmi00lp -y

clear
echo "----------------------------------------"
echo "  提示：安装 FireFox 浏览器 成功"
echo "----------------------------------------"
echo ""
menu
}




# 安装qemu虚拟机
install_qemu(){
apt-get install qemu -y

clear
echo "----------------------------------------"
echo "  提示：安装 Qemu 虚拟机 成功"
echo "----------------------------------------"
echo ""
menu
}




# 添加开机自启动qemu+win.img虚拟机
auto_qemu_win(){
if [[ -e /root/win.img ]]; then

sed -i '/tightvncserver/'d /etc/rc.local
echo "tightvncserver :1 -geometry 1024x768" >> /etc/rc.local

sed -i '/qemu/'d /etc/rc.local
echo "qemu-system-i386 -m 512 -hda win.img -k en-us -vnc 127.0.0.1:29 -daemonize -redir tcp:3389::3389" >> /etc/rc.local


	#添加自启动 加载配置文件
	touch /etc/init.d/win
	cat <<EOF > /etc/init.d/win
#!/bin/sh
### BEGIN INIT INFO
# Provides: win
# Required-Start: $syslog $remote_fs $network
# Required-Stop: $syslog $remote_fs $network
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Starts Qemu+Win Server on system start.
# Description: Starts Qemu+Win Server.
### END INIT INFO
# /etc/init.d/win

case "\$1" in
        start)
        su root -c '/usr/bin/qemu-system-i386 -m 512 -hda win.img -k en-us -vnc 127.0.0.1:29 -daemonize -redir tcp:3389::3389'
        ;;
        stop)
        su root -c `lsof -i:"3389" | awk '{print \$2}'| grep -v "PID" | xargs kill -9`
        ;;
        *)
        echo "Usage: /etc/init.d/win {start|stop}"
        exit 1
        ;;
esac
exit 0
EOF

chmod 755 /etc/init.d/win
update-rc.d win defaults
service win start

clear
echo "----------------------------------------"
echo "  提示：添加 Qemu+Win.img 虚拟机 开机自启动 成功"
echo "----------------------------------------"
echo ""
menu

else

clear
echo "----------------------------------------"
echo "  提示：未检测到 /root/win.img 取消操作 请查看帮助"
echo "----------------------------------------"
echo ""
menu

fi
}




# 全部卸载
unstall_lxde_vnc(){

# 卸载lxde和vnc
tightvncserver -kill :1
apt-get purge xorg lxde-core tightvncserver -y
rm -rf /root/.vnc
rm -rf /root/Desktop
sed -i '/tightvncserver/'d /etc/rc.local

# 卸载firefox浏览器和简体中文字体
apt-get purge iceweasel -y
apt-get purge ttf-arphic-ukai ttf-arphic-uming ttf-arphic-gbsn00lp ttf-arphic-bkai00mp ttf-arphic-bsmi00lp -y

# 卸载qemu虚拟机
lsof -i:"3389" | awk '{print $2}'| grep -v "PID" | xargs kill -9
apt-get purge qemu -y
sed -i '/qemu/'d /etc/rc.local
# rm -rf win*

clear
echo "----------------------------------------"
echo "  卸载 Lxde+VNC、FireFox+ttf、Qemu 成功"
echo "----------------------------------------"
echo ""
menu
}




get_help(){
apt-get install curl -y
local_ip=`curl -4 ip.sb`
clear
echo "----------------------------------------"
echo "  1.使用Windows VNC客户端连接远程桌面"
echo "    a.在shell中启动VNC服务"
echo "    tightvncserver :1 -geometry 1024x768"
echo "    b.VNC服务器地址：${local_ip}:1"
echo "    c.Windows客户端下载地址："
echo "    https://"
echo ""
echo "  2.使用Qemu虚拟机在Debian中安装Windows"
echo "    连接VNC在VNC内进行如下操作"
echo "    a.下载系统ISO 以精简版xp为例"
echo "    wget https://odrive.aptx.xin/System/DEEPIN-LITEXP-6.2.iso"
echo "    mv *iso win.iso"
echo "    b.创建虚拟硬盘 以10G为例"
echo "    qemu-img create win.img 10G"
echo "    c.在虚拟机中安装Windows系统"
echo "    qemu-system-i386 -cdrom win.iso -m 512M -boot d win.img -k en-us"
echo "    按提示安装完系统后：1.我的电脑-右键属性-允许远程桌面 2.添加开机密码"
echo ""
echo "  3.远程连接Qemu虚拟机中的Windows系统"
echo "    a.在shell中启动虚拟机"
echo "    tightvncserver :1 -geometry 1024x768"
echo "    qemu-system-i386 -m 512 -hda win.img -k en-us -vnc 127.0.0.1:29 -daemonize -redir tcp:3389::3389"
echo "    b.使用本地Windows自带的远程桌面连接工具 登陆远程桌面"
echo "    计算机地址：${local_ip}:3389"
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
echo "  2.添加 Lxde+VNC 开机自启动"
echo "  3.添加 Firefox 浏览器 和 简体中文字体"
echo "  4.安装 Qemu 虚拟机"
echo "  5.添加 Qemu+Win.img 虚拟机 开机自启动"
echo "  6.卸载 Lxde+VNC、FireFox+ttf、Qemu+win.img"
echo "  7.查看帮助"
echo "  8.退出脚本"
echo "----------------------------------------"

read -e -p "请输入对应的数字：" num
case $num in
	1)
	install_lxde_vnc
	;;
	2)
	auto_lxde_vnc
	;;
	3)
	add_firefox
	;;
	4)
	install_qemu
	;;
	5)
	auto_qemu_win
	;;
	6)
	unstall_lxde_vnc
	;;
	7)
	get_help
	;;
	8)
	exit 0
	;;
	*)
	clear
	menu
esac
}



clear
menu
