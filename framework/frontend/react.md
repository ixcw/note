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

jsx 中的 html 标签是闭合的，所以单标签也需要闭合

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

组件让你可以把UI拆分为独立可复用的片段，从概念上说，组件更像是 js 函数，接收任意的参数，然后返回 react 元素去描绘UI的样子

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

组件的 props 是 **不可变** 的，像下面的函数被称为 **纯函数**，特点是没有修改传入的参数，相同的输入总有相同的输出

```jsx
function sum(a, b) {
  return a + b
}
```

react 的组件遵循纯函数原则，绝对不要修改传入的 props，但是UI总是变动的，我们可以使用修改内部的状态 state 的方式去修改组件的输出

##### 4.4 状态

###### 4.4.1 状态更新流程

组件的内部状态 state 类似于 props，但是它是组件所私有的，被组件完全管理

考虑有这样一个 Clock 组件：

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

render 函数在每次组件有更新时都会调用一次，但只要我们每次都把 Clock 组件渲染进同一个 dom 节点，那么就始终只有一个 Clock 实例会被创建

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

###### 4.4.2 setState

关于 setState，牢记 **不可变值**  **不可变值**  **不可变值** ，**可能** 是异步更新，**可能** 会被合并，看见这个可能，就知道简单不了

函数组件没有 state 和 生命周期函数，但是都可以通过 hooks 解决

如果使用类组件，state 需要在构造函数中定义

```jsx
constructor(props) {
  super(props);
  this.state = {
    count: 0
  }
}
```

state 是不能 **直接修改** 的，要使用不可变值修改

```jsx
this.state.count++  // 这样直接修改是不行的
```

那我先直接修改，再使用 setState 修改可以吗？不行，仍然 **不能直接修改**

```jsx
this.state.count++
this.setState({
  count: this.state.count
})
```

但是你会发现 count 还是增加了，看似没问题，实际上还是有问题的，后面再解释

对数组进行操作时遵循一样的原则，不能先对数组进行修改，再去使用 setState 进行赋值，比如先对数组使用了 pop、push、splice 等会修改原数组的数组方法，不会修改原数组的方法是可以使用的，比如 concat、slice、map、filter 等

```jsx
this.setState({
  list: this.state.list.concat(100)  // 可以，因为返回了一个新数组
})
```

对对象的操作也是遵循一样的原则，不能直接修改对象的属性

```jsx
this.setState({
  obj: Object.assign({}, this.state.obj, { a: 100 }), // 可以，因为返回了一个新对象
  obj1: { ...this.state.obj1, a: 100 } // 同上
})
```

另一个点是，setState **可能** 是 **异步更新** 的，为什么说可能呢，请看下面的例子

```jsx
 this.setState({ num: 1 })
 console.log(this.state.num) // 0
```

在这个例子中我们使用 setState 改变了 num的值，然后立马打印 num 的值，发现 num 值并没有改变，即使我们把这句话封装成函数，每次点击按钮改变 num 的值，打印依然是滞后的，这说明 setState 的渲染是异步的，这有点类似于 Vue 的 $nextTick，那如何同步获取呢，在 setState 的回调里获取即可

```jsx
addNum = () => {
  this.setState({ num: this.state.num + 1 }, () => {
    console.log('setState callback: ', this.state.num)  // 可同步获取
  })
  console.log(this.state.num)
}
```

但是在 settimeout 里，setState 的表现是同步的

```jsx
setTimeout(() => {
  this.setState({ num: this.state.num + 1 }, () => {
    console.log('setState callback: ', this.state.num) // 先打印
  })
  console.log(this.state.num) // 后打印
}, 0)
```

自定义的事件中，setState 是同步的

```jsx
bodyClickHandler = () => {
  this.setState({ num: this.state.num + 1 })
  console.log('custom click: ', this.state.num)
}

componentDidMount() {
  document.body.addEventListener('click', this.bodyClickHandler)
}

componentWillUnmount() {
  document.body.removeEventListener('click', this.bodyClickHandler) // 及时销毁自定义事件
}
```

最后，setState 可能会被合并，什么意思呢，就是如果 setState 是异步更新的时候，不管写了几遍，都会被 **合并成一次**，这是 react 基于性能的考虑，比如

```jsx
addNum = () => {
  this.setState({ num: this.state.num + 1 })
  this.setState({ num: this.state.num + 1 })
  this.setState({ num: this.state.num + 1 })
  console.log(this.state.num)
}
```

最终 num 值只加了 1，怎么理解呢，可以理解为因为都是异步更新，所以不会立刻修改 num 值，而是之后统一修改，于是都只加了1，然后结果一合并，最终结果也是一样的了，类似于 `Object.assign()` 的属性合并，也是浅合并的

如何不被合并呢，传入回调函数（箭头函数或传统函数均可）修改即可，这次不会合并，函数是没法合并的，而是 +3，但打印仍然是滞后的

```jsx
addNum = () => {
  this.setState((prevState, props) => { return {num: prevState.num + 1} })
  this.setState((prevState, props) => { return {num: prevState.num + 1} })
  this.setState((prevState, props) => { return {num: prevState.num + 1} })
  console.log(this.state.num)  // 0
}
```

###### 4.4.3 单向数据流

react 中的组件数据是 **单向数据流** 的，react 的组件之间是互相独立的，但是父组件可以向子组件传递一些数据，子组件通过 props 接收这些数据，子组件只负责接收数据，并不关心这些数据是哪儿来的，无论是父组件的 state 或者 props 或者 直接手写的数据，都无所谓

可以在 props 传值的时候进行类型校验，类型校验需要安装一个库 `prop-types`，详情使用参考 [prop-types](https://www.npmjs.com/package/prop-types)

```jsx
import PropTypes from 'prop-types';

component.propTypes = {
  list: PropTypes.arrayOf(PropTypes.object).required,
  saveKey: PropTypes.func.isRequired,
  w: PropTypes.number,
  h: PropTypes.number
}
```

##### 4.5 生命周期

关于 react 组件的生命周期，有个网站做得很不错，可以看看：[react-lifecycle-methods-diagram](https://projects.wojtekmaj.pl/react-lifecycle-methods-diagram/)

1. 首先 react 组件会进入挂载阶段，先执行 constructor 构造方法，然后调用 render 函数渲染挂载，挂载成功后执行 `componentDidMount` 生命周期函数
2. 接着就进入更新阶段，每当有新的 props 或者调用 setState 变更 state 时，都会触发 shouldComponentUpdate 方法来决定是否应该调用 render 函数进行渲染，如果要调用，则渲染完成后执行 `componentDidUpdate` 生命周期函数
3. 最后进入卸载阶段，这个阶段 render 函数不再起作用，一般用于销毁定时器、自定义事件等，卸载完成会执行 `componentWillUnmount` 生命周期函数

至于父子组件的生命周期，和 vue 完全一致，请参考 vue


#### 5 事件处理

react 的事件处理和原生 dom 事件处理是非常相似的

原生：

```html
<button onclick="activateLasers()">
  Activate Lasers
</button>
```

react：

```jsx
<button onClick={activateLasers}>  Activate Lasers
</button>
```

可以看到 react 使用了驼峰命名，使用大括号传递了函数名称，也不用使用小括号

另外在 react 中阻止默认事件不能像原生一样简单的返回一个 false，必须明确指出 preventDefault

原生：

```html
<form onsubmit="console.log('You clicked submit.'); return false">
  <button type="submit">Submit</button>
</form>
```

react：

```jsx
function Form() {
  function handleSubmit(e) {
    e.preventDefault();
    console.log('You clicked submit.');
  }

  return (
    <form onSubmit={handleSubmit}>
      <button type="submit">Submit</button>
    </form>
  );
}
```

需要注意的是，这里的事件 e 是一个合成事件，不能完全等同于原生事件，但其由 w3c 规范定义而来，因此有很好的兼容性

当使用 es6 的 class 语法定义组件时，将事件处理写成类里面的方法是比较好的做法

```jsx
class Toggle extends React.Component {
  constructor(props) {
    super(props);
    this.state = {isToggleOn: true};
    // This binding is necessary to make `this` work in the callback
    this.handleClick = this.handleClick.bind(this);  
  }

  handleClick() {
      this.setState(prevState => ({
          isToggleOn: !prevState.isToggleOn    
      }));
  }
    
  render() {
    return (
      <button onClick={this.handleClick}>
            {this.state.isToggleOn ? 'ON' : 'OFF'}
      </button>
    );
  }
}

ReactDOM.render(
  <Toggle />,
  document.getElementById('root')
);
```

> 在 jsx 的回调中应该小心 this 的指向，在 jsx 中，class 的方法默认是不绑定在 class 的 this 上的，默认指向 undefined，所以需要我们手动进行绑定，如上面的代码那样，如果不这么做，在调用方法时将会报 undefined 错误

如果不想每次都在构造函数中绑定 this，也可以使用新语法**公有类字段**（ public class fields ），使用箭头函数定义函数并赋值给类的字段

```jsx
class LoggingButton extends React.Component {
    handleClick = () => {
        console.log('this is:', this);
    }
    
    render() {
        return (
            <button onClick={this.handleClick}>
                Click me
            </button>
        );
    }
}
```

另一种办法是在回调里面使用箭头函数

```jsx
class LoggingButton extends React.Component {
  handleClick() {
    console.log('this is:', this);
  }

  render() {
    return (
      <button onClick={() => this.handleClick()}>
        Click me
      </button>
    );
  }
}
```

> 但是这种办法的缺点是每次 render button 时，都会生成一个不同的回调函数，如果这个回调是作为 prop 传递给子组件时，可能触发一次多余的重绘，故为避免这种情况产生性能问题，应当使用构造函数绑定 this 或共有类字段的办法改变 this 指向

在回调中给事件传递参数需要注意，也要使用箭头函数或者绑定 this，不然回调中的函数会立即执行，因为回调中希望接收的是一个函数，而不是函数的执行

```jsx
<button onClick={(e) => this.deleteRow(id, e)}>Delete Row</button>
<button onClick={this.deleteRow.bind(this, id)}>Delete Row</button>
```

> e 表示 react 的事件，通常被当做第二个参数传递给函数，在使用箭头函数时必须显式地传递，但是使用 bind 的方式会自动传递

#### 6 条件渲染

react 的条件判断与 js 中的条件判断完全一致，这意味着你可以使用 if 等语句决定哪一个组件会被返回渲染

```jsx
class LoginControl extends React.Component {
  constructor(props) {
    super(props);
    this.handleLoginClick = this.handleLoginClick.bind(this);
    this.handleLogoutClick = this.handleLogoutClick.bind(this);
    this.state = {isLoggedIn: false};
  }

  handleLoginClick() {
    this.setState({isLoggedIn: true});
  }

  handleLogoutClick() {
    this.setState({isLoggedIn: false});
  }

  render() {
    const isLoggedIn = this.state.isLoggedIn;
    let button;
    if (isLoggedIn) {
      button = <LogoutButton onClick={this.handleLogoutClick} />;
    } else {
      button = <LoginButton onClick={this.handleLoginClick} />;
    }
    return (
      <div>
        <Greeting isLoggedIn={isLoggedIn} />
        {button}
      </div>
    );
  }
}

ReactDOM.render(
  <LoginControl />,
  document.getElementById('root')
);
```

可以使用 `&&` 进行判断

```jsx
function Mailbox(props) {
  const unreadMessages = props.unreadMessages;
  return (
    <div>
      <h1>Hello!</h1>
      {unreadMessages.length > 0 &&
         <h2>You have {unreadMessages.length} unread messages.</h2>
      }
    </div>
  );
}

const messages = ['React', 'Re: React', 'Re:Re: React'];
ReactDOM.render(
  <Mailbox unreadMessages={messages} />,
  document.getElementById('root')
);
```

如果 `&&` 前面的条件为真，则整个表达式的值为 `&&` 后面的值，相反，整个表达式的值为 false，react 会忽略这个值并跳过它

如果 `&&` 前面的值不是 boolean 而是别的类型，那将会被 react 返回而不会跳过，下面的代码最终返回 `<div>0</div>`

```jsx
render() {
  const count = 0;  
  return (
    <div>
      { count && <h1>Messages: {count}</h1>}
    </div>
  );
}
```

三元表达式也是个不错的选择

```jsx
render() {
  const isLoggedIn = this.state.isLoggedIn;
  return (
    <div>
      The user is <b>{isLoggedIn ? 'currently' : 'not'}</b> logged in.
    </div>
  );
}

// 或者

render() {
  const isLoggedIn = this.state.isLoggedIn;
  return (
    <div>
      {isLoggedIn
         ? <LogoutButton onClick={this.handleLogoutClick} />
         : <LoginButton onClick={this.handleLoginClick} />
      }
    </div>
  );
}
```

如果想隐藏一个组件使其不被渲染，那么可以直接在组件的 render 函数中返回一个 null 即可

```jsx
function WarningBanner(props) {
  if (!props.warn) { return null; }
  return (
    <div className="warning">
      Warning!
    </div>
  );
}

class Page extends React.Component {
  constructor(props) {
    super(props);
    this.state = {showWarning: true};
    this.handleToggleClick = this.handleToggleClick.bind(this);
  }

  handleToggleClick() {
    this.setState(state => ({
      showWarning: !state.showWarning
    }));
  }

  render() {
    return (
      <div>
        <WarningBanner warn={this.state.showWarning} />
        <button onClick={this.handleToggleClick}>
          {this.state.showWarning ? 'Hide' : 'Show'}
        </button>
      </div>
    );
  }
}

ReactDOM.render(
  <Page />,
  document.getElementById('root')
);
```

#### 7 循环渲染

react 可以使用 js 的 map 、for 等循环去处理循环

```jsx
const numbers = [1, 2, 3, 4, 5];
const listItems = numbers.map((number) => <li>{number}</li>);

ReactDOM.render(
  <ul>{listItems}</ul>,
  document.getElementById('root')
);
```

在我们渲染一个列表时，有必要给列表项赋予一个 key

```jsx
function NumberList(props) {
  const numbers = props.numbers;
  const listItems = numbers.map((number) =>
    <li key={number.toString()}>
      {number}
    </li>
  );
  return (
    <ul>{listItems}</ul>
  );
}

const numbers = [1, 2, 3, 4, 5];
ReactDOM.render(
  <NumberList numbers={numbers} />,
  document.getElementById('root')
);
```

为什么需要赋予一个 key 呢，通常这是为了帮助 react 标记列表项，更好的分辨列表项有无修改，更好的做法是使用数组元素中的**唯一的 id 值**

```jsx
const todoItems = todos.map((todo) =>
  <li key={todo.id}>
    {todo.text}
  </li>
);
```

如果没有这样的 id，也可以使用数组索引 index 代替

```jsx
const todoItems = todos.map((todo, index) =>
  <li key={index}>
    {todo.text}
  </li>
);
```

但请注意，在数组元素可能发生修改或者排序的情况下不推荐这样做，很有可能会影响性能，甚至对组件状态产生影响，在你不给出具体的 key 的情况下，react 会 **默认** 使用 index 作为 key

为什么会这样呢，因为 key 是 react 唯一用来标识 dom 元素的东西，如果你增加删除列表项时使用了相同的 key，react 会认为这个列表项和之前的列表项是同一个列表项，具体可以看看这篇文章了解 [Index as a key is an anti-pattern](https://robinpokorny.medium.com/index-as-a-key-is-an-anti-pattern-e0349aece318)

> key 的唯一只需要保证在当前数组中唯一即可，不同的数组中可以使用相同的 key

#### 8 form表单

原生的 form 表单有其默认行为，比如提交时会访问新的网页

在 react 中比较好的做法是自己去控制 form 的行为，也就是控制组件（controlled components）

不同于 vue 的是， vue 里面有 v-model 双向绑定，但是 react 得自己实现，从视图到值的更新一般需要我们自己去绑定一个 change 事件去监听值的变化，从而更新对应的 state 值

至此，可以理解所谓 **受控组件** 就是组件和 state 关联起来了，可以通过 state 去控制组件

```jsx
class NameForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {value: ''};
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({value: event.target.value});
  }
  
  handleSubmit(event) {
    alert('A name was submitted: ' + this.state.value);
    event.preventDefault();  // 阻止 form 的默认行为
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <label>
          Name:
          <input type="text" value={this.state.value} onChange={this.handleChange} />             </label>
        <input type="submit" value="Submit" />
      </form>
    );
  }
}
```

#### 9 组合 children

是继承还是组合使用，react 推荐组合，当你想要构建的组件不知道以后想放什么内容进去时，你可以使用 `props.children` ，这在别的库里面类似于 slot 的概念

```jsx
function FancyBorder(props) {
  return (
    <div className={'FancyBorder FancyBorder-' + props.color}>
      {props.children}
    </div>
  );
}

function WelcomeDialog() {
  return (
    <FancyBorder color="blue">
      <h1 className="Dialog-title">Welcome</h1>
      <p className="Dialog-message">
        Thank you for visiting our spacecraft!
      </p>
    </FancyBorder>
  );
}
```

但如果你需要多个 slot，可以自定义名称而不是单一的 children

```jsx
function SplitPane(props) {
  return (
    <div className="SplitPane">
      <div className="SplitPane-left">
        {props.left}
      </div>
      <div className="SplitPane-right">
        {props.right}
      </div>
    </div>
  );
}

function App() {
  return (
    <SplitPane
      left={<Contacts />}
      right={<Chat />} />
  );
}
```

> 记住 react 的组件可以接收任意的 props，不管是原始的 js 变量，还是 react 元素或者是函数

#### 10 高级特性

##### 10.1 函数组件

只接收 props 去渲染组件的情况下，函数组件是更方便的，更简单的语法，不用写继承语法，也不用写构造函数以及 render 函数，函数组件更符合 react 的设计理念：纯函数

首先了解一下函数式编程，函数式编程（FP）和面向对象编程（OOP）是编程界的两大编程范式

函数式编程以函数为基本单位，更关注数据的映射关系，尽量避免状态的变化

纯函数是函数式编程中的重要概念，纯函数是指函数的输出只依赖于函数的输入，且在函数的运行过程中不会产生副作用，常见的副作用有：改变了全局变量、修改了函数的输入参数、执行了 I/O 操作等等

简单的纯函数例子：

```js
// add 的返回值只依赖于 x 和 y，且不改变任何函数外部的值
function add(x, y) {
  return x + y;
}
```

纯函数的优点：

1. 函数行为是可预测的，给定相同的输入，就一定会有相同的输出
2. 由于纯函数不产生副作用，使得代码更容易理解和维护

常见的纯函数有数组里的 map、filter、reduce等等不改变原数组的数组方法

高阶函数：在函数式编程中，函数可以作为参数传递，也可以作为返回值返回，这种能够操作函数的函数称为高阶函数，高阶函数提供了强大的抽象机制，可以帮助我们编写更为灵活重用的代码，比如下面的代码

```js
function greaterThan(n) {
  return m => m > n;
}
let greaterThan10 = greaterThan(10);
console.log(greaterThan10(11));  // 输出：true
```

高阶函数最主要的用途是创建可配置的函数，比如我们在上面的代码中我们使用高阶函数 `greaterThan` 创建了一个可配置的函数 `greaterThan(10)` 并用 `greaterThan10` 变量去接收这个函数

又比如抽象重复代码：

```js
// 将 func 函数应用于数组的每个元素
function map(func, array) {
  let result = [];
  for (let item of array) {
      result.push(func(item));
  }
  return result;
}
```

说回函数组件，函数组件没有生命周期，没有 state，也没有实例（不是 class 嘛），函数组件可 **视为一个纯函数** （故 props 不可变），输入 props，输出 jsx，所以当不需要设置 state，不需要在生命周期执行操作时，选择函数组件是不错的选择，当然，通过其他的一些方法函数组件也能实现这些功能，这个后面再介绍

##### 10.2 非受控组件

非受控组件使用 ref，类似于 vue 里面的 ref 来标记 dom 元素，然后通过 vue 的 api 去获取这个 dom 元素，获取之后就可以 **操作** 这个 dom 元素

```js
this.$nextTick(() => {
  const elem = this.$refs.refId  // refId 是 ref 指定的 id 值
})
```

同理，在 react 中也是类似的

```jsx
// 首先在构造函数中创建 ref
constructor(props) {
  super(props)
  this.state = {
    name: 'james'
  }
  this.nameInputRef = React.createRef()
}

render() {
  return <div>
      // 然后在 dom 元素上使用 ref
      <input defaultValue={this.state.name} ref={this.nameInputRef} ></input>
    </div>
}
```

定义好了之后如何获取 dom 元素呢，同样，通过固定的 api 获取

```js
const elem = this.nameInputRef.current
alert(elem.value)
```

可以看到，input 中的值不管怎么变，都不会影响 state 中的值，因为没有绑定 onChange 事件，而 state 中的值不管怎么变，同样不影响 input 中的值，state 中的值和 input 的唯一关系是它给 input 赋了一个默认值，所以我们在 input 中绑定的是 defaultValue，而不是 value，同理 checkbox 得用 defaultChecked

再比如上传文件，如果使用受控组件，将比较难以获取文件名字，但是如果使用非受控组件，将变得容易：

```jsx
<input type="file" ref={this.fileInputRef}></input>

const elem = this.fileInputRef.current
alert(elem.files[0].name)
```

因此，如果使用 setState 不能实现的场景，必须手动操作 dom 的场景，就很适合非受控组件，比如上传文件，或者需要给富文本编辑器传递 dom 元素的时候

但是需要注意，优先使用受控组件，因为更符合 react 的设计原则，通过 state 数据驱动视图，但当必须操作 dom 时，就得使用非受控组件了

##### 10.3 portals

我们知道 react 的组件默认会按父组件嵌套子组件的形式一层一层地进行渲染，这和 dom 树是一一对应的，但是某些情况下需要我们把组件 **渲染到父组件以外**，这时就不能按照常规的渲染了，比如有时候我们使用了固定定位 fixed，为了兼容浏览器，比如 UC 浏览器，使用 fixed 定位的元素最好放到最外层渲染

```jsx
render() {
    return <div className="modal">
        {this.props.children}
    </div>
}
```

这里我们返回了一个 class 名为 modal 的 div 元素，modal 是 fixed 定位的，`this.props.children` 类似于 vue 中的 slot 语法，接收父组件的 **内容**

怎么让它渲染到外层 dom 呢，我们可以使用 `react-dom` 提供的 api

```jsx
import ReactDOM from 'react-dom'

render() {
    return ReactDOM.createPortal(
    	<div className="modal">{this.props.children}</div>,
        document.body  // 这里写的是 body，但是你想把参数里的 dom 元素传到哪儿，就写哪儿的 dom 元素
    )
}
```

其他常见场景包括父组件设置了 `overflow: hidden;`，或父组件的 `z-index` 值太小等 css 布局问题，都可以使用 portals 变更子组件的渲染地点

##### 10.4 context

如果有公共信息需要传递给每一个组件，比如主题、语言等，每个组件都用 props 去接收吗？显然是不太现实的，那你说可以用 redux 呀，可以，但是有点小题大做了，比如主题和语言没什么逻辑，数据结构也不复杂，没有必要用 redux 去管理，这时就可以用 context 上下文环境去做这个事情，顾名思义，context 很适合用来设置环境

```jsx
import React from 'react'
// 1. 创建一个 context 并赋值一个默认值
const ThemeContext = React.createContext('light')

// 5. 函数组件想要消费 context，由于函数组件没有实例，无法使用 this，故只能使用固定 api 去消费
function ThemeLink() {
    return <ThemeContext.Consumer>
        {value => <p>the link theme is {value}</p>}
    </ThemeContext.Consumer>
}

// 4. class 组件想要消费 context，需要指定 contextType
class ThemeButton extends React.Component {
    static contextType = ThemeContext // es6 新语法指定一个静态属性
    
    render() {
        // 指定完静态属性 contextType 之后就可以使用 context 了
        // react 会自动往上找到最近的 context 生产方
        const theme = this.context
        return <div>
            <p>the button theme is {theme}</p>
        </div>
    }
}
ThemeButton.contextType = ThemeContext // 常规写法，都是静态属性，选一种写法即可

// 3. 中间组件可消费 context，也可什么都不做
function Toolbar(props) {
    return (
        <div>
        	<ThemeButton />
        	<ThemeLink />
        </div>
    )
}

class App extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            theme: 'light'
        }
    }
    
    changeTheme = () => {
        this.setState({ theme: this.state.theme === 'light' ? 'dark' : 'light' })
    }
    
    render() {
        // 2. 然后我们需要在最外层组件生产出 context 的值，value 是为了动态改变其值，因为默认值是修改不了的
        return <ThemeContext.provider value={this.state.theme}>
        	<Toolbar />
            <hr />
            <button onChange={this.changeTheme}>change theme</button>
        </ThemeContext.provider>
    }
}
```

##### 10.5 异步组件

若某些组件体积比较大，需要用异步加载的方式提高性能

vue 里面使用的是 `import()`，react 用的是自己的 api：`React.lazy` 和 `React.Suspense`

```jsx
// 首先异步引入组件
const ContextDemo = React.lazy(() => import('./ContextDemo'))

class App extends React.Component {
    render() {
        return <div>
            // 然后就可以通过 suspense 引用了
            // 异步组件通常需要等待，所以设置 fallback 显示等待时显示的内容
            // 调试时可以设置低速网络进行测试，异步组件会被打包，作为最后一个 js 文件进行加载
            <React.Suspense fallback={<div>loading...</div>}>
            	<ContextDemo />
            </React.Suspense>
        </div>
    }
}
```

##### 10.6 性能优化 SCU

性能优化在 react 中是很重要的

SCU 的全称是 shouldComponentUpdate，是组件生命周期中的一个方法，通过返回 true 或 false 来决定是否执行 render 方法进行渲染

```jsx
shouldComponentUpdate(nextProps, nextState) {
    if (nextState.count !== this.state.count) {
        return true  // 可以渲染
    }
    return false  // 不重复渲染
}
```

SCU 默认是返回 true 的，你也许想问，既然这个东西是和性能优化有关的，那么 react 为什么不把它直接做到内部函数里面，反而要把它暴露给开发者，给开发者一个自由选择的权利，由开发者去决定是否渲染呢？问得好，这个问题是一个重点，下面进行解释

首先，在 react 的设计里面，只要父组件有数据更新，那么子组件也会 **无条件** 进行更新，不管子组件的数据有没有更新，都会执行 `componentDidUpdate` 这个生命周期函数，为什么呢？因为 SCU 默认是返回 true 的

```jsx
shouldComponentUpdate(nextProps, nextState) {
    return true
}
```

如何优化呢，按照上面的方法通过判断 props 或 state 的前后状态，进行限制即可

那么新的问题又来了，什么时候该用 SCU 呢，需要在每一个不需要更新的子组件上都加上 SCU 判断吗？这显然是不现实的，那什么时机该用呢？很简单，如果 **重复渲染导致页面卡顿已经影响到了业务**，那么这个时候就应该考虑使用 SCU 了，因为技术是为业务服务的，而不是为了追求极致的技术和性能

还记得我们前面说过 setState 需要使用不可变值吗，其实这和 SCU 有关，举个例子，我们写个组件接收一个 list 数组，然后渲染这个数组成一个列表，每次使用 SCU 进行判断，利用 lodash 的 isEqual 深层比较判断前后 list 数组是否相同，但是我们每次添加数组元素去改变 list 数组，却并没有更新对应的视图，检查发现是因为在改变 list 数组时是直接使用了 push 方法去新增的，然后再使用 setState 去修改，这明显违背了不可变值的原则

这个也是容易理解的，你先 push，那么 state 的值就已经变了，这个时候你再去调用 setState 修改，nextState 的值也变成和 state 的值一样的值了，所以 SCU 会错误地判断没有发生修改，一直返回 false 导致不执行 render 方法，也就是页面不执行重新渲染，故视图没有更新，解决办法也很简单，遵循 react 的不可变值原则即可

react 提供了纯组件 PureComponent 实现了 SCU 的浅比较，只比较 state 或 props 中的第一层，发现不一样则返回 true，纯组件是 class 组件，另一个纯函数是 memo，只不过 memo 是函数组件

其实浅比较已经适用于大多数场景，尽量不要使用深度比较，因为比较耗费性能

```jsx
class List extends React.PureComponent {}

function MyComponent(props) {}

function isEqual(prevProps, nextProps) {} // 实现一个类似 SCU 的比较

export default React.memo(MyComponent, isEqual)
```

最后介绍一下 `immutable.js`，多人合作时，总有人忽略了性能优化，没有使用不可变值导致出现 bug，如果引入这个库，那么将会采用类似于深拷贝的方式，但实际上是基于共享数据的，速度还不错，有一定学习成本，需要均衡考虑是否使用

##### 10.7 高阶组件

有时我们需要将一些组件的公共逻辑抽离出来，你可能最先想到了 mixin，但是和 vue 一样，mixin 已经被 react 废弃了，原因很简单，mixin 会导致难以维护，不好追踪代码来源，react 有更好的方案代替，这就是高阶组件 HOC 和 Render Props

首先高阶组件 HOC 不是一种功能，而是一种 **模式**，类似于设计模式中的工厂模式

首先定义一个工厂函数，工厂函数接收一个待改造的组件，然后在工厂函数内部实现我们要抽离的公共逻辑，最后将待改造的组件融合公共逻辑之后生成一个新的组件，最后返回新的组件，这就像是一个生产新函数的工厂一样

```jsx
const HOCFactory = (Component) => {
  class HOC extends React.Component {
    // 在此实现公共逻辑
    render() {
      return <Component {...this.props} />
    }
  }
  return HOC
}

const EnhancedComponent1 = HOCFactory(Component1)
const EnhancedComponent2 = HOCFactory(Component2)
```

redux 的 connect 就是一个高阶组件

#### 11 redux

redux 类似于 vue 里面的 vuex 或者 pinia，是一个状态管理工具库，可以对整个应用中的状态进行集中管理，并且确保状态只能以可预测的方式进行更新

使用 redux 的理由和 vue 中的 vuex 是一样的，没有状态管理之前，应用一旦变得复杂，组件层级过多，组件之间的传值也会变得繁琐，且不容易追踪状态的变化，极大地增加了代码维护的难度，而有了 redux 之后，状态被集中管理，各个组件都只需要和 redux 的状态库进行交互，传值变得简单，状态变化也变得可追踪，代码可维护性也提高了

##### 11.1 工作流程

1. 首先 react 的组件需要 取/改 状态仓库（store）中的数据，于是发起（dispatch）一个动作（action）
2. store 接收到了这个 action，得知了 react 组件想要做的操作，于是将 action 和当前的状态（state）传递给了归纳（reducer）去处理，reducer 内部有定义好的逻辑操作，经过 reducer 的处理之后，reducer 返回了一个新的 state 给 store
3. store 将新的 state 拿给 react 组件，react 组件完成了想要的 action，整个工作流程完成

打个比喻，react 组件就像去图书馆借书的人，图书馆就是 store，借书人说我要借某某某书，说的这句话就是 action，图书馆自然无法理解这句话，但是图书管理员也就是 reducer 可以，reducer 通过这句话去找到了这本书，找的过程就是 reducer 进行逻辑处理的过程，reducer 最终把书 state 拿到图书馆 store，借书人 react 组件拿到了想要借的书

##### 11.2 创建 store

首先通过 npm 安装 redux

```shell
npm install --save redux
```

然后一般情况下是在 src 文件夹下新建一个名为 store 的文件夹，再创建一个 `index.js` 文件，用于创建 store

```js
// index.js
import { createStore } from "redux"

const store = createStore()

export default store
```

##### 11.3 创建 reducer

但是光有 store 是不行的，就像图书馆还需要一个图书管理员吧，所以我们还得创建一个 reducer，再新建一个 `reducer.js` 文件

```js
// reducer.js
const defaultState = {  // 为 state 创建一个默认值
  inputValue: '',
  list: []
}

export default (state = defaultState, action) => {
  return state
}
```

在 `index.js` 中引入 reducer

```js
import { createStore } from "redux"
import reducer from "./reducer"

const store = createStore(reducer)

export default store
```

##### 11.4 获取 state

store 创建完毕后就可以获取其中的 state 了，可以通过 `getState` 去获取

```js
// TodoList.js
import React, { Component } from "react";
import store from "./store";

class TodoList extends Component {

  constructor(props) {
    super(props)
    this.state = store.getState()  // 通过 getState() 可以获取到 store 的 state
    console.log(this.state)
  }

  render() {
    return (
      <div>
        {this.state.list}
      </div>
    )
  }
}

export default TodoList
```

##### 11.5 修改 state

如果想要修改 store，只能发起一个 action，action 携带想要做的操作和传递的信息

```jsx
inputChangeHandler = (e) => {
  // 创建一个 action
  const action = {
    type: 'change_input_value',  // 想要做的操作
    value: e.target.value  // 传递的信息
  }
  store.dispatch(action)  // 发起 action
}
```

action 发送到 store 后，store 会将 action 交给 reducer 处理，注意在 reducer 中不能修改 state，只能返回一个新的 state

```js
// reducer.js
const defaultState = {
  inputValue: '',
  list: [1,2,3]
}

export default (state = defaultState, action) => {
  // reducer 对 action 进行处理
  if (action.type === 'change_input_value') {
    const newState = Object.assign({}, state, { // 利用 Object.assign 创建新的 state
      inputValue: action.value
    })
    return newState
  }
  return state
}
```

但此时你会发现，页面并没有更新，此时我们需要设置订阅函数去监听 store 的 state 的改变，从而手动去更新视图

```js
constructor(props) {
  super(props)
  this.state = store.getState()
  store.subscribe(this.storeChangeHandler)  // 设置订阅函数
}

storeChangeHandler = () => {
  this.setState(store.getState())  // 手动更新 state
}
```

同理，给 state 的 list 数组增加项也是一样的

```js
// 定义处理函数，创建并发送 action
addHandler = () => {
  const action = {
    type: 'add_todo_item'
  }
  store.dispatch(action)
}
```

在 reducer 中处理 action

```js
export default (state = defaultState, action) => {
  // reducer 对 action 进行处理
  if (action.type === 'change_input_value') {
    const newState = Object.assign({}, state, {
      inputValue: action.value
    })
    return newState
  }
  if (action.type === 'add_todo_item') {
    const newState = { ...state }
    newState.list.push(newState.inputValue)
    newState.inputValue = ''
    return newState
  }
  return state
}
```

删除数组项也是类似的

```js
// 绑定删除事件
renderItem={(item, index) => (
  <List.Item onClick={this.deleteItem.bind(this, index)}>
      {item}
  </List.Item>
)}

// 创建发送 action
deleteItem = (index) => {
  const action = {
    type: 'delete_todo_item',
    index
  }
  store.dispatch(action)
}
```

在 reducer 中处理 action

```js
if (action.type === 'delete_todo_item') {
  const newState = JSON.parse(JSON.stringify(state))
  newState.list.splice(action.index, 1)
  return newState
}
```

此时也许你会疑问怎么现在不用设置订阅函数了呢，因为只需要设置一次，就会在当前组件一直生效

##### 11.6 拆分 action

截至目前，我们每次需要修改 store 的 state 的时候，都需要在事件处理函数中创建并发起一个 action，然后 store 收到 action 后将 action 送给 reducer 函数去处理，reducer 函数判断 action 的 type 字段，从而选择对应的处理操作，产生一个新的 state 返回给 store，最后组件监听到了 store 的 state 的改变，重新设置组件的 state，触发页面的更新

这个流程有什么问题呢？

1. 万一 type 写错，是不方便排查错误的，因为这只是字符串的相等判断，字符串写错了不属于语法错误，控制台是不会报错的
2. 不方便修改，万一 type 需要修改，则需要改两个地方，定义 type 的地方和 reducer 中使用 type 的地方
3. 每次都需要创建 action，还是很麻烦的，而且 action 的代码是有大量重复的

这是可以改进的，我们可以专门定义一个 `actionType.js` 文件用于处理 action 的 type

```js
// actionType.js
export const CHANGE_INPUT_VALUE = 'change_input_value'
export const ADD_TODO_ITEM = 'add_todo_item'
export const DELETE_TODO_ITEM = 'delete_todo_item'
```

然后在组件 `TodoList.js` 中引入使用

```js
// TodoList.js
import {
  CHANGE_INPUT_VALUE,
  ADD_TODO_ITEM,
  DELETE_TODO_ITEM
} from './store/actionType'

inputChangeHandler = (e) => {
  const action = {
    type: CHANGE_INPUT_VALUE,
    value: e.target.value
  }
  store.dispatch(action)
}

addHandler = () => {
  const action = {
    type: ADD_TODO_ITEM
  }
  store.dispatch(action)
}

deleteItem = (index) => {
  const action = {
    type: DELETE_TODO_ITEM,
    index
  }
  store.dispatch(action)
}
```

同理，在 `reducer.js` 中引入使用

```js
// reducer.js
import {
  CHANGE_INPUT_VALUE,
  ADD_TODO_ITEM,
  DELETE_TODO_ITEM
} from './store/actionType'

const defaultState = {
  inputValue: '',
  list: []
}

export default (state = defaultState, action) => {
  // reducer 对 action 进行处理
  if (action.type === CHANGE_INPUT_VALUE) {
    const newState = Object.assign({}, state, {
      inputValue: action.value
    })
    return newState
  }
  if (action.type === ADD_TODO_ITEM) {
    const newState = { ...state }
    newState.list.push(newState.inputValue)
    newState.inputValue = ''
    return newState
  }
  if (action.type === DELETE_TODO_ITEM) {
    const newState = JSON.parse(JSON.stringify(state))
    newState.list.splice(action.index, 1)
    return newState
  }
  return state
}
```

可能你会觉得这样做不是更麻烦了吗？多了一个文件，而且看代码时需要多理解一步，需要将常量名转换一下，再去多的文件去查看，确实更麻烦了，但也带来了如下好处：

1. 错误更容易排查，即使你写错了常量的值，也不影响 reducer 对常量是否相等的判断，并且如果你写错了常量名称，那么将会报变量未定义的错误，错误明显更容易排查了
2. 假如 type 需要修改，那么只需要改一个地方，那就是定义常量的那个文件，组件和 reducer 中的 type 不用修改

目前已经解决了前两个问题，还有第3个问题每次都创建 action 的麻烦问题，对于这个问题，我们可以创建一个文件去统一创建 action

```js
// actionCreator.js
// 引入 type
import {
  CHANGE_INPUT_VALUE,
  ADD_TODO_ITEM,
  DELETE_TODO_ITEM
} from './actionType'

export const getInputChangeAction = (value) => ({
  type: CHANGE_INPUT_VALUE,
  value
})

export const getAddTodoItemAction = () => ({ type: ADD_TODO_ITEM })

export const getDeleteTodoItemAction = (value) => ({
  type: DELETE_TODO_ITEM,
  value
})
```

这样就可以在这个文件中完成 action 的 type 引用，所以组件中的 type 就不需要引入了，组件中的代码变成这样

```js
// TodoList.js

import {
  getInputChangeAction,
  getAddTodoItemAction,
  getDeleteTodoItemAction
} from './store/actionCreator'

inputChangeHandler = (e) => {
  const action = getInputChangeAction(e.target.value)
  store.dispatch(action)
}

storeChangeHandler = () => {
  this.setState(store.getState())
}

addHandler = () => {
  const action = getAddTodoItemAction()
  store.dispatch(action)
}

deleteItem = (index) => {
  const action = getDeleteTodoItemAction(index)
  store.dispatch(action)
}
```

如此一来，代码简洁了很多，也不用引入 type 了

##### 11.7 异步请求

和 vue 一样，异步请求的发出一般是在生命周期函数中进行，react 是在 `componentDidMount` 已挂载生命周期函数中发出请求，获得请求的数据后，按照 redux 的修改流程走就行了，创建 action，派送 action，最后 reducer 更新 store 的 state，页面监听到更新，重新渲染页面

##### 11.2 redux-thunk

在上一节的异步请求中，看似发送一个请求是非常简单的，但是如果一个组件中这样的请求多了之后，是很不好维护的，看上去也一团乱，我们可以把这些请求统一地移到一个地方进行管理，redux-thunk 就是做这样事情的一个中间件，它能把这些请求放到 action 中去处理

首先安装 redux-thunk

```shell
npm install redux-thunk --save
```

然后在创建 redux 的 store 的时候引入相关 api，使用这个中间件

```js
// store/index.js
import { createStore, applyMiddleware } from "redux"  // 引入 applyMiddleware
import { thunk } from "redux-thunk"  // 引入 redux-thunk
import reducer from "./reducer"

const store = createStore(
  reducer, 
  applyMiddleware(thunk)  // 应用中间件，如果想同时使用 redux-devtools 中间件，请查询官网了解
)

export default store
```

在之前 `actionCreator.js` 中创建 action 时，我们都是通过函数返回了一个 action 对象，但是用了 thunk 中间件之后，我们可以返回一个函数了，在函数中可以执行异步操作

```js
// actionCreator.js
export const getTodoList = () => {
  return (dispatch) => { // 外部派发，内部可以接收到 dispatch
    // 执行异步操作，成功获取结果后，将结果通过 action 派发出去修改 store
  }
}
```

在外部文件中依然正常创建 action，只不过现在这个 action 是一个函数，在派发的时候会自动执行一次

```js
componentDidMount() {
  const action = getTodoList()  // 此时的 action 是一个函数
  store.dispatch(action)  // dispatch 的同时会执行这个 action 函数
}
```

也许你会问，这样不是更麻烦了吗，还得安装包，各种配置，中间还多了一层函数封装，的确更麻烦了，但是随着应用的不断增大，你会发现这种集中处理请求的方式是更容易 **维护管理** 的

其实读到这里，你可能还是对中间件这个概念感到模糊，中间件顾名思义类似于中间人，是夹在中间的角色，负责在两个角色中间处理事务，具体到这里的 thunk 中间件，它位于哪两个角色中间呢，在 redux 的流程中，action 是要被 dispatch 到 store 的，再由 reducer 进行处理，所以它位于 dispatch 和 store 之间，也就是对 dispatch 进行了一个拦截，相当于改造了dispatch 方法，原本的 dispatch 方法只接收 action 对象，但是新的 dispatch 方法可以接收一个函数了，我们可以在函数中执行 **副作用**，比如发起异步请求的副作用，如果你还是原来的 action 对象，那么依然走旧的 dispatch 方法直接传递给 store 即可

##### 11.3 redux-saga

redux-saga 也是一个 redux 中间件，和 redux-thunk 相同的是，它们都是用于处理 redux 的异步请求的中间件，所以 redux-saga 可以替换 redux-thunk，二选一即可

saga 的使用流程也是和 thunk 差不多的，先安装，然后引入，不同的是 saga 需要引入创建方法 `createSagaMiddleware` 去创建 saga，后面就是一样的使用 `applyMiddleware` 应用 saga

saga 和 thunk 不同的是，saga 是把异步请求统一放到一个文件中去管理，而不是放到 action 中去管理，然后调用创建的 saga 的 run 方法去执行这个管理异步请求的文件，此文件中的函数要求必须是 [generator 函数](https://es6.ruanyifeng.com/#docs/generator)，是一种异步编程解决方案，该函数返回一个迭代器对象

新增一个 `saga.js` 用于管理异步请求：

```js
import { takeEvery, put } from 'redux/saga/effects'
import { GET_INIT_LIST } from './actionTypes'
import { initListAction } from './actionCreators'
import axios from 'axios'

function* getInitList() {
  try {
    const res = yield axios.get('/list.json')
    const action = initListAction(res.data)
    yield put(action)      
  } catch(e) {
    console.log(e)
  }
}

function* mySaga() {
  yield takeEvery(GET_INIT_LIST, getInitList)  // 收到 GET_INIT_LIST 时执行 getInitList
}

export default mySaga
```

##### 11.4 react-redux

react-redux 是 react 官方推荐的一个库，简化了 redux 的使用流程

1. 正常定义好 redux 的 store

2. 在最外层组件上引入 react-redux 的 Provider 组件，绑定好 store，这样内部组件就能使用 store了

   ```js
   import { Provider } from 'react-redux';
   import store from './store';
   
   const App = (
     <Provider store={store}>
       <TodoList />
     </Provider>
   )
   
   const root = document.getElementById('root');
   ReactDOM.render(
     <React>
       <App />
     </React>,
     root
   );
   ```

3. 内部组件引入 connect，连接

   ```js
   import { connect } from 'react-redux'
   
   class TodoList extends Components { ... }
   
   const mapStateToProps = (state) => { // 创建状态映射函数
     return {
       inputValue: state.inputValue
     }
   }
   
   const mapDispatchToProps = (dispatch) => { // 创建派发映射函数
     return {
       changeInputValue(e) {
         const action = {
           type: 'change_input_value',
           value: e.target.value
         }
         dispatch(action)
       }
     }
   }
   
   export default connect(mapStateToProps, mapDispatchToProps)(TodoList)
   ```

#### 12 组件拆分

react 中的组件大概可以分为三类组件，容器组件、UI组件、无状态组件，下面分别进行介绍

回看我们写的 `TodoList.js` 组件，里面有 state，也有 redux 的 store，同时还有UI展示，可以发现代码量虽然不多，但是却是耦合在一起的，如果代码量很多的话，维护是比较困难的，因此我们可以按功能去拆分这个组件

**容器组件：**按处理逻辑的功能去拆分的组件，负责处理逻辑，可包含UI组件，故称容器组件

**UI组件：**按展示UI的功能去拆分的组件，就是纯粹的展示UI的组件，接收 props，展示 props 的数据

下面进行拆分，UI组件其实就是 render 函数中的内容，可以把它单独提出来，首先创建一个 `TodoListUI.js`，引入相关的包，修改 state 的写法，现在不需要 state 了，只需要通过 props 的方式获取值，现在就是由父组件获取 state 的值，再传递给UI组件了

```js
// TodoListUI.js
import React, { Component } from "react"
import { 
  Input,
  Button,
  List
} from 'antd'

class TodoListUI extends Component {
  render() {
    return (
      <div>
        <div>
          <Input 
            placeholder="todo info"
            style={{width: 300, marginRight: 10}}
            value={this.props.inputValue}
            onChange={this.props.inputChangeHandler} />
          <Button type="primary" onClick={this.props.addHandler}>add</Button>
        </div>
        <div>
          <List
            style={{width: 300, marginTop: 5}}
            header={<div>Header</div>}
            footer={<div>Footer</div>}
            bordered
            dataSource={this.props.list}
            renderItem={(item, index) => (
              <List.Item onClick={this.props.deleteItem.bind(this, index)}>
                {item}
              </List.Item>
            )}
          />
        </div>
      </div>
    )
  }
}

export default TodoListUI
```

父组件：

```js
// TodoList.js
import React, { Component } from "react"
import store from "./store"
import {
  getInputChangeAction,
  getAddTodoItemAction,
  getDeleteTodoItemAction
} from './store/actionCreator'
import TodoListUI from './TodoListUI'

class TodoList extends Component {

  constructor(props) {
    super(props)
    this.state = store.getState()
    store.subscribe(this.storeChangeHandler)
  }

  inputChangeHandler = (e) => {
    const action = getInputChangeAction(e.target.value)
    store.dispatch(action)
  }

  storeChangeHandler = () => {
    this.setState(store.getState())
  }

  addHandler = () => {
    const action = getAddTodoItemAction()
    store.dispatch(action)
  }

  deleteItem = (index) => {
    const action = getDeleteTodoItemAction(index)
    store.dispatch(action)
  }

  render() {
    return (
      <TodoListUI
        inputValue={this.state.inputValue}
        list={this.state.list}
        inputChangeHandler={this.inputChangeHandler}
        addHandler={this.addHandler}
        deleteItem={this.deleteItem}
      />
    )
  }
}

export default TodoList
```

我们发现UI组件中只有一个 render 函数，这样的话其实就没有必要定义成 class 组件了，因为 class 组件有生命周期函数，还有 render 函数，执行效率是更慢的，这时可以使用无状态组件，具有更好的性能优势

**无状态组件：**其实就是一个函数组件，接收 props，返回UI元素，无需 render 函数

```js
import React from 'react'  // 仍然需要引入 react 库

import { 
  Input,
  Button,
  List
} from 'antd'

const TodoListUI = (props) => {
  return (
    <div>
      <div>
        <Input 
          placeholder="todo info"
          style={{width: 300, marginRight: 10}}
          value={props.inputValue}
          onChange={props.inputChangeHandler} />
        <Button type="primary" onClick={props.addHandler}>add</Button>
      </div>
      <div>
        <List
          style={{width: 300, marginTop: 5}}
          header={<div>Header</div>}
          footer={<div>Footer</div>}
          bordered
          dataSource={props.list}
          renderItem={(item, index) => (
            <List.Item onClick={props.deleteItem.bind(this, index)}>
              {item}
            </List.Item>
          )}
        />
      </div>
    </div>
  )
}

export default TodoListUI
```

> UI组件有时也能执行一些逻辑，这不是绝对的

#### 13 hooks

react hooks 是 react 在 16.8 版本之后开始新增的 api，旨在解决函数组件没有组件实例和状态以及生命周期的一些问题，是一个可选功能，但截止目前的 react 18 版本，hooks 已成为 react 全面推荐的功能，不再推荐使用类组件

类组件存在什么问题呢？主要是以下几点：

1. 大型组件难以拆分、重构、测试，因为 class 是难以拆分的，没有函数灵活

2. 相同的业务逻辑容易分散到各个方法中导致逻辑混乱，

   比如同样的请求数据的方法在组件挂载和更新的生命周期中都需要获取，这就导致相同的方法被分散到了两个地方执行

   又或者在挂载生命周期中绑定了某个事件，在销毁生命周期中解绑这个事件，看上去很正常是吧，但是同样可以理解为相同的业务逻辑被放到了两个地方执行

函数组件更灵活，更易拆分和测试，而且 react 也提倡函数式编程，但是函数组件也存在一个问题，就是太简单，太过简单的结构难以支撑复杂的业务，而 hooks，就是用来解决这个问题的，下面介绍一些常见的 hooks

##### 13.1 useState

我们知道函数组件是一个纯函数，执行完毕就销毁，无法存储 state，如果它能存 state，那就违背了纯函数不能产生副作用的原则，那就不是纯函数了

useState 这个 hook 可以解决这个问题，看到这儿也许你早就想问了，为啥叫 hook 呢？hook 翻译过来就是钩子，hook 的作用其实就是像钩子一样，比如函数组件没有 state，那么 useState 这个 hook 就把 state 给它 **钩** 过来，下面举一个例子

```jsx
// ClickCounter.jsx
import { useState } from "react"

export const ClickCounter = () => {
  const [count, setCount] = useState(0)
  const [name, setName] = useState('james')

  function clickHandler() {
    setCount(count + 1)
    setName(name + 2024)
  }

  return <div>
    <p>{name} 点击了 {count} 次</p>
    <button onClick={clickHandler}>点击</button>
  </div>
}
```

在这个函数组件 ClickCounter 中，通过 useState 这个 hook 函数引入了 count 和 name 这两个 state，useState 返回了一个 state 状态和 一个修改 state 的函数，然后我们通过解构赋值去接收了相应的状态和函数，所以 count 和 setCount 的命名可以自由发挥，但最好见名知意

引入了状态之后在返回的 react 元素里直接就能使用状态，并且可以编写函数利用 useState 钩子 **钩过来的修改状态的函数** 去改变 **钩过来的状态**，可以看到函数组件状态的引入及修改完全是由 hook 去管理的，函数组件并没有 **直接** 去修改状态，函数组件依然还是函数组件

这就是 react hooks 的意义所在：保证函数组件的纯粹的前提下给函数组件增强功能

> 所有的 hooks 都以 use 开头，包括自定义的 hooks，这是一种 **命名规范**，因此不是 hooks 的地方尽量不要使用 use 开头去命名，避免造成混淆

当 state 是一个对象时，如果你想更新其中的某个字段，必须显式复制其他字段

```jsx
const [position, setPosition] = useState({ x: 100, y: 100 })
setPosition({ x: 200 })  // 错误，不能直接这样更新，因为这样做丢失了 y 属性
setPosition({ ...position, x: 200 })  // 正确，需要先展开再合并，等同于 Object.assign({}, position, { x: 100 })
```

##### 13.2 useEffect

我们知道函数组件是纯函数，执行完即销毁，无法实现生命周期，useEffect 可以模拟生命周期，不是真正的生命周期，但是可以模拟生命周期的功能

同样的，生命周期的功能是被 useEffect **钩** 到函数组件中的，看下面的例子：

```jsx
import { useState, useEffect } from "react"

export const ClickCounter = () => {
  const [count, setCount] = useState(0)
  const [name, setName] = useState('james')

  function clickHandler() {
    setCount(count + 1)
    setName(name + 2024)
  }

  useEffect(() => {
    console.log('send ajax')
  })

  return <div>
    <p>{name} 点击了 {count} 次</p>
    <button onClick={clickHandler}>点击</button>
  </div>
}
```

我们引入了 useEffect 这个 hook，然后给它传递了一个回调函数并在里面打印了一条信息，启动项目，我们会发现在组件渲染成功时打印了一次，每点击一次 button 又会打印一次，这证明 useEffect 默认模拟的是 componentDidMount 和 componentDidUpdate 这两个生命周期函数

但是有时我们只想模拟 componentDidMount 这个生命周期怎么办呢？很简单，传递一个 **空数组** 作为第二个参数即可

```jsx
useEffect(() => {
  console.log('send ajax')
}, [])
```

再次点击 button，会发现没有打印信息，这说明此时没有再模拟 componentDidUpdate 生命周期了

再有时我们只想模拟 componentDidUpdate 生命周期呢？传递一个 **依赖数组** 作为第二个参数即可，所谓依赖就是指触发 update 所需要依赖的状态

```jsx
useEffect(() => {
  console.log('update')
}, [count, name])  // count 或 name 更新时，触发 useEffect 的执行
```

组件挂载时会触发第一次更新，随后每点击一次 button 修改一次状态，触发一次更新

如果想模拟销毁的生命周期怎么办呢？比如下面的代码在组件销毁后，定时器并没有被销毁，还会一直存在

```jsx
useEffect(() => {
  const timerId = setInterval(() => {
    console.log(Date.now())
  }, 1000)
}, [])
```

为了页面性能考虑，我们必须在销毁生命周期中销毁这个定时器，如何模拟出销毁生命周期呢，只需要在传递给 useEffect 的回调函数中返回一个函数，这个返回的函数就可以理解为模拟出的销毁生命周期，在返回的函数中销毁定时器即可

```jsx
useEffect(() => {
  const timerId = setInterval(() => {
    console.log(Date.now())
  }, 1000)
  return () => {
    clearInterval(timerId)
  }
}, [])
```

> 纯函数是不应该有副作用的，也就是函数组件是不应该有副作用的，但是作为一个组件，有时候副作用是不可避免的，这个时候，技术只能向业务妥协了，于是 react 发明了 hooks 来把产生副作用的功能 **钩** 到了纯函数中

这里需要注意的是，useEffect 模拟的销毁生命周期并不完全等同于类组件中的销毁生命周期

当 useEffect 模拟的是 **update 生命周期**，那么它模拟的销毁生命周期会在下一次 useEffect 更新执行之前被执行

例如有 FriendStatus 组件：

```jsx
// FriendStatus.jsx
import { useEffect, useState } from "react"

export const FriendStatus = ({ friendId }) => {
  const [status, setStatus] = useState(false)

  useEffect(() => {
    console.log(`开始监听 ${friendId} 的在线状态`)
    
    return () => {
      console.log(`结束监听 ${friendId} 的在线状态`)
    }
  })

  return <div>
    好友 {friendId} 在线状态：{status.toString()}
  </div>
}
```

App 组件：

```jsx
import React, { useState } from 'react';
import { FriendStatus } from 'components/FriendStatus';

function App() {
  const [flag, setFlag] = useState(true)
  const [friendId, setFriendId] = useState(1)

  return (
    <div>
      {flag && <FriendStatus friendId={friendId} />}
      <button onClick={() => setFriendId(friendId + 1)}>id++</button>
      <button onClick={() => setFlag(false)}>false</button>
    </div>
  );
}

export default App;
```

比如在上面的例子中，每点击一次 id++ 按钮更新 id 值，都将触发 useEffect 的更新和销毁生命周期打印内容如下：

```sh
# 挂载完成：
开始监听 1 的在线状态
# 点击按钮：
结束监听 1 的在线状态
开始监听 2 的在线状态
# 再次点击：
结束监听 2 的在线状态
开始监听 3 的在线状态
```

##### 13.3 useRef

useRef 其实就是用来实现类组件中的 `React.createRef()` 的，用来获取 dom 元素，使用上比原来的更简单

```jsx
import { useEffect, useRef } from "react"

export const RefDemo = () => {
  const btnRef = useRef(null)

  useEffect(() => {
    console.log(btnRef.current)  // <button>ref</button>
  }, [])

  return <div>
    <button ref={btnRef}>ref</button>
  </div>
}
```

此外还可以用于定义变量

```jsx
const numRef = useRef(0)
console.log(numRef.current)
```

比如函数组件中需要定义一个 id 变量去接收定时器，然后在卸载组件时清除这个定时器，这个时候用 useRef 定义变量就很合适

```jsx
import React, { useEffect, useRef } from 'react'

const TimerComponent = () => {
  const timerIdRef = useRef(null)

  useEffect(() => {
    // 设置定时器
    timerIdRef.current = setInterval(() => {
      console.log('定时器运行中')
    }, 1000)

    // 在组件卸载时清除定时器
    return () => {
      clearInterval(timerIdRef.current)
    }
  }, [])

  return <div>定时器组件</div>
}

export default TimerComponent
```

为什么使用 useRef 而不是 useState 的原因如下：

1. **避免不必要的重新渲染**：`useState` 的更新会触发组件的重新渲染，而 `useRef` 的更新不会。定时器 ID 并不需要参与渲染过程，它只是一个内部的引用，因此使用 `useRef` 更合适。避免不必要的重新渲染可以提高性能
2. **保持对最新值的引用**：`useRef` 可以存储一个可变的值，该值在组件的整个生命周期内保持一致，`useRef` 更像是一个实例变量，用于持久化跨渲染周期的数据
3. **语义更清晰**：`useRef` 通常用于引用 DOM 元素或持有不需要引起重新渲染的变量

##### 13.4 useContext

useContext 是用于使用 context 的，一般用于设置上下文环境，需要跨组件传值的时候比较有用，比如设置主题色

```jsx
// 创建 context
const ThemeContext = React.createContext('light')
const theme = useContext(ThemeContext)
console.log(theme)  // light
```

##### 13.5 useReducer

我们直接来看例子

```jsx
// ReducerDemo.jsx
import React, { useReducer } from "react"

const initialState = { count: 0 }

const reducer = (state, action) => {
  switch(action.type) {
    case 'increment':
      return { count: state.count + 1 }
    case 'decrement':
      return { count: state.count - 1 }
    default:
      return state
  }
}

export const ReducerDemo = () => {
  const [state, dispatch] = useReducer(reducer, initialState)

  return <div>
    count: {state.count}
    <button onClick={() => dispatch({ type: 'increment' })}>increment</button>
    <button onClick={() => dispatch({ type: 'decrement' })}>decrement</button>
  </div>
}
```

在这个例子中，我们创建了一个初始 state 对象和一个 reducer 函数用于处理不同情况下的 state 对象的变化情况，然后将它们传递给 useReducer，接着从 useReducer 中解构出了 state 和 dispatch，这时就可以通过 state 获取我们定义的 count 值了，也能通过 dispatch 去修改 count 的值，是不是觉得这和 redux 很像呢？没错，它就是借鉴的 redux 的流程，但是需要 **注意**，useReducer 不是用来代替 redux 的，它只是借鉴了 redux 的流程，实际上它可看成是 useState 的复杂版本，用于处理 state 的 **更新逻辑比较复杂** 的场景，你还可以将自定义的 reducer 函数抽离到单独的文件中，以方便维护，以上代码如果用 useState 的话，则是：

```jsx
const [count, setCount] = useState(0)
```

##### 13.6 useMemo

useMemo 是用于性能优化的，回顾之前讲的 SCU，当父组件渲染时，子组件也会无条件跟着渲染，但是如果这种渲染已经影响页面性能了，那么就需要我们自己使用 SCU 去做性能优化，判断什么时候才应该去渲染组件

##### 13.7 自定义 hooks

react 提供了自定义 hooks 的能力，以帮助我们拓展想要的功能，实际上就是自定义的函数，以 use 开头，一般都是引入 useState 和 useEffect 进行自定义，模仿 hooks 的设计进行定义

##### 13.8 hooks 规范

1. 只能用于函数组件和自定义 hooks 中
2. 只能用于顶层代码，不能用于循环和判断中

#### 14 高级技巧

##### 14.1 forwardRef

有时我们需要获取组件中的 **某个元素**，而不是某个元素，此时组件又恰好是函数组件，这时只能通过 forwardRef 传递 ref 去获取组件中的这个元素

子组件：

```jsx
import { forwardRef } from "react"

export default forwardRef(function Child(props, childRef) {
  return (
    <div ref={areaRef}>
      <div>yes</div>
      <div>no</div>
    </div>
  )
})
```

父组件：

```jsx
<Child ref={el => console.log('this is the element we want: ', el)} />
```



