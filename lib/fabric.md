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
getObjects() // 分组中所有对象的数组
size() // 所有对象的数量
contains()  // 检查特定对象是否在分组中
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

##### 7.3 打散分组

可以将已经组合好的分组打散成各个独立的图形，可以编写如下函数实现

```js
const ungroup = () => {
  // 判断当前有没有选中元素，如果没有就不执行任何操作
  if (!canvas.getActiveObject()) {
    return
  }
  // 判断当前选中的元素是否是组，如果不是，就不执行任何操作
  if (canvas.getActiveObject().type !== 'group') {
    return
  }
  // 先获取当前选中的元素，然后调用 toActiveSelection 将其打散
  canvas.getActiveObject().toActiveSelection()
}
```

#### 8 事件

可以通过 `on` 给图形对象添加事件，或者给 canvas 画布添加事件，`off` 去除事件

```js
// 多边形
// 和折线一样，不同的是多边形会自动闭合起点和终点
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
polygon.on('selected', options => {
  console.log('选中多边形:', options)
})
```

这样在选中多边形的时候就会触发回调函数，打印 options

#### 9 绘画

想要绘画需要开启绘画模式，通过设置 canvas 的 isDrawingMode 属性可以开启和关闭绘画模式

```js
canvas.isDrawingMode = true
```

10 操作禁止

某些场景下可能需要禁止某些操作，比如禁止水平和垂直移动、禁止旋转、禁止缩放等

```js
// 多边形
// 和折线一样，不同的是多边形会自动闭合起点和终点
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
// 禁止水平移动
polygon.lockMovementX = true
// 禁止重置移动
polygon.lockMovementY = true
// 禁止旋转
polygon.lockRotation = true
// 禁止水平缩放
polygon.lockScalingX = true
// 禁止垂直缩放
polygon.lockScalingY = true
```

#### 10 缩放、平移画布

##### 10.1 缩放画布

在 PC 端，监听的事件是 `mouse:wheel`，默认是以原点为基准缩放的，原点就是左上角的（0，0）坐标

```js
// 监听鼠标滚轮事件
canvas.on('mouse:wheel', opt => {
  // 滚轮向上滚一下是 -100，向下滚一下是 100
  let delta = opt.e.deltaY
  // 获取画布当前缩放值
  let zoom = canvas.getZoom()
  // 控制缩放范围在 0.01~20 的区间内
  zoom *= 0.999 ** delta
  if (zoom > 20) zoom = 20
  if (zoom < 0.01) zoom = 0.01
  // 设置画布缩放比例
  canvas.setZoom(zoom)
})
```

如果想以鼠标坐标为基准缩放，需要调用设置缩放坐标的 api

```js
// 监听鼠标滚轮事件
canvas.on('mouse:wheel', opt => {
  // 滚轮向上滚一下是 -100，向下滚一下是 100
  let delta = opt.e.deltaY
  // 获取画布当前缩放值
  let zoom = canvas.getZoom()
  // 控制缩放范围在 0.01~20 的区间内
  zoom *= 0.999 ** delta
  if (zoom > 20) zoom = 20
  if (zoom < 0.01) zoom = 0.01
  // 这里调用调用设置缩放坐标的 api
  // 参数1：将画布的缩放点设置成鼠标当前坐标
  // 参数2：传入缩放值
  canvas.zoomToPoint(
    {
      x: opt.e.offsetX, // 鼠标x轴坐标
      y: opt.e.offsetY  // 鼠标y轴坐标
    },
    zoom // 画布缩放比例
  )
})
```

##### 10.2 平移画布

这里实现 PC 端按住 `alt` 键平移画布的功能，想实现这个功能，我们可以将功能拆解一下

1. 鼠标按下
2. 鼠标移动
3. 鼠标停止移动

我们需要在这 3 个不同的阶段去处理对应的情况

1. 鼠标按下可通过 `mouse:down` 去监听到，由于我们要按住 `alt` 键才可以平移，所以需要在监听函数中判断是否按下了 `alt` 键，如果按下了 `alt` 键，则设置一个变量值去 **开启移动状态**，并且记录下当前鼠标的坐标值 x 和 y
2. 鼠标移动可通过 `mouse:move` 去监听到，判断是否需要移动，如果需要移动则立刻转换画布视图模式，将画布移动到鼠标坐标处
3. 鼠标松开可通过 `mouse:up` 去监听到，鼠标松开时，将画布定格到鼠标松开的坐标处，**关闭移动状态**

```js
// 监听鼠标按下
canvas.on('mouse:down', opt => {
  let evt = opt.e
  // 判断是否按住 alt 键
  if (evt.altKey === true) {
    // 开启移动状态，isDragging 是自定义变量
    canvas.isDragging = true
    // 记录鼠标按下时的坐标，lastPosX 和 lastPosY 是自定义变量
    canvas.lastPosX = evt.clientX
    canvas.lastPosY = evt.clientY
  }
})

// 监听鼠标移动
canvas.on('mouse:move', opt => {
  // 判断是否在移动状态，只有移动状态才会执行
  if (canvas.isDragging) {
    let evt = opt.e
    // 转换画布视图模式
    let vpt = canvas.viewportTransform
    vpt[4] += evt.clientX - canvas.lastPosX
    vpt[5] += evt.clientY - canvas.lastPosY
    // canvas 重新渲染
    canvas.requestRenderAll()
    // 更新按下时的坐标为移动时的新坐标
    canvas.lastPosX  = evt.clientX
    canvas.lastPosY  = evt.clientY
  }
})

// 监听鼠标松开
canvas.on('mouse:up', opt => {
  // 设置画布的视口转换，即定格到最后鼠标松开的坐标处  
  canvas.setViewportTransform(canvas.viewportTransform)
  // 关闭移动状态
  canvas.isDragging = false
})
```

#### 11 选中状态

fabric 创建的图形默认是可以被选中的，关于选中有许多可关注的点，比如是否可选中、空白区域是否可以选中图形、选中图形后图形的样式如何变化等等

##### 11.1 禁止选中

设置后，鼠标移动到图形上鼠标指针形状还是会变化，但是无法选中图形

```js
polygon.selectable = false
```

##### 11.2 禁止空白区域选中

设置后，鼠标必须放在图形上才能选中，而不是包裹图形的矩形区域中的任意一点都能选中

```js
path.perPixelTargetFind = true
```

##### 11.3 框选设置

可以通过鼠标在画布上移动画出一个矩形框进行批量选中图形，可以对画出的矩形框进行一些样式设置，以及控制框选表现

```js
// 画布是否可通过框选选中，默认 true，false 为不可选中，但仍可以直接点击图形进行选中
canvas.selection = true
// 鼠标框选时的背景色
canvas.selectionColor = 'rgba(234, 61, 255, 0.3)'
// 鼠标框选时的边框颜色
canvas.selectionBorderColor = "#1d2786"
// 鼠标框选时的边框宽度
canvas.selectionLineWidth = 6
// 鼠标框选时边框的虚线规则
canvas.selectionDashArray = [30, 4, 10]
// 只会选中完全包含在框选的选择框内的图形，只框选一部分的图形不会被选中
canvas.selectionFullyContained = true
```

##### 11.4 自定义图形选中框样式

当我们选中图形时，图形的样式会产生变化，具体是多出一个用于控制图形缩放及旋转的选中框，默认的选中框样式不好看，我们可以自定义这个选中框的样式

```js
path.set({
  borderColor: 'red',   // 选中框颜色
  cornerColor: 'green', // 控制角颜色
  cornerSize: 10,       // 控制角大小
  transparentCorners: true, // 控制角颜色设置不透明，如不设置，控制角的中间会变空白
  selectionBackgroundColor: 'orange' // 背景色
})
```

隐藏选中框的框线，但是控制角和背景色还在

```js
path.hasBorders = false
```

隐藏控制角，但是没有控制角将意味着无法用鼠标直接操作缩放和旋转，而只是允许移动操作

```js
path.hasControls = false
```

自定义鼠标悬停样式，这里定义了鼠标悬停在图形上时的样式

```js
path.hoverCursor = 'wait'
```

定义移动图形时的样式，这里定义了鼠标按下选中图形或选中图形进行移动时，图形的样式，这里的效果是缩放

```js
function animate(e, dir) {
  if (e.target) {
    fabric.util.animate({
      startValue: e.target.get('angle'),
      endValue: e.target.get('angle') + (dir ? 10 : -10),
      duration: 100
    })
    fabric.util.animate({
      startValue: e.target.get('scaleX'),
      endValue: e.target.get('scaleX') + (dir ? 0.2 : -0.2),
      duration: 100,
      onChange: function(value) {
        e.target.scale(value)
        canvas.renderAll()
      },
      onComplete: function() {
        e.target.setCoords()
      }
    })
  }
}
canvas.on('mouse:down', function(e) { animate(e, 1) })
canvas.on('mouse:up', function(e) { animate(e, 0) })
```

#### 12 裁剪

##### 12.1 定位基准点

可通过 `clipPath` 属性对图形进行裁剪，clipPath 将会从 **图形对象的中心** 开始定位

图形对象的 originX 和 originY 不起任何作用，也就是说，图形的 originX 和 originY 是用来定义对象的 **定位基准点** 的

而 clipPath 的 originX 和 originY 是起作用的，定位逻辑与 `fabric.Group` 相同，因为 clipPath 的定位基准点会影响 clipPath **相对于图形的位置**，也就是最终裁剪的位置会发生改变

如何理解定位基准点呢，请看如下的例子：

这里定义了一个矩形，相对于原点（0，0），距离 x 轴 100px， y 轴 100px

- 当 originX 和 originY 的值都是 center 时，此时矩形的中心点定位于坐标（200，200）处
- 当 originX 的值是 left 时，此时矩形的最左边定位于坐标（200，200）处，看上去像是矩形往右边平移了
- 当 originX 的值是 right 时，此时矩形的最右边定位于坐标（200，200）处，看上去像是矩形往左边平移了
- originY 的值分别是 top、center、bottom，效果与 originX 一致，不过是竖直方向
- originX 和 originY 通过设置不同的值进行排列组合可产生不同的效果，大家同理可证

这里（200，200）就是基准点，originX 和 originY 设置了相对于基准点的定位方式，这就是定位基准点

```js
const rect = new fabric.Rect({
  width: 100,
  height: 100,
  fill: 'blue',
  left: 200,
  top: 200,
  originX: 'center',
  originY: 'center'
})
```

##### 12.2 单一图形裁剪

对一个单一图形进行裁剪

```js
const clipPath = new fabric.Circle({
  radius: 60,
  left: -40,
  top: -40
})
polygon.clipPath = clipPath  // 这将会把多边形裁剪为圆形
```

##### 12.3 组裁剪

对一个组进行裁剪

```js
const clipPath = new fabric.Circle({
  radius: 40,
  left: -40,
  top: -40
})
const group = new fabric.Group([
  new fabric.Rect({ width: 100, height: 100, fill: 'red' }),
  new fabric.Rect({ width: 100, height: 100, fill: 'yellow', left: 100 }),
  new fabric.Rect({ width: 100, height: 100, fill: 'blue', top: 100 }),
  new fabric.Rect({ width: 100, height: 100, fill: 'green', left: 100, top: 100 })
])
group.clipPath = clipPath
```

##### 12.4 组对组裁剪

设置一个组为 clipPath 对另一个组进行裁剪

```js
const clipPath = new fabric.Group(
  [
    new fabric.Circle({ radius: 70, top: -70, left: -70 }),
    new fabric.Circle({ radius: 40, top: -95, left: -95 }),
    new fabric.Circle({ radius: 40, top: 15, left: 15 })
  ],
  { left: -95, top: -95 }
)
const group = new fabric.Group([
  new fabric.Rect({ width: 100, height: 100, fill: 'red' }),
  new fabric.Rect({ width: 100, height: 100, fill: 'yellow', left: 100 }),
  new fabric.Rect({ width: 100, height: 100, fill: 'blue', top: 100 }),
  new fabric.Rect({
    width: 100,
    height: 100,
    fill: 'green',
    left: 100,
    top: 100
  })
])
group.clipPath = clipPath
```

##### 12.5 组合裁剪

设置一个图形为 clipPath 对另一个图形进行裁剪，然后把另一个图形作为 clipPath 再对另一个组（图形）进行裁剪，有点像套娃裁剪

```js
const clipPath = new fabric.Circle({ radius: 70, top: -50, left: -50 })
const innerClipPath = new fabric.Circle({ radius: 70, top: -90, left: -90 })
// 第一次裁剪
clipPath.clipPath = innerClipPath
const group = new fabric.Group([
  new fabric.Rect({ width: 100, height: 100, fill: 'red' }),
  new fabric.Rect({ width: 100, height: 100, fill: 'yellow', left: 100 }),
  new fabric.Rect({ width: 100, height: 100, fill: 'blue', top: 100 }),
  new fabric.Rect({ width: 100, height: 100, fill: 'green', left: 100, top: 100 }),
])
// 第二次裁剪
group.clipPath = clipPath
```

##### 12.6 文字裁剪

没错，文字也属于图形的一种，因此也可以当作是 clipPath，用于裁剪

```js
const clipPath = new fabric.Text(
  'Hi I\'m the \nnew ClipPath!\nI hope we\'ll\nbe friends',
  { top: -100, left: -100 }
)
const group = new fabric.Group([
  new fabric.Rect({ width: 100, height: 100, fill: "red" }),
  new fabric.Rect({ width: 100, height: 100, fill: "yellow", left: 100 }),
  new fabric.Rect({ width: 100, height: 100, fill: "blue", top: 100 }),
  new fabric.Rect({ width: 100, height: 100, fill: "green", left: 100, top: 100 }),
])
group.clipPath = clipPath
```

##### 12.7 画布裁剪

画布也是可以被裁剪的，裁剪后只会显示裁剪后的画布的内容

```js
const group = new fabric.Group([
  new fabric.Rect({ width: 100, height: 100, fill: "red" }),
  new fabric.Rect({ width: 100, height: 100, fill: "yellow", left: 100 }),
  new fabric.Rect({ width: 100, height: 100, fill: "blue", top: 100 }),
  new fabric.Rect({ width: 100, height: 100, fill: "green", left: 100, top: 100 }),
])
const clipPath = new fabric.Circle({ radius: 100, top: 0, left: 50 })
canvas.clipPath = clipPath
```

可以设置在被裁剪的画布之外，还能看见图形的控件，控制图形的缩放和旋转

```js
const group = new fabric.Group([
  new fabric.Rect({ width: 100, height: 100, fill: "red" }),
  new fabric.Rect({ width: 100, height: 100, fill: "yellow", left: 100 }),
  new fabric.Rect({ width: 100, height: 100, fill: "blue", top: 100 }),
  new fabric.Rect({ width: 100, height: 100, fill: "green", left: 100, top: 100 }),
])
canvas.controlsAboveOverlay = true  // 设置可见控件
const clipPath = new fabric.Circle({ radius: 100, top: 0, left: 50 })
canvas.clipPath = clipPath
```

#### 13 序列化

所谓序列化就是将画布内容转化为其他格式的数据去保存，fabric 除了能把画布转化为 JSON，还能转化为 base64 和 svg

##### 13.1 JSON序列化

三个方法都能进行 JSON 序列化，生成的 JSON 里包含了画布以及画布包含的图形的数据，如果需要特定的 JSON 数据，需要自行进行数据转换

```js
console.log('canvas stringify ', JSON.stringify(canvas))
console.log('canvas toJSON', canvas.toJSON())
console.log('canvas toObject', canvas.toObject())
```

##### 13.2 base64

这个方法将会在控制台输出 base64 格式的 png 图片，由于此方法执行会打断 canvas 渲染，因此需要再执行一遍 `requestRenderAll` 才能显示渲染的图形

```js
console.log('toPng', canvas.toDataURL('png'))
canvas.requestRenderAll()
```

##### 13.3 svg

生成 svg 图片

```js
console.log('toSVG', canvas.toSVG())
```

#### 14 反序列化

所谓反序列化就是序列化的逆过程，将 JSON 数据重新渲染到画布上生成图形

```js
const str = ''  // JSON字符串
canvas.loadFromJSON(str)
```



#### x 使用图片

略

#### x 渐变和滤镜

略



























