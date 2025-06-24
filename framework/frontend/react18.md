#### 1 基本使用

显示原生 html

```jsx
const rawHtml = '<span>富文本<i>斜体字</i><b>加粗</b></span>'
const rawHtmlData = { __html: rawHtml }
const rawHtmlElem = <div>
        <p dangerouslySetInnerHTML={rawHtmlData}></p>
        <p>rawHtml</p>
      </div>
return rawHtmlElem
```

#### 2 事件

react 的事件是自己合成的事件 `SyntheticEvent`，不同于原生事件，也不同于 vue 的事件，模拟了 dom 事件的所有能力，当然也提供了访问原生事件的属性 `event.nativeEvent` ，所有的事件都被挂载到 document 上















































