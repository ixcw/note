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

#### 6 编写爬虫

分析完网页后，我们开始编写 `spiders.py`

##### 6.1 数据爬取

首先定义一个爬虫类，将需要的爬取数据存储到一个临时的 csv 文件中

```python
class Spider(object):
    def __init__(self):
        pass
    
    @staticmethod
    def init(self):
        if not os.path.exists('./temp.csv'):
            with open('./temp.csv', 'a', newline='', encoding='utf-8') as wf:
                write = csv.writer(wf)
                write.writerow([
                    "brand", "carName", "carImg", "saleVolume",
                    "price", "manufacturer", "rank", "carModel",
                    "energyType", "marketTime", "insure"
                ])

    def main(self):
        pass


if __name__ == '__main__':
    spiderObj = spider()
    spiderObj.init()
```

将前面分析网页得到的请求地址通过 init 函数初始化，然后在 main 函数中通过 requests 库模拟请求该请求地址，获取到数据

```python
class Spider(object):
    def __init__(self):
        self.spiderUrl = (
            'https://www.dongchedi.com/motor/pc/car/rank_data?				    aid=1839&app_name=auto_web_pc&city_name'
                          '=贵阳&count=10&offset=10&month=&new_energy_type=&rank_data_type=11&brand_id=&price'
                          '=&manufacturer=&series_type=&nation=0')
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:133.0) Gecko/20100101 Firefox/133.0'
        }

    @staticmethod
    def init():
        # 略

    def main(self):
        page_json = requests.get(self.spiderUrl, headers=self.headers).json()
        page = page_json['data']['list']
        print(page)


if __name__ == '__main__':
    spiderObj = Spider()
    spiderObj.init()
    spiderObj.main()
```

但是此时参数是固定的，我们需要修改请求地址的参数来获取新的数据，定义一个文件 `spiderPage.txt` 来存储页数

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


class Spider(object):
    def __init__(self):
        self.spiderUrl = ('https://www.dongchedi.com/motor/pc/car/rank_data?aid=1839&app_name=auto_web_pc&city_name'
                          '=贵阳&count=10&month=&new_energy_type=&rank_data_type=11&brand_id=&price'
                          '=&manufacturer=&series_type=&nation=0')
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:133.0) Gecko/20100101 Firefox/133.0'
        }

    @staticmethod
    def init():
        if not os.path.exists('./temp.csv'):
            with open('./temp.csv', 'a', newline='', encoding='utf-8') as wf:
                write = csv.writer(wf)
                write.writerow([
                    "brand", "carName", "carImg", "saleVolume",
                    "price", "manufacturer", "rank", "carModel",
                    "energyType", "marketTime", "insure"
                ])

    @staticmethod
    def get_page():
        with open('./spiderPage.txt', 'r') as r_f:
            return r_f.readlines()[-1].strip()

    @staticmethod
    def set_page(new_page):
        with open('./spiderPage.txt', 'a') as a_f:
            a_f.write('\n' + str(new_page))

    def main(self):
        count = self.get_page()
        params = {
            'offset': int(count)
        }
        print('从第{}条数据开始爬取'.format(int(count) + 1))
        page_json = requests.get(self.spiderUrl, headers=self.headers, params=params).json()
        data_list = page_json['data']['list']
        for index, car in enumerate(data_list):
            print('正在爬取第%d' % (index + 1) + '条数据')
            car_data = []
            # 品牌名
            car_data.append(car['brand_name'])
            # 车名
            car_data.append(car['series_name'])
            # 图片
            car_data.append(car['image'])
            # 销量
            car_data.append(car['count'])
            # 价格（范围）
            price = [car['min_price'], car['max_price']]
            car_data.append(price)
            #  厂商
            car_data.append(car['sub_brand_name'])
            # 排名
            car_data.append(car['rank'])
            # 车型（请求参数页获取）
            series_id = car['series_id']
            info_html = requests.get(
                f'https://www.dongchedi.com/auto/params-carIds-x-{series_id}',
                headers=self.headers
            ).text
            info_soup = etree.HTML(info_html)
            car_model = info_soup.xpath('//div[@data-row-anchor="jb"]/div[2]/div/text()')[0]
            # 能源类型
            energy_type = info_soup.xpath('//div[@data-row-anchor="fuel_form"]/div[2]/div/text()')[0]
            # 上市时间
            market_time = info_soup.xpath('//div[@data-row-anchor="market_time"]/div[2]/div/text()')[0]
            # 保修期限
            period = info_soup.xpath('//div[@data-row-anchor="period"]/div[2]/div/text()')[0]
            car_data.append(car_model)
            car_data.append(energy_type)
            car_data.append(market_time)
            car_data.append(period)
            print(car_data)
            break
        print(data_list)
        self.set_page(int(count) + 10)


if __name__ == '__main__':
    spiderObj = Spider()
    spiderObj.init()
    spiderObj.main()
```

##### 6.2 数据存储

###### 6.2.1 存储到 csv

爬取到数据后，存储数据到 csv 文件，定义一个存储到 csv 文件的函数

```python
@staticmethod
def save_to_csv(result_data):
    with open('./temp.csv', 'a', newline='', encoding='utf-8') as wf:
        writer = csv.writer(wf)
        writer.writerow(result_data)
```

###### 6.2.2 存储到数据库

接下来就是存储到数据库，Django 自带了存储到数据库的功能，我们可以将其利用起来，Django 的项目是由多个应用程序组成的，每个应用程序就是一个相对独立的模块，负责实现特定的功能，可以通过如下命令创建一个应用程序：

```sh
python manage.py startapp myApp
```

执行之后就会生成一个名为 `myApp` 的文件夹，这个文件夹就是创建的应用程序，里面有基本的结构，目录解析如下：

```sh
<myApp>/
    ├── migrations/            # 数据库迁移文件（用于管理模型的变更）
    │   └── __init__.py        # 使 migrations 成为一个 Python 包
    ├── __init__.py            # 使 <myApp> 成为一个 Python 包
    ├── admin.py               # 注册模型到 Django 管理后台
    ├── apps.py                # 配置应用的相关信息
    ├── models.py              # 定义应用的数据库模型
    ├── tests.py               # 编写应用的单元测试
    ├── views.py               # 定义应用的视图逻辑
```

Django 的这个功能可以快速创建标准应用结构，方便开发者专注于业务逻辑的实现，而不必耗费精力到搭建项目上

打开 `models.py` 文件，创建用于存储数据库的类

```python
from django.db import models

# Create your models here.


class CarInfo(models.Model):
    id = models.AutoField('id', primary_key=True)
    brand = models.CharField('品牌', max_length=255, default='')
    carName = models.CharField('车名', max_length=255, default='')
    carImg = models.CharField('图片链接', max_length=255, default='')
    saleVolume = models.CharField('销量', max_length=255, default='')
    price = models.CharField('价格', max_length=255, default='')
    manufacturer = models.CharField('厂商', max_length=255, default='')
    rank = models.CharField('排名', max_length=255, default='')
    carModel = models.CharField('车型', max_length=255, default='')
    energyType = models.CharField('能源类型', max_length=255, default='')
    marketTime = models.CharField('上市时间', max_length=255, default='')
    insure = models.CharField('保修时间', max_length=255, default='')
    createTime = models.DateField('创建时间', auto_now_add=True)

    class Meta:
        db_table = 'carInfo'


class User(models.Model):
    id = models.AutoField('id', primary_key=True)
    userName = models.CharField('用户名', max_length=255, default='')
    password = models.CharField('密码', max_length=255, default='')
    createTime = models.DateField('创建时间', auto_now_add=True)

    class Meta:
        db_table = 'user'
```

接下来到 `settings.py` 注册创建的应用程序 `myApp`

```python
# Application definition

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "myApp"
]
```

注册完成后就可以使用命令创建对应的数据库了，注意创建之前记得将数据库服务打开

```sh
python manage.py makemigrations
python manage.py migrate
```

执行完成后数据库就会自动创建我们刚刚定义的两张表 carinfo 和 user 表，以及其他的 Django 需要的表

接下来就是把存储到 csv 的数据进行简单的清洗，然后存入数据库

```python
@staticmethod
def clear_csv(self):
    # 数据清洗
    df = pd.read_csv('./temp.csv')
    # 删除空行
    df.dropna(inplace=True)
    # 删除重复行
    df.drop_duplicates(inplace=True)
    print(f'数据总数为{df.shape[0]}条')
    return df.values

def save_to_sql(self):
    data = self.clear_csv(self)
    for car in data:
        CarInfo.objects.create(
            brand=car[0],
            carName=car[1],
            carImg=car[2],
            saleVolume=car[3],
            price=car[4],
            manufacturer=car[5],
            rank=car[6],
            carModel=car[7],
            energyType=car[8],
            marketTime=car[9],
            insure=car[10]
        )
```

存入数据库前，记得先引入之前定义好的数据库模型，这是固定的写法

```python
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "carBigScreen.settings")
django.setup()
from myApp.models import CarInfo
```

之后就是等待爬虫爬取完成，然后在主函数中执行存入数据库的函数就可以了

```python
if __name__ == '__main__':
    spiderObj = Spider()
    # spiderObj.init()
    # spiderObj.main()
    spiderObj.save_to_sql()
```

#### 7 前端

##### 7.1 前端初始化

因为这个项目更注重后端，所以前端直接用模板来改写，[模板地址](https://gitee.com/MTrun/big-screen-vue-datav)，node 版本 18.18.2，使用 `pnpm install` 安装依赖，安装完成后就可以执行 `npm run serve` 运行项目了

##### 7.2 编写 Django 路由

返回 python 项目，编辑 `urls.py`，创建路由

```python
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path("admin/", admin.site.urls),
    path("myApp/", include("myApp.urls"))
]
```

此时 `myApp` 没有 `urls.py` 文件，创建即可：

```python
from django.urls import path

from myApp import views
urlpatterns = [
    path("center", views.center, name="center")
]
```

此时 `views.py` 文件 没有 `center` 函数，创建即可：

```python
from django.shortcuts import render
from django.http import JsonResponse

# Create your views here.


def center(request):
    if request.method == 'GET':
        return JsonResponse({'code': 200, 'msg': 'success'})
```

然后在 `myApp` 应用里创建一个 utils 文件夹，用于编写获取数据的工具

首先新建 `getPublicData.py` 文件，用于获取所有数据

```python
from myApp.models import *


def get_all_cars():
    # 获取所有数据
    return CarInfo.objects.all()
```

然后新建 `getCenterData.py` 文件，引入 `get_all_cars` 函数

```python
import json
import time
from .getPublicData import *


def get_center_data():
    cars = get_all_cars()
    print(cars)
```

然后在 `views.py` 文件中引入工具文件

```python
from django.shortcuts import render
from django.http import JsonResponse
from .utils import getPublicData
from .utils import getCenterData

# Create your views here.


def center(request):
    if request.method == 'GET':
        getCenterData.get_center_data()
        return JsonResponse({'code': 200, 'msg': 'success'})
```

现在在浏览器中访问 `http://localhost:8000/myApp/center` 就能得到 json 数据了：

```json
{'code': 200, 'msg': 'success'}
```

现在对获取的总数据进行处理：

```python
# getCenterData.py

import json
import time
from .getPublicData import *


def get_center_data():
    cars = list(get_all_cars())
    # 车辆总数据
    sum_cars = len(cars)
    # 销量最多汽车
    top_car = cars[0].carName
    # 车辆最高销售额
    top_car_volume = cars[0].saleVolume
    # 销售最多车型
    car_models = {}
    max_model = 0
    most_model = ''
    for i in cars:
        # 不存在车型返回 -1
        if car_models.get(i.carModel, -1) == -1:
            car_models[str(i.carModel)] = 1
        else:
            car_models[str(i.carModel)] += 1
    # 排序
    car_models = sorted(car_models.items(), key=lambda x: x[1], reverse=True)
    most_model = car_models[0][0]
    max_model = car_models[0][0]
    # 车型最多品牌
    car_brands = {}
    max_brand = 0
    most_brand = ''
    for i in cars:
        # 不存在车型返回 -1
        if car_brands.get(i.brand, -1) == -1:
            car_brands[str(i.brand)] = 1
        else:
            car_brands[str(i.brand)] += 1
    # 排序
    car_brands = sorted(car_brands.items(), key=lambda x: x[1], reverse=True)
    most_brand = car_brands[0][0]
    max_brand = car_brands[0][1]
    # 车辆平均价格
    car_prices = {}
    average_price = 0
    sum_price = 0
    for i in cars:
        x = json.loads(i.price)[0] + json.loads(i.price)[1]
        sum_price += x
    average_price = sum_price / (sum_cars * 2)
    average_price = round(average_price, 2)
    return sum_cars, top_car, top_car_volume, most_model, most_brand, average_price
```

返回处理的数据后，在 `views.py` 中接收数据，组装成 json 数据返回给路由

```python
# views.py

from django.shortcuts import render
from django.http import JsonResponse
from .utils import getPublicData
from .utils import getCenterData

# Create your views here.


def center(request):
    if request.method == 'GET':
        (sum_cars,
         top_car,
         top_car_volume,
         most_model,
         most_brand,
         average_price
         ) = getCenterData.get_center_data()
        return JsonResponse({
            'code': 200,
            'msg': 'success',
            'data': [
                {
                    'title': '车辆总数据',
                    'value': sum_cars
                },
                {
                    'title': '销量最多汽车',
                    'value': top_car
                },
                {
                    'title': '车辆最高销售额',
                    'value': top_car_volume
                },
                {
                    'title': '销售最多车型',
                    'value': most_model
                },
                {
                    'title': '车型最多品牌',
                    'value': most_brand
                },
                {
                    'title': '车辆平均价格',
                    'value': f'{average_price}万'
                }
            ]
        })
```

##### 7.3 前端请求数据

###### 7.3.1 axios

模板没有安装 axios 库，需要先安装

```sh
pnpm add axios
```

然后新建 api 文件夹，新建 index js文件，引入 axios，编写请求对象

```js
import axios from 'axios'

const api = axios.create({
    baseURL: 'http://127.0.0.1:8000/',
    timeout: 60000
})

export default api
```

然后在 `main.js` 文件中引入并绑定到 vue 原型上

```js
import $http from '@/api/index'
Vue.prototype.$http = $http
```

然后在 `center.vue` 组件中使用请求

```js
async mounted() {
  const res = await this.$http.get('myApp/center')
  console.log(res)
}
```

###### 7.3.2 跨域

接着会遇到跨域问题，我们安装 Django 的一个 python 库来解决，打开 Django 项目，运行命令安装

```sh
pip install django-cors-headers
```

> 注意这里有坑，运行安装命令后，pip 会自动查找与最新版本的 django-cors-headers 兼容的 Django 版本，然后自动将项目的 Django 版本升级，导致项目报错，建议提前查找与当前 Django 版本兼容的版本，指定版本安装
>
> 如果已经升级报错，则需要卸载受影响的库，重新安装指定版本
>
> ```sh
> pip install django-cors-headers==3.11.0
> ```

安装完成后打开 `settings.py` 文件，引入 `corsheaders` 并做相关配置

```python
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "corsheaders",
    "myApp"
]

MIDDLEWARE = [
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

CORS_ALLOW_CREDENTIALS = True
CORS_ALLOW_ALL_ORIGINS = True
CORS_ALLOW_HEADERS = "*"
ROOT_URLCONF = "carBigScreen.urls"
```

再次请求，就可以正常获取数据了

##### 7.4 前端数据渲染

可参考 [datav](http://datav.jiaminghi.com/) 的官方文档，完成数据渲染，如需更多数据，参照编写 Django 路由，编写更多路由返回数据即可




































