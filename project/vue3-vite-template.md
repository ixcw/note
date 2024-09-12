#### 4 引入 antd 图标

首先安装图标包，可以安装最新的，最新的语法上没有影响，只是更新了一部分图标

```sh
npm install --save @ant-design/icons-vue
```

然后在 main.js 中全局引入图标

```js
import { createApp } from 'vue'
import Antd from 'ant-design-vue'
import App from './App.vue'
import * as Icons from '@ant-design/icons-vue'

import './style.css'
import 'ant-design-vue/dist/reset.css'

const app = createApp(App)
app.use(Antd).mount('#app')

// 全局引入图标
const icons = Icons
for (const i in icons) {
  app.component(i, icons[i])
}
```

#### 5 导航栏布局

来到 antd 的官网，找到 Layout 布局，这里有许多经典布局，后台管理系统最常见的就是 [顶部-侧边布局](https://www.antdv.com/components/layout-cn#components-layout-demo-top-side)

我们选择这种布局，复制代码，清空 `App.vue` 文件，然后粘贴到项目中的 `App.vue` 文件中，然后同时也将默认的样式文件 `style.css` 清空，就得到了最基本的布局样式

> 官方的这段布局代码中有个 bug，在样式代码中加了一个 id 选择器，但是模板代码中并没有这个 id，于是导致 logo 不能显示，去掉这个 id 选择器 即可

#### 6 路由配置

vue 是个单页面的应用，这意味着路由的跳转是在单页面的前端完成的，页面路由跳转是很快的

vue 的路由需要作为一个组件单独引入，首先安装路由包，这里选择 4.2.5 这个版本

```sh
npm install vue-router@4.2.5
```

安装完成后，我们在项目根目录下新建一个 router 目录专门用于处理路由，再在 router 目录下新建一个 `index.js` 文件，导入 vue-router 包，配置和创建路由并导出去

```js
// router/index.js

import {createRouter, createWebHistory} from 'vue-router'
import Home from '../views/home.vue'

const routes = [
  {
    path: '/',
    redirect: '/home'
  },
  {
    path: '/home',
    component: Home
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
```

Home 是我们导入的 vue 组件，访问对应的 path 时，将导航至 Home 这个组件

前面我们将导航布局写在了 App.vue 组件里，这样其实是不对的，因为 App.vue 是充当项目入口的作用，我们需要将要显示的页面单独抽取成组件

在项目根目录下新建 views 文件夹，然后创建 Home.vue 文件，将 App.vue 中的导航布局全部剪切到 Home.vue 中

现在的任务就是让 App.vue 这个入口文件和 Home.vue 组件关联起来，可以利用路由来完成

router-view 是路由页面的展示区域，展示内容是可变的，会根据配置的路由路径去展示对应的页面内容

```vue
// Home.vue

<template>
  <router-view></router-view>
</template>
```

最后需要在 main.js 中导入配置好的路由

```js
// main.js

import { createApp } from 'vue'
import Antd from 'ant-design-vue'
import App from './App.vue'
import * as Icons from '@ant-design/icons-vue'
import router from './router'

import './style.css'
import 'ant-design-vue/dist/reset.css'

const app = createApp(App)
app.use(Antd)
  .use(router)
  .mount('#app')

// 全局引入图标
const icons = Icons
for (const i in icons) {
  app.component(i, icons[i])
}
```

#### 7 提取公共组件

可以把 Home 组件中的 Header、Sider、Footer 抽取成公共组件，可以在项目根目录下的 components 文件夹下新建公共组件，抽取完成后，正常导入使用即可

#### 8 集成 axios

vue 项目最常用的网络请求工具库就是 axios，首先安装 axios 的包

```sh
npm install axios@1.7.7
```

然后就能使用 axios 发起网络请求了

```js
axios.get('http://xxxapi').then(data => console.log(data))
```

但是不同的域名协议端口会导致跨域问题，需要进行配置解决，这里是后端配置全部允许跨域解决的

axios 可以增加拦截器，对某些操作进行统一处理，在 main.js 中增加如下 axios 配置，这里的配置非常简单，只是增加了打印

```js
// main.js

// axios 拦截器
axios.interceptors.request.use(config => {
  console.log('请求参数: ', config)
  return config
}, err => {
  return Promise.reject(err)
})
axios.interceptors.response.use(res => {
  console.log('返回结果: ', res)
  return res
}, err => {
  console.log('返回错误: ', err)
  return Promise.reject(err)
})
```

9 vite 多环境配置

在我们开发项目时，往往需要多个环境，比如开发时使用开发环境，开发完成的测试阶段使用测试环境，项目上线后使用正式环境，vite 构建的项目如何配置不同的开发环境呢，下面一起来看一下

根据约定，我们可以在项目根目录下新建 `.env` 文件进行环境变量的配置

```text
// .env
VITE_SERVER=http://api:8080
```

同时也可以新建测试环境，正式环境的配置

```text
// .env.test
VITE_SERVER=http://api.test:8080
```

```text
// .env.prod
VITE_SERVER=http://api.prod:8080
```

最后需要在 `package.json` 中配置脚本命令，添加 mode 选项，以区分不同的环境

```json
// package.json

"scripts": {
  "dev": "vite",
  "test": "vite --mode=test",
  "prod": "vite --mode=prod",
  "build": "vite build",
  "preview": "vite preview"
},
```

这样就可以通过运行不同的脚本命令，执行不同的环境打包了，如何在代码中访问配置的 VITE_SERVER 变量呢，可以按如下方式访问，这个变量是全局的，可在任何地方访问

```js
console.log(import.meta.env.VITE_SERVER)
```

这样就能实现不同环境下的不同域名的配置了，我们可以将 axios 的访问域名改为这个配置域名

```js
// main.js

axios.defaults.baseURL = import.meta.env.VITE_SERVER
```

#### 10 配置二级路由

前面我们访问的是一级路由，也就是 `http://localhost:5173/home` 这样的一级目录，访问的是 Home 组件，Home 组件是通过在入口组件 App 中定义的 router-view 标签去进行匹配显示的，现在我们想在 Home 组件中的内容区域也动态显示不同的内容，这就需要为 Home 组件配置二级路由来实现了

首先在 views 文件夹下新建一个 home 文件夹，用于存放 Home 组件需要动态显示的二级路由页面，然后新建一个 welcome.vue 文件，接着去配置路由文件 `router/index.js`，给 Home 组件的路由新增二级路由

```js
// router/index.js

import {createRouter, createWebHistory} from 'vue-router'
import Home from '../views/Home.vue'
import Welcome from '../views/home/Welcome.vue'

const routes = [
  {
    path: '/',
    redirect: '/home'
  },
  {
    path: '/home',
    component: Home,
    children: [
      {
        path: 'welcome',
        component: Welcome,
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
```

然后在 Home 组件中，也需要在需要动态显示二级路由的地方配置 router-view 标签去动态匹配二级路由页面

```vue
// Home.vue

<template>
  <a-layout>
    <Header></Header>
    <a-layout-content style="padding: 0">
      <a-layout style="padding: 0; background: #fff">
        <Sider></Sider>
        <router-view />
      </a-layout>
    </a-layout-content>
    <Footer></Footer>
  </a-layout>
</template>
```

这样在访问 `http://localhost:5173/home/welcome` 这样的二级路由时，才能正确的在 Home 组件中显示 Welcome 组件

> 因为访问 `/home` 时是访问的 Home 组件，所以访问 `/home/welcome` 时，需要在 Home 组件中添加 router-view 去显示二级路由页面，如果有三级路由，也同理





































