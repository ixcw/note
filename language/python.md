#### 1 pip 换源

查看当前 pip 源

```sh
pip config list
```

临时换源

```sh
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pymysql
```

永久换源

```sh
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

#### 2 python 版本切换

##### 2.1 Anaconda

使用 [Anaconda](https://www.anaconda.com/) 管理 python 环境

> [参考文章](https://blog.csdn.net/tqlisno1/article/details/108908775)

Anaconda 成为科学计算的事实标准，核心在于它解决了科学计算中的三大痛点：
✅ **复杂依赖管理**（Python + 非 Python）
✅ **性能优化**（MKL/CUDA 集成）
✅ **复现性**（跨平台环境隔离）

> 这里使用的 Anaconda 版本为 2.6.3，pycharm 版本为 2024.1.1

###### 2.1.1 Anaconda Navigator

使用图形化软件管理 python 环境

1. 首先添加源，加速包的下载速度，点击 channels，添加如下的清华源

   ```sh
   https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
   https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
   https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud//pytorch/
   https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
   ```

2. 点击 environments，再点击 create，输入 python 环境名称，选择 python 版本，下面的 R 不用管，这是 R 语言，一门用于科学计算统计的语言，然后点击 create，就创建了对应 python 版本的 python 环境

这样就完成了 python 环境的创建

###### 2.1.2 命令行创建

```sh
conda create -n myenv python=3.8  # myenv 为环境名，3.8 为 Python 版本
conda activate myenv
```

可以在安装时查看详细输出日志

```sh
conda create -n myenv python=3.8 -v
```

###### 2.1.3 使用 conda 安装依赖

虽然 conda 可以安装 txt 格式的 `requirements.txt` 依赖文件

```sh
conda install --file requirements.txt
```

但是 conda 的依赖文件最好是 yml 格式的，比如 `environment.yml`

```yaml
name: myenv      # 环境名（可选）
channels:
  - conda-forge  # 优先从 conda-forge 安装
  - defaults
dependencies:
  - python=3.8   # 指定 Python 版本
  - numpy        # 直接写包名（conda 会自动解析版本）
  - pandas
  - pip:         # 通过 pip 安装的包
    - torch
    - transformers
```

使用 `environment.yml` 创建环境

```sh
conda env create -f environment.yml
```

如果  `environment.yml` 文件中未指定环境名，则需通过 `-n <env_name>` 手动命名

```sh
conda env create -f env.yml -n my_env
```

如何生成 yml 文件呢，可以手动编写，但是更推荐直接导出，确保环境的一致性

```sh
conda activate your_env_name  # 激活环境
conda env export > environment.yml  # 导出当前环境中的依赖到 environment.yml
```

另一种安装方法，会删减未在 yml 文件中声明的包

```sh
conda env update -f environment.yml --prune
```

###### 2.1.4 conda 清理缓存

如果安装出现问题，可以尝试清理缓存

```sh
conda clean --all
```

##### 2.2 切换使用 python 版本

接下来是使用 pycharm 开发时如何选择 python 环境

1. 打开 pycharm，创建项目，选择 pure python 或者 python 框架都是可以的
2. 选择 `interpreter type` 时，选择 `custom environment`，然后选择 `select existing`
3. `type` 选择 `Conda`，这时会提示没有可执行的  conda，没关系，手动选择即可，选择 `select path`，定位到 Anaconda 的安装路径，选择这个 bat 文件：`D:\Develop\Anaconda\condabin\conda.bat`
4. 完成上诉步骤后，此时下方应该会出现使用 Anaconda 安装的 python 环境的名称，选择对应的 python 环境即可
4. 在 pycharm 中选择 python 解释器时，下方会出现 conda 的蟒蛇图标鼠标移动上去会显示 Use Conda Package Manager，选中与不选中该图标，下方的依赖列表会有变化，这是因为如果选中，则代表使用 conda 管理项目的依赖，如果不勾选，则默认使用 pip 管理项目的依赖

> 使用清华源注意记得关闭代理软件，否则可能会报错

##### 2.3 问题解决

1. cmd 中运行 conda 无法识别

   原因可能是安装时没有添加系统变量或添加失败

   重新配置系统即可，打开系统变量，在 path 变量中添加以下 3 个路径：

   ```text
   D:\Develop\Anaconda
   D:\Develop\Anaconda\Scripts
   D:\Develop\Anaconda\Library\bin
   ```

2. cmd 中的 python 版本依旧是旧版本

   尽管在 pycharm 中使用了 conda 的 python 版本作为解释器，但是 cmd 中的 python 版本还是未发生变化，这会导致在安装 `requirements.txt` 中的包时发生问题

   解决方法是通过 conda 命令激活 python 环境，比如我使用 Anaconda 创建了一个 python 环境名为 py38， python 版本是 3.8.20，那么切换命令如下：

   ```sh
   conda activate py38
   ```

   执行后，提示符前方的 base 会变成 py38，表示切换成功，此时再检查 python 版本，会发现 python 版本已切换到 3.8.20

   ```sh
   python --version  # Python 3.8.20
   ```

   假如在 cmd 中运行 `conda activate py38` 时出现错误提示：

   ```sh
   CondaError: Run 'conda init' before 'conda activate'
   ```

   原因是需要先进行初始化 conda，正确配置电脑上的 cmd 信息，才能执行激活命令，打开我们安装的 Anaconda prompt 命令行，执行如下初始化命令

   ```sh
   conda init
   ```

   然后关闭 Anaconda prompt，重新打开 cmd，此时就可以正常激活了，powershell 应该也是同步解决了不能激活的问题，如果 pycharm 中的 powershell 依然报错，那么关闭项目，重启 pycharm 即可

#### 3 pip 相关

##### 3.1 pip 报错

使用 Anaconda 管理 python 版本时，pip 报错：

```sh
pip --version
Unable to create process using 'C:\Users\James Lee\.conda\envs\py38\python.exe "C:\Users\James Lee\.conda\envs\py38\Scripts\pip-script.py" --version'
```

解决办法是重装 pip：

```sh
python -m pip install --force-reinstall pip
```

##### 3.2 依赖配置文件

依赖配置文件名称为 `requirements.txt`，这个文件里记录了项目需要的各种依赖库的版本，可通过使用 python 的 pip 命令进行生成：

```sh
# 列出当前环境已安装的依赖包
pip freeze
# 将依赖包情况写入 requirements.txt 文件
pip freeze > requirements.txt
```

> 需要注意的是，这种方式导出的文件，可能会包含本地路径，以及没有版本号，不能直接提供给别人使用，在别的电脑上是不能使用的，可以使用如下命令生成只带包名和版本号的依赖文件，会忽略本地路径
>
> ```sh
> pip list --format=freeze > requirements.txt
> ```

使用 pip 命令重新安装依赖包：

```sh
# -r 参数是 --requirement 的缩写，表示指定一个依赖文件
pip install -r requirements.txt
# 指定官方源安装
pip install -r requirements.txt -i https://pypi.org/simple
```

#### 4 模块

##### 4.1 python 模块

在 Python 中，**python 模块** 是一个包含 Python 代码的文件，通常是为实现某些功能或组织代码而创建的

模块可以包含变量定义、函数、类，以及可以直接运行的代码

通过模块，我们可以将代码分为逻辑上独立的部分，便于重用和维护

本质上一个 `.py` 文件就是一个模块，可以通过 `import` 关键字在其他模块中导入使用

Python 中的模块大致可以分为三类：

1. **内置模块**： Python 自带的标准库模块。例如：

   `math`: 数学函数相关

   `os`: 操作系统相关

   `sys`: 与 Python 解释器交互

   `random`: 随机数相关

   ```python
   import math
   print(math.sqrt(16))  # 输出 4.0
   ```

2. **三方模块**： 由社区或第三方开发者创建，需要通过包管理工具（如 `pip`）安装。例如：

   `numpy`: 数值计算

   `pandas`: 数据分析

   `requests`: HTTP 请求

   安装：

   ```sh
   pip install requests
   ```

   使用：

   ```python
   import requests
   response = requests.get('https://api.github.com')
   print(response.status_code)  # 输出 200
   ```

3. **自定义模块**： 开发者自己编写的模块

   比如自己创建一个模块文件 `mymodule.py`：

   ```python
   def greet(name):
       return f"Hello, {name}!"
   ```

   然后在另一个模块中导入使用：

   ```python
   import mymodule
   print(mymodule.greet("Alice"))  # 输出 "Hello, Alice!"
   ```
   

模块有如下四种导入方式：

1. 直接导入整个模块

   ```python
   import math
   print(math.pi)
   ```

2. 导入模块中的特定部分

   ```python
   from math import sqrt
   print(sqrt(16))
   ```

3. 使用别名导入

   ```python
   import pandas as pd
   df = pd.read_csv('./temp.csv')
   ```

4. 导入模块的所有内容（不推荐）

   ```python
   from math import *
   print(pi)
   ```

模块可以通过包进行组织，模块是组成 Python 项目的基本单位，而多个模块可以组合成一个包，什么是包呢，包其实就是包含多个模块的文件夹，通常会有一个 `__init__.py` 模块文件，用于标识该文件夹为一个 Python 包

在 Python 2.x 中，`__init__.py` 是必需的，用来标识该目录是一个 Python 包，在 Python 3.x 中，即使没有 `__init__.py`，目录也可以被视为包。但为了兼容性和明确性，通常仍然推荐添加一个空的 `__init__.py` 文件

如果需要在导入包时执行一些初始化逻辑（例如配置环境、导入子模块），可以在 `__init__.py` 文件中编写代码，通过 `__init__.py` 文件，可以决定从包中导入时哪些模块或函数会被导入

假设有如下包：

```text
my_project/
├── __init__.py
├── module1.py
├── module2.py
├──tools/
   ├── __init__.py
   ├── tools1.py
   ├── tools2.py
```

导入时：

```python
from my_project import module1
from my_project.tools import tools2
```

##### 4.2 `__name__ ` 和 `__main__`

每个 Python 模块都有一个内置的特殊变量 `__name__`，其值会随着情况而发生变化：

1. 当在命令行直接执行这个模块时：

   比如在命令行运行命令执行模块

   ```sh
   python my_script.py
   ```

   此时，特殊变量 `__name__` 的值被设置为 `__main__`

2. 模块被导入到其他模块中时：

   ```python
   import my_script
   ```

   此时特殊变量 `__name__` 的值被设置为模块的名称，即 `my_script`，而不是 `__main__`

因此，代码里面经常可以看见这样的写法：

```python
if __name__ == '__main__':
```

从上面的说明中，可以知道这里的代码写法有两种用途，一种是通过命令直接运行模块时执行特定的代码，另一种是模块被导入到其它模块时避免执行特定的代码，在同一个项目中，可以在多个模块文件中编写 `if __name__ == '__main__':`，这样在 **直接运行某个模块** 时，其 `if __name__ == '__main__':` 块会执行，而 **被其他模块导入** 时，其 `if __name__ == '__main__':` 块不会执行，通过这种机制，可以方便地在开发阶段测试代码，同时保持模块间的解耦

##### 4.3 代码规范

1. 文件名命名

   采用小写字母，使用下划线 `_` 分隔单词，这种风格与 Python 的官方编码规范（PEP 8）一致，不使用短横线分隔，因为在导入模块时不能直接导入，会更麻烦

   ```sh
   math_operations.py   # 包含数学运算的功能
   file_handler.py      # 包含文件处理相关逻辑
   ```

2. 变量

   变量名同文件名，采用小写字母 + 下划线的形式

   ```python
   user_name = "John"
   age = 30
   total_amount = 100.5
   ```

3. 常量

   常量采用大写字母 + 下划线的形式

   ```python
   MAX_USERS = 100
   PI = 3.14159
   API_KEY = "12345"
   ```

4. 类

   类名和其他语言一样，采用大驼峰命名，即首字母大写

   ```python
   class UserAccount:
       def __init__(self, name, age):
           self.name = name
           self.age = age
   ```

5. 对象

   同变量名

6. 函数

   同变量名

7. 私有变量或方法

   以`_`或`__`开头命名

8. 包名

   同变量名

9. 项目名

   小写字母 + 短横线

#### 5 Django

##### 5.1 websocket

1. 安装 channels 库

   ```sh
   pip install channels
   ```

2. 在 `settings.py` 中配置 Channels：

   ```py
   INSTALLED_APPS = [
       "channels",
   ]
   ```

3. 在 `consumers.py` 中创建 websocket 消费者

   ```python
   from channels.generic.websocket import AsyncWebsocketConsumer
   import json
   
   class ProgressConsumer(AsyncWebsocketConsumer):
       async def connect(self):
           await self.accept()
   
       async def disconnect(self, close_code):
           pass
   
       async def receive(self, text_data):
           text_data_json = json.loads(text_data)
           message = text_data_json['message']
   
           # 处理耗时任务，并发送进度
           for i in range(100):
               await self.send(json.dumps({
                   'progress': i + 1
               }))
               # 模拟耗时任务
               await asyncio.sleep(1)
   ```


#### 6 语法



















