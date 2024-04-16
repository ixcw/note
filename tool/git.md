#### 1 Git简介

版本管理是一个老生常谈的问题了，其实在我们的日常生活中是很常见的

比如对文件做了修改就复制一份，然后重命名为v1、v2、v3...，这样做的缺点很多，比如管理起来也是很麻烦的，还容易丢失，而且只是一个人还好，多人合作时很难将不同人的文件版本合并起来，Git就是用于解决版本控制的工具，有诸多好处，比如易于合作，对比文件内容变化，回溯旧版本，找回丢失文件等

版本控制系统分为三种类型

- 单机本地的版本控制

  只能在自己的电脑上使用

- 集中化版本控制

  基于服务器-客户端的模式，服务器集中管理版本，客户端保存最新版本，比如SVN，缺点是不支持离线提交，中心服务器一旦崩溃，所有人无法正常合作，版本数据也会丢失

- 分布式版本控制

  与集中化版本控制类似，不过在客户端中也会保存服务器端的完整备份，并不只是最新的版本，这样分布式优点就是支持离线提交，中心服务器崩溃也能恢复数据，典型代表就是Git

#### 2 Git优点

Git最初设计用在Unix风格的命令行中执行，项目越大，合作人数越多越能体现git的好用，原因主要有：

1. 直接记录快照，而非进行差异比较

   SVN是基于差异的版本控制，它所存储的是基本文件和一组差异，好处是节省了磁盘空间，缺点是随时间累积起来的差异越来越多，切换版本时需要应用对比每次的差异，导致耗时，效率低等问题

   而Git则是在原文件的基础上生成一份新的文件，类似于备份文件，如果文件没有发生修改，则不生成新文件，而是保留链接指向之前一个版本的旧文件，优点是版本切换快，缺点是磁盘占用空间大

2. 几乎所有操作都是在本地执行

   断网之后依然可以管理版本，只需要在联网之后将新版本同步到服务器上备份即可

#### 3 Git工作流程

Git有三个区域，分别是工作区、暂存区、Git仓库

1. 工作区

   正在工作的区域，此时还没有把文件提交到暂存区，对应的状态是modified，已修改

2. 暂存区

   暂时存放文件的区域，文件已提交到暂存区，对应状态是staged，已暂存

3. Git仓库

   存放文件版本的区域，文件已提交到本地Git仓库中，对应状态是committed，已提交

Git工作流程：在工作区中修改文件，然后暂存想要提交的文件，最后提交暂存区中的文件快照到Git仓库进行存储

#### 4 Git环境配置

linux和macos都包含了unix命令行，windows使用windows的命令提示符cmd，但是cmd不是unix终端环境，所以在windows上使用git需要安装git bash，安装完成之后就可以配置环境了

1. 设置用户名和邮箱

   Git需要使用这些基本信息记录是谁对项目进行了修改，打开git bash，输入如下命令进行配置

   ```bash
   git config --global user.name "ixcw"
   git config --global user.email "228295392@qq.com"
   ```

   > 参数说明
   > 1. global：
   >
   >    表示这是全局配置，对当前用户生效，优先级中级
   >
   >    配置文件存放路径是`home/.gitconfig`，Linux系统就是`~/.gitconfig`，Windows系统就是`C:\Users\22829\.gitconfig`
   >
   > 2. system：
   >
   >    表示是系统配置，对所有用户生效，优先级较低
   >
   >    配置文件存放路径是`git的安装目录/etc/gitconfig`
   >
   > 3. local：
   >
   >    local或不加参数，则表示只对当前仓库生效，优先级最高
   >
   >    配置文件存放路径是工作目录的`.git/config`
   >
   > 配置文件内容：
   >
   > ```txt
   > [user]
   > 	name = ixcw
   > 	email = 228295392@qq.com
   > ```

2. 检查配置信息

   可以找到配置文件的路径直接打开文件检查，也可以输入如下命令：

   ```bash
   git config --list --global
   # user.name=ixcw
   # user.email=228295392@qq.com
   ```

   > 参数说明
   >
   > list：表示列出所有的配置项
   >
   > global：仅列出全局配置文件

   可以只查看指定的配置项
   ```bash
   git config user.name
   # user.name=ixcw
   git config user.email
   # user.email=228295392@qq.com
   ```
   获取Git帮助信息
   
   ```bash
   # 会在浏览器中打开本地的完整帮助手册
   git help config
   # 直接在终端显示简要帮助信息
   git config -h
   ```

#### 5 Git操作

##### 5.1 创建Git仓库

想要通过Git管理文件版本，首先肯定要创建一个Git仓库，可以通过如下方式：

1. 将本地新建或已存在的工作目录转化为Git仓库

   在工作目录中执行如下命令进行Git仓库的初始化

   ```bash
   git init
   # Initialized empty Git repository in D:/MEGAsync/技术/前端/Git/work directory/.git/
   ```

   命令执行完毕后会在工作目录下创建一个`.git`的隐藏文件夹，这个隐藏目录就是当前项目的Git仓库，里面包含了必要的初始文件，而且git bash终端的后面会出现提示`(master)`，表明这是主分支

2. 从云端克隆一个Git仓库

##### 5.2 文件状态

工作区中的文件有两类四种状态

- 未被Git管理

  未被跟踪状态（Untracked）：未被Git管理的文件处于此种状态，一般情况下是刚刚新建的文件

- 已被Git管理

  未修改状态（Unmodified）：未修改的文件，文件内容与Git仓库中的文件内容一致

  已修改状态（Modified）：已修改的文件，文件内容与Git仓库中的文件内容不一致

  已暂存状态（Staged）：已修改的文件已存到暂存区，准备保存到Git仓库

我们的最终目的是让文件与Git仓库中的文件保持一致，即让所有文件处于未修改状态



查看工作区中的文件的状态：

```bash
git status
# On branch master
# No commits yet
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#         index.html
# nothing added to commit but untracked files present (use "git add" to track)
```

输入命令后bash会返回一些帮助信息，包括分支信息，文件状态等，可以看到，目前处于未被跟踪状态的文件是index.html，这意味着该文件没有被Git纳入管理，在之前的Git快照中没有该文件，Git将不会追踪管理其版本，除非手动添加它给Git进行管理

如果希望输出结果更简要一些，可以添加`short`参数

```bash
# -s 也可以，是short的简写
git status --short
# ?? index.html
```

红色的`??`表示文件处于未被跟踪状态



跟踪新文件

新文件一般都处于未被跟踪状态，我们可以将其添加到Git中进行管理

```bash
git add index.html
```

命令输入执行后没有输出表示成功添加，再次查看文件状态

```bash
git status
# On branch master
# No commits yet
# Changes to be committed:
#   (use "git rm --cached <file>..." to unstage)
#         new file:   index.html

# 或者

git status -s
# A  index.html
```

发现文件index.html已被添加到Git进行管理并被跟踪，同时被放到了暂存区中准备提交，绿色的A表示是新添加到暂存区的文件

##### 5.3 提交更新

文件添加到暂存区后需要提交更新才会被**放到Git仓库中进行保存**，可以执行如下命令

```bash
git commit -m "新建了index.html文件"
# [master (root-commit) 9544d97] 新建了index.html文件
#  1 file changed, 0 insertions(+), 0 deletions(-)
#  create mode 100644 index.html
```

m 是message的缩写，表示对此次提交进行说明，再次检查文件状态

```bash
git status
# On branch master
# nothing to commit, working tree clean
```

表示所有的文件已被Git管理且处于未修改状态

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/tool/git/git1.png)



##### 5.4 修改已提交更新的文件

当我们修改了已提交更新的文件，比如index.html之后，再次检查文件状态

```bash
git status
# On branch master
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#         modified:   index.html
# no changes added to commit (use "git add" and/or "git commit -a")

# 或者
git status -s
# M index.html
```

发现文件index.html处于已修改状态，但是没有被提交到暂存区，红色的M表示文件处于已修改状态

##### 5.5 暂存已修改文件

index.html文件已被修改，需要先暂存到暂存区域中，只需要再次运行add命令

```bash
git add index.html
```

> add命令主要有3个作用：
>
> 1. 跟踪新文件并添加到暂存区
> 2. 将修改过后的已跟踪文件添加到暂存区
> 3. 将有冲突的文件标记为已解决

再次检查文件状态，发现先前是红色的modified和M已经变成了绿色，表示该文件已被添加到暂存区中

##### 5.6 提交暂存区文件

只需要再次运行提交更新命令即可

```bash
git commit -m "初始化了index.html文件的内容"
# [master 3157683] 初始化了index.html文件的内容
#  1 file changed, 10 insertions(+)
```

再次检查文件状态

```bash
git status
# On branch master
# nothing to commit, working tree clean
```

表示成功提交，所有文件处于未修改状态

##### 5.7 撤销对文件的修改

在工作区中对文件进行了修改，但是还没有把文件添加到暂存区，此时可以使用Git仓库中的文件版本覆盖这次修改，对比撤销前后的文件的sha256值，发现并不是同一个文件

> 注意覆盖后这次修改无法找回，需要谨慎操作

```bash
git checkout -- index.html
```

##### 5.8 一次性暂存多个文件

如果需要暂存的文件比较多，则可以使用如下命令将新建和修改的文件全部加入暂存区，常用

```bash
git add .
```

##### 5.9 取消暂存的文件

可以将已暂存的文件取消暂存

```bash
git reset HEAD index.html
```

##### 5.10 跳过暂存区直接提交

Git标准工作流程应该是先暂存再提交，有时候如果我们希望跳过暂存区直接提交到Git仓库，可以在commit的时候添加`-a`参数，这时Git会跳过add命令，直接将**已跟踪过的文件**暂存起来一起提交，对于新增的文件还是需要add，否则是未跟踪状态

```bash
git commit -a -m "描述消息"
```

##### 5.11 移除文件

移除文件有两种方式：

1. 将文件从工作区和Git仓库中同时移除

   ```bash
   git rm -f index.js
   ```

   检查文件状态，绿色的D表示文件被移除，同时此操作已进入暂存区，文件index.js也已从工作区中消失

   ```bash
   git status -s
   # D index.js
   ```

2. 只移除Git仓库的文件，保留工作区中的文件

   ```bash
   git rm --cache index.css
   ```

   检查文件状态，js和css前面都出现了绿色的D，表示在提交时，它们会被从Git仓库中移除，但同时css文件并没有从工作区中被移除，而是变成了未跟踪状态Untracked

   ```bash
   git status -s
   # D  index.css
   # D  index.js
   # ?? index.css
   ```

##### 5.12 忽略文件

在项目中的有些文件无需纳入版本管理，但是也不希望每次检查文件状态时它们都显示未跟踪状态，这时就可以忽略这些文件，方法是新建一个`.gitignore`文件，列出要忽略的文件列表

文件格式：

1. 注释以#开头
2. 以/结尾表示目录
3. 以/开头防止递归
4. 以!开头表示取反
5. 可以以简化的正则表达式匹配文件，即glob模式
   - `*`匹配0或多个字符
   - `?`匹配1个字符
   - `[abc]`匹配abc中的其中一个
   - `-`范围匹配
   - `**`匹配中间目录，如 a/**/z 可以匹配 a/b/z 或 a/b/c/z

```sh
# 忽略所有的 .a 文件
*.a
# 虽然忽略了所有的 .a 文件但唯独 lib.a 不被忽略
!lib.a
# 忽略当前文件夹下的TODO文件，但是子目录下的同名文件不被忽略，也就是防止了递归
/TODO
# 忽略所有名为build的文件夹
build/
# 忽略doc文件夹下的.txt文件，但子目录下的不被忽略
doc/*.txt
# 忽略doc文件夹及其子目录下的.pdf文件
doc/**/*.pdf
```

##### 5.13 查看提交历史

如果希望查看我们的提交历史记录，可以使用如下命令

```bash
# 按时间倒序列出所有的提交历史，如果记录太多会显示不完，按enter可继续浏览，按q退出
git log
# 只展示最新的2条提交历史，数字可自定义
git log -2
# 在一行上展示提交历史
git log -2 --pretty=oneline
# 在一行上以自定义的格式展示提交历史
# %h 提交的简写哈希值
# %an 作者名字
# %ar 作者修订日期
# %s 提交说明
git log -2 --pretty=format:"%h | %an | %ar | %s"
```

##### 5.14 回退到指定版本

首先我们需要找到要回退的版本的提交ID标识

```bash
git log --pretty=oneline
```

然后利用ID进行回退

```bash
git reset --hard <CommitID>
```

回退完成后再次查看提交历史，将看不到回退之前的提交历史，只能看到已回退的版本之前的提交历史

想查看**全部的提交历史**需要使用新命令，输出信息里面也包含了版本回退的操作历史

```bash
git reflog --pretty=oneline
```

这时又可以利用指定的ID号回退到任意指定版本

本地回退完成之后，远程分支并没有完成回退，所以如果不想留下回退版本之后的提交记录，可以强制推送本地的更新

```bash
git push -f
```

##### 5.15 储藏更改

可以将当前的改动暂时储藏起来，这会把暂存区和工作区的改动保存起来

什么时候可以用呢，比如我们在某个分支上进行了改动，但是突然发现这个分支并不是我们想要改动的分支，这时就可以将改动储藏起来转移到想要改动的分支上面

储藏改动：

```bash
git stash
# 可以添加save参数说明储藏情况
git stash save "备注"
# 列出当前储藏的改动列表，如果有多条储藏会列出各个储藏的id
git stash list
# 恢复最新的进度到工作区
git stash pop
# 恢复指定的进度到工作区,id由list命令获得
git stash pop stash@{1}
git stash pop stash@`{1`}  # 注意在vscode中{}需要转义
```

##### 5.16 拉取其它分支的某个文件

有时候需要拉取其它分支的某文件到当前分支

```bash
git checkout origin/master  /xxx/xxx/xxxx.file
```

#### 6 开源协议

软件一旦开源，意味着任何人可以来查看和修改源码，但是开源并不意味着完全没有限制，为了限制使用者对软件源码的使用范围和保护软件作者权益，每个开源项目都会选择一个开源协议（Open Source License）

常见的五种开源协议：

1. **GPL（GNU General Public License）**

   具有传染性的开源协议，因为如果使用GPL协议意味着修改后和衍生的代码也必须开源，不允许作为闭源商业软件发布销售

   使用GPL协议的著名项目：Linux

2. **MIT（Massachusetts Institute of Technology）**

   限制最小的协议，在修改代码或发布包中需要包含原作者的许可信息

   使用MIT协议的著名项目：jQuery、Node.js

3. BSD（Berkeley Software Distribution）

4. Apache License 2.0

5. LGPL（GNU Lesser General Public License）

#### 7 开源项目托管平台GitHub

主流的开源项目托管平台有三个，分别是GitHub、GitLab、Gitee，GitHub全球流行，现被微软收购，但是依然保持开源，GitLab私有支持好，Gitee是国内的平台，网络访问快，界面中文，它们都只能托管**用Git管理的**代码，我们主要来看看GitHub

GitHub是一个网站，要使用GitHub只需要注册账号即可，注册完成后可以新建Git仓库，Git仓库新建完成后就拥有一个位于GitHub服务器的远程Git仓库了

##### 7.1 备份到远程仓库

Git远程仓库有两种访问方式，分别是HTTPS和SSH

- HTTPS

  无需配置，但是每次访问时都需要输入GitHub的账号密码，略显繁琐

  1. 首先打开我们在GitHub的Git远程仓库，记下远程仓库的https链接地址，通常是如下格式

     ```bash
     # https://github.com/用户名/项目名.git
     https://github.com/ixcw/test.git
     ```

  2. 本地已有Git仓库就不用管了，如果本地没有Git仓库就新建一个，确保所有要管理的文件已提交更新，然后在本地Git仓库中执行如下命令

     ```bash
     # git远程添加到GitHub远程仓库地址，并将远程仓库命名为origin
     git remote add origin https://github.com/ixcw/test.git
     # 接着把本地Git仓库推送到GitHub远程仓库的主分支
     git push -u origin master
     ```

  3. 只有第一次推送需要运行第2步中的命令，以后的推送只需要执行如下命令即可

     ```bash
     git push
     ```

- SSH

  需进行配置，但是配置完成后访问无需输入账号密码，更加推荐这种方式

  想用SSH的方式访问Git远程仓库需要配置SSH Key，SSH Key就相当于是一把钥匙，有了它就能直接访问你的GitHub账号而无需每次输入密码验证，配置完成后可以实现**免登录加密数据传输**，SSH Key由两部分组成，分别是私钥和公钥

  私钥：`id_rsa`，是一个文件，存放于客户端的电脑，也就是本地

  公钥：`id_rsa.pub`，也是一个文件，**其内容**存放于GitHub服务器

  1. 检查本地是否已存在私钥文件

     ```bash
     # 列出用户主目录下是否存在.ssh文件夹和里面是否有文件，Windows系统一般是这个路径：C:\Users\用户名\.ssh
     ls -al ~/.ssh
     ```
  
     如果列出了`id_rsa`等文件，证明已经有私钥了，之前已配置过SSH，如果想重新配置，也可以将其删除重新配置

  2. 生成SSH Key

     ```bash
     ssh-keygen -t ed25519 -C "228295392@qq.com"
     ```
  
     如果电脑太旧不支持ed25519算法，也可以使用如下算法

     ```bash
     ssh-keygen -t rsa -b 4096 -C "228295392@qq.com"
     ```
  
     > 参数说明：
     >
     > `-t ed25519` 或者 `-t rsa`：表示使用rsa算法或者ed25519算法
     >
     > `-b 4096`：表示密钥长度为4096bits，默认为2048bits，ed25519算法无需指定
     >
     > `-C`：表示在公钥文件中添加注释为这个公钥起别名
     >
     > ed25519与rsa区别：
     >
     > ed25519算法相比rsa算法的验证性能更高且更安全，GitHub官方推荐使用
     
     如果成功生成，则会在`.ssh`文件夹下生成两个文件，分别是私钥文件`id_ed25519`和公钥文件`id_ed25519.pub`，如果是rsa算法则是`id_rsa`和`id_rsa.pub`
  
  3. 打开生成的公钥文件，复制里面的内容，然后到GitHub网站登录账号找到设置，找到SSH Key，添加新的SSH Key，将复制的公钥内容粘贴到SSH Key中，标题处填写描述信息，表明这个Key是哪个设备的Key，点击添加会要求输入GitHub账号密码进行验证，验证即可

  4. 测试SSH连接，看是否配置成功

     ```bash
     # 尝试通过SSH连接到GitHub
     ssh -T git@github.com
     # The authenticity of host 'github.com (20.205.243.166)' can't be established.
     # ECDSA key fingerprint is SHA256:xxxxxx.
     # Are you sure you want to continue connecting (yes/no/[fingerprint])?
     ```
  
     输入yes，出现如下提示表示配置成功，`.ssh`文件夹下会生成一个`known_hosts`文件，记录host记录
  
     ```bash
     # Warning: Permanently added 'github.com,20.205.243.166' (ECDSA) to the list of known hosts.
     # Hi ixcw! You've successfully authenticated, but GitHub does not provide shell access.
     ```
  
  
   配置完成后就可以使用SSH的方式上传本地Git仓库到GitHub远程仓库了，和HTTPS的方式类似，不过HTTPS链接要改为SSH的链接
  
  ```bash
  # git远程添加到GitHub远程仓库地址
  git remote add origin https://github.com/ixcw/test.git
  # 接着把本地Git仓库推送到GitHub远程仓库的主分支
  git push -u origin master
  ```
  
  > 如果一个本地仓库之前已经用HTTPS的方式上传过代码了，那么再用SSH的方式上传会报错
  >
  > ```bash
  > fatal: remote origin already exists.
  > ```
  >
  > 原因是一个本地仓库对应一个远程仓库，不能再次添加新的连接，如果非要修改的话可以先删除原有的连接关系
  >
  > ```bash
  > git remote rm origin
  > ```
  >
  > 然后再添加就可以了

##### 7.2 从远程仓库克隆

从Git远程仓库克隆其代码只需选好要保存的文件夹位置，然后打开git bash执行如下命令

```bash
# git clone 远程仓库地址（可以是SSH或者HTTPS链接）
git clone git@github.com:ixcw/test.git
```

完成后即可将远程仓库克隆到本地，需要注意的是本地仓库中被Git忽略管理的文件在远程仓库中是不存在的，因此克隆下来的仓库中这些文件也不存在

##### 7.3 分支

Git中有分支的概念，类似于平行宇宙，不同的分支可用于开发不同的功能，最后可以将这些分支合并到一起，这样就完成了多功能的开发，有利于多人合作，每个人开发自己的分支，大家互不干扰

1. master主分支

   在我们初始化Git项目的时候，Git已经帮我们建立了一个主分支master

   在实际工作中，master主分支的作用就是保存记录整个项目**已完成功能的代码**，只有完成的功能代码可以提交到主分支上面

2. 功能分支

   就是用于开发新功能的分支，是临时从master分支上分叉出来的，新功能开发测试完成后需要合并回主分支

3. 查看分支列表

   ```bash
   git branch
   # * master
   ```

   由于当前只有master分支，故只列出了master分支，在分支的前面有一个*号，表明当前所处的分支是哪一个

4. 创建新的分支

   ```bash
   # git branch 新分支名称
   git branch login
   
   # 再次查看分支列表
   git branch
   #   login
   # * master
   ```

   创建分支的操作是基于当前所处分支创建的，新分支会完全克隆所基于的分支，两者的代码完全一致

   创建分支完成后，当前所处分支不会改变，除非手动切换

5. 切换分支

   ```bash
   # git checkout 分支名称
   git checkout login
   # Switched to branch 'login'
   ```

   出现如上输出表示切换成功，同时发现命令行提示变成了`(login)`，表示当前所处分支是login分支

   有时候，如果觉得每次都要执行两条命令有点麻烦，可以将两条命令合并成一条来写，可以立即创建并切换到新分支（果然懒是第一生产力）

   ```bash
   # 先切换回master主分支，建议新建分支都从master分支新建
   git checkout master
   
   git checkout -b reg
   # Switched to a new branch 'reg'
   
   git branch
   #   login
   #   master
   # * reg
   ```

6. 合并分支

   当新功能开发完毕，需要将其合并到主分支，需要将A分支的代码合并到B分支，则需要先切换到B分支再合并A分支

   ```bash
   # 因为要合并到主分支，所以先切换到主分支
   git checkout master
   # Switched to branch 'master'
   # Your branch is up to date with 'origin/master'.
   ```

   切换回主分支时，会提示分支和主分支更新保持一致了，这时去工作文件夹查看，发现login的功能代码文件不见了，而是变为了主分支的代码文件，因为此时我们已经切换回了主分支，理应工作区中只有主分支的代码文件，下面执行分支合并命令

   ```bash
   git merge login
   # Updating 7fd98d8..d190950
   # Fast-forward
   #  login.css  |  9 +++++++++
   #  login.html | 13 +++++++++++++
   #  2 files changed, 22 insertions(+)
   #  create mode 100644 login.css
   #  create mode 100644 login.html
   ```

   显示如上信息表示合并成功，工作区的代码文件也增加了login的代码文件

   如果不小心误合并，可以撤销合并

   ```bash
   git merge --abort
   ```

7. 删除分支

   当我们把功能分支的代码合并到主分支上以后，功能分支就失去了它的作用，可以卸磨杀驴了（不是）

   ```bash
   git branch -d login
   # Deleted branch login (was d190950).
   ```

   > 注意删除分支时不能处于该分支上

   再次检查分支列表，login分支已经消失

   ```bash
   git branch
   # * master
   #  reg
   ```

8. 合并冲突分支

   在多人合作开发中，难免会遇见不同的人对同一个文件进行了修改的情况，这时Git不知道具体修改了什么内容，就不能合并了，如果强行合并可能导致代码逻辑错乱，这时就产生了合并冲突，这种情况下我们只能选择**手动解决冲突** **手动解决冲突** **手动解决冲突**

   当我们在reg分支和master分支上都修改了index.html文件之后，在master分支合并reg分支，就会出现如下提示

   命令行的提示变成了`(master|MERGING)`，表明出现了冲突，正在合并中，需要先解决冲突再合并分支

   ```bash
   git merge reg
   # Auto-merging index.html
   # CONFLICT (content): Merge conflict in index.html
   # Automatic merge failed; fix conflicts and then commit the result.
   ```

   我们在master分支下手动打开index.html文件，发现vscode已经帮我们贴心地标记出了产生冲突的地方，如下图所示

   ![](https://cdn.jsdelivr.net/gh/ixcw/note/images/tool/git/git2.png)

   并且vscode为我们提供了选项，是保留当前修改，还是保留合并分支的修改，还是保留双方的修改，都由我们自己判断选择，甚至为了帮助我们判断，还有比较文件改变的选项，那我们自然要用一用了，点击比较改变，这时编辑器会分裂为2部分，左边显示当前修改，右边显示合并分支的修改，同时标记出不同点，然后我们就根据自己的需要去判断解决冲突

   解决完毕冲突之后，执行如下命令告知Git冲突已解决，重新提交更新

   ```bash
   git add .
   git commit -m "解决了master分支和reg分支的合并冲突"
   ```

   执行完毕后就成功合并了冲突分支

9. 将本地分支推送到远程仓库

   第一次推送分支，需要执行如下命令

   ```bash
   # git push -u 远程仓库别名 本地分支:远程分支
   git push -u origin master:master
   # 如果希望远程分支和本地分支命名一致，则可以简化命令
   git push -u origin master
   ```

   第二次及以后只需要执行`git push`命令即可

10. 查看远程分支

    ```bash
    # git remote show 远程仓库名称
    git remote show origin
    # * remote origin
    #   Fetch URL: https://github.com/ixcw/test.git
    #   Push  URL: https://github.com/ixcw/test.git
    #   HEAD branch: master
    #   Remote branches:
    #     main     new (next fetch will store in remotes/origin)
    #     master   tracked
    #     register tracked
    #   Local branches configured for 'git pull':
    #     master merges with remote master
    #     reg    merges with remote register
    #   Local ref configured for 'git push':
    #     master pushes to master (fast-forwardable)
    ```

11. 跟踪分支

    跟踪分支指的是从远程仓库中把远程分支下载到本地仓库中

    ```bash
    # 从远程仓库中下载远程分支到本地仓库，本地分支和远程分支的命名一致
    # git checkout 远程分支名称
    git checkout register
    # Switched to a new branch 'register'
    # Branch 'register' set up to track remote branch 'register' from 'origin'.
    
    # 从远程仓库中下载远程分支到本地仓库，本地分支和远程分支的命名不一致
    # git checkout -b 本地分支名称 远程仓库名称/远程分支名称
    git checkout -b reg origin/register
    # Switched to a new branch 'reg'
    # Branch 'reg' set up to track remote branch 'register' from 'origin'.
    ```

    远程分支下载后会立即切换到该分支	

12. 拉取远程分支的最新代码

    有时候远程分支的代码比本地代码更新，我们需要拉取远程分支的最新代码到本地，使得两者保持一致

    ```bash
    git pull
    # remote: Enumerating objects: 9, done.
    # remote: Counting objects: 100% (9/9), done.
    # remote: Compressing objects: 100% (6/6), done.
    # remote: Total 7 (delta 1), reused 0 (delta 0), pack-reused 0
    # Unpacking objects: 100% (7/7), done.
    # From https://github.com/ixcw/test
    #    a3fc6cb..81bd9f7  register   -> origin/register
    #  * [new branch]      main       -> origin/main
    # Updating a3fc6cb..81bd9f7
    # Fast-forward
    #  index.js | 1 +
    #  1 file changed, 1 insertion(+)
    ```

13. 删除远程分支

    ```bash
    # git push 远程仓库名称 --delete 远程分支名称
    git push origin --delete register
    # To https://github.com/ixcw/test.git
    #  - [deleted]         register
    ```

    删除本地分支时如果分支代码没有合并到主分支会报错，但是也可以改变参数为大写强行删除，或者合并之后再删除

    ```bash
    git branch -d reg
    # error: The branch 'reg' is not fully merged.
    # If you are sure you want to delete it, run 'git branch -D reg'.
    
    git branch -D reg
    ```

14. 推送本地分支到远程分支

    ```bash
    # 前面个dev是本地分支，后面个dev是远程分支，名字相同可简写
    git push origin dev:dev
    ```

##### 7.4 Git提交流程简化

将三条命令简化为一条
```cmd
git add .
git commit -m "message"
git push
```

变为

```cmd
git cmp "message"
```

向`.gitconfig`文件添加了一个别名：

```text
[alias]
    cmp = "!f() { git add -A && git commit -m \"$@\" && git push; }; f"
```

也可以在命令行使用命令更改：

```cmd
git config --global alias.cmp '!f() { git add -A && git commit -m "$@" && git push; }; f'
```
