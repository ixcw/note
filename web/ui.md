#### 1 Element-UI

Element-UI是基于vue的桌面端UI组件库，用于前端页面样式的编写，我们知道样式的编写不是很难，更多的是繁琐的工作量，利用前端UI库就可以更快地开发

#### 2 安装

- 通过命令行安装

  ```sh
  npm i element-ui
  ```

  使用elementUI，在默认的入口文件`main.js`中引入elementUI的组件库和样式

  ```js
  import Vue from 'vue';
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';
  import App from './App.vue';
  
  Vue.use(ElementUI);
  
  new Vue({
    el: '#app',
    render: h => h(App)
  });
  ```

  然后打开`App.vue`文件在模板位置书写elementUI的标签结构

  ```vue
  <template>
    <div id="app">
      <div id="nav">
        <router-link to="/">Home</router-link> |
        <router-link to="/about">About</router-link>
      </div>
      <el-row>
        <el-button>默认按钮</el-button>
        <el-button type="primary">主要按钮</el-button>
        <el-button type="success">成功按钮</el-button>
        <el-button type="info">信息按钮</el-button>
        <el-button type="warning">警告按钮</el-button>
        <el-button type="danger">危险按钮</el-button>
      </el-row>
      <router-view />
    </div>
  </template>
  ```

  运行打包命令`npm run serve`查看效果

- 通过图形化界面安装

  命令行运行`vue ui`打开图形化界面，进入项目配置界面搜索插件`vue-cli-plugin-element`并安装

  安装完成后接着配置插件，将全局导入改为按需导入，以减小项目体积

  打开项目目录，发现src文件夹下多了一个plugins文件夹，里面有个`element.js`文件，内容如下

  ```js
  import Vue from 'vue'
  import { Button } from 'element-ui'
  
  Vue.use(Button)
  ```

  发现自动导入了element的按钮组件，这时就可以在`App.vue`文件里面使用element标签了

#### 3 例子

##### 3.1 走马灯实现移动端滑动切换

可以通过检测移动端事件，获取走马灯实例执行切换方法实现

```vue
<template>
  <div
    class="banner"
    @touchstart="handleTouchStart"
    @touchmove="handleTouchMove"
    @touchend="handleTouchEnd"
  >
    <el-carousel
       class="bannerBox"
       ref="carousel"
       indicator-position="outside"
       trigger="hover"
     ></el-carousel>
  </div>
</template>
<script>
export default {
  name: "FirstRecommend",
  data() {
    return {
      startX: 0,
      endX: 0
    }
  },
  methods: {
    handleTouchStart(event) {
      this.startX = event.touches[0].clientX
    },
    handleTouchMove(event) {
      this.endX = event.touches[0].clientX
    },
    handleTouchEnd() {
      const distance = this.endX - this.startX
      // 切换阈值
      const threshold = 50
      if (distance > threshold) {
        // 向右滑动，执行切换方法切换到上一张
        this.$refs.carousel.prev()
      } else if (distance < -threshold) {
        // 向左滑动，执行切换方法切换到下一张
        this.$refs.carousel.next()
      }
    }
  }
}
</script>
```

















