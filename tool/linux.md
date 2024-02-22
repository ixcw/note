#### 修改SSH默认端口号
1. 默认ssh端口号通常为22，为了防止别人扫描爆破，需要修改
`vi /etc/ssh/sshd_config`
vi命令模式输入`:/port`查找到`port`,将`# port 22`修改为`port 26968`
2. 重启ssh服务
`/etc/init.d/sshd restart`

#### centos6安装高版本git
1. 卸载老版本git
`yum remove git`
2. 安装git依赖包
`yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel gcc perl-ExtUtils-MakeMaker package`
3. 下载git安装包
`wget https://www.kernel.org/pub/software/scm/git/git-2.13.2.tar.gz`
4. 安装git
```sh
tar -zxvf git-2.13.2.tar.gz
cd git-2.13.2
./configure --prefix=/usr/local/git all
make && make install
```
5. 加入环境变量
```sh
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
source /etc/bashrc
```
6. 查看git版本
`git --version`

#### SSL connect error
使用git clone产生此错误，解决方法是
`yum update -y nss curl libcurl`

#### SSH keygen
使用keygen程序生成私钥和公钥
`ssh-keygen -t rsa -b 2048 -f james-key-rsa`
>-t  type，指明加密类型
-b  bits，指明密钥大小
-f  file，指明密钥名字

####centos 6/7 升级内核
升级安装：
```sh
yum install centos-release-xen-46 -y
yum install kernel 
```
查看已安装内核：
`rpm -qa | grep kernel`

#### ubuntu主题
```sh
apt install gnome-tweak-tool
apt install gnome-shell-extensions
```
到`www.opendesktop.org`下载主题文件，解压放到`/usr/share/themes`下面，再打开tweak进行设置

#### 查看Ubuntu版本
```sh
lsb_release -a
```

#### CentOS 7

##### 1 查看ip地址

```bash
ifconfig
```

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/tool/linux/ifconfig.png)

##### 2 使用xshell连接

使用xshell新建会话，填入上面的IP地址，默认端口22，填入用户名密码登录

##### 3 常用命令

```sh
cd /usr/local # 切换到目标目录local
ls /boot # 显示目标目录的目录及文件名，不填参数表示当前目录
ll /boot # 显示目标目录的目录及文件详情，不填参数表示当前目录
clear # 清屏
pwd # 打印当前目录路径
mkdir ./work # 创建work文件夹
mkdir -p work/demo/study # 创建多级文件夹
mkdir -p -v work/demo/study # 创建多级文件夹的同时打印提示信息
mkdir -pv work/demo/study # 同上
cp work/file work1 #复制file到work1目录下
cp -r work work1 # 递归复制work文件夹全部内容到work1
mv # 重命名文件名或者移动文件或文件夹，移动文件夹可以不加-r
rm # 删除文件或文件夹，-r可以递归删除文件夹及文件 -f 强制删除并且不提示，如果不是root账户，rm默认不会提示
rm -rf # 慎用，比如rm -rf /usr/work，不小心加了空格 / usr/work，会删掉全部文件，准备跑路
find / -name *.java # 查找/目录下所有.java结尾的文件
```

##### 4 vim

###### 4.1 三种模式

- 普通模式：默认模式，文件只读，不可编辑

- 编辑模式：普通模式下按 i 进入，esc 键退出模式

- 命令模式：保存、搜索、退出等操作

###### 4.2 常用快捷键

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/tool/linux/vim快捷键.png)

##### 5 常用文本工具

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/tool/linux/常用文本工具.png)
- echo
   ```sh
   echo "hello" # 向终端输出hello
   echo "hello" > hello.txt # 向文件hello.txt里面写入hello，重写，会覆盖原本的内容
   echo "hello" >> hello.txt # 同上，但是效果是追加，不会覆盖
   ```
   
- cat

   ```sh
   cat hello.txt # 查看文件hello.txt的内容，内容输出到终端显示 -n 显示行号 -E 每行添加$表示结尾，可查出空行
   cat h1.txt h2.txt h3.txt # 合并h1.txt和h2.txt两个文件的内容到h3.txt文件
   cat > h.txt << EOF # 输入多行文本写入h.txt，EOF表示最后输入EOF结束输入，EOF可自定义，同echo，>重写，>>追加
   ```

- tail

   ```sh
   tail -n 2 full_log.txt # 显示最后两行内容
   tail -f full_log.txt # 显示最后几行，不退出，动态监控文件变化，文件发生改变实时输出，ctrl + c 退出
   ```

- grep

   ```sh
   grep abc hello.txt # 筛选出hello.txt文件中包含abc的文本行，支持正则表达式
   grep abc hello.txt > out.txt # 将结果写入out.txt
   grep -v abc hello.txt # 不包含abc的文本行
   ll | grep log.txt # 管道命令，将ll的结果作为数据源给grep进行筛选
   ```

##### 6 打包和压缩

- 打包：将多个文件合并为一个文件，不会压缩大小，常用工具 tar，拓展名 `.tar`
- 压缩，将单个文件压缩大小，常用工具 gzip，拓展名 `.gz`

两个工具可一起使用，拓展名 `.tar.gz`

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/tool/linux/tar常用选项参数.png)

```sh
tar zxvf tomcat.tar.gz -C /usr/local # 解压文件至local，-C可选，默认为当前目录
tar zcvf tomcat.tar.gz ./tomcat # 将tomcat文件夹压缩为tomcat.tar.gz文件
```



##### 7 应用安装

- yum
   ```sh
   yum search name # 在仓库中查询指定应用
   yum install -y name # 全自动下载安装应用及依赖，无需按y确认
   yum remove -y name # 全自动卸载安装应用及依赖，无需按y确认
   yum info name # 查看应用详情
   yum list installed *jdk* # 查看已安装的应用，名字包含jdk
   rpm -ql name # 查看应用安装后，输出与其关联的文件清单
   which name # 查看应用安装到哪儿了
   ```
   
- 编译安装

   如果yum仓库未提供rpm，往往需要编译安装，需要从应用官网下载源码后对源码编译后使用，使用编译命令make使用对应编译器对源码编译生成可执行文件

   ```sh
   tar zxvf redis-6.2.1.tar.gz # 解压源码压缩包
   cd redis-6.2.1/  # 进入解压的源码文件夹
   make # 使用对应编译器对源码编译生成可执行文件，需要提前安装好对应编译器，比如这里是gcc
   ```

   yum会自动在`/usr/bin`目录下生成对应的应用程序，编译安装不会，而是会在当前编译的目录中生成应用程序

   ```sh
   ./src/redis-server redis.conf # 运行redis，ctrl + c 退出
   ```

##### 8 系统管理命令

- netstat 网络管理

  ![](https://cdn.jsdelivr.net/gh/ixcw/note/images/tool/linux/netstat常用选项.png)
  ```sh
  netstat -tulpn
  netstat -ano
  ```

- 进程管理

  1. 查看进程

     ```sh
     ps -ef # 查看所有进程信息，id号等
     ps -ef | grep vim # 查看vim的进程信息，id号等
     ```

  2. 杀掉进程

     ```sh
     kill -9 PID # 强制杀掉进程号为PID的进程
     kill -s QUIT PID # 正常退出进程号为PID的进程
     ```

##### 9 应用服务化

应用服务化是指让应用程序以服务的方式在系统后台运行，Linux系统对服务化的应用统一管理，服务管理的命令为：`systemctl`

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/tool/linux/systemctl命令.png)

1. 找到pid文件，文件中保存了pid号，找到`/run/redis_6379.pid`

   ```sh
   find / -name *.pid
   ```

2. 打开pid文件

   ```sh
   vim /run/redis_6379.pid # 确认进程id，即PID
   ```

3. 切换到目录

   ```sh
   cd /usr/lib/systemd/system
   ```

4. 创建service文件

   ```sh
   vim redis.service
   ```
   内容如下：

   ```sh
   [Unit]
   Description=Redis
   After=syslog.target network.target remote-fs.target nss-lookup.target
   
   [Service]
   # Type=forking
   PIDFile=/run/redis_6379.pid
   ExecStart=/usr/local/redis-6.2.1/src/redis-server /usr/local/redis-6.2.1/redis.conf
   ExecStop=/bin/kill -s QUIT $MAINPID
   PrivateTmp=true
   
   [Install]
   WantedBy=multi-user.target
   ```

5. 重载所有service文件

   ```sh
   systemctl daemon-reload
   ```

6. 关闭正在运行的redis进程

   ```sh
   ps -ef | grep redis # 找到redis的PID
   kill -s QUIT 95558 # 正常关闭redis
   ```

7. 启动redis服务

   ```sh
   systemctl start redis # restart 重启 stop 停止 status 查看状态
   ```

8. 设置随系统启动

   ```sh
   systemctl enable redis # 启用自动启动 disable 关闭自动启动
   ```

9. 重启服务器，测试是否成功

   ```sh
   shutdown -r now # 重启服务器
   systemctl status redis # 查看redis是否启动
   ```

10. 查看随系统启动的服务

    ```sh
    systemctl list-unit-files # 可以使用grep，enabled 随系统启动 disabled 不随系统启动 static 关联应用可以启动它 
    ```

##### 10 用户及权限

Linux分用户和用户组，用户组就是将用户分组，隶属用户自动拥有该组权限，一个用户可以隶属于多个组，但同时只能生效一个，用户组让权限管理更轻松，不用为每一个用户单独设置权限

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/tool/linux/用户与用户组常用命令.png)

1. useradd
   ```sh
   useradd d1 # 创建用户d1
   useradd d2
   useradd t1
   ```
   
2. passwd
   ```sh
   passwd d1 # 修改d1的密码
   passwd d2
   passwd t1
   ```
   
3. groupadd
   ```sh
   groupadd developer #创建组developer
   groupadd testor
   ```
   
4. usermod
   ```sh
   usermod -g developer d1 #将d1分配到developer组
   usermod -g developer d2
   usermod -g testor t1
   groups # 查看当前用户属于哪一组，可指定查看具体用户 groups d1
   usermod -G developer,testor d1 # 将d1原有的组删掉，为d1同时添加两个组
   ```
   此时组已经分好，由root用户创建初始目录，授予用户组权限
   ```sh
   cd /usr/local/share # 切换到共享目录
   mkdir dev-document # 创建目录
   ```
   先了解一下文件权限代码
   ![](https://cdn.jsdelivr.net/gh/ixcw/note/images/tool/linux/文件权限代码表.png)
   

   接着第5步更改创建目录的权限

5. chown
   ```sh
   chown d1:developer dev-document # 将创建目录的属主改为d1，组改为developer
   ```
6. chmod
   ```sh
   chmod 750 dev-document # 750表示上面的文件权限代码表中的数字的和，7为rwx，5为r-x，0为---
   ```
   750：组用户可读写，其他用户不允许访问
   777：所有用户拥有完整权限
   700：只有属主拥有完整权限
7. newgrp
   ```sh
   newgrp testor # 如果用户有多个组，可以切换，比如d1切换到testor
   ```

root账户系统中只有一个，为方便起见，普通用户可以用sudo获取超级管理员权限，使用root用户登录后输入下面的命令，然后vim普通模式下输入100gg快速定位到第100行
```sh
visudo
```
接着仿照文件内容设置d1的权限，第一个ALL代表允许d1从任何电脑上远程访问，第二个表示可以切换至任意用户，第三个表示可以执行所有的命令，:wq退出保存
```sh
## Allow root to run any commands anywhere
root    ALL=(ALL)       ALL
d1      ALL=(ALL)       ALL
```
接着用命令验证改写是否正确

```sh
visodu -c
```

d1用户就可以用sudo获取权限了，但是每次都要sudo，root用户可以将visudo改为下面的内容，d1就不用每次都输入sudo了

```sh
## Allow root to run any commands anywhere
root    ALL=(ALL)       ALL
d1      ALL=(ALL)       NOPASSWD:ALL
```

##### 11 防火墙

1. 防火墙一般是基于应用进行设置的，先安装tomcat，把tomcat安装包复制到`/usr/local`文件夹下，解压，进入bin目录，启动tomcat
   ```sh
   cd /usr/local
   tar zxvf apache-tomcat-9.0.44.tar.gz
   cd apache-tomcat-9.0.44/
   cd bin
   ./startup.sh
   netstat -tulpn | grep 8080 # 查看tomcat是否启动
   ```
   
2. 此时服务器内通过浏览器访问`localhost:8080`，可以访问tomcat首页，而外部机器则不能通过`服务器IP地址:8080`进行访问，需要我们解除服务器防火墙才可以

   ```sh
   firewall-cmd --state # 查看防火墙的状态
   firewall-cmd --list-ports # 查看放行的端口，第一次查看一般是没有端口开放的
   firewall-cmd --zone=public --permanent --add-port=8080/tcp # 通过tcp访问时，放行8080端口，永久变更
   firewall-cmd --reload # 重载防火墙配置，使上面的配置生效
   ```

   配置完成后，外部机器就可以正常访问8080端口了，如果不想开放端口了，可以执行如下命令

   ```sh
   firewall-cmd --zone=public --permanent --remove-port=8080/tcp
   firewall-cmd --reload
   ```

   如果想放行一个范围的端口，可以这样更改，移除依然是改add为remove

   ```sh
   firewall-cmd --zone=public --permanent --add-port=8000-9000/tcp
   firewall-cmd --reload
   ```

##### 12 Bash Shell

Shell是用C语言写的脚本解释器，是用户通过代码操作Linux的桥梁，下面编写一键发布tomcat脚本`deploy_tomcat.sh`

```sh
echo "准备下载tomcat9" # 在屏幕显示提示信息
wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.44/bin/apache-tomcat-9.0.44.tar.gz
echo "正在解压缩tomcat9"
tar zxf apache-tomcat-9.0.44.tar.gz
echo "防火墙开放8080端口"
firewall-cmd --zone=public --permanent --add-port=8080/tcp
firewall-cmd --reload
echo "启动tomcat"
cd ./apache-tomcat-9.0.44/bin
./startup.sh
```

修改脚本权限

```sh
chmod 755 deploy_tomcat.sh
```

执行脚本

```sh
./deploy_tomcat.sh
```

##### 13 部署项目
###### 13.1 安装MySQL

1. yum search mysql ，yum源只有mariadb，没有mysql，先去mysql官网下载mysql安装源，复制下载链接，cd到目录`/usr/local`，新建mysql目录并用wget下载

   ```sh
   cd /usr/local
   mkdir mysql
   cd mysql
   wget https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
   ```

2. 安装安装源

   ```sh
   yum localinstall mysql80-community-release-el7-3.noarch.rpm
   ```

3. 重新搜索mysql，就可以搜索到mysql了，接着安装，这里mysql8.0是默认安装版本，如果想安装mysql5.7，可修改为5.7

   ```sh
   yum search mysql
   yum repolist all | grep mysql # 查看已安装的仓库源的mysql版本启用情况
   yum-config-manager --disable mysql80-community # 禁用默认的mysql8.0
   yum-config-manager --enable mysql57-community # 启用安装mysql5.7
   yum install mysql-community-server
   ```

4. 启动mysql

   ```sh
   systemctl start mysqld
   ```

5. 查看启动情况

   ```sh
   netstat -tulpn
   systemctl status mysqld
   ```

6. 设置开机启动

   ```sh
   systemctl enable mysqld
   ```

7. 初始化mysql

   - 修改root用户密码

      ```sh
      vim /var/log/mysqld.log # 打开mysql的日志，找到下面这句话，复制密码
      
      A temporary password is generated for root@localhost: <dkhfUShy6cY
      
      mysql -uroot -p # 使用root用户登录mysql，输入刚才复制的密码
      alter user 'root'@'localhost' identified with mysql_native_password by 'AmdYes1973!'; # 修改root密码
      ```
      
- 修改root用户登录的地址
  
      ```sh
      use mysql # 使用mysql数据库
      select host,user from user; # 查询地址用户
      update user set host='%' where user='root'; # 修改root用户地址为%，表示任意地址
      flush privileges; # 刷新权限，使设置生效
      ```
  
   - 放行3306端口
  
      ```sh
      firewall-cmd --zone=public --permanent --add-port=3306/tcp
      firewall-cmd --reload
      ```
  
###### 13.2 连接MySQL

1. 打开navicat填写服务器mysql信息，登录mysql
2. 建库建表，连接windows上原来的mysql，连接数据库，右键数据库选择`转储SQL文件`，选择`结构和数据`，导出sql文件，在服务器mysql上新建数据库，和原来windows上的数据库一致，右键该数据库，选择`运行SQL文件`，完成数据库迁移

###### 13.3 安装jdk
1. 搜索jdk版本

   ```sh
   yum search jdk
   ```

2. 安装openjdk1.8

   ```sh
   yum install -y java-1.8.0-openjdk
   java -version # 查看安装的jdk版本
   ```

###### 13.4 发布项目
1. 将项目打包为war包，在`pom.xml`中配置`<packaging>war</packaging>`，上传war包至服务器`/usr/local`，解压war包，这里用tar解压报错，换unzip解压即可

   ```sh
   unzip rbac-oa-1.0-SNAPSHOT.war -d rbac # 解压至rbac目录
   ```

2. 移动解压目录至`./apache-tomcat-9.0.44/webapps/`

   ```sh
   mv rbac ./apache-tomcat-9.0.44/webapps/
   ```

3. 编辑项目里的`mybatis-config.xml`mybatis配置文件，配置连接数据库信息，将数据库用户名和密码修改为服务器数据库的用户名和密码

   ```sh
   vim apache-tomcat-9.0.44/webapps/rbac/WEB-INF/classes/mybatis-config.xml
   ```

4. 配置tomcat运行参数，

   ```sh
   cd ..
   vim ./conf/server.xml
   ```
   
   修改`<Connector/>`标签中的8080为80端口，在最后的`</Host>`前添加`<Context/>`标签，指明访问路径
   
   ```xml
   <Connector port="80" protocol="HTTP/1.1"
                  connectionTimeout="20000"
                  redirectPort="8443" />
   
   <Context path="/" docBase="rbac"/>
   ```
   
5. 启动tomcat

   ```sh
   ./bin/startup.sh
   netstat -tulpn | grep 80
   firewall-cmd --zone=public --permanent --add-port=80/tcp
   firewall-cmd --reload
   ```

6. 服务器内部浏览器输入`localhost/login.html`，外部机器输入`192.167.74.130/login.html`即可访问项目
