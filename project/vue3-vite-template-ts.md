#### 1 项目目标

本项目目标为搭建一个基于 vue3 的前台模板项目，将会基于以下技术搭建：

- vue3

  使用 vue3 作为前端框架

- typescript

  使用 ts 作为开发语言

- vite

  使用 vite 作为构建工具

- pinia

  使用 pinia 作为状态管理工具

- vue router

  使用 vue router 作为前端路由

- tailwind css

  使用 tailwind css 来编写样式

- element plus

  使用 element plus 作为 UI 框架

- axios

  使用 axios 作为网络请求工具

#### 2 搭建基础框架

node 版本 20.11.1，使用 pnpm 版本 9.15.4 进行项目搭建，首先使用命令创建项目

根据 vue 官网的 [快速开始](https://cn.vuejs.org/guide/quick-start.html)，输入如下命令创建项目：

```sh
pnpm create vue@latest
```

然后命令行会依次询问创建选项

输入项目名称后，选择 ts、jsx、vue router、pinia，其余选否

创建完成后进入项目根目录，运行如下命令启动项目：

```sh
pnpm install
pnpm dev
```

> 打开 `main.ts` 文件，会发现引入 `App.vue` 报错了 `找不到模块“./App.vue”或其相应的类型声明。`
>
> 配置一下 `env.d.ts` 文件
>
> ```ts
> // env.d.ts
> 
> /// <reference types="vite/client" />
> declare module "*.vue" {
>   import type { DefineComponent } from "vue";
>   const vueComponent: DefineComponent<{}, {}, any>;
>   export default vueComponent;
> }
> ```

这样就成功创建了基于 vue3 的项目，使用 ts 作为开发语言，vue router 作为路由管理，pinia 作为状态管理的项目


#### 3 tailwind css

根据 Tailwind css 官网安装文档，直接安装 Tailwind css 提供给 vite 的插件进行安装即可

```sh
pnpm add tailwindcss @tailwindcss/vite
```

然后在 vite 的配置文件 `vite.config.ts` 中引入插件并使用

```ts
// vite.config.ts

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    tailwindcss()
  ],
})
```

最后在项目的公共 css 文件 `src/style.css` 中引入 Tailwind css 的样式

```css
/* src/style.css */

@import "tailwindcss";
...
```

编辑组件进行测试，出现样式则说明引入成功

```vue
// src/components/HelloWorld.vue

<h1 class="text-3xl font-bold underline">Hello world! Tailwind css</h1>
```

#### 4 element plus

首先直接安装 element-plus 和 element-plus 的图标

```sh
pnpm add element-plus @element-plus/icons-vue
```

根据官网推荐，这里再安装两个插件，以使用自动导入功能，这样就不用每次要用的时候都需要手动去导入了，很方便

```sh
pnpm add -D unplugin-vue-components unplugin-auto-import
```

安装完成之后，下面开始配置 element plus，在 vite 的配置文件 `vite.config.ts` 中引入插件并使用

```ts
// vite.config.ts

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    tailwindcss(),
    AutoImport({
      resolvers: [ElementPlusResolver()],
    }),
    Components({
      resolvers: [ElementPlusResolver()],
    }),
  ],
})
```

然后就可以测试了，编写组件测试，展示出按钮和图标则表示引入成功

```vue
// src/components/HelloWorld.vue

<div class="mb-4">
    <el-button>Default</el-button>
    <el-button type="primary">Primary</el-button>
    <el-button type="success">Success</el-button>
    <el-button type="info">Info</el-button>
    <el-button type="warning">Warning</el-button>
    <el-button type="danger">Danger</el-button>
</div>
<div class="mb-4">
    <el-icon :size="20">
        <Edit />
    </el-icon>
    <el-icon color="#409efc" class="no-inherit">
        <Share />
    </el-icon>
    <el-icon>
        <Delete />
    </el-icon>
    <el-icon class="is-loading">
        <Loading />
    </el-icon>
    <el-button type="primary">
        <el-icon style="vertical-align: middle">
            <Search />
        </el-icon>
        <span style="vertical-align: middle"> Search </span>
    </el-button>
</div>
```

> 需要注意，图标还是要手动导入才能使用的，也可以变成自动导入，可以参考 [官网](https://element-plus.org/zh-CN/component/icon.html)

#### 5 pinia

接下来集成 pinia，作为项目的状态管理工具，首先安装

```sh
pnpm add pinia
```

创建状态管理文件 `src/stores/counter.ts`

```ts
import { defineStore } from 'pinia'

export const useCounterStore = defineStore('counter', {
  state: () => ({
    count: 0
  }),
  actions: {
    increment() {
      this.count++
    }
  }
})
```

然后在主入口文件 `main.ts` 里引入 pinia

```ts
// main.ts

import { createApp } from 'vue'
import { createPinia } from 'pinia'
import './style.css'
import App from './App.vue'

const app = createApp(App)
app.use(createPinia())
app.mount('#app')
```

然后在组件中使用

```vue
const counterStore = useCounterStore()

<el-button type="primary" @click="counterStore.increment">
    Count is: {{ counterStore.count }}
</el-button>
```

但是这样直接使用会报 `Uncaught ReferenceError: useCounterStore is not defined` 错误，因为我们没有导入使用，其实我们前面已经安装了 `unplugin-auto-import/vite` 插件，可以配置常用的库的自动导入，比如 vue、vue router、pinia 等，这样就不用每次使用都需要手动导入了，在 `vite.config.ts` 配置

```ts
// vite.config.ts

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    tailwindcss(),
    AutoImport({
      resolvers: [ElementPlusResolver()],
      imports: ['vue', 'vue-router', 'pinia']
    }),
    Components({
      resolvers: [ElementPlusResolver()],
    }),
  ],
})
```



















