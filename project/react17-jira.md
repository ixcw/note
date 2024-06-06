#### 1 项目初始化

##### 1.1 创建项目

使用 `create-react-app` 创建 react 项目

为了创建 typescript 的项目，需要添加参数 `--template typescript`

```sh
npx create-react-app jira --template typescript
```

打开 `package.json` 会发现当前创建的是 react 18.3.1 的版本，react 没有提供降级的方式，react18 和 17 的区别不是很大，没有必要降级

来看下目录结构：

```sh
|-- jira
    |-- .gitignore
    |-- package-lock.json
    |-- package.json
    |-- README.md
    |-- tsconfig.json
    |-- node_modules  # node 模块文件夹
    |-- public  # 静态文件目录，不参与打包
    |   |-- favicon.ico
    |   |-- index.html  # 最终项目呈现到浏览器的网页
    |   |-- logo192.png
    |   |-- logo512.png
    |   |-- manifest.json
    |   |-- robots.txt
    |-- src  # 源文件目录
        |-- App.css
        |-- App.test.tsx  # 测试文件
        |-- App.tsx  # App 组件
        |-- index.css
        |-- index.tsx  # 入口文件
        |-- logo.svg
        |-- react-app-env.d.ts  # 引入一些 react 定义的类型
        |-- reportWebVitals.ts  # 埋点上报
        |-- setupTests.ts  # 配置单元测试库 testing-library
```

我们在 src 文件夹下的源码最终将被打包压缩文件，集成到 public 文件夹下的 `index.html` 文件中，public 文件夹下的其他静态资源也是为这个文件所服务的

我们关注一下 src 目录下的 `App.tsx` 这个文件（已删去多余代码）：

```tsx
import logo from './logo.svg';
import './App.css';

function App() {
  return (
    <img src={logo} className="App-logo" alt="logo" />
  );
}

export default App;
```

> 组件中的图片、字体等文件需要放到 src 目录下像模块一样引入，而不是放到 public 文件夹下

创建好项目后可直接运行项目demo：

```sh
npm start
```

##### 1.2 项目规范

俗话说，无规矩不成方圆，个人项目可以不怎么关注规则，但涉及多人合作项目时，有必要制定规范加以约束，以更好地进行协作

举一些常见的代码规范问题：

1. 组件引入使用相对路径，不是不可以，但当层级过多时，难以一眼看清引入结构
2. 代码格式很乱，不同的人不同的风格，难以协作
3. git commit 消息五花八门，同样各有各的风格，有的人甚至很宽泛的写一个 “fix”，这样的提交消息是没有意义的

针对上诉常见问题可做如下项目配置：

1. 配置项目根目录的地址别名，编辑 `tsconfig.json`：

   ```json
   {
     "compilerOptions": {
       "baseUrl": "./src"
   }
   ```

   然后就可以使用绝对路径了

2. 针对格式化问题，可以安装 [prettier](https://prettier.io/docs/en/install) 解决

   作为开发依赖进行安装：

   ```sh
   npm install --save-dev --save-exact prettier
   ```

   创建配置文件 `.prettierrc`，这是命令行的方式，你也可以手动创建

   ```sh
   node --eval "fs.writeFileSync('.prettierrc','{}\n')"
   ```

   创建忽略文件 `.prettierignore`，用于指定哪些文件不需要被格式化，文件内容：

   ```text
   # Ignore artifacts:
   build
   coverage
   ```

   >该忽略文件会自动跟踪 `.gitignore` 文件里的内容，所以不必额外指定 `node_modules` 等文件

   然后就可以使用命令手动去格式化文件了，但在项目工程里，我们肯定希望格式化是自动进行的，在每次通过 git commit 之前就自动进行格式化，于是可以安装两个模块分别是 `husky` 和 `lint-staged`

   ```sh
   npm install --save-dev husky lint-staged
   npx husky init
   node --eval "fs.writeFileSync('.husky/pre-commit','npx lint-staged\n')"
   ```

   添加如下代码到 `package.json`

   ```json
   {
     "lint-staged": {
       "**/*": "prettier --write --ignore-unknown"
     }
   }
   ```

   最后安装 `eslint-config-prettier`，使得 eslint 和 prettier 可以正常工作，关掉了一些不必要或和 prettier 冲突的规则

   ```sh
   npm install -D eslint-config-prettier
   ```

   编辑 `package.json`，在 eslint 规则里添加 prettier

   ```json
   {
     "eslintConfig": {
       "extends": [
         "react-app",
         "react-app/jest",
         "prettier"  // 添加 prettier 覆盖一些 eslint 的规则
       ]
     }
   }
   ```

   完成，可以编辑一个文件进行测试，比如在引入 react 功能函数的时候故意不加空格：

   ```tsx
   import React, {useReducer} from "react";
   ```

   直接提交之后，prettier 会帮我们自动格式化为：

   ```tsx
   import React, { useReducer } from "react";
   ```

3. 解决 commit 消息五花八门的问题，可以安装 `commitlint` 检查 commit 的消息，如果不符合一定的规范，则提交失败

   作为开发依赖进行安装：

   ```sh
   npm install --save-dev @commitlint/config-conventional @commitlint/cli
   ```

   创建配置文件 `commitlint.config.js`：

   ```sh
   echo "export default { extends: ['@commitlint/config-conventional'] };" > commitlint.config.js
   ```

   > ！！！ 测试的时候出现报错：SyntaxError: Unexpected token 'export'，定位到 `commitlint.config.js`，很明显是这个配置文件出了问题，而且是语法错误
   >
   > WTF，这不是官方文档吗，最后在 commitlint 的 github 项目的 [issue#614](https://github.com/conventional-changelog/commitlint/issues/614) 里找到了网友的解决方案，将 `export default` 改为 `module.exports` 就可以了

   详细的规则可以查看 [config-conventional](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional)

   然后配置 `commit-msg`：
   
   ```sh
   echo "npx --no -- commitlint --edit \$1" > .husky/commit-msg
   ```

##### 1.3 mock

由于前后端分离的开发模式，前后端常常是并行开发的，后端的进度一般会稍微落后，只要提前定义好了接口数据，前端是可以自己模拟接口数据提前进行开发的，接口模拟也叫 mock，下面介绍一些常见的 mock 方式

1. 代码入侵

   这是最常见也最简单的方式，即把接口数据直接写死在代码里面，或者是请求在项目里写好的本地 json 文件

   优点：简单

   缺点：切换真实接口的时候非常麻烦，需要大量改动代码，并且 mock 的效果不好，请求方式单一

2. 请求拦截

   典型代表是 [mockjs](http://mockjs.com/)，可以拦截请求，替换为自己生成的数据，数据可按一定的规则生成随机数据，它的原理就是拦截请求，重写 `XMLHttpRquest` 的一些属性，返回我们想要的数据

   优点：与前端代码分离，没有写死在前端代码里面，且生成的数据是动态的

   缺点：数据虽然是动态的，但仍然是假数据，无法模拟增删改查的情况，只支持 ajax，不支持 fetch

   > 了解为什么：[fetch 与 ajax的区别](https://juejin.cn/post/6997784981816737800)，简单来说就是 fetch 和 xhr 是同级的东西

3. 接口管理工具

   如 swagger、yapi，配置强大，但是会更多依赖于后端

   优点：功能强大

   缺点：依赖后端

4. 本地 node 服务

   前端在本地自己启动一个 node 服务用于模拟数据，典型代表是 [json-server](https://github.com/typicode/json-server)

   优点：配置简单，可快速启动服务，自定义程度高，可模拟增删改查的情况

   缺点：无法自动随后端api的变动而变动

可以发现，对前端来说，目前 json-server 是最优方案

全局安装 json-server

```sh
npm install json-server -g
```

新建一个 json 文件 `db.json`

```json
{
  "user": []
}
```

使用 json-server 监测这个 json 文件

```sh
json-server db.json
```

搞定，接下来开始测试（seriously 30s！）

现在你可以使用接口管理工具（比如 apifox）通过 get 方式访问 `http://localhost:3000/user` 获得返回的 json 数据 `[]` 了

> 如果使用 react，其默认端口也是 3000，这时可以指定别的端口号
>
> ```sh
> json-server -p 3001 db.json
> ```

测试用 post 的方式增加数据，相同的请求地址，请求方式选择 post，在 body 请求体里面填上要增加的数据，格式选择 json

```json
{
  "name": "james"
}
```

点击发送，状态码返回了201，结果返回了 json 数据，可以看到 json-server 还贴心地加了一个 id

```json
{
  "id": "8fcc",
  "name": "james"
}
```

这时再去看 `db.json` 这个文件：

```json
{
  "user": [
    {
      "id": "8fcc",
      "name": "james"
    }
  ]
}
```

可以发现，成功增加了数据，user 字段不再是空数组，而是多了刚才通过 post 方式发送的用户对象

这时再重新使用 get 获取，会发现接口返回数据变了，变成了新增的数据，这也能说明增加数据是成功了的：

```json
[
  {
    "id": "8fcc",
    "name": "james"
  }
]
```

那么修改呢，这里使用 patch 的请求方式进行测试，为什么不用 put 呢，请看 [通俗讲解 RESTful](https://juejin.cn/post/6844903953189208078)

记下 user 的 id，请求地址变更为：`http://localhost:3001/user/8fcc`，然后在 body 请求体里发送改名的数据：

```json
{
  "name": "jack"
}
```

可以发现用户字段的名字变更成功

测试删除比较简单，直接用 delete 请求方式请求 `http://localhost:3001/user/8fcc`，可以发现指定 id 为 `8fcc` 的用户被删除成功，用户字段重新变为空数组

#### 2 实现项目列表

下面正式进入开发阶段，目标是实现一个支持搜索的列表，可输入搜索和选择搜索

新建一个文件夹 `project-list`，文件夹下新建组件 `index.jsx` 作为列表组件的入口组件

```jsx
// index.jsx
export const ProjectListScreen = () => {
  return <div></div>
}
```

列表可拆分为搜索组件 `search-panel.jsx` 和列表组件 `list.jsx`

```jsx
// search-panel.jsx
export const SearchPanel = () => {
  return <form></form>
}
```

```jsx
// list.jsx
export const List = () => {
  return <table></table>
}
```

将两个组件引入列表入口组件

```jsx
// index.jsx
import { SearchPanel } from "./search-panel"
import { List } from "./list"

export const ProjectListScreen = () => {
  return <div>
    <SearchPanel />
    <List />
  </div>
}
```

下面实现搜索组件，首先找到这个组件需要哪些 **状态**，搜索组件需要项目名和负责人的 id，我们将其合二为一为一个参数状态 param，利用 hooks 的 useState 引入状态，这里的 setParam 用到了展开运算符，其实是和 `Object.assign()` 的效果是一样的，设置新值，不改变原有值

```jsx
// search-panel.jsx
import { useEffect, useState } from "react"

export const SearchPanel = () => {
  const [param, setParam] = useState({  // 参数状态
    name: '',
    personId: ''
  })
  const [users, setUsers] = useState([])  // 用户状态
  const [list, setList] = useState([])  // 列表状态
  useEffect(() => { // 请求接口
    fetch('').then(async res => {
      if(res.ok) {
        setList(await res.json())
      }
    })
  }, [param])  // 在 param 改变的时候请求
  return <form>
    <div>
      <input type="text" value={param.name} onChange={e => setParam({
        ...param,
        name: e.target.value
      })} />
      <select value={param.personId} onChange={e => setParam({
        ...param,
        personId: e.target.value
      })}>
        <option value="">负责人</option>
        {
          users.map(user => <option value={user.id}>{user.name}</option>)
        }
      </select>
    </div>
  </form>
}
```

到这里可能你发现了一个问题，由于这是搜索组件，搜索请求接口返回的是一个列表信息，那么理所应当应该定义一个列表状态，但是问题来了，定义在搜索组件里的列表状态实际上搜索组件是用不到的，列表组件 List 才是真正需要列表状态的组件，可是列表组件和搜索组件为同级组件，如何把列表状态传递给列表组件呢？答案是 **状态提升**





















