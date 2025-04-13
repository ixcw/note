#### 1 快捷键

快捷键 | 作用
-|-
`Alt + Enter`      | 智能提示
`double press Shift` or `Ctrl + Alt + A` | 搜索类、文件、操作、设置等等
`Ctrl + N`         | 搜索类
`Ctrl + Q`         | 查看类的帮助文档
`Ctrl + Space`     | 补全代码
`Ctrl + Shift + Enter` | 补全分号，完成语句
`Ctrl + W`         | 选择代码
`Ctrl + /`         | 注释
`Ctrl + D`         | 复制
`Ctrl + Y`         | 删除
`Alt + Shift + ↓` or `Alt + Shift + ↑`  | 移动一行，会与下（上）一行互换位置
`Ctrl + Shift + ↓` or `Ctrl + Shift + ↑`  | 移动整个方法，光标应该在方法上 
`Ctrl + -` or `Ctrl + +` | 折叠或者展开方法 
`Ctrl + Shift + -` or `Ctrl + Shift + +` | 折叠或者展开整个文件中的方法 
`Ctrl + Alt + T`         | 选中代码，添加 try catch
`Ctrl + shift + Delete`   | 选中代码，取消 try catch
`Alt + J`         | 选中标签
`Alt + Shift + J`         | 取消选中标签
`Ctrl + Alt + Shift + J`         | 选中文件中的所有相同标签（然后可以打字替换）
`Ctrl + Alt + L`         |    格式化代码
`Alt + Insert`     |      生成 getter() setter() tostring() 等方法 
`Ctrl + O`         |      重写方法
`Ctrl + I`         |      实现方法
`Ctrl + E`         |      最近使用的文件
`Shift + F6` | 智能重命名变量 

#### 2 代码快速生成

- `psvm`：生成main方法

- `sout`：生成输出

- `5.fori`：生成for循环，循环5次

- `iter`：增强for循环

#### 3 Live Template

可以把常用的一些代码片段做成模板，到时候写缩写就会智能提示

路径：`setting` ->  `Editor` -> `Live Template` -> `+` -> `Template Group` -> `Live Template`，填好缩写，代码片段就可以了

#### 4 设置项目默认文件夹

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/software/idea/default-project-directory.png)

#### 5 配置tomcat

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/software/idea/config-tomcat.png)

#### 6 配置maven

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/software/idea/config-maven.png)

#### 7 配置主题

插件中心搜索`Material Theme UI`，选择`Night Owl`或者`Deep Ocean`，配置代码字体可以到`setting` -> `editor` -> `font`

#### 8 配置背景图片

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/software/idea/background-image.png)

#### 9 配置参数提示

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/software/idea/code-completion.png)

#### 10 创建web项目

1. 新建maven项目，定义好名称
2. 设置项目结构，新增module，选择web：
   - 设置部署描述路径为`src\main\webapp\WEB_INF\web.xml`
   - 设置项目web资源目录为`src\main\webapp`
   - 设置默认artifact
3. 配置运行/调试配置，选择Tomcat Server：
   - 配置tomcat目录，端口默认是8080，可改为80
   - 配置Deployment，添加默认的artifact，设置访问路径
4. 在webapp下新建`index.html`，运行，即可在浏览器访问

>项目在pom.xml添加了jar包后，打包运行项目时如果报找不到类的错误，是因为jar包没有发布到lib目录，需要设置项目结构，在Artifacts中将jar包添加到lib目录发布就可以了，在pom中配置了scope为test和provided的jar包不会发布到这里，如果以后添加了新的jar包，记得同时修改这里添加jar包发布

#### 11 生成 apifox 文档

1. 在 apifox 软件中点击设置，打开 API 访问令牌，新建一个令牌，获取 token，期限可以选择无限期，以方便使用，比如生成了如下令牌：

   ```sh
   APS-jO6Kk3dAUmATLook0eooxaCPR1p4b3ai
   ```

2. 在 idea 中安装 Apifox Helper 插件，然后打开设置，打开一级目录下的 Apifox Helper 设置，选择上传到 Apifox，将上诉令牌填入 Api 访问令牌，点击测试令牌，显示成功，确定设置

3. 设置代码模块与 Apifox 项目的对应关系，点击添加，选择代码模块，一般就是当前项目，然后下方会显示上传至，会出现 Apifox 上存在的项目，选中其中一个项目，确认设置

4. 可以在 idea 左侧的项目文件目录上右键具体的 controller 包选择 Upload to Apifox，也可以在 idea 右侧选择 Apifox 的图标，然后选中接口目录，右键选择上传到 Apifox，等待命令行输出上传结果，即可上次成功，打开 Apifox 软件，即可看见刚刚上传的接口文档



























