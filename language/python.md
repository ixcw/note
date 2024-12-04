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

##### 2.1 安装版本管理软件

[参考文章](https://blog.csdn.net/tqlisno1/article/details/108908775)

使用 [Anaconda](https://www.anaconda.com/) 管理 python 环境，安装对应版本即可，这里使用的 Anaconda 版本为 2.6.3，pycharm 版本为 2024.1.1

安装完后，使用 Anaconda Navigator 图形化管理软件进行 python 的环境管理

1. 首先添加源，加速包的下载速度，点击 channels，添加如下的清华源

   ```sh
   https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
   https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
   https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud//pytorch/
   https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
   ```

2. 点击 environments，再点击 create，输入 python 环境名称，选择 python 版本，下面的 R 不用管，这是 R 语言，一门用于科学计算统计的语言，然后点击 create，就创建了对应 python 版本的 python 环境

这样就完成了 python 环境的创建

##### 2.2 切换使用 python 版本

接下来是使用 pycharm 开发时如何选择 python 环境

1. 打开 pycharm，创建项目，选择 pure python 或者 python 框架都是可以的
2. 选择 `interpreter type` 时，选择 `custom environment`，然后选择 `select existing`
3. `type` 选择 `Conda`，这时会提示没有可执行的  conda，没关系，手动选择即可，选择 `select path`，定位到 Anaconda 的安装路径，选择这个 bat 文件：`D:\Develop\Anaconda\condabin\conda.bat`
4. 完成上诉步骤后，此时下方应该会出现使用 Anaconda 安装的 python 环境的名称，选择对应的 python 环境即可

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

使用 pip 命令重新安装依赖包：

```sh
# -r 参数是 --requirement 的缩写，表示指定一个依赖文件
pip install -r requirements.txt
# 指定官方源安装
pip install -r requirements.txt -i https://pypi.org/simple
```

