#### 0 环境配置

1. 右击我的电脑依次点击`属性\高级系统设置\环境变量\系统变量`

2. 新建如下变量：

   变量名|变量值|说明
   -|-|-
   JAVA_HOME|`C:\Software\Java\jdk1.7.0_79`|jdk 的安装目录，目的是为了配置其他变量路径时用 `%%` 引用，故此变量也可不设
   classpath|`.;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar`|`.` 代表当前路径，`dt.jar` 是关于运行环境的类库，`tools.jar` 是关于工具的类库
   Path|`%JAVA_HOME%\bin`|指明了系统能在任何路径下识别 java 命令

3. 测试：按下 win+r 输入 cmd 回车，依次输入 java、javac，显示帮助文档

4. 使用 cmd 编译 java 源文件：
   - 新建 java 源文件：HelloWorld.java
   
   - 打开 cmd 切换工作目录到 java 源文件目录
   
   - 输入命令：

     ```sh
     javac HelloWorld.java  # 编译 java 源文件成 class 字节码文件
     java HelloWorld   # 执行 class 字节码文件，边解释边执行，注意执行时不用跟 .class 后缀
     ```

>JDK(java development kit)  >  JRE(java runtime environment)  >  JVM(java virtual machine)

#### 1 基础语法

**标识符**：也就是变量或者类的名字，由字母、数字、下划线、$ 符号组成，不能以数字开头，不能是 java 关键字或 java 保留字，区分大小写，取名最好能见名知意

**变量**：是数据的临时存储场所，变量名应符合标识符，以及驼峰命名法，即第一个单词首字母小写，后面的单词首字母都是大写，类名应符合标识符，以及Pascal命名，即所有的单词首字母都是大写

**数据类型**：java中的数据类型分为 **基础数据类型** 和 **引用数据类型**

> 一个 Java 源码文件只能定义一个 `public` 类型的 class，并且 class 的名称和文件名要完全一致

##### 1.1 基础数据类型

基础数据类型共有 8 种，分别是 byte、short、int、long、float、double、boolean、char

| 数据类型 | 字节大小 |
| :------: | :------: |
|   byte   |    1     |
|  short   |    2     |
|   int    |    4     |
|   long   |    8     |
|  float   |    4     |
|  double  |    8     |
| boolean  |    1     |
|   char   |    2     |

数值型分为整型和浮点型，整型有 byte、short、int、long，long 型需在结尾加 l

整型的进制表示有十进制、八进制和十六进制

八进制以 0~7 表示，以 0 开头

十六进制以 0~9 及 a~f 表示，以 0x 开头

浮点型有 float、double，浮点型默认为 double，在结尾加 d 表示double，也可不加，但是 float 需要在结尾加 f

> 浮点数在计算机中无法精确表示，因此判断浮点数相等不能用`==`，正确的方法是利用差值小于某个临界值来判断，比如

```java
double x = 1 - 9.0/10;
Math.abs(x - 0.1) < 0.00001    //差的绝对值约为2.77...E-17
```

布尔型的值只能是 true 或 false，不能是其他值或数字

字符型以单引号括起来的单个字符表示，直接赋值数字（ASCII数字），或者一串字符（Unicode编码）

数据类型进行转换时，小范围到大范围的转换是自动转换（隐式转换），大范围到小范围则需要强制类型转换，可能会发生精度丢失

```java
double d = 123.23;
float f = (float)d;
```

**常量**：一旦定义后续不可修改的量值。普通变量定义时在前面加上 final 即变为常量，常量命名常用大写加下划线命名

```java
final int MAX_NUM = 6;
```

##### 1.2 运算符 & 流程控制

###### 1.2.1 运算符

运算符包含算术运算符、关系运算符

1. 算术运算符

   ```java
   + - * / % ++ -- += -= *= /= %=
   ```

   >分子分母均为整数时，/ 除法获得的结果也是整数，比如 11 / 5  的值是 2
   >
   >++ 和 -- 的注意事项同 JavaScript

2. 关系运算符

   关系运算符用于比较大小，返回值是布尔值

   ```java
   > < >= <= == !=
   ```

   直接比较字符，比较的是转换后的 ASCII 码值

   ```java
   'A' > 'B' // 结果为 false
   ```

   浮点数可以和整数比较，值相等就返回 true

   ```java
   float f = 5.0f;
   long l = 5;
   f == l  // 结果为 true
   ```

3. 逻辑运算符

   逻辑运算符两边的表达式的结果都是布尔值

   ```java
   && & || | !
   ```

   > && 和 & 的区别在于，&& 是短路与，只要前一个表达式的结果为 false，则直接返回 false，不进行后一个表达式的运算，& 则会全部都运算，|| 同理，前一个表达式的结果为 true，则直接返回 true
   >
   
4. 条件运算符（三元运算符）

   ```java
   int max = a > b ? a : b // 取更大的值
   ```

> 运算符的优先级不用特别记忆，一般单目运算符优先级比多目运算符优先级高，实际开发使用 `()` 包裹

###### 1.2.2 流程控制

流程控制主要有三类，顺序控制、分支控制、循环控制

1. 顺序控制

   顺序控制不用特别去控制，按照代码顺序执行，就是顺序控制

2. 分支控制

   主要有 if 条件判断和 switch 条件判断

   ```java
   if (a > b) System.out.println("a > b");
   if (a > b) {
       System.out.println("a > b");
   } else if (a < b) {
       System.out.println("a < b");
   }
   ```

   switch 的判断条件与 if 不同，switch 的判断条件是 **常量值**，而 if 的判断条件是 **布尔值**

   switch 通过判断传入的常量值与分支的常量值的比较结果，去选择执行特定的分支

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

   >在每个 case 语句中一般需要加上 break，否则会接着执行下一个 case 语句
   >
   >表达式的结果可以是 int 或者是可以自动转换为 int 的值，又或者为字符串，为字符串的时候比较的是字符串的内容

3. 循环控制

   循环控制主要有 for 循环和 while 循环两种，具体选用哪一种，主要是看 **循环次数** 是否是确定的

   当循环次数已知时，常用 for 循环，在 java 中，数组的大小是固定的，因此 for 循环经常被用来遍历数组

   当循环次数未知时，常用 while 循环，如果需要至少执行一次的循环时则用 do while 循环

   ```java
   int n = 1;
   while(n < 5) {
       xxx; // 执行代码
       n++;
   }
   
   int n = 1;
   do {
       xxx; // 执行代码
       n++;
   } while(n < 5)
       
       
   // 循环次数确定为 5 次
   // 1. 初始化 i （只执行一次）
   // 2. 判断 n 是否小于等于 5
   // 3. 执行代码
   // 4. n++
   // 5. 重复 2 ~ 4 步，直至 n 不再满足条件
   for(int i = 1; n <= 5; n++) {
       xxx; // 执行代码
   }
   ```

   使用 break 可以结束整个循环，在多重循环里面，break 只能跳出所在的那一重循环

   使用 continue 可以结束当前的这一次循环，但是整个循环不会结束，会继续执行下一次循环

##### 1.3 数组

数组是引用数据类型

数组的大小是固定的，因此在初始化数组时 **必须指定长度**（通过直接或间接的方式）

数组用于存储一组 **相同数据类型** 的数据

1. 数组的初始化：

   数组的声明和基本数据类型基本一样，不同的是数组需要加 `[]` 进行声明，以下两种方式都是可以的

   ```java
   int[] arr;
   int arr[];
   ```

   数组声明后可以给数组赋初始值

   ```java
   int[] arr;
   arr = {1, 2, 3};   // 赋值为 int 数组，数组元素为 1,2,3
   arr = new int[10];  // 赋值为 int 数组，数组长度为 10
   arr = new int[]{4, 5, 6};  // 赋值为 int 数组，数组元素为 4,5,6
   ```

   数组的声明和赋初始值可以同时进行

   ```java
   int[] arr1 = {1, 2, 3};
   int[] arr2 = new int[10];
   int[] arr3 = new int[]{4, 5, 6};
   ```

2. 索引和长度

   数组的索引从 0 开始，获取数组元素使用 `arr[0]` 这种形式

   数组长度即为数组元素个数，可通过 `arr.length` 数组属性直接获取

3. 遍历数组

   由于数组长度固定，所以非常适合使用 for 循环遍历，普通 for 循环就不演示了，可以看看增强 for 循环，如果只需要遍历数组中的元素而 **不需要关心其索引**，可以使用增强for循环

   ```java
   int[] arr = { 1, 4, 9, 16, 25 };
   for (int n: arr) {
       System.out.println(n);
   }
   ```

   >每次循环会先把数组元素赋值给变量n，然后再在循环体里面对n进行处理
   >增强for循环的循环顺序是被**严格保证**的，因为其底层实现其实就是for循环，只不过多了给变量n赋值这步操作
   >除数组外，增强for循环还能够遍历所有可迭代的数据类型，包括 List 和 Map 等
   >
   >除了普通的数组，还有多维数组，也就是数组的元素也是数组，可通过 `arr[0][0]` 这种形式访问二维数组的元素

##### 1.4 方法

方法可以理解为 js 中的函数，用于封装特定的功能，同 js 一样，java 中的方法的参数传递也是值传递的，也就是说传递的是实参值的拷贝，形参接收实参的赋值，在方法中改变传入的值并不会影响实参的值，因为修改的只是实参的拷贝值，如果实参是引用类型，依然是值传递，只不过传递的是引用的拷贝，引用可理解为地址，但具体实现和别的语言不一样，在方法中对形参进行操作会影响到实参的内容，因为此时形参和实参指向同一个引用

>注意：字符串也是引用类型，但是传递字符串时会有传递基础类型的错觉，也就是修改形参不会影响实参，这是因为 java 中的字符串是不可变的，查看 java 源码可发现 String 是 final 不可变的常量，这样在修改字符串时，实际上相当于new 了一个新的字符串并将其引用赋值给了形参，这样形参的值就是新字符串的引用，而实参还是原来字符串的引用，于是造成了修改失败的现象，所以判断是否会影响实参，主要看对形参的操作是 **修改了引用还是修改了内容**（引用所指向的对象内容）

java 中的方法需要声明访问修饰符和返回值，无返回值时，也需要声明返回值为 void

```java
public void printNum(int num) {
    System.out.println(num);
}
```

**方法重载**：名称相同的方法可以重载，满足方法同名的前提下，形参的类型或个数以及顺序不同，都会构成方法的重载

#### 2 面向对象

##### 2.1 基础概念

在 java 中最重要的一个特征就是面向对象，而面向对象离不开类和对象的概念

**类：**从一类对象中抽象出来的共性或模板，是某一类事物，比如狗、人 、电脑

**对象：**可理解为某一个具体的事物或物体，比如一条名叫旺财的狗、一个名字叫张三的人、一台华硕的电脑

类具有属性和方法，就像人拥有高矮胖瘦等特征（属性），还有走路吃饭等行为（方法），具体需要定义哪些属性和方法则根据具体的需求而定，属性和方法千千万万，不可能将所有的属性方法都定义出来，根据需要进行定义即可

比如我们定义出一个 Person 类：

```java
public class Person {
    String name;
    double height;
    double weight;

    public void eat() {
        System.out.println("吃饭");
    }

    public void walk() {
        System.out.println("走路");
    }

    public void walk(String name) {
        System.out.println(name + "走路");
    }
}
```

然后使用 Person 类实例化出一个具体的名为 jack 的对象，然后使用其中的方法，或给其创建具体的属性

```java
public class StudyTest {
    public static void main(String[] args) {
        Person jack = new Person();
        jack.name = "jack";
        jack.height = 180;
        jack.weight = 60;
        jack.walk();
        jack.walk(jack.name);
    }
}
```

> **单一职责原则：**在设计类或方法时，尽量只设计一个功能，避免功能耦合

实例化对象会经历两个阶段：

1. 声明对象时在 **栈内存** 中开辟了一块空间用于存储声明

2. 实例化对象时时会在 **堆内存** 中开辟一块空间用于存储对象本身，最后将声明指向创建的对象本身

   ```java
   Person jack  // 声明对象，名为jack
   new Person()  // 实例化对象
   Person jack = new Person();  // 将声明指向实例化的对象
   ```

在类中，有一个方法与类 **同名**，无返回值，这个方法叫做构造方法

在用类去实例化对象时，会自动调用这个构造方法，如果没有显式地去编写构造方法，则会默认存在一个默认的无参的构造方法，若显式地编写了构造方法，则默认的构造方法将会被新编写的构造方法所覆盖

构造方法的作用是什么呢？一般是用来执行一些初始化操作，比如给对象的属性赋初始值

```java
public class Person {
    String name;
    double height;
    double weight;

    public Person(String name, double height, double weight) {
        this.name = name;  // // this表示当前对象，也就是通过类实例化出来的那个对象
        this.height = height;
        this.weight = weight;
    }

    public void eat() {
        System.out.println("吃饭");
    }

    public void walk() {
        System.out.println("走路");
    }

    public void walk(String name) {
        System.out.println(name + "走路");
    }
}
```

##### 2.2 封装

###### 2.2.1 概念

和现实世界中一样，在设计类时，有些属性和方法是可以暴露给外界的，而有些属性和方法则应该对外界隐藏，具体视情况而定，隐藏的过程就是封装的过程

对于想要隐藏的属性，可以给其添加 private 修饰符使其转变为私有变量，然后提供 public 修饰符修饰的共有 getter 和 setter 方法进行访问和修改

Java 中存在一种类，类的所有成员变量都是私有的，所有的成员变量都提供共有的 getter 和 setter，此外，还有一个无参的公共构造函数，构造函数一般默认的就行，这样的类叫做实体类（Java Bean）

实体类可用于对象数据的存取，而且也只应该负责数据的存取，实体类在开发中通常用于映射数据库中的表

###### 2.2.2 static

Java 中的变量分为 3 类

1. 局部变量：定义在方法或者 if for 等语句块中的变量，存储于栈区，随着方法或语句块一起生成或消失

2. 成员变量（实例变量）：定义在类的内部，类方法的外部，存储于堆区，随着对象一起生成或消失

3. 静态变量（类变量）：用 static 修饰的成员变量，随着类一起装载或卸载

静态变量可以直接通过 `类名.静态变量名` 的方式去访问，因为这些静态变量是属于类的，当然也可以通过 `对象名.静态变量名` 的方式去访问，但不推荐

类的所有生成的对象共享该类的静态变量，在类的成员方法中可以调用类的静态成员变量

> 如果成员方法是静态的，那么就只能调用静态成员变量，因为普通的成员变量只有在生成对象时才会初始化，因此静态方法只能调用静态成员变量，同理，静态方法中也无法使用 this 关键字

那什么情况下需要定义静态变量呢，当某些数据是公共的，被所有对象所共享的，就可以定义静态变量

比如记录创建了多少个学生，就可以在学生类里定义静态的 count 变量，然后在构造函数中执行 +1 的操作，这样每次创建学生对象，学生类的静态变量 count 就会 +1，通过学生类就能直接访问到这个静态变量，获知创建的学生个数

成员方法也可以使用 static 修饰成为静态方法，同静态变量一样，通过直接通过 `类名.静态方法` 的方式访问，同样也可以通过 `对象名.静态方法名` 的方式去访问，但不推荐

应用场景通常在定义工具类的时候，会使用静态方法，直接通过类名去调用静态方法，而不用实例化对象去使用，工具类通常还会将构造函数私有化，从而达到不允许创建对象的目的

###### 2.2.3 代码块

代码块分为静态代码块和代码块，定义在类中，静态代码块属于类，代码块属于对象，都是在类或对象初始化的时候执行一次，通常用于初始化一些成员变量

```java
public class Student {
    static {}  // 静态代码块
    {}  // 代码块
}
```

##### 2.3 继承

在生活中有继承，比如父亲和儿子，儿子继承父亲的一些特质、资产等等

程序开发中也有继承，在实际的程序开发中，我们发现不同的类，实际上封装的属性和方法，其实存在大量相同的地方，比如封装的狗类和猫类，它们都是名字、体重、吃饭等属性和方法，这就导致了重复定义，产生大量重复代码，在类作为模板的基础上，其实还能进行更高一层的模板封装，将这些类的共同点再进行一次抽取，封装出公共的类，比如猫和狗都是动物，可以再封装一个动物类，将猫狗类的共同点抽取出来封装，再由猫狗类去继承动物类，这样就能减少大量冗余代码，同时也增加了后期代码的可维护性

可以通过 `extends` 去继承父类，将会继承父类的属性和方法

```java
class Dog extends Animal { ... }
```

子类可以重写从父类继承过来的方法，将父类中的继承过来的方法变成自己的方法

前面我们看到，类中的成员变量和方法都会带有访问修饰符，类似于 `public` 这样的关键字，其作用如其名，是用于对成员变量进行访问控制的

- public：共有

  公有成员变量允许在本类和子类以及同个包下的类访问，不同包下也能访问

- private：私有

  私有成员变量只允许在本类中进行访问，别的地方是无法访问的

  ```java
  class MyClass {
      private int privateVar = 10; // 只能在MyClass内访问
  }
  
  class AnotherClass {
      void method() {
          MyClass obj = new MyClass();
          // System.out.println(obj.privateVar); // 编译错误，不可访问
      }
  }
  ```

- protected：受保护

  受保护成员变量允许在本类和子类以及同个包下的类访问，不同的包只有子类可以访问

##### 2.4 多态

###### 2.4.1 概念

生活中的多态是随处可见的，比如同样是动物的叫声，狗的叫声和猫的叫声是不一样的，这就是同一种方法在不同的对象上的不同表现

java 中的多态分为编译时多态和运行时多态，编译时多态在编译阶段就能知道，比如方法重载，而运行时多态则需要运行时确定，java 的大多数多态属于运行时多态

运行时多态要满足继承条件，**父类引用指向子类的对象**

```java
Animal one = new Animal()
Animal two = new Dog()
Animal three = new Cat()
one.eat()
two.eat()
three.eat()
```

如果狗类和猫类重写了动物类的吃方法，则打印将会是不同的结果，这种表现叫做 **向上转型**

这种方式定义的对象，无法调用子类特有的方法，只能调用父类拥有的和子类重写父类的方法

###### 2.4.2 接口

到目前为止，java 只有单继承，如何解决一个类型需要兼容多个特征的问题呢

#### 3 字符串

字符串的创建

```java
String s1 = "s1";
String s2 = new String();  // 空字符串
String s3 = new String("s3");
```

字符串方法

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

> 推荐 字符串常量.equals（字符串对象引用） 的方式比较字符串内容，因为一旦字符串对象引用为 null，那么将会报错，null不能使用equals方法

#### 4 集合

集合和数组类似，不同的是，集合的长度是可变的，而且可以存储不同数据类型的数据，更为灵活

常用的是 ArrayList 集合，类似于数组

```java
ArrayList list = new ArrayList();
list.add(100);
list.add("苹果");
list.add("苹果");
list.add(0, 200);
list.get(1);
list.remove(1);  // 返回值为被删除的因素
list.remove("苹果");  // 默认只会删除第一个匹配的元素，返回值为布尔值
list.set(1, "李子");  // 返回值为修改前的元素
list.size();  // 返回元素个数
```



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

#### 0 xml

xml 是 Extensible Markup Language 的缩写，可拓展的标记语言，起初用于数据传输，通过标签来标识数据

```xml
<employee>
    <name>jack</name>
    <age>18</age>
    <height>178</height>
</employee>
```

在如今的 java 开发中，xml 文件更多是用于描述项目配置，作为配置文件而存在，比如配置IP地址，配置发生变更需要修改的时候，只需要修改 xml 配置文件，而不需要修改 java 源代码，提高了可维护性

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