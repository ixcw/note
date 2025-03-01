#### 1 项目初始化

运行 nuxt3 项目的初始化命令

```sh
pnpm dlx nuxi@latest init nuxt3-init
```

报错网络问题

> Failed to download https://raw.githubusercontent.com/nuxt

将下面的 ip 解析加入 hosts，路径为  `C:\Windows\System32\drivers\etc\hosts`

```text
151.101.109.194 github.global.ssl.fastly.net
10.10.211.68 assets-cdn.github.com
185.199.111.133 raw.githubusercontent.com
```

cmd 运行命令刷新 dns

```sh
ipconfig/flushdns
```

之后重新执行初始化命令，选择包管理器为 pnpm 即可

#### 2 引入 element plus

参考 [element plus 模块文档](https://nuxt.com/modules/element-plus)

首先新建 `.npmrc` 文件

```txt
shamefully-hoist=true
```

由于我们前面选择的是 pnpm，因此这里使用 pnpm 安装

```sh
pnpm i element-plus @element-plus/nuxt -D
```

然后在项目配置文件 `nuxt.config.ts` 中配置 element plus

```ts
// nuxt.config.ts

export default defineNuxtConfig({
  modules: ['@element-plus/nuxt'],
  elementPlus: { /** Options */ }
})
```

接着就可以直接在组件中使用了，无需导入

```vue
<template>
  <div>
    <el-button @click="ElMessage('hello')">button</el-button>
    <ElButton :icon="ElIconEditPen" type="success">button</ElButton>
    <LazyElButton type="warning">lazy button</LazyElButton>
  </div>
</template>
```

> 动态导入一个 element plus 组件，你所需要做的就是在组件名称前添加Lazy前缀，有助于优化 JavaScript 包的体积

#### 3 引入 dayjs

同样使用 pnpm 安装

```sh
pnpm install --save-dev dayjs-nuxt
```

配置模块

```ts
// nuxt.config.ts

export default defineNuxtConfig({
  modules: ['@element-plus/nuxt', 'dayjs-nuxt'],
  elementPlus: { /** Options */ }
})
```

在组件中使用

```vue
<template>
  <div>
    <div>{{$dayjs(1691025478849).format('YYYY-MM-DD')}}</div>
  </div>
</template>

<script setup>
  const dayjs = useDayjs()
  console.log(dayjs(1691025478849).format('YYYY-MM-DD'))
</script>
```

#### 4 引入 sass

sass 的引入很简单，只需要安装即可，无需配置

```sh
pnpm install --save-dev sass
```

然后就能使用了

```vue
<style scoped lang="scss"></style>
```

#### 5 公共样式

创建 assets 文件夹，再创建 css 文件夹，创建 main.css 文件

```css
/* main.css */

* {
  margin: 0;
  padding: 0;
}
```

项目配置文件中引入

```ts
// nuxt.config.ts

export default defineNuxtConfig({
  modules: ['@element-plus/nuxt', 'dayjs-nuxt'],
  elementPlus: { /** Options */ },
  css: ['@/assets/css/main.css']
})
```

#### 6 公共组件

新建 components 文件夹，然后分别新建 `AppHeader.vue` 和 `AppFooter.vue` 文件

新建 layouts 文件夹，然后新建 `default.vue` 文件，使用前面创建的公共组件，无需引入，因为按照约定自动引入了

```vue
// default.vue

<template>
  <app-header />
  <slot />
  <app-footer />
</template>
```

#### 7 首页

首先删除 `app.vue` 文件，新建 pages 文件夹，再新建 `index.vue` 文件

```vue
// index.vue

<template>
  <div>首页</div>
</template>
```

为兼容移动端，配置一下视口

```ts
app: {
    head: {
        viewport: 'width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no',
    }
},
```











































