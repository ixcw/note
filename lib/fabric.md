#### 1 fabric

fabric 是对 canvas 的更高一层的封装，适合用于操作 2d 图形

#### 2 安装

通过 npm 安装即可

```sh
npm install fabric@4.6.0
```

然后在页面引入

```js
import { fabric } from 'fabric'
```

#### 3 画布

要使用 fabric 操作图形，首先需要新建一个画布

先创建一个 canvas 元素，给个 id，方便 fabric 选中

```html
<canvas id="c"></canvas>
```

然后就可以使用导入的 fabric 类创建画布了

```js
// canvas画布 初始化为视口宽高
const width = window.innerWidth
const height = window.innerHeight
const canvas = new fabric.Canvas('c', {
  width,  // 指定画布宽度
  height  // 指定画布高度
})
```

#### 4 基础图形

fabric 提供了几种基础图形，同样通过调用 fabric 类进行创建，下面分别介绍

> 图形的某些公共配置属性是通用的，比如表示图形位置的 top、left 等

##### 4.1 矩形

```js
const rect = new fabric.Rect({
  top: 30,   // 距离画布顶部的距离
  left: 30,  // 距离画布左边的距离
  width: 100,  // 宽度
  height: 60,  // 高度
  fill: '#5e5e5e',  // 填充颜色
  rx: 20,  // x轴的半径，用于创建圆角
  ry: 20   // y轴的半径，用于创建圆角
})
```

##### 4.2 圆形

```js
const circle = new fabric.Circle({
  top: 100,
  left: 100,
  fill: 'green',
  radius: 50  // 圆的半径
})
```

##### 4.3 椭圆

```js
const ellipse = new fabric.Ellipse({
  top: 20,
  left: 20,
  fill: 'hotpink',
  rx: 70,  // x轴的半径，用于创建圆角，x方向值越大，椭圆x轴方向越长
  ry: 30   // y轴的半径，用于创建圆角
})
```

##### 4.4 三角形

```js
const triangle = new fabric.Triangle({
  top: 100,
  left: 200,
  fill: 'blue',
  width: 80, // 底边长度
  height: 100, // 底边上的高
  angle: 90 // 旋转30度
})
```

##### 4.5 直线

```js
const line = new fabric.Line(
  [
    10, 10,   // 起点坐标
    200, 300  // 结点坐标
  ],
  {
    stroke: 'red', // 直线颜色
  }
)
```

##### 4.6 折线

折线不会自动闭合起点和终点

```js
// 
const polyline = new fabric.Polyline([
  {x: 30, y: 30},
  {x: 150, y: 140},      // 折线的每个折点坐标
  {x: 240, y: 150},
  {x: 100, y: 30}
], {
  fill: 'transparent',  // 折线需要填充透明色，否则中间会默认填充黑色
  stroke: '#6639a6',    // 线段颜色
  strokeWidth: 5        // 线段粗细
})
```

##### 4.7 多边形

多边形的配置和折线基本一样，不同的是多边形会自动闭合起点和终点

```js
const polygon = new fabric.Polygon([
  { x: 50, y: 50 },
  { x: 200, y: 50 },
  { x: 200, y: 200 },
  { x: 50, y: 200 }
], {
  top: 300,
  left: 300,
  fill: '#eee',
  stroke: '#5e5e5e',
  strokeWidth: 12
})
```

##### 4.8 路径

```js
// M: 起点坐标
// L: 折点坐标
// z: 自动闭合起点和终点
const path = new fabric.Path('M 0 0 L 200 100 L 170 200 z')
path.set({
  top: 300,
  left: 500,
  fill: 'hotpink', // 填充颜色
  opacity: 0.6,    // 不透明度
  stroke: 'black', // 路径颜色
  strokeWidth: 10  // 路径粗细
})
```

##### 4.9 文本

```js
// 文本
const text = new fabric.Text('雷猴啊')
// 文本，可编辑
const itext = new fabric.IText('靓仔')
// 文本框，可编辑，自动换行
const textbox = new fabric.Textbox('Lorum ipsum dolor sit amet', { width: 250 })
```

定义了基础图形后，可通过画布的 add 函数将图形添加到画布上

```js
canvas.add(
  rect,
  circle,
  ellipse,
  triangle,
  line,
  polyline,
  polygon,
  path,
  text,
  itext,
  textbox
)
```

#### 5 常用样式

fabric 有一些常用样式，比如选中图形，改变样式状态

```js
// 圆形
const circle = new fabric.Circle({
  top: 100,
  left: 100,
  radius: 50, // 圆形的半径 50
  fill: 'yellow', // 填充色
  backgroundColor: 'green', // 背景色
  stroke: '#f6416c', // 边框颜色
  strokeWidth: 5, // 边框粗细
  strokeDashArray: [20, 5, 14], // 边框虚线规则：填充20px 空5px 填充14px 空20px 填充5px ……
  shadow: '10px 20px 6px rgba(10, 20, 30, 0.4)', // 投影：向右偏移10px，向下偏移20px，羽化6px，投影颜色及透明度
  transparentCorners: false, // 选中时，角是被填充了。true 空心；false 实心
  borderColor: '#16f1fc', // 选中时，边框颜色：天蓝
  borderScaleFactor: 5, // 选中时，边的粗细：5px
  borderDashArray: [20, 5, 10, 7], // 选中时，虚线边的规则
  cornerColor: "#a1de93", // 选中时，角的颜色是 青色
  cornerStrokeColor: 'pink', // 选中时，角的边框的颜色是 粉色
  cornerStyle: 'circle', // 选中时，叫的属性。默认rect 矩形；circle 圆形
  cornerSize: 20, // 选中时，角的大小为20
  cornerDashArray: [10, 2, 6], // 选中时，虚线角的规则
  selectionBackgroundColor: '#7f1300', // 选中时，选框的背景色：朱红
  padding: 40, // 选中时，选择框离元素的内边距：40px
  borderOpacityWhenMoving: 0.6, // 当对象活动和移动时，对象控制边界的不透明度  
})
```

#### 6 转换

转换就是将图形进行各种变换，比如旋转、平移、缩放、翻转等等

##### 6.1 旋转

旋转就是配置 angle 属性，比如三角形旋转 30度

```js
const triangle = new fabric.Triangle({
  top: 100,
  left: 200,
  fill: 'blue',
  width: 80,
  height: 100,
  angle: 90 // 旋转30度
})
```

##### 6.2 平移

平移直接设置 top 和 left 的值即可

```js
const rect = new fabric.Rect({
  top: 30,
  left: 30,
  width: 100,
  height: 60,
  fill: '#5e5e5e',
  rx: 20,
  ry: 20
})
```

##### 6.3 缩放

缩放可以设置x轴和y轴方向的缩放，无损缩放，线段宽度会被放大

```js
const polygon = new fabric.Polygon([
  { x: 50, y: 50 },
  { x: 200, y: 50 },
  { x: 200, y: 200 },
  { x: 50, y: 200 }
], {
  top: 300,
  left: 300,
  fill: '#eee',
  stroke: '#5e5e5e',
  strokeWidth: 12,
  scaleX: 2,  // x轴方向放大两倍
  scaleY: 2   // y轴方向放大两倍
})
```

##### 6.4 翻转

将 scaleX 或 scaleY 的值设置为 -1 即可实现效果，同时设置则两个方向都进行翻转

```js
const path = new fabric.Path('M 0 0 L 200 100 L 170 200 z')
path.set({
  top: 300,
  left: 500,
  fill: 'hotpink',
  opacity: 0.6,
  stroke: 'black',
  strokeWidth: 10,
  scaleX: -1,  // 水平翻转
  scaleY: -1   // 垂直翻转
})
```

#### 7 分组

##### 7.1 创建分组

可以创建一个分组，有点类似于 PS 里面的分组，把多个图层分为同一个组，从而实现同步操作，比如同时进行平移、旋转、缩放等操作

```js
// 数组元素顺序影响图层覆盖，比如这里是 text 覆盖在 ellipse 上面
const group = new fabric.Group([ellipse, text], {
  top: 50,
  left: 100,
  angle: -10
})
```

##### 7.2 操作分组

分组创建好后，可对其进行操作，常见操作如下

```js
getObjects() // 返回一组中所有对象的数组
size() // 所有对象的数量
contains()  // 检查特定对象是否在 group 中
item()  // 选中组中的元素，参数为数组索引
forEachObject()  // 遍历组中对象
add()  // 添加元素对象
remove()  // 删除元素对象
fabric.util.object.clone()  // 克隆
```

比如 `item()`，用法如下

```js
group.item(0).set('fill', 'green')  // 将组中第一个元素 ellipse 填充为绿色
group.item(1).set({  // 将组中第二个元素 text 的文本内容改为 '雷猴，世界'，颜色改为白色
  text: '雷猴，世界',
  fill: '#fff'
})
```

#### x 使用图片

略

#### x 渐变和滤镜

略



























