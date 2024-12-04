#### 1 重装系统

[微pe](https://www.wepe.com.cn/) 官网下载 **微PE工具箱V2.3** 安装包后，点击打开，选择安装到 U盘，等待即可

下载原版 windows 的 iso 镜像文件，可下载多个版本的系统，复制到 U盘

将 U盘 插入待安装系统的电脑，启动电脑，启动电脑时，疯狂点击 F12（一般是 F12，根据品牌不同，还有可能是 F8 ~ F12 或 ESC），进入选择启动方式页面

|  台式  | 按键 | 笔记本 | 按键 |
| :----: | :--: | :----: | :--: |
|  华硕  |  F8  |  华硕  | ESC  |
|  微星  | F11  |  微星  | F11  |
|  技嘉  | F12  |  技嘉  | F12  |
| 七彩虹 | F11  |  联想  | F12  |

选择 U盘启动，进入 微pe 界面，打开资源管理，将 C盘 格式化

点击 Windows安装器，选择安装映像文件位置，选中 U盘 中的 iso镜像文件，再选择安装驱动器位置，选中 C盘，选择喜欢的系统版本，安装即可

安装后重启电脑，拔下 U盘，安装完成

#### 2 重置电脑密码

##### 2.1 恢复模式

按住 shift 键不放，重启电脑，进入恢复模式

依次选择：疑难答疑 => 高级选项 => 命令提示符，输入命令：

```sh
copy c:\windows\system32\Utilman.exe c:\windows\system32\Utilman.exe.bak /y  # 备份 Utilman
copy c:\windows\system32\cmd.exe c:\windows\system32\Utilman.exe /y  # cmd 覆盖 Utilman
```

然后关掉命令行，选择继续，重启电脑，选择辅助功能，弹出 Utilman.exe 命令行（此时已可执行 cmd 内部命令），输入命令：

```sh
net localgroup administrators  # 列出管理员用户组的用户
control userpasswords2  # 弹出账户管理窗口
```

弹出账户管理窗口后，选择重置密码，设置新密码即可

重置完成后，可以选择将 Utilman.exe 恢复回来：

```sh
copy c:\windows\system32\Utilman.exe.bak c:\windows\system32\Utilman.exe /y
```

##### 2.2 PE启动

准备好重装系统时制作的 pe盘，选择 U盘启动，进入 微pe 界面，打开 dism++，选中系统分区，点击打开会话，选择工具箱，点击账户管理，选中需要重置密码的账户，点击清空密码，清空完成

#### 3 todo不能同步

用 v2rayN 开启网络代理后，微软todo 无法同步

原因：微软将自家应用商店里的应用做了沙箱隔离，使其无法被网络代理

接触限制即可，下载最新的 v2rayN客户端，最新的客户端在安装文件夹的 bin 目录下自带了一个 `EnableLoopback.exe` 执行文件，打开该文件，找到 todo，勾上，保存即可









