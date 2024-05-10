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

JSX 最初由 Facebook 在2013年创建并使用在 react 中，可以看作是 JavaScript 的一种语法拓展，允许你在 JavaScript 中书写 HTML 等标记语言

咋一看你可能会奇怪，在 js 中写 html ？这不是 UI 和逻辑混在一起了吗？是的，但是我们来看看 react 的解释：

react 的设计理念认为数据渲染逻辑和UI逻辑实际上是 **高度耦合** 的，形如 html 负责 UI，js 负责逻辑这样的分离其实并没有做到真正的分离，相反，这只是 **技术上的分离**，**关注点依然是高度耦合**的，既然如何，何不将他们都放到一起，反而省却了关注点反复在 UI 和 逻辑之间跳转的麻烦，具体可以观看YouTube上的介绍视频 [Pete Hunt: React: Rethinking best practices](https://www.youtube.com/watch?v=x7cQ3mrcKaY)

##### 4.1 变量及表达式

在 jsx 中，你可以直接书写 html，而不用加引号将其变成字符串，html 就是 html

```jsx
const element = <h1>Hello, James!</h1>
```

由于 jsx 就是 js 的语法，因此你可以定义普通的 js变量

```jsx
const name = 'James'
```

在 jsx 中使用变量时，只需要使用一对大括号将其包括起来就可以了

```jsx
const name = 'James'
const element = <h1>Hello, {name}!</h1>
```

当然，你也可以将 js表达式 放入大括号中，也是可以正常解析的，因为表达式计算出来最终也是一个变量

```jsx
function formatName(user) {
  return user.firstName + ' ' + user.lastName
}

const user = {
  firstName: 'Harry',
  lastName: 'Potter'
}

const element = <h1>Hello, {formatName(user)}!</h1>
```

由于 jsx 在编译之后就是普通的 js，所以你可以使用 `if` 、`for` 等 js 逻辑判断关键字

```jsx
function getGreeting(user) {
  if (user) {
    return <h1>Hello, {formatName(user)}!</h1>
  }
  return <h1>Hello, Stranger.</h1>
}
```

普通情况下，html标签的属性是字符串，也就是双引号包括起来的字符串，在 jsx 中你也可以使用大括号使用字符串变量

```jsx
const element = <a href="https://www.reactjs.org"> link </a>
const imgEle = <img src={user.avatarUrl}></img>
const para = <p className={p}></p>
```

> 1. 双引号和大括号不要一起使用，否则变量就变成字符串了
> 2. 由于 jsx 更近似于 js，所以 html 中的关键字 `class` 在 jsx 中变成了 `className`

jsx 中的 html标签 是闭合的，单标签也需要闭合

```jsx
const imgEle = <img src={user.avatarUrl} />
```

##### 4.2 渲染元素

元素是构建 react 应用的最小单位，但 jsx 中的元素不同于 html 中的元素，只是简单的对象，react 关注的是如何根据 jsx 中的元素去更新 html 中的元素

```jsx
const element = <h1>Hello, world</h1>
```

假设 html 中有个元素的 id 为 root

```jsx
<div id="root"></div>
```

要渲染元素到这个 root 元素上，首先需要调用 `ReactDOM.createRoot` 去获取这个 root 元素，然后再调用 `render` 方法去渲染元素

```jsx
const root = ReactDOM.createRoot(
  document.getElementById('root')
)
const element = <h1>Hello, world</h1>
root.render(element)
```

react 的元素是不可变的，一旦创建，将不能更改其子元素或属性，更新UI的方式是创建一个新的元素并将其传递给 `render` 方法

react 采用了高效的算法，只会更新改变的节点，尽管是创建的完整的新元素放进 `render` 方法，但未改变的节点不会更新

##### 4.3 组件

组件让你可以把UI拆分为独立可复用的片段，从概念上说，组件更像是 js函数，接收任意的参数，然后返回 react元素去描绘UI的样子

定义组件的最简单的方式就是直接写一个 js函数

```jsx
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>
}
```

也可以通过 es6 的 class 语法定义，两种方式对 react 来说都是一样的

```jsx
class Welcome extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}</h1>
  }
}
```

组件和元素都是一样的渲染方式，组件接收一个名为 `props` 的对象，其包含了传递给组件的属性

> 什么时候有必要写成组件呢？就是当某部分的UI被用到了好几次，或者其本身足够复杂，那么写成组件是个不错的选择

组件的 props 是 **不可变** 的，像下面的函数被称为 **纯净函数**，特点是没有修改传入的参数，相同的输入总有相同的输出

```jsx
function sum(a, b) {
  return a + b
}
```

react 的组件遵循纯净函数原则，绝对不要修改传入的 props

但是UI总是变动的，我们可以使用 state 去修改组件的输出

##### 4.4 状态和生命周期

状态 state 类似于 props，但是它是组件私有的，被组件完全管理，考虑有这样一个 Clock 组件

```jsx
class Clock extends React.Component {
  render() {
    return (
      <div>
        <h1>Hello, world!</h1>
        <h2>It is {this.props.date.toLocaleTimeString()}.</h2>
      </div>
    )
  }
}
```

render 函数在每次组件有更新时都会调用一次，但只要我们每次都把 Clock 组件 渲染进同一个 dom 节点，那么就始终只有一个 Clock 实例会被创建

现在将 Clock 组件从 props 改造成 state 的形式

```jsx
class Clock extends React.Component {
  // 添加构造函数，接收 props，调用父构造函数 super，给组件的 state 赋值
  constructor(props) {    
    super(props) 
    this.state = {date: new Date()}
  }
  render() {
    return (
      <div>
        <h1>Hello, world!</h1>
        <h2>It is {this.state.date.toLocaleTimeString()}.</h2>
      </div>
    )
  }
}

const root = ReactDOM.createRoot(document.getElementById('root'))
root.render(<Clock />)
```

但截止目前 CLock 组件还是不能自动更新时间，需要添加 **生命周期函数**（到了特定时机自动执行的函数）

比如 `componentDidMount()` 生命周期函数会在组件的输出已经渲染到 dom 上时自动执行，是个添加定时器的好时机

```jsx
componentDidMount() {
  this.timerID = setInterval(() => this.tick(), 1000)
}
```

`componentWillUnmount()` 生命周期函数会在组件即将卸载时自动执行，这是个销毁定时器的好时机

```jsx
componentWillUnmount() {
  clearInterval(this.timerID)
}
```

最后，编写 `tick()` 函数使用 `setState()` 函数更新 state 里的数据

```jsx
class Clock extends React.Component {
  constructor(props) {
    super(props)
    this.state = {date: new Date()}
  }

  componentDidMount() {
    this.timerID = setInterval(
      () => this.tick(),
      1000
    )
  }

  componentWillUnmount() {
    clearInterval(this.timerID)
  }

  tick() {
    this.setState({ date: new Date() })
  }
    
  render() {
    return (
      <div>
        <h1>Hello, world!</h1>
        <h2>It is {this.state.date.toLocaleTimeString()}.</h2>
      </div>
    )
  }
}

const root = ReactDOM.createRoot(document.getElementById('root'))
root.render(<Clock />)
```

回顾：

1. 当 CLock 组件被传递给 `root.render()` 函数时，react 执行了 CLock 组件的构造函数，初始化了 state 数据
2. CLock 组件执行内部的 `render()` 函数，输出对应的 jsx 元素对象，react 随后更新网页 dom
3. 当网页 dom 被更新后，CLock 组件的生命周期函数 `componentDidMount()` 被执行，该方法让浏览器设置了一个定时器用于更新时间
4. 每秒 `tick()` 函数被执行时，都会调用 `setState()` 函数去更新 state 里的时间值，一旦值发生改变，react 就会重新执行 `render()` 函数，页面重新渲染
5. 当页面关闭时，CLock 组件被卸载，`componentWillUnmount()` 执行，定时器被销毁



> 关于 state 应该注意的点：
>
> 1. 不要直接修改 state，这将不会触发组件的重新渲染，应该始终使用 `setState()` 函数去更改 state
> 2. 只能在构造函数里直接对 state 进行赋值
> 3. state 的更新可能是 **异步** 的





























