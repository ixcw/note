#### 1 前端工程化

前端工程化也叫前端模块化，主要用于解决传统开发模式的两个问题

- 命名冲突

  多个js文件之间，如果存在同名变量，可能会发生变量重名的问题

- 文件依赖

  js文件之间无法实现相互引用

为了解决这两个问题，前端提出了模块化的方式，就是把单独的功能封装到单独的模块中，每个模块是一个单独的js文件，模块之间相互隔离，可以通过特定的接口导出内部成员，模块之间可以相互依赖，这样做的好处在于重用代码、便于维护、提升开发效率

#### 2 模块化规范

1. 浏览器端模块化规范

   前端模块化规范主要有AMD（require.js）和CMD（sea.js），目前已经比较落后，有更优的方案代替

2. 服务器端模块化规范

   最出名的就是CommonJS规范了，详情参考NodeJS篇

最新的模块化规范是大一统的ES6模块化规范，前面提到的这三种模块化规范，彼此之间存在着差异和局限性，而且不是浏览器端与服务器端通用的规范

为了解决这些问题，ES6模块化规范在语法层面规定了模块化规范通用标准，是浏览器端和服务器端**通用**的模块化标准，ES6模块化规范主要定义：

1. 每个js文件都是一个独立的模块
2. 导入模块使用`import`关键字（而不是require）
3. 暴露内部成员使用`export`关键字

#### 3 Node中的ES6模块化

node中的es6模块化支持并不好，但是可以通过babel三方库转化es6的代码为兼容性的代码

1. 安装babel三方库

   ```sh
   npm install --save-dev @babel/core @babel/cli @babel/preset-env @babel/node
   npm install --save @babel/polyfill
   ```

2. 在项目根目录新建babel配置文件

   新建`babel.config.js`文件

   ```js
   const presets = [
     [
       '@babel/env',
       {
         targets: {
           edge: '17',
           firefox: '60',
           chrome: '67',
           safari: '11.1'
         }
       }
     ]
   ]
   
   module.exports = { presets }
   ```

3. 然后就可以通过以下命令执行js文件了，文件现在支持es6高级语法

   ```sh
   npx babel-node .\index.js
   ```

#### 4 ES6模块化语法

主要是模块的导入与导出

- 默认导入导出

  `m1.js`文件：

  ```js
  let a = 10
  let b = 20
  let c = 30
  
  function show() {
    console.log('show')
  }
  
  export default { a, b, show }
  ```

  `index.js`文件：

  ```js
  import m1 from './m1.js'
  
  console.log(m1) // { a: 10, b: 20, show: [Function: show] }
  ```

  执行npx命令，得到如上输出

  > 每个模块中只允许使用唯一一次`export default`，否则会报错

- 按需导入导出

  按需导入导出是指在导出时直接在定义的时候导出，导入时使用**解构赋值导入**
  默认导入导出和按需导入导出可以同时存在互不影响

  `m1.js`文件：

  ```js
  let a = 10
  let b = 20
  let c = 30
  
  function show() {
      console.log('show')
  }
  
  export let s1 = 's1'
  export let s2 = 's2'
  export function say() {
      console.log('say')
  }
  
  export default { a, b, show }
  ```

  `index.js`文件：

  ```js
  import m1, { s1, s2, say } from './m1.js'
  
  console.log(m1) // { a: 10, b: 20, show: [Function: show] }
  console.log(s1) // s1
  console.log(s2) // s2
  console.log(say) // [Function: say]
  say() // say
  ```

  按需导入可以使用as可以起别名

  ```js
  import m1, { s1, s2 as s22, say } from './m1.js'
  
  console.log(m1) // { a: 10, b: 20, show: [Function: show] }
  console.log(s1) // s1
  // console.log(s2) // ReferenceError: s2 is not defined
  console.log(s22) // s2
  console.log(say) // [Function: say]
  say() // say
  ```

- 直接导入模块并执行代码
  
  有时候，我们不需要获得模块中向外暴露的成员，只是想执行模块中的代码，这种情况下往往模块也并没有向外暴露成员，那么可以直接导入模块
  
  `m1.js`文件：
  
  ```js
  let a = 10
  let b = 20
  let c = 30
  
  function show() {
    console.log('show')
  }
  
  export let s1 = 's1'
  export let s2 = 's2'
  export function say() {
    console.log('say')
  }
  
  export default { a, b, show }
  
  for (let i = 0; i < 6; i++) {
    console.log(i)
  }
  ```
  
  `index.js`文件：
  
  ```js
  import './m1'
  ```
  
  npx执行index文件，发现成功打印了for循环

#### 5 Webpack

首先来看看当前web开发面临的问题：

1. 文件依赖关系复杂
2. 静态资源请求效率低
3. 模块化支持不友好
4. **浏览器对js的高级特性兼容性低**

为了解决这些问题，webpack应运而生，webpack是一个流行的**前端项目构建工具**，或者叫做**打包工具**，webpack提供了一系列实用的功能，包括友好的模块化支持、代码混淆压缩、解决js高级特性兼容问题、静态资源优化等等功能，让前端程序员不必过多的为了这些功能无关的东西担忧，从而提高了开发效率和项目可维护性，目前绝大部分的企业都使用了webpack打包构建前端项目，因此webpack是非常重要的前端工具

##### 5.1 webpack项目体验

1. npm初始化项目

   ```sh
   npm init -y
   ```

2. 新建资源文件夹

   在项目根目录新建`src`文件夹，并新建`index.html`文件

   ```html
   <ul>
       <li>第1个li</li>
       <li>第2个li</li>
       <li>第3个li</li>
       <li>第4个li</li>
       <li>第5个li</li>
       <li>第6个li</li>
       <li>第7个li</li>
       <li>第8个li</li>
   </ul>
   ```

3. npm安装jQuery

   ```sh
   npm i jquery
   ```

4. 新建`index.js`文件

   传统方式肯定是在html文件中导入jQuery的js文件，然后使用jQuery，但是这里我们需要使用模块化的方式导入jQuery，所以html导入的是`index.js`文件，在`index.js`文件中通过模块化的方式导入jQuery

   ```js
   import $ from 'jquery'
   ```

5. 利用jQuery实现隔行变色效果

   导入jQuery之后就可以在`index.js`文件中使用jQuery了

   ```js
   import $ from 'jquery'
   
   $(function () {
       $('li:odd').css('backgroundColor', 'pink')
       $('li:even').css('backgroundColor', 'blue')
   })
   ```

   但是打开浏览器预览网页效果并没有实现隔行变色的效果，这是怎么回事呢，打开控制台，发现第一行导入语句报错了

   ```txt
   index.js:1 Uncaught SyntaxError: Cannot use import statement outside a module
   ```

   不能在模块外部使用import声明，怎么理解呢，其实就是浏览器对es6的模块化不够友好，浏览器并不支持es6的模块化语法，因此报错，解决方案自然就是使用webpack将es6的模块化语法转换为浏览器支持的语法

6. 安装配置webpack

   安装webpack

   ```sh
   npm i -D webpack webpack-cli
   ```

   配置webpack，在项目根目录创建`webpack.config.js`文件

   ```js
   module.exports = {
       mode: 'development'
   }
   ```

   配置文件中导出了一个配置，这个配置表示目前webpack的构建模式为开发模式，在开发模式下webpack不会对代码进行混淆压缩，这样的话构建速度会更快，节约了开发时间，如果改为`production`则表示构建模式为产品模式，也就是会对代码进行压缩混淆，构建速度会更慢，所以我们在开发阶段一般会把构建模式指定为开发模式

7. 配置npm的`package.json`配置文件

   新增`scripts`节点

   ```json
   "scripts": {
       "dev": "webpack"
   }
   ```

   配置好之后就可以使用如下命令运行webpack执行打包命令了

   ```sh
   npm run dev
   ```

   运行命令之后项目根目录就会自动生成一个`dist`文件夹，里面创建了一个`main.js`文件，这个文件就是webpack打包好的文件

   我们原先的html里面引用的是有兼容性问题的`index.js`文件，我们现在就不需要引用这个文件了，而是引用我们打包好的`main.js`文件，

   `main.js`文件直接打包了`index.js`和它依赖的jQuery的js文件，因此体积高达300多k

   如果我们想减小打包文件的体积，那可以将开发模式转为产品模式即可，转换过后发现`main.js`的体积变为了80多k，体积直接减小了3倍

   > 即使我们此时卸载了jQuery的三方库，只要我们引用的还是`main.js`文件，就不会影响网页的实现效果

##### 5.2 打包入口与出口

webpack默认的打包入口文件为src目录下的`index.js`，打包出口文件为dist目录下的`main.js`，所以我们前面没有配置打包的出口和入口文件，webpack也给我们生成了打包文件`main.js`，webpack的打包出入口文件其实是可以自定义配置的，在webpack的配置文件中新增如下配置

```js
const path = require('path')

module.exports = {
  mode: 'development',
  entry: path.join(__dirname, './src/index.js'),
  output: {
    path: path.join(__dirname, './dist'),
    filename: 'bundle.js'
  }
}
```

打包完成后html文件引用`bundle.js`就可以了

##### 5.3 自动打包

由于我们引用的是打包后的js文件，因此每当我们修改代码时，都需要手动将修改后的代码重新打包一遍，挺麻烦的，能不能自动执行这个打包的过程呢，答案是可以的

1. 安装自动打包工具

   ```sh
   npm i -D webpack-dev-server
   ```

2. 配置npm配置文件

   修改`package.json`文件的scripts节点，scripts节点下的配置可以通过`npm run`命令执行脚本

   ```json
   "scripts": {
       "dev": "webpack-dev-server"
   }
   ```

3. 修改html的引用路径

   引用路径不再使用相对路径，而是改为`"/bundle.js"`

4. 执行打包命令并查看效果

   ```sh
   npm run dev
   ```

   访问[localhost:8080/bundle.js](http://localhost:8080/bundle.js)查看js文件托管效果

###### 5.3.1 页面预览插件

直接访问网址还看不到html页面效果，需要再配置一款webpack插件`html-webpack-plugin`

1. 安装插件

   ```sh
   npm i -D html-webpack-plugin
   ```

2. 修改webpack配置文件

   ```js
   const path = require('path')
   const HtmlWebpackPlugin = require('html-webpack-plugin')
   
   const htmlPlugin = new HtmlWebpackPlugin({
     template: './src/index.html',
     filename: 'index.html'
   })
   
   module.exports = {
     mode: 'development',
     entry: path.join(__dirname, './src/index.js'),
     output: {
       path: path.join(__dirname, './dist'),
       filename: 'bundle.js'
     },
     plugins: [htmlPlugin]
   }
   ```

   > 这里生成的`index.html`文件是位于项目根目录下的，但我们还看不见，因为这个文件是在缓存里面的，同理前面引用的根目录下的`bundle.js`文件也是一样在缓存中的

3. 访问效果

   重新运行`npm run dev`，直接访问[http://localhost:8080/](http://localhost:8080/)就可以看见html的页面效果了

###### 5.3.2 相关参数

在我们自动打包之后，控制台输出了网页托管网址，但是还需要我们手动去点击一下才能打开网址查看网页效果，这怎么能行呢，能不能自动执行这个过程呢？那自然也是可以的（只能说懒惰是第一生产力，哈哈）

配置很简单，只需要在npm的配置文件中修改scripts节点的dev配置，增加相关参数就可以了

```json
"scripts": {
    "dev": "webpack-dev-server --open --host 127.0.0.1 --port 8888"
}
```

##### 5.4 加载器

在开发过程中，webpack只能打包处理js文件，而其它的非js文件比如css文件等webpack**默认**是处理不了的，需要借助于加载器loader才能正常处理打包，针对不同类型的文件有不同的loader加载器，比如less-loader用于打包处理.less文件，sass-loader用于打包处理.scss文件，url-loader用于打包处理css文件中与url路径相关的文件

###### 5.4.1 打包文件

1. 打包css文件

   在src文件夹下新建css文件夹，再新建`index.css`文件，去除li标签的默认样式，接着在`index.js`中导入`index.css`文件，运行打包命令发现报错，提示需要对应loader处理，因此我们需要先安装处理css的loader

   ```sh
   npm i -D style-loader css-loader
   ```

   配置webpack配置文件，添加module属性，配置处理文件和处理loader的对应关系

   test：要处理的文件类型，正则表达式

   use：对应的loader

   ```js
   const path = require('path')
   const HtmlWebpackPlugin = require('html-webpack-plugin')
   
   const htmlPlugin = new HtmlWebpackPlugin({
     template: './src/index.html',
     filename: 'index.html'
   })
   
   module.exports = {
     mode: 'development',
     entry: path.join(__dirname, './src/index.js'),
     output: {
       path: path.join(__dirname, './dist'),
       filename: 'bundle.js'
     },
     plugins: [htmlPlugin],
     module: {
       rules: [{ test: /\.css$/, use: ['style-loader', 'css-loader'] }]
     }
   }
   ```

   > use数组中的loader顺序是固定的，不能打乱，因为多个loader的调用顺序是从后往前调用，先调css-loader再调style-loader处理

   配置完成之后运行打包命令`npm run dev`就会自动打开网址预览页面了，发现成功应用了css文件

2. 打包less文件

   安装less和less-loader

   ```sh
   npm i -D less less-loader
   ```

   配置webpack配置文件

   ```js
   module: {
       rules: [
           { test: /\.css$/, use: ['style-loader', 'css-loader'] },
           { test: /\.less$/, use: ['style-loader', 'css-loader', 'less-loader'] }
       ]
   }
   ```

   编写less文件，然后用`index.js`入口文件引入.less文件

   ```js
   import './css/1.less'
   ```

   打包，查看效果

3. 打包sass文件

   sass文件的打包和less几乎一致

   安装sass-loader

   ```sh
   npm i -D node-sass sass-loader
   ```

   配置webpack配置文件

   ```js
   module: {
       rules: [
           { test: /\.css$/, use: ['style-loader', 'css-loader'] },
           { test: /\.less$/, use: ['style-loader', 'css-loader', 'less-loader'] },
           { test: /\.scss$/, use: ['style-loader', 'css-loader', 'sass-loader'] }
       ]
   }
   ```

   编写sass文件，然后用`index.js`入口文件引入.scss文件

   ```js
   import './css/1.scss'
   ```

   打包，查看效果

###### 5.4.2 解决css兼容性

css某些特性在IE中的支持不好，可以自己添加前缀，但是太麻烦了，我们可以借助postcss-loader解决

1. 安装postcss-loader

   ```sh
   npm i -D postcss-loader autoprefixer
   ```

2. 在项目根目录新建配置文件`postcss.config.js`

   ```js
   const autoprefixer = require('autoprefixer')
   
   module.exports = {
     plugins: [autoprefixer]
   }
   ```

3. 修改webpack配置文件，给处理css文件的loader加上postcss-loader

   ```js
   module: {
       rules: [
           { test: /\.css$/, use: ['style-loader', 'css-loader', 'postcss-loader'] },
           { test: /\.less$/, use: ['style-loader', 'css-loader', 'less-loader'] },
           { test: /\.scss$/, use: ['style-loader', 'css-loader', 'sass-loader'] }
       ]
   }
   ```

   重新打包即可

###### 5.4.3 打包图片和字体

webpack默认不能打包图片和字体文件（但是最新版的webpack似乎可以了？webpack@5.65.0），需要安装额外加载器

1. 安装处理url和file的加载器

   ```sh
   npm i -D url-loader file-loader
   ```

2. 修改webpack配置文件，添加规则，limit表示小于这个字节数的图片文件才会被转为base64

   ```js
   module: {
       rules: [
           { test: /\.css$/, use: ['style-loader', 'css-loader', 'postcss-loader'] },
           { test: /\.less$/, use: ['style-loader', 'css-loader', 'less-loader'] },
           { test: /\.scss$/, use: ['style-loader', 'css-loader', 'sass-loader'] },
           { test: /\.jpg|png|gif|bmp|ttf|eot|svg|woff|woff2$/, use: ['url-loader?limit=16940'] }
       ]
   }
   ```

   新版webpack配置了url-loader反而图片不能显示，查看官方文档，发现webpack5版本已经弃用url-loader和file-loader（?）

   如果非要强行使用，则需要增加额外配置如下

   ```js
   module: {
       rules: [
           { test: /\.css$/, use: ['style-loader', 'css-loader', 'postcss-loader'] },
           { test: /\.less$/, use: ['style-loader', 'css-loader', 'less-loader'] },
           { test: /\.scss$/, use: ['style-loader', 'css-loader', 'sass-loader'] },
           {
               test: /\.jpg|png|gif|bmp|ttf|eot|svg|woff|woff2$/,
               use: 'url-loader?limit=20000&esModule=false',
               type: 'javascript/auto'
           }
       ]
   }
   ```

###### 5.4.4 处理js兼容性

webpack默认不能处理js高级语法，先在`index.js`文件中书写类的语法

```js
class Person {
  static info = 'person'
}
console.log(Person.info)
```

然后打包运行，发现可以执行js高级语法（?），我猜又是webpack5解决了这个问题

1. 安装babel相关包

   ```sh
   npm i -D babel-loader @babel/core @babel/runtime
   npm i -D @babel/preset-env @babel/plugin-transform-runtime @babel/plugin-proposal-class-properties
   ```

2. 在项目根目录下新建babel配置文件`babel.config.js`

   ```js
   module.exports = {
       presets: ['@babel/preset-env'],
       plugins: [
           '@babel/plugin-transform-runtime',
           '@babel/plugin-proposal-class-properties'
       ]
   }
   ```

3. 修改webpack配置文件，添加规则，exclude是排除掉node引入的模块中的js文件，这些js文件不必处理

   ```js
   module: {
       rules: [
           { test: /\.css$/, use: ['style-loader', 'css-loader', 'postcss-loader'] },
           { test: /\.less$/, use: ['style-loader', 'css-loader', 'less-loader'] },
           { test: /\.scss$/, use: ['style-loader', 'css-loader', 'sass-loader'] },
           {
               test: /\.jpg|png|gif|bmp|ttf|eot|svg|woff|woff2$/,
               use: 'url-loader?limit=20000&esModule=false',
               type: 'javascript/auto'
           },
           {
               test: /\.js$/,
               use: 'babel-loader',
               exclude: /node_modules/
           }
       ]
   }
   ```

   重新打包即可

###### 5.4.5 vue单组件加载器

vue单组件编写完成后，通过`index.js`引入，打包发现报错，提示需要loader处理，下面安装对应的loader

1. 安装vue-loader

   ```sh
   npm i -D vue-loader vue-template-compiler
   ```

2. 修改webpack配置文件，添加规则

   ```js
   const path = require('path')
   const HtmlWebpackPlugin = require('html-webpack-plugin')
   const VueLoaderPlugin = require('vue-loader/lib/plugin')
   
   const htmlPlugin = new HtmlWebpackPlugin({
     template: './src/index.html',
     filename: 'index.html'
   })
   
   const vueLoaderPlugin = new VueLoaderPlugin()
   
   module.exports = {
     mode: 'development',
     entry: path.join(__dirname, './src/index.js'),
     output: {
       path: path.join(__dirname, './dist'),
       filename: 'bundle.js'
     },
     plugins: [htmlPlugin, vueLoaderPlugin],
     module: {
       rules: [{ test: /\.vue$/, use: 'vue-loader' }]
     }
   }
   ```

   运行打包命令后报错，提示没有找到`'vue-loader/lib/plugin'`，打开`node_modules`文件夹中的包发现确实没有这个文件，检查`vue-loader`安装版本是15.9.8，一顿百度操作之后发现15.6.1版本还有这个文件，于是更新版本后就发现有这个文件了

   接着运行打包命令，接着再次报错，提示找不到模块`'webpack/lib/RuleSet'`，打开`vue-loader`的`plugin.js`文件发现其引入了webpack的这个模块，而当前webpack的版本是5以上的版本，也没有找到这个`RuleSet.js`文件，打开原项目检查webpack版本发现版本是4.29.0，于是更新版本，这个版本就有这个文件了

   再次运行打包命令，再次报错，提示需要安装`@webpack-cli/serve`，于是想着是`webpack-dev-server`的版本不对，于是更新版本为3.1.14

   再次运行打包命令，再次报错，提示`html-webpack-plugin`有问题，再次更新版本为3.2.0

   再次运行打包命令，继续报错......

   最后我佛了，直接删除`node_modules`文件夹，复制老的`package.json`文件，重新`npm install`，发现报错更多了......

   最最后我放弃了旧项目的老版本，重新按照步骤从头到尾初始化安装了各种库的版本，有兼容性的图片和js兼容性我没有处理，这次就没有报上面的错误了，这次报了一个找不到vue库的错误，安装之，运行打包命令，成功！

   出于好奇为什么没有报错去查看了一下`vue-loader`的版本确实也是15.9.8，但是里面居然有`plugin.js`这个文件（???），而且打开文件一看，文件没有引用`webpack/lib/RuleSet`这个模块了，而是直接引用了`webpack`模块，也就是说同一个版本的前后表现并不一致，果然还是重装大法好？

   > 前端的各种三方库是由不同的团体开发的，彼此之间的信息交流有限，因此项目一旦报错，那么很有可能就是三方库版本的锅，最开始也是这样排查的
   >
   > 另外老版本的处理方式到了新版本就不一定能行了，或许新版本压根就不用处理，比如webpack4到5对图片文件和js兼容性的处理就不用额外配置
   >
   > 有时候是比较奇怪的bug，通过重装可以解决，猜测同一版本表现不一致的原因是缓存的可能

###### 5.4.6 构建vue

在`index.js`中导入vue并创建vue实例，导入组件，然后通过render配置项渲染组件到页面上，注意提前在index.html中建好app容器标签

```js
import Vue from 'vue'
import App from './components/App.vue'

const vm = new Vue({
  el: '#app',
  render: h => h(App)
})
```

##### 5.5 webpack打包发布

项目做完之后需要打包发布，可以通过npm配置文件配置打包发布命令，在scripts节点新增build指令

```json
"scripts": {
    "dev": "webpack-dev-server --open --host 127.0.0.1 --port 8888",
    "build": "webpack -p"
}
```

之后就可以运行命令打包发布了

```sh
npm run build
```

结果发现又报错了，提示未知参数`-p`，应该又是webpack版本的锅，去除`-p`参数后运行打包发布成功（无语）

```json
"scripts": {
    "dev": "webpack-dev-server --open --host 127.0.0.1 --port 8888",
    "build": "webpack"
}
```





















