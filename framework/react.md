#### 1 React

React是用于构建用户界面的JS库，所谓界面其实就是HTML界面，从MVC的角度看，react仅仅负责了V即View视图这一层，并没有提供完整的M和C的功能，react由Facebook创建，用于架设Instagram，于2013年开源，react有三个特点

1. 声明式

   声明式就是说你只需要描述UI是什么，那么UI就是什么，按照你的声明来，就跟写HTML一样很类似，至于UI的渲染和数据变更则由react完成

2. 基于组件

   组件是react的最重要的组成部分，基本上绝大部分功能都由组件实现，一个页面可以拆分成多个组件复用

3. 跨平台

   react不仅可以写web应用，通过react-native还可以开发安卓或iOS应用

#### 2 基本使用

1. 安装react

   ```sh
   npm i react react-dom
   ```

   react包：核心包，提供创建元素、组件等功能

   react-dom包：提供与DOM相关的功能

2. 创建页面元素

   ```html
   <body>
       <div id="root"></div>
       <script src="./node_modules/react/umd/react.development.js"></script>
       <script src="./node_modules/react-dom/umd/react-dom.development.js"></script>
       <script>
           // 创建页面元素
           // 参数依次是元素名称，元素属性，元素子节点（从第三个参数开始的参数都是）
           const h1 = React.createElement('h1', null, 'Hello React')
           const h2 = React.createElement('h2', { title: 'HR' }, 'Hello React')
       </script>
   </body>
   ```

3. 渲染页面元素

   ```html
   <body>
       <div id="root"></div>
       <script src="./node_modules/react/umd/react.development.js"></script>
       <script src="./node_modules/react-dom/umd/react-dom.development.js"></script>
       <script>
           // 创建页面元素
           // 参数依次是元素名称，元素属性，元素子节点（从第三个参数开始的参数都是）
           const h1 = React.createElement('h1', null, 'Hello React')
           const h2 = React.createElement('h2', { title: 'HR' }, 'Hello React')
           // 渲染页面元素到页面上
           // 参数依次是被渲染的页面元素，要渲染到的页面元素
           ReactDOM.render(h1, document.getElementById('root'))
           ReactDOM.render(h2, document.getElementById('root'))
       </script>
   </body>
   ```

#### 3 React脚手架

脚手架基本是开发现代web应用必备的，因为提供了很多帮助，比如项目打包、预编译等，福音是react的脚手架无需配置，开箱即用

```sh
npx create-react-app my-app
```

只需要执行一条命令，就安装了`create-react-app`工具并创建了名为my-app的react项目，之后参照终端提示cd到项目目录执行命令`npm start`即可启动项目

> 关于npx：npx是npm5.2.0版本之后引入的命令工具，目的是提高npm的使用体验，就比方说上面的命令，传统的npm需要安装react工具后才能创建react项目，而npx直接一条命令搞定

由于react脚手架是基于webpack的所以可以使用新的es语法，比如导入react库和react-dom库

```js
import React from 'react'
import ReactDOM from 'react-dom'

const h1 = React.createElement('h1', null, 'Hello React cli')
ReactDOM.render(h1, document.getElementById('root'))
```





















