#### 1 简介

JavaScript代码之所以能在浏览器中解析执行是因为浏览器中有JavaScript解析引擎，不同的浏览器的解析引擎内核是不一样的，例如Chrome的是Blink，火狐的是Gecko，苹果是WebKit，V8引擎是Blink内核内置的JS引擎，目前性能是最好的

原生js操作网页元素的API就是浏览器的解析引擎内核提供的，脱离了浏览器环境这些API自然也就不管用了

由于js这门语言的快速发展，大家不满足于只在浏览器里使用js，可不可以在后端也使用js呢？可以，有人就把浏览器里的内核引擎给《搬》出来放到了服务器里，这样即使脱离了浏览器环境，只要有内核能够解析js，js就可以执行，[Node.js](https://nodejs.org/zh-cn/)就是这样一款内核，它是从Chrome浏览器里提取出来的，基于V8引擎，性能不错

浏览器内核有浏览器专用的API，放到服务器上自然就没用了，于是nodejs取消掉了这些API，重新增加了一些给后端专用的API

随着nodejs的发展，围绕其生态的工具和框架也越来越多：

- express框架可以用于构建web应用的后台
- electron框架可以用于构建跨平台的桌面端应用（Windows、Linux、Mac）
- restify框架可以构建API接口

#### 2 安装

##### 2.1 普通安装

官网下载安装包，一般安装LTS长期支持版本，比较稳定，一路next安装即可

打开cmd或powershell，输入命令验证安装，打印出版本号即表示安装成功

```bash
node -v
```

##### 2.2 nvm

node有具体的版本，然而不同的项目依赖的node版本可能是不一样的，这就导致只安装单一个版本的node并不能兼容所有的项目，于是就有人就开发了nvm这款工具用来管理node版本

1. 安装nvm

   可以到github上下载[nvm](https://github.com/coreybutler/nvm-windows/releases)，安装完成后打开终端输入命令验证安装

   ```powershell
   nvm
   ```

2. 使用nvm切换node版本

   ```bash
   # 查看当前安装的node版本
   nvm list
   # 列出可安装的 node 版本
   nvm list available
   # 安装指定的 node 版本
   nvm install 17.9.0
   # 使用指定的 node 版本
   nvm use 17.9.0
   ```

#### 3 使用

编写完js代码后，在代码同级目录下打开终端输入如下命令即可使用node去解析执行js代码了

```sh
node hellonode.js  # hello node
```

#### 4 fs文件系统模块

了解完如何使用node执行js代码，接下来就是学习与node相关的API了，先来学习文件系统相关的API

fs模块是node官方提供的用于操作文件的模块，首先在代码文件开头引入该模块

```js
const fs = require('fs')
```

##### 4.1 读取文件内容

语法：

```js
fs.readFile(path [,options], callback)
// path: 文件路径，字符串
// options：以什么编码格式读取
// callback：回调函数，拿到读取结果
```

例子：

```js
const fs = require('fs')
fs.readFile('./files/1.txt', 'utf8', function (err, res) {
  console.log(err)
  console.log(res)
})
// null
// test content
```

可见可以通过判断err的值来确定是否读取成功

```js
fs.readFile('./files/11.txt', 'utf8', function (err, res) {
  if (err) {
    return console.log('读取失败：' + err.message)
    // 读取失败：ENOENT: no such file or directory, open 'D:\**\files\11.txt'
  }
  console.log('读取成功：' + res) // 读取成功：test content
})
```

##### 4.2 写入文件内容

语法：

```js
fs.writeFile(path, data [,options], callback)
// path: 文件路径，字符串
// data：要写入的内容
// options：以什么编码格式写入，默认utf8
// callback：回调函数，拿到写入结果
```

例子：

```js
fs.writeFile('./files/2.txt', 'abc', function (err) {
  console.log(err) // null
})
```

err为null表示写入成功，文件路径如果不存在则会自动新建一个文件写入，判断是否写入成功的方法与读取文件类似

##### 4.3 动态路径拼接

在使用fs模块时，如果提供的文件路径是相对路径，很容易发生路径的拼接错误

原因是代码运行时，文件路径 = node的运行目录 + 相对路径

node运行目录和js文件处于同一目录时没有问题，但目录不同时，拼接的路径就会发生错误

因此我们可以直接提供绝对路径而不提供相对路径，这样无论node在哪里执行，都不会出错，这就解决了问题

```js
fs.readFile(
  'D:\\MEGAsync\\技术\\前端\\NodeJS\\code\\files\\1.txt',
  'utf8',
  function (err, res) {
    if (err) {
      return console.log('读取失败：' + err.message)
    }
    console.log('读取成功：' + res)
  }
)
```

但是只提供绝对路径的话，移植性非常差，不利于维护，原因在于如果代码未来迁移到别的机器，根路径很有可能发生改变，但是绝对路径已经被写死，就会因为路径错误导致读取失败

node官方自然也考虑到了这个问题，于是给我们提供了一个字符串对象`__dirname`，该对象的值表示**当前的代码文件的所在目录**，这个值会根据机器的不同自动变更为对应的绝对路径，这样就**完美**地解决了路径容易拼错的问题

```js
console.log(__dirname) // D:\MEGAsync\技术\前端\NodeJS\code

fs.readFile(__dirname + '/files/1.txt', 'utf8', function (err, res) {
  if (err) {
    return console.log('读取失败：' + err.message)
  }
  console.log('读取成功：' + res) // 读取成功：test content
})
```

#### 5 path模块

path模块是node官方提供的用于处理路径的模块

##### 5.1 拼接路径

语法：

```js
path.join([...paths])
```

传入多个路径片段拼接成完整路径，虽然前面直接用加号也能拼接，但是这个方法更正规一些，因为如果加号拼接相对路径时不小心加了`.`则会导致错误，而join不会

```js
const path = require('path')
let pathStr = path.join('/a', '/b/c', '../d', './e')
console.log(pathStr) // \a\b\d\e   ..会抵消一层目录

let pathStr1 = __dirname + './files/1.txt'
let pathStr2 = path.join(__dirname, './files/1.txt')
console.log('pathStr1', pathStr1) // pathStr1 D:\MEGAsync\技术\前端\NodeJS\code./files/1.txt
console.log('pathStr2', pathStr2) // pathStr2 D:\MEGAsync\技术\前端\NodeJS\code\files\1.txt
```

##### 5.2 获取路径中的文件名和拓展名

获取文件名

语法：

```js
path.basename(path [,ext])
// ext：文件拓展名，如果提供则返回的文件名会删掉文件拓展名
```

例子：

```js
const path = require('path')
let fpath = '/a/b/c/index.jpg'
let filename = path.basename(fpath)
let filenameNoExt = path.basename(fpath, '.jpg')
console.log('filename', filename) // filename index.jpg
console.log('filenameNoExt', filenameNoExt) // filenameNoExt index
```

获取拓展名

语法：

```js
path.extname(path)
// path：文件路径字符串
```

返回值是文件拓展名

例子：

```js
const path = require('path')
let fpath = '/a/b/c/index.jpg'
let extName = path.extname(fpath)
console.log('extName', extName) // extName .jpg
```

#### 6 http模块

http是node官方提供的用于创建网络服务器的模块，创建的步骤也很简单，只需要调用创建服务器的方法就可以了

```js
// 1. 导入http模块
const http = require('http')
// 2. 创建服务器对象
const server = http.createServer()
// 3. 为服务器绑定请求事件，监听客户端的请求
server.on('request', function (req, res) {
  console.log('hello guest!')
})
// 4. 启动服务器
server.listen(80, () => {
  console.log('server running at localhost')
})
```

使用node命令执行这个js文件，就启动了服务器，执行了listen方法中的回调函数，终端打印出了`server running at localhost`

##### 6.1 req对象

req对象包含了客户端的相关属性和数据

```js
server.on('request', function (req, res) {
  console.log('hello guest!')
  console.log(req.url) // /  
  console.log(req.method) // GET
})
```

##### 6.2 res对象

res对象包含了服务器的相关属性和数据

```js
server.on('request', function (req, res) {
  console.log('hello guest!')
  console.log(req.url) // /
  console.log(req.method) // GET
  // end方法是向客户端响应内容，并且结束这次请求处理
  res.end(`your request url is ${req.url}, request method is ${req.method}`)
})
```

在网页上就会看到响应的话

```html
your request url is /, request method is GET
```

end方法直接响应中文会出现乱码，需要先设置响应头

```js
res.setHeader('Content-Type', 'text/html;charset=utf-8')
res.end(`你的请求路径是${req.url}，请求方法是${req.method}`)
```

##### 6.3 不同url响应不同内容

先获取请求的url，然后if else判断返回响应

```js
server.on('request', function (req, res) {
  const url = req.url
  let content = '<h1>404 NOT FOUND!</h1>'
  if (url === '/' || url === '/index.html') {
    content = 'index'
  } else if (url === '/about.html') {
    content = 'about'
  }
  res.setHeader('Content-Type', 'text/html;charset=utf-8')
  res.end(content)
})
```

##### 6.4 响应文件内容

利用请求路径和当前路径拼接为访问文件的路径，然后用fs模块读取文件，将读取内容响应给客户端

#### 7 模块化

模块化是指在解决复杂问题时，自顶向下将复杂问题分解为若干模块的过程，各个模块是可组合、分解、更换的单元，编程中的模块化就是按照**固定规则**将一个大文件拆分为各个独立互相依赖的小模块，模块化提高了代码复用性、可维护性，做到了按需加载

##### 7.1 模块化规范

模块化规范就是模块化过程中需要遵守的**固定规则**，比如以什么格式来引用模块，以什么格式导出模块，大家都遵循固定规则有利于互相合作

node遵守了CommonJS模块化规范，该规范规定：

1. 每个模块内部，module对象代表当前模块
2. module对象的exports对象是对外接口
3. 加载模块其实就是加载`module.exports`对象

看了下面几节你就会明白node就是遵守了该规范而设计的

##### 7.2 node模块化

在node中模块可分为三类：

1. 内置模块

   内置模块就是由node官方提供的模块，比如fs模块、path模块、http模块等

2. 自定义模块

   用户自己写的js文件其实就是自定义模块

3. 三方模块

   由第三方开发的模块，既不是自己写的也不是node提供的模块就是三方模块，使用前需下载导入

##### 7.3 加载模块

前面已经使用过的`require()`方法就可以加载模块

```js
const fs = require('fs')
// 加载自定义模块需指明路径
const custom = require('./custom.js') // const custom = require('./custom') 也可以
const third = require('third')
```

> 使用`require()`加载模块时会执行模块其中的代码

##### 7.4 模块作用域

在自定义模块中定义的变量、方法等只能在当前模块中访问，这种模块级别的访问限制就是模块作用域，防止了全局变量污染的问题，所谓全局变量污染就是指使用script标签引入js文件时，不同文件定义的相同名字的全局变量会覆盖

那么我们想将模块中的成员共享出去又怎么办呢，可以使用module对象，在每个自定义模块中都存在一个module对象，存储了和当前模块有关的信息，里面有个对象叫exports，通过它可以共享成员，通过require()导入模块时得到的就是exports对象，默认情况下自定义模块的exports对象是一个空对象，所以打印通过require()导入的模块会是一个空对象

```js
const module1 = require('./module1')
console.log(module1) // {}
```

利用exports对象可以向外共享成员，这样就可以将自己想共享出去的成员共享给别的模块使用，没有共享的成员，别的模块无法访问

```js
// 在module1模块中给exports添加属性和方法
const age = 20
module.exports.username = '张三'
module.exports.sayHello = function () {
  console.log('hello')
}
module.exports.age = age

// 在module模块中引入module1模块
const module1 = require('./module1')
console.log(module1) // { username: '张三', sayHello: [Function (anonymous)], age: 20 }
```

由于`module.exports`写起来比较麻烦，node又提供了简略写法`exports`

```js
console.log(module.exports) // {}
console.log(exports) // {}
console.log(exports === module.exports) // true，可见指向的是同一个对象
```

但是需要谨记的是通过`require()`导入的模块得到的永远是`module.exports`对象，改变了`exports`对象的指向不会影响这个结果，只是为了防止混乱，最好统一使用`module.exports`或者`exports`，不要混用

#### 8 npm与包

node中第三方模块可简称为包，node中的包都是免费开源的

由于node内置模块的功能有限，仅仅基于这些基础功能开发效率很低，于是许多三方开发者就自己开发封装出了很多实用的三方包，提供了一些拓展功能

[npm](https://www.npmjs.com/)是国外的一家公司，GitHub已于2020年收购了npm，但是依然保持免费

npm全称为Node Package Manager，即node包管理器，是nodejs默认的包管理器，同时npm也是全球最大的包管理分享平台，各种各样的三方包在上面进行开源分享

为什么要去使用别人分享的包呢？很简单，你不用别人的包那就得自己写，相同的功能，别人已经写好了，为什么不用呢，除非你能写出更好的，不然找不到自己去费时费力手写的理由，这就像你要把钉子砸进墙里，这时别人给你递过来一把锤子，但你说不，我要自己造一把锤子（？）

比方说你需要一个格式化时间的功能，下面是自己手写的过程：

`dateFormat.js`：

```js
/**
 * 格式化时间
 * @param {*} dateStr 时间字符串
 * @returns 格式化后的时间字符串
 */
function dateFormat(dateStr) {
  const dt = new Date(dateStr)
  const y = padZero(dt.getFullYear())
  const m = padZero(dt.getMonth() + 1)
  const d = padZero(dt.getDate())
  const hh = padZero(dt.getHours())
  const mm = padZero(dt.getMinutes())
  const ss = padZero(dt.getSeconds())
  return `${y}-${m}-${d} ${hh}:${mm}:${ss}`
}

/**
 * 补零函数
 * @param {*} n 数字
 * @returns 补零数字
 */
function padZero(n) {
  return n > 9 ? n : '0' + n
}

module.exports = {
  dateFormat
}
```

`dateTest.js`：

```js
const df = require('./dateFormat')
const dt = new Date()
let formattedDate = df.dateFormat(dt)
console.log('formattedDate', formattedDate) // formattedDate 2021-12-23 01:51:44
```

然后使用三方包来格式化时间，只需三行代码，不需要我们去写自定义模块，是不是省了很多力气

```js
const moment = require('moment')
const dt = moment().format('YYYY-MM-DD HH:mm:ss')
console.log(dt) // 2021-12-23 02:05:12
```

当然直接导入包是不行的，我们得先下载包，node贴心地为我们准备了终端命令行工具npm，直接使用即可

```sh
npm install 包名1 包名2 # 等价于 npm i 包名1 包名2
```

执行命令后就会在项目文件夹下新生成一个`node_modules`文件夹，里面存放着下载下来的包，同时也会生成一个`package.json`和`package-lock.json`文件，这两个文件后面介绍，安装完成后就可以正常导入包了

如果想指定包的版本号，可以加`@`，新安装的版本会覆盖旧版本
>版本号的含义：第一位数字表示大版本更新，第二位表示功能更新，第三位表示bug修复更新，如果前面的数字更新了，则后面的数字需要从零开始

```sh
npm i moment@2.22.2
```

##### 8.1 包管理配置文件

就是项目根目录下自动生成的`package.json`文件，npm安装包时会自动生成，记录了项目信息，包的配置信息，我们不要手动修改这两个文件，它们由npm自动维护，为什么要有这个文件呢，下面来分析一下

由于三方包往往包含了大量的细小文件，这些细小文件数量众多，我们知道当文件数量太多时，磁盘间的文件传输效率会大大降低，而且众多的文件也增大了项目的体积，往往一个项目本身的源代码所占体积不大，反而三分包占据了项目90%以上的体积，这就非常不利于多人合作时共享项目代码，所以如果我们将这些三方包也加入到版本管理中就会非常麻烦

这时有人想到，三方包本身就在npm共享平台上，大家都可以下载，如果用一个文件来记录包的信息，比如包的名称、版本号等，大家只要有这个记录文件，就能从npm上下载到一模一样的包，这样在多人合作时就可以不用将这个体积巨大的包文件夹加入版本管理，仅仅共享项目本身的源代码和记录文件，这样就完美解决了项目体积过大、项目文件过多的问题，而这个记录文件就是`package.json`文件

##### 8.2 快速生成配置文件

在不安装任何包的情况下也可以直接创建包管理配置文件
> 项目文件夹名字不能是中文，不能出现空格，否则报错不能执行

```sh
npm init -y  # -y：对默认选项进行确认，使用默认选项
```

生成的文件内容

```json
{
  "name": "chinese",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
```

在使用npm安装包时，npm会自动记录包名称和版本号到这个文件，所以一般不用我们手动修改该文件，在npm安装包之后，会多出一个`dependencies`节点，节点用于记录包名和版本号

```json
{
  "name": "chinese",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "moment": "^2.29.1"
  }
}
```

此外在安装包时npm会自动生成一个`package-lock.json`文件，为什么需要这个文件呢

因为`package.json`文件只能锁定大版本，也就是版本号的第一位，并不能锁定后面的小版本，每次`npm install`都是拉取的该大版本下的最新的版本，为了稳定性考虑我们几乎是不敢随意升级依赖包的，这将导致多出来很多工作量去测试和适配

所以`package-lock.json`文件出的功能就是当你每次安装一个依赖的时候就将其锁定在你安装的这个版本，以确保版本一致


##### 8.3 一次性安装所有的包

当我们拿到别人共享的项目文件时，包文件夹`node_modules`是没有被共享的，需要我们重新下载生成，我们可以直接运行命令

```sh
npm i # 等价于 npm install
```

这条命令并没有加包名而是直接使用了安装命令，这是因为它会自动读取项目文件夹下的包配置文件`package.json`里的`dependencies`节点记录的包的相关信息（包名和版本号），从而一次性将里面记录的包全部下载下来安装

##### 8.4 卸载包

当我们不再需要某个包时，仅仅删除包文件夹里的包是不行的，下次使用命令安装时还会被下载回来，正确做法是使用命令卸载包

```sh
npm uninstall 包名  # 会将包文件夹里的包和配置文件里的记录同时删除
```

##### 8.5 查看已安装的包

可以查看当前都安装了哪些包，方便管理，depth指定查看深度，0表示只列出版本号，方便查看，需要查看全局的包加上`-g`参数

```sh
npm ls --depth 0
```

##### 8.6 开发依赖

有些包只在开发阶段用得到，项目开发完成之后，上线运行时并不需要使用这些包，比如webpack，这时可以将这些包记录在开发依赖`devDependencies`里面，而在开发和上线都需要用到的包则依然放在`dependencies`里面，在安装包的时候添加参数`--save-dev`就可以将包放进`devDependencies`里面

```sh
npm i 包名 --save-dev  # 或者 npm i 包名 -D
```

##### 8.7 npm镜像

因为npm是外国网站，下载东西难免会比较慢，热心的淘宝在国内为我们搭建了一个镜像服务器，每隔一段时间就会去同步npm上的包，将npm的安装源切换成淘宝镜像就可以直接到淘宝镜像上面下载包了，提高了我们的下载速度

```sh
# 检查安装源
npm config get registry
# 设置安装源
npm config set registry=https://registry.npm.taobao.org/
```

设置完成之后会在`C:\Users\用户名\`路径下生成一个`.npmrc`配置文件，里面的内容就是

```txt
registry=https://registry.npm.taobao.org/
```

所以我们不用命令直接创建这个文件也是可以的，不过命令会更方便

另外我们还可以安装一个名叫`nrm`的包，这个包专门用于管理安装源地址，而且是实时更新的，相比于记住上面的淘宝镜像地址，这个用起来**更简单**

```sh
# 全局安装nrm
npm i nrm -g

# 列出可用的安装源
nrm ls
# npm ---------- https://registry.npmjs.org/
# yarn --------- https://registry.yarnpkg.com/
# tencent ------ https://mirrors.cloud.tencent.com/npm/
# cnpm --------- https://r.cnpmjs.org/
# taobao ------- https://registry.npmmirror.com/
# npmMirror ---- https://skimdb.npmjs.com/registry/

# 使用安装源
nrm use taobao
# Registry has been set to: https://registry.npmmirror.com/
```

可以看到淘宝镜像的地址发生了变化，所以我们用这个小工具安装新的淘宝源就可以了，不用去记淘宝镜像的地址

##### 8.8 包的分类

包可以分为项目包和全局包

- 项目包

  被安装到项目的`node_modules`文件夹下的包就是项目包，只在这个项目内生效，项目包可继续分类

  - 开发依赖包

    只在项目开发期间用到的包，记录在`devDependencies`中，安装的时候需要添加`--sava-dev`参数，简写参数是`-D`，这样安装的包的名称及版本号就会保存在`package.json`文件的`devDependencies`节点里面，表示仅在开发环境使用这个包，发布的时候不需要这个包

    ```sh
    npm i --save-dev 包名 # npm i -D 包名
    ```

  - 核心依赖包

    开发和上线都会用到的包，记录在`dependencies`中，安装的时候需要添加`--save`参数，简写形式是`-S`，或者不写这个参数默认就是这个参数，这样安装的包的名称及版本号就会保存在`package.json`文件的`dependencies`节点里面，表示在开发环境和发布的时候都需要使用这个包
    
    ```sh
    npm i 包名 # npm i --save 包名 | npm i -S 包名
    ```

- 全局包

  比如前面的nrm包就是作为全局包安装的，在安装时添加`-g`参数即可，全局包会被安装在用户目录下面

  `C:\Users\用户名\AppData\Roaming\npm\node_modules`

  全局包的卸载也是普通卸载一样的命令，只是需要添加`-g`参数

  ```sh
  npm uninstall 包名 -g
  ```

  一般来说只有**工具性质的包**才会安装为全局包，这样就能在任意项目中使用这个包了，一般包的官方说明里面也会建议你是否需要全局安装这个包，参考官方建议即可

##### 8.9 包的结构规范

包应该遵循如下规范结构：

1. 包必须是一个单独的目录

2. 包的根目录下必须存在`package.json`包管理配置文件

3. 包管理配置文件中必须包含name、version、main属性，分别代表包名、版本号、包的入口

   关于main：main表示了在使用require导入包时，应该导入包的哪个文件，main指明了文件路径，比如moment包的main配置
   
   ```json
   {
       "main": "./moment.js"
   }
   ```

##### 8.10 开发和发布自己的包

1. 创建项目文件夹，新建三个文件

   `index.js`、`package.json`、`README.md`

2. 编写功能文件`dateFormat.js`、`htmlEscape.js`，编写功能，对外暴露成员函数

3. 在`index.js`中导入功能文件，利用展开运算符对外暴露功能文件

   ```js
   module.exports = {
       ...dateFormat,
       ...htmlEscape
   }
   ```

4. 编写`package.json`，写明配置信息

   ```json
   {
     "name": "my-tools",
     "version": "1.0.0",
     "main": "index.js",
     "description": "提供格式化时间的功能，转义html的功能",
     "keywords": [
       "格式化时间",
       "dateFormat",
       "转义html"
     ],
     "author": "ixcw",
     "license": "ISC"
   }
   ```

5. 编写`README.md`说明文档，帮助别人理解包，主要是安装和使用方法

6. 到npm官网注册npm账号，然后在终端输入命令登录（注意先将安装源切换回npm官网）

   ```sh
   npm login
   ```

   登录完成后输入发布包的命令就可以发布包到npm上了（包名不能和别人的一样）

   ```sh
   npm publish
   ```

7. 删除发布的包

   删除72小时内发布的包，删除后的24小时内不允许重新发布，尽量不要在npm上发布无意义的包，练手的包最好删掉

   ```sh
   npm unpublish 包名 --force
   ```

##### 8.11 模块加载机制

1. 模块第一次被加载后会被缓存，模块会优先从缓存中加载，目的是为了提高加载效率，也就是说多次调用require不会导致模块中的代码执行多次
2. 内置模块的加载优先级最高，如果自定义模块和三方模块恰好和内置模块重名，那么node会优先加载内置模块
3. 自定义模块的加载必须是相对路径，且必须加`./`或`../`，否则node会将其错误识别为内置模块或三方模块进行加载从而导致加载失败，加载自定义模块时可以不加拓展名，node会自动补全
4. 三方模块加载时会逐层查找`node_modules`文件夹，直到磁盘根目录，找不到就报错
5. 以目录作为模块加载时，会查找目录下的`package.json`文件，寻找main入口，如果找不到就查找目录下的`index.js`进行加载，还找不到就报错

#### 9 Express

Express是基于NodeJS平台的web开发框架，用于创建web服务器，其本质是npm上面的三方包，对node的http模块进行了封装，可以更加快捷方便地创建web服务器，且功能上更加强大，就类似于jQuery和原生DOM的关系，除了提供网页资源的web服务器，express还可以创建API接口服务器

##### 9.1 安装express

通过npm安装即可

```sh
npm i express
```

##### 9.2 创建web服务器

```js
// 1. 导入express模块
const express = require('express')
// 2. 创建web服务器
const app = express()
// 3. 启动服务器
app.listen(80, () => {
  console.log('express is running at localhost')
})
```

##### 9.3 监听请求及响应

1. 监听get请求

   ```js
   // 监听get请求，响应json数据
   app.get('/user', (req, res) => {
     let user = {
       name: 'zs',
       age: 20,
       gender: '男'
     }
     res.send(user)
   })
   ```

2. 监听post请求

   ```js
   app.post('/user', (req, res) => {
     res.send('post请求成功')
   })
   ```

##### 9.4 获取请求参数

通过`req.query`对象获取请求参数，请求参数需要是通过**请求字符串**的形式发送的参数，该对象默认为空对象

```js
app.get('/', (req, res) => {
  console.log(req.query)
  res.send(req.query)
})
```

参数会作为对象的键值对属性，通过这个对象就可以使用传递过来的参数了

通过`req.params`对象获取动态参数，默认也是空对象

```js
// :id 是动态参数，是动态匹配的
app.get('/user/:id', (req, res) => {
  console.log(req.params)
  res.send(req.params)
})
```

请求地址：

`localhost/user/1`

响应内容：

```json
{
    "id": "1"
}
```

> 动态参数可以写多个，比如 `/user/:id/:name`

##### 9.5 托管静态资源

通过`express.static()`可以创建静态资源服务器，传入参数是静态资源的存放目录，然后在网址中不用加上存放目录就能访问静态资源，express会自动去存放静态目录的目录查找静态文件

```js
app.use(express.static('./static'))
```

直接访问`http://localhost/index.html`就可以访问到index.html文件了

如果希望托管多个静态目录，只需要再次调用这个方法就可以了，express会按照调用的顺序去依次查找静态文件

如果希望在访问静态文件的时候网址里面加上路径，而不是直接访问，可以添加路径参数

```js
app.use('/sta', express.static('./static'))
```

这时只有访问这样的网址才能访问到静态资源`http://localhost/sta/index.html`

##### 9.6 nodemon

前面我们发现，每次修改代码之后都需要手动重启服务器，非常麻烦，我们可以安装一个三方包`nodemon`，它可以帮助我们监听项目文件的变动，不用手动重启项目

```sh
npm i nodemon -g
```

使用也很简单，把node改为nodemon就行

```sh
nodemon app.js
# [nodemon] 2.0.15
# [nodemon] to restart at any time, enter `rs`
# [nodemon] watching path(s): *.*
# [nodemon] watching extensions: js,mjs,json
# [nodemon] starting `node .\app.js`
# express is running at localhost
```

##### 9.7 路由

路由可以简单理解为映射关系，在express中则是请求与处理函数间的映射关系，在前面我们已经使用过路由了，路由由请求方法、请求地址和处理函数组成，将路由挂载到app实例上即可

```js
app.post('/user', (req, res) => {
  res.send('post请求成功')
})
```

当客户端发来请求时，express会根据请求方法和请求地址按照路由的顺序进行路由匹配，匹配成功则交给对应的处理函数处理，否则返回不能处理请求的提示

但是直接挂载路由到app上的做法有缺点，一旦路由越来越多，代码也越来越冗余，为了模块化路由，express推荐将路由抽离为单独的模块

`router.js`：

```js
const express = require('express')
// 创建路由对象
const router = express.Router()
// 挂载路由到路由对象上
router.get('/get', (req, res) => res.send('Hello World GET!'))
router.post('/post', (req, res) => res.send('Hello World POST!'))

// 将路由对象导出去
module.exports = router
```

`app.js`：

```js
const express = require('express')
// 导入路由
const router = require('./router')

// 注册路由
const app = express()
app.use(router)
```

这里use函数的作用就是用来注册**全局中间件**，在后面单独讲解

为路由模块添加访问前缀也是和前面一样的方法

```js
app.use('/api', router)
```

##### 9.8 中间件

中间件（Middleware），特指在业务流程中的**中间处理环节**，而中间处理环节必然会有输入输出，因为要对接业务上下流，一次请求可能会接连由多个中间件处理之后才能响应给客户端

中间件本质上是一个function处理函数，在其形参列表中需要包含`next`参数，而路由处理函数中只包含了`req`和`res`参数

```js
app.get('/', function(req, res, next) {
    next()
})
```

`next()`函数是实现多个中间件连续调用的关键，它表示了把流转关系转交给下一个中间件或者路由，也就是中间件的输出

- 定义中间件函数

   在中间件的业务处理完毕后，必须调用next函数，将流转关系交给下一个中间件或路由

   ```js
   const mw = function (req, res, next) {
     console.log('this is a middleware function')
     next()
   }
   ```

   使用use函数可以让创建的中间件变为全局中间件，任何请求都会由这个中间件进行处理

   ```js
   app.use(mw)
   ```
   > 需要注意的是express是按住use的顺序来查找的，所以想要全局中间件生效，全局中间件的use要写在最开始的位置
   
   可以直接将全局中间件写在use函数里面
   ```js
   app.use(function (req, res, next) {
     console.log('this is a middleware function')
     next()
   })
   ```


- 中间件的作用

  多个中间件之间可以共享req和res对象，基于此特性我们可以在上游中间件里给req或res对象添加属性和方法供下游中间件使用

  ```js
  app.use(function (req, res, next) {
    req.time = new Date()
    next()
  })
  
  app.post('/user', (req, res) => {
    res.send('post请求成功' + req.time) // post请求成功Thu Dec 23 2021 23:38:57 GMT+0800 (中国标准时间)
  })
  ```

- 局部生效的中间件

  想要局部生效，就不用将中间件放到use函数里了，而是哪个路由需要用就将中间件作为参数传给它

  ```js
  app.use('/api', middleware, router)
  ```
  如果有不止一个局部中间件，可以依次传入或者以数组形式传入

  ```js
  app.use('/api', middleware, middleware1, middleware2, router)
  // 等价于
  app.use('/api', [middleware, middleware1, middleware2], router)
  ```

- 中间件的分类

  1. 应用级中间件

     绑定到app实例上的中间件都是应用级中间件

  2. 路由级中间件

     绑定到router实例上的中间件都是路由级中间件

  3. 错误级中间件

     错误级中间件用于捕获项目中的错误，防止项目因为异常崩溃，比起普通中间件多了`err`参数

     ```js
     app.get('/err', (req, res) => {
       throw new Error('服务器内部错误！')
       res.send('error page')
     })
     
     app.use((err, req, res, next) => {
       console.log('发生错误：' + err.message)
       res.send('Error: ' + err.message)
     })
     ```

     > 需要注意错误级中间件**只能注册在所有路由之后**，与普通中间件不一样，因为错误捕获是一个后置操作，错误必须先发生，然后才能捕获错误来处理

  4. 内置中间件

     express从4.16.0版本开始新增了三个内置中间件，提高了开发效率

     1. `express.static()`

        托管静态资源，前面介绍过了，这个中间件没有兼容性，express4.16版本之前也能使用

     2. `express.json()`

        解析JSON格式的请求体数据，有兼容性，必须在express4.16+的版本中使用

        ```js
        app.use(express.json())
        ```
        在不使用这个中间件的情况下无法直接获取JSON格式的请求体数据，打印了undefined
        ```js
        app.post('/json', (req, res) => {
          // 可以使用req.body接收请求体数据，默认为undefined
          console.log(req.body) // undefined
          res.send('json')
        })
        ```
        配置之后就能正常解析JSON格式请求体数据了

        ```js
        app.use(express.json())
        
        app.post('/json', (req, res) => {
          // 可以使用req.body接收请求体数据
          console.log(req.body) // { name: 'zs', age: 20 }
          res.send('json')
        })
        ```

     3. `express.urlencoded()`

        解析URL-encoded格式的请求体数据，有兼容性，必须在express4.16+的版本中使用

        ```js
        app.use(express.urlencoded({ extend: false }))
        ```
        在不使用这个中间件的情况下无法直接获取JSON格式的请求体数据，打印了undefined
        
        ```js
        app.post('/urlencoded', (req, res) => {
          console.log(req.body) // undefined
          res.send('urlencoded')
        })
        ```
        
        ds
        
        ```js
        app.use(express.urlencoded({ extend: false }))
        
        app.post('/urlencoded', (req, res) => {
          console.log(req.body) // { bookName: '从零开始的异世界生活', author: '长月达平' }
          res.send('urlencoded')
        })
        ```

  5. 三方中间件

     三方开发的中间件，比如在express4.16之前使用三方中间件body-parser来解析请求体数据

     先安装中间件

     ```sh
     npm i body-parser
     ```

     使用中间件

     ```js
     const parser = require('body-parser')
     app.use(parser.urlencoded({ extend: false }))
     app.post('/user', (req, res) => {})
     ```

     有没有发现使用方法和内置中间件几乎一模一样，因为内置中间件就是基于body-parser封装出来的


##### 9.9 解决跨域问题

跨域资源共享（CORS），全称Cross-Origin Resource Sharing，由一系列HTTP响应头组成，这些响应头决定了浏览器是否会阻止js获取跨域资源，浏览器由于同源安全策略默认会阻止网页获取跨域资源，但是如果服务器配置了CORS相关的HTTP响应头，则浏览器就会解除该限制

###### 9.9.1 三方中间件cors

cors是express的一个三方中间件，用于解决接口跨域问题

1. 安装cors

   ```sh
   npm i cors
   ```

2. 导入并且配置cors

   ```js
   const cors = require('cors')
   app.use(cors())
   
   app.get(...)
   ```

然后接口就能被跨域访问了，可见CORS只需在服务器端配置，客户端无需任何配置就能正常访问接口，CORS有兼容性，不兼容IE10以下版本

###### 9.9.2 响应头字段

- 响应头可以携带`Access-Control-Allow-Origin`字段，指定允许访问该接口的外域URL

  ```js
  res.setHeader('Access-Control-Allow-Origin', 'http://zs.cn')
  ```

  这将只允许域名为`http://zs.cn`的网站访问该接口，如果设置为`*`表示任何网站均可访问

- 响应头可以携带`Access-Control-Allow-Headers`字段，指定请求允许发送的请求头

  默认情况下CORS允许客户端向服务端发送9个请求头，如果需要额外发送请求头，需要指定

  ```js
  res.setHeader('Access-Control-Allow-Headers', 'Content-type, X-Custom-Header')
  ```

- 响应头可以携带`Access-Control-Allow-Methods`字段，指定请求允许使用的请求方法

  默认情况下CORS仅支持GET、POST、HEAD请求，如需额外请求方法，需要指定，如果设置为`*`则表示允许所有的请求方法

  ```js
  res.setHeader('Access-Control-Allow-Methods', 'POST, GET, HEAD, DELETE, PUT')
  ```

###### 9.9.3 CORS请求分类

客户端在请求CORS接口时，根据请求方法和请求头的不同，可分为两类请求

1. 简单请求

   请求方法是GET、POST、HEAD三者之一，以及请求头无自定义字段

2. 预检请求

   与简单请求相反的请求就是预检请求，或者向服务器发送了application/json格式的数据的请求，之所以叫预检请求是因为在浏览器发送真实的请求之前会提发送一个option请求预检，以得知服务器是否允许这次请求，得知服务器允许后才会发送真实请求

###### 9.9.4 jsonp

通过script的src属性来请求数据，服务器返回一个函数的调用，这样的曲线救国的请求方式叫做jsonp，如果项目中已经配置了jsonp接口，那么cors的配置应该放在jsonp接口之后，否则jsonp接口会被当成cors接口处理

```js
app.get('/api/jsonp', (req, res) => {
  // 获取请求参数中的回调函数
  const callback = req.query.callback
  const data = { name: 'zs', age: 20 }
  const scriptStr = `${callback}(${JSON.stringify(data)})`
  res.send(scriptStr)
})
```

#### 10 数据库MySQL

参考MySQL笔记

#### 11 Express操作数据库

##### 11.1 安装mysql模块

mysql是一个npm上的三方模块，提供了在node项目中连接操作MySQL数据库的能力

```sh
npm i mysql
```

使用mysql模块连接数据库

```js
// 1. 导入mysql模块
const mysql = require('mysql')
// 2. 建立与数据库的连接
const db = mysql.createPool({
  host: '127.0.0.1',
  user: 'james',
  password: 'james',
  database: 'express'
})
// 3. 检测连接是否成功
db.query('SELECT 1', (err, result) => {
  if (err) return console.log(err.message)
  console.log(result) // 打印 [ RowDataPacket { '1': 1 } ] 表示连接成功
})
```

##### 11.2 查询数据

```js
const sqlStr = 'SELECT * FROM user'
db.query(sqlStr, (err, result) => {
  if (err) return console.log(err.message)
  console.log(result)
})
// [
//   RowDataPacket { id: 1, name: 'zs', status: '0' },
//   RowDataPacket { id: 2, name: 'ls', status: '0' },
//   RowDataPacket { id: 3, name: '刘德华', status: '0' }
// ]
```

结果打印出了对象数组，一个对象表示一条记录

##### 11.3 插入数据

```js
const user = { name: '周杰伦', status: 0 }
const sqlStr = 'INSERT INTO user (name, status) VALUES (?, ?)'
db.query(sqlStr, [user.name, user.status], (err, result) => {
  if (err) return console.log(err.message)
  if (result.affectedRows === 1) {
    console.log(result)
  }
})
// OkPacket {
//   fieldCount: 0,
//   affectedRows: 1,
//   insertId: 4,
//   serverStatus: 2,
//   warningCount: 0,
//   message: '',
//   protocol41: true,
//   changedRows: 0
// }
```
插入数据时一一对应的方式虽然直观但是麻烦，尤其属性多的时候，可以更简便地插入数据，如果对象的属性和数据库表的字段是一一对应的，可以直接插入

```js
const user = { name: 'zxy', status: 0 }
const sqlStr = 'INSERT INTO user SET ?'
db.query(sqlStr, user, (err, result) => {
  if (err) return console.log(err.message)
  if (result.affectedRows === 1) {
    console.log('result')
  }
})
```

##### 11.4 更新数据

更新数据与插入数据的写法类似

```js
const user = { id: 5, name: '张学友', status: 1 }
const sqlStr = 'update user set name=?, status=? where id=?'
db.query(sqlStr, [user.name, user.status, user.id], (err, result) => {
  if (err) return console.log(err.message)
  if (result.affectedRows === 1) {
    console.log('result')
  }
})
```

同样的可以简写

```js
const user = { id: 5, name: '张学友', status: 0 }
const sqlStr = 'update user set ? where id=?'
db.query(sqlStr, [user, user.id], (err, result) => {
  if (err) return console.log(err.message)
  if (result.affectedRows === 1) {
    console.log('result')
  }
})
```

##### 11.5 删除数据

```js
const sqlStr = 'delete from user where id=?'
// 参数只有一个时可以不用数组传参
db.query(sqlStr, 2, (err, result) => {
  if (err) return console.log(err.message)
  if (result.affectedRows === 1) {
    console.log('success')
  }
})
```

要注意的是delete是真正的将数据从表中删除，一般我们不这么做，因为删除是一个危险操作，正确做法是设置一个标记字段，来标记记录是否被删除的状态，所以只需要更新删除标记字段的值即可

#### 12 身份认证

##### 12.1 web开发模式

目前web开发模式分为两种，分别是传统的开发模式和前后端分离的开发模式

- 传统开发模式

  服务器发送给客户端的页面是经过服务器的字符串拼接动态生成的，代码耦合严重，客户端不需要额外使用Ajax请求数据

- 前后端分离开发模式

  依赖于Ajax等异步请求技术，前后端分开分别独立开发，前后端通过Ajax进行通信，前端只需要请求后端接口数据，页面的生成由前端完成

##### 12.2 身份认证

身份认证（Authorization）又称身份验证、身份鉴权，是指通过一定手段验证用户身份的手段，对于不同的开发模式推荐使用不同的身份认证方式

传统开发模式推荐使用session认证机制，前后端分离推荐使用JWT认证机制

##### 12.3 HTTP无状态性

HTTP协议的无状态性是指每一次发送的http请求都是互相独立、无联系的，连续多个请求之间没有直接关系，服务器也不会主动去保存HTTP请求的状态

为了突破这个限制，正确识别客户端发来的http请求，产生了身份认证机制的技术

##### 12.4 session

先来看cookie，cookie是存储在客户端的一段不超过4KB的字符串，由键值对组成，还有一系列控制有效期、安全性的可选属性组成，每个域名下的cookie是各自独立的，当客户端发起请求时，会自动把当前域名下的未过期的cookie**全部发送**到服务器

客户端第一次请求服务器的时候，服务器会通过响应头的形式向客户端发送cookie，客户端将cookie保存在浏览器中

正是由于cookie是存储在浏览器中的，所以cookie不具有安全性，容易被伪造，所以重要的隐私数据不要用cookie，session就是在服务器端验证cookie是否有效的手段

在express中使用session需要安装中间件`express-session`

```sh
npm i express-session
```

配置中间件

```js
let session = require('express-session')
app.use(session({
    // 用于加密
    secret: 'any string',
    // 固定写法
    resave: false,
    // 固定写法
    saveUninitialized: true
}))
```

配置完之后就可以获取使用session了，可以向session中存储数据

```js
app.post('/api/login', (req, res) => {
  if (req.body.username !== 'admin' || req.body.password !== '000000') {
    return res.send({ status: 1, msg: '登录失败' })
  }
  req.session.user = req.body
  req.session.isLogin = true
  res.send({ status: 0, msg: '登录成功' })
})
```

也可以从session中获取存储的数据

```js
app.get('/api/username', (req, res) => {
  if (!req.session.isLogin) {
    return res.send({ status: 1, msg: 'fail' })
  }
  res.send({
    status: 0,
    msg: 'success',
    username: req.session.user.username
  })
})
```

当用户退出登录时，可以清除session信息

```js
app.post('/api/logout', (req, res) => {
  req.session.destroy()
  res.send({ status: 0, msg: '退出登录成功' })
})
```

注意不会清除所有的session，只会清除当前对应用户的session

##### 12.1 jwt

由于session认证机制需要配合cookie才能实现，而cookie不支持跨域访问，所以当需要跨域请求时需要很多额外配置，很麻烦，这时候用JWT（JSON Web Token）认证就比较合适了，这是目前最流行的跨域解决方案

jwt的原理是用户第一次验证通过后，服务器将用户信息加密生成一个token字符串，将其发送给客户端保存，客户端下次请求时在请求头中携带token请求，服务器端还原token信息，验证通过

jwt由三部分组成，分别是Header头部，Payload有效负载，Signature签名，中间以点号连接，其中payload才是真正的用户信息，经过加密生成，header和signature是安全加密需要的

一般浏览器会将token存储在localStorage或sessionStorage中，请求时一般推荐以如下格式将其放在请求头字段中

```txt
Authorization: Bearer <token>
```

要在express中使用jwt需要安装相关的包，jsonwebtoken用于生成jwt字符串，express-jwt用于将jwt字符串解析还原为JSON对象

```sh
npm i jsonwebtoken express-jwt
```

导入并使用

```js
const jwt = require('jsonwebtoken')
const expressJWT = require('express-jwt')

// 密钥，越复杂越好
const secretKey = 'dsdfsDSS34EFSFS34452'

// 注册将 JWT 字符串解析还原成 JSON 对象的中间件，unless函数指明哪些接口不需要解析
// 注意：只要配置成功了 express-jwt 这个中间件，就可以把解析出来的用户信息，挂载到 req.user 属性上
app.use(expressJWT({ secret: secretKey }).unless({ path: [/^\/api\//] }))

// 登录接口
app.post('/api/login', function (req, res) {
  const userinfo = req.body
  // 登录失败
  if (userinfo.username !== 'admin' || userinfo.password !== '000000') {
    return res.send({
      status: 400,
      message: '登录失败！',
    })
  }
  // 登录成功
  // TODO_03：在登录成功之后，调用 jwt.sign() 方法生成 JWT 字符串。并通过 token 属性发送给客户端
  // 参数1：用户的信息对象
  // 参数2：加密的秘钥
  // 参数3：配置对象，可以配置当前 token 的有效期
  // 记住：千万不要把密码加密到 token 字符中
  const tokenStr = jwt.sign({ username: userinfo.username }, secretKey, { expiresIn: '30s' })
  res.send({
    status: 200,
    message: '登录成功！',
    token: tokenStr, // 要发送给客户端的 token 字符串
  })
})

// 这是一个有权限的 API 接口
app.get('/admin/getinfo', function (req, res) {
  // 使用 req.user 获取用户信息，并使用 data 属性将用户信息发送给客户端
  console.log(req.user)
  res.send({
    status: 200,
    message: '获取用户信息成功！',
    data: req.user, // 要发送给客户端的用户信息
  })
})
```

如果客户端发送过来的token过期或者无效，可以捕获错误并处理

```js
// 使用全局错误处理中间件，捕获解析 JWT 失败后产生的错误
app.use((err, req, res, next) => {
  // 这次错误是由 token 解析失败导致的
  if (err.name === 'UnauthorizedError') {
    return res.send({
      status: 401,
      message: '无效的token',
    })
  }
  res.send({
    status: 500,
    message: '未知的错误',
  })
})
```
