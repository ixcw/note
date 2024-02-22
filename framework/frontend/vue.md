#### 1 vue

vue 由国人尤雨溪发明，是一款**渐进式**的 js **框架**

框架：之前学习的 jQuery 只能称为类库，类库一般专为解决某一方面的问题而诞生的，而框架则有一套**完整的解决方案**

渐进式：所谓渐进式就是你可以只使用 vue 的一部分功能特性，也可以使用完整的全套功能，由自己选择

#### 2 vue与传统开发对比

传统开发无论是原生 js 还是 jQuery 都是需要操作 Dom 的，即把网页元素选出来进行操作，比如选出元素为元素添加内容等，而 vue 做的事情其实也差不多，只不过有些许差别

```html
<div id="app">{{ msg }}</div>
```

```js
let vm = new Vue({
    el: '#app',
    data: {
        msg: 'hello world!'
    }
})
```

这就将 id 为 app 的 div 元素选出来并传递了 msg 数据，虽然同为选择元素，但是我们可以发现 vue 并**没有直接操作 Dom**，而是通过插值表达式的方式传递数据

插值表达式支持一些简单的 js 计算，比如加减运算、三元运算符、字符串拼接、大小判断等，对于所有的数据绑定，Vue 都提供了**完全的 JavaScript 表达式支持**，有个限制就是，每个绑定都只能包含**单个表达式**

```html
<div id="app">
    <div>{{msg}}</div>
    <div>{{1 + 2}}</div>
    <div>{{1 ? 'yes' : 'no'}}</div>
    <div>{{'msg: ' + msg}}</div>
    <div>{{2 > 1}}</div>
    <div>{{ msg.split('').reverse().join('') }}</div>
    <!-- 不会生效，这是语句，不是表达式 -->
    {{ var a = 1 }}
    <!-- 流控制也不会生效，请使用三元表达式 -->
    {{ if (ok) { return message } }}
</div>
<script>
    let vm = new Vue({
        el: '#app',
        data: {
            msg: 'hello world!'
        }
    })
</script>
```

#### 3 前端渲染

前端渲染也就是将模板和数据渲染形成 HTML 页面的过程

1. 原生的做法是拼接字符串，略显繁琐，不同的人写出来的代码差异大，后期难以维护
2. 之后就诞生了模板引擎，但模板引擎依然比较耦合，而且没有提供**事件机制**，我们还是需要操作 Dom 填充数据
3. 现在有了 vue 等前端框架，和模板引擎一样，vue 使用**模板语法**来进行前端渲染，但是 vue 的模板语法提供了事件机制

#### 4 基本语法

每个 Vue 应用都是通过用 Vue 函数创建一个新的** Vue 实例**开始的，当创建一个 Vue 实例时，你可以传入一个**选项对象**，教程主要描述的就是如何使用这些选项来创建你想要的行为

一个 Vue 应用由一个通过 `new Vue` 创建的**根 Vue 实例**，以及可选的嵌套的、可复用的组件树组成

##### 4.1 指令

指令就类似于自定义属性，不是类似于，其本质就是自定义属性，只不过是 vue 自定义出来的，以 `v-` 开头，这也符合 vue 的命名

指令提供了 vue 的一系列功能

指令 attribute 的值预期是**单个 JavaScript 表达式** (`v-for` 是例外情况，稍后我们再讨论)。指令的职责是，当表达式的值改变时，将其产生的连带影响，响应式地作用于 Dom

1. `v-cloak`

   前面我们学的插值表达式直接使用存在一个问题，就是刷新页面时，页面会先显示插值表达式，等数据渲染完成后再显示渲染好的内容，这就出现了页面闪动的现象，在页面刷新快的时候感受不出来，但一旦感受出来了用户体验就很差，`v-cloak` 就可以用来解决这个问题

   这个指令会**一直保持在元素上**直到**关联实例结束编译**，和 CSS 规则如 `[v-cloak] { display: none; }` 一起用时，这个指令可以先隐藏未编译的 Mustache 标签（插值表达式）直到实例准备完毕

   ```html
   <style>
       [v-cloak] {
           display: none;
       }
   </style>
   
   <div id="app" v-cloak>
       <div>{{ msg }}</div>
       <div>{{ 1 + 2 }}</div>
       <div>{{ 1 ? 'yes' : 'no' }}</div>
       <div>{{ 'msg: ' + msg }}</div>
       <div>{{ msg.split('').reverse().join('') }}</div>
   </div>
   
   <script>
       let vm = new Vue({
           el: '#app',
           data: {
               msg: 'hello world!'
           }
       })
   </script>
   ```
   
2. `v-text`

   更新元素的文本内容

   如果要更新部分的文本内容，需要使用插值表达式

   这个指令没有插值表达式的闪动问题

   ```html
   <div id="app" v-cloak>
       <div v-text="msg"></div>
   </div>
   ```

3. `v-html`

   将内容按原始 HTML 插入，内容不会作为 Vue 模板进行编译

   > 动态更新HTML的操作是很危险的，很容易导致 [XSS 攻击](https://en.wikipedia.org/wiki/Cross-site_scripting)，最好只用在可信内容上，**绝不要**对用户提供的内容使用插值

   ```html
   <div id="app" v-cloak>
       <div v-html="msg1"></div>
   </div>
   
   <script>
       let vm = new Vue({
           el: '#app',
           data: {
               msg: 'hello world!',
               msg1: '<h1>标题</h1>'
           }
       })
   </script>
   ```

4. `v-pre`

   跳过这个元素和它的子元素的编译过程，可以用来显示原始 Mustache 标签，跳过大量没有指令的节点会加快编译

   ```html
    <div v-pre>{{msg}}</div>
   ```

   这将不会编译数据msg，而是直接显示`{{msg}}`

5. `v-once`

   数据响应式是指数据变化之后，页面数据也会同步变化

   而使用了`v-once`指令后，插值就是一次性的，后续会失去响应式功能，即**只编译一次**，即使后续数据发生变化，页面上的值也不会更新

   如果有的数据显示后不再需要修改可以使用这个指令

   这可以提高性能，因为数据响应式需要vue不断地监听数据是否发生变化，而`v-once`则不会，但请留心这会影响到该节点上的其它数据绑定

   ```html
   <div v-once>{{info}}</div>
   ```

6. `v-model`

   双向数据绑定，前面的数据绑定都是 数据 => 页面 ，是单向的，而vue可以实现双向数据绑定，即 页面 <=> 数据，`v-model`可以实现数据的双向绑定

   ```html
   <input type="text" v-model="msg" />
   ```

   在输入框输入值后会实时更新数据msg的值，同时msg的值改变又会影响到输入框里的值

   这里也体现了vue的MVVM的设计思想，Model和View只能通过View-Model进行间接交互，模型和视图不能直接交互，或者说数据和页面Dom不直接交互

7. `v-on`

   `v-on` 提供事件绑定的功能，简写形式是 `@`

   ```html
   <div>
       <div>{{num}}</div>
       <button v-on:click="num++">点击 on</button>
       <button @click="num++">点击 @</button>
   </div>
   ```

   但是直接将事件处理代码写到引号里是不好的，应该将复杂逻辑代码抽取到函数中，在创建vue实例时传入的参数里的methods属性专门用于定义函数，函数创建完成后我们可以通过传递函数名的形式传给事件绑定指令，从而实现事件绑定

   ```html
   <div>
       <div>{{num}}</div>
       <button @click="handle">点击 handle</button>
       <button @click="handle()">点击 handle()</button>
   </div>
   
   <script>
       let vm = new Vue({
           el: '#app',
           data: {
               num: 1
           },
           methods: {
               handle: function () {
                   // this指向的是实例对象vm
                   this.num++
               }
           }
       })
   </script>
   ```
   当不需要传参数给函数时，传`函数名`和`传函数名()`效果是一样的

   但是当我们确定需要传递参数给函数时，函数名就必须要加括号了，给函数传递事件对象的固定写法是`$event`，且必须是最后一位参数

   > 如果不加括号直接传递函数名，那么默认传递的参数就是事件对象

   ```html
   <div>
       <div>{{num}}</div>
       
       <!-- 打印了事件对象，默认传递了事件对象 -->
       <button @click="handle">点击 handle</button>
       
       <!-- 这里打印的是undefined，因为什么也没传，要显式传递事件对象必须是$event -->
       <button @click="handle()">点击 handle()</button>
       
       <button @click="handle1(23, $event)">handle1(23, $event)</button>
   </div>
   
   <script>
       let vm = new Vue({
           el: '#app',
           data: {
               num: 1
           },
           methods: {
               handle: function (event) {
                   this.num++
                   console.log(event)
               },
               handle1: function (p, event) {
                   // this指向的是实例对象vm
                   this.num++
                   console.log(p)
                   console.log(event)
               }
           }
       })
   </script>
   ```
   **事件修饰符：**就是帮助我们处理事件的修饰符，使用起来和以前原生写法相比简单多了

   - `.stop`：阻止冒泡

     如果使用原生的方式，需要在底层元素上调用事件对象的阻止冒泡函数

     ```html
     <div @click="handle">
         <button @click="handle1">阻止冒泡</button>
     </div>
     
     <script>
         methods: {
             handle: function (event) {
                 console.log(event)
             },
             handle1: function (event) {
                 event.stopPropagation()
             }
         }
     </script>
     ```

     而使用事件修饰符就简单多了，直接加上修饰符即可

     ```html
     <div @click="handle">
         <button @click.stop="handle2">阻止冒泡</button>
     </div>
     ```

   - `.prevent`：阻止默认行为

     原生做法是绑定事件，然后再调用事件对象的阻止默认行为函数

     ```js
     <a href="https://www.baidu.com" @click="handle3">百度</a>
     
     handle3: function (event) {
         event.preventDefault()
     }
     ```

     使用事件修饰符

     ```html
     <a href="https://www.baidu.com" @click.prevent>百度</a>
     ```

   **按键修饰符：**顾名思义是用来帮助处理按键的

   ```html
   <form action="">
       <div>用户名：<input type="text" v-model="uname" /></div>
       <div>密码：<input type="password" v-model="pwd" /></div>
       <div><input type="button" value="提交" @click="handleSubmit" /></div>
   </form>
   ```

   ```js
   handleSubmit: function () {
       console.log(this.uname)
       console.log(this.pwd)
   }
   ```

   使用按键修饰符，就可以监听键盘事件，在输完密码后直接按下enter处理表单了

   ```html
   <form action="">
       <div>用户名：<input type="text" v-model="uname" /></div>
       <div>密码：<input type="password" v-model="pwd" @keyup.enter="handleSubmit" /></div>
       <div><input type="button" value="提交" @click="handleSubmit" /></div>
   </form>
   ```

   按删除键调用函数

   ```html
   <div>密码：<input type="password" v-model="pwd" @keyup.enter="handleSubmit" @keyup.delete="clearContent" /></div>
   ```

   ```js
   clearContent: function () {
       this.pwd = ''
   }
   ```

   如果觉得vue提供的按键修饰符不够用，可以自己自定义，只需要拿到按键的ASCII码（可以通过事件对象的属性keyCode获取）

   ```js
   Vue.config.keyCodes.a = 65
   ```

   然后就可以使用自定义按键修饰符了

   ```html
   <input type="text" v-model="pwd" @keyup.a="handle" />
   ```

8. `v-bind`

   `v-bind`用于**动态地处理属性值**

   ```html
   <a v-bind:href="url">百度 v-bind</a>
   ```

   > url是data中定义的数据

   可以简写为

   ```html
   <a :href="url">百度 :</a>
   ```

   到这里就可以解释一下`v-model`的双向数据绑定的实现过程了

   从数据 => 页面的绑定是通过`v-bind`实现

   然后页面 => 数据的绑定是通过事件绑定`v-on`获取输入值然后修改数据值实现的

   ```html
   <div>
       {{model}}
       <input type="text" :value="model" @input="viewToModel" />
   </div>
   ```

   ```js
   viewToModel: function (e) {
       this.model = e.target.value
   }
   ```

   或者直接写成这样就不用定义函数了

   ```html
   <input type="text" :value="model" @input="msg=$event.target.value" />
   ```

   不过既然`v-model`已经封装好了，那么直接使用`v-model`就可以了

   ```html
   <input type="text" v-model="model" />
   ```

   动态参数：

   v-bind可以接收动态参数，这个特性从2.6.0开始，可以用方括号括起来的 JavaScript 表达式作为一个指令的参数

   ```html
   <a v-bind:[attributeName]="url"> ... </a>
   ```

   这里的 `attributeName` 会被作为一个 JavaScript 表达式进行动态求值，求得的值将会作为最终的参数来使用。例如，如果你的 Vue 实例有一个 `data` property `attributeName`，其值为 `"href"`，那么这个绑定将等价于 `v-bind:href`

   同样地，你可以使用动态参数为一个动态的事件名绑定处理函数：

   ```html
   <a v-on:[eventName]="doSomething"> ... </a>
   ```

   在这个示例中，当 `eventName` 的值为 `"focus"` 时，`v-on:[eventName]` 将等价于 `v-on:focus`

   > 动态参数预期会求出一个字符串，异常情况下值为 `null`。这个特殊的 `null` 值可以被显性地用于移除绑定。任何其它非字符串类型的值都将会触发一个警告
   >
   > 动态参数表达式有一些语法约束，因为某些字符，如空格和引号，放在 HTML attribute 名里是无效的，变通的办法是使用没有空格或引号的表达式，或用计算属性替代这种复杂表达式
   >
   > 在 Dom 中使用模板时 (直接在一个 HTML 文件里撰写模板)，还需要避免使用大写字符来命名键名，因为浏览器会把 attribute 名全部强制转为小写

   利用`v-bind`还可以绑定样式，因为它们都是 attribute，所以我们可以用 `v-bind` 处理它们：只需要通过表达式计算出字符串结果即可。不过，字符串拼接麻烦且易错。因此，在将 `v-bind` 用于 `class` 和 `style` 时，Vue.js 做了专门的增强。表达式结果的类型除了字符串之外，还可以是对象或数组

   ```css
   .active {
       border: 1px solid violet;
       width: 100px;
       height: 100px;
   }
   ```
   传统做法肯定要操作Dom去修改class属性的值，但是vue直接动态绑定就行了

   ```html
   <div :class="{active: isActive}"></div>
   <button v-on:click="toggleClass">切换类名有无</button>
   ```

   ```js
   toggleClass: function () {
       this.isActive = !this.isActive
   }
   ```

   > 绑定的class里面是一个对象，通过类名后面的布尔值控制类名的有无

   如果有多个类名

   ```html
   <div :class="{active: isActive, error: isError}"></div>
   ```

   另外我们可以通过数组传递数据的方式实现

   ```html
   <div :class="[activeClass, errorClass]"></div>
   <button v-on:click="toggleClassArray">切换类名有无（数组）</button>
   ```

   ```js
   data: {
       activeClass: 'active',
       errorClass: 'error'
   }
   
   toggleClassArray: function () {
       this.errorClass = this.errorClass == '' ? 'error' : ''
   }
   ```

   对象和数组的方法可以结合起来使用

   ```html
   <div :class="[{active: isActive}, errorClass]"></div>
   <button v-on:click="toggleClass">切换类名有无</button>
   ```

   类名数量少的时候直接写在标签里没问题，属性一多就影响阅读了，可以将其定义在数据中，想要对类名进行修改的话直接修改数据就好了

   数组：

   ```html
   <div :class="activeClassArr"></div>
   ```

   ```js
   data: {
       activeClassArr: ['active', 'error']
   }
   ```

   对象：

   ```html
   <div :class="activeClassObj"></div>
   ```

   ```js
   
   data: {
       activeClassObj: {
           active: true,
           error: true
       }
   }
   ```

   如果元素本来就有class了，那么使用`v-bind`绑定的类将会追加到class上而不是覆盖它

   ```html
   <div class="bigSize" :class="activeClassObj">大号文字</div>
   ```

   除了绑定类，还可以绑定style，绑定方法与类的绑定方法类似

   ```html
   <div :style="{border: borderStyle, width: widthStyle}">style</div>
   ```

   ```js
   data: {
       borderStyle: '1px solid green',
       widthStyle: '200px'
   }
   ```

   数组写法可以把样式写为对象，然后传递对象数组

9. `v-if` 和 `v-else` 和 `v-else-if` 和 `v-show`

   很明显，这是用于分支控制元素是否显示的，符合条件的显示，不符合条件的不显示，**只有显示的Dom会被渲染到页面上**，不显示的不会被渲染

   ```html
   <div>
       <div v-if="score>=90">优秀</div>
       <div v-else-if="score<90&&score>=80">良好</div>
       <div v-else-if="score<80&&score>=60">一般</div>
       <div v-else="score<60">较差</div>
       <input v-model="score" type="text" />
   </div>
   ```

   ```js
   data: {
       score: 99
   }
   ```

   Vue 会尽可能高效地渲染元素，通常会**复用已有元素**而不是从头开始渲染，例如，如果你允许用户在不同的登录方式之间切换

   ```html
   <template v-if="loginType === 'username'">
     <label>Username</label>
     <input placeholder="Enter your username">
   </template>
   <template v-else>
     <label>Email</label>
     <input placeholder="Enter your email address">
   </template>
   ```

   那么在上面的代码中切换 loginType 将不会清除用户已经输入的内容。因为两个模板使用了相同的元素，<input> 不会被替换掉——仅仅是替换了它的 placeholder

   这样也不总是符合实际需求，所以 Vue 为你提供了一种方式来表达“这两个元素是完全独立的，不要复用它们”。只需添加一个具有唯一值的 key attribute 即可，现在，每次切换时，输入框都将被重新渲染

   ```html
   <template v-if="loginType === 'username'">
     <label>Username</label>
     <input placeholder="Enter your username" key="username-input">
   </template>
   <template v-else>
     <label>Email</label>
     <input placeholder="Enter your email address" key="email-input">
   </template>
   ```

   `v-if` 也是**惰性的**：如果在初始渲染时条件为假，则什么也不做——直到条件第一次变为真时，才会开始渲染条件块

   而`v-show`同样是控制元素的显示与否的，但是**元素Dom始终会被渲染到页面上**，只是在不显示时是通过设置display值控制的

   ```html
   <div v-show="flag">v-show</div>
   ```

   当flag的值为false时元素不会显示，检查页面元素时发现是下面这样的

   ```html
   <div style="display: none;">v-show</div>
   ```

   > 注意，`v-show` 不支持 `<template>` 元素，也不支持 `v-else`。

   一般如果一个元素需要**经常性地显示与隐藏**，那么使用`v-show`是比较合适的，但是如果只是一次性的显示隐藏，使用`v-if`比较合适，因为控制Dom渲染到页面与否的性能消耗是更大的

10. `v-for`

    循环控制也是必不可少的，`v-for`主要用于循环数组

    ```html
    <div>
        <ul>
            <li v-for="item in fruits">{{item}}</li>
            <li v-for="(item, index) in fruits">{{item + ' -- ' + index}}</li>
            <li v-for="item in myFruits">
                <span>{{item.ename}}</span>
                ---
                <span>{{item.cname}}</span>
            </li>
        </ul>
    </div>
    ```

    ```js
    data: {
        fruits: ['apple', 'orange', 'grape', 'banana'],
        myFruits: [
            { ename: 'apple', cname: '苹果' },
            { ename: 'orange', cname: '橘子' }
        ]
    }
    ```

    可以提供key给vue用于区分不同的元素，vfor是高度复用的，区分不同的元素可以帮助vue提高循环效率，所以提供给key的值应该是唯一的，比如id之类的值，也可以用元素本身或者索引值作为key

    > 不提供也是可以的，但是vue就需要更复杂的计算，循环效率降低了

    ```html
    <li v-for="item in myFruits" :key="item.id">
        <span>{{item.ename}}</span>
        ---
        <span>{{item.cname}}</span>
    </li>
    ```

    那么如何修改数组，让页面上显示的循环出来的数组跟着发生改变呢？

    可以使用数组变更方法改变数组，比如`push()`、`pop()`、`shift()`、`unshift()`、`splice()`、`reverse()`、`sort()`等，Vue 将被侦听的数组的变更方法进行了包裹，所以它们也将会触发视图更新
    
    或者直接替换整个数组，下面的方法不会直接修改原数组，而是会生成一个新的数组，所以可以将新数组赋值给原数组进行替换，比如`concat()`、`slice()`、`filter()`
    
    ```js
    this.listArray = ['a', 'b']
    this.listArray = ['a'].concat(['b'])
    this.listArray = ['a', 'b'].filter(item => item === 'b')
    ```

    > 你可能认为这将导致 Vue 丢弃现有 Dom 并重新渲染整个列表。幸运的是，事实并非如此。Vue 为了使得 Dom 元素得到最大范围的重用而实现了一些智能的启发式方法，所以用一个含有相同元素的数组去替换原来的数组是非常高效的操作
    
    甚至直接通过数组索引更新数组的元素也是可以的（只有vue3版本可以，vue的内部原理变化，从defineProperty变为了Proxy）
    
    ```js
    this.listArray[1] = 'hello'
    ```
    
    对于vue2，则需要set
    
    ```js
    vm.$set(vm.items, indexOfItem, newValue)
    ```
    
    除了遍历数组之外，`v-for`还可以遍历对象

    ```html
    <div v-for="(value, key, index) in star" :key="index">
        {{value + '--' + key + '--' + index}}
    </div>
    ```
    
    ```js
    data: {
        star: {
            name: '刘德华',
            age: 18,
            gender: '男'
        }
    }
    ```
    
    对对象的修改也可以直接赋值属性（vue3）
    
    ```js
    this.star.career = 'star'
    ```
    
    `v-if`可以与`v-for`结合使用
    
    ```html
    <li v-if="index!==3" v-for="(item, index) in fruits">
        {{item + ' -- ' + index}}
    </li>
    ```
    >但是**非常不推荐**同时使用 v-if 和 v-for，**永远不要把 `v-if` 和 `v-for` 同时用在同一个元素上**
    >
    >因为当 Vue 处理指令时，`v-for` 比 `v-if` 具有更高的优先级
    >
    >```html
    ><ul>
    >  <li
    >    v-for="user in users"
    >    v-if="user.isActive"
    >    :key="user.id"
    >  >
    >    {{ user.name }}
    >  </li>
    ></ul>
    >```
    >
    >会经过如下运算
    >
    >```js
    >this.users.map(function (user) {
    >  if (user.isActive) {
    >    return user.name
    >  }
    >})
    >```
    >
    >


##### 4.2 表单操作

对于表单的操作需要注意是通过**设定value值**来操作的，先禁用提交按钮的默认提交行为，然后通过`v-model`双向绑定表单控件

1. 输入框

   ```html
   <input type="text" v-model="uname" />
   ```

   ```js
   data: {
       uname: '张三'
   }
   ```

2. 单选和多选按钮

   给单选按钮设定value值，然后双向绑定自定义数据gender的值为value值其中之一，通过控制gender的值来确定选中了谁，而不是通过设置checked属性，最后提交函数中拿到的值也是value的值`this.gender`

   ```html
   <input type="radio" id="male" value="1" v-model="gender" />
   <label for="male">男</label>
   <input type="radio" id="female" value="2" v-model="gender" />
   <label for="female">女</label>
   ```

   ```js
   data: {
       gender: 2 // 默认value值为2，则默认选中的是女
   }
   ```

   对于多选，value值可以设定为数组

   ```html
   <input type="checkbox" id="ball" value="1" v-model="hobby" />
   <label for="ball">篮球</label>
   <input type="checkbox" id="sing" value="2" v-model="hobby" />
   <label for="sing">唱歌</label>
   <input type="checkbox" id="code" value="3" v-model="hobby" />
   <label for="code">写代码</label>
   ```

   ```js
   data: {
       hobby: ['2', '3']  // 默认为2和3，则默认选中唱歌和写代码
   }
   
   handle: function () {
       console.log(this.hobby.toString())
   }
   ```

3. 下拉选择框

   下拉选择框与选择按钮同理

   ```html
   <select v-model="occupation" multiple>
       <option value="0">请选择职业...</option>
       <option value="1">教师</option>
       <option value="2">软件工程师</option>
       <option value="3">律师</option>
   </select>
   ```

   ```js
   data: {
       occupation: ['2', '3']
   }
   ```

4. 多行文本域

   和单行输入文本同理

   ```html
   <textarea v-model="desc"></textarea>
   ```
   

**表单域修饰符：**与事件修饰符一样，表单域也提供了修饰符

1. `.number`

   表单域默认的值是字符串，使用这个修饰符可以将默认的字符串转为数字类型，输入框的type值可以是number也可以不是

   ```html
   <input type="text" v-model.number="age" />
   ```

   ```js
   handle: function () {
       console.log(this.age + 13) // 输入6，打印19
   }
   ```

2. `.trim`

   去除输入的前后空格

   ```html
   <input type="text" v-model.trim="info" />
   ```

   ```js
   handle: function () {
       console.log(this.info.length)
   }
   ```

3. `.lazy`

   将input事件转为change事件，`v-model`的默认事件是input事件，每次输入都会触发事件，而change事件则是在失去焦点的时候触发，这个常用在用户输完用户名时触发验证时使用

   ```html
   <input type="text" v-model.lazy="msg" />
   <div>{{msg}}</div>
   ```

##### 4.3 自定义指令

当内置指令不满足需求时，可以自定义指令，比如自定义一个获取焦点的指令

```html
<input type="text" v-focus />
```

```js
Vue.directive('focus', {
    inserted: function (el) {
        // el：指令所绑定的元素
        el.focus()
    }
})
```

如果自定义指令要携带参数，可以通过第二个参数带入

```html
<input type="text" v-color="msg" />
```

```js
Vue.directive('color', {
    bind: function (el, binding) {
        // 根据指令的参数设置背景色
        // console.log(binding.value) // 就是msg的值
        el.style.backgroundColor = binding.value.color
    }
})

data: {
    msg: {
        color: 'blue'
    }
}
```

如果想定义局部指令，需要在vue实例的参数中定义，局部指令只能在本组件（也就是vue实例）中使用，而前面定义的是全局指令，可在各个组件中使用

```html
<input type="text" v-focus v-color="msg" />
```

```js
var vm = new Vue({
    el: '#app',
    data: {
        msg: {
            color: 'red'
        }
    },
    methods: {
        handle: function () {}
    },
    directives: {
        color: {
            bind: function (el, binding) {
                el.style.backgroundColor = binding.value.color
            }
        },
        focus: {
            inserted: function (el) {
                el.focus()
            }
        }
    }
})
```

##### 4.4 计算属性

模板内的表达式非常便利，但是设计它们的初衷是用于简单运算的。在模板中放入太多的逻辑会让模板过重且难以维护，对于任何复杂逻辑，你都应当使用**计算属性**

比如反转字符串

```html
<div>{{msg.split('').reverse().join('')}}</div>
```

这个逻辑就较为复杂，可以将其写到计算属性里面

```html
<div>{{reversedMessage}}</div>
```

```js
var vm = new Vue({
    el: '#app',
    data: {
        msg: 'Hello'
    },
    computed: {
        // 计算属性的 getter
        reversedMessage: function () {
            return this.msg.split('').reverse().join('')
        }
    }
})
```

这里我们声明了一个计算属性 `reversedMessage`。我们提供的函数将用作 property `vm.reversedMessage` 的 getter 函数，打开控制台修改message的值，会发现`vm.reversedMessage` 的值始终取决于 `vm.message` 的值，最妙的是我们已经以声明的方式创建了这种依赖关系：计算属性的 getter 函数是没有副作用 (side effect) 的，这使它更易于测试和理解

也许你会发现同样是写函数，这和在methods中定义的函数有什么区别？其实区别在于**计算属性是基于它们的响应式依赖进行缓存的**，而方法是没有缓存的，只在相关响应式依赖发生改变时它们才会重新求值。这就意味着只要 `message` 还没有发生改变，多次访问 `reversedMessage` 计算属性会立即返回之前的计算结果，而不必再次执行函数

这也同样意味着下面的计算属性将不再更新，因为 `Date.now()` 不是响应式依赖

```js
computed: {
  now: function () {
    return Date.now()
  }
}
```

下面连续调用两次计算属性，但是只打印了一次结果，证明vue将结果进行了缓存而没有去计算两次，这样提高了性能

```html
<div>{{reverseString}}</div>
<div>{{reverseString}}</div>
```

```js
computed: {
    reverseString: function () {
        console.log('computed')
        return this.msg.split('').reverse().join('')
    }
}
```

如果用函数实现一样的效果则需要这样写，控制台会发现打印了两次结果，说明每次调用都会去计算

```html
<div>{{reverseMessage()}}</div>
<div>{{reverseMessage()}}</div>
```

```js
methods: {
    reverseMessage: function () {
        console.log('methods')
        return this.msg.split('').reverse().join('')
    }
}
```
计算属性默认只有 getter，不过在需要时你也可以提供一个 setter

```js
computed: {
  fullName: {
    // getter
    get: function () {
      return this.firstName + ' ' + this.lastName
    },
    // setter
    set: function (newValue) {
      var names = newValue.split(' ')
      this.firstName = names[0]
      this.lastName = names[names.length - 1]
    }
  }
}
```

现在再运行 `vm.fullName = 'John Doe'` 时，setter 会被调用，`vm.firstName` 和 `vm.lastName` 也会相应地被更新


##### 4.5 侦听属性

侦听器就是用来侦听**数据的变化**的，一旦数据发生改变就会通知侦听器所绑定的方法来响应数据的变化，当需要在数据变化时执行异步或开销较大的操作时，这个方式是最有用的

```html
<div id="app">
    <div>
        <span>名：</span>
        <span>
            <input type="text" v-model="firstName" />
        </span>
    </div>
    <div>
        <span>姓：</span>
        <span>
            <input type="text" v-model="lastName" />
        </span>
    </div>
    <div>{{fullName}}</div>
</div>
```

```js
var vm = new Vue({
    el: '#app',
    data: {
        firstName: 'Jim',
        lastName: 'Green',
        fullName: 'Jim Green'
    },
    // 侦听 firstName 和 lastName 这两个数据，一旦发生变化就执行对应的函数
    watch: {
        firstName: function (val) {
            this.fullName = val + ' ' + this.lastName
        },
        lastName: function (val) {
            this.fullName = this.firstName + ' ' + val
        }
    }
})
```

一旦监听的数据发生变化就会通知所对应的函数执行对应的函数操作

在这个案例中计算属性也能实现类似效果，但异步任务的处理还是侦听器更好，比如验证用户名的异步任务

```html
<div id="app">
    <div>
        <span>用户名：</span>
        <span>
            <input type="text" v-model.lazy="uname" />
        </span>
        <span>{{tip}}</span>
    </div>
</div>
```

```js
methods: {
    checkName: function (uname) {
        // 调用接口，但是可以使用定时任务的方式模拟接口调用
        var that = this
        setTimeout(function () {
            // 模拟接口调用
            if (uname == 'admin') {
                that.tip = '用户名已经存在，请更换一个'
            } else {
                that.tip = '用户名可以使用'
            }
        }, 2000)
    }
},
watch: {
    uname: function (val) {
        // 调用后台接口验证用户名的合法性
        this.checkName(val)
        // 修改提示信息
        this.tip = '正在验证...'
    }
}
```

##### 4.6 过滤器

如同生活中的过滤器，vue的过滤器是对数据进行过滤的，或者说将数据处理成想要的样子

过滤器使用管道符来处理，支持级联处理

```html
<div id="app">
    <input type="text" v-model="msg" />
    <div>{{msg | upper}}</div>
    <div>{{msg | upper | lower}}</div>
    <div :abc="msg | upper">测试数据</div>
</div>
```

```js
// 定义过滤器，val是要处理的数据
Vue.filter('upper', function (val) {
    return val.charAt(0).toUpperCase() + val.slice(1)
})
Vue.filter('lower', function (val) {
    return val.charAt(0).toLowerCase() + val.slice(1)
})
```

和自定义指令一样可以定义局部过滤器，只在当前组件生效

```js
var vm = new Vue({
    el: '#app',
    data: {
        msg: ''
    },
    filters: {
        upper: function (val) {
            return val.charAt(0).toUpperCase() + val.slice(1)
        }
    }
})
```

同样可以传递参数，在传递的数据之后添加参数传递即可

```js
Vue.filter('upper', function (val, arg1, arg2) {
    return arg1 + arg2
})
```

##### 4.7 生命周期

生命周期就是指一个事物从诞生到消亡的过程，对于vue实例来说也是一样的，大致分为三个阶段

每个 Vue 实例在被创建时都要经过一系列的初始化过程——例如，需要设置数据监听、编译模板、将实例挂载到 Dom 并在数据变化时更新 Dom 等。同时在这个过程中也会运行一些叫做**生命周期钩子**的函数，生命周期钩子的 `this` 上下文指向调用它的 Vue 实例

> 不要在选项 property 或回调上使用[箭头函数](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Functions/Arrow_functions)
>
> 比如 `created: () => console.log(this.a)` 或 `vm.$watch('a', newValue => this.myMethod())`
>
> 因为箭头函数并没有 `this`，`this` 会作为变量一直向上级词法作用域查找，直至找到为止
>
> 经常导致 `Uncaught TypeError: Cannot read property of undefined` 或 `Uncaught TypeError: this.myMethod is not a function` 之类的错误

1. 挂载

   这个阶段主要是初始化相关属性，我们需要重点关注mounted这个函数，因为一旦mounted函数被触发意味着vue实例的**初始化工作已完成**，页面中的**模板内容已存在**，这时就可以向模板中填充数据了，我们从后台请求数据后向模板里面填充数据时首先得保证模板已存在

   ```js
   // vue实例生成之前自动执行
   beforeCreate: function () {
       console.log('beforeCreate')
   }
   
   // vue实例生成之后自动执行
   created: function () {
       console.log('created')
   }
   
   // 组件内容渲染到页面之前自动执行
   beforeMount: function () {
       console.log('beforeMount')
   }
   
   // 组件内容被渲染到页面之后自动执行
   mounted: function () {
       console.log('mounted')
   }
   ```

2. 更新

   元素或组件的变更操作，例如改变data中的值等等就会触发更新的操作

   ```js
   // 数据发生变化时就会自动执行这个函数
   beforeUpdate: function () {
       console.log('beforeUpdate')
   }
   
   //数据发生变化且页面重新渲染完成时会自动执行这个函数
   updated: function () {
       console.log('updated')
   }
   ```

3. 销毁

   销毁相关属性，如果确实不需要这个vue实例了可以销毁它，释放一些资源

   ```js
   beforeDestroy: function () {
       console.log('beforeDestroy')
   }
   
   destroyed: function () {
       console.log('destroyed')
   }
   
   // vue3 调用 app.unmount()
   // 实例卸载时自动执行
   beforeUnmount: function () {
       console.log('beforeUnmount')
   }
   // 实例卸载且Dom完全销毁后自动执行
   unmounted: function () {
       console.log('unmounted')
   }
   ```

##### 4.8 变异方法和替换数组

- 变异方法

  对数组的操作导致数组发生变化，vue会监听这种变化，把这种变化响应到页面上，是响应式的变化，原数组数据发生改变的数组方法都是变异方法，比如`shift()`、`unshift()`、`pop()`、`push()`、`splice()`、`sort()`、`reverse()`等等

- 替换数组

  原数组不发生变化，而是**产生一个新的数组**，也叫做非变异方法，比如`filter()`、`concat()`、`slice()`等等，也许你会觉得整个数组的替换会导致vue丢失Dom元素重新渲染整个列表，但是vue用一些**黑科技**实现了高效操作，但是要注意由于原数组没有发生变化，所以直接调用这些方法并不会起作用，需要将调用这些方法产生的新数组赋值给原数组使原数组发生变化从而实现数组的替换，进而产生响应式的效果

  ```js
  methods: {
      change: function () {
          this.list = this.list.slice(0, 2)
      }
  }
  ```

  > 如果不使用这些方法而直接通过数组索引的方式去修改数组的元素，将不会产生响应式的效果
  >
  > ```js
  > this.list[1] = 'grape'
  > ```
  >
  > vue专门给这种情况提供了api解决，这样去修改指定索引的数组元素就是响应式的了
  >
  > ```js
  > Vue.set(this.list, 1, 'grape') // 等价于 vm.$set(this.list, 1, 'grape')
  > ```
  > 除了处理数组，这个api还可以处理对象
  >
  > **直接给对象添加属性，不会响应式**（直接修改现有的属性是响应式的）
  >
  > ```js
  > vm.info.gender = 'female'
  > ```
  >
  > 使用api，数据就会响应式地响应到页面上
  >
  > ```js
  > vm.$set(vm.info, 'gender', 'female')
  > ```

#### 5 组件

前面已经可以实现日常功能开发了，但是还不够完美，组件化开发可以让开发变得更容易维护管理，类似于手机也是由各种组件组成的，比如电池、屏幕、cpu等等，组件可更换，功能也更单一，便于合作，每个人分别单独开发，最后统一组装，我们总是希望可以重用自己的代码，因此组件化开发也被web标准化组织提上日程，现在已有web component组件化规范，但是浏览器支持并不好，vue部分实现了该规范

在 Vue 里，一个组件本质上是一个拥有**预定义选项**的一个 Vue 实例

##### 5.1 组件注册

```js
Vue.component('button-counter', {
    data: () => {
        return {
            count: 0
        }
    },
    template: '<button @click="count++">点击了{{count}}次</button>'
})

let vm = new Vue({
    el: '#app'
})
```

使用组件

```html
<div id="app">
    <button-counter></button-counter>
</div>
```

组件内也可以定义方法

```js
Vue.component('button-counter', {
    data: () => {
        return {
            count: 0
        }
    },
    methods: {
        handle: function () {
            this.count += 2
        }
    },
    template: '<button @click="handle">点击了{{count}}次</button>'
})
```

组件一旦定义好，可以多处**复用**，注意组件之间的**数据是互相独立的**，点击各个组件，它们显示的数据变化是独立的

```html
<div id="app">
    <button-counter></button-counter>
    <button-counter></button-counter>
</div>
```

全局组件一旦定义好，可以在子组件中使用，也可以在根组件上使用，即便你不用也是会挂载到vue实例上去的，所以性能较差，但是使用方便

那么如何定义局部组件呢，非常简单，只需要定义好局部组件的选项对象，然后配置给vue实例即可，需要注意局部组件只能在挂载的父组件中使用，由于不使用局部组件时它本身就是一个变量，不会进行挂载，所以性能较高，使用稍微复杂

```html
<div id="app">
    <part-component1></part-component1>
    <part-component2></part-component2>
    <part-component3></part-component3>
</div>
```

```js
const PartComponent1 = {
    data: function () {
        return {
            msg: 'PartComponent1'
        }
    },
    template: `
      <div>{{msg}}</div>
     `
}
const PartComponent2 = {
    data: function () {
        return {
            msg: 'PartComponent2'
        }
    },
    template: `
      <div>{{msg}}</div>
      `
}
const PartComponent3 = {
    data: function () {
        return {
            msg: 'PartComponent3'
        }
    },
    template: `
       <div>{{msg}}</div>
      `
}
let vm = new Vue({
    el: '#app',
    components: {
        'part-component1': PartComponent1,
        'part-component2': PartComponent2,
        PartComponent3  // 键值名字一样可以简写
    }
})
```


> 1. 组件中的data属性**必须是一个函数**，不能是对象，并且函数应该返回值，因为**使用函数会产生局部作用域**，使得每个组件拥有自己单独的数据
>
> 2. 组件的模板**必须只有一个根元素**，不允许有兄弟根元素
>
> 3. 组件的模板可以是模板字符串，但是模板字符串是ES6提供的，需要浏览器兼容，**可以使用前端工程化解决**
>
>    使用字符串定义模板的问题是字符串不能换行，模板全部写到一行的可读性是很差的，而模板字符串就支持换行了，还支持变量替换，很好用
>
>    ```js
>    Vue.component('button-counter', {
>        data: () => {
>            return {
>                count: 0
>            }
>        },
>        methods: {
>            handle: function () {
>                this.count += 2
>            }
>        },
>        template: `
>            <div>
>                <button @click="handle">点击了{{count}}次</button>
>                <button>test</button>
>            </div>
>        `
>    })
>    ```
>
> 4. 组件名称可以是短横线连接，也可以是驼峰命名，首字母全部大写
>
>    但是一旦使用驼峰式命名，这个组件**在不改变命名的情况下**只能用到别的组件模板里，要用到html页面里时，需要改变驼峰式命名为短横线才会生效，如下所示
>
>    ```html
>    <div id="app">
>        <button-counter></button-counter>
>        <button-counter></button-counter>
>        <hello-world></hello-world>
>    </div>
>    ```
>
>    ```js
>    Vue.component('button-counter', {
>        data: () => {
>            return {
>                count: 0
>            }
>        },
>        methods: {
>            handle: function () {
>                this.count += 2
>            }
>        },
>        template: `
>           <div>
>              <button @click="handle">点击了{{count}}次</button>
>              <button>test</button>
>              <HelloWorld></HelloWorld>
>          </div>
>          `
>    })
>    Vue.component('HelloWorld', {
>        data: () => {
>            return {
>                msg: 'HelloWorld'
>            }
>        },
>        template: `
>          <div>{{msg}}</div>
>          `
>    })
>    ```
>

##### 5.2 组件通信

###### 5.2.1 父传子

在子组件中使用`props`属性**以数组的形式接收**接收父组件传递过来的数据，父组件通过在子组件上自定义属性，通过自定义属性进行传值

子组件接收到数据后就可以像使用data中的数据一样使用接收到的数据了

```html
<menu-item title="来自父组件的数据"></menu-item>
```

```js
Vue.component('menu-item', {
    props: ['title'],
    data: function () {
        return {
            msg: '子组件的数据'
        }
    },
    template: `
       <div>{{msg + '---' + title}}</div>
       `
})

var vm = new Vue({
    el: '#app',
    data: {
        pmsg: '父组件的数据'
    }
})
```

> 注意这里没有使用父组件data中的数据进行传递，而是直接传的字符串，如果要传父组件data中的数据，需要对子组件的自定义属性进行**动态绑定**
>
> 如果传递的数据不止一个，那么依次定义子组件的自定义属性，用子组件的props属性以数组形式依次接收即可

```html
<menu-item :title="pmsg"></menu-item>
```

```html
<menu-item :title="pmsg" data-title="data-title"></menu-item>
```

```js
Vue.component('menu-item', {
    props: ['title', 'dataTitle'],
    data: function () {
        return {
            msg: '子组件的数据'
        }
    },
    template: `
      <div>{{msg + '---' + title + '---' + dataTitle}}</div>
      `
})
var vm = new Vue({
    el: '#app',
    data: {
        pmsg: '父组件的数据'
    }
})
```

> 在上面的例子中也发现了，在html中自定义属性的名字需要使用短横线连接来定义，但是在子组件中使用props参数接收数据时需要将短横线转为驼峰式命名，否则会报错接收不了

```html
<menu-item :title="pmsg" :data-title="pmsg"></menu-item>
```

```js
Vue.component('menu-item', {
    props: ['title', 'dataTitle'],
    data: function () {
        return {
            msg: '子组件的数据'
        }
    },
    template: `
       <div>{{msg + '---' + title + '---' + dataTitle}}</div>
       `
    // template: '<div>{{msg + "---" + title + "---" + dataTitle}}</div>'
})
```

从父组件向子组件传递不同数据类型的方法

1. string

   字符串传递就是上面的例子

2. number

   可以直接传数字，但是子组件接收到的数据类型是字符串类型的，如果想传递数字类型，需要**动态绑定**

   ```html
   <menu-item :title="pmsg" :data-title="pmsg" tnum="12"></menu-item>
   ```

   ```js
   Vue.component('menu-item', {
       props: ['title', 'dataTitle', 'tnum'],
       data: function () {
           return {
               msg: '子组件的数据'
           }
       },
       template: `
          <div>
             <div>{{msg + '---' + title + '---' + dataTitle}}</div>
             <div>{{12 + tnum}}</div>   // 1212
          </div>
          `
   })
   ```

   如果改为动态绑定，打印结果就是24

   ```html
   <menu-item :title="pmsg" :data-title="pmsg" :tnum="12"></menu-item>
   ```

3. boolean

   布尔类型与数字类型的传递一致，需要**动态绑定**

4. array

   数组类型直接传递数组名即可，在子组件中正常接收使用，需要**动态绑定**

   ```html
   <menu-item
      :title="pmsg"
      :data-title="pmsg"
      :tnum="12"
      :parr="parr"
      ></menu-item>
   ```

   ```js
   Vue.component('menu-item', {
       props: ['title', 'dataTitle', 'tnum', 'parr'],
       data: function () {
           return {
               msg: '子组件的数据'
           }
       },
       template: `
          <div>
              <div>{{msg + '---' + title + '---' + dataTitle}}</div>
              <div>{{12 + tnum}}</div>
              <ul>
                  <li v-for='(item, index) in parr' :key='index'>{{item}}</li>
              </ul>
          </div>
          `
       // template: '<div>{{msg + "---" + title + "---" + dataTitle}}</div>'
   })
   var vm = new Vue({
       el: '#app',
       data: {
           pmsg: '父组件的数据',
           parr: ['apple', true, 12, null, 'grape']
       }
   })
   ```

5. object

   对象类型和数组传递方式一致，需要**动态绑定**

总结：除了**直接传递字符串**不需要动态绑定，其余的数字、布尔、数组、对象等数据类型均需要进行动态绑定传递



prop验证

我们可以为组件的 prop 指定验证要求，如果有一个需求没有被满足，则 Vue 会在浏览器控制台中警告你。这在开发一个会被别人用到的组件时尤其有帮助，当 prop 验证失败的时候，(开发环境构建版本的) Vue 将会产生一个控制台的警告

```js
Vue.component('my-component', {
  props: {
    // 基础的类型检查 (`null` 和 `undefined` 会通过任何类型验证)
    propA: Number,
    // 多个可能的类型
    propB: [String, Number],
    // 必填的字符串
    propC: {
      type: String,
      required: true
    },
    // 带有默认值的数字
    propD: {
      type: Number,
      default: 100
    },
    // 带有默认值的对象
    propE: {
      type: Object,
      // 对象或数组默认值必须从一个工厂函数获取
      default: function () {
        return { message: 'hello' }
      }
    },
    // 自定义验证函数
    propF: {
      validator: function (value) {
        // 这个值必须匹配下列字符串中的一个
        return ['success', 'warning', 'danger'].indexOf(value) !== -1
      }
    }
  }
})
```



传入一个对象的所有 property

如果你想要将一个对象的所有 property 都作为 prop 传入，你可以使用不带参数的 `v-bind` (取代 `v-bind:prop-name`)。例如，对于一个给定的对象 `post`：

```js
post: {
  id: 1,
  title: 'My Journey with Vue'
}
```

```html
<blog-post v-bind="post"></blog-post>
<!-- 等价于 -->
<blog-post
  v-bind:id="post.id"
  v-bind:title="post.title"
></blog-post>
```

###### 5.2.4 子通知父

首先我们要理解 prop 接收数据是设计为**单向数据流**的，父级 prop 的更新会向下流动到子组件中，但是反过来则不行。这样会防止从子组件**意外变更父级组件的状态**，从而导致你的应用的**数据流向难以理解**，并且破坏了组件间的数据独立性

因此：

1. 如果在子组件中直接修改父组件传递过来的值，比如修改数字，那么修改无效，且会触发警告

2. 如果修改的是数组、对象等引用类型的数据，则会影响父组件中的数据

正确的做法是**用 prop 来传递一个初始值，然后子组件定义一个本地的 data property 并将这个 prop 用作其初始值**

```js
props: ['initialCounter'],
data: function () {
  return {
    counter: this.initialCounter  //子组件修改自己的数据就不会有问题了
  }
}
```

另一种情况是需要对传入的数据进行转换处理，可以定义计算属性

```js
props: ['size'],
computed: {
  normalizedSize: function () {
    return this.size.trim().toLowerCase()
  }
}
```



但是如果我们就是想让父组件中的数据发生改变呢，而不是通过上诉方式间接地接收然后修改子组件中的数据，这个时候我们可以通知父组件去修改，没错，父组件数据的修改只能是父组件去完成

那么如何通知父组件呢，vue给我们提供了一个函数 `$emit()`

1. 首先我们在用到的子组件上定义一个**自定义事件**，这个**自定义事件**绑定一个父组件中的方法用于处理父组件中的数据修改

   ```html
   <div id="app">
      <div :style="{fontSize: fontSize + 'px'}">{{pmsg}}</div>
      <menu-item @enlarge-text="handleEnlargeText"></menu-item>
   </div>
   ```

   ```js
   var vm = new Vue({
       el: '#app',
       data: {
           pmsg: '父组件的数据',
           fontSize: 10
       },
       methods: {
           handleEnlargeText: function () {
               this.fontSize += 5
           }
       }
   }) 
   ```

2. 然后在子组件中通过某种方法触发 `$emit()` 去通知父组件中在子组件上定义的自定义事件，从而触发父组件中的函数去执行对应操作

   > 触发的自定义事件在html中一般用短横线隔开，在触发函数 `$emit()` 中可以写驼峰命名也可以写短横线，都可以成功触发（vue3）

   ```js
   Vue.component('menu-item', {
       methods: {
           handleClick() {
               this.$emit("enlargeText")
           }
       },
       template: `<button @click='handleClick'>扩大父组件字体大小</button>`
   })
   ```

3. 如果子组件不仅仅只是通知父组件修改其数据，而且希望向父组件传递自己的数据的话，则可以通过 `$emit()` 的后面的参数传递，在父组件中直接通过 `$event` 接收，或者在处理函数中通过函数参数依次接收

   ```html
   <div id="app">
      <div :style="{fontSize: fontSize + 'px'}">{{pmsg}}</div>
      <menu-item @enlarge-text="handleEnlargeText"></menu-item>
   </div>
   ```

   ```js
   var vm = new Vue({
       el: '#app',
       data: {
           pmsg: '父组件的数据',
           fontSize: 10
       },
       methods: {
           handleEnlargeText: function (val1, val2) {
               this.fontSize += val2
           }
       }
   })
   
   Vue.component('menu-item', {
       methods: {
           handleClick() {
               this.$emit("enlargeText", 2, 3)
           }
       },
       template: `<button @click='handleClick'>扩大父组件字体大小</button>`
   })
   ```

###### 5.2.5 兄弟组件

非父子组件之间的数据交互比如兄弟组件用props方式的传值就不太方便了，它们之间没有vue实例做监听，vue提供了单独的**事件处理中心**来管理兄弟组件间的通信，兄弟组件间必须通过事件处理中心才能进行数据的交互

1. 定义事件处理中心

   事件处理中心其实就是一个**vue实例**

   ```js
   var eventHub = new Vue()
   ```

2. 监听和触发事件

   如果两个兄弟组件要传递数据就需要通过事件处理中心来监听和触发事件，所以要在两个兄弟组件内使用事件处理中心来监听和触发事件

   ```js
   Vue.component('test-tom', {
       data: function () {
           return {
               num: 0
           }
       },
       template: `
          <div>
              <div>Tom: {{num}}</div>
              <button @click="handle">Tom</button>
          </div>
          `,
       methods: {
           // 点击按钮时触发了处理函数handle，在handle中触发兄弟组件的事件，并且向兄弟组件事件传递了数据 2
           handle: function () {
               eventHub.$emit('jerry-event', 2)
           }
       },
       // 在mounted生命周期内监听自己的事件，保证别的组件来触发它的时候能够执行
       // 在mounted生命周期阶段页面中已有模板内容，可确保监听成功
       mounted: function () {
           eventHub.$on('tom-event', (val) => {
               this.num += val
           })
       }
   })
   
   Vue.component('test-jerry', {
       data: function () {
           return {
               num: 0
           }
       },
       template: `
           <div>
               <div>Jerry: {{num}}</div>
               <button @click="handle">Jerry</button>
           </div>
           `,
       methods: {
           handle: function () {
               eventHub.$emit('tom-event', 1)
           }
       },
       mounted: function () {
           eventHub.$on('jerry-event', (val) => {
               this.num += val
           })
       }
   })
   ```

   定义好这两个兄弟组件之后，在页面中点击一个组件调用其处理函数，在处理函数内触发兄弟组件的事件，由于事件处理中心在mounted阶段监听着兄弟组件的事件，因此兄弟组件的事件被触发执行，兄弟组件的数据增加了组件传递过去的数值的大小

   ```html
   <div id="app">
       <test-tom></test-tom>
       <test-jerry></test-jerry>
   </div>
   ```

   总结：

   `eventHub.$emit()`：触发**别人的事件**

   `eventHub.$on()`：监听**自己的事件**

3. 销毁事件

   如果不想继续使用这些自定义事件了，可以在事件处理中心中将其销毁，方法是调用 `$off()`

   ```js
   methods: {
       handle: function() {
           eventHub.$off('tom-event')
           eventHub.$off('jerry-event')
       }
   }
   ```

###### 5.2.6 组件插槽

组件插槽的作用是父组件向子组件**传递内容**而不是传递数据，这个内容可以是普通文本，也可以是标签（Dom标签或者组件标签）

首先在子组件的模板中加上 `<slot></slot>` 标签

```js
Vue.component('comp-slot', {
    template: `
       <div>
           <strong>ERROR:</strong>
           <slot></slot>
       </div>
       `
})
```

然后在父组件中通过直接在子组件标签中间写内容的方式将内容传递给子组件的slot插槽，内容会将slot替换掉

所以最终在页面上会显示：**ERROR:** BUG

```html
<comp-slot>BUG</comp-slot>
```

如果在slot标签中有定义默认内容，那么父组件没有传递内容给插槽时，插槽会显示默认的内容：**ERROR:** default content

```js
Vue.component('comp-slot', {
  template: `
    <div>
      <strong>ERROR:</strong>
      <slot>default content</slot>
    </div>
  `
})
```

```html
<comp-slot></comp-slot>
```



有时不止一个 slot，所以可以给 slot 添加 name 属性通过指定不同的值来区分不同的 slot，这种插槽叫做**具名插槽**

父组件在传递内容时，可以指定插槽的名称向指定的插槽传递内容，没有指定名称的就传给没有name属性的插槽

```js
Vue.component('comp-slot', {
    template: `
        <div>
            <strong>ERROR:</strong>
            <slot>default content</slot>
            <slot name="tom"></slot>
            <slot name="jerry"></slot>
        </div>
        `
})
```

```html
<comp-slot>
    <p slot="tom">Tom</p>
    <p>No name slot</p>
    <p slot="jerry">Jerry</p>
</comp-slot>
```

如果传递的内容不止一个标签，可以使用`<template></template>`标签指定插槽名称，然后在里面书写多个标签

```html
<comp-slot>
    <p slot="tom">Tom</p>
    <p>No name slot</p>
    <p slot="jerry">Jerry</p>
    <template slot="tom">
        <div>
            <p>template</p>
            <p>template</p>
            <p>template</p>
        </div>
    </template>
</comp-slot>
```

当父组件传递给子组件的内容里面有子组件的数据时，需要对子组件内容进行加工处理时，可以使用**作用域插槽**，因为父组件是不能修改子组件数据的

1. 首先在子组件中的slot标签中利用动态绑定**自定义属性**将想要处理的子组件的数据进行绑定，抛给父组件

   ```js
   Vue.component('comp-slot', {
       props: ['fruitList'],
       template: `
         <div>
           <ul>
             <li v-for="item in fruitList" :key="item.id">
               <slot :info="item">{{item.name}}</slot>
             </li>
           </ul>
         </div>
       `
   })
   
   var vm = new Vue({
       el: '#app',
       data: {
           fruitList: [
               {
                   id: 1,
                   name: 'apple'
               },
               {
                   id: 2,
                   name: 'grape'
               },
               {
                   id: 3,
                   name: 'orange'
               },
               {
                   id: 4,
                   name: 'peach'
               }
           ]
       }
   })
   ```

2. 然后在父组件中的子组件标签中的template标签上添加`slot-scope`属性来获取绑定的内容，属性值的名称可自定义，处理获得的内容就可以了，`info`是前面的**自定义属性**，相当于`item`的别名

   `slotProps`是属性值自定义名称，代表了获取到的子组件的内容，里面有传递过来的`info（也就是item）`
   
   ```html
   <div id="app">
       <comp-slot :fruit-list="fruitList">
           <template slot-scope="slotProps">
               <strong v-if="slotProps.info.id==2" class="current">{{slotProps.info.name}}</strong>
               <span v-else>{{slotProps.info.name}}</span>
           </template>
       </comp-slot>
   </div>
   ```
>在 2.6.0 中，我们为具名插槽和作用域插槽引入了一个新的统一的语法 (即 v-slot 指令)。它取代了 slot 和 slot-scope 这两个目前已被废弃但未被移除且仍在文档中的 attribute。

在向具名插槽提供内容的时候，我们可以在一个 `<template>` 元素上使用 `v-slot` 指令，并以 `v-slot` 的参数的形式提供其名称

```html
<base-layout>
  <template v-slot:header>
    <h1>Here might be a page title</h1>
  </template>

  <p>A paragraph for the main content.</p>
  <p>And another one.</p>

  <template v-slot:footer>
    <p>Here's some contact info</p>
  </template>
</base-layout>
```

```html
<div class="container">
  <header>
    <slot name="header"></slot>
  </header>
  <main>
    <slot></slot>
  </main>
  <footer>
    <slot name="footer"></slot>
  </footer>
</div>
```

如果你希望更明确一些，仍然可以在一个 `<template>` 中包裹默认插槽的内容

```html
<template v-slot:default>
    <p>A paragraph for the main content.</p>
    <p>And another one.</p>
</template>
```

而对于作用域插槽，与之前版本也是大同小异的

```js
const app = Vue.createApp({
  data() {
    return {
      count: 123
    }
  },
  template: `
    <div>
      <list v-slot="slotProps">
        <span>{{slotProps.item}}</span>
      </list>
    </div>
  `
})

app.component('list', {
  data() {
    return {
      list: [1, 2, 3]
    }
  },
  template: `
    <div>
      <slot v-for="item in list" :item="item"></slot>
    </div>
  `
})

app.mount('#root')
```

其实这里可以利用ES6的解构赋值简写，因为 `slotProps` 接收到的是子组件传递给父组件所有的内容，所以可以利用解构赋值写成

```js
template: `
  <div>
    <list v-slot="{item}">
      <span>{{item}}</span>
    </list>
  </div>
`
```

##### 5.3 动态组件
如果我们希望动态地切换组件，自己去实现的话，需要靠数据配合 `v-show` 等去判断，但其实 vue 已经有了内置的功能了

```js
const app = Vue.createApp({
  data() {
    return {
      curentItem: 'input-item'
    }
  },
  methods: {
    handleClick() {
      this.curentItem === 'input-item'
        ? (this.curentItem = 'common-item')
        : (this.curentItem = 'input-item')
    }
  },
  template: `
    <div>
      <input-item v-show="curentItem === 'input-item'"></input-item>
      <common-item v-show="curentItem === 'common-item'"></common-item>
      <button @click="handleClick">切换</button>
    </div>
  `
})
```

可以写成

```js
template: `
  <div>
    <component :is="curentItem"></component>
    <button @click="handleClick">切换</button>
  </div>
`
```

但是如果组件是input之类的输入内容后再切换会导致输入的内容丢失，这时可以利用缓存标签 `<keep-alive></keep-alive>` 解决

```js
template: `
  <div>
    <keep-alive>
      <component :is="curentItem"></component>
    </keep-alive>
    <button @click="handleClick">切换</button>
  </div>
`
```

##### 5.4 异步组件

之前的组件都是在父组件中直接使用，组件的效果直接就展示了，没有延迟，是同步的，而有时候我们需要等待一段时间让组件生效展示，这时可以定义异步组件，使用 vue 的内置方法 `Vue.defineAsyncComponent()`定义，该方法接收一个回调函数，函数返回一个 promise 实例，在 promise 中处理异步流程

```js
app.component(
  'async-common-item',
  Vue.defineAsyncComponent(() => {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        resolve({
          template: `<div>this is an async component</div>`
        })
      }, 3000)
    })
  })
)
```

##### 5.5 组件边界

> 这里记录的都是和处理边界情况有关的功能，即一些需要对 Vue 的规则做一些小调整的特殊情况。不过注意这些功能都是有劣势或危险的场景的。我们会在每个案例中注明，所以当你使用每个功能的时候请稍加留意

访问子组件或子元素的实例，也就是我们**直接去操作Dom节点**，一般不是非常必要的话不建议直接操作Dom

比如需要根据数据展示对应的Dom，例如轮播图之类的

```js
const app = Vue.createApp({
  data() {
    return {
      count: 1
    }
  },
  mounted() {
    console.log(this.$refs.count) // <div>hello</div>
    this.$refs.count.innerHTML = 'hello'
    console.log(this.$refs.common) // Proxy {sayHello: ƒ, …}
    console.log(this.$refs.common.sayHello()) // 执行sayHello函数
  },
  template: `
    <div ref="count">{{count}}</div>
    <common-item ref="common"></common-item>
  `
})

app.component('common-item', {
  methods: {
    sayHello() {
      alert('hello')
    }
  },
  template: `
    <div>common-item</div>
  `
})

app.mount('#root')
```

拿到表单Dom操作

```js
methods: {
    resetLoginForm: function () {
        // console.log(this)
        // elementUI的form表单重置表单的方法
        this.$refs.loginFormRef.resetFields()
    }
}
```



依赖注入

有的时候数据需要深层次地传递，当组件层数过多时非常麻烦，需要一层一层的传递，这时可以使用依赖注入

> 然而，依赖注入还是有负面影响的。它将你应用程序中的组件与它们当前的组织方式耦合起来，使重构变得更加困难
>
> 同时所提供的 property 是**非响应式**的
>
> 如果你想要共享的这个 property 是你的应用特有的，而不是通用化的，或者如果你想在祖先组件中更新所提供的数据，那么这意味着你可能需要换用一个像 Vuex 这样真正的状态管理方案了。

如果你确实想用依赖注入，那么可以使用两个新的实例选项：provide 和 inject

```js
const app = Vue.createApp({
  data() {
    return {
      count: 1
    }
  },
  provide() {
    return {
      count: this.count
    }
  },
  template: `
    <child></child>
    <button @click="count+=1">add</button>
  `
})

app.component('child', {
  template: `
    <child-child></child-child>
  `
})

app.component('child-child', {
  inject: ['count'],
  template: `
    <div>{{count}}</div>
  `
})

app.mount('#root')
```

在这个例子中，点击增加 count 的值并不会响应到孙子组件里面，说明数据不是响应式的

#### 6 网络请求

##### 6.1 前后端交互模式

前后端一般都是通过接口进行交互，有如下几种方式：

1. 原生的 Ajax

   原生的 Ajax 使用比较麻烦，现已较少使用

2. 基于 jQuery 的 Ajax

   jQuery 的项目常用，比原生 Ajax 使用简单，原生 Ajax 和 jQuery 的 Ajax 都是基于 Dom 操作的，并不适合 vue

3. fetch

   标准化组织制定的新的规范，可以理解为 Ajax 的升级版

4. axios

   基于 promise 实现的三方库，可以更加强大地调用接口，关于 promise 「请」参考 JavaScript 基本篇
   

**restful url：**

和普通的 url 地址不同，专用于接口的 restful 风格的 url，基于请求方法的不同，表示不同的含义

- get 查询

- post 新增

- put 修改

- delete 删除


##### 6.2 fetch api

更简单的数据获取方式，功能更强大，可看作是 xhr 的升级版，fetch 是基于 Promise 实现的

语法结构：

```js
fetch(url)
    .then(fn1)
    .then(fn2)
    ...
    .catch(fn)
```

例子如下：

```js
fetch('http://localhost:3000/fdata')
    .then(function (data) {
      // 注意这里的 text() 是fetch的API，意思是返回一个Promise对象，text用于处理文本类返回
      return data.text()
    })
    .then(function (data) {
      // 这里得到的才是真实数据
      console.log(data) // Hello Fetch!
    })
```

fetch传参方式：

1. get

   由于默认是get方法，所以这里的method参数可以不写，这里是通过直接在url上写上请求参数的方式传参的

   ```js
   // express框架可以通过 req.query.id 获取参数
   fetch('http://localhost:3000/books?id=123', { method: 'get' })
       .then(function (data) {
           // 注意这里的 text() 是fetch的API，意思是返回一个Promise对象
           return data.text()
       })
       .then(function (data) {
           // 这里得到的才是真实数据
           console.log(data)
       })
   
   // express框架可以通过 req.params.id 获取参数，url需要设置为动态参数 '/books/:id'
   fetch('http://localhost:3000/books/123', { method: 'get' })
       .then(function (data) {
           // 注意这里的 text() 是fetch的API，意思是返回一个Promise对象
           return data.text()
       })
       .then(function (data) {
           // 这里得到的才是真实数据
           console.log(data)
       })
   ```

2. delete

   与get的动态参数传参一致，不过get改为delete

   ```js
   fetch('http://localhost:3000/books/123', { method: 'delete' })
       .then(function (data) {
            // 注意这里的 text() 是fetch的API，意思是返回一个Promise对象
            return data.text()
       })
       .then(function (data) {
            // 这里得到的才是真实数据
            console.log(data) // Hello Fetch!
       })
   ```

3. post

   post请求传参配置稍微多一些，需要配置请求体和请求头

   ```js
   fetch('http://localhost:3000/books', {
       method: 'post',
       body: 'uname=zs&pwd=123',
       headers: {
           'Content-Type': 'application/x-www-form-urlencoded'
       }
   })
       .then(function (data) {
           // 注意这里的 text() 是fetch的API，意思是返回一个Promise对象
           return data.text()
       })
       .then(function (data) {
           // 这里得到的才是真实数据
           console.log(data) // Hello Fetch!
       })
   
   fetch('http://localhost:3000/books', {
       method: 'post',
       body: JSON.stringify({
           uname: '张三',
           pwd: 123
       }),
       headers: {
           'Content-Type': 'application/json'
       }
       })
       .then(function (data) {
           // 注意这里的 text() 是fetch的API，意思是返回一个Promise对象
           return data.text()
       })
       .then(function (data) {
           // 这里得到的才是真实数据
           console.log(data) // Hello Fetch!
       })
   ```

4. put

   和post一样

   ```js
   fetch('http://localhost:3000/books/123', {
           method: 'put',
           body: JSON.stringify({
               uname: '张三',
               pwd: 789
           }),
           headers: {
               'Content-Type': 'application/json'
           }
       })
       .then(function (data) {
           // 注意这里的 text() 是fetch的API，意思是返回一个Promise对象
           return data.text()
       })
       .then(function (data) {
           // 这里得到的才是真实数据
           console.log(data) // Hello Fetch!
       })
   ```

fetch获取json格式数据
```js
fetch('http://localhost:3000/json')
    .then(function (data) {
        // 要获取json这里就不能返回 text() 了，需要返回json，如果依然想用text，则需要自己使用JSON.parse()转化结果
        return data.json()
    })
    .then(function (data) {
        // 这里得到的才是真实数据
        console.log(data) // Hello Fetch!
    })
```

##### 6.3 Axios

Axios 是一个基于 Promise 的 **HTTP第三方库**，比 fetch 功能更强大，它支持浏览器端和 nodejs 端，能拦截请求和响应，自动转换 JSON 数据

使用 Axios 之前需要先引入其 js 文件

Axios 发送请求很简单，调用相应的方法即可

```js
axios.get('http://localhost:3000/adata').then((ret) => {
    // 返回结果中的data属性包含了服务器响应的数据
    console.log(ret.data)
})
```

###### 6.3.1 Axios传参

1. get 和 delete

   直接将请求参数写在 url 里

   ```js
   axios.get('http://localhost:3000/axios?id=123').then((ret) => {
       console.log(ret.data)
   })
   
   // restful风格
   axios.get('http://localhost:3000/axios/123').then((ret) => {
       console.log(ret.data)
   })
   ```

   通过Axios提供的params参数传递

   ```js
   axios.get('http://localhost:3000/axios', {
         params: {
             id: 789
         }
       })
       .then((ret) => {
           console.log(ret.data)
       })
   ```

   delete的传参方式与get一致，只要修改为delete方法即可

2. post和put

   Axios的post方法默认传递的是JSON格式的数据，只需要直接传递对象给post函数即可

   ```js
   axios.post('http://localhost:3000/axios', {
       uname: '张三',
       pwd: 123
   })
     .then((ret) => {
       console.log(ret.data)
     })
   ```

   如果想传递传统表单的`application/x-www-form-urlencoded`格式的参数则需要使用API对参数进行处理

   ```js
   var params = new URLSearchParams()
   params.append('uname', '张三')
   params.append('pwd', 123)
   axios.post('http://localhost:3000/axios', params).then((ret) => {
       console.log(ret.data)
   })
   ```

   put的传参方式与post一致，只要修改为put方法即可

###### 6.3.2 Axios全局配置

可以对Axios进行全局配置

```js
// 配置请求基地址
axios.defaults.baseURL = 'http://localhost:3000/'
// 配置请求头，在请求头中会出现 mytoken: hello 的键值对
axios.defaults.headers['mytoken'] = 'hello'
// 配置请求响应时间，超时失败
axios.defaults.timeout = 3000
axios.get('adata').then((ret) => {
    console.log(ret.data)
})
```

###### 6.3.3 Axios拦截器

1. 请求拦截器

   用于在请求发出之前设置信息

   ```js
   axios.interceptors.request.use(
       config => {
           // 发请求前设置请求头
           config.headers.mytoken = 'hello interceptor'
           return config
       },
       err => {
           console.log(err)
       }
   )
   axios.get('adata').then(ret => {
       console.log(ret.data)
   })
   ```

2. 响应拦截器

   在获取数据之前对数据进行处理，比方说在拦截器里提前处理数据获得实际响应的数据，请求接口获得的结果就直接是响应的实际数据了

   ```js
   axios.interceptors.response.use(
       res => {
           return res.data
       },
       err => {
           console.log(err)
       }
   )
   axios.get('adata').then(ret => {
       console.log(ret)
   })
   ```

#### 7 Vue路由

路由是一个比较广义抽象的概念，路由的本质其实就是**对应关系**，不仅后端有路由，前端也有路由

后端的路由是指根据用户的不同的请求地址返回不同的内容，这里请求地址和返回内容（服务器资源）之间就是一种对应关系

最开始的网页应用由后端渲染，存在性能问题，后来分担给前端渲染，但是却不支持浏览器的前进后退操作，再后来就出现了 SPA（Single Page Application） 单页面应用，网页只有一个页面，通过 Ajax 实现网页局部刷新，同时支持浏览器的前进后退操作，实现原理是通过 URL 的 hash 值的变化导致浏览器记录访问历史的变化，**不会触发新的 URL 请求**

前端路由就是指根据用户的不同事件显示不同的页面内容，具体到开发层面就是**用户事件**与**事件处理函数**之间的对应关系，这个对应关系通过前端路由进行监听维护，前端路由监听用户事件并触发相应的处理函数

手动实现简易的前端路由

```html
<div id="app">
    <!-- 切换组件的超链接 -->
    <a href="#/zhuye">主页</a>
    <a href="#/keji">科技</a>
    <a href="#/caijing">财经</a>
    <a href="#/yule">娱乐</a>

    <!-- 根据 :is 属性指定的组件名称，把对应的组件渲染到 component 标签所在的位置 -->
    <!-- 可以把 component 标签当做是【组件的占位符】 -->
    <component :is="comName"></component>
</div>
```

```js
// 主页组件
const zhuye = {
    template: '<h1>主页信息</h1>'
}

// 科技组件
const keji = {
    template: '<h1>科技信息</h1>'
}

// 财经组件
const caijing = {
    template: '<h1>财经信息</h1>'
}

// 娱乐组件
const yule = {
    template: '<h1>娱乐信息</h1>'
}

const vm = new Vue({
    el: '#app',
    data: {
        comName: 'zhuye'
    },
    // 注册私有组件
    components: {
        zhuye,
        keji,
        caijing,
        yule
    }
})

// 监听 window 的 onhashchange 事件，根据获取到的最新的 hash 值，切换要显示的组件的名称
window.onhashchange = function () {
    // 在事件处理函数中可以通过 location.hash 获取到最新的 hash 值
    console.log(location.hash)
    let hash = location.hash
    switch (hash.slice(1)) {
        case '/zhuye':
            vm.comName = 'zhuye'
            break
        case '/keji':
            vm.comName = 'keji'
            break
        case '/caijing':
            vm.comName = 'caijing'
            break
        case '/yule':
            vm.comName = 'yule'
            break
    }
}
```

##### 7.1 Vue Router

Vue Router是 Vue 官网提供的路由管理器，可以非常方便地用于 SPA 应用的开发，一般我们不用自己实现前端路由，直接使用 Vue Router 就好了

1. 引入 Vue Router 库文件

   首先引 入Vue Router 的依赖 Vue 文件，然后再引入 Vue Router 文件

2. 添加路由链接

   添加路由链接 `<router-link></router-link>`，这是 vue 提供的标签，默认渲染为 `<a></a>` 标签

   `to` 属性默认渲染为 `href` 属性，值为以 # 开头的 hash 地址
   
   ```html
<router-link to="/user">User</router-link>
   ```

3. 添加路由占位符

   如果通过路由规则匹配到了对应的组件，则该组件会被渲染到路由占位符的位置

   ```html
   <router-view></router-view>
   ```

4. 创建路由组件

   ```js
   const User = {
       template: `<h1>User Component</h1>`
   }
   const Register = {
       template: `<h1>Register Component</h1>`
   }
   ```

5. 创建路由实例

   在创建路由实例时，路由规则由对象数组的形式进行配置

   ```js
   const router = new VueRouter({
       routes: [
           { path: '/user', component: User },
           { path: '/register', component: Register }
       ]
   })
   ```

6. 将路由实例挂载到 vue 根实例上面

   ```js
   const vm = new Vue({
       el: '#app',
       router // 属性和值的名称一样，在ES6中可以简写，不必写成 router: router
   })
   ```
   
   至此就完成了路由的定义工作，点击渲染好的 `<a>` 链接，在路由占位符的位置就会显示对应的路由组件

##### 7.2 路由重定向

用户在访问 A 地址时，自动将地址重定向到 B 地址，从而实现展示特定组件的效果，使用 `redirect` 就可以定义路由重定向规则

```js
const router = new VueRouter({
    routes: [
        { path: '/', redirect: '/user' },
        { path: '/user', component: User },
        { path: '/register', component: Register }
    ]
})
```

##### 7.3 嵌套路由

嵌套路由就是指通过路由规则的层级嵌套，构造出较为复杂的路由组件关系，一般比较多的是父子级路由的嵌套

1. 先在父路由组件中定义好路由链接和路由占位符

   ```js
   const Register = {
     template: `
       <div>
           <h1>Register Component</h1>
           <router-link to="/register/tab1">tab1</router-link>
           <router-link to="/register/tab2">tab2</router-link>
           <router-view></router-view>
       </div>
     `
   }
   ```

2. 创建子路由组件

   ```js
   const Tab1 = {
       template: `
           <h3>tab1 component</h3>
       `
   }
   
   const Tab2 = {
       template: `
           <h3>tab2 component</h3>
       `
   }
   ```

3. 将子路由规则配置到父路由规则里面

   ```js
   const router = new VueRouter({
       routes: [
           { path: '/', redirect: '/user' },
           { path: '/user', component: User },
           {
               path: '/register',
               component: Register,
               children: [  // 通过 children 属性进行配置
                   { path: '/register/tab1', component: Tab1 },
                   { path: '/register/tab2', component: Tab2 }
               ]
           }
       ]
   })
   ```

4. 由于父路由规则所在路由实例已经挂载到 vue 实例，因此这里无需再次挂载

##### 7.5 动态路由匹配

如果在路由链接里面的地址只有一部分是动态变化的，而其余部分均是一样的，那么就可以使用动态路由匹配来匹配路由，而不是每一个路由都去单独定义规则，这样可以简化路由规则的书写

```html
<router-link to="/user/1">User1</router-link>
<router-link to="/user/2">User2</router-link>
<router-link to="/user/3">User3</router-link>
```

```js
const router = new VueRouter({
    routes: [
        { path: '/', redirect: '/user/1' },
        { path: '/user/:id', component: User }
    ]
})
```

在动态路由组件的内部可以通过特定的 API `$route.params.id` 来获取动态参数的值

```js
const User = {
    template: `<h1>User Component {{ $route.params.id }}</h1>`
}
```

但是使用 `$route` 获取动态参数与对应的路由过于耦合，可以使用 `props` 属性来解耦

首先设置 `props` 属性为true

```js
const router = new VueRouter({
    routes: [
        { path: '/', redirect: '/user/1' },
        { path: '/user/:id', component: User, props: true }
    ]
})
```

然后在组件中使用 `props` 属性接收参数值

```js
const User = {
    props: ['id'],
    template: `<h1>User Component {{ id }}</h1>`
}
```

也可以将 `props` 属性的值不设置为true，而是设置为一个对象，这种情况下动态参数将不能被传递，只能传递对象里的值

> 但是我们仍然可以通过老办法也就是$route的方式访问到动态参数

```js
const router = new VueRouter({
    routes: [
        { path: '/', redirect: '/user/1' },
        {
            path: '/user/:id',
            component: User,
            props: { uname: '张三', age: 18 }
        }
    ]
})
```

```js
const User = {
    props: ['uname', 'age'],
    template: `<h1>User Component {{ $route.params.id }} {{uname + '---' + age}}</h1>`
}
```

还可以将 `props` 属性设置为函数，形参里面就包含了动态参数的值，这样就可以把动态参数也一并传递给动态路由组件接收了

```js
const router = new VueRouter({
    routes: [
        { path: '/', redirect: '/user/1' },
        {
            path: '/user/:id',
            component: User,
            props: route => ({ uname: '张三', age: 18, id: route.params.id })
        }
    ]
})
```

然后在路由组件中接收参数，就可以使用参数了

```js
const User = {
    props: ['uname', 'age', 'id'],
    template: `<h1>User Component {{id}} {{uname + '---' + age}}</h1>`
}
```

##### 7.6 命名路由

所谓的命名路由其实就是给路由规则起别名的意思，是为了更加方便地表示路由路径

首先给路由规则起别名

```js
const router = new VueRouter({
    routes: [
        { path: '/', redirect: '/user/1' },
        {
            name: 'user',  // 起别名为 user
            path: '/user/:id',
            component: User,
            props: route => ({ uname: '张三', age: 18, id: route.params.id })
        }
    ]
})
```

然后修改路由链接，将to属性改为动态绑定的一个对象，对象里面可以指定要跳转的路由别名，还有需要传递的参数（参数命名需要与路由规则里的参数名称一致）

```html
<router-link to="/user/1">User1</router-link>
<router-link to="/user/2">User2</router-link>
<router-link :to="{name: 'user', params: {id: 3}}">User3</router-link>
```

使用效果方面与普通路由完全一致

##### 7.7 编程式导航

在页面导航中有两种方式，一种是**声明式导航**，另一种是**编程式导航**

- 声明式导航

  就是点击链接跳转的方式，比如普通网页中的 `<a>` 链接，vue 里的 `<router-link>` 链接等

- 编程式导航

  通过调用 js 的 API 的方式实现的导航，比如修改 `location.href` 属性实现的导航，在vue中，常用的编程式导航 API 有

  1. `this.$router.push('hash地址')`

     ```js
     const User = {
         props: ['uname', 'age', 'id'],
         template: `
             <div>
                 <h1>User Component {{id}} {{ uname + '---' + age }}</h1>
                 <button @click="goRegister">编程式导航</button>  
             </div>
         `,
         methods: {
             goRegister: function () {
                 this.$router.push('/register')
             }
         }
     }
     ```
     除了 hash 地址还可以传递别的参数
     - 传递对象
  
       ```js
       this.$router.push({path: '/register'})
       ```
  
     - 带查询参数，参数会被拼接在地址里，`/register?uname=zs`
  
       ```js
       this.$router.push({path: '/register', query: {uname: 'zs'}})
       ```
  
     - 给命名路由传递参数
  
       ```js
       this.$router.push({name: 'register', params: {id: 1}})
       ```
  
  2. `this.$router.go(n)`
  
     n 为 -1 表示后退历史记录一步，为 1 表示前进一步
  
     ```js
     const Register = {
       template: `
         <div>
           <h1>Register Component</h1>
           <router-link to="/register/tab1">tab1</router-link>
           <router-link to="/register/tab2">tab2</router-link>
           <router-view></router-view>
           <button @click="goBack">后退</button>  
         </div>
       `,
       methods: {
         goBack: function () {
           this.$router.go(-1)
         }
       }
     }
     ```

##### 7.8 路由导航守卫

可以通过路由导航守卫来**控制访问权限**

```js
const router = new VueRouter({
  routes
})

// 挂载路由导航守卫
// to: 访问路径
// from: 当前的访问是从哪个路径跳转过来的
// next: 放行到哪个路径
router.beforeEach((to, from, next) => {
  if (to.path === '/login') return next()
  const tokenStr = window.sessionStorage.getItem('token')
  if (!tokenStr) return next('/login')
  next()
})

export default router
```


#### 8 Vue单文件组件

传统组件存在的问题：

1. 全局定义的组件需要保证组件名称没有重名
2. 组件里的模板不管是使用字符串还是模板字符串，在里面书写的html都不支持语法高亮，只能硬写，这是很不科学的
3. 传统组件不支持将CSS直接写进来
4. 没有构建步骤限制，只能使用传统HTML和ES5，不能使用预处理器，比如babel

为了解决这一系列的问题，Vue提出了单文件组件的解决方案，而这也是Vue开发最常使用的方案，每个Vue单文件组件是一个以`.vue`结尾的单文件，其内容大致结构如下

```vue
<template>
    <div>组件模板区域</div>
</template>

<script>
    // 组件业务区域
    export default {
        // 组件数据
        data: () => {
            return {}
        },
        methods: {
            // 组件函数
        }
    }
</script>

<style scoped lang="less">
    /* 组件样式区域，scoped指令使得每个组件的样式彼此独立 */
    /* lang指定预处理器 */
</style>
```

#### 9 Vue脚手架

之前我们都是手动构建vue项目的，而vue脚手架就是一个命令行工具，可以帮助我们快速地自动构建vue项目，这样就可以快速地创建项目，把更多精力花在业务逻辑上

##### 9.1 安装vue脚手架

目前脚手架已升级到了4版本，工具类的推荐全局安装

```sh
npm i -g @vue/cli
```

安装完成后可以检查脚手架的版本号

```sh
vue -V   # vue --version
```

##### 9.2 新建vue项目

###### 9.2.1 通过命令行

输入命令之后根据界面提示一通操作猛如虎，就新建了vue项目

```sh
vue create vue-project
```
然后cd到项目目录，执行运行命令`npm run serve`把项目跑起来，访问命令行中的网址就可以访问初始化好的项目页面了

###### 9.2.2 通过图形界面

输入命令后将会打开浏览器进入vue脚手架的图形界面，这种方式比起命令行的方式更加直观一些

```sh
vue ui
```
在初始化git仓库那里填写提交信息

然后进入预设面板进行设置，如果之前创建过项目又保存了预设，那这里会出现预设选项供你选择，这里我们再次选择手动配置，配置完成后就可以运行任务开启项目了

###### 9.2.3 基于vue2.X的模板

目前已经很少使用了，同样根据命令行提示操作就可以了

```sh
npm i -g @vue/cli-init
vue init webpack vue-project
```

##### 9.3 项目自定义配置

项目新建完成，有些东西可以自定义配置，比如端口号、自动开启预览，可以在`package.json`里配置，新增vue节点配置

```json
"vue": {
    "devServer": {
        "port": 8888,
        "open": true
    }
}
```

但是不推荐这种方式，配置文件应该负责单一的功能，所以推荐将配置写到vue的专门配置文件`vue.config.js`中

```js
module.exports = {
  devServer: {
    port: 8848,
    open: true
  }
}
```

#### 10 Vuex

在我们的组件之间共享数据的方式中，父组件向子组件传值是通过v-bind属性绑定的方式，子传父是通过事件绑定的方式，兄弟组件是通过事件处理中心的方式，但是这些都是组件之间的小范围的数据共享，**而且某些时候数据共享会变得很麻烦，比如组价数量很多的时候，一个组件向另一个组件传值可能需要通过好几个组件进行中介传值**，如果要实现大范围的、频繁地进行数据共享，单单用组件传值是不够的，vuex就是专门用来解决这个问题的，vuex是实现组件全局状态管理的一种机制，状态其实也就是数据，通过vuex可以方便地实现组件之间的数据共享

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/frontend/vue/vuex.png)

使用vuex的好处：

1. 在vuex中集中管理状态，方便开发维护
2. 高效地在组件间共享数据，提高开发效率
3. vuex中的数据是响应式的，数据一旦发生改变，引用了这个数据的页面都会发生改变

> 应用不复杂的时候，不需要使用vuex，但当应用复杂时，使用vuex反而会带来便利
>
> 存储在vuex中的数据应该只有组件间共享的数据，组件私有数据就存储在组件里，当然这只是建议

##### 10.1 vuex的使用

1. 安装vuex

   可通过npm也可通过vue图形化界面

2. 引入vuex，创建store对象

   `store.js`：

   ```js
   import Vue from 'vue'
   import Vuex from 'vuex'
   Vue.use(Vuex)
   export default new Vuex.Store({
       state: {},
       mutation: {},
       actions: {}
   })
   ```

3. 挂载store对象到vue实例

   `main.js`：

   ```js
   import Vue from 'vue'
   import store from './store'
   import App from './App.vue'
   
   new Vue({
       store
       render: h => h(App)
   }).$mount('#app')
   ```

##### 10.2 vuex核心概念

1. State

   State提供唯一的一个公共数据源，用于存放共享数据

   ```js
   import Vue from 'vue'
   import Vuex from 'vuex'
   
   Vue.use(Vuex)
   
   const store = new Vuex.Store({
     state: {
       count: 0
     }
   })
   ```

   访问数据的方式：

   - 直接访问

     ```js
     this.$store.state.count
     ```

     在template标签中无需加this可直接访问

     ```vue
     <template>
         <div>{{$store.state.count}}</div>
     </template>
     ```

   - 通过mapState访问

     首先从vuex中导入mapState，然后通过mapState声明要使用的共享值，接着使用展开语法展开mapState，将其转为computed计算属性的值

     ```js
     import { mapState } from 'vuex'
     
     export default {
         data() {},
         computed: {
             ...mapState(['count'])
         }
     }
     ```

     接着就可以在页面直接使用了

     ```vue
     <template>
         <div>{{count}}</div>
     </template>
     ```

2. Mutation

   既然我们可以直接访问vuex的共享数据，那我们怎么使用数据呢，在组件中定义函数然后直接操作访问的数据吗，这是不可以的，虽然可以实现效果，但是却修改了这些全局共享数据，而通过mutation也修改了全局数据，但是可以集中监控数据变化

   定义mutation里面的函数：

   ```js
   const store = new Vuex.Store({
     state: {
         count: 0
     },
     mutations: {
         add(state) {
             state.count++
         }
     }
   })
   ```

   触发函数：

   ```js
   methods: {
       btnHandler() {
           this.$store.commit('add')
       }
   }
   ```

   触发函数时还可以传递参数：

   ```js
   const store = new Vuex.Store({
     state: {
         count: 0
     },
     mutations: {
         add(state, step) {
             state.count += step
         }
     }
   })
   ```

   ```js
   methods: {
       btnHandler() {
           this.$store.commit('add', 3)
       }
   }
   ```

   除了commit直接触发还有第二种方式，先从vuex引入mapMutations函数，然后将需要使用的mutations的函数映射为methods的函数

   ```js
   import { mapMutations } from 'vuex'
   
   export default {
       data() {},
       methods: {
           ...mapMutations(['add']),
           btnHandler() {
               this.add(3)
           }
       }
   }
   ```

3. Action

   现在我们有个需求，点击按钮之后延迟一秒后再加一，那么直接在mutations里面写异步代码setTimeout吗，答案是不行的，里面不能写异步代码，写了也不起作用，数据是不同步的，action就是处理这个**异步**的问题的，在action里面通过mutation间接修改共享数据

   ```js
   const store = new Vuex.Store({
     state: {
         count: 0
     },
     mutations: {
         add(state, step) {
             state.count += step
         }
     },
     actions: {
         asyncAdd(context) {
             setTimeout(() => {
                 context.commit('add')
             }, 1000)
         }
     }
   })
   ```

   调用actions

   ```js
   methods: {
       btnHandler() {
           this.$store.dispatch('asyncAdd')
       }
   }
   ```

   携带参数的方式也和mutation一样

   ```js
   const store = new Vuex.Store({
     state: {
         count: 0
     },
     mutations: {
         add(state, step) {
             state.count += step
         }
     },
     actions: {
         asyncAdd(context, step) {
             setTimeout(() => {
                 context.commit('add', step)
             }, 1000)
         }
     }
   })
   ```

   ```js
   methods: {
       btnHandler() {
           this.$store.dispatch('asyncAdd', 5)
       }
   }
   ```

   触发actions的第二种方式也是一样的

   ```js
   import { mapAtions } from 'vuex'
   
   export default {
       data() {},
       methods: {
           ...mapAtions(['asyncAdd']),
           btnHandler() {
               this.asyncAdd(5)
           }
       }
   }
   ```

   到这里我们其实可以发现组件里面不用定义函数来处理mutation或action的函数调用，既然是将这些**共享函数**映射为**组件自己的函数**，那么直接扔给模板使用就可以了

   ```js
   import { mapAtions } from 'vuex'
   
   export default {
       data() {},
       methods: {
           ...mapAtions(['asyncAdd'])
       }
   }
   ```

   ```vue
   <template>
       <button @click="asyncAdd"></button>
   </template>
   ```

4. Getter

   getter用于将store对象里的**数据加工处理**为新的数据（但是**不修改数据**，修改数据是mutation的事情），类似于计算属性，当store中的数据变化后，getter里的数据自然也会变化

   ```js
   const store = new Vuex.Store({
     state: {
         count: 0
     },
     mutations: {
         add(state, step) {
             state.count += step
         }
     },
     actions: {
         asyncAdd(context, step) {
             setTimeout(() => {
                 context.commit('add', step)
             }, 1000)
         }
     },
     getters: {
         showNum(state) {
             return '最新数量是：' + state.count
         }
     }
   })
   ```

   同样，访问也有两种方式

   - 直接访问

     ```vue
     <template>
         <div>{{$store.getters.showNum}}</div>
     </template>
     ```

   - 间接访问

     将数据映射到computed里面就好

     ```js
     import { mapGetters } from 'vuex'
     
     export default {
         data() {},
         computed: {
             ...mapGetters(['showNum'])
         }
     }
     ```

     ```vue
     <template>
         <div>{{showNum}}</div>
     </template>
     ```

#### 11 常用技巧

##### 11.1 自定义样式

Vue 的官网解释：[子组件的根元素](https://vue-loader.vuejs.org/zh/guide/scoped-css.html#子组件的根元素)

深度作用选择器

如果你希望 `scoped` 样式中的一个选择器能够作用得“更深”，例如影响子组件，你可以使用 `>>>` 操作符：

```js
<style scoped>
.a >>> .b { /* ... */ }
</style>
```

上述代码将会编译成：

```css
.a[data-v-f3f3eg9] .b { /* ... */ }
```

> 有些像 Sass 之类的预处理器无法正确解析 `>>>`。这种情况下你可以使用 `/deep/` 或 `::v-deep` 操作符取而代之——两者都是 `>>>` 的别名，同样可以正常工作。


