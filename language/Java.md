#### 0 环境配置

1. 右击我的电脑依次点击`属性\高级系统设置\环境变量\系统变量`

2. 新建如下变量：

   变量名|变量值|说明
   -|-|-
   JAVA_HOME|C:\Software\Java\jdk1.7.0_79|jdk的安装目录，目的是为了配置其他变量路径时用%%引用，故此变量也可不设
   classpath|.;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar|.代表当前路径，dt.jar是关于运行环境的类库，tools.jar是关于工具的类库
   Path|%JAVA_HOME%\bin|指明了系统能在任何路径下识别java命令

3. 测试：按下win+r输入cmd回车，依次输入java、javac，显示帮助文档

4. 使用cmd编译java：
   - 新建java源文件：HelloWorld.java
   
   - 打开cmd切换工作目录到java源文件目录
   
   - 输入命令：

     ```sh
     javac HelloWorld.java  # 编译java源文件
     java HelloWorld   # 执行字节码文件,边解释边执行，注意执行别跟.class后缀
     ```

>JDK(java development kit) > JRE(java runtime environment) > JVM(java virtual machine)

#### 1 基础语法

基本概念：

**标识符**：变量的名称或者类的名称就是标识符，由字母、数字、下划线、$符号组成，不能以数字开头，不能是java关键字或java保留字，区分大小写，最好能见名知意

**变量**：数据的临时存储场所，通常存放于内存中，变量名应符合标识符，以及驼峰命名，即第一个单词首字母小写，后面的单词首字母都是大写

**类**：类名应符合标识符，以及Pascal命名，即所有的单词首字母都是大写

**数据类型**：java中的数据类型分为**基础数据类型**和**引用数据类型**

> 一个Java源码文件只能定义一个`public`类型的class，并且class的名称和文件名要完全一致

##### 1.1 基础数据类型

基础数据类型共有8种，数值型占了6种，另外两种是字符型char和布尔型boolean，分别占据2、1字节大小

数值型分为整型和浮点型

整型有byte、short、int、long，分别占据1、2、4、8字节大小

整型的进制表示有十进制、八进制和十六进制，八进制以0~7表示，以0开头，十六进制以0~9及a~f表示，以0x开头，long型需在结尾加l

浮点型有float、double，分别占据4、8字节大小

浮点型默认为double，在结尾加d表示double（可选），float需在结尾加f

> 浮点数在计算机中无法精确表示，因此判断浮点数相等不能用`==`，正确的方法是利用差值小于某个临界值来判断，比如

```java
double x = 1 - 9.0/10;
Math.abs(x - 0.1) < 0.00001    //差的绝对值约为2.77...E-17
```

字符型以单引号括起来的单个字符表示，也可以直接赋值数字（ASCII数字），或者一串字符（Unicode编码）

布尔型只能是true或false，不能是其他值，数字也不行

数据类型转换小范围到大范围转换是自动转换（隐式转换），大范围到小范围需要强制类型转换，可能会精度丢失

**常量**：一旦定义后续不可修改的量值。普通变量定义时在前面加上final即变为常量，常量命名常用大写加下划线

##### 1.2 分支&循环

分支控制主要有if和switch，主要讲讲switch

**switch**：根据传入的表达式的结果执行特定的分支

> 一般需要加break，否则会接着下一个case执行， 表达式的结果可以是int或者是可以自动转换为int的值，又或者为字符串，比较的是字符串的内容

  ```java
  switch(i) {
    case 1:
      xxx;
      break;
    case 2:
      xxx;
      break;
    case 3:
    case 4:
      xxx;
      break;
    default:
      xxx;
      break;
  }
  ```

循环控制有while和for，根据不同的情况使用，主要看**循环次数是否已知**

循环次数未知时，常用while，至少需要执行一次循环时用do...while

循环次数已知时，常用for，在java中，数组的大小是固定的，因此for循环经常被用来遍历数组

数组是引用数据类型，由于数组的大小是固定的，因此数组在初始化时必须指定长度（直接或间接）

数组的初始化：

```java
int arr1[] = {1, 2, 3};
int[] arr2 = {4, 5, 6};  // 常用
int[] arr = new int[5];  // 创建时设定长度
int[] arr = new int[]{12, 21, 21, 22};  // 创建时直接赋值，不需要设定长度
int[] arr = {12, 21, 21, 22};  // 另一种直接赋值方式，不需要使用new关键字
```

数组长度：`arr.length`，大小等于数组元素的个数

数组索引：从0开始，即第一个数组元素的索引是0，最后一个数组元素的索引是`arr.length - 1`

利用for循环对数组遍历：

```java
int[] arr = {1, 2, 3};
for (int i = 0; i < arr.length; i++) {
	System.out.println(arr[i]);
}
```

如果只需要访问数组中的元素而**不需要关心其索引**，可以使用增强for循环，也叫foreach循环

> 每次循环会先把数组元素赋值给变量n，然后再在循环体里面对n进行处理
增强for循环的循环顺序是被**严格保证**的，因为其底层实现其实就是for循环，只不过多了给变量n赋值这步操作
除数组外，增强for循环还能够遍历所有可迭代的数据类型，包括List、Map等

```java
int[] ns = { 1, 4, 9, 16, 25 };
for (int n: ns) {
    System.out.println(n);
}
```

##### 1.3 方法

java中的方法的参数传递是值传递的，也就是说传递的是实参的值的拷贝，形参接收实参的赋值，在方法中改变形参的值并不会影响实参的值，因为修改的是形参的值，与实参无关

如果实参是引用类型，依然是值传递，只不过传递的是引用的拷贝，引用可理解为地址，但具体实现和别的语言不一样，在方法中对形参进行操作会影响到实参的内容，因为此时形参和实参指向同一个引用

> 注意：字符串也是引用类型，但是传递字符串时会有传递基础类型的错觉，也就是修改形参不会影响实参，这是因为java中的字符串是不可变的，查看java源码可发现String是final的，这样在修改字符串时，实际上相当于new了一个新的字符串并将其引用赋值给了形参，这样形参的值就是新字符串的引用，而实参还是原来字符串的引用，于是造成了修改失败的现象，所以判断是否会影响实参，主要看对形参的操作是**修改了引用还是修改了内容**（引用所指向的对象内容）



- `System.println();`会将所有输出的值转换为字符串再进行输出
- 变量分3类
>局部变量：在方法或者语句块的内部定义的变量，存储于栈区，随方法或语句块一起生成或者消失
>成员变量/实例变量：类内部的方法外部定义，存储于堆区，随对象生成消失
>静态变量/类变量：类内部用static修饰定义，随类装载卸载生成消失


- 比较浮点数大小可以用math包下的BigDecimal类，用equals比较
- 位运算 运算效率高 左移1位等于\*2 右移1位等于/2 `3<<2`相当于`3*4`

##### 1.3 比较引用类型大小

由于引用类型存储的是对象的引用（不是对象的地址），具体是如何实现对对象的引用则无需关心。判断引用类型引用的对象是否相等，使用equals方法

```java
s1.equals(s2);    //结果为boolean值
if(s1 != null && s1.equals(s2))    //避免NullPointerException
"h".equals(s2);    //用不可能为null的字符串做主体
```

##### 1.6 字符串

效果上是字符数组，实际的底层原理是字节数组

- 构造方法

  ```java
  /*
  public String();  //创建空白字符串，不含任何内容
  public String(char[] array);  //根据字符数组来创建字符串
  public String(byte[] array);  //根据字节数组来创建字符串，字符串的内容为ASCII码转换得到的字符
  String = "";  //直接创建
  */
  public class StringDemo {
    public static void main(String[] args) {
        byte[] byteArray = {56, 97, 103, 104};
        char[] charArray = {'a','b','c'};
        String str = new String(byteArray);
        String str1 = new String(charArray);
        System.out.println(str);  // 8agh
        System.out.println(str1); // abc
    }
  }
```
  
- 字符串常量池
  

程序中直接创建的字符串就在字符串常量池中，字符串常量池在堆中

  ```java
  String str2 = "abc";
  String str3 = "abc";
  String str4 = new String("abc");
  System.out.println(str2 == str3);  // true
  System.out.println(str2 == str4);  // false
  System.out.println(str2.equals(str4));  // true
```

  

- 字符串常用方法：
推荐字符串常量.equals（字符串对象引用），因为一旦字符串对象引用为null，那么反过来将会报错，null不能使用equals方法
```java
String s1 = "Hello";
"Hello".equals(s1);         // true 比较字符串内容是否相等
"Hello".contains("ll");     // true 是否包含子串
"Hello".indexOf("l");       // 2 首次出现的索引位置
"Hello".lastIndexOf("l");   // 3 最后出现的索引位置
"Hello".startsWith("He");   // true 以子串开头
"Hello".endsWith("lo");     // true 以子串结尾
"Hello".substring(2);       // "llo" 以索引2开始截取到末尾，包含2
"Hello".substring(2, 4);    // "ll" 以索引2开始截取到4，不包含4
"  \tHello\r\n ".trim();    // "Hello" 去除首尾空白字符等，返回一个新的字符串
"".isEmpty();               // true，判断字符串是否为空，标准是 str==null 或 str.length()==0
"  \n".isBlank();           // true，同isEmpty()，增加判断是否仅由空白字符构成
s1.replace('l', 'w');       // "hewwo"，所有字符'l'被替换为'w'

String s = "A,B,C,D";
String[] ss = s.split("\\,");     // {"A", "B", "C", "D"} 以','分割字符串

String[] arr = {"A", "B", "C"};
String s = String.join("***", arr); // "A***B***C" 以"***"连接字符串数组

String s = "Hi %s, your score is %d!";
s.formatted("Alice", 80);    // 传入其他参数，替换占位符，然后生成新的字符串
String.format("Hi %s, your score is %.2f!", "Bob", 59.5);    // 同上

String.valueOf(123); // "123" 把基本类型或引用类型转换为字符串
String.valueOf(45.67); // "45.67"
String.valueOf(true); // "true"
String.valueOf(new Object()); // java.lang.Object@636be97c

int n1 = Integer.parseInt("123"); // 123 字符串转换为基本类型
int n2 = Integer.parseInt("ff", 16); // 按十六进制转换，255
boolean b1 = Boolean.parseBoolean("true"); // true
boolean b2 = Boolean.parseBoolean("FALSE"); // false

char[] cs = "Hello".toCharArray(); // String -> char[] 字符串和字符数组互相转换
String s = new String(cs); // char[] -> String
```


##### 1.7 包装类型
有两种基本类型到包装类型的写法需要写全称，其余的首字母大写即可
| 基本类型 | 包装类型  |
| -------- | --------- |
| `int`      | `Integer`   |
| `char`     | `Character` |
其余六种包装类型是`Byte` `Short` `Long` `Float` `Double` `Boolean`
源码及转换例子如下

```java
Integer n = new Integer(10);  // 手动装箱 se5之前
int m = n.intValue();  // 手动拆箱
Integer m  = 10;  // 自动装箱 se5之后
int n = m;     // 自动拆箱  自动装箱和自动拆箱只发生在编译阶段，目的是为了少写代码
```
##### 1.8 常用类
1. `BigDecimal`：可以表示一个任意大小且精度完全准确的浮点数，在比较两个BigDecimal的值是否相等时，要特别注意，使用equals()方法不但要求两个BigDecimal的值相等，还要求它们的scale()相等，必须使用compareTo()方法来比较，它根据两个值的大小分别返回负数、正数和0，分别表示小于、大于和等于

2. `Math`

   生成随机整数：

   ```java
   double min = 10;
   double max = 50;
   double n = Math.random() * (max - min) + min; // Math.random()的范围是[0,1)，n为[10,50)
   long m = (long) n; // m的范围是[10,50)的整数
   ```
   `SecureRandom`类可以产生安全的真随机数
##### 1.9 static静态关键字



#### 2 面向对象
- 类里面的成员变量可以不初始化赋值，系统自动初始化赋值，而局部变量必须先初始化赋值才能使用
- 同一个类的不同对象有不同的成员变量存储空间，而不同对象共享该类的同一个方法
- 除基本数据类型外，其余都是引用数据类型，类似于C++的指针，对象的名字本质上就是指针，指针存储在栈区，对象存储在堆区
- this关键字也是指针，对自身对象的引用
- static关键字声明静态成员变量，存储在数据区，对该类不同对象来说只有一份，共享一份，静态方法不再针对某个对象调用，所以不能访问非静态成员变量
- 定义包名后，编译出来的class文件必须位于正确的文件夹下面，即包名指定的文件夹，class文件的包名顶层文件夹要在classpath里，方便查找
- 在子类中可对父类的方法进行重写
- super关键字指向父类对象
- **子类的构造方法必须先显式地调用基类的构造方法，除非父类构造方法是默认的**，
```java
super();    //调用父类的构造方法
this();    //调用自己的构造方法
```
- 父类向子类强制向下转型，最好借助运算符`instanceof`判断父类的实例是否是子类的类型
```java
Object obj = "hello";
if (obj instanceof String) {
    String s = (String) obj;
    System.out.println(s.toUpperCase());
}
```
- `java.lang`包下的`Object`类的`toString()`方法，作用是返回一个以十六进制文本表示这个对象的字符串，建议所有子类重写此方法，`包名.类名`是完整的类名，通常省略了包名
```java
getClass().getName() + '@' + Integer.toHexString(hashCode());    //包名.类名@十六进制的哈希码
```
- equals方法一般需要根据需求重写，**String类已经重写了equals，可以比较字符串是否一样**，如果不重写，则只有比较的两个引用指向的是同一个对象的时候才会返回true

- 父类的引用不可用访问其子类对象新增加的成员（属性和方法）

- 子类如果定义了一个与父类方法参数返回值完全相同的方法，被称为重写/覆写（override）

- 抽象类可以引用具体的子类的实例，上层代码只定义规范，具体的业务逻辑由不同的子类实现，调用者并不关心如何实现

- interface是一种特殊的抽象类，成员变量默认public static final修饰，能且只能这么修饰，实际上不建议在接口里面定义变量，因为接口就是用来定义接口的，在里面加属性没有意义，且加了静态的属性就属于公共属性了，方法默认public abstract修饰，一个类不能继承多个类，但是可以实现多个接口

#### 异常处理
- exception的类型需要自己确定
- 存在多个`catch`的时候，`catch`的顺序非常重要：子类必须写在前面

#### 数组
`type[] name = new type[number]`数组是引用类型，new一个数组等于new一个对象
数组的元素相当于是类的成员变量，在为数组分配空间后，数组元素按照成员变量的初始化规则被隐式初始化 0 or false or null
a.length 数组的长度

- **动态初始化：** 即数组定义和分配空间以及赋值分开操作
```java
int[] a;  //定义
a = new int[3];  //分配空间
a[0] = 1;  //赋值
...
```
- **静态初始化：** 即数组定义和分配空间以及赋值同时操作
```java
int[] a = {1, 2, 3};
Date days[] = {new Date(1, 2, 3),...,...};  //Date为自定义的类
```

#### String
- 常用方法
- StringBuffer 代表可变的字符序列，String是不可变的，是final的，想要s1 + s2，String需要一个新的String对象接受s1、s2的字符串，StringBuffer直接加上

#### File
- 位于java.io.File，代表系统文件名（路径和文件名）
- 与class一样，属于一种类

#### 容器
- 位于java.util包
- Colections类提供了一些静态方法实现了基于List容器的基本的算法，sort(List)排序，binarySearch(List,Object)二分查找,在java.lang.Comparable接口中提供了compareTo(T,o)用于比较大小，想要比较大小的两个对象，他们的类得重写这个方法

#### 泛型
- 定义几何的同时定义定义几何中的对象的类型

#### 6 反射
反射是在运行时动态访问类和对象的技术，让程序更加灵活，对象的实例化往往是在源码中写死的，即编译时就确定了调用什么对象，而反射则可以动态的在运行时动态指定要加载的类
##### 6.1 反射的核心类

反射核心类有四个，正好构建出一个类的完整结构，创建对象，执行方法，访问成员变量这些操作

1. Class类

   Class是JVM中代表“类和接口”的类，而实例化的Class对象包含了某个特定的类的结构信息，通过Class对象可以获取到特定类的构造方法、方法、成员变量

   ![](https://cdn.jsdelivr.net/gh/ixcw/note/images/language/java/Class核心方法.png)

2. Constructor构造方法类

   Constructor类是对Java类中的构造方法的抽象，Constructor对象包含了具体类的某个具体构造方法的声明，通过Constructor对象调用带参构造方法创建对象

   ```java
   Class employeeClass = Class.forName("com.imooc.reflect.entity.Employee");  // 获取Class对象
   Constructor constructor = employeeClass.getConstructor(new Class[] {  // 获取Constructor对象，指定参数类型
     Integer.class, String.class, Float.class, String.class
   });
   Employee employee = (Employee) constructor.newInstance(new Object[] {  // 创建对象
     100, "李磊", 3000f, "研发部"
   });
   ```

3. Method方法类

   Method对象指代某个类中方法的描述，比如返回值，参数类型个数等

   ```java
   // 调用指定方法，说明方法参数，方便重载，返回Method对象
   Method updateSalaryMethod = employeeClass.getMethod("updateSalary", new Class[] {
     Float.class
   });
   // 调用方法，返回Employee对象
   Employee employee1 = (Employee) updateSalaryMethod.invoke(employee, new Object[] {1000f});
   ```

4. Field成员变量类

   Field对应某个具体类中的成员变量的声明，通过Field对象可以为某对象中的成员变量赋值/取值

   ```java
   Field enameField = employeeClass.getField("ename");  // 通过Class对象拿到Field对象
   String ename = (String) enameField.get(employee);  // 拿到ename成员变量的值
   enameField.set(employee, "李雷");  // 设置ename成员变量的值
   ```

>上面的方法都是获取的公有的构造方法、方法和成员变量，如果想访问私有的可以使用getDeclared系列方法：
```java
// s表示可以获取所有的多个方法或者变量
getDeclaredConstructor(s)|Method(s)|Field(s)
```

#### 7 Lambda表达式
Lammbda表达式只能实现有且仅有一个抽象方法的接口，这种接口称为函数式接口，Lambda表达式就代表了接口的实现，无需再去实现接口，不用定义匿名类。基于函数式接口并使用Lambda表达式的编程方式称为函数式编程，函数式编程的理念是将代码作为可重用数据代入到程序运行中

##### 7.1 语法
- 参数类型可以省略（抽象方法已经定义过），参数只有一个的时候小括号可以省略
- 执行语句只有一句时，大括号和return关键字、分号都可以省略


##### 7.2 使用
1. 定义函数式接口：
```java
public interface MathOperation {
  public Float operate(Integer a, Integer b);
}
```
2. 使用Lambda表达式：
```java
// 完整写法
MathOperation addition = (Integer a, Integer b) -> {
  System.out.println("加法");
  return a + b + 0f;
}
System.out.println(addtion.operate(5, 3));

// 简写
MathOperation addition = (a, b) -> a + b + 0f;
System.out.println(addtion.operate(5, 3));

// 假设只有一个参数a
MathOperation addition = a -> a + 0f;
System.out.println(addtion.operate(5));
```

##### 7.3 函数式编程
Java中自带大量函数式接口，比如java.lang.Runnable，jdk8以后在java.util.function包中提供了一系列的函数式接口，常用的三个是：
- Predicate<T>，条件判断，固定返回布尔值，用于测试传入数据是否满足判断要求
  ```java
  Predicate<Integer> predicate = n -> n > 4;
  boolean result = predicate.test(10);
  System.out.println(result);  // true
  ```
  下面体会函数式编程的优点：
  ```java
  // 定义函数
  public static void filter(List<Integer> list, Predicate<Integer> predicate) {
    for(Integer num : list) {
      if(predicate.test(num)) {
        System.out.println(num + " ");
      }
    }
  }
  
  // 调用
  List<Integer> list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  filter(list, n -> n%2 == 1);  // 筛选出所有奇数
  filter(list, n -> n%2 == 0);  // 筛选出所有偶数
  ```
  通过传入函数式接口作为参数，在调用时将代码作为可重用数据即参数代入到程序运行中，这样就能更加灵活调用

- Consumer<T>，有一个输入参数，无输出的功能代码

  ```java
  // 定义函数
  public static void output(Consumer<String> consumer) {
    String text = "Easy choice, Hard life, Hard choice, easy life.";
    consumer.accept(text);
  }
  
  // 调用
  output(s -> System.out.println("向控制台打印：" + s));  //具体的代码实现
  ```

- Function<T,R>，有一个输入参数，需要返回数据的功能代码

  利用Function函数式接口生成定长随机字符串：

  ```java
  public class FunctionSample {
    public static void main(String[] args) {
      Function<Integer, String> randomStringFunction = l -> {
        String chars = "abcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder stringBuilder = new StringBuilder();
        Random random = new Random();
        for (int i = 0; i < l; i++) {
          int index = random.nextInt(chars.length());
          stringBuilder.append(chars.charAt(index));
        }
        return stringBuilder.toString();
      };
  
      String randomString = randomStringFunction.apply(16);
      System.out.println(randomString);
    }
  }
  ```

>可以为函数式接口添加注解 @FunctionalInterface ，编译器将会对接口进行检查，是否符合函数式接口的规范



#### IO
- 以程序为主体的IO
- 处理数据不同分为：字节流（inputStream outputStream） 字符流（Reader Writer）
- 功能不同分为：节点流 处理流

#### 线程

#### 1 JDBC

##### 1.1 定义

Java为数据库定义了一套访问接口：JDBC（Java Database Connectivity），具体的实现由各大数据库厂商来实现，提供数据库驱动jar包。我们可以使用这套接口（JDBC）编程，真正执行的代码是**驱动jar包**中的**实现类**

##### 1.2 使用

要使用JDBC接口，需要把对应数据库的实现类导入项目，也就是导入驱动jar包

- 手动下载驱动jar包，然后放入项目下的自建libs目录下，然后作为库添加到项目里面（右键libs-->add as library）

- 或者可以使用maven直接添加依赖，maven会自动完成下载配置

```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.47</version>
    <scope>runtime</scope>
</dependency>

```


使用Java对数据库进行操作时，必须使用PreparedStatement，严禁任何通过参数拼字符串的代码

##### 1.4 连接池

在执行JDBC的增删改查的操作时，如果每一次操作都来一次打开连接，操作，关闭连接，那么创建和销毁JDBC连接的开销就太大了。为了避免频繁地创建和销毁JDBC连接，我们可以通过连接池（Connection Pool）复用已经创建好的连接。

JDBC连接池有一个标准的接口`javax.sql.DataSource`，注意这个类位于Java标准库中，但仅仅是接口。要使用JDBC连接池，我们必须选择一个JDBC连接池的实现。常用的JDBC连接池有：C3P0，Druid



目前使用最广泛的是HikariCP。我们以HikariCP为例，要使用JDBC连接池，先添加HikariCP的依赖如下

```xml
<dependency>
    <groupId>com.zaxxer</groupId>
    <artifactId>HikariCP</artifactId>
    <version>2.7.1</version>
</dependency>
```

紧接着，我们需要创建一个`DataSource`实例，这个实例就是连接池

```java
HikariConfig config = new HikariConfig();
config.setJdbcUrl("jdbc:mysql://localhost:3306/test");
config.setUsername("root");
config.setPassword("password");
config.addDataSourceProperty("connectionTimeout", "1000"); // 连接超时：1秒
config.addDataSourceProperty("idleTimeout", "60000"); // 空闲超时：60秒
config.addDataSourceProperty("maximumPoolSize", "10"); // 最大连接数：10
DataSource ds = new HikariDataSource(config);
```

注意创建`DataSource`也是一个非常昂贵的操作，所以通常`DataSource`实例总是作为一个全局变量存储，并贯穿整个应用程序的生命周期

获取`Connection`时，把`DriverManage.getConnection()`改为`ds.getConnection()`

```java
try (Connection conn = ds.getConnection()) { // 在此获取连接
    ...
} // 在此“关闭”连接
```

通过连接池获取连接时，并不需要指定JDBC的相关URL、用户名、口令等信息，因为这些信息已经存储在连接池内部了（创建`HikariDataSource`时传入的`HikariConfig`持有这些信息）。一开始，连接池内部并没有连接，所以，第一次调用`ds.getConnection()`，会迫使连接池内部先创建一个`Connection`，再返回给客户端使用。当我们调用`conn.close()`方法时（`在try(resource){...}`结束处），不是真正“关闭”连接，而是释放到连接池中，以便下次获取连接时能直接返回。

因此，连接池内部维护了若干个`Connection`实例，如果调用`ds.getConnection()`，就选择一个空闲连接，并标记它为“正在使用”然后返回，如果对`Connection`调用`close()`，那么就把连接再次标记为“空闲”从而等待下次调用。这样一来，我们就通过连接池维护了少量连接，但可以频繁地执行大量的SQL语句

很多地方都有这种设计思想，中间人、缓存、代理，化腐朽为神奇

#### 2 web

JavaEE最核心的组件就是基于Servlet标准的Web服务器

##### 2.1 servlet

编写HTTP服务器其实是非常简单的，只需要先编写基于多线程的TCP服务，然后在一个TCP连接中读取HTTP请求，发送HTTP响应即可。但是，要编写一个完善的HTTP服务器需要考虑很多事情，这些基础工作需要耗费大量的时间，并且经过长期测试才能稳定运行。如果我们只需要输出一个简单的HTML页面，就不得不编写上千行底层代码，那就根本无法做到高效而可靠地开发

在JavaEE平台上，处理TCP连接，解析HTTP协议这些底层工作统统扔给现成的Web服务器去做，我们只需要把自己的应用程序跑在Web服务器上。为了实现这一目的，JavaEE提供了Servlet API，我们使用Servlet API编写自己的Servlet来处理HTTP请求，Web服务器实现Servlet API接口，实现底层功能

```java
// WebServlet注解表示这是一个Servlet，并映射到地址/:
@WebServlet(urlPatterns = "/")
public class HelloServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 设置响应类型:
        resp.setContentType("text/html");
        // 获取输出流:
        PrintWriter pw = resp.getWriter();
        // 写入响应:
        pw.write("<h1>Hello, world!</h1>");
        // 最后不要忘记flush强制输出:
        pw.flush();
    }
}
```

servlet同样可以用maven引入

```xml
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>4.0.0</version>
    <scope>provided</scope>
</dependency>
```

##### 2.2 服务器

普通的Java程序是通过启动JVM，然后执行`main()`方法开始运行。但是Web应用程序有所不同，我们无法直接运行`war`文件，必须先启动Web服务器，再由Web服务器加载我们编写的`HelloServlet`，这样就可以让`HelloServlet`处理浏览器发送的请求

因此，我们首先要找一个支持Servlet API的Web服务器。常用的服务器有

- [Tomcat](https://tomcat.apache.org/)：由Apache开发的开源免费服务器
- [Jetty](https://www.eclipse.org/jetty/)：由Eclipse开发的开源免费服务器
- [GlassFish](https://javaee.github.io/glassfish/)：一个开源的全功能JavaEE服务器

无论使用哪个服务器，只要它支持Servlet API 4.0（因为我们引入的Servlet版本是4.0），我们的war包都可以在上面运行，要运行我们的hello.war，首先要下载Tomcat服务器，解压后，把hello.war复制到Tomcat的webapps目录下，然后切换到bin目录，执行startup.sh或startup.bat启动Tomcat服务器

因为我们编写的Servlet并不是直接运行，而是由Web服务器加载后创建实例运行，所以类似Tomcat这样的Web服务器也称为Servlet容器