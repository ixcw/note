#### 1 tailwindcss

先来了解 tailwindcss，与以往的css框架 bootstrap 等不同，tailwindcss 是一个工具类优先的css框架，提供了一系列原子化的类名，比如 flex、w-1 等功能类名，由开发者自由组合成想要的样式

tailwindcss 的工作原理是扫描所有类名，然后生成相应的样式代码并写入到一个静态css文件中，最后由页面文件引用生成的静态css文件

这种开发方式的好处是不用再为起css类名烦恼，同时代码体积也会有一定优化，因为所有样式都只需写一遍放到一个静态css文件中

接下来介绍使用步骤：

1. 安装

   ```shell
   npm install -D tailwindcss  # 作为开发依赖安装
   npx tailwindcss init  # 项目根目录下初始化出一个tailwindcss配置文件 tailwind.config.js
   ```

2. 编辑配置文件`tailwind.config.js`：

   ```js
   /** @type {import('tailwindcss').Config} */
   module.exports = {
     content: ["./src/**/*.{html,js}"],  // 模板文件的路径，即需要扫描的模板文件路径
     theme: {
       extend: {},
     },
     plugins: [],
   }
   ```

3. 将加载tailwind的指令添加到主css文件中，加载tailwind的功能模块，比如`./src/input.css`

   ```css
   @tailwind base;
   @tailwind components;
   @tailwind utilities;
   ```

4. 执行命令构建静态css文件，比如`./src/output.css`

   ```shell
   npx tailwindcss -i ./src/input.css -o ./src/output.css --watch
   ```

   

5. 引用生成的静态css文件，比如在`./src/index.html`中

   ```html
   <!doctype html>
   <html>
   <head>
     <meta charset="UTF-8">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <link href="./output.css" rel="stylesheet">
   </head>
   <body>
     <h1 class="text-3xl font-bold underline">
       Hello world!
     </h1>
   </body>
   </html>
   ```

更多请访问 [tailwind官网](https://tailwindcss.com/)

#### 2 windicss

windicss可看作是tailwindcss的升级版，为什么这样说呢，[windicss官网](https://windicss.org/) 上介绍道：windicss 完全兼容 tailwindcss 的 V2 版，除此之外还有许多新的特性

最主要的特性是更快的加载构建速度，windicss提供了更快的加载速度和热更新速度，创作者谈及创造windicss的理由时说道：当项目越来越大时，构建时间变得很长，长达 3s，这是不可接受的

windicss与很多工程化构建工具都有集成，可以很方便的安装使用，详情参考 [installation](https://windicss.org/guide/installation.html)

但请注意windicss已不再更新新功能，仅维护安全更新，原因主要是因为维护团队人员出现变动精力有限，不过windicss已有更好的替代工具unocss，unocss是受windicss的新特性影响开发出来的，新项目建议直接使用unocss，详情见 [Windi CSS is Sunsetting](https://windicss.org/posts/sunsetting.html)

#### 3 unocss

unocss是一款原子化css引擎，特点是快速、定制、按需、灵活

- 快速

  不多解释

- 定制

  可以通过预设提供类名，比如不使用预定的类名，定制你自己的类名`m-1`

  ```ts
  // uno.config.ts
  import { defineConfig } from 'unocss'
  
  export default defineConfig({
    rules: [
      ['m-1', { margin: '1px' }],
    ],
  })
  ```

- 按需

  只有用到的类名会生成对应的静态css，没有用到就不会生成，假设只用到了`m-1`，则生成的静态css为

  ```css
  .m-1 { margin: 1px; }
  ```

- 灵活

  通过正则表达式，你可以制定更加灵活的规则，比如上诉的`m-1`类名可以用正则表达式改写如下：

  ```ts
  // uno.config.ts
  export default defineConfig({
    rules: [
      [/^m-([\.\d]+)$/, ([_, num]) => ({ margin: `${num}px` })],
    ],
  })
  ```

  这样一来就不局限于写死的`m-1`了，`m-6`、`m-8.8`都是可以自动生成对应静态css的，同样是按需生成的

#### 4 微信小程序中使用unocss

1. 安装unocss

   ```shell
   npm -D unocss
   ```

2. 编辑配置文件`uno.config.js`

   ```js
   import { defineConfig, presetUno } from "unocss";
   
   const remRE = /^-?[\.\d]+rem$/
   
   export default defineConfig(
     {
       presets: [
         presetUno(),
       ],
       theme:{
         // 解决小程序不支持 * 选择器
         preflightRoot: ["page,::before,::after"]
       },
       postprocess(util) {
         // 自定义rem 转 rpx
         util.entries.forEach((i) => {
           const value = i[1]
           if (value && typeof value === 'string' && remRE.test(value))
             i[1] = `${value.slice(0, -3) * 4}rpx`
         })
       },
     }
   )
   ```

3. 配置脚本命令

   在`package.json`中配置unocss脚本，监听模板文件，生成静态css文件

   ```json
   {
     "scripts": {
       "unocss": "unocss pages/**/*.wxml components/**/*.wxml -c unocss.config.js --watch -o unocss.scss",
       "unocss:build": "unocss pages/**/*.wxml components/**/*.wxml -c unocss.config.js -o unocss.scss"
     }
   }
   ```

4. 执行脚本命令，平时开发执行`unocss`即可，会实时监听模板文件，生成生产文件执行`unocss:build`

   ```shell
   npm run unocss
   ```
   
   每当模板文件的类名有变化时，都会生成新的`unocss.scss`文件

5. 引入静态css文件`unocss.scss`

   在`app.scss`中引入生成的静态css文件

   ```scss
   @import "unocss.scss";
   ```

经过以上步骤，已经可以正常使用unocss了，但还有一些问题，比如微信小程序不支持unocss的部分特殊类名，比如`[]`，我的方案是自己编写特殊类名放入`unocss.custom.scss`中，然后在`app.scss`中引入

#### 5 智能提示

由于小程序的文件格式特殊性，是`wxml`而不是`html`，平时开发是没有unocss类名智能提示的，没有智能提示是很不方便的，下面分vscode和webstorm进行讲解如何配置智能提示

- vscode

  1. 首先将`wxml`类型关联为`html`，以使vscode能正确识别`wxml`文件

     路径：`设置 => 文本编辑器 => 文件 => Associations `，添加项，键为`*.wxml`，值为`html`

  2. 安装拓展，名为 `WindiCSS IntelliSense`

- webstorm

  webstorm略微麻烦，webstorm2024.1.2版已经内置了 tailwindcss 拓展，但是并没有windicss的拓展，因此没有智能提示，虽然有鼠标悬停显示，但并不是编辑实时提示，因此需要使用tailwindcss的智能提示来代替

  1. 安装tailwindcss作为开发依赖

     目的在于让webstorm知道项目使用了tailwindcss

     ```shell
     npm install -D tailwindcss
     npx tailwindcss init
     ```

  2. 和vscode同样的问题，需要关联文件格式

     路径：`设置 => 语言和框架 => 样式表 => Tailwind CSS`，编辑配置文件，在`includeLanguages`节点下增加配置

     ```json
     {
       "includeLanguages": {
         "ftl": "html",
         "jinja": "html",
         "jinja2": "html",
         "smarty": "html",
         "tmpl": "gohtml",
         "cshtml": "html",
         "vbhtml": "html",
         "razor": "html",
         "wxml": "html"  // 此为增加配置
       }
     }
     ```
