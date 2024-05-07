#### 1 常用插件

1. chinese language pack
2. code glance pro
3. git tool box
4. translation
5. WeChat mini program support
6. material ui lite  -  推荐主题 `palenight`  字体 `fira code`

#### 2 项目配置

1. webstorm 不能识别 `@` 根目录别名

   根目录添加 `webpack.config.js` 文件

   ```js
   /* webstorm 识别 @ 别名 */
   
   const path = require('path')
   
   module.exports = {
     context: path.resolve(__dirname, './'),
     resolve: {
       extensions: ['.js', '.vue', '.json'],
       alias: {
         '@': path.resolve('./')
       }
     }
   }
   ```

   然后webstorm设置语言和框架，找到JavaScript，webpack，手动配置文件为这个添加的文件

2. 开发uniapp不能识别`rpx`单位

   安装插件 `WeChat mini program support`

3. 不能识别uniapp官方函数

   webstorm设置语言和框架，找到JavaScript，库，安装库 `uni-app`

4. 不能识别node官方函数

   webstorm设置语言和框架，找到JavaScript，库，安装库 `node.js core`

5. 不能识别 `:class`

   安装插件 `uniapp-support`

6. 未解析的变量、未使用的导出

   编辑器的检查里面取消相关项目的检查

3 常见问题

1. gitlab项目不能更新代码，提示获取accesstoken，但是token版本不对

   卸载webstorm自带插件gitlab，然后更新代码，输入gitlab账号密码并记住















