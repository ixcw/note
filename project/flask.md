##### 3.3 链接管理器

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

##### 3.4 日志

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

##### 3.5 错误处理

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

4 数据库ORM





















