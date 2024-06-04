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

   > ！！！ 测试的时候出现报错：SyntaxError: Unexpected token 'export'   commitlint.config.js'，很明显是这个配置文件出了问题，而且是语法错误，WTF，这不是官方文档吗，最后在 github 的项目 issue 里 找到了网友的解决方案，将 export default 改为 module*.*exports 就可以了

   详细的规则可以查看 [config-conventional](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional)

   然后配置 `commit-msg`：

   ```sh
   echo "npx --no -- commitlint --edit \$1" > .husky/commit-msg
   ```

##### 1.3 mock

