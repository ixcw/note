#### 1 项目概览

搭建一个兼职求职平台，为企业和用户提供招人和求职的机会，有企业端和用户端

#### 2 技术架构

项目采用 vue3 + TS + vite + pinia + vueuse + vant3 UI 的技术方案，该方案是目前比较新的流行技术，不常用uniapp是因为uniapp**平台依赖严重**，技术并不开源，且**bug较多**，不利于商业项目

#### 3 框架搭建

##### 3.1 搭建项目

使用vite搭建，依次选择vue、typescript完成搭建

```sh
npm init vite
```

启动项目，安装依赖后启动项目

```sh
npm install && npm run dev
```

##### 3.2 集成pinia

集成状态管理插件pinia，pinia相当于vuex的下一代更新，首先安装pinia为项目依赖

```sh
npm install pinia --save
```

在src目录下新建目录store，新建文件`index.ts`

```typescript
import { createPinia } from "pinia";

const store = createPinia();
export default store;
```

在`main.ts`中引入store，在应用挂载之前usestore

```typescript
import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import store from './store'

const app = createApp(App)
app.use(store)
app.mount('#app')
```

##### 3.3 集成vueuse

vueuse是一个常用的工具集函数包，包含了常用的功能，基于composition api封装，安装vueuse为项目依赖即可

```sh
npm install @vueuse/core --save
```

##### 3.4 集成vant3 ui

vant ui是一款移动端ui框架，帮助我们快速搭建前端界面，安装vant为项目依赖即可

```sh
npm install vant --save
```

##### 3.5 配置路径

编辑`tsconfig.json`文件，配置常用根路径为`@`

```json
{
  "compilerOptions": {
    "paths": {
      "@": ["./src"],
      "@/*": ["./src/*"]
    }
  }
}
```

##### 3.6 梳理项目模块

梳理项目模块，创建对应视图文件

```text
views
    login
        index.vue                       // 登录页
        serviceAgree.vue                // 服务协议
        privacyPolicy.vue               // 隐私政策
    task
        index.vue                       // 任务主页
        search.vue                      // 任务搜索
        details.vue                     // 任务详情
        companySource.vue               // 公司任务主页
    contract
        index.vue                       // 合约主页
        details.vue                     // 合约详情
        progress.vue                    // 合约进度
    message
        index.vue                       // 消息主页
        systemList.vue                  // 系统消息列表
        systemDetails.vue               // 系统消息详情
        talk.vue                        // 对话消息
    my
        index.vue                       // 我的主页
        user                            // 用户中心
            index.vue                   // 个人信息主页
            authReal.vue                // 实名认证
            certified.vue               // 已完成实名认证
            identitySwitch.vue          // 切换身份
        set                             // 我的设置
            index.vue                   // 设置主页
        feedback                        // 意见反馈
            index.vue                   // 反馈主页
        account                         // 我的账户
            index.vue                   // 账户主页
            advance.vue                 // 账户提现
            coinExplain.vue             // 无忧币说明
            depositExplain.vue          // 押金说明
        resume                          // 我的简历
            index.vue                   // 简历主页
            preview.vue                 // 简历预览
        collect                         // 我的收藏
            index.vue                   // 收藏主页
    talent
        index.vue                       // 人才主页
        details.vue                     // 人才详情
```





















