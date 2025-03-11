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

这样就成功创建了使用 ts 作为开发语言，vue router 作为路由管理，pinia 作为状态管理的 vue3 项目


#### 3 tailwind css

根据 Tailwind css 官网安装文档，直接安装 Tailwind css 提供给 vite 的插件即可

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

最后在项目的主 css 文件 `src/assets/main.css` 中引入 Tailwind css 的样式

```css
/* src/assets/main.css */

@import "tailwindcss";
...
```

编辑组件进行测试，出现样式则说明引入成功

```vue
// src/App.vue

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
// src/App.vue
import { Loading } from '@element-plus/icons-vue'


<div class="mb-4">
    <el-button>Default</el-button>
    <el-button type="primary">Primary</el-button>
    <el-button type="success">Success</el-button>
    <el-button type="info">Info</el-button>
    <el-button type="warning">Warning</el-button>
    <el-button type="danger">Danger</el-button>
</div>
<div class="mb-4">
    <el-icon class="is-loading">
        <Loading />
    </el-icon>
</div>
```

> 需要注意，图标还是要手动导入才能使用的，也可以变成自动导入，可以参考 [官网](https://element-plus.org/zh-CN/component/icon.html)
>
> 也可以选择直接全部导入（前提是不考虑打包体积），这样就不用手动去导入了，编辑 `main.ts`
>
> ```ts
> // main.ts
> 
> import './assets/main.css'
> 
> import { createApp } from 'vue'
> import { createPinia } from 'pinia'
> import * as ElementPlusIconsVue from '@element-plus/icons-vue'
> 
> import App from './App.vue'
> import router from './router'
> 
> const app = createApp(App)
> 
> app.use(createPinia())
> app.use(router)
> for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
>   app.component(key, component)
> }
> 
> app.mount('#app')
> ```

#### 5 pinia

pinia 在项目创建时，我们已经选择了安装，所以可以直接使用，我们选择 vue 为我们准备好的示例文件 `src/stores/counter`，

```ts
// src/stores/counter.ts

import { ref, computed } from 'vue'
import { defineStore } from 'pinia'

export const useCounterStore = defineStore('counter', () => {
  const count = ref(0)
  const doubleCount = computed(() => count.value * 2)
  function increment() {
    count.value++
  }

  return { count, doubleCount, increment }
})
```

在组件中使用：

```vue
// src/App.vue

<script setup lang="ts">
import { useCounterStore } from '@/stores/counter';
const counterStore = useCounterStore()
</script>

<template>
	<el-button type="primary" @click="counterStore.increment">
	    Count is: {{ counterStore.count }}
    	DoubleCount is: {{ counterStore.doubleCount }}
	</el-button>
</template>
```

#### 6 sass

Vite 已经内置了对 Sass 的支持，因此你只需要安装 `sass` 包即可，不需要额外安装 `sass-loader`

```sh
pnpm add sass --save-dev
```

重新运行项目即可

```vue
<style scoped lang="scss"></style>
```

















