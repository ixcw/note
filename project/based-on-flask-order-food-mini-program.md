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

首先介绍目录结构：

```txt
│  application.py  封装的 Flask 的全局变量，包括 app、全局变量等
│  manager.py  主入口
│  requirements.txt  依赖列表
│  www.py  HTTP模块相关初始化
├─common  公共包
│  │
│  ├─libs  公用方法或类库
│  │  │  UrlManager.py
│  ├─models  数据库model
│
├─config  配置文件
│      base_setting.py  基础配置
│      local_setting.py  开发配置
│      production_setting.py  生产配置
│
├─docs  文档
│      mysql.md  数据库变更
│
├─jobs  任务
│  │
│  └─tasks  定时任务
│
├─web  前端存放
│  │
│  ├─static  静态文件
│  ├─templates  模板
│  ├─controllers  控制层
│  │  │  index.py
```

通过命令行启动应用

```sh
# linux
export ops_config=local && python manager.py runserver
# windows
$env:ops_config="local"; python manager.py runserver
```

#### 6 后台管理页面

首先新建一个控制层 user

```python
# user.py

from flask import Blueprint

route_user = Blueprint('user_page', __name__)

@route_user.route('/login')
def login():
    return 'login page'
```

然后在 `www.py` 中引入

```python
# www.py

from application import app
from web.controllers.index import route_index
from web.controllers.user.User import route_user

app.register_blueprint(route_index, url_prefix='/')
app.register_blueprint(route_user, url_prefix='/user')
```

此时访问 `http://127.0.0.1:8999/user/login` 就得到了 login page 的返回，但是我们想要的是一个网页，于是引入模板渲染工具，返回渲染结果

```python
# user.py

from flask import Blueprint, render_template

route_user = Blueprint('user_page', __name__)

@route_user.route('/login')
def login():
    return render_template('user/login.html')
```

此时会报找不到 login.html 模板的错误，这是正常的，我们去新建这个模板文件，将准备好的 static  静态文件和 templates  模板文件夹直接复制到 web 文件夹，但是此时还是不能访问，因为默认的模板文件夹不是指向的 web 文件夹下，需要做一些配置

```python
# application.py

class Application(Flask):
    def __init__(self, import_name, template_folder=None):
        super(Application, self).__init__(import_name, template_folder=template_folder)
        self.config.from_pyfile('config/base_setting.py')
        # 通过命令行赋值 ops_config 环境变量，再启动应用
        if "ops_config" in os.environ:
            self.config.from_pyfile('config/%s_setting.py' % os.environ['ops_config'])
        db.init_app(self)


db = SQLAlchemy()
# 配置模板文件所在目录
app = Application(__name__, template_folder=os.getcwd() + '/web/templates/')
manager = Manager(app)
```

这时会报方法未定义错误，这是因为模板文件中使用了未定义的方法，实际上就是链接管理器中的方法未定义，将准备好的代码拷贝过来如下

```python
# UrlManager.py

class UrlManager(object):
    def __init__(self):
        pass

    @staticmethod
    def buildUrl(path):
        return path

    @staticmethod
    def buildStaticUrl(path):
        ver = "%s" % 22222222
        path = "/static" + path + "?ver=" + ver
        return UrlManager.buildUrl(path)
```

但你也许会问这是 py 文件中的方法，怎么在模板文件中使用呢，我们可以通过函数模板进行注入

```python
# application.py

from common.libs.UrlManager import UrlManager

# 注入函数模板
app.add_template_global(UrlManager.buildUrl, 'buildUrl')
app.add_template_global(UrlManager.buildStaticUrl, 'buildStaticUrl')
```

现在再次访问 `http://127.0.0.1:8999/user/login` 就能访问到 html 模板文件了，但是会发现没有图片和样式，调试发现静态资源返回了 404 找不到资源，所以还要再配置静态资源的目录，这个问题只有在本地开发时会遇到

```python
# static.py

from flask import Blueprint, send_from_directory
from application import app

route_static = Blueprint('static', __name__)


@route_static.route("/<path:filename>")
def index(filename):
    return send_from_directory(app.root_path + '/web/static/', filename)
```

配置根路径 root_path

```python
class Application(Flask):
    def __init__(self, import_name, template_folder=None, root_path=None):
        super(Application, self).__init__(
            import_name,
            template_folder=template_folder,
            root_path=root_path,
            static_folder=None
        )
        self.config.from_pyfile('config/base_setting.py')
        # 通过命令行赋值 ops_config 环境变量，再启动应用
        if "ops_config" in os.environ:
            self.config.from_pyfile('config/%s_setting.py' % os.environ['ops_config'])
        db.init_app(self)


db = SQLAlchemy()
# 配置模板文件所在目录
app = Application(__name__, template_folder=os.getcwd() + '/web/templates/', root_path=os.getcwd())
```

在 `www.py` 中引入路由

```python
# www.py

from application import app
from web.controllers.index import route_index
from web.controllers.user.User import route_user
from web.controllers.static import route_static

app.register_blueprint(route_index, url_prefix='/')
app.register_blueprint(route_user, url_prefix='/user')
app.register_blueprint(route_static, url_prefix='/static')
```

接下来就按照路由的添加方式添加静态页面的访问路径就能搭建后台管理页面了

#### 7 小程序页面

这里按照正常流程创建小程序就可以了，创建完成后将提前准备好的小程序文件复制进来，就得到了基础的小程序前端页面

#### 8 后台账号模块开发

经过前面的基础框架和前端页面的搭建，项目已经有了一个基础样貌，但是具体功能还未实现，接下来就进入正式的功能开发，每个功能的开发从需求到数据库设计再到功能开发，整个流程走通是非常重要的，在这里我们也会按照这样的顺序进行讲解

##### 8.1 需求分析

首先开发后台的账号模块，先来分析需求

```mermaid
graph TD
    Account["账号模块"]
    Manager1["账户管理"]
    Manager2["认证功能"]
    AccountList["账户列表"]
    AccountAdd["添加账户"]
    AccountEdit["编辑账户"]
    AccountDelete["删除账户"]
    AccountRestore["恢复账户"]
    LoginOut["登录登出"]
    ResetPwd["重置密码"]
    InfoEdit["编辑信息"]
    
    Account --> Manager1
    Account --> Manager2
    Manager1 --> AccountList
    Manager1 --> AccountAdd
    Manager1 --> AccountEdit
    Manager1 --> AccountDelete
    Manager1 --> AccountRestore
    Manager2 --> LoginOut
    Manager2 --> ResetPwd
    Manager2 --> InfoEdit
```

账户模块可以对自己的账号进行修改和登录，也可以管理别的账号，我们首先实现登录功能

##### 8.2 创建用户表

登录 mysql

```sh
mysql -u root -p
```

创建数据库 order_food

```sh
CREATE DATABASE `order_food` DEFAULT CHARACTER SET = `utf8mb4`;
```

查看创建结果

```sh
SHOW DATABASES;
```

使用 food_db 数据库

```sh
USE order_food;
```

执行创建用户表的命令

```sql
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `uid` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户uid',
  `nickname` varchar(100) NOT NULL DEFAULT '' COMMENT '用户名',
  `mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '手机号码',
  `email` varchar(100) NOT NULL DEFAULT '' COMMENT '邮箱地址',
  `sex` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1: 男 2: 女 0: 没填写',
  `avatar` varchar(64) NOT NULL DEFAULT '' COMMENT '头像',
  `login_name` varchar(20) NOT NULL DEFAULT '' COMMENT '登录用户名',
  `login_pwd` varchar(32) NOT NULL DEFAULT '' COMMENT '登录密码',
  `login_salt` varchar(32) NOT NULL DEFAULT '' COMMENT '登录密码的随机加密秘钥',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1: 有效 0: 无效',
  `updated_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '最后一次更新时间',
  `created_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '插入时间',
  PRIMARY KEY(`uid`),
  UNIQUE KEY `login_name` (`login_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表(管理员)';
```

> 此处时间字段可能会报无效默认值，设置 mysql 的配置解决

##### 8.3 创建 ORM model

我们可以使用一款 flask 的工具库 `flask-sqlacodegen` 快速创建对应表的 model，首先安装

```sh
pip install flask-sqlacodegen==1.1.6.1
```

安装完成后执行下面的命令

```sh
flask-sqlacodegen 'mysql://root:root@127.0.0.1/order_food' --tables user --outfile "common/models/User.py" --flask
```

在 models 文件夹下就生成了 `User.py` 文件，但是生成的 model 文件中的 db 变量是默认生成的，需要换成我们项目中自定义生成的 db

```python
# User.py
# coding: utf-8

from sqlalchemy import BigInteger, Column, DateTime, Integer, String
from sqlalchemy.schema import FetchedValue
from application import db


class User(db.Model):
    __tablename__ = 'user'

    uid = db.Column(db.BigInteger, primary_key=True)
    nickname = db.Column(db.String(100), nullable=False, server_default=db.FetchedValue())
    mobile = db.Column(db.String(20), nullable=False, server_default=db.FetchedValue())
    email = db.Column(db.String(100), nullable=False, server_default=db.FetchedValue())
    sex = db.Column(db.Integer, nullable=False, server_default=db.FetchedValue())
    avatar = db.Column(db.String(64), nullable=False, server_default=db.FetchedValue())
    login_name = db.Column(db.String(20), nullable=False, unique=True, server_default=db.FetchedValue())
    login_pwd = db.Column(db.String(32), nullable=False, server_default=db.FetchedValue())
    Login_Salt = db.Column(db.String(32), nullable=False, server_default=db.FetchedValue())
    status = db.Column(db.Integer, nullable=False, server_default=db.FetchedValue())
    updated_time = db.Column(db.DateTime, nullable=False, server_default=db.FetchedValue())
    created_time = db.Column(db.DateTime, nullable=False, server_default=db.FetchedValue())
```

##### 8.4 实现登录功能

###### 8.4.1 请求方式

打开登录页面，点击登录，发现报错 `method not allowed`，原因是默认只有 get 请求方式，我们将 post 请求方式加上

```python
# web/controllers/user/User.py

from flask import Blueprint, render_template

route_user = Blueprint('user_page', __name__)


@route_user.route('/login', methods=["GET", "POST"])
def login():
    return render_template('user/login.html')
```

但是按照这里的逻辑，无论是通过 get 直接访问登录页，还是点击按钮用 post 访问，都会直接返回登录页，我们想要的效果是点击登录按钮时是登录功能，而不是返回登录页，因此对请求方式进行判断分开处理

```python
# web/controllers/user/User.py

from flask import Blueprint, render_template, request, jsonify

route_user = Blueprint('user_page', __name__)


@route_user.route('/login', methods=["GET", "POST"])
def login():
    if request.method == 'GET':
        return render_template('user/login.html')
    res_json = {'code': 200, 'msg': '登录成功', 'data': {}}
    req = request.values
    login_name = req['login_name'] if 'login_name' in req else ''
    login_pwd = req['login_pwd'] if 'login_pwd' in req else ''
    
    if login_name is None or len(login_name) < 1:
        res_json['code'] = -1
        res_json['msg'] = '登录失败，请输入正确的用户名~~'
        return jsonify(res_json)
    if login_pwd is None or len(login_pwd) < 1:
        res_json['code'] = -1
        res_json['msg'] = '登录失败，请输入正确的密码~~'
        return jsonify(res_json)

    return "%s - %s" % (login_name, login_pwd)
```

###### 8.4.2 数据库查询

但是这里只是进行了判空处理，接下来进行数据库查询处理

```python
# web/controllers/user/User.py

from common.models.User import User

@route_user.route('/login', methods=["GET", "POST"])
def login():
    # 略
    user_info = User.query.filter_by(login_name=login_name).first()
    if not user_info:
        res_json['code'] = -1
        res_json['msg'] = '登录失败，请输入正确的用户名和密码~~'
        return jsonify(res_json)

    return "%s - %s" % (login_name, login_pwd)
```

此时数据库还没有用户数据，我们插入一条数据用于测试

```sql
INSERT INTO `user` (`uid`, `nickname`, `mobile`, `email`, `sex`, `avatar`, `login_name`, `login_pwd`, `login_salt`, `status`, `updated_time`, `created_time`) VALUES (1, 'james', '18888888888', 'james@qq.com', 1, '', 'james', '816440c40b7a9d55ff9eb7b20760862c', 'cF3JfH5FJfQ8B2Ba', 1, '2024-12-24 14:00', '2024-12-24 14:00');
```

插入完成后，再去使用用户名 `james` 进行登录，就能通过校验了

###### 8.4.3 密码加密

此时还未校验登录密码，这里的登录密码是通过盐值进行加密的，下面说一下如何进行加密

首先在 `common/libs` 下新建一个包 `user`，然后在包下新建一个服务类 `UserService.py`，利用 md5 和 base64 进行加密密码

```python
# UserService.py

import base64
import hashlib


class UserService():
    @staticmethod
    def get_pwd(pwd, salt):
        md5 = hashlib.md5()
        pwd_str = "%s-%s" % (base64.encodebytes(pwd.encode('utf-8')), salt)
        md5.update(pwd_str.encode('utf-8'))
        return md5.hexdigest()
```

返回 controller，引入 service

```python
# web/controllers/user/User.py

from common.libs.user.UserService import UserService

@route_user.route('/login', methods=["GET", "POST"])
def login():
    # 略
    if user_info.login_pwd != UserService.get_pwd(login_pwd, user_info.Login_Salt):
        res_json['code'] = -1
        # 一样的提示，防止用户试密码
        res_json['msg'] = '登录失败，请输入正确的用户名和密码~~'
        return jsonify(res_json)
```

###### 8.4.4 前端处理

然后处理前端，在静态文件夹新建登录文件，用于处理登录，这里使用 jQuery 编写，以及自定义的封装函数

```js
// static/js/user/login.js

;
const userLoginOps = {
  init: function () {
    this.eventBind()
  },
  eventBind: function () {
    $('.login-wrap .login-btn').click(function () {
      let loginBtn = $(this)
      if (loginBtn.hasClass('disabled')) {
        common_ops.alert('正在处理，勿重复提交')
        return
      }
      const loginName = $('.login-wrap input[name=login_name]').val().trim()
      const loginPwd = $('.login-wrap input[name=login_pwd]').val().trim()
      if(!loginName) {
        common_ops.alert('请输入正确的用户名')
        return
      }
      if(!loginPwd) {
        common_ops.alert('请输入正确的密码')
        return
      }

      loginBtn.addClass('disabled')

      $.ajax({
        url: common_ops.buildUrl('/user/login'),
        type: 'POST',
        data: {loginName, loginPwd},
        dataType: 'json',
        success: function (res) {
          let callback = null
          if (res.code === 200) {
            loginBtn.removeClass('disabled')
            callback = function () {
              window.location.href = common_ops.buildUrl('/')
            }
            common_ops.alert(res.msg, callback)
          }
        }
      })
    })
  }
}

$(document).ready(function () {
  userLoginOps.init()
})
```

###### 8.4.5 cookie 凭证

完成了基本校验，这里我们选择生成 cookie 作为用户凭证，依然在 service 中利用 md5 和 盐值 进行加密生成，最后调用 `make_response` 工具生成返回信息，返回给前端，这样登录成功时，浏览器就会存储 cookie

```python
# web/controllers/user/User.py
@route_user.route('/login', methods=["GET", "POST"])
def login():
    # 略
	# 生成cookie
	response = make_response(json.dumps(res_json))
	response.set_cookie(
        app.config['AUTH_COOKIE_NAME'],
        '%s#%s' % (UserService.generate_auth_code(user_info), user_info.uid)
    )

	return response
```

###### 8.4.6 登录拦截器

到这里我们发现，即使前面做了这么多登录工作，在我们不登录的时候，直接访问后台首页，还是可以访问到的，既然这样可以的话，那登录还有什么用呢，因此我们要对这些情况做个统一的登录拦截

我们当然可以对每个需要登录访问的路径在 controller 里面做拦截，但是这样非常麻烦，因此只需要做统一拦截即可

在web目录下新建 `interceptors` 包，然后新建一个 `AuthInterceptor.py` 拦截模块

```python
# web/interceptors/AuthInterceptor.py

from flask import request, redirect
from application import app
from common.models.User import User
from common.libs.user.UserService import UserService
from common.libs.UrlManager import UrlManager


# 拦截器装饰器
@app.before_request
def before_request():
    path = request.path
    user_info = check_login()
    if not user_info:
        return redirect(UrlManager.buildUrl('/user/login'))
    return


def check_login():
    """
    从 cookie 中取出 uid，然后查询数据库，通过查询到的个人信息生成加密授权码，和接收到的加密授权码进行对比，是否一致
    """
    cookies = request.cookies
    auth_cookie = cookies[app.config['AUTH_COOKIE_NAME']] if app.config['AUTH_COOKIE_NAME'] in cookies else None
    if auth_cookie is None:
        return False
    auth_info = auth_cookie.split('#')
    if len(auth_info) != 2:
        return False
    try:
        # 查询数据库用户信息
        user_info = User.query.filter_by(uid=auth_info[0]).first()
    except Exception as e:
        app.logger.error(e)
        return False
    if user_info is None:
        return False
    if auth_info[0] != UserService.generate_auth_code(user_info):
        # 对比不一致
        return False
    return user_info
```

拦截器会对所有请求进行拦截处理，这时再去访问后台，却发现报错了，报了无限循环重定向错误，原因是只要没有登录，那么就会一直重定向到登录页，正常访问登录页也会被重定向，这肯定是不行的，需要对正常访问的情况进行处理

先在配置文件中配置需要放行的路由地址

```python
# config/base_setting.py

# 基础配置

SERVER_PORT = 8999
DEBUG = False
SQLALCHEMY_ECHO = False

AUTH_COOKIE_NAME = 'food_admin'

IGNORE_URLS = [
    "^/user/login"
]

IGNORE_CHECK_LOGIN_URLS = [
    "^/static",
    "^/favicon.ico"
]
```

然后在拦截器中利用正则进行匹配处理

```python
# web/interceptors/AuthInterceptor.py

from flask import request, redirect
import re
from application import app
from common.models.User import User
from common.libs.user.UserService import UserService
from common.libs.UrlManager import UrlManager


# 拦截器装饰器
@app.before_request
def before_request():
    path = request.path
    ignore_urls = app.config['IGNORE_URLS']
    ignore_check_login_urls = app.config['IGNORE_CHECK_LOGIN_URLS']
    pattern = re.compile('%s' % '|'.join(ignore_check_login_urls))
    if pattern.match(path):
        return
    user_info = check_login()
    pattern = re.compile('%s' % '|'.join(ignore_urls))
    if pattern.match(path):
        return
    if not user_info:
        return redirect(UrlManager.buildUrl('/user/login'))
    return
```

经过处理后，就可以正常登录了，未登录访问首页时，会自动跳转到登录页

###### 8.4.7 退出登录

退出登录其实就是清除 cookie

```python
# web/controllers/user/User.py

@route_user.route('/logout')
def logout():
    response = make_response(redirect(UrlManager.buildUrl('/user/login')))
    response.delete_cookie(app.config['AUTH_COOKIE_NAME'])
    return response
```

##### 8.5 用户信息编辑

###### 8.5.1 信息编辑

首先获取已登录的用户信息，利用 flask 自带的全局变量 g 存储用户信息

```python
# web/interceptors/AuthInterceptor.py

user_info = check_login()
g.current_user = None
if user_info:
    g.current_user = user_info
```

然后可以在路由的 `render_template` 中传递这个数据过去，但是这样做的话，每个需要用到这个全局变量的地方都要传递一次，很麻烦，这时就又需要做统一处理了，由于这些路由都是通过 `render_template` 去渲染的，因此我们可以直接改造这个方法，传递全局变量过去

在 `common/libs` 下新建 `Custom.py`

```python
# common/libs/Custom.py

from flask import render_template, g


def custom_render(template, context=None):
    """
    自定义渲染方法，获取全局变量
    """
    if context is None:
        context = {}
    if 'current_user' in g:
        context['current_user'] = g.current_user
    return render_template(template, **context)
```

然后将 controller 里面的原有 `render_template` 替换成 `custom_render`，比如

```python
# web/controllers/index.py

from flask import Blueprint
from common.libs.Custom import custom_render

route_index = Blueprint('index_page', __name__)


@route_index.route("/")
def index():
    return custom_render('index/index.html')
```

其余的 controller 全部替换即可

接下来就是编写前端 js 文件获取输入，提交给编辑接口，编辑接口将全局变量的值修改，然后修改数据库中的值，完成修改

```python
# web/controllers/user/User.py

@route_user.route('/edit', methods=["GET", "POST"])
def edit():
    """
    修改用户信息
    :return: 修改结果
    """
    if request.method == 'GET':
        return custom_render('user/edit.html')
    res_json = {'code': 200, 'msg': '修改成功', 'data': {}}
    req = request.values
    nick_name = req['nickName'] if 'nickName' in req else ''
    email = req['email'] if 'email' in req else ''

    if nick_name is None or len(nick_name) < 1:
        res_json['code'] = -1
        res_json['msg'] = '修改失败，请输入正确的姓名~~'
        return jsonify(res_json)
    if email is None or len(email) < 1:
        res_json['code'] = -1
        res_json['msg'] = '修改失败，请输入正确的邮箱~~'
        return jsonify(res_json)

    user_info = g.current_user
    user_info.nickname = nick_name
    user_info.email = email
    db.session.add(user_info)
    db.session.commit()
    return jsonify(res_json)
```

###### 8.5.2 修改密码

修改密码大致相同，只是得注意，由于修改了` login_pwd`，而 cookie 是根据这个进行校验的，会导致修改完成后退出登录到登录页，解决办法也很简单，在修改完密码返回之前，将 cookie 也给更新一下就行

```python
@route_user.route('/reset-pwd', methods=['GET', 'POST'])
def reset_pwd():
    """
    修改密码
    :return: 修改结果
    """
    if request.method == 'GET':
        return custom_render('user/reset_pwd.html')
    res_json = {'code': 200, 'msg': '修改成功', 'data': {}}
    req = request.values
    old_password = req['oldPassword'] if 'oldPassword' in req else ''
    new_password = req['newPassword'] if 'newPassword' in req else ''

    if old_password is None or len(old_password) < 6:
        res_json['code'] = -1
        res_json['msg'] = '修改失败，请输入正确的原密码~~'
        return jsonify(res_json)
    if new_password is None or len(new_password) < 6:
        res_json['code'] = -1
        res_json['msg'] = '修改失败，请输入正确的新密码~~'
        return jsonify(res_json)
    if old_password == new_password:
        res_json['code'] = -1
        res_json['msg'] = '修改失败，新密码和原密码不能相同哦~~'
        return jsonify(res_json)

    user_info = g.current_user
    user_info.login_pwd = UserService.get_pwd(new_password, user_info.Login_Salt)
    db.session.add(user_info)
    db.session.commit()

    # 重新生成cookie，防止退出登录
    response = make_response(json.dumps(res_json))
    response.set_cookie(
        app.config['AUTH_COOKIE_NAME'],
        '%s#%s' % (UserService.generate_auth_code(user_info), user_info.uid),
        60 * 60 * 24 * 120  # 保存 120 天
    )

    return response
```

对于用户信息页面的 tab 栏不能正确切换的问题，可以修改路径，然后抽取公共组件，并传递相应的值到路由页面，实现 tab 高亮

##### 8.6 账号管理

###### 8.6.1 账号列表和详情

首先做展示账号列表的功能，查出所有用户信息，返回给账号页面进行处理即可

```python
# web/controllers/account/Account.py

from flask import Blueprint
from common.libs.Custom import custom_render
from common.models.User import User

route_account = Blueprint('account_page', __name__)


@route_account.route('/index')
def index():
    user_list_data = {}
    user_list = User.query.order_by(User.uid.desc()).all()
    user_list_data['list'] = user_list
    return custom_render('account/index.html', user_list_data)
```

然后是分页，这里不用三方插件实现，类似这种简单功能，自己就能封装，只要知道总数据条数，每一页需要的数据条数，就能算出总页数来进行分页了



























