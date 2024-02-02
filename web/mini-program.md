#### 1 结构

```json
{
  // 指定页面路径
  "pages":[
    "pages/index/index",
    "pages/logs/logs"
  ],
  "window":{
    "backgroundTextStyle":"light",
    "navigationBarBackgroundColor": "#fff",
    "navigationBarTitleText": "微信",
    "navigationBarTextStyle":"white"
  },
  "sitemapLocation": "sitemap.json",
  // 使用自定义组件，引用vant UI组件
  "usingComponents": {
    "van-button": "@vant/weapp/button/index"
  },
  // 设置debug模式开启，控制台输出调试信息
  "debug": true,
  // 选项栏设置，list数组指定页面路径，配置选中时的颜色
  "tabBar": {
    "list": [
      {
        "text": "首页",
        "pagePath": "pages/index/index"
      },
      {
        "text": "日志",
        "pagePath": "pages/logs/logs"
      },
      {
        "text": "日志",
        "pagePath": "pages/logs/logs"
      },
      {
        "text": "日志",
        "pagePath": "pages/logs/logs"
      }
    ],
    "selectedColor": "#07c160"
  }
}
```

#### 2 事件与数据流

1. 函数可以通过`e.target.dataset`拿到组件中的`data-*`属性设置的数据

   ```html
   <van-button type="info" bindtap="show" data-name="james" data-my-book="微信小程序">信息按钮</van-button>
   ```

   ```js
   show(e) {
     // 将对象e以树形的形式打印到控制台
     console.dir(e)
     // 获取data-name的值
     // currentTarget也可以获取，代表当前触发事件的元素，target表示绑定的事件的元素
     console.log(e.target.dataset.name)
     // 获取data-my-book的值，这里要写驼峰命名
     console.log(e.target.dataset.myBook)
   }
   ```
   也可以用mark，这样在父元素设置了自定义属性后，子元素不用重复设置也能拿到父元素的自定义属性的值，比如

   ```html
   <view class="todos">
     <view wx:for="{{ todos }}" bindtap="toggleTodoHandle" mark:index="{{ index }}">
       <icon type="{{ item.completed ? 'success' : 'circle' }}"/>
       <text>{{ item.name }}</text>
       <!-- catchtap阻止冒泡  不用重复设置 data-index="{{ index }}" -->
       <icon type="clear" size="16" catchtap="removeTodoHandle"/>
     </view>
   </view>
   ```

   ```js
   removeTodoHandle (e) {
     let todos = this.data.todos
     // todos.splice(e.currentTarget.dataset.index, 1)
     todos.splice(e.mark.index, 1)
     this.setData({ todos: todos })
   }
   ```

2. 单向数据流

   小程序的数据流是单向的，不管是从界面流到逻辑还是相反流动，与vue等双向绑定不同

   ```html
   <input value="{{ msg }}"/>
   <text>{{ msg }}</text>
   ```

   ```js
   page({
     data: {
       msg: 'initial'
     }
   })
   ```

   以上代码虽然文本框和输入框显示相同文字initial，但是改变输入框的值的时候，文本框并不会同步变化，说明数据不是双向绑定的，可以用事件解决

   ```html
   <input value="{{ msg }}" bindinput="inputHandle"/>
   <text>{{ msg }}</text>
   ```

   ```js
   inputHandle: function(e) {
     this.data.msg = e.detail.value
     console.log(this.data.msg)
   }
   ```

   通过打印当前传递进函数的对象，发现可以通过detail获取value属性的值，于是将其赋值给data中设定的msg属性，但是发现文本框的值并没有同步变化，原因是小程序中的数据绑定是一次性的，在最开始就绑定了，而框架不知道你什么时候要改变data中的值，没有时刻去监听值的变化，需要你通过规定的方式赋值，框架才知道你改变了data的值，于是就将值再次绑定给表达式

   ```js
   inputHandle: function(e) {
     this.setData({
       msg: e.detail.value
     })
   }
   ```

3. 登录案例

   - 方式一：原始方式，拿到输入框的值，通过setData赋给data

   ```html
   <view>
     <input placeholder="请输入用户名" value="{{ username }}" bindinput="inputChangeHandle" 
            data-prop="username"/>
     <input type="password" placeholder="请输入密码" value="{{ password }}" bindinput="inputChangeHandle" 
            data-prop="password"/>
   </view>
   <view>
     <button type="primary" bindtap="loginHandle">登录</button>
     <button type="default">注册</button>
   </view>
   ```

   ```js
   inputChangeHandle: function (e) {
     let prop = e.target.dataset['prop']
     let changed = {}
     changed[prop] = e.detail.value
     this.setData(changed)
   }
   
   loginHandle: function () {
     console.log(this.data)
   }
   ```

   - 方式二：直接通过form表单获取，但是代码数据流向不清晰

   ```html
   <form bindSubmit="loginHandle">
     <input placeholder="请输入用户名" value="{{ username }}" name="username"/>
     <button type="primary" form-type="submit">登录</button>
   </form>
   ```

   点击登录按钮后，就会触发loginHandle函数执行，拿到表单里的具体name属性的标签的value的值，在`e.detail.value`里面

   ```js
   loginHandle: function (e) {
     console.log(e)
   }
   ```

   建议使用方式一

#### 3 条件渲染

通过条件判断是否需要渲染组件

```html
<view bindtap="toggle">
  <text>切换内容展示</text>
</view>
<view wx-if="{{ showText }}">
  <text>展示内容</text>
</view>
```

```js
Page({
  data:{
    showText: true
  },
  toggle: function() {
    this.setData({ showText: !this.data.showText })
  }
})
```

一次性控制多个组件，可以用block包围

```html
<block wx-if="{{ showText }}">
  <view>
    <text>展示内容1</text>
  </view>
  <view>
    <text>展示内容2</text>
  </view>
</block>
```

#### 4 界面交互

见开发文档：[界面交互](https://developers.weixin.qq.com/miniprogram/dev/api/ui/interaction/wx.showActionSheet.html)

#### 5 flex布局

```html
<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <title></title>
  <style>
  	.container {
  		display: flex;
  		flex-direction: column;
  		width: 400px;
  		height: 300px;
  		border: 1px solid #ccc;
  	}
  	.item {
  		flex: 1;
  	}
  </style>
</head>

<body>
	<div class="container">
		<div class="item" style="background-color: green;"></div>
		<div class="item" style="background-color: yellow;"></div>
		<div class="item" style="background-color: white;"></div>
		<div class="item" style="background-color: blue;"></div>
	</div>
</body>

</html>
```

#### 6 页面跳转与传值

- 跳转

  在`app.json`中添加页面后，小程序会自动生成页面基本结构，然后在想要跳转的页面中填写页面的**相对地址**就可以跳转页面了

  ```html
  <navigator url="../demo2/demo2">go to demo2 page</navigator>
  ```

  标签中间放图片也是可以的，点击图片也会跳转，比较像a标签

  可以添加redirect属性，这样就**不会有返回按钮**了，比如有些页面只需要访问一次的时候可以使用，比如版本升级的页面介绍

  ```html
  <navigator url="../demo2/demo2" redirect>go to demo2 page</navigator>
  ```

  可以添加hover-class属性，控制点击的高亮效果

  ```html
  <!-- 指定点击颜色 -->
  <navigator url="../demo2/demo2" hover-class="my-hover">go to demo2 page</navigator>
  <!-- 点击无效果 -->
  <navigator url="../demo2/demo2" hover-class="none">go to demo2 page</navigator>
  ```

  ```css
  .my-hover {
    color: red;
  }
  ```

  除了使用navigator跳转，还可以使用api跳转

  ```html
  <button type="primary" bindtap="jumpHandle">跳转页面</button>
  ```

  ```js
  jumpHandle: function() {
    // wx.navigateTo({
    //   url: '../demo2/demo2'
    // }),
    wx.redirectTo({
      url: '../demo2/demo2'
    })
  }
  ```

  `wx.navigateTo`保留当前页面，跳转到应用内的某个页面，但是不能跳到 tabbar 页面。使用`wx.navigateBack`可以返回到原页面，默认返回上一页，可以通过delta设置返回第几页，1代表上一页，2代表上上页，以此类推，小程序中页面栈最多十层

  ```js
  backHandle: function() {
    wx.navigateBack({
      delta: 2
    })
  }
  ```

  > 跳转页面tabbar会不见

- 传值

  传值直接用地址传值的`?`进行传递

  ```html
  <navigator url="../demo2/demo2?name=index&age=18">go to demo2 page</navigator>
  ```

  然后在demo2的js的页面加载监听函数中的options参数里面就有传递过去的值

  ```js
  /**
    * 生命周期函数--监听页面加载
    */
  onLoad: function (options) {
    console.log(options)
  }
  ```

  拿到值之后可以通过setdata设置值到data对象中，这样就可以在js里面操作数据了，通过api跳转也可以在url里面通过`?`传递参数

#### 7 数据请求

使用`wx.request`这个API请求数据，这里没有跨域的概念，因为这是客户端没有所属域，不是一个服务器向另一个服务器发起请求

由于小程序不存在DOM的概念，因此不能使用jQuery，也就不能使用传统的Ajax请求数据了，这里可以用fetch请求，fetch使用了promise

##### 7.1 Promise

promise是ES6新推出的专门处理异步编程的语法，Ajax也是异步编程

- 异步编程

  怎么理解异步呢，就是不按顺序执行，或者不用等待同步，重点是理解**代码的执行时机**，请看下面的Ajax的代码

  ```js
  var ret = 'ret'
  $.ajax({
    url: 'http://localhost:3000/data'
    success: function (data) {
      ret = data
      console.log(ret)  // hello
    }
  })
  console.log(ret)  // ret
  ```

  执行这段代码，发现Ajax外面的ret的打印结果没有改变，说明代码**不是从上到下顺序执行的**，或者说到打印外围ret的时候，Ajax的成功回调函数还没有被执行，自然也就没有赋值的操作，因此打印出了变量ret的原始值，而回调函数里面的console因为已经完成了赋值，所以必然会打印出赋值以后的值，为什么会这样呢，为什么回调函数没有按照顺序执行而是执行得更慢呢，原因就是异步，在这段代码的执行过程中，当遇见Ajax请求时，代码执行不会停在这里等待Ajax执行完毕再执行接下去的代码，而是直接跳过Ajax执行接下去的代码，没有同步的等待，不必非得按照代码的顺序执行，这就代表了异步，但Ajax最终也是要执行的，所以Ajax也开始了执行，去url中获取数据，获取数据**成功**之后执行成功回调函数（这里没有写失败函数），所以回调函数的执行时机是在Ajax获取数据成功之后，在Ajax内部是同步的，所以多次调用Ajax的打印结果是不一样的，因为结果完成的时间不一样，先完成的Ajax先打印，但是我们就是想要让结果按照一定的顺序执行怎么办呢，可以在一个Ajax请求里面再次调用Ajax请求，层层嵌套，因为Ajax内部是同步的，但是多层嵌套的代码结构复杂，俗称回调地狱，解决这个问题的办法，就是采用Promise代替Ajax请求数据

- Promise用法

  Promise是一个对象（函数，但是函数也是对象），可以获取异步操作的消息，提供了简洁的API控制异步操作，从字面意思上来讲Promise即是承诺，Promise是设计用来处理异步操作的，异步操作有可能成功也有可能失败，但Promise事先就规定好了对应处理方案，不管什么情况都会对结果进行处理的承诺

  1. 实例化Promise对象，在构造函数中传递回调函数，用于处理异步任务，回调函数中接收两个参数，分别是**resolve和reject，表示成功和失败两种情况，这两个参数都是方法**

  2. 调用Promise对象的then方法，获取处理异步任务的结果

     ```js
     let promise = new Promise(function(resolve, reject) {
       setTimeout(function() {
         let flag = true
         if (flag) {
           resolve('成功了')
         } else {
           reject('失败了')
         }
       }, 3000)
     })
     promise.then(data => console.log(data), info => console.log(info))
     ```

     上面用定时器实现了异步任务，这段代码的执行结果会在3秒后在控制台打印成功了，如果flag设置为false则会打印失败了

  3. Promise如何解决回调地狱的问题呢，通过多次链式调用then方法就可以解决了，执行顺序和then的执行顺序一致，每一次then都会返回一个新的Promise对象，包含了此次调用结果，这样**更容易阅读**

##### 7.2 Fetch

Fetch的核心在于对 HTTP 接口的抽象，包括 Request，Response，Headers，Body，基于Promise实现，提供了更简单的数据获取方式，功能更强大

```js
// data.text()返回一个Promise对象，第二个then中的data才是获取到的数据
fetch('url').then(data => data.text()).then( data => console.log(data))
```

#### 8 小程序结构

#### 9 小程序结构

#### 10 小程序结构

