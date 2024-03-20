#### 1 JS历史介绍
- 概念：一门客户端脚本语言，运行在客户端浏览器中的 每一个浏览器都有JavaScript的解析引擎
- 脚本语言：不需要编译，直接就可以被浏览器解析执行了
- 功能：可以来增强用户和html页面的交互过程，可以来控制html元素，让页面有一些动态的效果，增强用户的体验

- JavaScript发展史：
  - 1992年，Nombase公司，开发出第一门客户端脚本语言，专门用于表单的校验 命名为：C--，后来更名为：ScriptEase
  - 1995年，Netscape(网景)公司，开发了一门客户端脚本语言：LiveScript 后来，请来SUN公司的专家，修改LiveScript，命名为JavaScript
  - 1996年，微软抄袭JavaScript开发出JScript语言
  - 1997年，ECMA(欧洲计算机制造商协会)，制定出客户端脚本语言的标准：ECMAScript，就是统一了所有客户端脚本语言的编码方式
- JavaScript = ECMAScript + JavaScript自己特有的东西(BOM + DOM)
- ECMAScript：客户端脚本语言的标准规范，但是它只是规范，不规定如何实现规范，规范的实现比较主流的是 Chrome 的 V8 引擎，包括Nodejs也是基于这个引擎实现的

#### 2 引用方式
- 内部JS：定义`<script>`，标签体内容就是js代码

- 外部JS：通过`<script>`的src属性引入外部的js文件

>注意：
>`<script>`可以定义在html页面的任何地方 但是**定义的位置会影响执行顺序**
>
>`<script>`可以定义多个
>
>使用了src属性的`<script>`元素不应该再在`<script></script>`标签中再包含其他JavaScript代码，如果两者都提供的话，则浏览器只会下载并执行脚本文件，从而忽略行内代码
>
>`<script>`元素的一个最为强大、同时也备受争议的特性是，它可以包含来自外部域的JavaScript文件
>
>不管包含的是什么代码，浏览器都会按照`<script>`在页面中出现的顺序依次解释它们，前提是它们没有使用 defer 和 async 属性，第二个`<script>`元素的代码必须在第一个`<script>`元素的代码解释完毕才能开始解释，第三个则必须等第二个解释完，以此类推
>
>现代 Web 应用程序通常将所有JavaScript引用放在`<body>`元素中的页面内容后面，因为页面在浏览器解析到`<body>`的起始标签时开始渲染，如果放到`<head>`中则会增加页面加载时间
>
>`<noscript>`是在脚本不可用时让浏览器显示一段话

#### 3 注释

ECMAScript采用C语言风格的注释

```js
  // 单行注释

  /* 多行注释
     多行注释 */
```

#### 4 变量

在ECMAScript 中一切都区分大小，比如 `Typeof` 是一个完全有效的函数名，因为首字母大写了和关键字不一样

ECMAScript 变量是**松散类型**的，意思是变量可以用于保存任何数据类型的数据

变量就是一小块存储数据的内存空间，js 属于弱类型语言，不同于 Java 等强类型语言在定义了变量将来要存储的数据的数据类型后就只能存储固定类型的数据，js 定义变量时不定义变量将来的存储数据类型，而是赋值的时候再去确定，同一个变量的数据类型可根据赋值改变
```js
// 先定义，后赋值
var apple
apple = 2
apple = true

// 定义的时候直接赋值
var apple = 'big red apple'
```
变量不声明不赋值就直接使用会报错

只声明不赋值，变量默认保存特殊值 `undefined`

变量标识符使用驼峰命名，第一个单词的首字母小写，后面每个单词的首字母大写

在 ES6 之前，不声明就直接赋值可以使用，但是变量会变为挂载到全局对象`window`上的一个属性，成为全局变量，node环境下是挂载到全局对象`global`上

```js
var a = 1;
b = 2;  // window.b = 2 或 global.b = 2
delete b;
console.log(global.b);  // undefined
```

##### 4.1 基本数据类型

也叫值类型

| 数据类型  | 解释                                                         | 默认值    |
| :-------- | ------------------------------------------------------------ | :-------- |
| Number    | 数字类型，包括整数、浮点数、NaN（not a number 不是一个数字的数字类型（?））、Infinity | 0         |
| String    | 字符串类型，包括 "abc"、"a"、'abc'                           | ''        |
| Boolean   | 布尔类型，true 或 false 在 js 中等价于 1 或 0                | false     |
| Null      | 一个对象为空的占位符                                         | null      |
| Undefined | 未定义类型，如果一个变量只有声明没有赋值，则其值为undefined  | undefined |
| Symbol    | 象征类型，通常用于获取唯一值，比如让对象属性使用唯一标识符，不会发生属性冲突的危险 |           |
| BigInt    | 大整数类型，表示非常大的整数，解决 number 无法安全表示大于`2^53 - 1`的整数的问题 |           |

- 数字类型

  八进制前面加 `0` 表示

  十六进制前面加 `0x` 表示
  
  ```js
  // 数字类型的最大值
  console.log(Number.MAX_VALUE)
  // 数字类型的最小值
  console.log(Number.MIN_VALUE)
  // 无穷大
  console.log(Infinity)
  // 无穷小
  console.log(-Infinity)
  // 非数字
  console.log(NaN)
  ```

  可以用 `isNaN()` 函数判断变量是否为数字类型，是返回 false，否返回 true
  
  ```js
  var num = 12
  console.log(isNaN(num)) // false
  ```
  NaN 六亲不认，连自己都不认，NaN 参与的 === 运算比较结果全部为 false，isNaN 除外
  
- 字符串类型

  字符串是由 `""` 或 `''` 包括起来的任意文本，因为 HTML 中用 `""` 更多，所以在 js 中推荐使用 `''`

  字符串有很多方法和属性，其中属性 `length` 表示字符串的长度

  字符串可以用 `+` 拼接，其他类型的变量也会变成字符串

- 布尔类型

  与数字类型运算时，true看作是1，false看作是0
##### 4.2 引用数据类型

对象、函数等

##### 4.3 数据类型的转换
通常从表单或者prompt等输入框获取过来的值**都是字符串类型**的数据，有时候需要进行数据类型的转换
###### 4.3.1 转为字符串
- `toString()`

- `String()`

- 加号拼接（隐式转换）

```js
var num = 6
console.log(num.toString())
console.log(String(num))
console.log(num + '')
const c = true + '10' // 'true10'
```
###### 4.3.2 转为数字

常用的有两种

- `parseInt()`

  转为整数，如果字符串是小数，那么**向下取整**，如果字符串内不是符合要求的数字，结果是`NaN`

  ```js
  console.log(parseInt('3'))  // 3
  console.log(parseInt('3.14'))  // 3
  console.log(parseInt('3.99'))  // 3
  console.log(parseInt('3p'))  // 3
  console.log(parseInt('p3'))  // NaN
  console.log(parseInt('.3'))  // NaN
  ```

- `parseFloat()`

  转为浮点数，用法基本和上面个一样

  ```js
  console.log(parseFloat('3')) // 3
  console.log(parseFloat('3.14')) // 3.14
  console.log(parseFloat('3.99')) // 3.99
  console.log(parseFloat('3p')) // 3
  console.log(parseFloat('p3')) // NaN
  console.log(parseFloat('.3')) // 0.3
  ```
  
- `Number()`

  字符串里面不能出现字母，否则结果是`NaN`

  ```js
  console.log(Number('3')) // 3
  console.log(Number('3.14')) // 3.14
  console.log(Number('3.99')) // 3.99
  console.log(Number('3p')) // NaN
  console.log(Number('p3')) // NaN
  console.log(Number('.3')) // 0.3
  ```

- 利用减乘除

###### 4.3.1 转为布尔值

使用`Boolean()`函数转换，代表空或否定的值转为false，否则为true

```js
console.log(Boolean(''))  // false
console.log(Boolean(0))  // false
console.log(Boolean(NaN))  // false
console.log(Boolean(null))  // false
console.log(Boolean(undefined))  // false
console.log(Boolean(1))  // true
console.log(Boolean(-1))  // true
console.log(Boolean('string'))  // true
```

##### 4.4 获取变量数据类型
可以使用 `typeof` 运算符来获取一个变量的数据类型

```js
let a
let b = null
let c = 1
let d = 'd'
let e = () => {}
let f = {}
let g = true
let h = Symbol('s')

console.log(typeof a) // undefined
console.log(typeof b) // object
console.log(typeof c) // number
console.log(typeof d) // string
console.log(typeof e) // function
console.log(typeof f) // object
console.log(typeof g) // boolean
console.log(typeof h) // symbol
console.log(typeof 42n) // bigint，ES11新增，表示任意大的整数

var age = prompt('please input your age:')
console.log(typeof age)  // string
```

#### 5 运算符

用于赋值、比较、运算等功能的符号

##### 5.1 算术运算符

就是普通的加减乘除和取余，但是要注意浮点数直接参与运算时可能会发生精度问题，所以 js 不要直接拿浮点数参与运算，浮点数丢给后端运算，或者把浮点数变为整数再去运算

```js
console.log(1 + 1) // 2
console.log(0.1 + 0.2) // 0.30000000000000004
console.log(1 - 1) // 0
console.log(1 * 2) // 2
console.log(0.07 * 100) // 7.000000000000001
console.log(2.2 / 2) // 1.1
console.log(10 / 3) // 3.3333333333333335
console.log(4 % 2) // 0
console.log(9 % 2) // 1
console.log(1 % 2) // 1

console.log(0.3 == 0.1 + 0.2)  // false
```

##### 5.2 一元运算符

只有一个运算数参与运算的运算符，有自增自减和正负号

- 自增自减

  在变量前面或后面写上自增自减的符号，表示自己增加1或者减少1

  ```js
  var num = 5
  num++ // 单行的num++和++num是等价的
  console.log(num++) // 6，先输出变量值，然后自增
  console.log(num + 1) // 8
  
  console.log(--num) // 6，普通的加1不会对变量本身产生影响
  console.log(num++ + 1) // 7
  console.log(num)  // 7
  console.log(num++ + ++num) // 16
  ```
  
  > 注意自增自减符号在变量的前后，当变量在表达式中是有区别的：
  >
  > 1. 在前表示变量会**先自增或自减**，然后**变量自增或自减的结果**参与整个表达式的运算
  >
  > 2. 在后表示变量**先参与整个表达式的运算**，然后再自增或自减
  >
  > 但是如果变量不在一个表达式里面，而是单独成一行，那么这个时候自增自减运算符的前后顺序不会产生影响，最终结果是一样的

##### 5.3 比较运算符

判断两个数是否相等用普通的比较 `==`

数字类型和别的类型比较，别的类型会先转换为数字类型再进行比较

字符串之间的比较会按照字典顺序比较

如果还需要判断类型则可以使用全等 `===`，全等 `===` 会先判断比较的类型是否一致，不一致直接返回false，如果类型一致再进行数值的比较

```js
console.log(3 > 5) //false
console.log(3 < 5) //true
console.log(3 < '5') //true
console.log(3 < 'a') //false
console.log(2 > true) //true
console.log('a' > 'b') //false

console.log(3 <= 5) //true
console.log(3 >= 5) //false

console.log(3 == 3) //true
console.log(3 == '3') //true
console.log(0 == '') //true
console.log(0 == false) //true
console.log(false == '') //true
console.log(null == undefined) //true

console.log(2 != 3) //true
console.log(3 === '3') //false
console.log(3 !== '3') //false
```
所以如果是判断null可以用两等，因为节约了代码量，而在别的地方为了避免出现错误的概率，一律使用全等
```js
if(a == null) {...}
// 相当于
if(a === null || a === undefined) {...}
```

##### 5.4 逻辑运算符

用于多条件的判断，返回值是布尔值，有三个分别是与或非

| &&   | 运算符两边都为true，结果才为true |
| ---- | -------------------------------- |
| \|\| | 运算符有一边为true，结果就为true |
| !    | 取反，结果与表达式相反           |

**在逻辑运算时，其它类型会先转为布尔类型：**

1. 数字类型的 0 或 `NaN` 转为false，别的数字转为true

2. 字符类型的 `''` 转为false，别的字符串转为true

3. `null` 和 `undefined` 转为false，普通对象转为true

>由于上诉特性，与和或会表现出短路的现象：
>
>- 与运算时，前面为false，那么最终结果肯定是false，所以计算机就不会去计算与运算符后面的表达式了
>
>- 或运算同理，前面为true，那么最终结果肯定是true，所以计算机就不会去计算或运算符后面的表达式了
>
>这种现象叫做短路与（短路或）

```js
console.log(123 && 456) //456
console.log(0 && 456) //0
console.log(123 || 456) //123
console.log(0 || 456) //456
```

##### 5.5 赋值运算符

用于赋值，常用`=`，还有`+=`、`-=`、`*=`、`/=`、`%=`等，表示先运算再赋值给变量

```js
var num = 5
num += 2  // 等价于 num = num + 2
console.log(num)  // 7
```

##### 5.6 三元运算符

通过判断条件来判断该用哪一个表达式的值，公式：`判断条件 ? 表达式1 : 表达式2`，如果判断条件为true则用表达式1的值，否则用表达式2的值

```js
var time = prompt('请输入时间（0~59）：')
var result = time < 10 ? '0' + time : time
console.log(result)  // 06
```

##### 5.7 类型运算符

用于获取变量的类型

- `instanceof`：检测构造函数的 `prototype` 属性是否出现在某个实例对象的原型链上，返回布尔值
- `typeof`：获取获取变量的数据类型，返回数据类型

>`instanceof` 用于检测对象，而 `typeof` 用于检测变量，不管是值类型还是引用类型
>
>如果表达式 `obj instanceof Foo` 返回 `true`，则并不意味着该表达式会永远返回 `true`，因为 `Foo.prototype` 属性的值有可能会改变，改变之后的值很有可能不存在于 `obj` 的原型链上，这时原表达式的值就会成为 `false`。另外一种情况下，原表达式的值也会改变，就是改变对象 `obj` 的原型链的情况，虽然在目前的ES规范中，我们只能读取对象的原型而不能改变它，但借助于非标准的 `__proto__` 伪属性，是可以实现的。比如执行 `obj.__proto__ = {}` 之后，`obj instanceof Foo` 就会返回 `false` 了


##### 5.8 运算符优先级

记住常用的就好，**不行就加括号**

`括号 > 一元运算符 > 算数运算符 > 关系运算符 > 相等运算符`

##### 5.9 可选链

可选链解决了获取对象属性时，中间或者前置属性不存在时返回错误的问题，ES11新特性

可选链 `?.` 前面的值是 `undefined` 或 `null` 时，会停止计算（可理解为短路，后面的代码将不会执行）并且返回 `undefined`

比如：`value?.prop` 和 `value.prop` 在 `value` 存在时是等价的，而 `value` 不存在时，前面个表达式会返回 `undefined`

所以如果想访问多个属性嵌套的属性时可以连续使用可选链进行访问：`alert(user?.address?.street)`

可选链也可以配合dom选择器：`let html = document.querySelector('.elem')?.innerHTML`，如果没有符合的元素，则 `html` 的值为 `undefined`

> 1. 不要过度使用可选链，会造成调试困难，因为可能会隐藏某些错误，比如 user 必须存在，而其属性可有可无，就应该这样写：`user.address?.street`，而不是 `user?.address?.street`，这样在 user 不存在时我们可以及时发现报错
> 2. 可选链前的变量必须已声明，否则会触发引用错误 `ReferenceError: user is not defined`
> 3. 可选链不是运算符而是特殊语法，可以与 `()` 、`[]` 配合使用调用方法或者访问属性，`userAdmin.admin?.()` 当 `admin` 方法存在时将会调用，否则不调用，`user?.[key]`，user 不存在则返回 undefined
> 4. 可选链用于读取，但不能用于写入

#### 6 流程控制

代码的执行顺序对程序的结果有着直接的影响，而流程控制就是控制代码的执行顺序的

##### 6.1 条件判断

有的时候，我们需要让代码在满足某些条件的时候才去执行，这时就需要进行条件判断了

- if else

  用`if`进行**条件判断**，条件为真则执行`{}`中的语句，否则执行`else`里面的语句，如果没有加`else`只有`if`，那么跳过语句的执行，转而执行下面的代码，条件判断还可以设置多个条件，用`else if`设置多个判断条件，一旦满足条件，**立即执行语句，然后结束整个`if`语句**

  需要注意的是，if 判断的可以是布尔值，也可以是 truly 或 falsely 变量

  > truly 变量：两步取反后为真的变量
  >
  > falsely 变量：两步取反后为假的变量
  >
  > ```js
  > // 除了以下为 falsely 变量外都是 truly 变量
  > console.log(!!0 === false) // true
  > console.log(!!NaN === false) // true
  > console.log(!!'' === false) // true
  > console.log(!!null === false) // true
  > console.log(!!undefined === false) // true
  > console.log(!!false === false) // true
  > ```

  如果条件判断里面是falsely变量，则不会执行 if 语句块中的语句

  逻辑判断同理，也是判断的 truly 变量，而不是简单的布尔值

  ```js
  console.log(10 && 0)  // 0
  console.log('' || 'abc')  // 'abc'
  console.log(!window.abc)  // true
  ```

  if 判断的一个例子

  ```js
  // 判断闰年
  var year = prompt('请输入年份：')
  if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
    alert('闰年')
  } else {
    alert('平年')
  }
  
  // 判断成绩
  var score = prompt('请输入成绩：')
  if (score >= 90) {
    console.log('A')
  } else if (score >= 80) {
    console.log('B')
  } else if (score >= 70) {
    console.log('C')
  } else if (score >= 60) {
    console.log('D')
  } else {
    console.log('E')
  }
  ```

- switch

  和 if 判断类似，主要实现多分支语句的判断，并且**当变量的特定值作为判断条件时**，而不是进行范围的判断时，switch比 if 更加合适

  switch判断会直接跳到满足case条件的地方执行，不会像 if else 一样从上到下挨着判断，所以执行效率更高

  如果都不满足case条件，则执行default语句

  switch的条件通常写成一个变量而不写表达式，以方便判断

  switch条件和case条件的比较是**全等关系**，需要同时判断类型和值是否相等

  满足case条件且执行语句后，需要使用break跳出switch语句的执行，否则会有case语句穿透的问题，也就是说如果不写break，那么会执行接下去的case语句，不管有没有匹配上条件都会执行，直到遇见break为止或者执行default

  ```js
  // 由于没有加break，最后控制台打印的是： 1  2
  var num = 3 - 2
  switch (num) {
    case 1:
      console.log('1')
      // break
    case 2:
      console.log('2')
      break
    case 3:
      console.log('3')
      break
    default:
      console.log('no matching')
  }
  ```

##### 6.2 循环

循环是为了让**程序编写**更加高效，让某些代码重复执行

- for

  如果**循环次数是确定的**，那么通常使用for循环

  初始化变量语句只在循环中执行一次

  ```js
  for (var i = 1; i <= 3; i++) {
    console.log('外循环循环第' + i + '次')
    for (var j = 1; j <= 3; j++) {
      console.log('内循环循环第' + j + '次')
    }
  }
  
  // 外循环循环第1次
  // 内循环循环第1次
  // 内循环循环第2次
  // 内循环循环第3次
  
  // 外循环循环第2次
  // 内循环循环第1次
  // 内循环循环第2次
  // 内循环循环第3次
  
  // 外循环循环第3次
  // 内循环循环第1次
  // 内循环循环第2次
  // 内循环循环第3次
  ```


- while

  和for一样用于循环，不同的是while通常**循环次数不确定**

  当循环的**条件判断不仅仅是次数判断**时，用while会更清晰

  while容易写成死循环，应该在循环体里面更新计数器退出循环

  ```js
  var message = prompt('do you like it?')
  
  while (message !== 'yes') {
    message = prompt('do you like it?')
  }
  
  alert('me too')
  ```

- do while

  do while和while是基本一样的，不同的是do while会**至少执行一次**循环体

  ```js
  var message = prompt('do you like it?')
  
  do {
    message = prompt('do you like it?')
  } while (message !== 'yes')
  
  alert('me too')
  ```

>关键字continue和break：
>
>- continue：立即跳出当前循环，**继续**下一次循环
>- break：立即跳出当前循环，**结束**循环的执行

#### 7 数组

一个变量只能存储一个值，但是数组可以存储一组相关的数据，在js中数组不要求数据类型一致，可存放任意类型的数据，存放的每个数据叫做元素，数组是以单个变量的形式存储了多组数据

##### 7.1 创建数组

- 通过字面量

  ```js
  var arr = [1, 2, 3, 'a', true]
  ```

- 通过new

  ```js
  var arr = new Array() // 创建一个空数组
  var arr = new Array(3) // 创建一个长度为3的数组，里面有3个空元素
  var arr = new Array(2, 3) // 创建一个数组，里面有2个元素，分别是2和3
  ```

##### 7.2 获取数组元素

- 索引

  可以通过数值索引获取单个元素，数组索引从0开始，第一个元素的索引是0，使用索引获取数组中的元素

  索引越界也有获取结果，只不过是undefined

  ```js
  var arr = [1, 2, 3, 'a', true]
  console.log(arr[3]) // a
  console.log(arr[5]) // undefined
  ```

- 遍历

  如果要获取数组的所有元素，可以通过循环遍历，数组的长度可通过数组的属性length来获取，length的大小等于数组中的元素个数

  ```js
  var arr = [1, 2, 3, 'a', true]
  for (var i = 0; i < arr.length; i++) {
    console.log(arr[i])
  }
  ```

##### 7.3 修改数组元素

js的数组是非常自由的，可以随意添加数组元素

- 直接修改数组长度
- 直接给新的数组元素赋值
- `push()`可在数组尾部添加多个数组元素，返回值是新数组的长度，原数组发生变化

> 1. 追加或删除数组元素时，没有指定值的元素将会是undefined
> 2. 如果元素已经存在则会被替换
> 3. 直接给**整个数组变量**赋值，那么和其它的js变量一样，会被直接替换为所赋的值

```js
var arr = [1, 2, 3, 'a', true]
arr.length = 2
console.log(arr)  // Array [ 1, 2 ]

arr[3] = 'b'
console.log(arr)  // Array(4) [ 1, 2, <1 empty slot>, "b" ]
console.log(arr[2])  // undefined
arr[0] = 0
console.log(arr) // Array(4) [ 0, 2, <1 empty slot>, "b" ]

var arrLength = arr.push(4, 5, true, 'a')
console.log(arrLength) // 7
console.log(arr) // Array(7) [ 1, 2, 3, 4, 5, true, "a" ]

arr = 'js变量也是自由的'
console.log(arr) // js变量也是自由的，数组被替换成了字符串

// 案例：筛选数组中大于等于77的数
var arr = [2, 3, 56, 78, 90, 77, 45, 87, 23]
var newArr = []
for (var i = 0; i < arr.length; i++) {
  if (arr[i] >= 77) {
    newArr[newArr.length] = arr[i]
  }
}
console.log(newArr) // Array(4) [ 78, 90, 77, 87 ]

// 案例：翻转数组中的元素顺序
var arr = [2, 3, 56, 78, 90, 77, 45, 87, 23]
var newArr = []
for (var i = arr.length - 1; i >= 0; i--) {
  newArr[newArr.length] = arr[i]
}
console.log(newArr) // Array(9) [ 23, 87, 45, 77, 90, 78, 56, 3, 2 ]

// 案例：冒泡排序
var arr = [2, 3, 56, 78, 90, 77, 45, 87, 23]
for (var i = 0; i < arr.length - 1; i++) {
  for (var j = 0; j < arr.length - i - 1; j++) {
    if (arr[j] > arr[j + 1]) {
      var temp = arr[j]
      arr[j] = arr[j + 1]
      arr[j + 1] = temp
    }
  }
}
console.log(arr)

// 纯数字交换
function exchangeNum(num1, num2) {
  num1 = num1 + num2
  num2 = num1 - num2
  num1 = num1 - num2
}
```

- `unshift()`可以在数组的首部添加数组元素，可添加多个数组元素，返回值是新数组的长度，原数组发生变化

  ```js
  var arr = [1, 2, 3]
  var re = arr.unshift('red', 'green', 'blue')
  console.log(arr) // Array(6) [ "red", "green", "blue", 1, 2, 3 ]
  console.log(re) // 6
  ```

- `pop()`可以删除数组的最后一个元素，只能删除一个元素，返回值是删除的那个元素，原数组发生变化

  ```js
  console.log(arr.pop()) // 3
  console.log(arr) // Array(5) [ "red", "green", "blue", 1, 2 ]
  ```

- `shift()`可以删除数组的第一个元素，只能删除一个元素，返回值是删除的那个元素，原数组发生变化

  ```js
  console.log(arr.shift()) // red
  console.log(arr) // Array(4) [ "green", "blue", 1, 2 ]
  ```


##### 7.4 数组方法
- `reverse()`

  翻转数组元素，返回值是翻转后的数组，原数组发生变化

  ```js
  var arr = ['red', true, null, undefined, 2, 3]
  console.log(arr.reverse())  // Array(6) [ 3, 2, undefined, null, true, "red" ]
  console.log(arr) // Array(6) [ 3, 2, undefined, null, true, "red" ]
  ```
  
- `sort()`

  排序数组元素，返回值是排序后的数组，原数组发生变化

  默认排序顺序是在将元素转换为字符串，然后比较它们的**UTF-16代码单元值序列**时构建的

  如果没有指明 `compareFunction` ，那么元素会按照转换为的字符串的诸个字符的Unicode位点进行排序，例如 "Banana" 会被排列到 "cherry" 之前

  当数字按由小到大排序时，比较的**数字会先被转换为字符串**，所以在Unicode顺序上 "18" 要比 "9" 要靠前，导致排序出错

  ```js
  var arr = [18, 9, 77, 1, 7]
  console.log(arr.sort()) // Array(5) [ 1, 18, 7, 77, 9 ]
  console.log(arr) // Array(5) [ 1, 18, 7, 77, 9 ]
  ```

  解决办法就是添加比较函数，下面的函数意思是按照**升序排序**

  ```js
  arr.sort(function (a, b) {
    return a - b
  })
  console.log(arr) // Array(5) [ 1, 7, 9, 18, 77 ]
  ```

  降序排序就返回相反的值

  ```js
  arr.sort((a, b) => b - a)
  console.log(arr) // Array(5) [ 77, 18, 9, 7, 1 ]
  ```

- `indexOf()`

  查找给定元素在数组中的索引，返回找到的第一个索引，没有找到返回 -1

  ```js
  var arr = ['red', 'green', 'red', 'blue', 'violet']
  console.log(arr.indexOf('red')) // 0
  console.log(arr.indexOf(2)) // -1
  ```

- `lastIndexOf()`

  查找给定元素在数组中的索引，返回找到的最后一个索引，没有找到返回 -1

  ```js
  console.log(arr.lastIndexOf('red')) // 2
  console.log(arr.lastIndexOf(2)) // -1
  ```

  案例：数组去重 （常用）

  遍历旧数组，通过查询索引得知元素在新数组中是否存在，存在就不保存，不存在则保存

  ```js
  var arr = ['red', 'green', 'red', 'blue', 'violet']
  var uniArr = unique(arr)
  console.log(uniArr) // Array(4) [ "red", "green", "blue", "violet" ]
  
  function unique(arr) {
    var newArr = []
    for (var k in arr) {
      if (newArr.indexOf(arr[k]) === -1) {
        newArr.push(arr[k])
      }
    }
    return newArr
  }
  ```

- `toString()`

  将数组元素以`,`作为分隔符拼接为字符串

  ```js
  var arr = ['red', 'green', 'red', 'blue', 'violet']
  console.log(arr.toString()) //  red,green,red,blue,violet
  ```

- `join()`

  将数组元素按照指定的分隔符拼接为字符串

  ```js
  console.log(arr.join()) //  red,green,red,blue,violet
  console.log(arr.join('-')) //  red-green-red-blue-violet
  console.log(arr.join('&')) //  red&green&red&blue&violet
  ```
  
- `concat()`

  拼接多个数组或者值，**原数组不会改变**，返回值是拼接好的**一个新数组**

  ```js
  // 拼接两个数组
  const array1 = ['a', 'b', 'c']
  const array2 = ['d', 'e', 'f']
  const array3 = array1.concat(array2)
  
  console.log(array1) // Array(3) [ "a", "b", "c" ]
  console.log(array2) // Array(3) [ "d", "e", "f" ]
  console.log(array3) // Array(6) [ "a", "b", "c", "d", "e", "f" ]
  
  // 拼接三个数组
  var num1 = [1, 2, 3]
  var num2 = [4, 5, 6]
  var num3 = [7, 8, 9]
  var nums = num1.concat(num2, num3)
  console.log(nums) // Array(9) [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
  
  // 拼接值
  console.log(nums.concat(10)) // Array(10) [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
  console.log(nums) // Array(9) [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
  ```

- `slice()`

  返回**一个新的数组**，新数组是由 `begin` 和 `end` 决定的原数组的**浅拷贝**（包括 `begin`，不包括`end`）

  原数组不会改变

  `begin`：如果该参数为负数，则表示从原数组中的倒数第几个元素开始提取，`slice(-2)` 表示提取原数组中的倒数第二个元素到最后一个元素（包含最后一个元素）

  `end`：如果该参数为负数， 则它表示在原数组中的倒数第几个元素结束抽取。 `slice(-2,-1)` 表示抽取了原数组中的倒数第二个元素到最后一个元素（不包含最后一个元素，也就是只有倒数第二个元素）

  ```js
  const animals = ['ant', 'bison', 'camel', 'duck', 'elephant']
  
  console.log(animals.slice()) // ['ant', 'bison', 'camel', 'duck', 'elephant']
  console.log(animals.slice(2)) // ['camel', 'duck', 'elephant']
  console.log(animals.slice(2, 4)) // ['camel', 'duck']
  console.log(animals.slice(1, 5)) // ['bison', 'camel', 'duck', 'elephant']
  console.log(animals.slice(-2)) // ['duck', 'elephant']
  console.log(animals.slice(2, -1)) // ['camel', 'duck']
  console.log(animals) // ['ant', 'bison', 'camel', 'duck', 'elephant']
  ```
  slice 方法可以用来将一个类数组（Array-like）对象/集合转换成一个新数组。你只需将该方法绑定到这个对象上。一个函数中的`arguments` 就是一个类数组对象的例子，关于 prototype 原型，参见本文 [14.4 原型](#)，关于 `call` ，参见本文 [16.1 this指向](#)

  ```js
  function list() {
    return Array.prototype.slice.call(arguments);
  }
  
  var list1 = list(1, 2, 3); // [1, 2, 3]
  ```

- `splice()`（常用）

  通过删除或替换现有元素或者原地添加新的元素来修改数组，并以数组形式返回被修改的内容，原数组发生改变

  ```js
  array.splice(start[, deleteCount[, item1[, item2[, ...]]]])
  ```
  `start`：
  
  不写的时候，会返回空数组
  
  指定修改的开始位置（从0计数）
  
  如果超出了数组的长度，则从数组末尾开始添加内容
  
  如果是负值，则表示从数组末位开始的第几位，如果负数的绝对值大于数组的长度，则表示开始位置为第0位
  
  `deleteCount`：
  
  可选，整数，表示要移除的数组元素的个数
  
  计数的时候包含开始位置，如果 `deleteCount` 是 0 或者负数，则不移除元素，**这种情况下，至少应添加一个新元素**
  
  返回值是由被删除的元素组成的一个数组
  
  ```js
  // 从索引 2 的位置开始删除 0 个元素，插入“drum”
  var myFish = ['angel', 'clown', 'mandarin', 'sturgeon']
  var removed = myFish.splice(2, 0, 'drum')
  console.log(removed) // []
  console.log(myFish) // [ "angel", "clown", "drum", "mandarin", "sturgeon" ]
  
  // 从索引 2 的位置开始删除 0 个元素，插入“drum” 和 "guitar"
  var myFish = ['angel', 'clown', 'mandarin', 'sturgeon']
  var removed = myFish.splice(2, 0, 'drum', 'guitar')
  console.log(removed) // []
  console.log(myFish) // [ "angel", "clown", "drum", "guitar", "mandarin", "sturgeon" ]
  
  // 从索引 3 的位置开始删除 1 个元素
  var myFish = ['angel', 'clown', 'drum', 'mandarin', 'sturgeon']
  var removed = myFish.splice(3, 1)
  console.log(removed) // [ "mandarin" ]
  console.log(myFish) // [ "angel", "clown", "drum", "sturgeon" ]
  
  // 从索引 2 的位置开始删除所有元素
  var myFish = ['angel', 'clown', 'mandarin', 'sturgeon']
  var removed = myFish.splice(2)
  console.log(removed) // [ "mandarin", "sturgeon" ]
  console.log(myFish) // [ "angel", "clown" ]
  ```

##### 7.5 数组检测
可以用运算符`instanceof`得知某变量是否为数组，也可以用来检测别的类型
```js
var arr = []
var obj = {}

console.log(arr instanceof Array) // true
console.log(arr instanceof Object) // true
console.log(obj instanceof Array) // false
console.log(obj instanceof Object) // true
```
H5新增`isArray()`方法

```js
console.log(Array.isArray(arr)) // true
console.log(Array.isArray(obj)) // false
```


#### 8 函数

代码难免会产生重复，比如功能一样的代码在各个地方都需要使用，那不可能每个地方都写一遍重复的代码吧，这时就可以把这些重复的代码只编写一次，然后给它起个名字，这样在需要调用重复代码时调用名字即可，这个名字和重复代码就分别代表了函数名和函数体

1. 函数可以没有形参，也可以有形参且不限个数，形参不需要指定类型（本来就是var）

2. 函数的声明不需要写在调用函数的地方的前面，因为有预解析

3. 函数的形参同样也是非常地freedom啊，可以传递与形参个数不匹配的实参进去

   如果实参个数大于形参的个数，那么多余的实参将不会被使用

   如果实参个数小于形参的个数，那么没有实参的形参将不会被赋值，也就是默认值undefined
   
   >在实际应用中最好让形参和实参的个数一致
   
   ```js
   getSum(1, 2) // 3
   getSum(2, 3) // 5
   getSum(2, 3, 5) // 5
   getSum(2) // NaN
   
   function getSum(num1, num2) {
     console.log(num1 + num2)
   }
   ```
   
4. 可以指定形参的默认值，不传递参数时就使用形参的默认值

   >如果想跳过中间的某个形参不传递参数使用默认值可以传递 `undefined`

   ```js
   getSum() // 5
   getSum(1) // 4
   getSum(undefined, 1) // 3
   
   function getSum(num1 = 2, num2 = 3) {
     console.log(num1 + num2)
   }
   ```


##### 8.1 返回值

函数可以有返回值，作为整个函数的运算结果返回给函数调用者

```js
var getMaxNum = function (num1, num2) {
  return num1 > num2 ? num1 : num2
}

var maxNum = getMaxNum(666, 6)
console.log(maxNum) // 666
```

> return执行之后，return后面的语句不会执行，相当于**终止了函数的执行**
>
> return**只能返回一个值**，如果用逗号分隔返回了多个值，则只会返回最后一个值
>
> 如果函数没有写return，则函数的返回值是undefined（因为函数也可以看做是特殊的变量，没有赋值，就是undefined）

##### 8.2 函数内置对象

  js的每个函数都有一个内置对象 arguments，可以在函数中直接使用，存储了外界传进去的所有实参，arguments 是一个伪数组对象（类数组对象），当我们不确定形参的个数时，可以使用arguments

```js
function arg() {
  console.log(arguments)
  console.log(arguments.length)
  console.log(arguments[1])
  for (var i = 0; i < arguments.length; i++) {
    console.log(arguments[i])
  }
}

arg(1, 2, 3)

// 打印结果：
// Arguments { 0: 1, 1: 2, 2: 3, … }
// 3
// 2
// 1
// 2
// 3
```

> 伪数组不具有push、pop等方法

#### 9 作用域

代码中的变量或者函数不是一直都可以使用的，而是只在某一部分区域或范围发生作用，变量或者函数发生作用的范围就是作用域，作用域可提高代码重用性，减少重名概率

**在 es6 之前**，js 作用域分为全局作用域和函数作用域，没有块级作用域，关于块级作用域参见本文 [18.1 let](#)

- 全局作用域

  全局作用域的作用范围是整个 js 文件，由于**变量提升**，变量定义的前后顺序会影响结果

  ```js
  function log() {
    console.log(num)
  }
  log()  // undefined
  
  var num = 10
  ```

  先定义变量再使用就正常了

  ```js
  var num = 10
  
  function log() {
    console.log(num)
  }
  
  log() // 10
  ```

  如果在函数中不声明直接给变量赋值，在函数执行之后，这个变量会变成全局作用域变量

  ```js
  function log() {
    num = 20
  }
  log()
  console.log(num) // 20
  ```

- 函数作用域

  函数的大括号内部就是一个局部作用域，作用范围是整个函数体

  ```js
  function log() {
    var num = 20
  }
  log()
  console.log(num) // Uncaught ReferenceError: num is not defined
  ```

  > 全局作用域变量只有在浏览器关闭时才会被销毁，是比较占用内存的，一般除非有必要，否则不要定义太多全局变量，而且太多全局变量也会带来维护上的困难
  >
  > 函数作用域变量在函数执行完毕后就会被销毁

- 作用域链

  如果在一个函数的定义中包含了另一个函数的定义，那就是在一个函数作用域中包含了另一个函数作用域

  由此我们可以知道内部函数的函数作用域是被包含在外部函数的函数作用域的范围里面的，因此在内部函数的函数作用域中可以访问到外部函数的函数作用域中的变量
  
  当我们在一个内部函数中访问一个变量时，会先查找内部函数的函数作用域中是否定义了该变量，如果没有定义，那这种变量就叫做**自由变量**，这时会在 **内部函数定义的地方** **内部函数定义的地方** **内部函数定义的地方** 的外一层的作用域（可能是函数作用域也可能是全局作用域）中继续查找，这样一直找到最外层的作用域，如果最后找到了全局作用域还是没有找到，就报错，这样一层一层的作用域查找形成了一个链条，这就是**作用域链**
  
  当一个函数访问了另一个函数中的变量，这种情况就产生了闭包，关于闭包参加本文 [16.4 闭包](#)
  
  如果内部函数的函数作用域中的变量和外部函数的函数作用域中的变量产生冲突时，外部函数的函数作用域中的变量会被屏蔽
  
  ```js
  var num = 10
  
  function fn() {
    var num = 20
    function fun() {
      console.log(num) // 20
    }
    fun()
  }
  
  fn()
  ```

#### 10 预解析

js 代码在浏览器中的执行需要分为两步，先是由 js 解析器进行预解析，然后再执行代码

预解析：

js 引擎先把 js 里面所有的变量声明和函数声明提升到当前作用域的最前面，但是预解析只是把变量的声明提升了，并没有提升赋值的操作，这就是变量提升，ES6解决了这个问题

由预解析的特性可解释如下代码：

1. ```js
   console.log(num) // undefined
   var num = 10
   ```
   相当于
   ```js
   var num
   console.log(num)
   num = 10
   ```
   
2. ```js
   fun() // Uncaught TypeError: fun is not a function
   var fun = function () {
     console.log('预解析')
   }
   ```
   相当于
   ```js
   var fun
   fun()
   fun = function () {
     console.log('预解析')
   }
   ```
   
3. ```js
   fun() // 预解析
   function fun() {
     console.log('预解析')
   }
   ```
   相当于
   ```js
   function fun() {
     console.log('预解析')
   }
   fun() // 预解析
   ```

4. ```js
   var num = 10
   fun()
   function fun() {
     console.log(num) // undefined
     var num = 20
   }
   ```
   相当于
   ```js
   var num
   function fun() {
     var num
     console.log(num)
     num = 20
   }
   num = 10
   fun()
   ```
   

#### 11 对象
保存一个值可以用变量，保存一组值可以用数组，那么保存一整套数据又该用什么呢，为了解决这个问题，我们需要使用对象，对象可以更加清晰地存储和表达这些信息

现实生活中的对象可以是一个具体的事物，比如笔记本电脑不是对象，因为是泛指，而我的华硕笔记本电脑才是对象，因为是具体的一个电脑，js里面的对象指的是一组无序的属性和方法的集合，所有的事物都是对象，如字符串、数值、数组、函数等

##### 11.1 属性

对象有属性，属性就是对象的特征、特点，就像一个人的高矮胖瘦一样，描述了对象的特征

##### 11.2 方法

对象有方法，方法就是对象的行为，就像一个人能做什么事情一样，描述了对象的能力

##### 11.3 创建对象

- 字面量

  很常用的方法，直接利用`{}`包含对象的属性和方法，然后把对象赋值给变量进行存储

  ```js
  var zhangsan = {
    name: '张三',
    age: 18,
    sex: '男',
    sayHi: function () {
      console.log('你好')
    }
  }
  ```

- new

  先 new 一个空对象，然后给对象赋值属性和方法

  ```js
  var zhangsan = new Object()
  zhangsan.name = '张三'
  zhangsan.age = 18
  zhangsan.sayHi = function () {
    console.log('你好')
  }
  
  console.log(zhangsan.name) // 张三
  console.log(zhangsan['age']) // 18
  zhangsan.sayHi() // 你好
  ```

- 构造函数（ES5）

  字面量和 new 一次只能创建一个对象，要创建新的对象需要写重复的属性和方法的代码，为此，我们可以将这些属性和方法封装到函数里面，这个函数就是构造函数，构造函数首字母应该大写

  构造函数类似于Java里的类，是创建对象的蓝图模板

  ```js
  function Star(name, age, sex) {
    this.name = name
    this.age = age
    this.sex = sex
    this.sing = function (song) {
      console.log(song)
    }
  }
  var liudehua = new Star('刘德华', 28, '男')
  console.log(liudehua.name) // 刘德华
  console.log(liudehua.age) // 28
  console.log(liudehua.sex) // 男
  liudehua.sing('17岁') // 17岁
  ```

  当调用new关键字的时候：

  1. 构造函数会在内存中先创建一个空的对象，
  2. 构造函数内部的this会指向这个新创建的对象
  3. 执行构造函数里面的赋值代码或者别的代码，给空对象添加属性和方法
  4. 返回这个对象

##### 11.4 调用对象属性方法

通过`.`来调用对象的属性和方法，或者通过`[]`也可以调用对象属性

```js
var zhangsan = {
  name: '张三',
  age: 18,
  sex: '男',
  sayHi: function () {
    console.log('你好')
  }
}

console.log(zhangsan.name) // 张三
console.log(zhangsan['age']) // 18
zhangsan.sayHi() // 你好
```

##### 11.5 遍历对象

普通的for不能遍历对象，要使用`for in`遍历对象的属性，遍历获得对象的键，通过键可以获取值

```js
function Star(name, age, sex) {
  this.name = name
  this.age = age
  this.sex = sex
  this.sing = function (song) {
    console.log(song)
  }
}

var liudehua = new Star('刘德华', 28, '男')

for (var k in liudehua) {
  console.log(k)
  console.log(liudehua[k])
}

// name
// 刘德华
// age
// 28
// sex
// 男
// sing
// function sing(song)
```
for in也可以遍历数组，但是当数组原型上有自定义属性时会将该属性也遍历出来，因此不推荐

如需遍历数组，可以使用for of，这种遍历方式遍历顺序是严格保证的，但是注意不会改变原数组

```js
const arr = [1, 2, 3]
for (let elem of arr) {
  elem = elem + 1
  console.log(elem)  // 2 3 4
}
console.log(arr)  // Array(3) [ 1, 2, 3 ]
```

如需遍历数组索引，可以使用keys，返回一个**新的数组迭代器对象**

```js
const arr = [1, 2, 3]
const indexIterator = arr.keys()
for (const index of indexIterator) {
  console.log(index)  // 0 1 2
}
console.log(indexIterator)  // Array Iterator {  }
```

如需同时遍历数组索引和元素，可以使用entries，返回一个**新的数组迭代器对象**

```js
const arr = ['a', 'b', 'c']
const arrIterator = arr.entries()
for (const [index, elem] of arrIterator) {
  console.log(index, elem)  // 0 a 1 b 2 c
}
console.log(arrIterator)  // Array Iterator {  }
```

##### 11.6 常用内置对象

内置对象就是 js 自带的对象，提供了一些常用的功能，这里介绍常用的内置对象及其属性方法，更多请查阅 MDN 文档

###### 11.6.1 Math

Math 对象不是构造函数，不需要使用 new 来调用，它的属性和方法都是静态的可以直接调用

- `PI`

  直接调用`π`的值

  ```js
  console.log(Math.PI) // 3.141592653589793
  ```

- `max()`

  max函数返回一组数中的最大值

  如果给定的参数中至少有一个参数无法被转换成数字，则会返回 `NaN`

  没有给定参数返回`-Infinity`

  ```js
  console.log(Math.max(1, 3, 2)) // 3
  console.log(Math.max(-1, -3, -2)) // -1
  const array1 = [1, 3, 2]
  console.log(Math.max(...array1)) // 3
  console.log(Math.max()) // -Infinity
  console.log(Math.max(1, 2, 3, 'string')) // NaN
  ```

- `abs()`

  abs函数返回一个数的绝对值

  传入一个非数字形式的字符串或者 undefined / empty 变量，将返回 `NaN`

  传入 null 将返回 0

  ```js
  console.log(Math.abs('-1')) // 1，隐式转换
  console.log(Math.abs(-2)) // 2
  console.log(Math.abs(null)) // 0
  console.log(Math.abs('string')) // NaN
  console.log(Math.abs()) // NaN
  console.log(Math.abs(undefined)) // NaN
  ```

- `ceil()`

  ceil函数返回大于或等于一个给定数字的最小整数，也就是向上取整

  ```js
  console.log(Math.ceil(0.95)) // 1
  console.log(Math.ceil(4)) // 4
  console.log(Math.ceil(7.004)) // 8
  console.log(Math.ceil(-7.004)) // -7
  ```

- `floor()`

  floor函数返回小于或等于一个给定数字的最大整数，也就是向下取整

  ```js
  console.log(Math.floor(45.95)) // 45
  console.log(Math.floor(45.05)) // 45
  console.log(Math.floor(4)) // 4
  console.log(Math.floor(-45.05)) // -46
  console.log(Math.floor(-45.95)) // -46
  ```

- `round()`

  round函数返回一个给定数字的四舍五入后的整数

  要注意 js 里面的 `.5`往大了取，和数学里的不太一样

  ```js
  console.log(Math.round(20.49)) // 20
  console.log(Math.round(20.5)) // 21
  console.log(Math.round(-20.5)) // -20
  console.log(Math.round(-20.51)) // -21
  ```

- `random()`

  random函数返回一个伪随机数，范围是`[0,1)`

  ```js
  console.log(Math.random()) //  0.5711357878457415
  ```

  获取两个整数之间的数，不包含较大的整数，如果要包含较大的整数，需要加1

  ```js
  function getRandomExcludeMax(min, max) {
    return Math.floor(Math.random() * (max - min)) + min
  }
  
  function getRandomIncludeMax(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min
  }
  
  console.log(getRandomExcludeMax(1, 5)) // 1
  console.log(getRandomIncludeMax(1, 5)) // 5
  ```

  案例：利用随机整数点名

  ```js
  var staffName = ['张三', '老王', '小李', '小红']
  var staffNo = getRandomIncludeMax(0, staffName.length - 1)
  console.log(staffName[staffNo])
  
  function getRandomIncludeMax(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min
  }
  ```

###### 11.6.2 Date

- 创建时间

  创建一个 `Date` 实例，该实例呈现时间中的某个时刻，自1970年1月1日（UTC）起经过的毫秒数

  创建一个新`Date`对象的唯一方法是通过`new`操作符

  可跟参数创建时间对象

  ```js
  var date = new Date()
  console.log(date) // Date Sun Nov 07 2020 22:03:12 GMT+0800 (中国标准时间)
  ```

- 格式化时间

  ```js
  var date = new Date('2020-11-7 8:8:8')
  console.log(date) // Date Sat Nov 07 2020 08:08:08 GMT+0800 (中国标准时间)
  var week = [
    '星期日',
    '星期一',
    '星期二',
    '星期三',
    '星期四',
    '星期五',
    '星期六'
  ]
  var year = date.getFullYear() // 年份
  var month = date.getMonth() + 1 // 月份，按0~11来算，所以获取正常月份应该要+1
  var dates = date.getDate() // 日期
  var day = date.getDay() // 星期，1~6 表示周一到周六，0 表示周日
  var hour = date.getHours() // 小时
  var minute = date.getMinutes() // 分钟
  var second = date.getSeconds() // 秒数
  
  console.log(year) // 2020
  console.log(month) // 11
  console.log(dates) // 7
  console.log(day) // 6，周几，
  console.log(hour) // 8
  console.log(minute) // 8
  console.log(second) // 8
  console.log(
    '今天是：' +
      year +
      '年' +
      month +
      '月' +
      dates +
      '日 ' +
      getTimes(date) +
      ' ' +
      week[day]
  )
  
  function getTimes(time) {
    var h = beautyTime(time.getHours())
    var m = beautyTime(time.getMinutes())
    var s = beautyTime(time.getSeconds())
    return h + ':' + m + ':' + s
  }
  
  function beautyTime(n) {
    return n < 10 ? '0' + n : n
  }
  ```

- 获取毫秒数

  获取设定的时间距离1970年1月1日的毫秒数

  总共有四种方法

  `+` 可以转换数据类型，很常用，可以直接在new的时候使用

  H5新增了 `now()` 获取，但是只能获取当前的时间

  ```js
  var date = new Date('2020-11-7 8:8:8')
  var msecond1 = date.valueOf()
  var msecond2 = date.getTime()
  var msecond3 = +date
  var msecond4 = +new Date('2020-11-7 8:8:8')
  var msecond5 = Date.now()
  console.log(msecond1) // 1604707688000
  console.log(msecond2) // 1604707688000
  console.log(msecond3) // 1604707688000
  console.log(msecond4) // 1604707688000
  console.log(msecond5) // 1606707982897
  ```
  获取毫秒数有什么用呢？我们知道时间是一直往前走的，特别是毫秒级的时间基本每次获取的当前毫秒数都是不一样的，所以又叫时间戳

  时间戳可以用来加密

  毫秒数可以用来比较两个时间的大小、计算两个时间的差值

  案例：倒计时

  ```js
  console.log(countDown('2020-11-7 8:8:8'))
  
  function countDown(time) {
    var nowTime = +new Date()
    var inputTime = +new Date(time)
    var times = (inputTime - nowTime) / 1000 // 毫秒换算为秒
    var d = parseInt(times / 60 / 60 / 24)
    var h = parseInt((times / 60 / 60) % 24)
    var m = parseInt((times / 60) % 60)
    var s = parseInt(times % 60)
    return (
      beautyTime(d) +
      '天' +
      beautyTime(h) +
      '时' +
      beautyTime(m) +
      '分' +
      beautyTime(s) +
      '秒'
    )
  }
  
  function beautyTime(n) {
    return n < 10 ? '0' + n : n
  }
  ```

##### 11.7 global全局对象

Global全局对象中封装的方法是静态方法，不需要写 `Global`对象直接写方法就可以调用

`encodeURI()`：用于 url 编码
`decodeURI()`：用于 url 解码
`encodeURIComponent()`：用于 url 编码，Component 编码的字符更多
`decodeURIComponent()`：用于 url 解码，Component 编码的字符更多
`isNaN()`：判断一个变量是否为 NaN
`eval()`：将字符串作为 js 代码来执行

```js
var str = 'http://www.baidu.com?wd=中文字符'
var encode = encodeURI(str)
console.log(encode) //  http://www.baidu.com?wd=%E4%B8%AD%E6%96%87%E5%AD%97%E7%AC%A6

var decode = decodeURI(encode)
console.log(decode) //  http://www.baidu.com?wd=中文字符

var str1 = 'http://www.baidu.com?wd=中文字符'
var encode1 = encodeURIComponent(str1)
console.log(encode1) // http%3A%2F%2Fwww.baidu.com%3Fwd%3D%E4%B8%AD%E6%96%87%E5%AD%97%E7%AC%A6

var decode1 = decodeURIComponent(encode1)
console.log(decode1) // http://www.baidu.com?wd=中文字符

var notNum = NaN
document.write((notNum === NaN) + '<br>') // false
document.write((NaN === NaN) + '<br>') // false
document.write(isNaN(notNum) + '<br>') // true

var jscode = 'alert(123)'
eval(jscode) // 弹窗显示 123
```

##### 11.8 正则表达式对象

正则表达式定义字符串的组成规则，用`//`包括，以`^`开始，`$`结束，用来匹配需要的字符串

正则表达式里面不要随意加空格

- 创建方式

  1. 通过new

     ```js
     var reg = new RegExp('^\\w{6,12}$', 'g') // 全局匹配单词字符，长度6~12之间
     ```

  2. 直接赋值

     ```js
     var reg= /^\w{6,12}$/g  // 全局匹配单词字符，长度6~12之间
     ```

- 匹配规则

  1. 单个字符
     `[a]`：匹配 a
     `[ab]`：匹配 a 或 b 其中一个
     `[a-zA-Z0-9_]`：匹配 a~z 或 A~Z 或 0~9 或 _ 其中一个

  2. 特殊符号

     特殊符号需要加反斜线进行转义

     `\d`：匹配单个数字字符，相当于 `[0-9]`
     `\w`：匹配单个单词字符，相当于`[a-zA-Z0-9_]`

  3. 量词符号

     `?`：匹配字符出现 0 次或 1 次
     `-`：匹配字符出现 0 次或多次
     `+`：匹配字符出现1次或多次
     `{m, n}`：匹配字符出现 m 次到 n 次之间，包含 m 和 n
     `{ , n}`：匹配字符出现最多n次
     `{m, }` ：匹配字符出现最少m次

- 测试方法

  `test()`：测试字符串是否符合正则表达式规则
  
  ```js
  var reg = /^\w{6,12}$/g
  var str1 = 'red'
  var str2 = 'red apple'
  var str3 = 'redapple'
  console.log(reg.test(str1)) // false
  console.log(reg.test(str2)) // false
  console.log(reg.test(str3)) // true
  ```
  
  `exec()`：同样是匹配字符串，成功返回该值，失败返回null
  ```js
  var str = 'hello'
  var pattern = /o/
  var result = pattern.exec(str)
  console.log(result) // ['o', index: 4, input: 'hello', groups: undefined]
  console.log(result.index) // 4
  ```
  

更多请参考[正则表达式](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Guide/Regular_Expressions)

#### 12 字符串

##### 12.1 字符串属性

与数组一样，字符串的长度可以通过`length`属性获取

```js
var str = 'andy'
console.log(str.length) // 4
```

也许你会疑惑，基本类型怎么会有属性给你调呢，原来js对字符串类型进行了包装，包装成了复杂数据类型，这个过程是js自动完成的

```js
var temp = new String('andy')
str = temp
temp = null
```

> 字符串的值是不可变的，这与Java一样，一旦修改其值，那么将会开辟一块新的内存空间，地址也随之改变，已经不再是原来的字符串了，所以不要**大量的**拼接字符串，会非常消耗性能

##### 12.2 字符串方法

字符串的方法不会改变原字符串，因为字符串是不可变的，字符串的方法会返回一个新字符串

- `indexOf` 和 `lastIndexOf()`

  与数组类似，可以查找字符在字符串中的位置，找不到返回 -1，`indexOf()`还可以指定开始查找位置

  ```js
  var str = '床前明月光，疑似明月光'
  console.log(str.indexOf('明')) // 2
  console.log(str.indexOf('疑似')) // 6
  console.log(str.indexOf('明', 2)) // 2，从第三个元素开始查找
  console.log(str.indexOf('明', 3)) // 8，从第四个元素开始查找
  console.log(str.indexOf('2')) // -1
  console.log(str.lastIndexOf('明')) // 8
  console.log(str.lastIndexOf('2')) // -1
  ```
  案例：求字符出现的位置和次数
  ```js
  var str = '举头望明月，就是明月光'
  var index = str.indexOf('明')
  while (index != -1) {
    console.log(index)
    index = str.indexOf('明', index + 1)
  }
  // 3
  // 8
  ```
  
- `charAt(index)`

  根据给定索引返回索引处的字符

  使用`charCodeAt(index)`返回索引处的字符的ASCII码，可以用来判断用户按下了哪个键

  H5新增`str[index]`获取，和`charAt(index)`等价

  ```js
  var str = '举头望明月，就是明月光'
  console.log(str.charAt(3)) // 明
  console.log(str.charCodeAt(3)) // 26126
  console.log(str[3]) // 明
  ```

- `concat()`

  用于拼接字符串，等价于`+`，`+`更常用

  ```js
  var str = 'andy'
  console.log(str.concat('red', 'apple')) // andyredapple
  ```

- `substr()`

  用于截取字符串，`substr(start, length)`

  start是截取的起始位置，length是截取几个字符，截取包含start在内

  ```js
  var str = 'andy'
  console.log(str.substr(2, 2)) // dy
  ```

- `replace()`

  替换字符串中的字符，只会替换第一个字符

  ```js
  var str = 'andyandy'
  console.log(str.replace('a', 'b')) // bndyandy
  ```

  `replaceAll()`可以替换所有满足要求的字符

  ```js
  var str = 'andyandy'
  console.log(str.replaceAll('a', 'b')) // bndybndy
  ```

- `split()`

  按照指定的分隔符将字符分开组成数组，与数组的方法`join()`相反

  ```js
  var arr = 'red,green,blue'
  console.log(arr.split(',')) // Array(3) [ "red", "green", "blue" ]
  ```

#### 13 Web APIs

API（Application Programming Interface）翻译过来就是应用程序接口，在编写某些功能的封装时，封装完成后会对外暴露接口，这些接口就是 API，有了 API 我们就能调用这些功能而不需要去了解这些功能的内部实现细节

Web APIs 就是浏览器提供给我们的 API，用来操作浏览器的功能（ BOM ）或者是网页上的元素（ DOM ）

##### 13.1 DOM

Document Object Model 文档对象模型，是 w3c 推荐的处理 HTML 的标准编程接口，可以通过这些编程接口改变网页的结构、内容以及样式

一个网页可以看成是一个文档对象（document object）

HTML 标签组成的元素（element）又构成了一个树形结构

网页中的所有内容又可以细分为各个节点（node），比如标签、属性、文本、注释等等

DOM 元素是**对象**，有了**对象**我们就可以使用对象的属性和方法去实现改变网页的结构、内容以及样式的目的

###### 13.1.1 获取DOM元素

想要操作 DOM 元素对象，首先要获取它，这和要先有 css 选择器的道理是一样的

1. `document.getElementById()`

   返回**一个**匹配特定 ID 的 DOM 元素对象（元素的 ID 在大部分情况下要求是唯一的）

   找到了返回文档中拥有特定 ID 的 DOM 元素对象，没有找到返回 null

   当获取到元素对象之后，就可以使用它的属性和方法了

   ```js
   var element = document.getElementById('time')
   console.log(element) // <div id="time">
   console.log(typeof element) // object
   ```

2. `document.getElementsByTagName()`
   通过元素标签名获取元素对象的集合，这个集合是一个**伪数组**，可以用遍历数组的方法来遍历获取元素对象
   
   ```js
   var el = document.getElementsByTagName('li')
   console.log(el) // HTMLCollection { 0: li, 1: li, 2: li, length: 3 }
   console.log(el[0]) // <li>
   ```
   这个方法还可以用到 DOM 元素对象上面，这样可以选择特定元素下的元素对象集合
   ```js
   var el = document.getElementById('nav')
   var liEls = el.getElementsByTagName('li')
   ```
   
3. `document.getElementsByClassName()`
   HTML5 新增的方法，通过类名获取元素对象集合
   
   ```js
   var els = document.getElementsByClassName('red')
   console.log(els) // HTMLCollection { 0: li.red, 1: li.red, length: 2 }
   ```
   
4. `document.querySelector()`
   HTML5 新增的方法，根据给定的选择器返回选到的**第一个** DOM 元素对象
   
   ```js
   var el = document.querySelector('#time')
   var el = document.querySelector('.red')
   var el = document.querySelector('li')
   ```
   
5. `document.querySelectorAll()`
   HTML5 新增的方法，根据给定的选择器返回选到的全部 DOM 元素对象组成的集合
   
   ```js
   var els = document.querySelectorAll('#time')
   var els = document.querySelectorAll('.red')
   var els = document.querySelectorAll('li')
   ```
   
6. `document.documentElement` 和 `document.body`
   文档中往往只有一个html和body标签，可以直接获取它们
   
   ```js
   var bodyEle = document.body
   console.log(bodyEle) // <body>
   var htmlEle = document.documentElement
   console.log(htmlEle) // <html lang="en">
   ```

###### 13.1.2 事件

事件是用户在网页上的行为，行为可以被 js 检测到并且做出相应地回应，事件由三部分组成：

- 事件源：被触发的对象，比如按钮
- 事件类型：事件如何被触发，比如鼠标点击、鼠标滑过、键盘按下等等
- 事件处理程序：通常是一个函数，采用函数赋值的形式

```js
var btn = document.getElementById('btn')
btn.onclick = function () {
  alert('点击了按钮')
  console.log('点击了按钮')
}
```
1. 注册事件

   注册事件：给 DOM 元素对象绑定事件

   - 传统注册方式

     给 DOM 对象的以 `on` 开头的属性直接赋值事件处理函数的方式

     特点是同一个元素只能绑定一个处理函数，之后给相同事件注册的处理函数会覆盖前面注册的（目前已不推荐使用）

   - 监听注册方式

     这是 w3c 推荐的规范，但是在 `IE9` 之后才支持，同一个元素、同一个事件可以绑定多个监听器

     ```js
     // 点击按钮会先弹出22再弹出33
     var btn = document.querySelector('button')
     btn.addEventListener('click', function () {
        alert(22)
     })
     btn.addEventListener('click', function () {
        alert(33)
     })
     ```
     封装一个事件绑定函数
     ```js
     const btn = document.querySelector('button')
     
     function bindEvent(el, type, fn) {
       el.addEventListener(type, fn)
     }
     
     bindEvent(btn, 'click', e => {
       console.log(e.target) // 获取触发事件的 DOM 对象
       e.preventDefault()  // 阻止默认行为
       alert('click')
     })
     ```

2. 删除事件

   - 传统注册方式

     直接置空覆盖就好

     ```js
     el.onclick = function() {
         alert(22)
         el.onclick = null
     }
     ```

   - 监听注册方式

     ```js
     btn.addEventListener('click', fn)
     
     function fn() {
         alert(33)
         btn.removeEventListener('click', fn)
     }
     ```

3. DOM事件流

   事件发生时会在元素节点之间按照特定的顺序传播，这个过程叫做 DOM 事件流，大致分为3个阶段

   整个过程如同从水底拿东西一样：

   1. 捕获阶段

      想要获取目标元素，让事件发生，首先需要从最顶层的元素开始向里面查找目标，就像从进入水面游到水底的过程，途中经过的元素会触发事件

   2. 目标阶段

      接触到了目标，目标触发事件的过程，就像在水底正在拿东西的过程一样

   3. 冒泡阶段

      目标接触完毕，原路返回到顶层元素的过程，途径的元素会触发事件，就像已经在水底拿了东西重新游回水面的过程，如冒泡一般

   > 1. js 只能执行捕获或冒泡的其中一个阶段，`onclick` 只能得到冒泡阶段
   >
   > 2. 在`addEventListener(type, listener [, useCapture])`监听注册函数中
   >
   >    `useCapture` 的值：
   >
   >    `true`：表示在捕获阶段触发事件
   >
   >    默认不写或 `false`：表示在冒泡阶段触发事件
   
   ```js
   // html
   <div class="fa">
       <div class="son">son box</div>
   </div>
   
   // 由于参数为true，只在捕获阶段触发事件，所以点击son盒子会先弹出fa再弹出son
   var son = document.querySelector('.son')
   son.addEventListener(
     'click',
     function () {
       alert('son')
     },
     true
   )
   
   var fa = document.querySelector('.fa')
   fa.addEventListener(
     'click',
     function () {
       alert('fa')
     },
     true
   )
   
   // 由于参数为默认不写，只在冒泡阶段触发事件，所以点击son盒子会先弹出son再弹出fa
   var son = document.querySelector('.son')
   son.addEventListener('click', function () {
     alert('son')
   })
   
   var fa = document.querySelector('.fa')
   fa.addEventListener('click', function () {
     alert('fa')
   })
   ```
   实际开发中很少使用事件捕获，冒泡有时会带来麻烦，但有时又有用
   
   某些事件没有冒泡，如 `onblur`、`onfocus`、`onmouseenter`、`onmouseleave`
   
4. 事件对象

   事件对象就是事件处理函数的形参，只有有了事件才会存在，这是系统自动创建的，不需要我们显式传参，是事件的相关数据的集合，比如点击事件里面，事件对象就有鼠标坐标等相关信息，键盘事件就有用户按键的相关信息，这个形参可以自定义命名

   ```js
   var fa = document.querySelector('.fa')
   fa.addEventListener('click', function (event) {
     alert('fa')
     console.log(event)
   })
   ```
   事件对象的常用属性和方法

   |              事件对象的属性               |                             说明                             |
   | :---------------------------------------: | :----------------------------------------------------------: |
   |       `e.target` 或 `e.srcElement`        | 返回**触发事件的 DOM 对象**，前者标准，后者不标准是为了**兼容 IE** |
   |                 `e.type`                  |        返回事件类型，如 `click`、`mouseover`，不带 on        |
   | `e.stopPropagation()` 或 `e.cancelBubble` |       阻止冒泡，前者标准，后者不标准是为了**兼容 IE**        |
   |  `e.preventDefault()` 或 `e.returnValue`  | 阻止默认事件，比如不让链接跳转，前者标准，后者不标准是为了**兼容 IE** |

   鼠标事件对象（MouseEvent）常用属性

   | `e.clientX`、`e.clientY` | 鼠标在可视区域的坐标 |
   | :----------------------: | :------------------: |
   |   `e.pageX`、`e.pageY`   | 鼠标在页面文档的坐标 |
   | `e.screenX`、`e.screenY` | 鼠标在电脑屏幕的坐标 |


   ```js
   // 给ul绑定事件，然后点击li，最后target返回的是触发事件的li，而this返回的是绑定事件的ul
   var ul = document.querySelector('ul')
   ul.addEventListener('click', function (e) {
     console.log(this) // ul
     console.log(e.target) // li
   })
   
   // type可以返回事件的类型
   var son = document.querySelector('.son')
   son.addEventListener('click', fn)
   son.addEventListener('mouseover', fn)
   son.addEventListener('mouseout', fn)
   
   function fn(e) {
     console.log(e.type)
   }
   
   // 给链接添加了阻止默认事件的处理函数后，点击链接就不会跳转了
   var a = document.querySelector('a')
   a.addEventListener('click', fn)
   
   function fn(e) {
     e.preventDefault()
   }
   
   // 阻止事件冒泡
   var son = document.querySelector('.son')
   son.addEventListener('click', function (e) {
     alert('son')
     e.stopPropagation()
   })
   
   var fa = document.querySelector('.fa')
   fa.addEventListener('click', function () {
     alert('fa')
   })
   ```

5. 事件委派（代理、委托）

   有时候，我们需要给每个子元素都注册事件，比如给 ul 里的每个 li 注册事件，但是DOM操作越多，页面执行效率就会越低，而且当li很多的时候非常麻烦，所以我们可以只给父元素注册事件，利用冒泡原理来影响每一个子元素，这就是事件委派，**把本来应该绑定给子元素的事件全部委派给父元素**

   具体的操作是只给父元素注册事件，当子元素发生动作后，就会开始向上冒泡，等冒泡到父元素的时候，由于父元素注册了事件，因此该事件被触发，整个过程**看起来就像子元素触发了该事件一样**

   在事件委派中如果想对子元素进行一些操作，我们可以利用事件对象来获取子元素

   事件委派只注册了一次事件，相比注册多次事件，页面执行效率大大地提高了

   ```js
   var ul = document.querySelector('ul')
   ul.addEventListener('click', fn)
   
   function fn(e) {
     alert('alert')
     // 干掉别人
     for (let i = 0; i < ul.children.length; i++) {
       ul.children[i].style.backgroundColor = ''
     }
     // 留下自己
     e.target.style.backgroundColor = 'violet'
   }
   ```
   考虑到事件委托，前面的事件绑定函数需要重写
   ```js
   // selector：需要被事件委托的 DOM 对象
   function bindEvent(el, type, selector, fn) {
     // 说明只传了 3 个参数
     if (fn == null) {
       // 把事件处理函数赋值给 fn
       fn = selector
       selector = null
     }
     el.addEventListener(type, e => {
       // 记录触发事件的 DOM 对象
       const target = e.target
       // selector 不为 null，说明传了 4 个参数，为代理的情况
       if (selector) {
         if (target.matches(selector)) {
           // 修改 fn 的 this 指向，传递事件对象
           fn.call(target, e)
         }
       } else {
         // 普通绑定
         fn.call(target, e)
       }
     })
   }
   ```

6. 常用鼠标事件

   |   onclick   |      鼠标左键点击      |
   | :---------: | :--------------------: |
   | onmouseover |        鼠标滑过        |
   | onmouseout  |        鼠标移开        |
   |   onfocus   |      获得鼠标焦点      |
   |   onblur    |      失去鼠标焦点      |
   | onmousemove |        鼠标移动        |
   | onmousedown |        鼠标按下        |
   |  onmouseup  |        鼠标弹起        |
   | contextmenu | 控制何时显示上下文菜单 |
   | selectstart |      鼠标开始选中      |

   案例：禁止用户复制网页上的文字

   ```js
   // 禁用网页右键菜单
   document.addEventListener('contextmenu', (e) => {
     e.preventDefault()
   })
   // 禁用鼠标选中
   document.addEventListener('selectstart', (e) => {
     e.preventDefault()
   })
   ```

   案例：图片跟随鼠标移动

   图片采用绝对定位

   ```js
   var img = document.querySelector('img')
   document.addEventListener('mousemove', function (e) {
     var x = e.pageX
     var y = e.pageY
     img.style.left = x + 'px'
     img.style.top = y + 'px'
   })
   ```

7. 常用键盘事件

   | onkeydown  |                 键被按下                  |
   | :--------: | :---------------------------------------: |
   |  onkeyup   |                  键弹起                   |
   | onkeypress | 键被按下，但不识别功能键（ctrl、shift等） |

   ```js
   document.addEventListener('keydown', () => {
     console.log('down')
   })
   document.addEventListener('keyup', () => {
     console.log('up')
   })
   document.addEventListener('keypress', () => {
     console.log('press')
   })
   // down
   // press
   // up
   ```

   利用键盘事件对象的`keyCode`属性可以获得对应按键的ASCII码，`keyup`和`keydown`不区分字母大小写，`keypress`区分

###### 13.1.3 操作DOM元素

可以获取 DOM 元素，也了解了事件，接下来就可以操作 DOM 元素了

1. 操作DOM元素内容

   `innerHTML`：获取或者替换元素内容，保留 HTML 标签以及换行、空格

   获取元素的内容

   ```js
   let div = document.getElementsByTagName('div')[0]
   let html = div.innerHTML
   console.log(html)
   console.log(typeof html)
   
   // <ul>
   //   <li>1</li>
   //   <li>2</li>
   //   <li>3</li>
   // </ul>
   //
   // string
   ```

   替换元素内容

   > 如果要追加元素内容，使用字符串拼接的方式 `+=` 或者使用 [insertAdjacentHTML](https://developer.mozilla.org/zh-CN/docs/Web/API/Element/insertAdjacentHTML)，不过对于这种多次操作 DOM，最好一次性操作，参加本文 [20 性能优化](#)

   ```js
   var div = document.getElementById('time')
   var btn = document.getElementById('btn')
   btn.onclick = function () {
     div.innerHTML = '文本'
   }
   ```
   `innerText`：表示一个节点及其后代的**“已渲染的”**文本内容

   ```html
   <div>
       <ul>
           <li style="display: none;">1</li>
           <li>2</li>
           <li>3</li>
       </ul>
   </div>
   ```

   ```js
   let div = document.getElementsByTagName('div')[0]
   let text = div.innerText
   console.log(text)
   console.log(typeof text)
   
   div.innerText = '<p>123</p>'
   console.log(div.innerText)
   
   // 2  被隐藏的元素的内容获取不到
   // 3
   // string
   // <p>123</p>  页面上就显示的 p 标签，其不会被作为 HTML 标签处理
   ```

2. 操作DOM元素的Property

   property 可以理解为一种操作 DOM 元素的形式，通过操作对象的属性的形式去操作 DOM 元素，这些属性就是 property

   案例：点击眼睛图标显隐密码

   ```js
   // 通过更改输入框的类型属性来实现
   var eye = document.getElementById('eye')
   var pwd = document.getElementById('pwd')
   var flag = true
   
   eye.onclick = function () {
     if (flag) {
       pwd.type = 'text'
       eye.src = './img/open.png'
       flag = !flag
     } else {
       pwd.type = 'password'
       eye.src = './img/close.png'
       flag = !flag
     }
   }
   ```
   案例：循环修改背景图片（精灵图）
   ```js
   let lis = document.querySelectorAll('li')
   for (let i = 0; i < lis.length; i++) {
     let index = i * 44
     // 注意和 css 中不一样，js 中采用的是驼峰命名法
     lis[i].style.backgroundPosition = '0 ' + index + 'px'
   }
   ```

   案例：修改元素样式

   直接通过修改元素的 style 属性来改变元素样式，这样的样式属于行内样式，权重较高，如果要修改的样式较多会变得非常麻烦

   ```js
   var divs = document.querySelectorAll('div')
   divs[0].onclick = function () {
     this.style.backgroundColor = 'violet'
     this.style.width = '150px'
   }
   ```

   但是直接修改 style 一次只能修改一个样式，如果样式较多可以把它们写成类，通过 className 去修改类名，这个更加常用

   ```js
   this.className = 'origin change'
   ```

3. 操作自定义属性值Attribute

   设置自定义属性：`setAttribute()`

   ```js
   el.setAttribute('data-index', 2)
   ```

   获取自定义属性值：`getAttribute()`

   ```js
   el.getAttribute('data-index')
   ```

   移除自定义属性：`removeAttribute()`

   ```js
   el.removeAttribute('data-index')
   ```
   如果自定义属性是为了保存并使用数据（有些数据可以不用保存到数据库中而直接保存到页面中），但是有时我们仅仅通过属性名字不好分辨属性到底是内置属性还是自定义属性，所以 HTML5 规定，和数据相关的自定义属性统一以 `data-` 开头

   获取数据的时候就可以不用调 API 而是直接使用 dataset 就可以获取自定义属性值，而且在获取的时候可以省略 `data-` 不写

   ```js
   // 自定义属性名：data-index
   console.log(el.dataset.index)
   console.log(el.dataset['index'])
   
   // 如果自定义属性名有多个短线连接，那么获取时要采用驼峰命名法
   // 自定义属性名：data-list-name
   console.log(el.dataset.listName)
   console.log(el.dataset['listName'])
   ```

4. 案例

- 排他思想

  有时候，有一组同类元素，需要对其中一个做点击变色效果，当其变色时，其余的元素保持不变，这时如果给每个元素都绑定点击事件会非常麻烦，因为每个元素都要写一次，这时可以利用for循环，干掉别人，留下自己，这就简化了代码，这叫做排他思想

  > 缺点：绑定了大量的事件，性能消耗严重，可以利用事件委托解决

  ```js
  var btns = document.getElementsByTagName('button')
  for (let i = 0; i < btns.length; i++) {
    btns[i].onclick = function () {
      // 每次点击按钮就遍历所有的按钮将样式清空
      for (let j = 0; j < btns.length; j++) {
        btns[j].style.backgroundColor = ''
      }
      // 然后恢复自己的样式
      this.style.backgroundColor = 'violet'
    }
  }
  ```

- 表格滑过变色

  效果是鼠标滑过单行表格变色

  ```js
  var trs = document.querySelector('tbody').querySelectorAll('tr')
  for (let i = 0; i < trs.length; i++) {
    trs[i].onmouseover = function () {
      this.className = 'bg'
    }
    trs[i].onmouseout = function () {
      this.className = ''
    }
  }
  ```

- 表单全选

  ```js
  // 点击全选按钮，选中下面的所有按钮
  var seAll = document.getElementById('seAll')
  var se = document.getElementById('se').getElementsByTagName('input')
  seAll.onclick = function () {
    for (let i = 0; i < se.length; i++) {
      se[i].checked = this.checked
    }
  }
  
  // 点击下面的单选按钮，如果单选按钮被全部选中，则选中全选按钮
  for (let i = 0; i < se.length; i++) {
    se[i].onclick = function () {
      let flag = true
      for (let i = 0; i < se.length; i++) {
        if (!se[i].checked) {
          flag = false
          break // 提高效率
        }
      }
      seAll.checked = flag
    }
  }
  ```

- Tab栏切换（常用）

  点击 tab 栏，内容区域跟随 tab 栏一起变化

  ```js
  // 获取元素对象
  var tab_list = document.querySelector('.tab_list')
  var lis = tab_list.querySelectorAll('li')
  var items = document.querySelectorAll('.item')
  // for循环绑定点击事件
  for (var i = 0; i < lis.length; i++) {
      // 给5个小li设置索引号
      lis[i].setAttribute('index', i)
      lis[i].onclick = function () {
          // 排他思想，先清除全部的样式，再设置当前的样式
          for (var i = 0; i < lis.length; i++) {
              lis[i].className = ''
          }
          this.className = 'current'
          // 排他思想，先隐藏全部的内容，再显示当前的内容
          var index = this.getAttribute('index')
          for (var i = 0; i < items.length; i++) {
              items[i].style.display = 'none'
          }
          items[index].style.display = 'block'
      }
  }
  ```

###### 13.1.4 操作节点

在前面通过直接获取 DOM 元素对象进行操作的方式非常繁琐，且逻辑性不强，这里还有一种兼容性不太好的通过节点层级来操作 DOM 元素对象的方式克服了上诉缺点，节点比元素的范围广，网页中的元素属性、文本等都是节点

- 节点类型 `nodeType`

  元素节点：1

  属性节点：2

  文本节点：3（文本、空格、换行等）

- 节点名称 `nodeName`

- 节点值 `nodeValue`

实际开发中主要操作元素节点，利用DOM树可以把节点划分为父子兄的层级关系

1. 获取父节点

   获取的是离元素最近的父节点，亲父亲，获取不到返回 null

   ```js
   console.log(el.parentNode)
   ```

2. 获取子节点

   获取的是子节点的即时更新的集合，包含了所有的节点类型，元素节点、文本节点等，如果想只获得元素节点，需要循环判断节点类型，比较麻烦，所以一般不使用这种方法获取子节点

   ```js
   console.log(el.childNodes)
   ```

   有一种非标准的只读属性的方法，只返回子元素节点，尽管非标准，但得到了良好的支持，常用

   ```js
   console.log(el.children)
   ```

   获取第一个或者最后一个子节点，同 `childNodes` 会获取所有节点的第一个或最后一个节点

   ```js
   console.log(el.firstChild)
   console.log(el.lastChild)
   ```

   有一种兼容性不太好的写法，IE9以上才支持，只返回第一个或最后一个元素节点

   ```js
   console.log(el.firstElementChild)
   console.log(el.lastElementChild)
   ```

   实际开发中更常用的做法是利用 `children` 获取所有的子元素节点，然后直接通过数组索引调用

   ```js
   console.log(el.children[0])
   console.log(el.children[el.children.length - 1])
   ```

3. 获取兄弟节点

   获取对应元素节点的下一个或上一个兄弟节点，同样是获取的所有类型的节点

   ```js
   console.log(el.nextSibling)
   console.log(el.previousSibling)
   ```

   同样有只获取元素对象的方法，兼容性较差

   ```js
   console.log(el.nextElementSibling)
   console.log(el.previousElementSibling)
   ```

4. 创建节点

   在网页中动态创建新的节点，先创建，然后将创建的节点添加到网页中，这里是给父节点添加子节点，类似于数组的 push

   ```js
   var li = document.createElement('li')
   var ul = document.querySelector('ul')
   ul.appendChild(li)
   ```

   如果想往前面添加

   ```js
   ul.insertBefore(li, ul.children[0])
   ```

5. 删除节点

   返回删除的节点

   ```js
   el.removeChild()
   ```

6. 复制节点

   复制节点，参数为空或者false将是浅拷贝，不复制内容

   ```js
   var ul = document.querySelector('ul')
   var li = ul.children[0].cloneNode(true)
   ul.appendChild(li)
   ```

7. 三种创建DON元素方式的区别

   - `document.write()`

     这种创建方式直接将内容写进页面内容流，但当文档流执行完毕，它会**重新绘制页面**，导致页面内容丢失，比如在事件里面调用它，一般这个时候页面已加载完成，文档流已经执行完毕，执行事件就会导致页面重绘，用户体验差，不推荐使用

   - `el.innerHTML`

     这种方式是直接给元素添加内容，不会导致页面重绘，但这种方式是属于**拼接字符串**的方式，直接拼接字符串的效率较低，但是我们可以曲线救国，如果先用数组将这些字符串 `push()` 起来组成数组，然后利用 `join()` 将其转为字符串一次性写给元素，这种方式的效率非常快

   - `document.createElement()`

     直接创建元素，不会导致页面重绘，效率较高（不被 `innerHTML` 弯道超车的情况下），结构清晰

##### 13.2 BOM

BOM 就是 Browser Object Model，即浏览器对象模型，提供了独立于内容，与浏览器窗口进行交互的对象，其核心对象是 `window`，BOM 的范围比 DOM 更大，包含了 DOM

> 由于各大浏览器厂商没有统一标准，所以 BOM 没有较为统一的标准，兼容性较差，

`window` 是一个全局对象，定义在全局作用域里的变量和函数自动成为 `window` 的属性，只不过我们在调用这些属性方法时可以不加 `window` 的前缀

> 这种情况仅限于 ES5，ES6 新增的 let const class 等关键字定义的变量不会成为 window 的属性

`alert()`、`prompt()` 等都是 `window` 对象的函数

###### 13.2.1 BOM常见事件

- 窗口加载事件`onload`

  在窗口文档完全加载后就会自动触发该事件

  ```js
  window.onload = function () {}
  // 或
  window.addEventListener('load', function () {})
  ```

  在之前的代码中，js 代码必须写在元素声明之后，或者在元素之后外部引入，否则无法获取元素，因为元素必须先存在，js 才能获取到它，如何解决这个位置问题呢，答案是把 js 写到窗口加载事件里面，由于窗口加载事件是在页面文档完全加载完成之后调用的，故元素必然是存在的，这时 js 不论在网页中写到元素之前还是之后都可以正确地获取到元素，也就可以把 js 在元素的前面引入了

  ```js
  window.addEventListener('load', function () {
    var img = document.querySelector('img')
    img.addEventListener('click', function () {
      alert('onload')
    })
  })
  ```
  如果页面图片很多，等待网页完全加载完成很耗时，这时可以使用`DOMContentLoaded`，仅当DOM加载完成不包括 css、图片、flash等就可以触发事件，提升用户体验
  
- 窗口调整事件`resize`

  浏览器窗口大小发生变化时触发事件，可以利用这个事件做响应式布局

  ```js
  window.addEventListener('resize', () => {
    console.log(window.innerWidth) // 打印当前浏览器窗口宽度
  })
  ```

###### 13.2.2 定时器
定时器也是 `window` 对象提供的函数，一共有两个

- `setTimeOut()`

  设置一个毫秒级定时器，程序执行到定时器时会等待定时时间，在定时时间到期后调用指定函数

  毫秒数参数可以省略，默认为0ms

  ```js
  for (let i = 0; i < 3; i++) {
    setTimeout(() => {
      console.log('时间到了' + i)
    }, 2000)
  }
  
  // 21:45:20.572 时间到了0
  // 21:45:20.575 时间到了1
  // 21:45:20.576 时间到了2
  // 注意时间，发现并没有依次等待2s输出语句
  // 原因是for循环的执行与定时函数的执行是互相独立的
  // for循环极快地跑了三遍，然后三个定时函数一起等待了2s输出语句
  ```
  
  往往一个页面中可能会存在多个定时器，可以给它们起不同的名字
  ```js
  var timer1 = setTimeout(fn, 1000)
  var timer2 = setTimeout(fn, 2000)
  var timer3 = setTimeout(fn, 3000)
  
  function fn() {
    console.log('时间到了')
  }
  ```
  
  >回调函数：普通函数是按照代码顺序调用的，执行到了就马上调用，而在定时器里面的函数不是马上调用的，而是等待指定时间才调用，所以回调函数可以理解为先干完一件事再干另一件事，回头调用
  >
  >MDN的解释：一个函数被作为实参传入另一函数，并在该外部函数内被调用，用以来完成某些任务的函数，称为回调函数
  >
  >回调函数有同步回调函数和异步回调函数，关于异步，后面解释
  
  定时器可以设置也可以清除，可以使用`clearTimeOut()`清除定时器
  
  ```js
  // 点击按钮清除定时器3的执行
  var btn = document.querySelector('button')
  btn.addEventListener('click', () => {
    clearTimeout(timer3)
  })
  
  var timer1 = setTimeout(fn, 1000)
  var timer2 = setTimeout(fn, 2000)
  var timer3 = setTimeout(fn, 3000)
  
  function fn() {
    console.log('时间到了')
  }
  ```
  
- `setInterval()`

  设置一个毫秒级的循环定时器，每隔设定的时间就循环执行回调函数

  ```js
  // 每隔1s打印一次
  setInterval(() => {
    console.log('Interval')
  }, 1000)
  ```

  同样的可以清除循环定时器

  ```js
  // 点击开始按钮开始循环定时器，停止按钮停止循环定时器
  var begin = document.querySelector('.begin')
  var stop = document.querySelector('.stop')
  var timer = null
  begin.addEventListener('click', function () {
      timer = setInterval(function () {
          console.log('begin')
      }, 1000)
  })
  stop.addEventListener('click', function () {
      clearInterval(timer)
  })
  ```

  案例：发送短信倒计时

  ```js
  var btn = document.querySelector('button')
  var time = 3 // 定义剩下的秒数
  btn.addEventListener('click', function () {
      btn.disabled = true
      btn.innerHTML = '还剩下' + time + '秒' // 立马改变按钮文字，防止转变突兀
      var timer = setInterval(function () {
          if (time == 1) {
              clearInterval(timer)
              btn.disabled = false
              btn.innerHTML = '发送'
              time = 3
          } else {
              btn.innerHTML = '还剩下' + --time + '秒'
          }
      }, 1000)
  }).
  ```

###### 13.2.3 同步和异步

js 是单线程语言，这意味着在同一时间点 js 只能做一件事情，所有的任务都需要排队执行，这就导致了一个问题，如果中间一个任务卡住了，就会导致页面渲染卡顿阻塞的感觉，为解决这个问题，把CPU的多核能力利用起来，H5提出了新标准，允许 js 创建多个线程，于是 js 就出现了同步和异步

- 同步

  就是按照顺序执行，必须等前一个步骤做完之后再做后一个步骤，比方说做饭的时候，必须等到水烧开了之后你再去切菜炒菜

- 异步

  但是这样是不合理的，烧水耗时长，完全可以在烧水的同时去切菜炒菜，提高效率，这就引出异步的概念，不用等待耗时的操作完成再去操作下一步，而是直接去操作下一步，让下一步和耗时的操作**同时进行**，这样大大的提高了效率

  ```js
  // 下面的代码就是异步的例子，没有等待定时器执行完毕，而是直接打印了3，最后打印了2
  console.log(1)
  setTimeout(function () {
    console.log(2)
  }, 1000)
  console.log(3)
  
  // 1
  // 3
  // 2
  ```

  但是下面的代码依然是打印了132，是怎么回事呢

  ```js
  console.log(1)
  setTimeout(function () {
    console.log(2)
  })
  console.log(3)
  ```

  原来 js 为了提高效率，设定了同步任务和异步任务的执行栈，同步任务在主线程执行，而异步任务添加到任务队列执行

  异步任务一般都是回调函数，且是如下类型的回调函数：

  1. 普通事件：click、resize 等
  2. 资源加载：load 等
  3. 定时器：setTimeOut 等

  这些回调函数会被当成异步任务放到任务队列（消息队列）里面去执行
  
  由于 js 的执行机制会**先执行同步任务的执行栈**，如果在顺序执行过程中遇见了异步任务，那么会直接将异步任务扔到任务队列里面排队，同时不执行异步任务，而是**让它等待**，等到执行栈里的**同步任务全部执行完毕**，再去任务队列里面把排队的异步任务依次取出来放到执行栈中依次执行，整个过程由专门的异步进程来处理
  
  需要注意的是，任务队列里的异步任务是先进先出的，先排队的先拿出来执行，如果有多个异步任务，会先拿出先放进去的异步任务到执行栈里去执行
  
  在同步和异步任务都执行完之后，主线程执行栈还会监控异步任务队列是否有新的异步任务进入排队，如果有就继续拿出来执行，然后进入下一个监控循环，这种机制叫做事件循环（event loop）
  
  ES6 引入了 Promise 用于处理异步，参加本文 [18.9 Promise](#)

###### 13.2.5 BOM常用对象

1. `navigator`

   包含了与浏览器相关的信息，常用的有用于查看浏览器型号的用户代理

   ```js
   console.log(navigator.userAgent)
   // Mozilla/5.0 (Windows NT 10.0; Win64; x64) 
   // AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36
   ```

2. `screen`

   可以查看**屏幕**高度和宽度，常用于**屏幕**大小适配

   > 注意查看的是屏幕的大小而不是浏览器的大小

   ```js
   console.log(screen.width + ' ' + screen.height)  // 1366 768
   ```

3. `location`

   获取或者设置浏览器地址栏的URL地址

   常用属性：

   - `location.href`：获取或者设置**完整URL地址**

     ```js
     console.log(location.href)  // http://localhost:63342
     location.href = 'https://www.baidu.com'  // 执行这条代码之后网站会跳转到百度
     ```

   - `location.protocol`：获取URL地址的**网络协议**

     ```js
     console.log(location.protocol)  // http:
     ```

   - `location.host`：获取URL地址的**域名**

     ```js
     console.log(location.host)  // localhost:63342
     ```

   - `location.search`：获取URL地址的**请求参数**

     ```js
     console.log(location.search)  // '?a=100&b=200'
     ```

   - `location.hash`：获取URL地址的**哈希值**，`#` 号后面的内容

     ```js
     console.log(location.hash)  // '#app'
     ```

   - `location.pathname`：获取URL地址的**路径**

     ```js
     console.log(location.pathname)  // '/JavaScript/test.html'
     ```

   常用函数：

   - `assign()` 和 `replace()`：跳转网页

     `assign()` 会记录历史记录，而 `replace()` 不会

     ```js
     location.assign('http://www.baidu.com')
     location.replace('http://www.baidu.com')
     ```

   - `reload()`：刷新网页

     如果参数为 `true`，则为强制刷新（相当于ctrl + f5），会清除浏览器缓存，全部的网页内容都需要重新从服务器获取

     ```js
     location.reload(true)
     ```

4. `history`

   实现网页的前进后退等功能

   ```js
   history.back() // 后退
   history.forward() // 前进
   history.go(1) // 去往指定网页
   ```

###### 13.2.6 浏览器本地存储

有些数据没有必要存到数据库中，可以直接存到浏览器里，存储之后设置读取很方便，页面刷新也不会丢失

主要有三种存储方式：

- `cookie`

  早期的浏览器存储方式，本来是用于浏览器和服务器通讯的，但是浏览器又没有别的存储方式，只能用它，cookie 会随着请求发送出去

  cookie 是一个请求首部，其中含有先前由服务器通过 `Set-Cookie` 首部投放并存储到客户端的 `HTTP cookies`

  这个首部可能会被完全移除，例如在浏览器的隐私设置里面设置为禁用 cookie

  容量很小，大概 4kb，其生命周期可以专门设置过期时间

  ```js
  document.cookie = '...'
  ```

- `sessionStorage`

  HTML5 新增，容量大概 5M，生命周期为会话期间，关闭浏览器窗口，浏览器窗口关闭数据消失，同一窗口或者页面数据共享，以键值对形式存储数据

  ```js
  var val = 'jack'
  sessionStorage.setItem('uname', val)
  sessionStorage.getItem('uname')
  sessionStorage.removeItem('uname')
  sessionStorage.clear()
  ```

- `localStorage`

  HTML5 新增，容量大概 20M，生命周期为一直存在，除非手动删除，在同一个浏览器内数据共享，依然以键值对形式存储数据，其使用的方法与`sessionStorage`完全一致
  
  ```js
  var val = 'jack'
  localStorage.setItem('uname', val)
  localStorage.getItem('uname')
  localStorage.removeItem('uname')
  localStorage.clear()
  ```

> 本地存储只能存储字符串，对于对象可以将其序列化之后存储（`JSON.stringify()`），反序列化是反向操作（`JSON.parse()`）

#### 14 面向对象

编程界有两大编程思想，分别是面向过程和面向对象，面向过程就是前面学习的将需要解决的问题分出具体的步骤，然后编写通用的函数，利用函数和语句依次实现这些步骤，这就是面向过程，而面向对象则不去考虑具体的步骤，是将事物分解成一个个的对象，由对象之间分工合作一起来解决问题，步骤的问题往往细化到了对象的内部，对象只暴露方法，不暴露步骤细节，所以不管面向过程还是面向对象，底层细节其实是一样的，但是面向对象具有代码复用性高，容易维护开发的特点，适合多人合作开发，如果是简单的项目，面向过程开发起来会更快捷

在ES6中，js为我们提供了面向对象的功能

##### 14.1 ES6类和对象

类：将一类相同的对象的属性和行为抽象出来，将这些属性和行为封装成一个模板，这个模板也就是类

对象：就是一个具体的对象，看得见摸的着的具体的东西，比如一本书、一杯茶，可以按照模板（类）生产出一个具体的对象，这个过程也叫作实例化

> 利用面向对象的编程思想就是思考有哪些对象，然后创建类，生产实例化对象出来，让对象去帮我们完成任务

在 js 中，对象在表现上是一组无序的属性和方法的集合，并且所有的事物都是对象，比如数值、字符串、数组、函数等都是对象

创建一个类：

```js
class Car {
    // class body
}
```

实例化一个对象

```js
var obj = new Car()
```

类有默认的构造方法`constructor()`，通过new关键字去实例化对象时会自动调用该方法，如果没有显式地定义构造函数，则会有一个默认的构造方法

```js
class Car {
    constructor(cname) {
        this.cname = cname
    }
}
var car = new Car('bmw')
console.log(car.cname) // bmw
```

如果要给类添加方法，直接把方法写在类里面就行了，类里面的方法不需要加function关键字

```js
class Car {
  constructor(cname) {
    this.cname = cname
  }
  drive() {
    console.log('driving')
  }
}
var car = new Car('bmw')
car.drive() // driving
```

##### 14.2 类的继承

子类可以继承父类的一些属性和方法，比如下面的程序，子类中没有写任何方法，却可以直接调用父类的方法，证明该方法是从父类继承过来的

```js
class Father {
  constructor() {}
  money() {
    console.log(100)
  }
}

class Son extends Father {}
var son = new Son()
son.money() // 100
```

但是如果父类中使用了 `this` 关键字指向了自己，子类就没有办法直接使用父类的方法了，因为这里的 `this` 指向的是父类

这时可以在子类中使用 `super` 关键字来指代父类，调用父类的构造方法 `super()` 或者父类的普通函数 `super.function_name()`，

如果子类有自己独有的属性那么需要单独在构造函数中赋值，而和父类共有的属性直接调用父类的构造函数即可，这样做的好处是将来父类的构造函数一旦改变，其各个子类中的共有属性赋值方法也会一起改变，方便了维护，这其实也是继承的意义，带来了可维护性和便利性

> 如果子类重写了父类中的方法，则优先调用子类中的方法

```js
class Father {
  constructor(x, y) {
    this.x = x
    this.y = y
  }
  sum() {
    console.log(this.x + this.y)
  }
  say() {
    console.log('i am father')
  }
}

class Son extends Father {
  constructor(x, y) {
    // this.x = x
    // this.y = y
    super(x, y) // 调用父类的构造函数
  }
  say() {
    console.log('i am son')
    super.say()  // 调用父类的普通方法
  }
}
var son = new Son(1, 2)
son.sum() // 3
son.say() // i am son  i am father
```

需要注意，如果想在子类中拓展新的方法，同时需要使用子类的属性和父类的属性时，在子类中使用super时需要写在子类this之前，因为必须先调用父类的构造函数，才能够调用子类的构造函数

```js
class Father {
  constructor(x, y) {
    this.x = x
    this.y = y
  }
  sum() {
    console.log(this.x + this.y)
  }
}

class Son extends Father {
  constructor(x, y) {
    super(x, y) // 必须写在this之前
    this.x = x
    this.y = y
  }
  subtract() {
    console.log(this.x - this.y)
  }
}
var son = new Son(5, 3)
son.sum() // 8
son.subtract() // 2
```

类是没有变量提升的，需要先定义类，再去实例化对象，否则会报未定义错误

类里面的属性和方法要加this来使用

```js
class Star {
  constructor(uname, age) {
    this.uname = uname
    this.age = age
    this.sing() // 立即调用函数需要加()
  }
  sing() {
    console.log(this.uname)
  }
}
var ldh = new Star('刘德华') // 刘德华
```

如果想点击之后调用函数，则函数不要加`()`，如果加了会直接执行方法，而不是在点击的时候再去执行，但是下面的点击执行后会输出undefined，这和this指向有关

```js
class Star {
  constructor(uname, age) {
    this.uname = uname
    this.age = age
    this.btn = document.querySelector('button')
    this.btn.onclick = this.sing()
  }
  sing() {
    console.log(this.uname)
  }
}
var ldh = new Star('刘德华') // 刘德华
```

在类中的构造函数中的this指向的是创建的对象，而普通函数中的this则是指向调用者，谁调用就指向谁，在点击事件中，调用`sing()`方法的是btn对象，所以此时的this指向的是btn对象，btn对象并没有uname这个属性，故输出了undefined

解决办法是用中间变量存储this，让其指向我们创建的对象，这样无论是谁来调用这个方法，都会指向创建的对象

```js
var that
class Star {
  constructor(uname, age) {
    that = this
    this.uname = uname
    this.age = age
    this.btn = document.querySelector('button')
    this.btn.onclick = this.sing
  }
  sing() {
    console.log(that.uname)
  }
}
var ldh = new Star('刘德华')
ldh.sing() // 刘德华
```

##### 14.3 ES5构造函数

类只是语法糖，是对基于原型继承的模拟，class 实际上还是函数

```js
class Student {
  constructor(name, age) {
    this.name = name
    this.age = age
  }
}

console.log(typeof Student)  // function
```

在 ES6 之前是没有类的，创建对象不是基于类创建的，而是基于构造函数来创建的

```js
// 1. 通过new Object创建对象
var obj1 = new Object()
// 2. 通过对象字面量创建对象
var obj2 = {}
// 3. 通过自定义构造函数创建对象
function Star(uname, age) {
  this.uname = uname
  this.age = age
  this.sing = function () {
    console.log('sing')
  }
}
var ldh = new Star('刘德华', 18)
console.log(ldh)
```

> 构造函数是一种特殊的函数，主要用于初始化对象，**首字母应该大写**，初始化对象时要用 `new` 关键字
>
> 与类一样，可以将公共的属性和方法抽取到里面封装起来

**实例成员：**在构造函数内部通过this添加的成员，只能通过实例对象访问

**静态成员：**给构造函数直接添加的成员，只能通过构造函数来访问

```js
function Star(uname, age) {
  this.uname = uname
  this.age = age
  this.sing = function () {
    console.log('sing')
  }
}
var ldh = new Star('刘德华', 18)
Star.sex = '男'
console.log(ldh) // Object { uname: "刘德华", age: 18, sing: sing() }
console.log(Star.sex) // 男
console.log(ldh.sex) // undefined
```

##### 14.4 原型

构造函数存在内存浪费的问题，当创建对象的时候，会开辟一块新的内存空间用于创建对象，但是当对象的内部有复杂数据类型比如方法时，又需要为方法开辟一块内存空间，这样每创建一个对象，都需要一块额外的内存空间用于创建对象的方法，这就造成了内存空间的浪费

```js
function Star(uname, age) {
  this.uname = uname
  this.age = age
  this.sing = function () {
    console.log('sing')
  }
}
var ldh = new Star('刘德华', 18)
var zxy = new Star('张学友', 18)
console.log(ldh.sing === zxy.sing) // false
```

所以我们就想如果创建的所有对象都使用同一个函数，岂不是就节约了内存，也方便了继承和维护

js 为我们提供了解决办法，在所有的构造函数（或者类，类也是函数）内部都默认存在一个 `prototype` 属性，属性值是一个对象，所以叫做原型对象，当我们需要一个不变的函数给创建的对象之间共享时，可以将这个函数定义给原型对象

```js
function Star(uname, age) {
  this.uname = uname
  this.age = age
}

Star.prototype.sing = function () {
  console.log('sing')
}

var ldh = new Star('刘德华', 18)
var zxy = new Star('张学友', 18)
ldh.sing()
zxy.sing()
console.log(ldh.sing === zxy.sing) // true
console.log(ldh)

// Object { uname: "刘德华", age: 18 }
//   age: 18
//   uname: "刘德华"
// <prototype>: Object { sing: sing(), … }
//   constructor: function Star(uname, age)
//   sing: function sing()
//     <prototype>: Object { … }
```

在**创建的对象**内部有一个 `__proto__` 属性指向其**构造函数的原型对象** `prototype`，这个叫做对象的原型

在 js 中每个实例对象都有一个私有属性 `__proto__`，这也是同一个构造函数创建的对象之间能共享定义在构造函数的原型对象上面的函数或者属性的原因

```js
console.log(ldh.__proto__ === Star.prototype) // true
```

当对象调用一个属性或函数时的查找执行规则：

先在对象自身的属性或函数中查找执行，如果有就直接使用，没有就去对象的原型也就是其构造函数的原型对象 `prototype` 上去找，如果还是找不到就往构造函数的原型对象的原型上去找（原型对象也是对象，也有原型 `__proto__`，它指向父构造函数的原型对象 `prototype`），这样如果有多个继承的构造函数，最终会指向 `Object` 的原型对象，而 `Object` 的原型对象的原型指向的是 `null`，至此查找结束，还是没有找到就报错，而一整个原型指向形成了一个链条，这就是**原型链**

```js
var o = {a: 1}

// o 这个对象继承了 Object.prototype 上面的所有属性
// o 自身没有名为 hasOwnProperty 的属性
// hasOwnProperty 是 Object.prototype 的属性
// 因此 o 继承了 Object.prototype 的 hasOwnProperty
// Object.prototype 的原型为 null
// 原型链如下:
// o ---> Object.prototype ---> null

var a = ["yo", "whadup", "?"]

// 数组都继承于 Array.prototype
// (Array.prototype 中包含 indexOf, forEach 等方法)
// 原型链如下:
// a ---> Array.prototype ---> Object.prototype ---> null

function f(){
  return 2
}

// 函数都继承于 Function.prototype
// (Function.prototype 中包含 call, bind等方法)
// 原型链如下:
// f ---> Function.prototype ---> Object.prototype ---> null
```

**属性遮蔽（property shadowing）：**

对象自身的属性和原型链上面的属性发生冲突时，优先选择自身的属性，原型上面的属性会被屏蔽掉

因为任何函数都可以添加到对象上作为对象的属性，所以函数和属性一样可以被属性屏蔽

> `__proto__` 是一个非标准属性，不能直接拿来做赋值等操作，它的作用**仅仅是指向其构造函数的原型对象**，并且它从来没有被包括在 ECMAScript  语言规范中，但是现代浏览器都实现了它
>
> MDN文档中的警告：**已废弃:** 该特性已经从 Web 标准中删除，虽然一些浏览器目前仍然支持它，但也许会在未来的某个时间停止支持，请尽量不要使用该特性
>
> 通过现代浏览器的操作属性的便利性，可以改变一个对象的 `[[Prototype]]` 属性, 这种行为在每一个JavaScript引擎和浏览器中都是一个非常慢且影响性能的操作，使用这种方式来改变和继承属性是对性能影响非常严重的
>
> 遵循 ECMAScript 标准，`someObject.[[Prototype]]` 符号是用于指向 `someObject` 的原型
>
> 从 ECMAScript 6 开始，`[[Prototype]]` 可以通过 [`Object.getPrototypeOf()`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/GetPrototypeOf) 和 [`Object.setPrototypeOf()`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/setPrototypeOf) 访问器来访问，这等同于属性 `__proto__`
>
> ```js
> // 让我们从一个函数里创建一个对象o，它自身拥有属性a和b的：
> let f = function () {
> this.a = 1;
> this.b = 2;
> }
> /* 这么写也一样
> function f() {
> this.a = 1;
> this.b = 2;
> }
> */
> let o = new f(); // {a: 1, b: 2}
> 
> // 在f函数的原型上定义属性
> f.prototype.b = 3;
> f.prototype.c = 4;
> console.log(o.d); // undefined
> // d 是 o 的自身属性吗？不是，那看看它的原型上有没有
> // d 是 o.[[Prototype]] 的属性吗？不是，那看看它的原型上有没有
> // o.[[Prototype]].[[Prototype]] 为 null，停止搜索
> // 找不到 d 属性，返回 undefined
> ```
>
> 类中的原型和 `Object.getPrototypeOf()`
>
> ```js
> class People {
>   constructor(name = 'people', age = 18) {
>     this.name = name
>     this.age = age
>   }
>   sayHi() {
>     console.log('Hi')
>   }
> }
> 
> class Student extends People{
>   constructor(gender = 'male') {
>     super()
>     this.gender = gender
>   }
>   sayHello() {
>     console.log('Hello')
>   }
> }
> 
> const zs = new Student()
> zs.sayHi()
> zs.sayHello()
> console.log(Object.getPrototypeOf(zs) === Student.prototype)
> console.log(Object.getPrototypeOf(Student.prototype))
> console.log(zs.name)
> 
> console.log(zs.[[Prototype]])  // 不要这样用，会直接报错
> console.log(Object.getPrototypeOf(zs))  // 正确地访问 [[Prototype]] 属性
> 
> // Hi
> // Hello
> // true
> // Object constructor: class People sayHi: ƒ sayHi() [[Prototype]]: Object
> // people
> // People constructor: class Student sayHello: ƒ sayHello() [[Prototype]]: Object
> ```

在对象原型和原型对象中有一个 `constructor` 属性，其指向构造函数本身，用于记录对象引用于哪个构造函数

有的时候我们需要修改原型对象，比如要添加的共享方法不止一个，我们把这些方法写成一个对象直接赋值给原型对象会更加方便

但是这样就把原来的原型对象给覆盖掉了，这就出现了问题

解决方法是重新指明原来的原型对象，这时就可以利用 `constructor` 属性指明原来的构造函数

```js
function Star(uname, age) {
  this.uname = uname
  this.age = age
}
Star.prototype = {
  constructor: Star, // 指明原本的构造函数是 Star
  sing() {
    console.log('sing')
  },
  movie() {
    console.log('movie')
  }
}
var ldh = new Star('刘德华', 18)
var zxy = new Star('张学友', 18)
console.log(Star.prototype.constructor) // function Star(uname, age)
console.log(ldh.__proto__.constructor) // function Star(uname, age)
```

利用原型对象，我们可以给 js 原本内置的对象拓展新的方法，比如给数组对象添加求和的方法，注意给内置对象拓展新方法只能用单个添加方法的方式添加，否则会报错，但是不推荐这种用法，除非是为了 js 的新特性而拓展，**不要轻易修改内置对象的方法**，一般也用不到

```js
Array.prototype.sum = function () {
  var sum = 0
  for (let i = 0; i < this.length; i++) {
    sum += this[i]
  }
  return sum
}
console.log(Array.prototype)

var arr = [1, 2, 3]
console.log(arr.sum()) // 6
```

在ES6之前没有提供继承的方法，所以如果要实现继承只能通过`call()`方法改变this的指向，从而让子构造函数继承父构造函数的属性，属于曲线救国，`call()`也可以起到调用普通函数的作用

```js
function Father(uname, age) {
  this.uname = uname
  this.age = age
}
function Son(uname, age) {
  // this本来指向子构造函数的实例对象
  // 但是这里修改为父构造函数的this指向了子构造函数的this
  Father.call(this, uname, age)
}
var son = new Son('刘德华', 18)
console.log(son.uname) // 刘德华
```

对于方法的继承则需要使用原型对象，但是不可以直接将子构造函数的原型对象指向父构造函数的原型对象，因为这样会导致对子构造函数的原型对象进行操作时影响父构造函数的原型对象,解决办法是指向一个新创建的父类对象，这样在父类对象中可以利用`__proto__`属性找到父构造函数的原型对象，进而找到继承的方法，而且对子构造函数的原型对象的修改就变成了对父类对象的修改，不会影响父构造函数的原型对象，只是在对子构造函数的原型对象修改之后记得将构造函数指回原来的构造函数

```js
Son.prototype = new Father()
Son.prototype.constructor = Son
```

#### 15 ES5新增函数

##### 15.1 数组

1. forEach

   对数组的每个元素执行一次给定的函数

   > forEach接收的参数是一个函数，故不能使用break或continue
   
   ```js
   // currentValue：数组当前项的值
   // index：数组当前项的索引号
   // arr：数组本身
   array.forEach(function (currentValue, index, arr) {})
   
   let numArr = [1, 2, 3]
   numArr.forEach(function (elem, i, arr) {
     if(arr[i] == 2) {
       break  // Uncaught SyntaxError: unlabeled break must be inside loop or switch
       continue  // Uncaught SyntaxError: continue must be inside loop
     }
     console.log(elem, i)
     console.log(arr)  // Array(3) [ 1, 2, 3 ]
     console.log(arr === numArr)  // true
   })
   ```
   forEach不会改变原数组，由于forEach接收参数是函数，而在js中函数参数是值传递的，故在函数中操作的数组元素只是一份值拷贝，因此如果数组元素是基本数据类型，那么不管如何操作都不会影响原数组，但是如果是引用数据类型，则可以修改其内容，同样的，重新给引用数据类型赋值也是不会生效的，因为被赋值的只是一份值拷贝，不会影响原数组元素
   
1. map

   创建一个**新数组**，新数组由原数组中的每个元素都调用一次提供的函数后的**返回值**组成，map的参数与forEach一致

   map不会改变原数组，这点和forEach是一样的，但是map会返回一个**新数组**
   
   >虽然forEach和map不会改变原数组，但是还是要注意当数组元素是引用数据类型时，依然可以更改原数组元素的内容
   
   ```js
   const array = [1, 2, 3]
   const newArray = array.map(elem => elem + 1)
   console.log(array, newArray);  // Array(3) [ 1, 2, 3 ]  Array(3) [ 2, 3, 4 ]
   
   
   const array = [{name: 'a'}, {name: 'b'}, {name: 'c'}]
   const newArray = array.map(elem => {
     elem.name = 'd'
     return elem
   })
   console.log(array, newArray);  // name全部为d
   ```
   
   当无法满足返回条件而无法返回值的时候，默认会返回undefined，这意味着新数组的长度与原数组保持一致
   
   ```js
   let numbers = [1, 2, 3, 4]
   let filteredNumbers = numbers.map(function(num, index) {
     if(index < 3) {
        return num
     }
   })
   console.log(filteredNumbers);  // Array(4) [ 1, 2, 3, undefined ]
   ```
   可见，通过map去筛选过滤一个数组可能不是一个好的选择，下一个介绍filter，就是用来筛选过滤数组的
   
2. filter

   创建一个新的数组，新数组由原数组中的每个**通过了测试条件的数组元素**组成

   同样的新数组获得的数组元素是一份浅拷贝，因为函数参数是值传递的
   
   filter的参数与forEach一致，会不会改变原数组的注意事项与forEach一致
   
   filter只会返回通过测试条件的元素，用于筛选数组元素时比map更为适合
   
   ```js
   let arr = [2, 6, 8, 12, 66, 88]
   let newArr = arr.filter(elem => elem >= 8)
   console.log(newArr)  // Array(4) [ 8, 12, 66, 88 ]
   ```
   
3. some

   检查数组中是否至少有一个元素满足测试条件，返回值为true或false

   如果找到了满足测试条件的**第一个元素**，则立即终止循环并返回true，否则跑完整个循环并返回false
   
   some的参数与forEach一致，会不会改变原数组的注意事项与forEach一致
   
   ```js
   let arr = [2, 6, 8, 12, 66, 88]
   let flag = arr.some(elem => {
     console.log(elem)  // 2 6 8 12
     return elem > 8
   })
   console.log(flag) // true
   ```
   与some类似的一个函数叫做every，同样返回值为true或false，参数也是一致的，唯一不同点是，every需要**所有的数组元素**都满足测试条件，才会返回true，否则返回false，同样的，当检测到一个元素不满足测试条件时会立即终止循环并返还false
   
5. reduce

   返回一个处理值，参数接收一个处理函数和一个初始值，初始值可选

   处理函数的参数与forEach的处理函数的参数基本一致，只不过第一个参数为累加器，后面三个参数保持一致

   累加器的值起初为传入的初始值的值，若没有传入初始值，则为数组第一个元素的值

   处理函数的执行位置起初为数组第一个元素，若没有传入初始值，则为数组第二个元素

   处理函数每次处理的结果将会赋值给累加器

   有了如上条件，reduce可实现如下应用：

   ```js
   const arr = [1, 1, 2, 3, 4, 5, 6]
   const sum = arr.reduce((t, v) => t + v, 0)  // 数组求和
   const product = arr.reduce((t, v) => t * v, 1)  // 数组累乘
   const maxNum = arr.reduce((t, v) => Math.max(t, v))  // 求最大值
   const uniqueArr = arr.reduce((t, v) => t.includes(v) ? t : [...t, v], [])  // 数组去重
   const elemCount = arr.reduce((t, v) => (t[v] = (t[v] || 0) + 1, t), {})  // 元素计数
   console.log(sum)  // 22
   console.log(product)  // 720
   console.log(maxNum)  // 6
   console.log(uniqueArr)  // Array(6) [ 1, 2, 3, 4, 5, 6 ]
   console.log(elemCount)  // Object { 1: 2, 2: 1, 3: 1, 4: 1, 5: 1, 6: 1 }
   ```


##### 15.2 字符串

1. `trim()`

   删除字符串两端的空白字符，**不影响原有字符串**而是返回一个新的字符串

   可用于解决判断是否已输入有效文字的问题，防止仅输入空格的情况
   
   ```js
   var str = ' l dh '
   console.log(str.trim()) // l dh
   ```

##### 15.3 对象

1. `Object.keys()`

   用于获取对象所有的属性，返回一个由属性名组成的**数组**，这个方法比forin的好处在于直接返回数组，可以在需要的时候调用

   ```js
   var obj = {
     id: 1,
     oname: 'xiaomi',
     price: 1999,
     num: 2000
   }
   var attriArr = Object.keys(obj)
   console.log(attriArr) // Array(4) [ "id", "oname", "price", "num" ]
   ```

2. `Object.defineProperty()`

   用于修改或新增对象属性，可设置一系列属性特性

   ```js
   var obj = {
     id: 1,
     oname: 'xiaomi',
     price: 1999,
     num: 2000
   }
   Object.defineProperty(obj, 'id', {
     value: 2, // 设置属性值，默认undefined
     writable: false, // 值是否可以被重写，默认false
     enumerable: false, // 不允许遍历，默认false
     configurable: false // 不允许删除，不允许再次配置属性的特性，默认false
   })
   obj.id = 1
   console.log(obj) // Object { id: 2, oname: "xiaomi", price: 1999, num: 2000 }
   ```

#### 16 函数进阶

函数可以利用构造函数创建，但是不常用，可以看出，所有的函数都是Function的实例对象

```js
var fn = new Function('a', 'b', `console.log(a + b)`)
fn(1, 2) // 3
```

##### 16.1 this指向

记住一句话：函数中的this指向是**在函数执行时确定的**，而不是在函数定义时确定

|       函数类别       |      this指向      |
| :------------------: | :----------------: |
|       普通函数       |       window       |
| 定时器、立即执行函数 |       window       |
|       箭头函数       |     词法作用域     |
|      对象的函数      |        对象        |
|    构造函数（类）    |      实例对象      |
|    绑定的事件函数    | 绑定事件函数的对象 |

> 1. 普通函数也就是直接定义，直接调用的函数，这时的函数 this 指向的是 window 对象，但是可以通过 `call()`、`apply()`、`bind()` 等方法去执行函数，在执行函数的时候改变其 this 的指向
> 2. 定时器 `setTimeout()` 里的回调函数的 this 指向的是 window 对象，因为定时器是 window 对象的函数，在定时器里执行的函数相当于是普通函数，所以其 this 指向了 window 对象，可是由于箭头函数的 this 指向的是其词法作用域中的 this，因此如果在定时器里面的回调函数是箭头函数的话，那么它的 this 可以指向定时器所在的词法作用域的 this
> 3. 匿名函数的执行环境具有全局性，所以立即执行函数中的 this 指向是 window 对象

通过 `call()`、`apply()`、`bind()` 等方法改变this指向

```js
// 1. call()可以正常调用函数，也可以改变this指向，这可以用来实现构造函数的继承
var obj = {
  name: 'ldh'
}
function fn() {
  console.log(this)
}
fn.call() // window
fn.call(obj) // Object { name: "ldh" }

function Father(uname, age, sex) {
  this.uname = uname
  this.age = age
  this.sex = sex
}
function Son(uname, age, sex) {
  Father.call(this, uname, age, sex)
}
var son = new Son('刘德华', 18, '男')
console.log(son) // Object { uname: "刘德华", age: 18, sex: "男" }

// 2. apply()可以正常调用函数，也可以改变this指向，但是其参数必须是伪数组的形式，可以配合内置函数使用
function fn1(arr) {
  console.log(this)
  console.log(arr)
}
fn1.apply(obj, ['hi']) // Object { name: "ldh" } / hi
var arr = [1, 3, 6, 9, 8]
// null表示不需要改变this指向，通过apply调用max()函数的同时传递数组参数进去求最大值
var max = Math.max.apply(null, arr)
// 但在严格模式下最好把this指回调用者Math
var min = Math.min.apply(Math, arr)
console.log(max) // 9
console.log(min) // 1

// 3. bind()不会正常调用函数，但是也可以改变 this 指向，返回值是一个改造之后的原构造函数的拷贝
// 如果有的函数我们不需要立即调用，但是又想改变函数中 this 指向，用 bind 就最合适，比方说按钮的禁用，常用
function fn2(a, b) {
  console.log(this)
  console.log(a + b)
}
var fn3 = fn2.bind(obj, 1, 2)
fn3() // Object { name: "ldh" } / 3

var btn = document.querySelector('button')
btn.onclick = function () {
  this.disabled = true

  // setTimeout里面函数的this指向的是window
  // setTimeout(function () {
  //   this.disabled = false
  //   console.log(this) // window
  // }, 3000)

  // 利用bind改变this指向btn，又不会立即调用函数，正好合适
  setTimeout(
    function () {
      this.disabled = false
      console.log(this) // <button>
    }.bind(this),
    3000
  )

  // ES6中的箭头函数, this总是指向词法作用域，也就是外层调用者obj，也可以解决这个问题
  // setTimeout(() => {
  //   this.disabled = false
  //   console.log(this) // <button>
  // }, 3000)
}

// 再来一个 bind 函数的例子
function fn1(a, b) {
  console.log('this: ', this)
  console.log(a, b)
  return 'this is fn1'
}

const fn2 = fn1.bind({x:100},10,20)
const fn3 = fn2()
console.log(fn3)

// this:  { x: 100 }
// 10 20
// this is fn1
```

手写 bind 函数：

利用 apply 函数去实现

```js
// 因为 bind 是 Function 的原型对象上的函数，故我们可以定义一个新的 bind1 函数
Function.prototype.bind1 = function () {
  // 由于 bind 函数的参数个数不确定，所以我们可以将函数的参数拆解为数组，以方便使用 apply 函数
  const args = Array.prototype.slice.call(arguments)
  // 传入 bind 函数的第一项参数是 this 指向的对象，先获取它
  const this_obj = args.shift()
  // 用变量接收调用 bind 函数的函数的 this
  const self = this
  return function () {
    return self.apply(this_obj, args)
  }
}
```

##### 16.2 严格模式

严格模式是ES5之后新增的，所以只兼容IE10以后的浏览器，即在严格的条件下运行js代码，消除了js语法中的一些不合理严谨的地方，减少了怪异行为，代码运行更加安全，提高编译效率增加运行速度，严格模式可以选择性地开启，应用到整个脚本或者单个函数中

- 为脚本开启

  在所有代码之前加上字符串标明

  ```js
  'use strict'
  ```
  或者在立即执行函数里面标明
  ```js
  (function () {
    'use strict'
  })()
  ```

- 为函数开启

  ```js
  function fn() {
    'use strict'
  }
  ```
  

严格模式下的主要变化：
1. 普通模式下的变量没有声明就赋值不会报错，严格模式会

   ```js
   'use strict'
   num = 10 // Uncaught ReferenceError: assignment to undeclared variable num
   console.log(num)
   ```

2. 严禁删除已声明的变量

   ```js
   'use strict'
   var num = 10
   delete num //  Uncaught SyntaxError: applying the 'delete' operator to an unqualified name is deprecated
   ```

3. 严格模式下全局作用域下的函数的this指向的是undefined而不是window

   > 在定时器中的函数还是指向的window，事件和对象的this依然指向调用者

   ```js
   'use strict'
   function fn() {
     console.log(this)
   }
   fn() // undefined
   
   setTimeout(function () {
     console.log(this) // window
   }, 1000)
   ```

   严格模式下构造函数如果当成普通函数调用而不加new关键字，this会报错，因为严格模式下普通函数的this指向undefined

   ```js
   'use strict'
   function Star() {
     this.sex = '男' // Uncaught TypeError: this is undefined
   }
   Star()
   ```

4. 严格模式下函数的参数不能重名

   ```js
   'use strict'
   function fn(a, a) { //  Uncaught SyntaxError: duplicate formal argument a
     console.log(a + a)
   }
   fn(1, 2) // 4
   ```

5. 严格模式下函数必须声明在顶层作用域，不允许声明在非函数的代码块内，比如if、for的代码块

##### 16.3 高阶函数

所谓的高阶函数就是指**接收函数作为参数**或者**将函数作为返回值返回**的函数，最典型的就是回调函数

##### 16.4 闭包

**闭包：**访问另一个函数作用域中的变量的**函数**及其**词法作用域的引用**共同组成了闭包

作用域链对闭包很重要，我们知道对自由变量的查找是在**函数定义的地方**向上级作用域查找，因此闭包包含的函数和其词法作用域的引用形成了作用域链的一部分

```js
// fun 函数访问到了 fn 函数中定义的局部变量，这就产生了闭包
function fn() {
  var num = 10
  function fun() {
    console.log(num)
  }
  fun()
}
fn() // 10
```

在实际应用中有两种常见的情况会产生闭包：

1. 当函数作为返回值被返回时

   这里的值为100的变量 a 和返回的匿名函数组成了闭包

   ```js
   function create() {
     let a = 100
     return function () {
       console.log(a)
     }
   }
   
   create()  // 直接这样写是不会执行返回的函数的，可以写成 create()()
   
   let fn = create()  // create()执行完毕后，其内部的 a 变量并没有销毁，因为其返回的匿名函数还没有被执行
   let a = 200
   fn()  // 但是更推荐这种方式， 100
   ```
   可以看到闭包的作用之一就是**延伸了变量的作用范围**，但要注意这是比较消耗内存的，函数作用域的变量没有被及时地销毁

2. 当函数作为参数被传递时

   这里值为100的 b 和被传递的函数组成了闭包

   ```js
   let b = 100
   function print(func) {
     let b = 200
     func()
   }
   function func() {
     console.log(b)
   }
   print(func)  // 100
   ```


常见的闭包应用

1. 点击 li 标签输出其索引号

   用循环注册事件的方法无法输出其索引值

   ```js
   // 点击li输出其索引号，一共有3个li
   var lis = document.querySelector('.nav').querySelectorAll('li')
   for (var i = 0; i < lis.length; i++) {
     lis[i].onclick = function () {
       // 点击事件我们不能确定它什么时候执行，只有点击的时候才会执行
       // 而循环是同步操作，当我们点击执行的时候，循环早就已经完成了
       // i 此时已经变成了 3，所以不管点哪个 li，输出都是 3
       console.log(i) // 3
     }
   }
   ```

   传统方法可以利用自定义属性去临时存储 i 的值，这样这里被存储的 i 和绑定的事件函数就形成了闭包

   ```js
   var lis = document.querySelector('.nav').querySelectorAll('li')
   for (var i = 0; i < lis.length; i++) {
     lis[i].index = i
     lis[i].onclick = function () {
       console.log(this.index)
     }
   }
   ```

   或者把定义i变量的 var 改为 let，原因和 let 的特性有关，在 for 循环的小括号中用 let 声明的 i 会在块级作用域中每次循环都重新声明初始化一次，就会有不同的 i，同时每循环一次都会产生一个块级作用域，let 的值也都被隔开互不影响，都形成了各自独立的闭包，最后的输出也就不同了

   ```js
   var lis = document.querySelector('.nav').querySelectorAll('li')
   for (let i = 0; i < lis.length; i++) {
     lis[i].onclick = function () {
       console.log(i)
     }
   }
   ```

   利用闭包获取 li 的索引，面试常问，这种方式会造成性能浪费，因为创建的立即执行函数中的变量 i 必须等待点击事件完成之后才会销毁

   ```js
   var lis = document.querySelector('.nav').querySelectorAll('li')
   for (var i = 0; i < lis.length; i++) {
     // 利用 for 循环创建4个立即执行函数，把 i 作为参数传递进去
     (function (i) {
       lis[i].onclick = function () {
         console.log(i)
       }
     })(i)
   }
   ```

2. 延迟打印 li 的内容

   直接利用 for 循环写会报错，原因依然是 for 循环是同步任务，而 setTimeout 是异步任务，执行时机不一样，任务队列也不一样，即使把延迟设置为 0，结果还是一样的，等执行到延时函数里时 i 已经变成了 3，然而不存在 `lis[3]` 这个元素，故报错

   ```js
   var lis = document.querySelector('.nav').querySelectorAll('li')
   for (var i = 0; i < lis.length; i++) {
     setTimeout(() => {
       console.log(lis[i].innerHTML()) // lis[i] is undefined
     }, 3000)
   }
   ```

   可以利用立即执行函数产生闭包解决

   ```js
   var lis = document.querySelector('.nav').querySelectorAll('li')
   for (var i = 0; i < lis.length; i++) {
     (function (i) {
       setTimeout(() => {
         console.log(lis[i].innerHTML)
       }, 3000)
     })(i)
   }
   ```
   
3. 隐藏内部数据，对外只提供 API

   这里返回的对象的函数和 data 形成了闭包，外界无法直接访问和修改 data，只能通过返回对象的函数（也就是API）进行访问修改

   ```js
   function createCache() {
     const data = {}
     return {
       set: function (key, val) {
         data[key] = val
       },
       get: function (key) {
         return data[key]
       }
     }
   }
   
   const c = createCache()
   c.set('a',100)
   console.log(c.get('a'))  // 100
   ```

##### 16.5 递归函数

如果一个函数**调用自身**，就叫做递归函数

```js
function fn() {
  fn() // Uncaught InternalError: too much recursion
}
fn()
```

但是要注意递归函数容易引起栈溢出错误，所以需要设置退出条件

```js
var num = 1
function fn() {
  console.log('recursion' + num)
  if (num == 6) {
    return
  }
  num++
  fn()
}
fn()
```

求阶乘

```js
function fn(n) {
  if (n == 1) {
    return 1
  }
  return n * fn(n - 1)
}
console.log(fn(3)) // 6
```

求斐波那契数列,数列从第三项开始，每一项等于前两项之和，0,1,1,2,3,5,8,13,21...

```js
function fb(n) {
  // 直接返回前三项
  if (n === 1) {
    return 0
  } else if (n === 2 || n === 3) {
    return 1
  }
  // 从第四项开始通过递归返回
  return fb(n - 1) + fb(n - 2)
}
console.log(fb(5)) // 3
```

##### 16.6 深浅拷贝

**拷贝：**将一个对象复制给另一个对象，包括对象的属性和属性值

###### 16.6.1 浅拷贝

浅拷贝就是将对象的属性循环遍历赋值给另一个对象的属性，从而达到拷贝属性的目的

但是这样做只是简单的属性之间的赋值，基础数据类型没问题，但是对于引用数据类型来说由于赋值的是地址，所以浅拷贝之后**拷贝对象**里的引用数据类型属性所指向的还是**被拷贝对象**里的属性，修改其内容，将会影响**被拷贝对象**里的属性值

利用es6提供的函数`Object.assign()`，可以直接实现浅拷贝

如下，修改了obj1的age，obj2的age不会受影响，但是修改obj1的study对象的属性，obj2也受到了影响

```js
const obj1 = {
  name: 'jack',
  age: 18,
  study: {
    book: 'javascript'
  }
}
const obj2 = {}
Object.assign(obj2, obj1)
obj1.age = 16
obj1.study.book = 'js'
console.log(obj2)  // { name: 'jack', age: 18, study: { book: 'js' } }
```

可以用for in循环遍历对象手动实现浅拷贝

```js
for (const k in obj1) {
  obj2[k] = obj1[k]
}
```

###### 16.6.2 深拷贝

深拷贝，顾名思义，和浅拷贝一样，只不过解决了浅拷贝对引用数据类型的属性拷贝不完全的问题

则在拷贝时会重新开辟一块内存空间给复杂数据类型的属性，然后把地址赋值给新拷贝的对象

可以利用`JSON`直接实现，但是`JSON`不能拷贝函数，故此处只考虑对象和数组的情况

```js
const objStr = JSON.stringify(obj1)
const obj2 = JSON.parse(objStr)
```

利用递归手动实现深拷贝

```js
// 双参数
function deepCopy(newObj, oldObj) {
  for (let k in oldObj) {
    if (oldObj[k] instanceof Array) {
      newObj[k] = []
      deepCopy(newObj[k], oldObj[k])
    } else if (oldObj[k] instanceof Object) {
      newObj[k] = {}
      deepCopy(newObj[k], oldObj[k])
    } else {
      newObj[k] = oldObj[k]
    }
  }
}

// 单参数
function deepClone(obj) {
  if (obj == null || typeof obj !== 'object') return obj
  const newObj = obj instanceof Array ? [] : {}
  for (const k in obj) {
    if (obj.hasOwnProperty(k)) newObj[k] = deepClone(obj[k])
  }
  return newObj
}
```

#### 17 正则表达式

用于匹配字符串中字符组合的模式，在 js 中正则表达式也是对象，有两种创建方式：

通过`RegExp`对象的构造函数

```js
var re = new RegExp(/123/)
console.log(re)
```

直接通过字面量
```js
var rg = /123/
console.log(rg)
```

测试字符串是否符合正则表达式的匹配规则
```js
var rg = /123/
console.log(rg.test(123)) // true
console.log(rg.test('a')) // false
```

`^`：以字符开头

`$`：以字符结尾

```js
// 只要包含有abc就行
var rg = /abc/
console.log(rg.test('abc'))
console.log(rg.test('aabcd123'))

// 必须以abc开头
var rg = /^abc/
console.log(rg.test('abc')) // true
console.log(rg.test('aabcd123')) // false
console.log(rg.test('abd')) // false

// 必须以abc结尾
var rg = /abc$/
console.log(rg.test('abc')) // true
console.log(rg.test('aabcd123')) // false
console.log(rg.test('dabc')) // true

// 精确匹配，必须是abc，只有abc能匹配
var rg = /^abc$/
console.log(rg.test('abc')) // true
console.log(rg.test('aabcd123')) // false
console.log(rg.test('dabc')) // false
```

字符选择类，提供一堆字符选择，匹配其中的一个即可，包含其中的一个字符

```js
var rg = /[abc]/
console.log(rg.test('abc')) // true
console.log(rg.test('aert')) // true
console.log(rg.test('credit')) // true
console.log(rg.test('r')) // false

// 三选一，只能是其中的一个
var rg = /^[abc]$/
console.log(rg.test('a')) // true
console.log(rg.test('aa')) // false
```

范围符，简写字符的范围

```js
// 26个字母中选择一个
var rg = /^[a-z]$/
console.log(rg.test('a')) // true
console.log(rg.test('aa')) // false
console.log(rg.test('r')) // true

// 26个字母中选择一个，不限大小写，或者下划线或者短横线
var rg = /^[a-zA-Z_-]$/
console.log(rg.test('a')) // true
console.log(rg.test('A')) // true
console.log(rg.test('-')) // true
```

如果`^`写在了`[]`里面则表示取反的意思，表示不能出现中括号中的字符

```js
// 26个字母中选择一个，不限大小写，或者下划线或者短横线
var rg = /^[^a-zA-Z_-]$/
console.log(rg.test('a')) // false
console.log(rg.test('A')) // false
console.log(rg.test('-')) // false
console.log(rg.test('!')) // true
console.log(rg.test('!1')) // false，只能匹配一个字符
```

量词符，限定某种匹配模式出现的次数

|   `*`   |     0或多次      |
| :-----: | :--------------: |
|   `+`   |     1或多次      |
|   `?`   |      0或1次      |
|  `{n}`  |       n次        |
| `{n,}`  | n或更多次，包括n |
| `{n,m}` | n到m次，包括n或m |

```js
// 不再匹配单个a，而是0或多个a
var rg = /^a*$/
console.log(rg.test('')) // true
console.log(rg.test('a')) // true
console.log(rg.test('aa')) // true
console.log(rg.test('aaa')) // true

// 至少要有一个a
var rg = /^a+$/
console.log(rg.test('')) // false
console.log(rg.test('a')) // true
console.log(rg.test('aa')) // true
console.log(rg.test('aaa')) // true

// a出现0或1次
var rg = /^a?$/
console.log(rg.test('')) // true
console.log(rg.test('a')) // true
console.log(rg.test('aa')) // false
console.log(rg.test('aaa')) // false

// a出现大于或等于3次
var rg = /^a{3,}$/
console.log(rg.test('')) // false
console.log(rg.test('a')) // false
console.log(rg.test('aa')) // false
console.log(rg.test('aaa')) // true
console.log(rg.test('aaaa')) // true

// a出现大于或等于3次并且小于等于6次
var rg = /^a{3,6}$/
console.log(rg.test('')) // false
console.log(rg.test('a')) // false
console.log(rg.test('aa')) // false
console.log(rg.test('aaa')) // true
console.log(rg.test('aaaa')) // true
console.log(rg.test('aaaaa')) // true
console.log(rg.test('aaaaaa')) // true
console.log(rg.test('aaaaaaa')) // false
```

验证用户名

```js
var rg = /^[a-zA-Z0-9_-]{6,16}$/
console.log(rg.test('andy007')) // true
console.log(rg.test('andy_007')) // true
console.log(rg.test('andy-007')) // true
```

小括号表示优先级，作为一个整体

```js
var rg = /^abc{3}$/
console.log(rg.test('abccc')) // true
console.log(rg.test('abcabcabc')) // false

var rg1 = /^(abc){3}$/
console.log(rg1.test('abccc')) // false
console.log(rg1.test('abcabcabc')) // true
```

预定义类，用于简化正则表达式的书写

| `\d` |         `[0-9]`          |
| :--: | :----------------------: |
| `\D` |         `[^0-9]`         |
| `\w` |      `[a-zA-Z0-9_]`      |
| `\W` |     `[^a-zA-Z0-9_]`      |
| `\s` | 匹配空格，`[\t\r\n\v\f]` |
| `\S` |     `[^\t\r\n\v\f]`      |

```js
// 匹配座机号码
var rg = /\d{3}-\d{8}|\d{4}-\d{7}/
```

利用正则也可以替换字符串中的字符，g 表示全局匹配，i 是不分大小写

```js
btn.onclick = function () {
  div.innerHTML = text.value.replace(/骂人|可恶/g, '**')
}
```

#### 18 ES6

ES的全称是ECMAScript，由ECMA国际标准化组织制定的脚本语言的标准化规范，而JavaScript就是实现了这一规范的脚本语言，ES6是一种泛指，泛指自2015年之后推出各种ES版本，新版本增加了不少有用的新特性，以及对语言的完善，功能的改进

##### 18.1 let

使用var声明变量导致了程序运行的不可预测性、语法过于松散，ES6新增了let关键字用于替换var，具有如下特点

1. 块级作用域

   在ES6之前只有**全局作用域**和**函数作用域**，ES6新增了**块级作用域**，也就是`{}`包括起来的区域

   比如if、for都有块级作用域，块级作用域的好处在于防止了块内变量覆盖块外变量

   比如使用var在块级作用域中声明的变量在块外依然可以访问

   ```js
   if (true) {
     var a = 1
   }
   console.log(a) // 1
   ```

   但是改为let声明在块外就不能访问了

   ```js
   if (true) {
     let a = 1
   }
   console.log(a) // Uncaught ReferenceError: a is not defined
   ```

   利用此特性可以防止循环变量变为全局变量

   比如使用var声明for循环中的循环变量i，在for循环结束后，在for循环外部还能访问到变量i，显然是不合理的

   > for循环的小括号内也是块级作用域

   ```js
   for (var i = 0; i < 2; i++) {
     console.log(i);  // 0 1
   }
   console.log(i) // 2
   ```

   如果换成let就不能访问了

   ```js
   for (let i = 0; i < 2; i++) {
     console.log(i);  // 0 1
   }
   console.log(i) // Uncaught ReferenceError: i is not defined
   ```

   还有就是如果使用let声明的for循环变量i，那么在循环内部调用定时器等函数时会自动形成闭包，循环变量i在循环期间不会被释放

   ```js
   for (var i = 0; i < 2; i++) {
     setTimeout(() => {
       console.log(i);  // 0 1
     });
   }
   ```
   转为es5的代码，可以看到，定时器会被放到一个函数内部，从而形成闭包

   ```js
   var _loop = function _loop(i) {
     setTimeout(function () {
       console.log(i); // 0 1
     });
   };
   for (var i = 0; i < 2; i++) {
     _loop(i);
   }
   ```

2. 不存在变量提升

   在let未推出之前，存在变量提升的现象，就是把**变量声明**提升提到函数最顶部的地方，但是不会提升赋值

   ```js
   console.log(a) // undefined
   var a = 20
   ```

   由于变量提升，上面的代码相当于

   ```js
   var a
   console.log(a)
   a = 20
   ```

   只声明不赋值的话，变量值会初始化为undefined，在执行到赋值语句之前打印，输出自然为undefined

   若改为let则会报错：在初始化之前不能访问变量a

   ```js
   console.log(a) // Uncaught ReferenceError: can't access lexical declaration 'a' before initialization
   let a = 20
   ```

3. 暂时性死区

   使用let在块级作用域中声明变量后，这个块级作用域就相当于成了一片暂时性死区

   尽管外界声明了相同名称的变量，但是在块级作用域中不会识别外界相同名称的变量

   ```js
   var num = 10
   if (true) {
     console.log(num) // Uncaught ReferenceError: can't access lexical declaration 'num' before initialization
     let num = 20
   }
   ```

4. 不属于全局对象window

   ```js
   let a = 1;
   b = 2;
   console.log(window.a);  // undefined
   console.log(window.b);  // 2
   ```

5. 不允许重复声明

   ```js
   let a = 1;
   let a = 2;  // SyntaxError: Identifier 'a' has already been declared
   ```


##### 18.2 const

ES6新增的const用于声明常量，常量是指一旦被声明赋值的变量，其值不能被更改，const声明的变量具有和let声明的变量一样的特性，除此之外有两点需要注意的地方

1. const声明常量时必须赋初始值

   ```js
   const PI // Uncaught SyntaxError: missing = in const declaration
   ```

2. 引用数据类型常量

   如果常量值是一个引用数据类型，则不能被更改的值是引用地址，但是引用指向的对象的值是可以改变的，比如数组元素的值

   ```js
   const PI = 3.14
   PI = 100 // Uncaught TypeError: invalid assignment to const 'PI'
   
   const arr = [1, 2, 3]
   arr[0] = 'a'
   arr[1] = 'b'
   arr[2] = 'c'
   console.log(arr) // Array(3) [ "a", "b", "c" ]
   arr = [] // Uncaught TypeError: invalid assignment to const 'arr'
   ```

>const声明的常量由于不会变化，浏览器不需要实时监测其值的变化，有利于程序效率的提高
>
>何时选用const：如果确定当前定义的变量后面不会再被更改，就可以选用const

##### 18.3 箭头函数

ES6推出了箭头函数，主要用于简化函数的定义语法，同时也有一些新的特性

```js
() => {}
```

箭头函数没有名称，小括号中依然是函数形参，大括号是函数体

由于箭头函数没有名称，所以通常我们会将其赋值给一个变量，然后通过变量名来调用

当箭头函数作为参数进行传递时，不需要函数名称

```js
const fn = () => {
  console.log(23)
}
fn() // 23
```

当函数体中只有一句代码时，可以省略大括号

此时箭头函数会将表达式作为返回值进行返回，因此return关键字也可以省略

```js
const fn = () => console.log(23)
fn() // 23

const sum = (num1, num2) => num1 + num2
console.log(sum(1, 2)) // 3
```

当只有一个形参时，小括号也可以省略

```js
const fn = v => v
console.log(fn(6)) // 6
```

要注意箭头函数中的this指向的是**词法作用域**，也就是箭头函数所在的**上下文的this**

> 解释一下为什么say打印的this是{}，因为是在node环境下运行的，如果是浏览器环境则是window
>
> 那为什么没有指向global？因为在Node.js的模块作用域中，this默认指向module.exports，而不是全局对象global

```js
const obj = {
  uname: 'jack',
  sing: function() {
    console.log(this, this.uname)
  },
  say: () => console.log(this, this.uname)
}
obj.sing()  // { uname: 'jack', sing: [Function: sing], say: [Function: say] } jack
obj.say()  // {} undefined
```
此外还需注意，箭头函数不能用作构造函数，在箭头函数内部也不能使用默认的类数组arguments

可以看到浏览器环境下arguments未定义，node环境虽然打印了arguments，却不是我们希望的内容

```js
const fun1 = function() {
  console.log(arguments)
}
fun1(1, 2, 3)  // [Arguments] { '0': 1, '1': 2, '2': 3 }

const fun2 = () => console.log(arguments)
// Uncaught ReferenceError: arguments is not defined  浏览器环境
// [Arguments] { '0': {}, '1': [Function: require] ... }  node环境
fun2(1, 2, 3)
```

##### 18.4 解构赋值

解构赋值是对数组和对象的更简洁的操作方式，可以一行代码就能从数组中提取出数组元素

```js
let arr = [1, 2, 3]
let [a, b, c] = arr
console.log(a) // 1
console.log(b) // 2
console.log(c) // 3
```

像这样变量和数组元素是一一对应的时候很好理解，但如果变量数量和数组元素数量不一样多呢，答案是没有对应起来的变量的值将是undefined，因为没有赋值操作，自然是初始值undefined

变量数量少于数组元素：

```js
let arr = [1, 2, 3]
let [a, b] = arr
console.log(a) // 1
console.log(b) // 2
```

变量数量多于数组元素：

```js
let arr = [1, 2, 3]
let [a, b, c, d, e] = arr
console.log(a) // 1
console.log(b) // 2
console.log(c) // 3
console.log(d) // undefined
console.log(e) // undefined
```

> 数组的解构赋值方式也可以应用到对字符串的解构上面，变量与字符串的字符一一对应即可

对于对象的解构则是用变量名称去匹配对象的属性名称，和数组不一样，这里没有顺序的考量，匹配上了就进行赋值

```js
let person = {
  uname: '张三',
  age: 18,
  sex: '男'
}
let { sex, uname, age } = person
console.log(uname) // 张三
console.log(age) // 18
console.log(sex) // 男
```

对于对象的解构还可以给变量取别名，但是要注意起了别名就只能用别名了，原变量名失效

```js
let person = {
  uname: '张三',
  age: 18,
  sex: '男'
}
let { uname: myName, age: myAge, sex: mySex } = person
// console.log(uname) // Uncaught ReferenceError: uname is not defined
console.log(myName) // 张三
```
讲了半天，解构赋值的应用场景有哪些呢

除了一般在取值的时候比较方便外，在函数传参的时候也是可以应用解构赋值的

```js
let arr = [1, 2, 3]

function foo([a, b, c]) {
  console.log(a, b, c);
}
foo(arr)  // 1 2 3

let person = {
  uname: '张三',
  age: 18,
  sex: '男'
}

function foo({age, sex, uname}) {
  console.log(uname, age, sex);
}
foo(person)  // 张三 18 男
```

##### 18.5 拓展运算符

将数组或者对象转化为以**逗号**分隔的参数序列

```js
const arr = [1, 2, 3]
console.log(...arr) // 1 2 3  // 逗号成了参数分隔符
```

利用拓展运算符可以很方便地合并数组

```js
const arr1 = [1, 2, 3]
const arr2 = [4, 5, 6]
const arr3 = [...arr1, ...arr2]
console.log(arr3) // Array(6) [ 1, 2, 3, 4, 5, 6 ]
arr1.push(...arr2)
console.log(arr1) // Array(6) [ 1, 2, 3, 4, 5, 6 ]
```

将伪数组转换为真正的数组

```js
const divs = document.getElementsByTagName('div')
console.log(divs) // HTMLCollection { 0: div, 1: div, 2: div, length: 3 }
const divsArr = [...divs]
console.log(divsArr) // Array(3) [ div, div, div ]
```

字符串也是可以使用拓展运算符的

```js
const str = 'spread'
const arr = [...str]
console.log(arr)  // [ 's', 'p', 'r', 'e', 'a', 'd' ]
```


##### 18.6 剩余参数

剩余（rest）参数就是在函数传参时把**数量不确定的参数**组合成一个数组，可看成是拓展运算符的逆运算

剩余参数与拓展运算符写法都是一样的，如何区分呢？

看是什么时候用，用作形参时，就是剩余参数，用作实参时就是拓展运算符

```js
const sum = (...args) => {  // 作为形参使用，此时是剩余参数
  let total = 0
  args.forEach(item => total += item)
  return total
}
console.log(sum(10, 20)) // 30
console.log(sum(10, 20, 30)) // 60


const arr = [1, 2, 3]
const [x, ...y] = arr  // 此时可理解为形参，接收参数2和3，然后组合成了数组
console.log(x)  // 1
console.log(y)  // [ 2, 3 ]
```

##### 18.7 ES6新增函数

###### 18.7.1 数组

1. find

   返回数组中满足测试条件的**第一个**元素的**值**，否则返回undefined

   find的参数与forEach的参数一致，同样不会改变原数组

   与some类似，若找到满足测试条件的元素则返回该元素，立即终止循环，否则跑完整个循环返回undefined

   与find具有相同功能的函数是findLast，只不过顺序与find相反，是从最后一个元素开始往前遍历的

   ```js
   const arr = [
     { id: 1, uname: 'jack' },
     { id: 1, uname: 'michael' },
     { id: 2, uname: 'james' },
     { id: 3, uname: 'johnson' }
   ]
   const target = arr.find(elem => elem.id == 1)
   const reverseTarget = arr.findLast(elem => elem.id == 1)
   console.log(target)  // Object { id: 1, uname: "jack" }
   console.log(reverseTarget)  // Object { id: 1, uname: "michael" }
   ```

2. findIndex

   返回数组中满足测试条件的**第一个**元素的**索引**，否则返回-1

   findIndex其余注意事项与find一致

   同样的，具有相同查找功能但方向相反的函数是findLastIndex

   ```js
   const arr = [
     { id: 1, uname: 'jack' },
     { id: 1, uname: 'michael' },
     { id: 2, uname: 'james' },
     { id: 3, uname: 'johnson' }
   ]
   const targetIndex = arr.findIndex(elem => elem.id == 1)
   const reverseTargetIndex = arr.findLastIndex(elem => elem.id == 1)
   console.log(targetIndex)  // 0
   console.log(reverseTargetIndex)  // 1
   ```

3. includes

   数组是否包含指定的值，返回布尔值，可以检测NaN

   ```js
   const arr = [1, 3, 2, 5, 6, 8, NaN]
   const result1 = arr.includes(6)
   const result2 = arr.includes(7)
   const result3 = arr.includes(NaN)
   console.log(result1) // true
   console.log(result2) // false
   console.log(result3) // true
   ```

4. `Array.from()`

   将类数组或可迭代对象转换为一个新的真数组，该真数组是一个浅拷贝

   ```js
   const arrLike = {
     0: 'jack',
     1: 'james',
     2: 'michael',
     length: 3
   }
   const arr = Array.from(arrLike)  // const arr = Array.prototype.slice.call(arrLike)
   console.log(arr) // Array(3) [ "jack", "james", "michael" ]
   ```

   可以接收函数参数，用于处理转换的过程

   ```js
   const arrLike = {
     0: 'jack',
     1: 'james',
     2: 'michael',
     length: 3
   }
   const arr = Array.from(arrLike, elem => elem + ' love watermelon')
   console.log(arr) // Array(3) [ "jack love watermelon", "james love watermelon", "michael love watermelon" ]
   ```

###### 18.7.2 字符串

1. 模板字符串

   ```js
   // 1. 模板字符串可以解析变量
   let uname = '张三'
   let sayHello = `hello, my name is ${uname}`
   console.log(sayHello) //  hello, my name is 张三
   
   // 2. 模板字符串可以换行
   let result = {
     uname: '张三',
     age: 20,
     sex: '男'
   }
   let html = `<div>
     <span>${result.uname}</span>
     <span>${result.age}</span>
     <span>${result.sex}</span>
   </div>`
   console.log(html)
   // <div>
   //   <span>张三</span>
   //   <span>20</span>
   //   <span>男</span>
   // </div>
   
   // 3. 模板字符串可以调用函数
   const sing = () => 'i want something just like this'
   let chris = `i'm singing that ${sing()}`
   console.log(chris) // i'm singing that i want something just like this
   ```

2. `startsWith()` 和 `endsWith()`

   表示字符串是否以指定字符开头或者结尾，返回布尔值

   ```js
   let str = 'hello world!'
   let result1 = str.startsWith('hello')
   let result2 = str.endsWith('!')
   console.log(result1) // true
   console.log(result2) // true
   ```

3. `repeat()`

   将字符串重复指定的次数并且返回新的字符串

   ```js
   let str = 'hello world!'
   let result1 = str.repeat(2)
   let result2 = str.repeat(3)
   console.log(result1) // hello world!hello world!
   console.log(result2) // hello world!hello world!hello world!
   ```

##### 18.8 对象属性

当对象属性的名称与其值的名称相同时，可以简写

```js
const name = 'jack'
const age = 18
const stu = { name, age }
console.log(stu)  // { name: 'jack', age: 18 }
```

如果对象属性的名称想使用变量的值的话，可以加`[]`

```js
const name = 'jack'
const age = 18
const sch = 'school'
const fruit = 'cherry'
const stu = { name, age, [sch]: fruit }
console.log(stu)  // { name: 'jack', age: 18, school: 'cherry' }
```



##### 18.9 Set

Set 是 ES6 提供的新的数据结构，类似于数组，但是其元素的值是唯一的，Set 对象允许你存储任何类型的唯一值，无论是[原始值](https://developer.mozilla.org/zh-CN/docs/Glossary/Primitive)或者是对象引用

如果需要存储不重复的值，就可以使用 Set 了，比如记录用户的搜索记录

```js
// 创建一个空的set
const s = new Set()
console.log(s.size) // 0
// 创建时接收数组作为初始化参数
const s1 = new Set([1, 2, 3])
console.log(s1.size) // 3

// 利用Set去重数组
const s2 = new Set(['a', 'a', 'b', 'b'])
console.log(s2) // Set [ "a", "b" ]
let arr = [...s2]
console.log(arr) // Array [ "a", "b" ]
```

Set为我们提供了方法去操作其中的元素

```js
const s = new Set()
s.add(1).add(2).add(3).add('a')
console.log(s) // Set(4) [ 1, 2, 3, "a" ]
console.log(s.delete('a')) // true
console.log(s) // Set(3) [ 1, 2, 3 ]
console.log(s.has(2)) // true
s.clear()
console.log(s) // Set []
```

Set可以和数组一样使用foreach遍历元素

```js
const s = new Set(['a', 'b', 'c'])
s.forEach(val => console.log(val))
// a
// b
// c
```

##### 18.10 Promise

Promise 是es6 引进的 api，专门用于处理 js 中的异步编程的问题
我们先看看下面的例子，Ajax 接口返回的是一个字符串 helloworld，我们期望打印的是 helloworld

```js
let ret = 'ret'
$.ajax({
    url: 'http://localhost:3000/data',
    success: function (data) {
        ret = data
    }
})
console.log(ret)  // ret
```

然而，结果没有打印 helloworld 而是打印了 ret

这是因为 Ajax 请求是一个异步任务，代码的顺序执行是一个同步任务，同步任务不会去等待异步任务的执行完毕，它们是不同的执行栈

更糟糕的是，当有多个 Ajax 异步接口调用时（这种情况非常常见，不止一个接口），接口返回结果的时间是不确定的，因为返回时间会受到网络状况和某些情况的影响

```js
$.ajax({
    url: 'http://localhost:3000/data',
    success: function (data) {
        console.log(data)
    }
})
$.ajax({
    url: 'http://localhost:3000/data1', // 设置成了延迟 1s 返回数据
    success: function (data) {
        console.log(data)
    }
})
$.ajax({
    url: 'http://localhost:3000/data2',
    success: function (data) {
        console.log(data)
    }
})
```

尽管 data1 接口 是位于 2 号位顺序的，却是最后才打印的，因为它的执行时间最晚，但是这种情况却不符合人的直观感觉，因为代码的书写顺序和代码的执行结果不一样

所以对于异步程序，我们不能依赖其代码的**书写顺序**来判断**执行顺序**

如果确定需要异步任务按照某种书写顺序执行而不受异步的影响，比如网络、延时等的影响，则需要进行嵌套书写

```js
$.ajax({
    url: 'http://localhost:3000/data',
    success: function (data) {
        console.log(data)
        $.ajax({
            url: 'http://localhost:3000/data1',
            success: function (data) {
                console.log(data)
                $.ajax({
                    url: 'http://localhost:3000/data2',
                    success: function (data) {
                        console.log(data)
                    }
                })
            }
        })
    }
})
```

（这..这搁这儿套娃呢）如上通过回调函数来进行嵌套书写确实可以按顺序打印结果，而不受data1接口的请求时间最长的影响，但是这样书写存在一个致命问题，就是**代码可读性极差**，代码看起来就像一个漏斗，这还只是仅仅嵌套了三层，要是嵌套了十几层，那不敢想象，简直就是十八层地狱，所以这种嵌套书写方式也叫作回调地狱，为了解决这种问题，Promise诞生了

Promise是一个函数对象，通过它可以获取异步操作的消息

Promise主要解决了回调地狱的问题，以及提供了更加简洁的api用于控制异步操作

```js
console.log(typeof Promise) // function
console.log(Promise) // ƒ Promise() { [native code] }
```

Promise的字面意思就可以直接理解为承诺，我们知道异步任务的结果有成功的也有失败的，当发生对应的情况的时候，Promise都提供了对应的解决方案，这就是对不同情况的承诺

首先要使用Promise要实例化出一个Promise实例，在构造函数中传递回调函数，回调函数中有两个参数`resolve`和`reject`分别用于处理异步任务成功和失败的情况，然后通过`then()`来获取处理的结果，具体看下面的代码

```js
var promise = new Promise(function (resolve, reject) {
    setTimeout(function () {
        // var flag = true
        var flag = false
        if (flag) {
            // 处理成功的情况
            resolve('success')
        } else {
            // 处理失败的情况
            reject('fail')
        }
    }, 1000)
})

promise.then(
    function (data) {
        console.log(data)  // 成功时打印success
    },
    function (info) {
        console.log(info)  // 失败时打印fail
    }
)
```

> promise 有几个内部属性，state 、result，执行器 executor 函数将会改变这些内部属性的值
>
> - state：有三种状态，起初是 pending 的状态，在 executor 执行结束后变为 fulfilled 或者 rejected 状态，状态的更改是最终的，也就是说在 executor 内部一旦调用 resolve 或者 reject 函数后状态将会确定，之后再调用 resolve 或者 reject 将会不生效，会被忽略掉
>
> - result：起初是 undefined，如果执行的是 `resolve(value)` 那么会变为 value，如果执行的是 `rejected(error)` 那么会变为 error
>
> 需要注意这两个属性是内部属性，从**外部无法直接访问**

用Promise封装原生Ajax请求

```js
function queryData(url) {
    return new Promise(function (resolve, reject) {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== 4) {
                return
            }
            if (xhr.readyState == 4 && xhr.status == 200) {
                resolve(xhr.responseText)
            } else {
                reject('server error')
            }
        }
        xhr.open('get', url)
        xhr.send(null)
    })
}
```

然后就可以调用这个封装的函数，在then方法中分别处理成功和失败的情况，成功会执行第一个回调函数参数，失败执行第二个

> 如果只对成功的情况感兴趣，可以只传第一个函数参数
>
> 如果只对失败的情况感兴趣，第一个参数可以传 null，或者不使用 then 直接使用catch，两种写法可以认为是等价的
>
> ```js
> let promise = new Promise((resolve, reject) => {
>   setTimeout(() => reject(new Error("Whoops!")), 1000)
> })
> 
> // .catch(f) 与 promise.then(null, f) 一样
> promise.catch(alert) // 1 秒后显示 "Error: Whoops!"
> ```

```js
queryData('http://localhost:3000/data').then(
    function (data) {
        console.log(data)
    },
    function (info) {
        console.log(info)
    }
)
```

了解了Promise处理异步的流程之后我们来看看它是如何解决回调地狱的问题的

```js
queryData('http://localhost:3000/data')
    .then(function (data) {
      console.log(data)
      return queryData('http://localhost:3000/data1')
    })
    .then(function (data) {
      console.log(data)
      return queryData('http://localhost:3000/data2')
    })
    .then(function (data) {
      console.log(data)
    })
```
通过不断返回Promise对象，然后调用then方法的方式，循环调用封装的方法访问接口，接口调用形式变成了线性的链式调用，代码可读性得到了大大的提高
>then方法里可以只处理成功的情况而不处理失败的情况
>
>then方法里的回调函数返回的如果不是Promise对象而是普通值，那么下一个then的回调函数得到的就是这个普通值，这里没有返回Promise对象而可以继续调用then方法的原因是then方法里还是返回了默认的Promise对象，所以**无论如何then方法都会返回一个Promise对象**
>
>```js
>.then(function (data) {
>   console.log(data)
>   return 'hello'
>})
>.then(function (data) {
>   console.log(data)  // hello
>})
>```

**Promise实例方法：**

1. `then()`

   得到异步任务的处理结果，返回Promise对象，返回处理结果

2. `catch()`

   获取异常信息

3. `finally()`

   无论成功与否均会调用，非正式标准

```js
function fn() {
    return new Promise(function (resolve, reject) {
        setTimeout(function () {
            resolve(123)
        }, 2000)
    })
}

fn()
    .then(function (data) {
        console.log(data)
    })
    .catch(function (data) {
        console.log(data)
    })
    .finally(function (data) {
        console.log('finally')
    })
```

正常情况打印了123和finally，换为`reject('error')`执行，打印结果是error和finally

这里使用catch或者直接在then方法里传递第二个回调函数来处理失败情形**效果是完全一致的**

**Promise对象方法：**

Promise 对象方法可以直接通过 Promise 调用

1. `Promise.all()`

   用于并发处理多个异步任务，所有的异步任务都执行完成才能得到结果，通过数组形式接收多个异步任务，得到的结果也是数组的形式

   ```js
   var p1 = queryData('http://localhost:3000/a1')
   var p2 = queryData('http://localhost:3000/a2')
   var p3 = queryData('http://localhost:3000/a3')
   Promise.all([p1, p2, p3]).then(function (result) {
       console.log(result) // ['Hello TOM!', 'Hello JERRY!', 'Hello SPIKE!']
   })
   ```

2. `Promise.race()`

   同样用于并发处理多个异步任务，但是如同其名“竞赛”，只要有一个异步任务先执行完成就能得到结果，对于其余未完成的结果并不关心，即使后面也完成了，也不会去处理

   ```js
   var p1 = queryData('http://localhost:3000/a1')
   var p2 = queryData('http://localhost:3000/a2')
   var p3 = queryData('http://localhost:3000/a3')
   Promise.race([p1, p2, p3]).then(function (result) {
       console.log(result) // Hello TOM!
   })
   ```

##### 18.11 Class
参见本文 [14 面向对象](#)

#### 19 ES7
##### 19.1 async/await

async/await 是 ES7 引入的新语法，可以让异步操作变得更简单

- async 用在函数上，函数返回的是 Promise 实例对象
- await 则必须用在 async 函数**内部**，利用 await 可以获得异步操作的结果

```js
axios.defaults.baseURL = 'http://localhost:3000/'
async function queryData() {
    let ret = await axios.get('adata')
    return ret.data
}
queryData().then(data => console.log(data))
```

async/await 的最大用处是**同步处理**多个异步请求

```js
axios.defaults.baseURL = 'http://localhost:3000/'
async function queryData() {
    let info = await axios.get('async1')
    let ret = await axios.get('async2?info=' + info.data)
    return ret.data
}
queryData().then(data => console.log(data)) // world
```

后台的 express 代码

```js
app.get('/async1', (req, res) => {
    setTimeout(() => {
        res.send('hello')
    }, 3000)
})

app.get('/async2', (req, res) => {
    if (req.query.info == 'hello') {
        res.send('world')
    } else {
        res.send('error')
    }
})
```

可以看到后台接口 async1 被设置成了延迟 3s 才返回结果，然而异步请求 async2 接口的异步操作依赖于这个结果，所以只能**强行等待** 3s 获得结果之后才去发起请求，async/await 让这两个异步操作之间变成了同步操作，消除了异步任务返回时间的不确定性对代码顺序产生的影响，因此如果下一个异步操作依赖于上一个异步操作的结果，那么使用 async/await 无疑是不错的选择

#### 20 性能优化

##### 20.1 防抖和节流

**防抖：**对于短时间内连续触发的事件，防抖的含义就是让某个时间期限之内，事件处理函数只执行一次，防止了短时间内大量触发事件处理函数导致性能浪费

实现：第一次执行函数时给出一个延时，在延时之内如果重复触发了执行函数，则重新开始延时计算

案例：监听浏览器滚动条位置、页面适配时监听页面大小

```js
var i = 0
function showTop() {
  i++
  var scrollTop = document.body.scrollTop || document.documentElement.scrollTop
  console.log(`滚动条位置：${scrollTop}，触发了${i}次`)
}
window.onscroll = debounce(showTop, 1000)

/**
 *
 * @param {Function} fn 需要防抖的函数
 * @param {Number} delay 延迟执行的毫秒数
 * @returns 延迟执行函数
 */
function debounce(fn, delay) {
  let timer = null
  // 利用闭包，维护变量纯净
  return function () {
    if (timer) {
      clearTimeout(timer)
    }
    timer = setTimeout(fn, delay)
  }
}
```

**节流：**类似控制阀门一样定期开放执行函数，也就是让函数执行一次后，在某个时间段内暂时失效，过了这段时间后再重新激活，就像技能冷却一样

实现：有多种实现思路，比如利用标志位加定时器，通过标志位判定、直接判断定时器、设置时间戳，通过时间间隔判断

案例：输入框做实时搜索时，间隔一段时间就搜索一次，而不是每个字输完都搜索，或者输入的间隔时间大于某个值则认为输入完成，进行搜索

```js
var i = 0
function showTop() {
  i++
  var scrollTop = document.body.scrollTop || document.documentElement.scrollTop
  console.log(`滚动条位置：${scrollTop}，触发了${i}次`)
}
window.onscroll = throttle(showTop, 1000)

/**
 *
 * @param {Function} fn 需要节流的函数
 * @param {*} delay 延迟间隔
 * @returns 节流函数
 */
function throttle(fn, delay) {
  // let valid = true
  // return () => {
  //   // valid值为false，说明fn()未执行，正在冷却
  //   if (!valid) {
  //     return false
  //   }
  //   valid = false
  //   setTimeout(() => {
  //     fn()
  //     valid = true
  //   }, delay)
  // }

  // let timer = null
  // return () => {
  //   if (timer) {
  //     return false
  //   }
  //   timer = setTimeout(() => {
  //     fn()
  //     timer = null
  //   }, delay)
  // }

  let time = 0
  return () => {
    let now = +new Date()
    if (now - time > delay) {
      fn()
      time = now
    }
  }
}
```

##### 20.2 缓存和一次性操作

**缓存DOM 查询**

DOM 操作是比较浪费性能的，对于大量的 DOM 操作，我们可以对 DOM 的查询结果进行主动的缓存，以提高性能

> 为什么浏览器不做缓存呢，因为 js 是操作 DOM 的，可能会中途修改 DOM，这样就不能保证查询 DOM 的准确性，所以是否缓存查询结果由我们自己决定

```js
// 无缓存
for (let i = 0; i < document.getElementsByTagName('p').length; i++) {
  console.log('no cache')
}

// 有缓存
const pList = document.getElementsByTagName('p')
const length = pList.length
for (let i = 0; i < length; i++) {
  console.log('cache')
}
```

**一次性操作**

对于需要多次的重复操作 DOM，可以想办法将这些重复操作中不需要操作 DOM 的部分提前整合做完，再去一次性地操作 DOM，这样就最大限度地减少了 DOM 的操作次数

比如创建很多个 li 元素插入 ul 元素中：

```js
var element  = document.getElementById('ul')
var fragment = document.createDocumentFragment()
var browsers = ['Firefox', 'Chrome', 'Opera', 'Safari', 'Internet Explorer']

browsers.forEach(function(browser) {
    var li = document.createElement('li')
    li.textContent = browser
    fragment.appendChild(li)
})

element.appendChild(fragment)
```

又比如使用 `innerHTML` 去修改元素，如果内容较多，可以提前对内容进行处理

由于 `innerHTML` 采用的是**拼接字符串**的方式，每一次都去拼接字符串的效率较低，我们先将这些字符串 `push()` 起来组成数组，然后利用 `join()` 将其转为字符串一次性写给元素，这种方式的效率非常快

```js
let el = document.querySelector('div')
let htmlArr = []
htmlArr.push('<ul>')
for (let i = 1; i < 4; i++) {
  htmlArr.push(`<li>${i}</li>`)
}
htmlArr.push('</ul>')
let htmlStr = htmlArr.join('')
// 只操作了一次 DOM
el.innerHTML = htmlStr
```













