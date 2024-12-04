#### 1 创建项目

使用 pycharm 创建 django 项目，python 版本选择 3.8

简单介绍一下 django 项目的项目文件：

生成项目文件目录树可在项目根目录下使用如下命令，此命令为 windows 内置

```sh
# 生成第一层目录
tree
# 生成详细目录
tree /f
# 或写入到文件
tree /f > tree.txt
```

目录如下

```text
│  manage.py  // 主入口文件
│          
├─carBigScreen  // 项目文件夹
│      asgi.py
│      settings.py  // 基础配置文件
│      urls.py  // 基础路由文件
│      wsgi.py
│      __init__.py
│      
└─templates  // 前端相关文件
```

打开 pycharm 的设置，点击项目设置，打开 python 解释器设置，这里可以看见当前 python 环境已经安装的相关的库

如果是使用 conda 管理的 python 版本，还需要点击一下 conda 图标，才能看见 conda 安装的库

#### 2 安装项目依赖库

将准备好的 `requirements.txt` 文件复制到项目根目录，就类似于前端项目的 `package.json` 文件，复制完成后回到 pycharm，会发现 pycharm 已经检测到了这个依赖配置文件，提醒是否安装依赖，这里不用管它，我们通过命令行安装：

```sh
pip install -r requirements.txt
```

等待安装完成即可

安装完成后就可以启动项目了，点击启动，访问 `http://localhost:8000/` 就能看见启动页了

#### 3 修改基础配置

打开 `settings.py` 文件，将英文改为中文：

```python
LANGUAGE_CODE = "en-us"
# 改为
LANGUAGE_CODE = "zh-hans"
```

修改完后返回网页，会发现英文网页变成了中文网页

时间改回上海时区：

```python
TIME_ZONE = "UTC"
# 改为
TIME_ZONE = "Asia/Shanghai"
```

数据库配置从默认的 sqlite 改成 mysql，名字暂时留空：

```python
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": ,
    }
}
```

打开 Navicat，连接 MySQL 数据库，新建一个数据库，名字就叫 `car_big_data`，字符集默认就行，返回配置文件，把名字命名为刚刚创建的数据库名字，顺便增加数据库地址端口及用户名和密码配置

```python
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": "car_big_data",
        "User": "root",
        "PASSWORD": "123456",
        "HOST": "localhost",
        "PORT": "3306",
    }
}
```
项目报错

```sh
ModuleNotFoundError: No module named 'MySQLdb'
```

原因是未找到模块，但是项目已经安装了 pymysql 库，在 `settings.py` 中引入库

```python
import pymysql
pymysql.install_as_MySQLdb()
```

此时再次运行项目报错用户权限不能连接，重新打开所在数据库以 root 用户登录检查权限，重新赋权即可

```sh
.\mysql -u root -p
SHOW GRANTS FOR 'James Lee'@'localhost';
GRANT ALL PRIVILEGES ON car_big_data.* TO 'James Lee'@'localhost' IDENTIFIED BY '123456';
FLUSH PRIVILEGES;
```

#### 4 创建爬虫文件

项目根目录下新建文件夹 `spiderMan`，然后文件夹下新建 `spiders.py` 文件，在文件中引入相关的库

```python
import requests
from lxml import etree
import csv
import os
import time
import json
import pandas as pd
import re
import django
```

#### 5 网页分析

要做爬虫，第一步就是对网页进行分析，针对具体的网页采相应的爬取策略，这个项目爬取的是 [懂车帝](https://www.dongchedi.com/)

打开懂车帝的网站，点击排行榜进入排行榜网页，发现排行榜上的汽车相关消息比较齐全，比如车辆价格、销量等等，于是决定可以爬取这个网页

分析网页数据的类型，一般分两类，一类是服务器渲染，另一类是异步渲染

服务器渲染就是第一次访问网页，网页渲染好的内容

异步渲染则是通过网页上的某些按钮或行为触发网络请求得到的数据进行渲染的，比如一个长列表，网页滚动时，加载新的列表数据，新的列表数据就是异步渲染的数据，异步渲染可通过调试模式查看网络获取请求地址和请求数据，可选择自己需要的数据进行记录

还有的数据需要访问别的网页，可通过观察规律，得出访问规律，拼接数据进行访问，比如访问每辆车的参数页，参数页地址可通过参数页的前缀地址加上汽车 id 拼接而成

















































