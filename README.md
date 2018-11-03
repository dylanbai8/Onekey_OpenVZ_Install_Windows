## OpenVZ虚拟化（架构）VPS 一键安装 Windows 系统

测试环境为 Debian7 （理论上支持 Debian Ubuntu 系列的大部分系统）

```
wget -N --no-check-certificate git.io/w.sh && chmod +x w.sh && bash w.sh
```

---
---

### 为 Debian/Ubuntu 安装远程桌面
```
依次执行 1、4

如果需要使用浏览器 依次执行 1、2、4
```

### 为 Dbian/Ubuntu 安装 WindowsXP
```
依次执行 3、4

默认启动内存为 512M 如果需要修改启动内存 依次执行 3、6、4
```

### 安装自定义 Windows 系统 （iOS 镜像）
```
执行 7 按提示操作
```

---
---

### 注意事项
```
如果安装完后 VNC桌面空白，查看是否有 Sub-process /usr/bin/dpkg returned an error code (1) 报错

解决办法1：
执行 rm /var/lib/dpkg/info/$nomdupaquet* -f 后重新安装

解决办法2：
更换源 或者更换系统
```
