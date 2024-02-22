#### 1 环境搭建

安装必要的开发软件，主要是在 centos7 下安装 mysql 和 python3

##### 1.1 安装mysql

安装mysql：可参考[Linux CentOS 7 安装mysql的两种方式](https://blog.csdn.net/Escorts/article/details/118941623)

安装完成后可查看mysql的初始密码：

```powershell
less /var/log/mysqld.log | grep 'password'
# A temporary password is generated for root@localhost: qN&mO6q?sj7W
```

登录mysql：

```powershell
mysql -u root -p
```

##### 1.1 安装python3

首先查看centos7的默认python版本：

```powershell
python
# Python 2.7.5 (default, Jun 28 2022, 15:30:04) 
# [GCC 4.8.5 20150623 (Red Hat 4.8.5-44)] on linux2
# Type "help", "copyright", "credits" or "license" for more information.
```

发现是2.7.5的版本，不符合需求

