#### 1 变量

sass使用`$`来标识变量，任何可以用作css属性值的赋值都可以用作sass的变量值

```scss
$highlight-color: #F90;
```

变量可以定义在块内和块外，定义在块内时只在块内生效

```scss
$nav-color: #F90;
nav {
  $width: 100px;
  width: $width;
  color: $nav-color;
}
```

变量可以引用别的变量

```scss
$highlight-color: #F90;
$highlight-border: 1px solid $highlight-color;
```

#### 2 嵌套规则

在css中经常存在选择器被反复书写的情况，如下，content被反复书写，这样是很麻烦的

```css
#content article h1 { color: #333 }
#content article p { margin-bottom: 1.4em }
#content aside { background-color: #EEE }
```

在sass中，可以嵌套书写，只需要写一遍，且可读性更高

```scss
#content {
  article {
    h1 { color: #333 }
    p { margin-bottom: 1.4em }
  }
  aside { background-color: #EEE }
}
```

如需给选择器自身添加某些效果，比如伪类，如上方式是行不通的，需要使用`&`选择自身

```scss
a {
  color: blue;
  &:hover { color: red }
}
```

#### 3 文件导入

无需`.scss`后缀

```scss
@import "colors"
```

#### 4 混合器

sass一大特性就是复用代码，但是变量只能复用一个属性，当我们需要复用大段的代码时，可以使用mixin

> 当一段代码具有**某一个**特定功能时，且多处用到该段代码，适合使用混合器，比如溢出省略号

```scss
@mixin rounded-corners {
  -moz-border-radius: 5px;
  -webkit-border-radius: 5px;
  border-radius: 5px;
}
```

使用：

```scss
notice {
  background-color: green;
  border: 2px solid #00aa00;
  @include rounded-corners;
}
```

也可以像写函数那样传参

```scss
@mixin link-colors($normal, $hover, $visited) {
  color: $normal;
  &:hover { color: $hover; }
  &:visited { color: $visited; }
}
```

使用：

```scss
a {
  @include link-colors(blue, red, green);
}
```

#### 5 选择器继承

可以通过继承样式来简化代码

> 当某个类属于另一个类的拓展时，适合使用继承

```scss
.error {
  border: 1px solid red;
  background-color: #fdd;
}

.seriousError {
  @extend .error;
  border-width: 3px;
}
```
