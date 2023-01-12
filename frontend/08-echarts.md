#### 1 数据可视化

数据可视化就是利用图形化的手段将数据转化为图形，可以更加直观地表达和沟通信息，揭示蕴含在数据中的规律，可以利用可视化库帮助我们进行数据的可视化，比如百度的ECharts

#### 2 ECharts使用步骤

目前已进入Apache基金会作为开源项目，和常规js库的引用方式相同，下载然后在页面中引入，大概有5个步骤

1. 下载并引入echarts文件

2. 准备装载图表的DOM容器，需要指定大小

3. 初始化echarts对象

   ```js
   var box = document.querySelector('.box')
   var myChart =  echarts.init(box)
   ```

4. 指定配置项和数据

   ```js
   var option = {
       title: {
           text: 'ECharts 入门示例'
       },
       tooltip: {},
       legend: {
           data: ['销量']
       },
       xAxis: {
           data: ['衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋', '袜子']
       },
       yAxis: {},
       series: [
           {
               name: '销量',
               type: 'bar',
               data: [5, 20, 36, 10, 10, 20]
           }
       ]
   }
   ```

5. 给echarts对象设置配置项

   ```js
   myChart.setOption(option)
   ```

然后echarts就会将图表渲染到指定DOM容器里面了

#### 3 配置项

其实学习echarts关键在于学习如何查阅其文档根据需求修改配置，先来看常用配置：

1. title

   标题组件，用于配置图表的标题

2. tooltip

   提示框组件，用于设置提示框，鼠标放在图表上进行提示的小图框

   - trigger

     触发方式，使用item的意思是放到非轴图形的数据对应的图形上触发提示

   - formatter

     格式化提示内容
     a：series系列图表名称
     b：series数据名称 data 里面的name
     c：series数据值 data 里面的value
     d：当前数据/总数据的比例
     
   ```js
   tooltip: {
       trigger: 'item',
       formatter: "{a} <br/>{b} : {c} ({d}%)"
   }
   ```


3. legend

   图例组件，展现了不同系列的标记，可以通过点击图例来控制不同系列的显示和隐藏

4. toolbox

   工具栏组件，里面存放了一些实用的工具，比如导出图片、缩放、重置等

5. grid

   绘图网格组件，设置网格的位置和刻度标签的显示等

6. xAxis 和 yAxis

   图表的X轴和Y轴的配置

7. color

   颜色列表，用于设置图表颜色

8. series

   系列列表

   - type

     用于选取图表类型，比如bar是柱形图，line是折线图

   - name

     设置系列名称，用于tooltip的显示和legend的筛选

   - stack

     用于设置数据是否堆叠

     如果设置相同的值则会发生数据堆叠，后面的系列的数据值等于自身和前面系列的数据值相加

     去掉这个选项或者设置不同的值就不会发生数据堆叠了
     
   - radius
   
     南丁格尔玫瑰图有两个圆，内圆和外圆都可以设置半径，单位可以是像素也可以是百分比（ 基于DOM容器大小），第一项是内半径，第二项是外半径（通过它可以实现饼形图大小），是百分比时要加引号
   
   - center
   
     图表的中心位置距离图表DOM容器边缘的距离 left 50%  top 50%  
   
   - roseType
   
     玫瑰类型，一种是半径模式，以半径为衡量单位，另一种是面积模式
   
   - data
   
     数据集，数据集合，是一个对象数组
     
   - label 和 labelLine

     label对象用于修饰饼形图文字和引导线的相关样式
     
     ```js
     series: [
         {
             name: '点位统计',
             type: 'pie',
             radius: ['10%', '70%'],
             center: ['50%', '50%'],
             // radius：半径模式  area：面积模式
             roseType: 'radius',
             data: [
                 {value:10, name:'rose1'},
                 {value:5, name:'rose2'},
                 {value:15, name:'rose3'},
                 {value:25, name:'rose4'},
                 {value:20, name:'rose5'},
                 {value:35, name:'rose6'},
                 {value:30, name:'rose7'},
                 {value:40, name:'rose8'}
             ],
             label: {
               fontSize: 10
             },
             labelLine: {
               // 连接到图形的线长度
               length: 6,
               // 连接到文字的线长度
               length2: 8
             }
         }
     ]
     ```
     

#### 4 自适应数据可视化项目

可以利用css的比例单位rem和一个js库`flexible.js`做页面自适应，通过媒体查询确定文字基准大小，根据设计稿大小确定适配范围

```css
/* 最大宽度是1024px，也就是屏幕宽度小于1024px */
@media screen and (max-width: 1024px) {
    html {
        /* 由1024px / 24 得出，分多少份可以在flexible.js代码里面修改 */
        font-size: 42.66px !important;
    }
}

@media screen and (min-width: 1920px) {
    html {
        font-size: 80px !important;
    }
}
```







