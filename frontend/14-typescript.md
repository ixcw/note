#### 1 TypeScript
ts是js的超集，是对js的拓展，引进了一些别的语言的优秀特性到js中，补充完善了js的部分功能

#### 2 相对于js的优势

主要优势就是ts的静态类型带来的一系列好处

1. 解决了js动态类型可以随意赋值带来的混乱

2. 在代码编写阶段就会报错，不会等到代码编译后才发现错误

3. 编辑器更加友好的智能提示，由于拥有静态类型，编辑器可以很方便地推断出某个变量所拥有的方法和属性

#### 3 安装使用ts

安装：

```bash
npm install typescript -g  # 全局安装最新版的ts
```

使用：

```bash
tsc xxx.ts  # 编译ts文件为js文件
```

然后就可以用node运行js文件了

```bash
node xxx.js
```

但是这样每次都要手动转换ts文件为js文件，我们可以安装`ts-node`工具来自动转换执行ts.

```bash
npm install ts-node -g  # 全局安装最新版的ts-node
```

直接执行ts文件：

```bash
ts-node xxx.ts
```

#### 4 类型注解和类型推断

类型注解（type annotation）：为变量注解它的变量类型

```ts
let count: number  // 为变量count注解它的变量类型为number
count = 123
```

类型推断（type inference）：ts自动去推断变量的变量类型

```ts
let count = 123  // 不写注解，而是直接赋值，ts会自动推断出变量count的变量类型为number
```

所以，编写ts时，在ts可以自动推断出变量类型时，可以不用写类型注解，只有在ts无法自动推断出变量类型的时候才需要去写类型注解

不需要加类型注解：

```ts
const firstNum = 1  // 类型推断：1
const secondNum = 2  // 类型推断：2
const totalNum = firstNum + secondNum  // 类型推断：number
```

需要加类型注解：

当变量作为函数的形参时，如果不加类型注解，那么ts无法推断其类型，因为不知道你要传递什么类型的变量到函数里面，这里ts对函数形参的类型推断为：any

```ts
function total(firstNum, secondNum) {
  return firstNum + secondNum
}

total('1', 2)
```

加了类型注解之后：

这时传递的字符串`'1'`将会报错，只能传递数字类型的1，函数的返回值也能通过类型推断推断出为数字类型的number

```ts
function total(firstNum: number, secondNum: number) {
  return firstNum + secondNum
}

total(1, 2)
```

虽然能推断出函数的返回值类型，但是有时候还是手动注解上函数返回值的类型比较好，比如下面的情况，虽然传的都是number，但是函数返回值却是string类型的

```ts
function total(firstNum: number, secondNum: number) {
  return firstNum + secondNum + ''
}

total(1, 2)
```

如果我们期待函数返回值是number类型的，最好还是加上注解，加上注解后，在编写代码的阶段就会报错，从而杜绝了函数返回值类型与期望的类型不一致的问题

```ts
function total(firstNum: number, secondNum: number): number {
  return firstNum + secondNum + ''  // 报错
}

total(1, 2)
```

如果函数没有返回值，可以把函数返回值注解为`void`

```ts
function hello(): void {
  console.log('hello')
}
```

如果一个函数永远执行不完，可以注解为`never`

```ts
function errorEmitter(): never {
  throw new Error()
  console.log('hello')
}

function whileTrue(): never {
  while (true) {}
  console.log('hello')
}
```

有时候我们会使用解构语法来引用函数的参数，这时可以这么写，不要直接在解构里写注解，而是要对整个解构写注解

```ts
function addNum({ firstNum, secondNum }: {firstNum: number, secondNum: number}) {
  return firstNum + secondNum
}

const total = addNum({ firstNum: 1, secondNum: 2 })
```

注解多种类型：

```ts
let numOrStr: number | string = 123
numOrStr = '123'
```

注解数组：

1. 注解普通类型数组

   ```ts
   const numArr: number[] = [1, 2, 3]
   const arr: (number | string)[] = [1, '2', 3]
   ```

2. 注解对象类型数组

   对象类型的数组注解起来可能会不容易阅读，可以先起个类型别名，然后用别名去注解，就容易阅读了

   ```ts
   // const objArr: { name: string; age: number }[] = [{ name: 'james', age: 18 }]
   
   // 类型别名（type alias）
   type User = { name: string; age: number }
   
   const objArr: User[] = [{ name: 'james', age: 18 }]
   ```

3. 元组（tuple）

   对数组进行普通的注解时，只能约束类型范围，却不能约束数组某个具体位置上的元素的类型

   比如下面这个数组，你可以将第一个数组元素改为数字，或者增加数组元素，都不会报错

   ```ts
   const teacherInfo = ['james', 'male', 18]
   ```

   如果数组的长度是固定的，每一项数组元素的类型也是固定的，这时就可以使用元组来进行具体的约束了

   这时再去修改数组元素类型，或者增减数组元素，就会报错了

   ```ts
   const teacherInfo: [string, string, number] = ['james', 'male', 18]
   ```

   元组在读取csv文件时，对这种类型固定的格式可能会很有用

#### 5 接口

接口与类型别名类似，都是用于起别名，但是接口只能表示对象或者函数等复杂类型，而类型别名除了表示复杂类型，还可以表示基础类型

> ts规范是能用接口表示的尽量用接口表示

```ts
interface Person {
  name: string
}

const getPersonName = (person: Person) => {
  return person.name
}

const setPersonName = (person: Person, name: string) => {
  person.name = name
}
```























