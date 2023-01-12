#### 1 jQuery简介

jQuery是一个JavaScript库，封装了大量好用的 js 函数，实现了很多常用的功能，我们想使用这些功能时只需要到库里面拿来用就可以了，而不用自己编写这些函数，也不用去了解这些函数的实现细节，jQuery编写了大量专门用于操作DOM的函数，j for JavaScript，query 就是查询，学习jQuery也就是在学习查询其封装的函数的用法，使用jQuery相比使用原生 js 开发的开发速度大大地提高了，而且兼容了目前主流的浏览器，不用自己编写兼容函数

#### 2 常用API

##### 2.1 入口函数

为了使 js 代码可以在任意位置引入，jQuery 提供了方便的写法，以便等待页面加载完成后执行 js

```js
// 第一种写法
$(document).ready(function () {
    $('div').hide()
})

// 第二种写法，更加简洁，推荐
$(function () {
    $('div').hide()
})
```

> 注意这里的加载完成是相对于原生 js 中的 `DOMContentLoaded`，不同于 `load` 事件，需要完全加载完图片、css 、js 文件等资源

##### 2.2 jQuery对象

用原生 js 获取的对象是DOM对象，只能使用原生 js 对象的属性和方法

用jQuery的方式获取的对象就是 jQuery对象，本质是将DOM元素进行了包装，只能使用jQuery提供的方法

但是某些情况下两者可以互转，因为原生 js 比jQuery的范围更大，所以如果需要使用原生 js 的属性和方法，必须要将jQuery对象转换为DOM对象，转换时只需要用索引号从**伪数组**中取出元素就可以了

```js
// jQuery对象转换为DOM对象
$('video')[0].play()
$('video').get(0).play()

// DOM对象转换为jQuery对象
var myVideo = document.querySelector('video')
$(myVideo)
```

> `$` 是`jQuery`的别名，二者可以互换，但是一般使用符号更简洁，是jQuery中的顶级对象，这个对象相当于原生 js 的 `window`对象，利用 `$` 把元素包装成jQuery对象，然后就可以调用jQuery提供的方法了

#### 3 选择器

原生的 js 有很多种选择器，有一些还有兼容问题，jQuery选择器更加简洁通用，jQuery的选择器和 css 基本一致，只不过要写在特定的格式里面

| 标签选择器 |    `$('div')`     |
| :--------: | :---------------: |
|  ID选择器  |    `$('#id')`     |
|  类选择器  |   `$('.class')`   |
| 全选选择器 |     `$('*')`      |
| 子代选择器 |   `$('ul>li')`    |
| 后代选择器 |   `$('ul li')`    |
| 并集选择器 |  `$('div,p,li')`  |
| 交集选择器 | `$('li.current')` |

##### 3.1 隐式迭代

jQuery有个概念叫隐式迭代，遍历以伪数组形式存储的内部DOM元素的过程就是隐式迭代的过程，它会隐式地把匹配到的所有元素进行循环遍历，执行对应的方法，而不用我们主动去循环遍历，这样的设计可以简化我们的操作

```js
// 将所有选中的li的背景颜色都改为紫罗兰色
$(function () {
  $('ul li').css('background', 'violet')
})
```

隐式迭代是对同一种元素的同一种操作，如果需要不同的操作，则需要自己遍历，可以使用`each()`方法

```js
// 给元素赋值不同的颜色
var arr = ['red', 'green', 'blue']
$('div').each(function (i, domEle) {
    $(domEle).css('color', arr[i])
})
```

也可以用`$.each()`遍历元素，主要用于处理数据

```js
$.each($('div'), function (i, ele) {
    console.log(i)
    console.log(ele)
})
```



##### 3.2 筛选选择器

筛选选择器，类似于 css 中的结构伪类选择器

| `$('li:first')` |         选择第一个 li 元素          |
| :-------------: | :---------------------------------: |
| `$('li:last')`  |        选择最后一个 li 元素         |
| `$('li:eq(0)')` | 选择第一个 li 元素（索引号从0开始） |
|  `$('li:odd')`  |           选择奇数位的 li           |
| `$('li:even')`  |           选择偶数位的 li           |

##### 3.3 筛选方法

通过jQuery选择器的筛选方法选出关系元素

|        `$('li').parent()`        |                         选出父级元素                         |
| :------------------------------: | :----------------------------------------------------------: |
|       `$('li').parents()`        | 选出祖先元素，可以在参数中指定要选中的某一个祖先元素，这样就不用一层一层地往上找了 |
|     `$('ul').children('li')`     |               选出子级元素，相当于`$('ul>li')`               |
|       `$('ul').find('li')`       |                选出后代元素，相当于`$(ul li)`                |
|   `$('.first').siblings('li')`   |                   选出兄弟节点，不包括自身                   |
|     `$('.first').nextAll()`      |                      选出之后的兄弟节点                      |
|     `$('.first').prevAll()`      |                      选出之前的兄弟节点                      |
| `$('div').hasClass('protected')` |               div 元素是否包含类，是返回 true                |
|         `$('li').eq(2)`          | 选出索引为2的 li 元素，相当于`$('li:eq(2)')`，更推荐这种写法，因为可以动态赋值，比如：`$(li).eq(index)` |

有了这些方法，可以方便地实现排他思想

```js
$('button').click(function () {
    $(this).css('background', 'violet')
    $(this).siblings('button').css('background', '')
})
```

jQuery可以很方便地获得当前元素的索引号，而不必额外添加自定义属性

```js
$('ul li').mouseover(function () {
    var index = $(this).index()
    $('#content div').eq(index).show()
    $('#content div').eq(index).siblings().hide()
})
```

jQuery还可以使用链式编程，同样的代码不必写两次，这样更加简洁

```js
$('ul li').mouseover(function () {
    var index = $(this).index()
    $('#content div').eq(index).show().siblings().hide()
})
```

#### 4 修改样式

可以通过 css 方法来修改简单的样式，也可以通过修改类来切换多个样式

- css 方法

  只写属性不写值就是返回属性的值

  ```js
  log($(this).css('width')) // 200px
  ```

  属性和值都写了就是修改其值，值是数字可以不加引号和单位

  ```js
  log($(this).css('width', '200px')) // 宽度改为200px
  ```

  可以传递对象进去修改多组样式，属性可以不加引号

  ```js
  $('div').css({
      width: 200,
      height: 200,
      backgroundColor: 'red' // 复合属性要采用驼峰命名，不能加短横线
  })
  ```

- 修改类

  如果不想直接写样式，可以修改元素的类

  ```js
  // 添加class
  $('div').click(function () {
      $(this).addClass('current')
  })
  // 删除class
  $('div').click(function () {
      $(this).removeClass('current')
  })
  // 切换class，在添加和删除之间切换
  $('div').click(function () {
      $(this).toggleClass('current')
  })
  
  // 切换tab栏案例的jQuery版本，是不是很简洁很感动
  $(function () {
    $('.tab_list li').click(function () {
      $(this).addClass('current').siblings().removeClass('current')
      var index = $(this).index()
      $('.tab_con .item').eq(index).show().siblings().hide()
    })
  })
  ```
  
  jQuery修改类名与原生 js 方式修改类名的区别是，jQuery只对具体的类名操作，不影响别的类名
  
  ```js
  // 原生的这种方式会覆盖类名，原先的one类名不见了
  var one = document.querySelector('.one')
  one.className = 'two'
  // 追加类名two，原本的one类名还在
  $('.one').addClass('two')
  // 删除同理，只影响two类名
  $('.one').removeClass('two')
  ```
  
#### 5 效果
jQuery为我们封装了很多动画效果，常用的如下：

1. 显示与隐藏

   可以加参数来指定显示的快慢和显示完成之后需要执行的回调函数，一般情况下不加

   ```js
   // 显示
   $('div').show()
   // 隐藏
   $('div').hide()
   // 切换
   $('div').toggle()
   ```

2. 滑动

   可以像抽屉一样下拉上划，配合事件切换函数可以实现很好的效果

   ```js
   // hover()：前一个函数参数表示鼠标移到元素上要执行的函数，后一个是离开时
   $('.nav>li').hover(
     function () {
       $(this).children('ul').slideDown(200)
     },
     function () {
       $(this).children('ul').slideUp(200)
     }
   )
   
   // 如果只写一个函数参数，则鼠标经过和离开元素都会执行该函数
   $('.nav>li').hover(function () {
     $(this).children('ul').slideToggle(200)
   })
   ```

   动画排队：类似于滑动这样的动画效果一旦触发就必须要执行完毕，所以如果在短时间内多次触发了滑动，那么这些动画就全部都要执行，就像排队一样，这样的效果并不好，可以用`stop()`来停止动画，不过是停止的上一次的动画，这样即使短时间内多次触发动画，也只会执行最后一次动画的效果

   ```js
   $('.nav>li').hover(function () {
     $(this).children('ul').stop().slideToggle(200)
   })
   ```

3. 淡入淡出

   让元素渐渐地显示和隐藏

   ```js
   $('div').fadeIn(1000)
   $('div').fadeOut(1000)
   $('div').fadeToggle(1000)
   $('div').fadeTo(1000, 0.5) // 修改元素透明度
   ```

4. 自定义动画

   ```js
   // params: 想要改变的样式属性，以对象方式传递，可以不加引号，驼峰命名
   animate(params, [speed], [easing], [fn])
   
   // 在500ms内变化样式属性
   $(function () {
     $('button').click(function () {
       $('div').animate(
         {
           left: 200,
           top: 200,
           opacity: 0.4,
           width: 500
         },
         500
       )
     })
   })
   ```

#### 6 属性操作
对于元素的固有属性，即元素自带的属性，不是自定义的属性，可以使用`prop()`方法来获取或者设置

```js
// 获取a链接的链接地址属性的值
var href = $('a').prop('href')
// 设置a链接的标题属性值
$('a').prop('title', '我是title')
```

对于元素的自定义属性，可以使用`attr()`方法来获取或者设置

```js
// 获取a链接的链接自定义属性的值
var href = $('a').attr('data-index')
// 设置a链接的标题属性值
$('a').attr('data-index', 3)
```

数据缓存：将数据暂时存放在元素内存里面，不会修改DOM元素结构，页面刷新会丢失，也可以利用它获取H5的自定义属性的值，获取过来直接就是数字类型的值，而且不用加 `data-` 前缀

```js
// 设置数据缓存的值
$('span').data('uname', 'andy')
// 获取数据缓存的值
var uname = $('span').data('uname')
// 获取自定义属性data-index的值，返回数字型
$('div').data('index')
```

#### 7 内容操作

利用`html()`可以修改元素内容值，相当于原生 js 的`innerHTML()`

```js
// 获取div的内容，会把标签也一起获取了
$('div').html()
// 设置div的内容值
$('div').html('abc')
// 只想获取文本值，不想获取标签，相当于原生js的innerText()
$('div').text()
// 同上，只设置文本值，标签不生效
$('div').text('abc')
// 获取表单的值，相当于原生js的value
$('input').val()
// 设置表单的值
$('input').val('abc')
```

#### 8 元素操作

```js
// 创建元素
var li = $('<li>创建的li元素</li>')

// 在元素内部添加元素
// 内部元素之后添加
$('ul').append(li)
// 内部元素之前添加
$('ul').prepend(li)
// 在元素外部添加元素
// 外部元素之后添加
$('.test').after(li)
// 外部元素之前添加
$('.test').before(li)

// 删除元素
// 删除自身
$('ul').remove()
// 删除所有子节点
$('ul').empty()
// 删除元素内容
$('ul').html('')
```

#### 9 尺寸和位置

|          width()/height()          |             返回元素的宽度或高度              |
| :--------------------------------: | :-------------------------------------------: |
|     innerWidth()/innerHeight()     |         返回元素的宽度或高度加padding         |
|     outerWidth()/outerHeight()     |     返回元素的宽度或高度加padding加border     |
| outerWidth(true)/outerHeight(true) | 返回元素的宽度或高度加padding加border加margin |

```js
console.log($('div').width()) // 200
$('div').width(300)  // 修改元素宽度为300px
```

|         offset()         |         返回元素相对于文档的偏移坐标，和父级没有关系         |
| :----------------------: | :----------------------------------------------------------: |
|        position()        | 返回元素相对于带有定位的父级的偏移坐标，如果父级无定位，则相对于文档，这个方法只能获取不能设置 |
| scrollTop()/scrollLeft() |               返回元素被卷去的头部或左侧的大小               |
|                          |                                                              |

```js
console.log($('.son').offset())  // Object，包含了top和left属性
$('.son').offset({
    top: 200,
    left: 200
})  // 修改偏移坐标

// 滚动页面到一定程度显示返回按钮
var boxTop = $('.container').offset().top
$(window).scroll(function () {
  if ($(document).scrollTop() >= boxTop) {
    $('.back').fadeIn()
  } else {
    $('.back').fadeOut()
  }
})
// 点击按钮返回顶部
$('.back').click(function () {
  // $(document).scrollTop(0) // 动画过快，不美观
  // 利用元素做动画
  $('html,body').stop().animate({
    scrollTop: 0
  })
})
```

#### 10 事件

之前的事件绑定都是直接写事件函数绑定单个事件，想要绑定不同的事件需要重复写单个的事件函数，jQuery提供了处理事件的函数`on()`，可以用于同时绑定多个事件

```js
// 同时给div元素绑定多个事件
$('div').on({
    click: function() {
        $(this).css('background', 'skyblue')
    },
    mouseenter: function() {
        $(this).css('background', 'violet')
    },
    mouseleave: function() {
        $(this).css('background', 'purple')
    }
})
// 给多个事件绑定同一个处理函数
$('div').on('mouseenter mouseleave', function() {
    $(this).toggleClass('current')
})
```

利用`on()`还可以实现事件委派，把原本给子元素绑定的事件委派给父元素

如果li是动态创建的，也可以给它绑定事件，这用以前单独绑定的方式是不行的，因为绑定事件时li还没有创建

```js
// 事件是绑定给ul的，但是触发事件的是li，冒泡原理
$('ul').on('click', 'li', function() {
    console.log(23)
})
```

利用`off()`解绑事件

```js
// 解绑绑定在div上的所有事件
$('div').off()
// 解绑绑定在div上的click事件
$('div').off('click')
```

如果有的事件只需要触发一次，可以用`one()`来绑定事件

```js
$('p').one(function () {
  alert(1)
})
```

有的事件希望它自动触发，可以用`trigger()`

```js
$('div').on('click', function () {
  alert(1)
})
// 直接调用click函数
$('div').click()
// 通过trigger()函数触发
$('div').trigger('click')
// 通过triggerHandler()函数触发，这种方式不会触发元素的默认行为，比如输入框获得焦点之后的光标闪烁
$('div').triggerHandler('click')
```

事件被触发就会产生事件对象

```js
// 阻止冒泡
$(document).on('click', function () {
  console.log(1);
})
$('div').on('click', function (e) {
  console.log(2);
  e.stopPropagation()
})
```

#### 11 对象拷贝

可以使用`extend()`来拷贝对象，需要注意深浅拷贝的区别

```js
// 将obj对象拷贝给target对象，target对象里原有的数据会被覆盖
$.extend([true], target, obj)
```

> 浅拷贝：将被拷贝对象的**复杂数据类型的地址**拷贝给目标对象，修改目标对象会影响被拷贝对象
>
> 深拷贝：完全克隆，而不是拷贝地址，对于复杂数据类型会新开辟一块内存空间用来存储拷贝过来的值，修改目标对象不会影响被拷贝对象

#### 12 多库共存

jQuery是使用`$`作为标识符的，如果别的库也使用了相同的符号，多库一起使用时就会产生冲突

```js
// 将$改为jQuery
jQuery.each()
// 使用jQuery提供的函数自定义名字
myJQuery = jQuery.noConflict()
myJQuery('div')
```

#### 13 jQuery插件

jQuery的功能毕竟有限，可以使用相关的插件拓展功能，先在插件网站上下载想要的插件，然后解压压缩包，然后打开里面的示例文件，参照其进行CV即可

图片懒加载：用户刚刚进入网页的时候，网页下面的图片没有必要全部加载出来，因为此时用户还看不到这些图片，直接全部加载图片无异于浪费性能，只在用户下滑网页时才加载这些图片，这就是图片懒加载，但是这种效果手写比较麻烦，可以使用插件帮助我们实现

#### 14 aJax

##### 14.1 URL地址

URL（Uniform Resource Locator），统一**资源**定位符，用于标识互联网的每个资源的唯一的位置，浏览器通过 URL 地址访问网络资源

URL 地址由三部分组成：

1. 通信协议：客户端和服务器之间需要遵守相同的协议进行通信，规定了通信的方式，比如 http 协议
2. 服务器地址：也就是域名 www.baidu.com
3. 资源位置：资源的路径 `/resource`

##### 14.2 Ajax

Ajax（Asynchronous JavaScript and XML），异步的 JavaScript 和 XML，从字面意思可以看出这是和异步 js 和数据传输相关的，也就是使用异步的 js 和服务器交互数据的技术

原生 js 提供了一个对象用于处理和服务器之间的异步数据传输，这就是 `XMLHttpRequest` 对象

但是原生语法的 `XMLHttpRequest` 对象的用法比较复杂，因此 jQuery 库对其进行了封装，封装后的产物就是 Ajax，简化了原生语法的使用难度

基本上网页上涉及到与服务器传输数据的增删改查都可以使用 Ajax，比如用户注册时请求服务器对用户名进行查重，搜索关键字时的提示，数据分页显示请求分页数据等，我们先直接介绍比较简单的 Ajax，想直接了解 `XMLHttpRequest` 对象的，可以查看本文的 [5 XMLHttpRequest](#)

jQuery 中的 Ajax 主要有3个函数：

1. `$.get()`

   专门用于发起get请求，主要用于从服务器请求数据

   url:请求的服务器资源地址，字符串

   data：请求资源需要携带的参数，对象

   callback：请求成功时的回调函数

   ```js
   $.get(url, [data], [callback])
   ```

   ```js
   // 不带参数的get请求
   $(function () {
       $('#btnGET').on('click', function () {
           $.get('http://www.liulongbin.top:3006/api/getbooks', function (res) {
               console.log(res) // Object { status: 200, msg: "获取图书列表成功", data: (8) […] }
           })
       })
   })
   
   // 带参数的get请求
   $(function () {
       $('#btnGETINFO').on('click', function () {
           $.get('http://www.liulongbin.top:3006/api/getbooks', { id: 1 }, function (res) {
               console.log(res) // Object { status: 200, msg: "获取图书列表成功", data: (1) […] }
           })
       })
   })
   ```

2. `$.post()`

   和get的用法基本一致，不同的是是用来向服务器发送数据

   ```js
   $.post(url, [data], [callback])
   ```

   ```js
   $(function () {
       $('#btnPOST').on('click', function () {
           $.post(
               'http://www.liulongbin.top:3006/api/addbook',
               {
                   bookname: '水浒传',
                   author: '施耐庵',
                   publisher: '天津图书出版社'
               },
               function (res) {
                   console.log(res) // Object { status: 502, msg: "不允许重复添加！！！" }
               }
           )
       })
   })
   ```

3. `$.ajax()`

   功能更加综合的函数，可以对Ajax请求进行更详细的配置

   ```js
   $.ajax({
       type: 'GET', // 请求方式，GET POST
       url: 'http://www.liulongbin.top:3006/api/getbooks', // 请求资源地址
       data: {
           id: 1 // 请求携带的参数
       },
       success: function (res) { // 请求成功的回调函数
           console.log(res)
       }
   })
   ```

   ```js
   // 发起get请求
   $(function () {
       $('#btnGET').on('click', function () {
           $.ajax({
               type: 'GET',
               url: 'http://www.liulongbin.top:3006/api/getbooks',
               data: {
                   id: 1
               },
               success: function (res) {
                   console.log(res) // Object { status: 200, msg: "获取图书列表成功", data: (1) […] }
               }
           })
       })
   })
   
   // 发起post请求
   $(function () {
       $('#btnPOST').on('click', function () {
           $.ajax({
               type: 'POST',
               url: 'http://www.liulongbin.top:3006/api/addbook',
               data: {
                   bookname: '史记',
                   author: '司马迁',
                   publisher: '上海图书出版社'
               },
               success: function (res) {
                   console.log(res) // Object { status: 201, msg: "添加图书成功" }
               }
           })
       })
   })
   ```

##### 14.3 接口

使用Ajax等工具请求网络数据时，所请求的资源服务器地址就是数据接口，简称为接口

接口必须规定其请求方式，比如get、post

测试接口是否可以正常访问，可以使用接口测试工具，能在不写代码的情况下就方便地测试，常见的接口测试工具有postman等

##### 14.4 表单

网页表单主要负责数据采集，form标签就是用来采集用户输入的数据的

###### 14.4.1 表单组成

表单由三部分组成：

1. 表单标签

   form标签

   |  属性   |                             描述                             |
   | :-----: | :----------------------------------------------------------: |
   | action  |     提交数据到服务器的url地址，默认值为当前页面的url地址     |
   | method  |        以什么方式提交数据，通常为get或post，默认为get        |
   | enctype | 发送数据前以何种方式对数据进行编码，`application/x-www-form-urlencoded`、`multipart/form-data`、`text/plain`，默认为application |
   | target  | 在何处打开url，`_blank`、`_self`，默认值为`_self`，在相同的框架中打开url |

   ```html
   <form action="/login" method="post" target="_blank">
   ```

   > 提交表单后，页面会立即跳转到action指定的url地址
   >
   > get方式提交数据会以明文方式放在url地址里面，而post不会，是以form data的方式隐式提交的，安全性更高，post适合用来提交大量的、复杂的数据，比如文件上传，向服务器提交数据一般使用post
   >
   > enctype默认方式在发送数据之前会对数据进行编码，multipart不对数据编码，但是如果表单包含文件上传控件时必须使用该方式

2. 表单域

   包含文本框、密码框、隐藏域、复/单选框、选择框、文件上传框等等

3. 表单按钮

   一般为提交按钮

###### 14.4.2 表单同步提交

点击表单按钮提交数据时，页面跳转到action指定的url地址的行为叫做表单的同步提交，同步提交造成用户的体验很不好，而且同步提交后之前页面的数据会丢失，解决办法是可以换成Ajax来异步提交表单的数据，而表单只负责采集数据，具体方法如下

1. 监听表单的提交事件

   ```js
   $(function () {
       // 第一种方式
       // $('#f1').submit(function () {
       //   alert('监听到了表单的提交事件')
       // })
   
       // 第二种方式
       $('#f1').on('submit', function () {
           alert('监听到了表单的提交事件2')
       })
   })
   ```

2. 虽然监听了表单的提交事件，但是表单提交还是会默认跳转，需要进一步阻止其跳转行为

   ```js
   $('#f1').on('submit', function (e) {
       alert('监听到了表单的提交事件2')
       e.preventDefault() // 阻止表单提交和页面跳转
   })
   ```

3. 获取表单数据，常规做法是给每个表单域的控件取id，然后通过id获取值，但是这样就太繁琐了，为了简化这个操作，jQuery提供了`serialize()`函数帮助一键获取表单的数据，但要注意在使用这个函数之前要为每个控件添加name属性

   >中文的打印结果是乱码，原因是serialize()会自动调用encodeURIComponent方法将数据进行编码
   >解决方法：调用decodeURIComponent(XXX,true)将数据解码 

   ```js
   $('#f1').on('submit', function (e) {
       alert('监听到了表单的提交事件2')
       e.preventDefault() // 阻止表单提交和页面跳转
       var data = $(this).serialize()
       // console.log(data) // 中文会乱码
       var decData = decodeURIComponent(data, true)
       console.log(decData) // user_name=但是&password=sdaaasa
   })
   ```

##### 14.5 XMLHttpRequest

尽管名称是 XML，但是 `XMLHttpRequest` 可以用于获取任何类型的数据，而不仅仅是 XML

###### 14.5.1 发起GET请求

```js
// 获取 xhr 实例
const xhr = new XMLHttpRequest()
// 第三个参数是 async，默认不写为 true，表示异步执行
xhr.open('GET', '/JavaScript/myFolder/myFile.json', true)
xhr.onreadystatechange = function () {
  // 只有当准备状态为 4 且状态码为 200 时才视为返回请求数据成功
  // readyState：xhr对象的请求状态 status：服务器响应状态
  if (xhr.readyState === 4 && xhr.status === 200) {
    console.log(JSON.parse(xhr.responseText))
  }
}
xhr.send(null)
```

###### 14.5.2 readyState

表示XHR对象所处的状态

|  值  |       表示       | 解释                                                         |
| :--: | :--------------: | :----------------------------------------------------------- |
|  0   |      UNSENT      | xhr 对象创建成功                                             |
|  1   |      OPENED      | 已调用 `open()` 和 `send()`                                  |
|  2   | HEADERS_RECEIVED | `send()` 执行完成，响应头已被接收                            |
|  3   |     LOADING      | 数据接收中，此时 `xhr.response` 属性中已包含部分数据         |
|  4   |       DONE       | 请求完成，数据传输已经完成（成功或者失败，需要根据状态码进一步判断） |

###### 14.5.3 查询字符串

如果想在发送请求时添加参数，则可以使用查询字符串在 url 后面添加查询的参数，在url链接后面加上 `?`，然后以键值对方式添加查询参数，参数间以 `&` 分隔，具体格式如下

```js
'http://www.liulongbin.top:3006/api/getbooks?id=1&name=zs'
```

> 当发起get请求时，无论是通过 jQuery 的 Ajax 还是直接使用原生 xhr 对象，我们传给这些函数的参数，无论参数是对象还是普通变量，本质上都会变成查询字符串的形式拼接到 URL 地址上

###### 14.5.4 URL编码

在 URL 地址中只允许出现英文字母标点符号和数字，不允许出现中文，如果确实需要出现中文，则需要进行转义，也就是编码，用安全的字符去表示不安全的字符

> 安全字符：特殊字符，看不懂的无意义的字符
>
> 不安全字符：比如中文

浏览器提供了原生的编解码函数，分别是 `encodeURI()` 和 `decodeURI()`，由于浏览器会自动对 URL 地址进行编码，我们一般不必将其强行解码为中文

###### 14.5.5 发起POST请求

与发起 GET 请求略有不同，主要是发送数据的方式不同

```js
// 发送请求字符串的格式
// 1. 创建 xhr 对象
var xhr = new XMLHttpRequest()
// 2. 调用 open 函数
xhr.open('POST', 'http://www.liulongbin.top:3006/api/addbook')
// 3. 设置 Content-Type 属性
xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded')
// 4. 调用 send 函数
xhr.send('bookname=水浒传&author=施耐庵&publisher=上海图书出版社')
// 5. 监听事件
xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {
        console.log(xhr.responseText)
    }
}

// 发送 JSON 格式的数据
// POST 请求需要发送数据，接收数据都是一样的
xhr.open('POST', '/login', true)
xhr.onreadystatechange = function () {
  if (xhr.readyState === 4 && xhr.status === 200) {
    console.log(JSON.parse(xhr.responseText))
  }
}
const postData = {
  username: 'zs',
  age: 18
}
xhr.send(JSON.stringify(postData))
```

###### 14.5.6 处理超时请求

在新版的 xhr 中可以设置请求超时时间和处理函数，提高用户体验

```js
var xhr = new XMLHttpRequest()

// 设置超时时间及对应的处理函数
xhr.timeout = 30
xhr.ontimeout = function () {
    console.log('请求超时了！')
}

xhr.open('GET', 'http://www.liulongbin.top:3006/api/getbooks', true)
xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {
        console.log(xhr.responseText)
    }
}
xhr.send(null)
```

###### 14.5.7 FormData对象

为了方便对表单进行处理，HTML5 新增了一个 `FormData` 对象，用来模拟表单操作，而不必非得在 HTML 文件中写 `<form>` 标签

```js
// 1. 创建 FormData 实例
var fd = new FormData()
// 2. 向实例中追加表单数据
fd.append('uname', 'zs')
fd.append('upwd', '123456')

var xhr = new XMLHttpRequest()
xhr.open('POST', 'http://www.liulongbin.top:3006/api/formdata', true)
xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {
        console.log(JSON.parse(xhr.responseText))
    }
}
xhr.send(fd)
```

如果网页中已经有 `<form>` 标签了，也可以利用 `FormData` 对象去获取表单里的数据，只需要获取 `form` 元素对象传递给 `FormData` 对象即可

```js
// 1. 通过 DOM 操作，获取到 form 表单元素
var form = document.querySelector('#form1')

form.addEventListener('submit', e => {
    // 阻止表单的默认提交行为
    e.preventDefault()

    // 创建 FormData，快速获取到 form 表单中的数据
    var fd = new FormData(form)

    var xhr = new XMLHttpRequest()
    xhr.open('POST', 'http://www.liulongbin.top:3006/api/formdata', true)
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            console.log(JSON.parse(xhr.responseText))
        }
    }
    xhr.send(fd)
})
```

###### 14.5.8 上传文件

新版 xhr 不仅可以发送文本，还可以上传文件，利用 `<input>` 标签选择文件，添加给 `FormData` 对象即可上传

```js
// 1. 获取到文件上传按钮
var btnUpload = document.querySelector('#btnUpload')

// 2. 为按钮绑定单击事件处理函数
btnUpload.addEventListener('click', function () {
    
    // 3. 获取到用户选择的文件列表
    var files = document.querySelector('#file1').files
    if (files.length <= 0) {
        return alert('请选择要上传的文件！')
    }
    
    // 4. 将用户选择的文件，添加到 FormData 中
    var fd = new FormData()
    fd.append('avatar', files[0])

    var xhr = new XMLHttpRequest()
    xhr.open('POST', 'http://www.liulongbin.top:3006/api/upload/avatar', true)
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var data = JSON.parse(xhr.responseText)
            if (data.status === 200) {
                // 上传成功
                document.querySelector('#img').src = 'http://www.liulongbin.top:3006' + data.url
            } else {
                // 上传失败
                console.log('图片上传失败！' + data.message)
            }
        }
    }
    xhr.send(fd)
})
```

只是点击上传，没有显示上传进度，对用户的体验是不好的，在新版 xhr 中还可以通过监听 `xhr.upload.onprogress` 事件来获取文件的上传进度

```js
var xhr = new XMLHttpRequest()

// 监听文件上传的进度
xhr.upload.onprogress = function (e) {
    if (e.lengthComputable) {
        // 计算出上传的进度
        var procentComplete = Math.ceil((e.loaded / e.total) * 100)
        console.log(procentComplete)
        // 动态设置进度条
        $('#percent')
            .attr('style', 'width: ' + procentComplete + '%;')
            .html(procentComplete + '%')
    }
}

// 上传成功，改变进度条样式
xhr.upload.onload = function () {
    $('#percent')
        .removeClass()
        .addClass('progress-bar progress-bar-success')
}

xhr.open('POST', 'http://www.liulongbin.top:3006/api/upload/avatar', true)
xhr.send(fd)
```

可以看出使用 xhr 上传文件还是比较麻烦的，jQuery 也封装了上传文件的函数，使用起来更简单

```js
$(function () {
    $('#btnUpload').on('click', function () {
        var files = $('#file1')[0].files
        if (files.length <= 0) {
            return alert('请选择文件后再上传！')
        }

        var fd = new FormData()
        fd.append('avatar', files[0])

        // 发起 jQuery 的 Ajax 请求，上传文件
        $.ajax({
            method: 'POST',
            url: 'http://www.liulongbin.top:3006/api/upload/avatar',
            data: fd,
            // 不许修改 contentType 属性，使用 FormData 的 contentType
            contentType: false,
            // 不许对 FormData中 的数据编码，将数据原样发送到服务器
            processData: false,
            success: function (res) {
                console.log(res)
            }
        })

        // 监听 Ajax 请求的发起，会监听所有的 Ajax 请求
        $(document).ajaxStart(function () {
            $('#loading').show()
        })

        // 监听到 Ajax 完成
        $(document).ajaxStop(function () {
            $('#loading').hide()
        })
    })
})
```

###### 14.5.9 手写简易的Ajax
面试可能会考，其实也就是用 xhr 的方式实现
```js
function ajax(url, successFn) {
  const xhr = new XMLHttpRequest()
  xhr.open('GET', url, true)
  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {
      successFn(xhr.responseText)
    }
  }
  xhr.send(null)
}

// 如果想复杂一点可以用 promise 封装一下
function ajax(url) {
  return new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest()
    xhr.open('GET', url, true)
    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4) {
        if (xhr.status === 200) {
          resolve(JSON.parse(xhr.responseText))
        } else if (xhr.status === 404) {
          reject(new Error('404 not found'))
        }
      }
    }
    xhr.send(null)
  })
}

const url = '/data'
ajax(url)
  .then(res => console.log(res))
  .catch(err => console.error(err))
```


##### 14.6 数据交换格式

就是客户端与服务器端约定好的数据交换格式，常见的数据交换格式有XML和JSON，其中XML较少使用，JSON常用

###### 14.6.1 JSON

先来说说XML，全称是Extensible Markup Language，可拓展标记语言，与HTML一同为标记语言，但是两者的用途不一样，HTML用于标记网页内容，而XML用于传输数据，然而XML有其缺点存在，虽然语义明确，但是和数据无关的代码太多，导致体积大，传输数据效率低，其次在js中解析xml比较麻烦

```xml
<note>
    <from>张三</from>
    <to>李四</to>
    <heading>通知</heading>
    <body>开会</body>
</note>
```

而JSON的全称是Javascript Object Notation，JS对象表示法，顾名思义，JSON主要就是用来表示js对象的表示法，它使用文本来表示js对象，所以JSON的本质是字符串，比XML更快、小和易于解析

###### 14.6.2 JSON结构

json表示的js对象主要是对象和数组

1. 对象结构

   对象结构在json中表示为`{}`括起来的内容，内容主要是键值对，以逗号分隔，键是英文双引号包裹的字符串，值可以是数字、字符串、null、布尔值、数组、对象这六种数据类型，不可以是undefined、函数等值

2. 数组结构

   数组结构在json中表示为`[]`括起来的内容，内容就是数组内容，数据类型和对象结构的一致

> JSON中不允许使用单引号，不能写注释，最外层必须是对象或数组格式

###### 14.6.3 序列化与反序列化

序列化：将数据对象转化为字符串的过程叫做序列化

反序列化：与序列化相反的过程，也就是将字符串转化为数据对象的过程叫做反序列化

JSON字符串转为JS对象，也就是JSON反序列化

```js
var jsonStr = '{"a": "Hello", "b": "world"}'
var obj = JSON.parse(jsonStr)
console.log(obj) // Object a: "Hello" b: "world"
```

JS对象转为JSON字符串，也就是JSON序列化

```js
var obj2 = { a: 'hello', b: 'world', c: false }
var str = JSON.stringify(obj2)
console.log(str) // {"a":"hello","b":"world","c":false}
console.log(typeof str) // string
```

#### 15 axios

##### 15.1 axios简介

axios 是一个专门用于处理网络请求的 js 库，是一个基于 promise 的HTTP库，有如下优点

1. 相比于原生的 `XMLHttpRequest` 对象，axios 使用起来更简单

2. Ajax 虽然好用，但是不可避免地要引入 jQuery，而 jQuery 不仅仅只有 Ajax，还有其他很多功能，随之而来的问题是体积增大

   axios专注于网络请求，更加轻量化

axios 的使用和 Ajax 基本一致，作为 js 库，首先需要引入其 js 文件

1. 引入js文件

   ```js
   <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
   ```

2. 使用axios对象发起请求

   ```js
   // 调用axios的get函数发起get请求
   document.querySelector('#btn1').addEventListener('click', function () {
       var url = 'http://www.liulongbin.top:3006/api/get'
       var paramsObj = { name: 'zs', age: 20 }
       axios.get(url, { params: paramsObj }).then(function (res) {
           // axios返回的res包含了不少属性，其中data是我们需要的返回数据
           console.log(res.data)
       })
   })
   
   // 调用axios的post函数发起post请求
   document.querySelector('#btn2').addEventListener('click', function () {
       var url = 'http://www.liulongbin.top:3006/api/post'
       var dataObj = { address: '北京', location: '顺义区' }
       axios.post(url, dataObj).then(function (res) {
           console.log(res.data)
       })
   })
   
   // 直接用axios发起get请求
   document.querySelector('#btn3').addEventListener('click', function () {
       var url = 'http://www.liulongbin.top:3006/api/get'
       var paramsData = { name: '钢铁侠', age: 35 }
       axios({
           method: 'GET',
           url: url,
           params: paramsData
       }).then(function (res) {
           console.log(res.data)
       })
   })
   
   // 直接用axios发起post请求
   document.querySelector('#btn4').addEventListener('click', function () {
       axios({
           method: 'POST',
           url: 'http://www.liulongbin.top:3006/api/post',
           data: {
               name: '娃哈哈',
               age: 18,
               gender: '女'
           }
       }).then(function (res) {
           console.log(res.data)
       })
   })
   ```

##### 15.2 同源策略与跨域

先来看下什么是同源，同源就是指两个 URL 地址的网络协议、域名、端口号完全相同，则两个 URL 地址是同源的（具有相同的源）

网页默认的端口号是 80，比如针对 URL地址 `http://www.test.com/index.html` 判断是否同源

|                 URL                 |                  是否同源                  |
| :---------------------------------: | :----------------------------------------: |
|   http://www.test.com/other.html    |                     是                     |
|   https://www.test.com/other.html   | 否，网络协议不同，http 和 https 是不一样的 |
|   http://blog.test.com/other.html   |               否，域名不一样               |
| http://www.test.com:8888/other.html |              否，端口号不一样              |
|  http://www.test.com:80/other.html  |                     是                     |

同源策略的英文是 SOP（same origin policy），是浏览器提供的一个安全功能，同源策略规定了不同源的网页或脚本之间的交互规则，是用于隔离潜在恶意文件的浏览器的重要安全机制，简单理解就是不同的网站之间不允许进行资源的交互，比方说无法操作对方的 DOM，无法发送 Ajax 请求给对方去请求对方的资源，无法去读取对方的 cookie 等等

> 其实不同源的网页间可以正常发起数据请求，服务器也能正常返回数据，只是数据会被浏览器拦截下来，发现不同源之后就会拒绝把数据返回给网页，这就造成了同源策略的限制

可是有时候我们恰好需要破解同源策略的限制又怎么办呢，而且这是非常常见的情况，特别是现在前后端分离开发之后，比如我们前端网页的 URL 地址和服务器的接口地址往往是不同源的，而我们又需要向接口地址请求数据，这时就会受到浏览器的同源策略的限制，所以必须要进行跨域请求，目前主要有两种主流的跨域解决方案，分别是 `JSONP` 和 `CORS`

- JSONP

  JSONP 应该是最早的解决跨域的方案，因此兼容性好，可以兼容低版本的 IE，这是前端人员想出来的临时解决方案

  - 直接发起JSONP

    JSONP（JSON with Padding），是一种 JSON 的使用模式，我们知道在网页中无法通过 Ajax 去请求非同源的接口数据

    但是

    图片标签 `<img src="跨域的 URL 地址" />`

    CSS 标签 `<link href="跨域的 URL 地址" />`

    JS 标签 `<script src="跨域的 URL 地址"></script>` 

    它们的地址属性却可以请求到非同源的网站的数据，因此我们就可以利用 `script` 标签的 `src` 属性去请求跨域的数据

    ```html
    <script>
        function callback(data) {
            console.log(`JSONP响应回来的数据是：${data}`)
        }
    </script>
    <!-- callback 参数用于指定接收返回数据的回调处理函数 -->
    <script src="http://www.liulongbin.top:3006/api/jsonp?callback=callback&name=ls&age=30"></script>
    ```

    > 用这种方式发起的请求只能发起 GET 请求，这是 JSONP 的缺点
    >
    > JSONP 和 XHR 没有关系，因为整个过程中没有用到 `XMLHttpRequest` 对象
    >
    > 需要注意的是，所有的跨域请求必须要经过服务器端的配合和允许，否则就算使用 JSONP，也是请求不成功的，如果服务器不允许跨域还跨域成功了，这就是属于安全漏洞

  - 通过 Ajax 发起 JSONP 请求

    对于 JSONP，jQuery 的 Ajax 自然也提供了封装，不指定回调函数的情况下，jQuery 会自动生成一个，jQuery封装的 JSONP 请求原理和利用 script 标签 src 属性请求是一样的，稍微不同的点是 jQuery 是临时在 `<head>` 标签中生成一个 `<script>` 标签，请求完毕再移除标签的方式

    ```js
    $(function () {
        // 发起JSONP的请求
        $.ajax({
            url: 'http://ajax.frontend.itheima.net:3006/api/jsonp?name=zs&age=20',
            // 需要指定数据类型为JSONP
            dataType: 'jsonp',
            // 自定义参数名称，默认为callback，可不写
            jsonp: 'callback',
            // 自定义回调函数名称，默认自动生成
            jsonpCallback: 'abc',
            success: function (res) {
                console.log(res)
            }
        })
    })
    ```

- CORS

  CORS（Cross-Origin Resource Sharing）属于跨域请求的根本性的解决方案，是 w3c 的标准，支持 GET 和 POST 请求，缺点是兼容性不太好，这个**由服务器端设置**，主要是设置了 http 的 header，设置了允许跨域的 URL 地址，以及请求的方法
  
  服务器设置好之后，对应的前端 URL 地址就可以直接发起 Ajax 请求去访问服务器的数据了，而不用去采用 JSONP 的方式请求数据
  
  ```js
  // 设置允许跨域的 URL 地址，不建议直接写 “ * ”
  response.setHeader("Access-Control-Allow-Origin", "http://localhost:8888");
  response.setHeader("Access-Control-Allow-Headers", "X-Requested-With");
  response.setHeader("Access-Control-Allow-Methods", "PUT,POST,GET,DELETE,OPTIONS");
  // 接收跨域的cookie
  response.setHeader("Access-Control-Allow-Credentials", "true");
  ```

##### 15.3 防抖节流与缓存

防抖策略（debounce）：是当事件触发后，延迟n秒后再执行回调函数，如果在n秒内事件被再次触发则重新计时，也就是延迟触发事件，防抖的好处在于不管短时间内触发了多少次事件，只有最后一次会被执行

**应用场景：**

比如用户在搜索框内输入关键字查询，我们需要监听用户输入关键字的事件，如果用户输入每个字都去监听并执行回调函数，那么就会触发很多次查询请求，这样很浪费服务器性能，于是我们就可以利用防抖，等用户确定输入完毕后在执行查询操作

```js
// 1. 定义延时器的Id
var timer = null
// 2. 定义防抖的函数
function debounceSearch(kw) {
    timer = setTimeout(function () {
        getSuggestList(kw)
    }, 500)
}

$('#ipt').on('keyup', function () {
    // 3. 清空 timer
    clearTimeout(timer)
    
    var keywords = $(this).val().trim()
    if (keywords.length <= 0) {
        return $('#suggest-list').empty().hide()
    }
	// 调用防抖函数请求数据
    debounceSearch(keywords)
})
```

对于查询过的结果，可以进行缓存，减少发送请求的次数，节约服务器资源



节流策略（throttle）：在一定时间内减少事件的触发频率，比方游戏中的英雄攻击频率是固定的，不管你短时间内按下多少次攻击键，英雄也还是固定攻击指定的次数

具体的实现方式为设置节流阀，节流阀就是一个标志，标志是否可以进行操作

**应用场景：**

1. 鼠标短时间内多次点击，但是在单位时间内只触发一次事件
2. 网页懒加载时要监听滚动条位置，其实不用每次滑动网页都去监听，而是降低计算的频率

鼠标跟随案例，短时间会触发大量鼠标移动监听事件，可以设置节流

```js
$(function () {
    var angel = $('#angel')
    // 定义节流阀
    var timer = null
    $(document).on('mousemove', function (e) {
        // 节流阀不为空则直接返回
        if (timer) {
            return
        }
        // 开启延时器
        timer = setTimeout(function () {
            $(angel)
                .css('top', e.pageY + 'px')
                .css('left', e.pageX + 'px')
            console.log('ok')
            // 重置节流阀
            timer = null
        }, 16)
    })
})
```

##### 15.4 HTTP协议

通信就是信息的传递与交换，通信有三要素分别是主体、内容、方式，主体就是通信的双方，内容就是通信内容，方式就是通信方式

通信协议就是双方约定好的通信格式发送和接收消息，客户端与服务器端要传输的内容是网页，而网页又叫超文本，故它们之间的传输协议就是超文本传输协议，HyperText Transfer Protocol，简写就是HTTP协议

HTTP协议的交互模型是请求和响应，客户端请求，服务器响应客户端的请求

###### 15.4.1 HTTP请求消息

客户端发起的请求叫HTTP请求，客户端发送给服务端的消息就叫HTTP请求消息，HTTP请求消息由四部分组成，请求标头里面可以查看

1. 请求行（request line）

   请求行由三部分组成，分别是请求方式、URL、HTTP协议版本，它们之间由空格隔开

   ```txt
   GET /api/get?name=zs&age=20 HTTP/1.1
   ```

2. 请求头（header）

   请求头部用于描述客户端的基本信息，比如user-agent描述客户端是什么浏览器，content-type描述发送的数据格式，accept描述客户端接收什么类型的返回内容，accept-language描述接收什么语言的返回内容

   ```txt
   Host: www.liulongbin.top:3006
   User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36
   Accept: */*
   Accept-Encoding: gzip, deflate
   Accept-Language: en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7,zh-TW;q=0.6
   ```

3. 空行

   请求头字段结束后是一个空行，告知服务器请求头部至此结束，其作用就是用来分隔请求头和请求体的

4. 请求体

   请求体中存放的就是需要提交到服务器的数据，只有post请求才会有内容，form data，表单数据

   ```txt
   name=zs&age=20
   ```

###### 15.4.2 HTTP响应消息

响应消息就是服务器响应给客户端的消息，也叫做响应报文，相应的，响应消息也是由四部分组成的

1. 状态行

   状态行由三部分组成，分别是HTTP协议版本、状态码、状态码说明

   ```txt
   HTTP/1.1 200 OK
   ```

2. 响应头

   响应头部用于描述服务器的基本信息

   ```txt
   X-Powered-By: Express
   Access-Control-Allow-Origin: *
   Content-Type: application/json; charset=utf-8
   Content-Length: 79
   ETag: W/"4f-h8WypMHQNdDpzXt1ibCRH/fCOBg"
   Date: Thu, 16 Dec 2021 14:52:14 GMT
   Connection: keep-alive
   Keep-Alive: timeout=5
   ```

3. 空行

   与请求消息中的空行作用类似，都是用来分隔响应头和响应体的

4. 响应体

   响应体中存放的自然就是服务器响应给客户端的资源了

   ```txt
   {"message":"POST请求测试成功","body":{"name":"zs","age":"20"},"query":{}}
   ```

###### 15.4.3 HTTP请求方法

HTTP请求方法属于HTTP协议的一部分，作用是表明要对服务器进行的操作，常用的请求方法为get和post

|  GET   | 查询服务器上的资源，请求体中不包含请求数据，请求数据放在协议头中 |
| :----: | :----------------------------------------------------------: |
|  POST  |          新增服务器上的资源，请求数据包含在请求体中          |
|  PUT   |                      修改服务器上的资源                      |
| DELETE |                      删除服务器上的资源                      |

###### 15.4.4 HTTP响应状态码

英文全称为HTTP Status Code，也属于HTTP协议的一部分，用于标识服务器响应的状态，客户端可以通过响应消息得知响应状态码，通过响应状态码可以得知请求是成功还是失败

HTTP状态码由三位数组成，第一位表明状态码的类型，后两位用于进一步细分，共分为五种类型

| 1**  | 服务器信息，表示服务器已收到请求，但是需要请求者继续执行某些操作，很少遇见 |
| :--: | :----------------------------------------------------------: |
| 2**  |             响应成功，表明请求已被成功接收并处理             |
| 3**  |               重定向，需要进一步操作以完成请求               |
| 4**  | 客户端错误，表明客户端存在错误导致请求无法完成，比如语法错误 |
| 5**  |         服务器错误，表明服务器在处理请求时发生了错误         |

常见的状态码如下

| 状态码 |       英文说明        |                           中文说明                           |
| :----: | :-------------------: | :----------------------------------------------------------: |
|  200   |          OK           |               响应成功，一般用于get或post请求                |
|  201   |        Created        |        已成功创建，一般用于创建资源，如post或put请求         |
|  301   |   Moved Permanently   | 永久移动，请求的资源已被永久移动到新url，返回信息包含新url，浏览器会自动重定向到新url，客户端应更新请求url |
|  302   |         Found         | 临时移动，与301类似，但是是临时移动，客户端应该保持旧url地址 |
|  304   |     Not Modified      | 资源未修改，表示服务器没有返回任何资源，而是从客户端的缓存中访问资源 |
|  400   |      Bad Request      | 请求参数有误，如语义错误，服务器端无法理解，客户端应该修改请求参数 |
|  401   |     Unauthorized      |                 用户未授权，需要验证用户权限                 |
|  403   |       Forbidden       |              服务器已接收请求，但是拒绝提供服务              |
|  404   |       Not Found       |      服务器无法根据请求找到资源，通常是url地址写错导致       |
|  408   |    Request Timeout    |         请求超时，服务器等待客户端发送请求的时间过长         |
|  500   | Internal Server Error |  服务器内部错误，无法完成请求，比如服务器内部的逻辑编码错误  |
|  501   |     Not Implement     | 服务器不支持该请求方法，只有GET和HEAD请求是服务器必须支持的  |
|  503   |  Service Unavailable  |           服务器超载或者正在维护，暂时无法处理请求           |
