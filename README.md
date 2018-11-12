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
1.如果安装完后 VNC桌面空白，查看是否有 Sub-process /usr/bin/dpkg returned an error code (1) 报错

解决办法1：
执行 rm /var/lib/dpkg/info/$nomdupaquet* -f 后重新安装

解决办法2：
更换源 或者更换系统

2.关于OpenVZ
在OpenVZ构架的VPS内安装Windows系统 CPU很容易100%运行
长期CPU、内存爆满 一般主机商不允许这样做 可能被判定为滥用而停封（短暂测试几小时或者一半天是没有问题的）

脚本的实现原理为在Debian/Ubuntu系统内使用qemu虚拟化工具安装运行了一个Windows虚拟机
因此，你为Windows系统分配的硬件资源应尽量的小于vps实际配置
举例：假如你的vps为2核CPU、2G内存，那么你分配给Windows的硬件资源应为1核CUP、1G内存，或者更少。这样以防止资源爆满

如果测试中你的vps不幸被停封了，发工单解释情况（随便编个理由），一般都是可以解封的
如果你需要长期运行Windows，一定要尽量使用少的资源，推荐不超过vps实际硬件资源的50%
```

---
---

### 开机自启动 Windows 虚拟机
```
编辑 /etc/rc.local
在 exit 0 前新增加一行 粘贴以下代码（具体配置可以自行修改）

qemu-system-x86_64 -hda /root/IMG/win.img -m 512M -smp 1 -daemonize -vnc :2 -net nic,model=virtio -net user -redir tcp:3389::3389

【修改端口映射】
默认主机仅将远程桌面3389端口转发至Windows系统 如果是用来运行程序（如建站）可能需要转发如80、443、22等端口
只需修改末尾 添加多个端口即可 如：-redir tcp:3389::3389 -redir tcp:443::443 -redir tcp:80::80
具体格式为 -redir [tcp|udp]:host-port::guest-port

查看端口是否正常映射：
lsof -i:"3389"
有返回内容即为映射正常

【修改其它配置】
-m 512M 表示内存为512M
-smp 2 表示使用两个CPU核心
-daemonize 在后台运行虚拟机
-vnc :2 开启vnc远程访问 其中:2标识vnc端口
-net nic,model=virtio -net user 即网络为NAT方式 OpenVZ充当虚拟机的网关和防火墙
-redir tcp:3389::3389 重定向虚拟机的3389端口到主机的网络界面上
```
