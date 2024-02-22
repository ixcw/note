#### 1 初步理解

直接引用vue3的在线文件

```html
<script src="https://unpkg.com/vue@next"></script>
```

然后创建vue实例

```js
const app = Vue.createApp({})
app.mount('#root')
```

可以在创建vue实例时传递一个配置对象，对象里面的属性是vue实例需要的配置

```js
const app = Vue.createApp({
  data() {
    return {
      msg: 'hello'
    }
  },
  template: `
    <div>{{ msg }}</div>
  `
})
app.mount('#root')
```

在vue实例调用mount方法进行挂载的时候，会返回一个根组件

```js
const vm = app.mount('#root')
```

根组件拥有vue实例的一系列属性，比如可以通过根组件来获取或者改变变量msg的值

```js
vm.$data.msg = 'haha'
```

#### 2 生命周期

vue的生命周期函数可以理解为在vue运行时的某一**特定时期**会**自动执行**的函数，见下图

![lifecycle](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/frontend/vue3/lifecycle.png)

> 并不是`mounted`要等到`created`中所有的代码执行结束后才执行，注意`created`中的异步任务仍然比`mounted`中的同步代码后执行

#### 3 样式绑定

##### 3.1 特殊属性 `$attrs`

如果子组件上的根元素不止一个，如果想给其中的某个根元素指定样式的话，可以用到特殊的属性 `$attrs`

在父组件中：

```js
template: `
  <div>{{ msg }}</div>
  <demo class="green" />
`
```

子组件中：

```js
app.component('demo', {
  template:`
    <div :class="$attrs.class">first</div>
    <div>second</div>
  `
})
```
>`$attrs`属性是一个代理对象，其包含了所有父组件传递给子组件的参数，在子组件中可以通过`$attrs`属性访问这些传递的参数

##### 3.2 行内样式

行内样式的绑定推荐用对象的写法

```js
data() {
  return {
    msg: 'hello',
    styleObj: {
      color: 'yellow',
      background: 'blue'
    }
  }
},
template: `
  <div :style="styleObj">{{ msg }}</div>
  <demo class="green" />
`
```

#### 4 循环渲染

`v-for` 除了循环数组，还能循环对象，循环对象时，循环项目由数组值、索引变为对象值、键、索引

```js
data() {
  return {
    msg: 'hello',
    styleObj: {
      color: 'yellow',
      background: 'blue'
    }
  }
},
template: `
  <div :style="styleObj">{{ msg }}</div>
  <demo class="green" />
  <div v-for="(value, key, index) in styleObj">{{ value }} -- {{ key }} -- {{ index }}</div>
`,
```

> 为了让循环更新列表时可以尽量**复用**循环项，最好给定一个不重复的key值，这样可以提高循环渲染的性能

循环数组时除了改变原数组以外，还可以直接替换整个数组，如`concat`、`filter`等生成新数组的方法返回的新数组赋值给原数组，效果和改变原数组是一样的

> vue3的新特性：在vue3中，直接修改数组中的值或者对象中的值，vue3可以检测到这种变化，反映到页面的变化上来

还可以直接循环数字，循环项是1~数字

使用`v-for`循环时，不能同时使用`v-if`，因为循环的优先级高于条件判断，所以条件判断不会生效，解决办法是在循环内部的标签中进行条件判断

> 循环可以使用`template`标签，这样最终的渲染结果就不会多出一层标签了

#### 5 事件

如果需要一次点击事件触发多个函数，那么使用`,`间隔，函数调用加上`()`就可以了

```js
methods: {
  handleClick() {
    alert(1)
  },
  handleClick1(event) {
    alert(event)
  },
},
template: `
  <button @click="handleClick(), handleClick1($event)">click</button>
`
```

#### 6 组件

##### 6.1 全局组件

注册全局组件，注册之后，在每个组件里面都可以使用，即使不用，也是挂载到vue实例上的，对性能有一定损耗，但是使用起来简单

```js
app.component('component-name', {
  template:`
    <div>component</div>
  `
})
```

##### 6.2 局部组件

局部组件直接通过变量进行定义，然后作为组件配置传递给创建vue实例的方法`createApp`

```js
const Counter = {
  data() {
    return {
      count: 0
    }
  },
  template: `
    <div @click="count++">{{ count }}</div>
  `
}

const HelloWorld = {
  template: `
    <div>HelloWorld</div>
  `
}

const app = Vue.createApp({
  components: { 
    Counter,
    HelloWorld
  },
  template: `
    <counter />
    <hello-world />
  `
})
```

> 局部组件命名推荐使用大驼峰命名，方便和普通变量进行区分，在使用组件时，vue会自动将大驼峰命名转化为短横线命名，方便开发者使用

##### 6.3 组件传值

###### 6.3.1 传值校验

对于普通的组件传值直接把props属性写成数组就可以了，而如果想要校验接收的值类型，则需要将props属性写为对象，在对象里面规定默认的值类型，如果传错值类型，在控制台将会打印警告信息

```js
app.component('demo', {
  // props: ['content'],
  props: {
    content: String // String Number Object Function Boolean Symbol
  },
  template:`
    <div>demo</div>
    <div>{{ typeof content }}</div>
  `
})
```

还可以对是不是必传进行校验，以及设定不传时的默认值，甚至对值的范围进行校验

```js
app.component('demo', {
  // props: ['content'],
  props: {
    content: {
      type: Number,
      validator: function(value) {
        return value < 1000
      },
      required: true,
      default: 'hello'
    }
  },
  template:`
    <div>demo</div>
    <div>{{ typeof content }}</div>
  `
})
```

如果传递的参数过多，可以将这些参数组合成一个对象，然后使用`v-bind`指令一次性传给子组件，子组件用`props`数组接收这些参数，类似于js中的解构赋值语法

```js
const app = Vue.createApp({
  data() {
    return {
      params: {
        name: 'jack',
        sex: 1,
        age: 18
      }
    }
  },
  template: `
    <div>
      <demo v-bind="params"></demo>
    </div>
  `
})

app.component('demo', {
  props: ['name', 'sex', 'age'],
  template:`
    <div>{{ name }}</div>
    <div>{{ sex }}</div>
    <div>{{ age }}</div>
  `
})
```

对于组件传参的参数命名，如果有多个单词的情况，最好是用短横线命名(**更符合html的规范**)，然后子组件的props接收时可以继续按短横线命名接收，或者使用小驼峰命名接收(推荐)，但是在模板中使用参数时，必须按小驼峰命名的方式使用，否则无效

```js
const app = Vue.createApp({
  data() {
    return {
      params: {
        name: 'jack',
        sex: 1,
        age: 18
      }
    }
  },
  template: `
    <div>
      <demo :data-name="params.name"></demo>
    </div>
  `
})

app.component('demo', {
  props: ['data-name'], // props: ['dataName'],
  template:`
    <div>{{ dataName }}</div>
  `
})
```

###### 6.3.2 单向数据流

当我们在子组件中对**父组件传递给子组件的数据**进行修改时，vue将会在控制台触发一个警告，并且我们的修改不会成功

> `[Vue warn]: Attempting to mutate prop "dataSex". Props are readonly. `

```js
const app = Vue.createApp({
  data() {
    return {
      params: {
        name: 'jack',
        sex: 1,
        age: 18
      }
    }
  },
  template: `
    <div>
      <demo :data-sex="params.sex"></demo>
    </div>
  `
})

app.component('demo', {
  props: ['dataSex'],
  template:`
    <div @click="dataSex++">{{ dataSex }}</div>
  `
})
```

这就是vue中的单向数据流的概念，子组件可以使用父组件传递过来的数据，但是不能修改传递过来的数据，如果想要实现**修改的效果**，子组件可以定义自己的数据，将传递过来的数据赋值给自己的数据，修改自己的数据就可以了

```js
const app = Vue.createApp({
  data() {
    return {
      params: {
        name: 'jack',
        sex: 1,
        age: 18
      }
    }
  },
  template: `
    <div>
      <demo :data-sex="params.sex"></demo>
    </div>
  `
})

app.component('demo', {
  props: ['dataSex'],
  data() {
    return {
      mySex: this.dataSex
    }
  },
  template:`
    <div @click="mySex++">{{ mySex }}</div>
  `
})
```

为什么要存在单向数据流呢？因为假设允许我们修改父组件的数据，那么当一个子组件修改了父组件的数据之后，另一个子组件的数据也将被修改（因为都是来自于父组件的数据），这样就造成了组件之间的数据是耦合的，后期维护修改起来非常麻烦，在开发过程中也容易造成一些难以排查的bug，所以vue就不建议甚至禁止了子组件直接去修改父组件的数据

###### 6.3.3 `Non-props` 属性

如果父组件给子组件传值的时候，子组件不用props去接收，那么这个传值会自动变成子组件最外层标签上的属性

```html
<div data-sex="1"></div>
```

如果希望不出现这个属性，可以在子组件中通过`inheritAttrs`属性进行配置

```js
const app = Vue.createApp({
  template: `
    <div>
      <demo style="color: red;"></demo>
    </div>
  `
})

app.component('demo', {
  // inheritAttrs: false,
  template:`
    <div>123</div>
  `
})
```

non-props属性有时候是有用的，比如用于修改子组件的样式，可以绑定内联样式或者类样式

当不指定`inheritAttrs`时，标签的颜色将被指定为红色

```html
<div style="color: red;">123</div>
```

###### 6.3.4 多级组件传值

超过三级组件时，传值变得麻烦，需要一层一层地通过props进行传递，这时可以使用`provide/inject`语法，最外层组件`provide`值，需要使用值的内层组件`inject`值即可

```js
provide() {
    return {
        count: this.count
    }
}

inject: ['count']
```

##### 6.4 组件通信

之前我们说过单向数据流的概念，但是如果子组件就是想改变父组件中的数据应该怎么做呢？这时候子组件虽然不能直接去修改父组件中的数据，但是可以**通知**父组件让它自己去修改自己的数据

如何通知呢？vue为我们准备了`$emit`函数用于通知父组件，首先我们自定义一个自定义事件名称，然后使用`$emit`函数将自定义事件名称通知给父组件，父组件在子组件上通过自定义事件名称来监听通知，一旦监听到了通知就执行对应的函数去执行修改操作（或者别的什么操作）

```js
const app = Vue.createApp({
  data() {
    return { count: 1 }
  },
  methods: {
    handleAddOne() {
      this.count++
    }
  },
  template: `
    <div>
      <counter :count="count" @add-one="handleAddOne" />
    </div>
  `
})

app.component('counter', {
  props: ['count'],
  methods: {
    handleCounterClick() {
      this.$emit('addOne')
    }
  },
  template:`
    <div @click="handleCounterClick">{{ count }}</div>
  `
})

const vm = app.mount('#root')
```

除了简单的通知父组件执行某些操作，使用`$emit`函数也可以向父组件传递子组件的数据

```js
const app = Vue.createApp({
  data() {
    return { count: 1 }
  },
  methods: {
    handleAdd(param1, param2) {
      this.count += param2
    }
  },
  template: `
    <div>
      <counter :count="count" @add="handleAdd" />
    </div>
  `
})

app.component('counter', {
  props: ['count'],
  methods: {
    handleCounterClick() {
      this.$emit('add', 2, 3)
    }
  },
  template:`
    <div @click="handleCounterClick">{{ count }}</div>
  `
})

const vm = app.mount('#root')
```

甚至先在子组件中完成计算

```js
const app = Vue.createApp({
  data() {
    return { count: 1 }
  },
  methods: {
    handleAdd(param) {
      this.count = param
    }
  },
  template: `
    <div>
      <counter :count="count" @add="handleAdd" />
    </div>
  `
})

app.component('counter', {
  props: ['count'],
  methods: {
    handleCounterClick() {
      this.$emit('add', this.count + 2)
    }
  },
  template:`
    <div @click="handleCounterClick">{{ count }}</div>
  `
})

const vm = app.mount('#root')
```

在子组件中可以通过`emits`属性对子组件中向外传递的自定义事件进行校验和限制，方便维护

写成简单的数组的话，如果传递的事件名称不在数组中，则会在控制台发出警告

> `[Vue warn]: Component emitted event "add" but it is neither declared in the emits option nor as an "onAdd" prop.`

```js
app.component('counter', {
  props: ['count'],
  emits: ['minus'],
  methods: {
    handleCounterClick() {
      this.$emit('add', this.count + 2)
    }
  },
  template:`
    <div @click="handleCounterClick">{{ count }}</div>
  `
})
```

写成对象的话就能进行一些限制

> `[Vue warn]: Invalid event arguments: event validation failed for event "add".`

```js
app.component('counter', {
  props: ['count'],
  emits: {
    add: count => {
      if(count < 0) return true
      return false
    }
  },
  methods: {
    handleCounterClick() {
      this.$emit('add', this.count + 2)
    }
  },
  template:`
    <div @click="handleCounterClick">{{ count }}</div>
  `
})
```

除了以上写法外，vue还提供了一种简化的语法，利用`v-model`指令完成修改

```js
const app = Vue.createApp({
  data() {
    return { count: 1 }
  },
  template: `
    <div>
      <counter v-model="count" />
    </div>
  `
})

app.component('counter', {
  props: ['modelValue'],
  methods: {
    handleCounterClick() {
      this.$emit('update:modelValue', this.modelValue + 2)
    }
  },
  template:`
    <div @click="handleCounterClick">{{ modelValue }}</div>
  `
})
```

> 子组件中接收的参数名称是固定的`modelValue`，通知的事件名称也是固定的`update:modelValue`
>
> 如果不想使用固定的名称`modelValue`，可以在父组件中定义要使用的名称`<counter v-model:mCount="count" />`，然后在子组件中使用即可，在使用这种修改名称的写法的时候，可以写多个`v-model`，传递多个双向绑定的值给子组件

##### 6.5 插槽

如果不只想向子组件中传递参数，而且还想传递内容，比如标签、文本、**组件**等等，那么就可以使用slot插槽的语法

```js
const app = Vue.createApp({
  template: `
    <div>
      <counter>456</counter>
      <counter>
        <button>456</button>
      </counter>
    </div>
  `
})

app.component('counter', {
  template:`
    <div>
      123
      <slot></slot>
    </div>
  `
})
```

> slot标签上不能直接绑定事件，可以在slot外层包裹一个span标签绑定事件

slot可以有默认值，写在slot标签中即可，父组件不传内容时可以显示默认值

```js
const app = Vue.createApp({
  template: `
    <div>
      <counter>456</counter>
      <counter>
        <button>456</button>
      </counter>
      <counter></counter>
    </div>
  `
})

app.component('counter', {
  template:`
    <div>
      123
      <slot>default content</slot>
    </div>
  `
})
```

有时候需要同时传递多个内容到子组件中，子组件需要决定这些内容的存放位置，这时仅靠单纯的slot标签就不行了，但是如果给每个插槽指定名字，就能方便的区分不同的内容了，这样的插槽叫做具名插槽

> `v-slot can only be used on components or <template> tags.`

```js
const app = Vue.createApp({
  template: `
    <div>
      <layout>
        <template v-slot:header>
          <div>header</div>
        </template>
        <template v-slot:footer>
          <div>footer</div>
        </template>
      </layout>
    </div>
  `
})

app.component('layout', {
  template:`
    <div>
      <slot name="header"></slot>
      <div>content</div>
      <slot name="footer"></slot>
    </div>
  `
})
```

具名插槽的语法可以简写为`#`

```js
const app = Vue.createApp({
  template: `
    <div>
      <layout>
        <template #header>
          <div>header</div>
        </template>
        <template #footer>
          <div>footer</div>
        </template>
      </layout>
    </div>
  `
})
```

我们知道父子组件中的数据是有自己的作用域的，在组件中使用数据，会优先查找自己的数据，所以如果在父组件中进行插槽内容传递时想要使用子组件中的数据，就需要用到特殊的语法**作用域插槽**了

```js
const app = Vue.createApp({
  template: `
    <div>
      <list v-slot="slotProps">
        <div>{{ slotProps.item }}</div>
        <span>{{ slotProps.item }}</span>
      </list>
    </div>
  `
})

app.component('list', {
  data() { return { list: [1, 2, 3] } },
  template:`
    <div>
      <slot v-for="item in list" :item="item" />
    </div>
  `
})
```

可以使用es6的解构语法

```js
const app = Vue.createApp({
  template: `
    <div>
      <list v-slot="{item}">
        <div>{{ item }}</div>
        <span>{{ item }}</span>
      </list>
    </div>
  `
})
```

##### 6.6 动态组件

有时候我们希望去控制子组件的显隐，如果通过用`v-show`指令去控制，可能代码量会比较大，这时可以利用动态组件去简化代码，通过`is`属性动态绑定一个动态的值来指定需要显示的子组件

```js
const app = Vue.createApp({
  data() { return { currentIem: 'input-item' } },
  template: `
    <div>
      <component :is="currentItem" />
      <input-item v-show="currentIem === 'input-item'" />
      <common-item v-show="currentIem === 'common-item'" />
    </div>
  `
})

app.component('input-item', {
  template:`
    <input />
  `
})

app.component('common-item', {
  template:`
    <div>hello</div>
  `
})
```

动态组件在显隐切换时有时会丢失一些数据（比如在input框中输入的数据），这时可以使用`keep-alive`标签将动态组件的数据缓存起来，确保不会丢失

```js
<keep-alive>
  <component :is="currentItem" />
</keep-alive>
```

##### 6.7 异步组件

平时我们调用的普通组件里如果内容都是写死的，那就是同步组件，如果组件有异步行为，则需要定义异步组件

```js
const app = Vue.createApp({
  data() { return { currentIem: 'input-item' } },
  template: `
    <div>
      <async-common-item></async-common-item>
    </div>
  `
})

app.component('async-common-item', Vue.defineAsyncComponent(() => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve({
        template: `<div>this is an async component</div>`
      })
    }, 3000) // 异步组件在3s后加载到页面上
  })
}))
```

#### 7 高级语法

##### 7.1 `mixin` 混合

混合可以编写一些通用的代码，方便各个组件混合使用

> 如果混合的`data`、`methods`与组件的`data`、`methods`存在重复的情况，那么组件中的`data`、`methods`优先级更高
>
> 生命周期函数不会覆盖，而是都会存在，先执行混合里面的生命周期函数，再执行组件的生命周期函数

```js
const myMixin = {
  data() {
    return {
      number: 2,
      count: 2
    }
  },
  methods: {
    handleClick() {
      console.log(this.number);
    }
  },
  created() {
    console.log('mixin created')
  }
}

const app = Vue.createApp({
  mixins: [myMixin],
  // data() {
  //   return {
  //     number: 1
  //   }
  // },
  methods: {
    handleClick() {
      console.log(this.number);
    }
  },
  created() {
    console.log('created')
  },
  template: `
    <div>
      <div @click="handleClick">{{ number }}</div>
      <div>{{ count }}</div>
    </div>
  `
})
```

上面的写法是局部混合，想要使用混合必须先引入混合，我们也可以定义全局的`mixin`，这种写法，组件不需要写`mixins`属性引入，可以直接使用全局混合中的数据和方法

> 不太推荐使用全局mixin，代码不太容易维护

```js
app.mixin({
  data() {
    return {
      number: 2,
      count: 2
    }
  },
  methods: {
    handleClick() {
      console.log(this.number);
    }
  },
  created() {
    console.log('mixin created')
  }
})
```

> Vue3推出后，更推荐使用composition api，更容易维护，混合的数据方法不太直观，一个数据在当前组件中使用，如果出现问题，还需要定位到mixin中去查找数据，也由于混合策略可更改等原因，相同的数据也不容易定位问题

##### 7.2 自定义指令

有些操作dom的操作不容易复用，这时我们可以编写自定义指令来复用这些操作，比如定义一个输入框自动聚焦的指令

```js
const app = Vue.createApp({
  template: `
    <div>
      <input v-focus>
    </div>
    `
})
  
app.directive('focus', {
  mounted(el) {
    el.focus()
  }
})
```

这里定义的是全局自定义指令，指令中的mounted钩子函数会自动接收指令挂载上去的元素，然后对元素进行某些操作，局部指令可以如下定义

```js
const directives = {
  focus: {
    mounted(el) {
      el.focus()
    }
  }
}

const app = Vue.createApp({
  directives, // 引用局部自定义指令
  template: `
    <div>
      <input v-focus>
    </div>
    `
})
```

可以给自定义指令传值实现某些操作

```js
const directives = {
  pos: {
    mounted(el, binding) {  // binding是固定写法
      el.style.top = binding.value + 'px'
    },
    updated(el, binding) {  // updated是为了监听值更新时进行操作（这里的数据不是响应式的）
      el.style.top = binding.value + 'px'
    }
  }
}

const app = Vue.createApp({
  directives,
  data() {
    return {
      top: 100
    }
  },
  template: `
    <div>
      <input v-pos="top" class="header">
    </div>
    `
})
```

##### 7.3 插件

插件更容易封装一些通用功能

```js
const myPlugin = {
  install(app, options) {
    console.log(app, options) // 有了app和options就能编写一些通用的功能了
  }
}

const myPlugin = (app, options) => { // 插件写成函数也是可以的
  console.log(app, options)
}

const app = Vue.createApp({
  template: `
    <div>
      <my-title></my-title>
    </div>
    `
})

app.component('my-title', {
  template: `<div>title</div>`
})

app.use(myPlugin, {name: 'dell'})

const vm = app.mount('#root')
```

#### 8 composition api

在我们使用选项式api时，随着代码越来越多，页面会很长，查找代码需要来回跳跃，很麻烦

组合式api是vue3新增语法，解决了选项式api的一些缺点，

##### 8.1 setup函数

组合式api借助setup函数实现，setup函数在created实例被完全实例化之前执行，因此setup函数里面不能使用this关键字

```js
const app = Vue.createApp({
  template: `
    <div>
      <div>{{ name }}</div>
      <div @click="handleClick">{{ age }}</div>
    </div>
  `,
  methods: {
    test() {
      alert(123)
    }
  },
  setup(props, context) {
    this.test() // Uncaught TypeError: this.test is not a function
    return {
      name: 'james',
      age: 18,
      handleClick: () => {
        alert(123)
      }
    }
  }
})
```

可以通过`this.$options`获取setup函数

```js
const app = Vue.createApp({
  template: `
    <div>
      <div @click="test">{{ name }}</div>
      <div @click="handleClick">{{ age }}</div>
    </div>
  `,
  methods: {
    test() {
      console.log(this.$options.setup())
    }
  },
  setup(props, context) {
    return {
      name: 'james',
      age: 18,
      handleClick: () => {
        alert(123)
      }
    }
  }
})
```

##### 8.2 ref reactive 响应式

先来看一个普通的变量（非响应式），name是非响应式的，所以值的变化不会实时反映到页面上

```js
const app = Vue.createApp({
  template: `
    <div>
      <div>{{ name }}</div>
    </div>
  `,
  setup(props, context) {
    let name = 'james'
    setTimeout(() => name = 'jack', 2000)
    return { name }
  }
})
```

我们可以通过vue3的新语法让普通变量变成响应式变量

利用`ref`处理基础类型的变量

```js
const app = Vue.createApp({
  template: `
    <div>
      <div>{{ name }}</div>
    </div>
  `,
  setup(props, context) {
    const { ref } = Vue
    let name = ref('james')
    setTimeout(() => name.value = 'jack', 2000)
    return { name }
  }
})

const vm = app.mount('#root')
```

> 这里为什么修改的时候要修改value的原因，涉及到了响应式原理，ref会通过proxy对数据进行封装，数据变化时会触发模板的更新，普通数据会被封装成形如`proxy({ value: 'james' })`这样的响应式引用，因此改变值的时候需要改变封装的value

非基础类型用`reactive`处理

```js
const app = Vue.createApp({
  template: `
    <div>
      <div>{{ name }}</div>
      <div>{{ nameObj.name }}</div>
    </div>
  `,
  setup(props, context) {
    const { ref, reactive } = Vue
    let name = ref('james')
    const nameObj = reactive({ name: 'james' })
    setTimeout(() => name.value = 'jack', 2000)
    setTimeout(() => nameObj.name = 'jack', 2000)
    return { name, nameObj }
  }
})
```

利用`readonly`可以将响应式变量变为只读变量，修改将会触发vue警告

```js
const app = Vue.createApp({
  template: `
    <div>
      <div>{{ nameObj[0] }}</div>
      <div>{{ copyNameObj[0] }}</div>
    </div>
  `,
  setup(props, context) {
    const { reactive, readonly } = Vue
    const nameObj = reactive([123])
    const copyNameObj = readonly(nameObj)
    setTimeout(() => nameObj[0] = 456, 2000)
    setTimeout(() => copyNameObj[0] = 456, 2000)  // Set operation on key "0" failed: target is readonly. 
    return { nameObj, copyNameObj }
  }
})
```

##### 8.3 toRefs

如果我们在模板中使用响应式变量的时候不想通过调用属性的方式使用，而是想要把属性解构出来直接使用可不可以呢

```js
const app = Vue.createApp({
  template: `
    <div>
      <div>{{ name }}</div>
    </div>
  `,
  setup(props, context) {
    const { reactive } = Vue
    const nameObj = reactive({ name: 'james' })
    setTimeout(() => nameObj.name = 'jack', 2000)
    const { name } = nameObj
    return { name }
  }
})
```

答案是不可以，因为此时你解构出来的只是一个普通变量，而不是响应式变量，要达到这种效果需要借助vue提供的api：`toRefs`，这样就能实现效果了

```js
const app = Vue.createApp({
  template: `
    <div>
      <div>{{ name }}</div>
    </div>
  `,
  setup(props, context) {
    const { reactive, toRefs } = Vue
    const nameObj = reactive({ name: 'james' })
    setTimeout(() => nameObj.name = 'jack', 2000)
    const { name } = toRefs(nameObj)
    return { name }
  }
})
```

> 原理是将解构出来的普通变量再次通过Proxy进行封装，这样普通变量就变成响应式变量了

##### 8.4 toRef 和 context

`toRef`是为了向对象里面取一个**可能不存在**的属性的时候使用的，这个属性仍然保持响应式特性（不太建议使用）

```js
const app = Vue.createApp({
  template: `
    <div>
      <div>{{ name }}</div>
      <div>{{ age }}</div>
    </div>
  `,
  setup(props, context) {
    const { reactive, toRefs, toRef } = Vue
    const nameObj = reactive({ name: 'james' })
    const { name } = toRefs(nameObj)
    const age = toRef(nameObj)
    setTimeout(() => name.value = 'jack', 1000)
    setTimeout(() => age.value = 18, 1000)
    return { name, age }
  }
})
```

通过context可以获取到一些常用的属性方法，比如用于获取non-props属性的`attrs`，slots插槽，emit触发事件等

```js
const { attrs, slots, emit } = context
```

##### 8.5 watch 和 watchEffect

watch具有一定的惰性，第一次页面刷新不会执行，只有监听的数据改变时才会执行，可以拿到原始值和变化后的当前值，可以监听多个数据的变化

> 监听对象时，需要使用函数返回监听的属性
>
> 惰性可以通过配置`{ immediate: true }`变为非惰性

```js
const app = Vue.createApp({
  template: `
    <div>
      <div>
        <input v-model="name" />
        <div>Name is {{ name }}</div>
        <input v-model="age" />
        <div>Name is {{ age }}</div>
      </div>
    </div>
  `,
  setup(props, context) {
    const { ref, reactive, watch, watchEffect, toRefs } = Vue
    // const name = ref('jack')
    // watch(name, (currentValue, preValue) => {
    //   console.log('preValue:', preValue)
    //   console.log('currentValue:', currentValue)
    // })
    const nameObj = reactive({
      name: 'james',
      age: 18
    })
    watch([() => nameObj.name, () => nameObj.age], ([curName, curAge], [preName, preAge]) => {
      console.log('curName:', curName)
      console.log('curAge:', curAge)
      console.log('preName:', preName)
      console.log('preAge:', preAge)
    }, { immediate: true })
    const {name, age} = toRefs(nameObj)
    return { name, age }
  }
})
```

`watchEffect`可以自动感知代码依赖，不需要传递特定参数进行监听，只需要传递一个回调函数就可以了，不能获取原始值和当前值，是非惰性的

```js
watchEffect(() => {
  console.log(nameObj.name)
  console.log(nameObj.age)
})
```

#### 9 vue cli

使用`npm`安装

```cmd
npm i @vue/cli
```

之后创建项目，选择选项之后回车创建

```cmd
vue create demo
```

cd到创建目录，运行项目，打开命令行中的链接就能到浏览器中看见项目了

```cmd
npm run serve
```

##### 9.1 工程结构

源码都放在 `src` 目录下面，`public` 目录下是 `index.html` 文件，提供挂载节点，`src` 目录下的 `main.js` 文件起工程入口的作用，初始代码如下：

```js
import { createApp } from 'vue'  // 由于cli工程是用webpack管理的，所以可以使用import语法导入需要的模块
import App from './App.vue'  // 导入组件

createApp(App).mount('#app')  // 将组件挂载到 index.html 文件的dom节点上
```

cli工程里面都是写成单文件组件的，一个vue文件就是一个单文件组件，在单文件里同时书写模板、逻辑和样式

```vue
<template>
  <div>
    <input v-model="inputValue" />
    <button class="button" @click="handleAddItem">提交</button>
  </div>
  <ul>
    <list-item
      v-for="(item, index) in list"
      :key="index"
      :msg="item"
    />
  </ul>
</template>

<script>
import { reactive, ref } from 'vue';
import ListItem from './components/ListItem';

export default {
  name: 'App',
  components: { ListItem },
  setup() {
    const inputValue = ref('');
    const list = reactive([]);

    const handleAddItem = () => {
      list.push(inputValue.value);
      inputValue.value = '';
    };
    return { handleAddItem, inputValue, list }
  }
}
</script>

<style>
  .button {
    margin-left: 20px;
    color: red;
  }
</style>
```

##### 9.2 vue router

路由就是根据url的不同，页面展示不同的内容。使用cli创建项目时选择vue router，然后项目就会加入router功能

`main.js`：

```js
import { createApp } from 'vue'
import App from './App.vue'
import router from './router' // 引入route模块

createApp(App).use(router).mount('#app')  // 使用route模块并且挂载到dom节点
```

`./router/index.js`：

```js
import { createRouter, createWebHashHistory } from 'vue-router' // 引入需要的模块
import HomeView from '../views/HomeView.vue'

const routes = [ // 创建路由
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/about',
    name: 'about',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    // 异步加载路由，首次访问首页时并不会加载这个路由，只有当点击访问时才会加载
    // 是否采用这种方式要看具体场景，需要首页加载快的时候，页面跳转速度可以慢一点的可以使用这种方式，比如后台管理系统
    // 而本身项目不大时，就用普通的同步加载就行了
    component: () => import(/* webpackChunkName: "about" */ '../views/AboutView.vue')
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router
```

> hash路由模式，会在url后面添加#号

`App.vue`：

```vue
<template>
  <nav>
    <!-- 跳转路由的标签，定义路由路径跳转链接 -->
    <router-link to="/">Home</router-link> |
    <router-link to="/about">About</router-link>
  </nav>
  <!-- 展示当前路由路径对应的组件内容的标签，路由路径变化时，显示的对应组件内容 -->
  <router-view/>
</template>
```

##### 9.3 vuex

vuex创建一个全局的仓库用于管理全局的数据。同样的，使用cli创建项目时选择vuex，然后项目就会加入vuex功能

`main.js`：

```js
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store' // 引入store模块

createApp(App).use(store).use(router).mount('#app')  // 使用store模块并且挂载到dom节点
```

`store/index.js`：

```js
import { createStore } from 'vuex'

export default createStore({
  state: {
    name: 'james'
  },
  getters: {
  },
  mutations: {
  },
  actions: {
  },
  modules: {
  }
})
```

页面如何获取vuex管理的数据 `name` 呢，可以通过一个vue的全局对象 `$store` 去获取

```vue
<template>
  <div class="about">
    <h1>This is an about page</h1>
    <h1>{{ myName }}</h1>
  </div>
</template>

<script>
export default {
  computed: {
    myName() {  // 一般会配合计算属性来返回需要的数据，不这样做也行，但可读性较差
      return this.$store.state.name
    }
  }
}
</script>
```

作为一个全局的数据仓库，不能随意地去直接修改里面的数据，需要一套规范的流程，vuex为我们设计了这样的一套数据存取流程

1. 想要修改vuex中的数据，首先需要通过动作（action）去触发修改操作，而动作需要派发（dispatch）

   ```js
   this.$store.dispatch('change')  // 派发了一个动作（动作名称是change）
   ```

2. 动作是不能无中生有的，必须得存在这个动作你才能派发，所以在vuex的仓库文件 `store/index.js`  中的 `actions` 配置对象中需要定义对应的动作

   ```js
   import { createStore } from 'vuex'
   
   export default createStore({
     state: {
       name: 'james'
     },
     getters: {
     },
     mutations: {
     },
     actions: {
       change() {  // 动作如果被派发，就会执行相应的代码
         console.log('change')
       }
     },
     modules: {
     }
   })
   ```

3. 在动作里面还是不能直接修改vuex中的数据，数据只能通过变异（mutation）去修改，因此需要在动作里面提交（commit）变异去修改数据，同理，变异方法需要提前定义好

   ```js
   import { createStore } from 'vuex'
   
   export default createStore({
     state: {
       name: 'james'
     },
     getters: {
     },
     mutations: {
       changeName() {  // 变异方法，修改 name 数据
         this.state.name = 'jack'
       }
     },
     actions: {
       change() {
         this.commit('changeName')
       }
     },
     modules: {
     }
   })
   ```

看到这里你也许会想，修改vuex的数据的流程大概就是

`派发动作（dispatch action） => 在动作中提交变异方法（commit mutation） => 变异方法修改数据（mutation change data）`

既然修改vuex的数据必须通过变异方法，那为什么非要通过动作去提交变异方法呢？省略动作直接提交变异方法不行吗？答案是可以，但得分情况

主要是看有没有异步行为，如果没有异步行为，那么可以绕过action，直接commit mutation

但是如果有异步行为，因为mutation的设计是只能存在同步行为的方法，所以异步操作只能放在action里面，因此这种情况必须通过action去提交mutation

将代码改为动态修改，派发动作并且携带参数

```js
export default {
  computed: {
    myName() {
      return this.$store.state.name
    }
  },
  methods: {
    handleClick() {
      this.$store.dispatch('change', 'jack')
    }
  }
}
```

异步修改vuex的数据

```js
import { createStore } from 'vuex'

export default createStore({
  state: {
    name: 'james'
  },
  getters: {
  },
  mutations: {
    changeName(state, name) {
      state.name = name
    }
  },
  actions: {
    change(store, name) {
      setTimeout(() => {
        store.commit('changeName', name)
      }, 2000)
    }
  },
  modules: {
  }
})
```

vue3的composition api中使用vuex

```js
import { useStore } from 'vuex'
import { toRefs } from 'vue'

export default {
  setup() {
    const store = useStore()
    const { name } = toRefs(store.state)
    const handleClick = () => {
      store.dispatch('change', 'jack')
    }
    return { name, handleClick }
  }
}
```

##### 9.4 axios

axios是用于发起网络请求的工具库，首先安装axios，具体使用参见 [axios官方文档](https://axios-http.com/zh/docs/intro)

#### 10 移动端实例

##### 10.1 vue cli 初始化工程目录

利用 vue cli 初始化工程目录，勾选 vue router 、vuex 、 sass 等创建项目

```cmd
vue create shop
```

项目创建完成后，可以将一些不要的组件和资源先删掉，完成项目的初始化

由于各端浏览器的样式表现是有差异的，所以需要对基础样式做一个初始化，这里我们不必手写基础样式，安装一个库即可解决

```cmd
npm i normalize.css --save
```

安装完成之后在 `main.js` 引入这个css文件

```js
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import 'normalize.css'

createApp(App).use(store).use(router).mount('#app')
```

然后因为是移动端项目需要使用rem适配屏幕，所以对rem需要设置根元素的字体大小，在 `src` 目录下新建 `style` 目录，再新建 `base.scss` 文件

```scss
html {
  font-size: 100px; // 1rem = 100px
}
```

接着继续在 `main.js` 中引入这个scss文件

```js
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import 'normalize.css'
import './style/base.scss'

createApp(App).use(store).use(router).mount('#app')
```

这样就完成了项目的初始化搭建

##### 10.2 首页布局

flex + box-sizing 常规布局，图标使用 iconfont

> iconfont引用方式：
>
> 1. 注册iconfont账号，创建新的项目，挑选图标加入购物车，将购物车里的图标加入项目
>
> 2. 在项目页面生成cdn的css代码，cdn是阿里的cdn，将字体文件存放到了cdn地址，复制生成的css代码，粘贴到工程目录的`style`目录下新建的的`iconfont.css`文件中
>
> 3. 在`main.js`中引入`iconfont.css`文件，即可在页面中使用iconfont图标了
>
>    `main.js`：
>
>    ```js
>    import { createApp } from 'vue'
>    import App from './App.vue'
>    import router from './router'
>    import store from './store'
>    import 'normalize.css'
>    import './style/base.scss'
>    import './style/iconfont.css'
>       
>    createApp(App).use(store).use(router).mount('#app')
>    ```
>
>    页面：
>
>    ```vue
>    <div class="iconfont icon-home"></div>
>    ```

优化代码：

到此为止我们在`main.js`中引入了两个自己写的css文件，可以将其合并为一个css文件引入，新建一个`index.scss`，在其中引入这两个css文件，然后再在`main.js`中引入`index.scss`即可

`index.scss`：

```scss
@import './base.scss';
@import './iconfont.css';
```

`main.js`：

```js
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import 'normalize.css'
import './style/index.scss'

createApp(App).use(store).use(router).mount('#app')
```

> 在vue3中，template中可以有不止一个根节点，vue3会自动在最终编译时加上一个根节点

对于变量，可以统一管理，新建一个`variables.scss`管理变量

```scss
$content-font-color: #333;
$active-color: #1FA4FC;
```

然后在页面中引入使用

```scss
@import "./style/variables.scss";

.location {
    color: $content-font-color;
}

&--active {
    color: $active-color;
}
```

对于常用css代码，可以封装起来使用，新建一个`mixins.scss`

```scss
@mixin ellipsis {
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}
```

页面中引入，然后使用封装的代码

```scss
@import "./style/variables.scss";
@import "./style/mixins.scss";

.location {
    position: relative;
    padding: .16rem 0;
    line-height: .22rem;
    font-size: .16rem;
    color: $content-font-color;
    @include ellipsis;
}
```

首页布局完成之后，如果全部代码都写到一个页面，首页代码会很长，不容易维护，因此可以将代码拆分为不同的组件，再将这些组件引入首页即可

`Docker.vue`：

```vue
<template>
</template>

<script>
export default {
  name: 'Docker' // 写不写都可以，写是为了方便vue调试工具调试，不写的话vue调试工具默认以文件名作为组件的显示名称
}
</script>

<style lang="scss" scoped>
@import "../style/variables.scss";
</style>
```

`App.vue`：

```vue
<template>
  <Docker />
</template>

<script>
import Docker from '@/views/Docker.vue'

export default {
  name: 'App',
  components: { Docker }
}
</script>

<style lang="scss" scoped>
@import "./style/variables.scss";
@import "./style/mixins.scss";
</style>
```

##### 10.3 登录页拦截（路由守卫）

创建登录组件`Login.vue`和主页组件`Home.vue`，在首页组件`App.vue`中只需要定义好路由视图标签

`App.vue`：

```vue
<template>
  <router-view />
</template>

<script>
export default {
  name: 'App'
}
</script>

<style lang="scss" scoped>
</style>
```

然后编辑路由文件`src/router/index.js`，将登录组件`Login.vue`和主页组件`Home.vue`引入，然后定义好访问路径，这样访问指定路径时，首页组件就会展示指定的组件

```js
import { createRouter, createWebHashHistory } from 'vue-router'
import Login from '@/views/Login.vue'
import Home from '@/views/Home.vue'

const routes = [
  {
    name: 'Login',
    path: '/login',
    component: Login
  },
  {
    name: 'Home',
    path: '/',
    component: Home
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router
```

接着编辑路由守卫，通过登录组件拦截未登录的访问

```js
import { createRouter, createWebHashHistory } from 'vue-router'
import Login from '@/views/Login.vue'
import Docker from '@/views/Docker.vue'

const routes = [
  {
    name: 'Login',
    path: '/login',
    component: Login
  },
  {
    name: 'Docker',
    path: '/',
    component: Docker
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

// to表示要访问的路径，from表示从哪个路径访问而来，next是放行函数，可以放行至指定组件
router.beforeEach((to, from, next) => {
  console.log(to, from)
  const isLogin = false // 模拟未登录的情况
  if (isLogin || to.name === 'Login') {
    next()
  } else {
    next({ name: 'Login' })
  }
})

export default router
```

已经登录的情况下再次访问登录页跳转回主页

```js
const routes = [
  {
    name: 'Login',
    path: '/login',
    component: Login,
    beforeEnter (to, from, next) {
      const isLogin = true
      if (isLogin) {
        next({ name: 'Home' })
      } else {
        next()
      }
    }
  },
  {
    name: 'Home',
    path: '/',
    component: Home
  }
]
```











































