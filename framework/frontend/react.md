#### 1 简介

react 是用于构建用户界面的 js 库，所谓界面其实就是HTML界面，react 由 facebook 创建，用于架设Instagram，于2013年开源，react有三个特点

1. 声明式

   声明式就是说你只需要描述UI是什么，那么UI就是什么，按照你的声明来，就跟写HTML一样很类似，至于UI的渲染和数据变更则由react去完成

2. 组件

   组件是react的最重要的组成部分，基本上绝大部分功能都由组件实现，一个页面可以拆分成多个组件复用

3. 跨平台

   react不仅可以写web应用，还可以通过 react native 开发原生应用

#### 2 基本使用

1. 安装react

   ```sh
   npm i react react-dom
   ```

   react：核心包，提供创建元素、组件等功能

   react-dom：提供与页面dom相关的功能

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
           const h1 = React.createElement('h1', null, 'Hello React')
           const h2 = React.createElement('h2', { title: 'HR' }, 'Hello React')
           // 渲染页面元素到页面上
           // 参数依次是被渲染的页面元素，要渲染到的页面元素
           ReactDOM.render(h1, document.getElementById('root'))
           ReactDOM.render(h2, document.getElementById('root'))
       </script>
   </body>
   ```

#### 3 脚手架

使用react脚手架创建react工程项目，只需要执行一条命令，就安装了`create-react-app`工具并创建了名为`my-app`的react项目

```sh
npx create-react-app my-app
cd my-app
npm start
```

> npx：npx 是 npm5.2.0 版本之后引入的命令工具，目的是提高npm的使用体验，可以在不下载npm模块包的情况下执行对应npm模块包的功能
>
> 比如上面的创建react项目的命令，按以往npm的方式需要先下载`create-react-app`后才能创建react项目，而使用npx直接一条命令搞定，也不用下载`create-react-app`

但是通过这个命令创建的react项目默认是最新版本的，比如当前创建的就是react18的版本

```json
// package.json

{
  "name": "my-app",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "@testing-library/jest-dom": "^5.17.0",
    "@testing-library/react": "^13.4.0",
    "@testing-library/user-event": "^13.5.0",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-scripts": "5.0.1",
    "web-vitals": "^2.1.4"
  },
}
```

如何创建指定版本的react项目呢？答案是没法指定，react脚手架没有提供这个功能，只能通过手动降级的方式

1. 修改`package.json`，降低react版本号及对应模块包的版本号

2. 删除`node_modules`文件夹和`package-lock.json`文件

3. 因为react18更改了挂载方式，所以还得修改`./src/index.js`文件

   ```js
   import React from 'react';
   // 18
   // import ReactDOM from 'react-dom/client';
   import ReactDOM from 'react-dom';
   import './index.css';
   import App from './App';
   import reportWebVitals from './reportWebVitals';
   
   // 18
   // const root = ReactDOM.createRoot(document.getElementById('root'));
   // root.render(
   //   <React.StrictMode>
   //     <App />
   //   </React.StrictMode>
   // );
   
   // 16
   const root = document.getElementById('root');
   ReactDOM.render(
     <React.StrictMode>
       <App />
     </React.StrictMode>,
     root
   );
   
   // If you want to start measuring performance in your app, pass a function
   // to log results (for example: reportWebVitals(console.log))
   // or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
   reportWebVitals();
   ```

4. 使用`npm install`重新安装对应模块包，如果其他模块包的版本不能确定可能会报错，可以添加参数安装

   ```shell
   npm install --legacy-peer-deps
   ```


#### 4 JSX

































