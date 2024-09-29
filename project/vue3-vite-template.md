#### 1 创建 vite 项目

创建固定版本为 5.0.0 的 vite 项目

```sh
npm create vite@5.0.0 vue3_vite --template vue
```

回车后出现选项，依次选择 vue => JavaScript，就完成了创建，接着 cd 到 vue3_vite 目录，执行 npm 安装，并且执行已经内置好的脚本

```sh
cd vue3_vite
npm install
npm run dev
```

最后访问终端的本地网址即可

#### 2 集成 ant-design-vue

ant design vue，简称 antd，最先支持了 vue3，因此选用，使用 npm 安装 antd 的固定版本 4.1.0

```sh
 npm i ant-design-vue@4.1.0
```
直接全局注册就好，在项目根目录下的 main.js 中引入 antd 进行全局注册

```js
import { createApp } from 'vue'
import Antd from 'ant-design-vue'
import App from './App.vue'

import './style.css'
import 'ant-design-vue/dist/reset.css'

const app = createApp(App)
app.use(Antd).mount('#app')
```


#### 3 发布至 git

登录至 gitlab 上创建项目，然后进入项目根目录运行如下命令进行初始化和绑定

```sh
git init --initial-branch=main
git remote add origin https://gitlab.com/start5024717/vue3_vite.git
```

随后正常提交即可