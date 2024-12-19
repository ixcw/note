#### 1 环境搭建

安装必要的开发软件，主要是在 centos7 下安装 mysql 和 python3

##### 1.1 安装mysql

安装mysql：可参考 [Linux CentOS 7 安装mysql的两种方式](https://blog.csdn.net/Escorts/article/details/118941623)

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

#### 2 正式开发

开发环境可以先用 windows 开发，至于 Linux 环境部署，后面再说

#### 3 flask 框架

直接使用安装 flask 框架即可，这里使用的 python 版本是 3.5.5

```sh
pip install flask
```

##### 3.1 路由

路由其实在 flask 里面就是拥有路由路径注解的函数

```python
@app.route('/')
def hello_world():
    return 'Hello World!'


@app.route('/index')
def index():
    return 'Index Page'
```

当我们定义上面的路由函数，访问下面这些路由路径时，就会得到相应函数的返回

```sh
http://127.0.0.1:5000  # Hello World!
http://127.0.0.1:5000/index  # Index Page
```

但是当我们想要拥有统一的 url 前缀时，比如 api，那么每一个路由函数都要写一遍 api 吗，这显然很麻烦，所幸 flask 为我们提供了简便的写法，只需要写一次即可，使用 Blueprint 编写统一的前缀

`Blueprint` 是 Flask 框架中的一个类，用于模块化管理应用程序。通过使用 `Blueprint`，可以将一个大型应用程序拆分成多个更小的模块，每个模块有自己的路由和视图逻辑，同时保持应用的组织性和可维护性

首先新建一个 `api.py` 文件，引入 `Blueprint`，新建路由

`api_page` 表示该蓝图的名字，这个名字用于标识蓝图，可以在注册到主应用时或调用蓝图的视图函数时用到，比如，蓝图的视图函数可以通过 `url_for('api_page.some_view')` 来引用

`__name__` 是 Python 内置的一个特殊变量，表示当前模块的名字

```python
from flask import Blueprint

api_route = Blueprint("api_page", __name__)


@api_route.route('/')
def index():
    return 'api Hello World!'


@api_route.route('/index')
def hello():
    return 'api Index Page'
```

##### 3.2 链接管理器

有了蓝图分化模块还不够，我们还要对链接进行管理，flask 有提供默认的链接管理器 `url_for`

```python
from flask import Flask, url_for

app = Flask(__name__)


@app.route('/')
def hello_world():
    return 'Hello World!' + url_for('index')


@app.route('/index')
def index():
    return 'index page'


if __name__ == '__main__':
    app.run()
```

访问对应地址就会得到返回，可以看到 url_for 返回的是路由函数所对应的路由地址

```sh
http://127.0.0.1:5000  # Hello World!/index
```

为了统一更好的使用，有必要再进行一次封装，这样可以自定义一些通用的操作，首先自定义一个链接管理类 UrlManager

```python
class UrlManager(object):
    @staticmethod
    def build_url(path):
        return path

    @staticmethod
    def build_static_url(path):
        return path
```

然后引入使用这个类去创建 url

```python
from flask import Flask, url_for
from common.libs.UrlManager import UrlManager

@app.route('/')
def hello_world():
    url = UrlManager.build_url('/api')
    return 'Hello World!' + url
```

##### 3.3 日志

日志是后端应用不可或缺的一部分，可以帮助我们快速地定位问题，flask 自带了日志功能，调用 logger 进行输出即可

```python
@app.route('/')
def hello_world():
    url = UrlManager.build_url('/api')
    msg = 'Hello World!' + url
    app.logger.error(msg)
    return msg
```

访问对应路由，可以看到控制台打印了日志

```sh
[2024-12-18 22:33:23,386] ERROR in app: Hello World!/api
```

##### 3.4 错误处理

我们可以自定义一些错误信息，这样比起默认的错误提示更加友好和可定制化

```python
@app.errorhandler(404)
def page_not_found():
    return '404 Not Found', 404
```

这样当输入了错误的路径时，404提示变为如下提示

```sh
http://127.0.0.1:5000/t  # 404 Not Found
```

可结合日志

```python
@app.errorhandler(404)
def page_not_found(err):
    app.logger.error(err)
    return '404 Not Found', 404
```

日志输出：

```sh
[2024-12-18 22:48:54,503] ERROR in app: 404 Not Found: The requested URL was not found on the server. If you entered the URL manually please check your spelling and try again.
```

#### 4 数据库ORM

ORM 就是 **Object-Relational Mapping** 的简写，表示对象关系映射，这是一种将数据库中的表与编程语言中的对象进行映射的技术，简化了数据库操作的复杂性，在使用 ORM 时，开发者可以使用面向对象的方式来处理数据库中的数据，而不需要直接编写 SQL 查询语句

ORM 仅仅是一个概念，要用到实际开发中我们需要实际的开发库，**SQLAlchemy** 就是这样一款 ORM 开发库，SQLAlchemy 既支持 ORM 映射，也支持使用 SQL 语句进行查询和操作，它是 Python 开发中常用的数据库交互库之一，尤其是在 Web 开发中，很多框架如 Flask 都使用它作为数据库层的解决方案

##### 4.1 安装

```sh
pip install sqlalchemy
pip install mysqlclient
```

> 如果安装 mysqlclient 出现编译问题，可尝试安装已编译好的包
>
> ```sh
> pip install --only-binary :all: mysqlclient
> ```

##### 4.2 使用

引入相关库，然后配置到 app，最后执行 SQL 语句获取查询结果

```python
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text

# 配置数据库  配置格式为：mysql://账号:密码@ip地址/数据库
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:root@127.0.0.1/order_food'
db = SQLAlchemy(app)

@app.route('/index')
def index():
    sql = text("SELECT * FROM `user`")
    with db.engine.connect() as conn:
        result = conn.execute(sql)
        for row in result:
            print(row)
    return 'index page'
```

#### 5 搭建 MVC 框架

有了前面知识的准备，我们就可以开始搭建一个 MVC 框架了，MVC 是一种程序模型，将应用程序分为模型、视图和控制器三个独立的部分，有助于实现代码的分离和组织，提高代码的可维护性和可扩展性

Model 层：负责处理业务数据，比如数据库交互，数据验证和计算等等

View 层：负责数据展示，比如前端页面HTML，与模型解耦，通常用模板引擎（如 JSP、Vue 等）进行渲染

Controller 层：作为模型和视图之间的中介，控制器接收来自视图的用户输入，调用模型去处理数据，并更新视图以展示新的数据，路由控制常常位于控制层

```sh
# linux
export ops_config=local && python manager.py runserver
# windows
set ops_config=local ; python manager.py runserver
```



































