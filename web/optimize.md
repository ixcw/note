#### vue2 项目优化

1. 生产环境去掉 sourcemap，减少 dist 打包大小

2. 压缩图片

3. vue 脚手架默认开启了 preload 与 prefetch，可以配置删除预获取和预加载，减少请求数

4. 通过 `webpack-bundle-analyzer` 插件可以分析打包的文件包含了哪些文件资源，从而着手优化

5. 开启 gzip 压缩代码，需要前后端配合，前端利用 `compression-webpack-plugin` 插件压缩代码成 gz，后端配置 nginx 的 gzip，

   有静态和在线压缩两种方式，可以都配置，静态优先级更高，静态压缩就是直接把前端压缩好的 gz 文件返回给浏览器，在线压缩就是将没有压缩的 js 文件利用服务器的 cpu 压缩过后返回给浏览器

2. 