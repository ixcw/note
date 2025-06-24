#### 1 SpringMVC简介

首先什么是MVC，MVC是一种架构设计，分为三层，分别是Model、View、Controller，View就是通常我们所见的前台页面、表单，Model就是后台业务逻辑部分，包括Dao、Service，Controller就是控制器，作为中介连接前台页面和后台业务逻辑，传送前台请求数据给后台，拿到后台业务逻辑处理数据的结果，返回给前台，J2EE的Servlet可以开发控制器，但是与JDBC一样使用起来并不方便，Spring提供了SpringMVC来帮助我们更简单的开发控制器，SpringMVC是轻量级的Web开发框架，学习简单，它的核心就是开发控制器用于处理请求产生响应，好处就是让前台页面与后台逻辑解耦，提高了程序的可维护性，SpringMVC基于Spring运行，对象由IoC容器管理

#### 2 SpringMVC环境配置

1. 创建普通maven工程，找到项目结构，添加facets，选择web，修改发布描述器`web.xml`的位置为`项目目录\src\main\webapp\WEB-INF\web.xml`

2. 接着修改web资源存放目录，改为`项目目录\src\main\webapp\`

3. 这时idea会提醒web facets resources not included in any artifacts，创建artifact即可，idea会根据前面你的配置自动生成artifact，artifact的类型默认选择exploded就好，项目会以目录的方式运行，如果改选archive，项目将会被打成war包运行

4. 在webapp目录下新建一个默认首页index.html文件，在运行选项旁点击添加配置，选择tomcat server => local，配置VM option的更新操作，改为更新类和资源，就可以热部署了，把端口从8080改为默认访问端口80，这里会提醒No artifacts marked for deployment，选择deployment，添加前面配置的artifact即可，应用上下文配置访问路径，如果改为`/`，加上前面创建的默认访问首页index.html，则直接访问`http://localhost/`就可以访问首页了，至此，项目基本结构搭建完毕

5. 在pom里面引入spring-webmvc依赖，配置web.xml文件，配置DispatcherServlet，拦截所有请求，类似于公司前台小姐姐（不是）

   ```xml
   <!--DispatcherServlet是SpringMVC中最重要的核心类，用于拦截http请求-->
   <!--根据http请求的url调用与之对应的Controller方法，完成对http请求的处理-->
   <servlet>
     <servlet-name>springmvc</servlet-name>
     <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
     <!--告知IoC的配置文件在哪里-->
     <init-param>
       <param-name>contextConfigLocation</param-name>
       <param-value>classpath:applicationContext.xml</param-value>
     </init-param>
     <!--表示在web应用启动时自动创建IoC容器（因为SpringMVC的所有对象都依赖于IoC容器），并初始化DispatcherServlet-->
     <!--如果不配置，那么这里的工作将会在第一次访问url的时候创建，程序响应速度更慢-->
     <!--这里的数值>=0时生效，数值越小，加载优先级越高-->
     <load-on-startup>0</load-on-startup>
   </servlet>
   <servlet-mapping>
     <servlet-name>springmvc</servlet-name>
     <!--/表示拦截所有请求-->
     <url-pattern>/</url-pattern>
   </servlet-mapping>
   ```

6. 配置Ioc，开启注解扫描

   ```xml
   <!--在IoC初始化过程中，自动创建并管理com.heeh.springmvc包下的注解类-->
   <!--@Component @Repository @Service @Controller-->
   <context:component-scan base-package="com.heeh.springmvc"/>
   <!--启用SpringMVC的注解开发模式-->
   <mvc:annotation-driven/>
   <!--作用是将静态资源如图片、JS、CSS等排除在外，不进行拦截处理，提高执行效率-->
   <mvc:default-servlet-handler/>
   ```

7. 编写控制器测试类

   ```java
   package com.heeh.springmvc.controller;
   
   import org.springframework.stereotype.Controller;
   import org.springframework.web.bind.annotation.GetMapping;
   import org.springframework.web.bind.annotation.ResponseBody;
   
   @Controller
   public class TestController {
       /**
        * 测试方法
        * GetMapping 用于将当前方法和get方式请求的url进行绑定
        * ResponseBody 直接向响应输出字符串数据，不跳转页面
        * 将controller的方法返回的对象通过适当的转换器转换为指定的格式之后
        * 写入到response对象的body区（响应体中）
        * 通常用来返回JSON数据
        * @return
        */
       @GetMapping("/t")
       @ResponseBody
       public String test() {
           return "SUCCESS";
       }
   }
   ```

8. 由于前面引入了spring-webmvc的依赖jar包，这里需要配置tomcat，选择发布的artifact，将新添加的jar包依赖放入到输出布局默认lib目录里面，这时就可以启动项目了，浏览器访问`http://localhost/t`，就能看见test方法返回的数据了，修改test方法里的数据，点击debug按钮，选择更新类和资源，tomcat就会进行热部署，浏览器刷新页面就能看见改变的数据了

可以看到，用SpringMVC开发的时候，只需要编写标准的方法，写好注解，不用像Servlet那样引入请求响应对象，就可以处理请求和返回结果

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/springmvc/SpringMVC处理示意图.png)

#### 3 URL Mapping

URL映射的主要作用就是将url和Controller方法进行绑定，通过这种方式SpringMVC就可以通过Tomcat对外暴露服务接口，主要有三个注解：

- @RequestMapping

  用于通用的请求绑定

- @GetMapping

  用于Get的请求绑定

- @PostMapping

  用于Post的请求绑定

编写测试类

```java
package com.heeh.springmvc.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class URLMappingController {
    @GetMapping("/g")
    @ResponseBody
    public String getMapping() {
        return "This is a get method";
    }
    @PostMapping("/p")
    @ResponseBody
    public String postMapping() {
        return "This is a post method";
    }
}

```

然后浏览器分别访问`http://localhost/g`和`http://localhost/p`，结果是This is a get method和405状态码，消息是Request method 'GET' not supported，因为这里的方法定义的是post请求，而浏览器地址栏直接发送的请求是get请求

编辑index.html文件，发送post请求就可以访问方法了

```html
<form action="/p" method="post">
  <input type="submit" value="提交">
</form>
```
@RequestMapping默认不区分访问方式，通常用来定义整个类的访问前缀，类里面的方法在指定具体的访问方式和路径后，需要和访问前缀一起拼接访问的完整路径，比如

```java
@Controller
@RequestMapping("/um")
public class URLMappingController {
    @GetMapping("/g")
    @ResponseBody
    public String getMapping() {
        return "This is a get method";
    }
    @PostMapping("/p")
    @ResponseBody
    public String postMapping() {
        return "This is a post method";
    }
}
```

这样访问getMapping方法的路径就是`http://localhost/um/g`，当然这个注解也可以用到方法上，如果想要指定访问方式，可以如下设置

```java
@RequestMapping(value = "/g", method = RequestMethod.GET)
```

显然不如另两个注解方便

#### 4 接收请求参数

##### 4.1 Controller方法

post方法直接在方法上填好参数就可以接收请求参数了，注意参数名字和前台的input的name属性名**一致**，mvc可以将填写的数据自动转换为数字类型

HTML：

```html
<form action="/um/p" method="post">
  <input name="username"><br/>
  <input name="password"><br/>
  <input type="submit" value="提交">
</form>
```

Java：

```java
@PostMapping("/p")
@ResponseBody
public String postMapping(String username, Long password) {
  System.out.println(username + ":" + password);
  return "This is a post method";
}
```

控制台结果：

```txt
lisi:123
```

但是注意数字自动转换仅限于输入了正确的数字，如果输入其他字符，比如abc，那么前台会收到状态码 400 – Bad Request，后台会报错

```txt
MethodArgumentTypeMismatchException: 
Failed to convert value of type 'java.lang.String' to required type 'java.lang.Long';
```

所以前台最好用js做好表单校验



get方法在前台发送请求参数方式一般是在访问路径后面直接填写，比如`http://localhost/um/g?manager_name=lily`，get方法接收参数的方法和post方法一样，都是填写方法参数



> 有时候，前台发送的参数名称不符合Java的命名规范，比如上面的manager_name，Java里面一般叫做managerName，那怎么办呢，MVC当然也为这个问题提供了解决方法，方法是在方法参数里面增加@RequestParam把不同名称的参数绑定起来，这样就不需要和前台参数命名一致了，可以按照驼峰命名命名变量了
>
> ```java
> @Controller
> @RequestMapping("/um")
> public class URLMappingController {
>   @GetMapping("/g")
>   @ResponseBody
>   public String getMapping(@RequestParam("manager_name") String managerName) {
>     System.out.println("managerName:" + managerName);
>     return "This is a get method";
>   }
> 
>   @PostMapping("/p")
>   @ResponseBody
>   public String postMapping(@RequestParam("username") String userName, 
>                             @RequestParam("password") Long passwd) {
>     System.out.println(userName + ":" + passwd);
>     return "This is a post method";
>   }
> }
> ```

##### 4.2 Java Bean

如果前台参数很多，那么一个个的参数填起来就会很多，也不容易查看，一般是直接用编写好的Java实体类接收参数

首先创建Java Bean，注意属性命名和前台参数保持一致

```java
package com.heeh.springmvc.entity;

public class User {
    private String username;
    private Long password;

    // getter and setter
}
```

然后直接在方法参数里面传入Java Bean即可

```java
@PostMapping("/p1")
@ResponseBody
public String postMapping1(User user) {
  System.out.println(user.getUsername() + ":" + user.getPassword());
  return "This is a post method";
}
```

Java Bean和参数混合接收也是可以的，只要命名和前台参数保持一致

```java
@PostMapping("/p1")
@ResponseBody
public String postMapping1(User user, String username) {
  System.out.println(username);
  System.out.println(user.getUsername() + ":" + user.getPassword());
  return "This is a post method";
}
```

#### 5 接收表单复合参数

1. 创建html文件

   ```html
   <div>
     <h2>学员调查问卷</h2>
     <form action="./apply" method="post">
       <h3>您的姓名</h3>
       <input name="name">
       <h3>您正在学习的技术</h3>
       <select name="course">
         <option value="java">Java</option>
         <option value="h5">HTML5</option>
         <option value="python">Python</option>
         <option value="php">PHP</option>
       </select>
       <div>
         <h3>您的学习目的</h3>
         <input type="checkbox" name="purpose" value="1">就业找工作
         <input type="checkbox" name="purpose" value="2">工作要求
         <input type="checkbox" name="purpose" value="3">兴趣爱好
         <input type="checkbox" name="purpose" value="4">其他
       </div>
       <div>
         <input type="submit" value="提交">
       </div>
     </form>
   </div>
   ```

   > 这里的action属性用的是`./apply`，这是URI相对地址，URL是URI的子集，URI分绝对地址和相对地址
   >
   > - 相对路径以`./`开头，表示是同一级目录，也可以不写，默认表示同一级目录，比如`js/index.js`
   >
   > - 绝对路径以`/`开头，必须增加项目路径，比如`/project/js/index.js`，如果项目上下文（项目访问路径）配置的是`/`，那么可以不写项目路径，就变成了`/js/index.js`
   >
   > 可以看到使用相对路径的好处就在于摆脱了对项目路径的依赖，更加方便灵活

2. 编写controller，用数组接收参数

   ```java
   @Controller
   public class FormController {
   
     @PostMapping("/apply")
     @ResponseBody
     public String apply(String name, String course, Integer[] purpose) {
       System.out.println(name + ":" + course);
       for (Integer p : purpose) {
         System.out.println(p);
       }
       return "SUCCESS";
     }
   }
   ```

   结果

   ```txt
   lisi:h5
   1
   3
   ```

   > 如果前台不传数据，或者数据不存在，那么方法接收不到参数可能会报空指针异常，解决办法是增加默认值
   >
   > ```java
   > @Controller
   > public class FormController {
   > 
   >  @PostMapping("/apply")
   >  @ResponseBody
   >  public String apply(@RequestParam(value = "n", defaultValue = "allen") String name,
   >                      String course, Integer[] purpose) {
   >      System.out.println(name + ":" + course);
   >      for (Integer p : purpose) {
   >          System.out.println(p);
   >      }
   >      return "SUCCESS";
   >  }
   > }
   > ```
   > 这里匹配名字改为了n，那么数据不存在，则结果是
   >
   > ```txt
   > allen:java
   > 1
   > ```
   >
   > 匹配名字改回name，如果正常传参则正常显示，如果不传参数则采用默认参数
   >
   >
   > ```java
   > @Controller
   > public class FormController {
   > 
   >  @PostMapping("/apply")
   >  @ResponseBody
   >  public String apply(@RequestParam(value = "name", defaultValue = "allen") String name,
   >                      String course, Integer[] purpose) {
   >      System.out.println(name + ":" + course);
   >      for (Integer p : purpose) {
   >          System.out.println(p);
   >      }
   >      return "SUCCESS";
   >  }
   > }
   > ```
   >
   > 结果
   >
   > ```txt
   > mikasa:java
   > 1
   > 
   > allen:java
   > 1
   > ```

   可以改为List接收参数，默认是使用的ArrayList，使用集合需要在参数前面加上@RequestParam注解

   ```java
   @PostMapping("/apply")
   @ResponseBody
   public String apply(String name, String course, @RequestParam List<Integer> purpose) {
     System.out.println(name + ":" + course);
     for (Integer p : purpose) {
       System.out.println(p);
     }
     return "SUCCESS";
   }
   ```

   结果

   ```txt
   allen:java
   1
   2
   3
   ```

   也可以将这些参数放到实体类中，编写实体类

   ```java
   public class Form {
     private String name;
     private String course;
     private List<Integer> purpose;
   
     // getter and setter
   }
   ```

   直接用实体类接收参数

   ```java
   @PostMapping("/apply")
   @ResponseBody
   public String apply(Form form) {
     System.out.println(form.getName() + ":" + form.getCourse());
     for (Integer p : form.getPurpose()) {
       System.out.println(p);
     }
     return "SUCCESS";
   }
   ```

   结果

   ```txt
   allen:java
   1
   2
   3
   ```

   > 有人喜欢用Map接收数据，当然没有问题，但是Map有一个缺陷，就是复合数据只会传第一个参数，后面的数据会丢失
   >
   > 比如
   >
   > ```java
   > @PostMapping("/apply")
   > @ResponseBody
   > public String apply(@RequestParam Map map) {
   >   System.out.println(map);
   >   return "SUCCESS";
   > }
   > ```
   >
   > 我们在第4行打上断点进行调试，前台勾选前三项数据提交，会发现
   >
   >  ![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/springmvc/map接收参数的缺陷.png)
   >
   > 复合参数只接收到了1，后面的2、3都丢失了，继续运行程序，结果是
   >
   > ```txt
   > {name=allen, course=java, purpose=1}
   > ```
   >
   > 所以复合数据最好用List来接收

#### 6 关联对象赋值

有时候，并不是只有一个对象就可以完成所有的表单数据的接收，从设计合理性来说，更有可能在一个表单数据中包含了多个对象的数据，对象之间是有关联的，比如用户注册时填写的个人信息，里面有身份证相关的信息，身份证被设计为了一个类，那么用户对象包含了身份证对象，如何对身份证对象赋值呢，再比如这里的表单假设再有一个活动抽奖，需要填写邮递地址，这里地址被设计成一个类，与表单类关联，又该如何赋值

首先在html中增加邮递地址的输入框

```html
<h2>学员调查问卷</h2>
<form action="./apply" method="post">
  <h3>您的姓名</h3>
  <input name="name">
  <h3>您正在学习的技术</h3>
  <select name="course">
    <option value="java">Java</option>
    <option value="h5">HTML5</option>
    <option value="python">Python</option>
    <option value="php">PHP</option>
  </select>
  <div>
    <h3>您的学习目的</h3>
    <input type="checkbox" name="purpose" value="1">就业找工作
    <input type="checkbox" name="purpose" value="2">工作要求
    <input type="checkbox" name="purpose" value="3">兴趣爱好
    <input type="checkbox" name="purpose" value="4">其他
  </div>
  <h3>收货人</h3>
  <input name="delivery.name">
  <h3>联系电话</h3>
  <input name="delivery.mobile">
  <h3>收货地址</h3>
  <input name="delivery.address">
  <div>
    <input type="submit" value="提交">
  </div>
</form>
```

然后定义邮递地址实体类

```java
public class Delivery {
    private String name;
    private String mobile;
    private String address;
  
    // getter and setter
}
```

接着在表单实体类中包含邮递实体类，这里需要实例化

```java
public class Form {
    private String name;
    private String course;
    private List<Integer> purpose;
    private Delivery delivery = new Delivery();
  
    // getter and setter
}
```

然后定义Controller方法，直接用表单实体对象接收

```java
@PostMapping("/apply")
@ResponseBody
public String applyDelivery(Form form) {
  System.out.println(form.getDelivery().getName());
  return "SUCCESS";
}
```

在第4行打上断点调试，可以看到form对象接收到了前台form传递过来的数据，关联对象delivery也获得了数据

 ![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/springmvc/关联对象赋值.png)

这里的关键就在于前台的数据名称，关联对象的数据名称需要加上前缀，这里是`delivery.`，然后MVC会自动给其赋值

#### 7 日期类型

1. 前台增加输入时间的标签

   ```html
   <h3>收货时间</h3>
   <input name="createTime">
   ```

2. 如果直接用String接收参数没有问题，但是如果用Date时间类型接收则会报400错误，因为字符串无法直接转化为时间，MVC也为这个问题提供了解决方案，一种方法是直接加上@DateTimeFormat注解，说明日期转换的模式，MVC就会按这种模式进行日期转换，输入不符合模式的数据，将会转换失败并报错

   ```java
   @PostMapping("/apply")
   @ResponseBody
   public String applyDelivery(Form form, @DateTimeFormat(pattern = "yyyy-MM-dd") Date createTime) {
     System.out.println(form.getDelivery().getName());
     System.out.println(createTime);
     return "SUCCESS";
   }
   ```

   结果

   ```txt
   allen
   Fri Mar 12 00:00:00 CST 1993
   ```
   如果实体类中包含时间类型的属性，那么将注解加到对应属性上即可

直接注解虽然简单，但是每一个需要日期转换的地方都要写一个注解吗，显然是不可能的，这时可以定义一个日期转换类，配置成全局日期处理器，这样需要日期处理的地方就会自动转换了，MVC对此提供了支持

1. 编写日期转换类

   ```java
   package com.heeh.springmvc.converter;
   
   import org.springframework.core.convert.converter.Converter;
   
   import java.text.ParseException;
   import java.text.SimpleDateFormat;
   import java.util.Date;
   
   public class DateConverter implements Converter<String, Date> {
       @Override
       public Date convert(String s) {
           SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
           try {
               Date d = sdf.parse(s);
               return d;
           } catch (ParseException e) {
               return null;
           }
       }
   }
   ```

2. 配置IoC配置文件

   ```xml
   <!--配置格式转换服务工厂Bean，指明自己编写的转换类是哪一个-->
   <bean id="conversionService" class="org.springframework.format.support.FormattingConversionServiceFactoryBean">
     <property name="converters">
       <set>
         <bean class="com.heeh.springmvc.converter.DateConverter"/>
       </set>
     </property>
   </bean>
   
   <!--启用SpringMVC的注解开发模式-->
   <mvc:annotation-driven conversion-service="conversionService"/>
   ```

3. 在之前编写的get方法上增加时间参数进行测试

   ```java
   @GetMapping("/g")
   @ResponseBody
   public String getMapping(@RequestParam("manager_name") String managerName, Date createTime) {
     System.out.println("managerName:" + managerName + ":" + createTime);
     return "This is a get method";
   }
   ```

   前台传递参数：`localhost/um/g?manager_name=lily&createTime=1998-03-16`，结果是

   ```txt
   managerName:lily:Mon Mar 16 00:00:00 CST 1998
   ```
>如果前台输入的模式不一致，比如有的人喜欢输入`19980316`，那岂不是会转换失败，这时可以在编写的转换类中通过if判断处理不同的情况即可

#### 8 中文乱码

中文乱码的根源是字符集的问题，Tomcat默认使用ISO-8859-1，属于西欧字符集，不支持中文，所以解决问题的关键在于将ISO-8859-1转换为UTF-8，在Controller中请求与响应都需要设置UTF-8

1. 找到Tomcat的安装目录，在conf目录下打开`server.xml`，找到8080端口的地方，添加属性`URIEncoding="UTF-8"`

   ```xml
   <Connector port="8080" protocol="HTTP/1.1"
                  connectionTimeout="20000"
                  redirectPort="8443" URIEncoding="UTF-8" />
   ```

   URIEncoding表示了网址部分的编码，在向Tomcat传递的时候会自动将编码转换为UTF-8，从而解决了get请求传递中文的问题

   > Tomcat 8.0之后的版本，URIEncoding默认就是UTF-8，所以8.0后的版本不用配置

2. 在`web.xml`中配置过滤器，拦截所有请求，解决post请求中文乱码的问题

   ```xml
   <filter>
     <filter-name>characterFilter</filter-name>
     <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
     <init-param>
       <param-name>encoding</param-name>
       <param-value>UTF-8</param-value>
     </init-param>
   </filter>
   <filter-mapping>
     <filter-name>characterFilter</filter-name>
     <url-pattern>/*</url-pattern>
   </filter-mapping>
   ```

3. 配置Spring配置文件，设置响应的字符集为UTF-8，解决响应的中文乱码问题

   ```xml
   <!--启用SpringMVC的注解开发模式-->
   <mvc:annotation-driven conversion-service="conversionService">
     <mvc:message-converters>
       <bean class="org.springframework.http.converter.StringHttpMessageConverter">
         <property name="supportedMediaTypes">
           <list>
             <!--底层也是调用response.setContextType("text/html;charset=utf-8")-->
             <value>text/html;charset=utf-8</value>
           </list>
         </property>
       </bean>
     </mvc:message-converters>
   </mvc:annotation-driven>
   ```

#### 9 响应输出结果

##### 9.1 ResponseBody

@ResponseBody直接产生响应体的数据，过程中不涉及任何视图，通常用于产生标准字符串/JSON/XML等格式数据，响应的数据会被配置的StringHttpMessageConverter影响

如果响应的数据有格式，会被浏览器解析，例如，浏览器会将这段文字解析为标题

```java
@PostMapping("/p1")
@ResponseBody
public String postMapping1(User user, String username) {
  System.out.println(username);
  System.out.println(user.getUsername() + ":" + user.getPassword());
  return "<h1>这是一个post方法<h1>";
}
```

但是一般更多的是返回JSON等格式的数据，帮助前端构建动态页面

##### 9.2 ModelAndView

ModelAndView，翻译为中文就是“模型（数据）与视图（界面）”对象，通过这个对象可**将包含数据对象与模板引擎进行绑定**，MVC默认的View是JSP，也可以配置其他模板引擎

1. 编写Controller方法，返回值为ModelAndView

   ```java
   @GetMapping("/view")
   public ModelAndView showView(Integer userId) {
     ModelAndView mav = new ModelAndView("/view.jsp");
     return mav;
   }
   ```
   
2. 在webapp目录下新建`view.jsp`文件

3. 访问`http://localhost/um/view`，就可以看见`view.jsp`的内容了

   > 也许此时你会问，那我直接访问`http://localhost/view.jsp`不就完事儿了吗，何必多次一举再写个方法，用上ModelAndView呢，问题就在于前面强调的内容，**将包含数据对象与模板引擎进行绑定**，之所以这样做就是为了数据的逻辑处理与页面动态展现，比如此时增加判断，根据用户id返回不同的名字，这样就可以将用户对象和JSP绑定起来了
   >
   > ```java
   > @GetMapping("/view")
   > public ModelAndView showView(Integer userId) {
   >   // 或者
   >   // ModelAndView mav = new ModelAndView();
   >   // mav.setViewName("/view.jsp");
   >   // 优点是更灵活，可以在需要的地方再定义访问路径
   >   ModelAndView mav = new ModelAndView("/view.jsp");
   >   User user = new User();
   >   if (userId == 1) {
   >    user.setUsername("lily");
   >   } else if (userId == 2) {
   >    user.setUsername("smith");
   >   }
   >   mav.addObject("u", user);
   >   return mav;
   > }
   > ```
   >
   > 在`view.jsp`中增加el表达式
   >
   > ```jsp
   > <h2>username:${u.username}</h2>
   > ```
   >
   > 在浏览器传送参数`http://localhost/um/view?userId=2`，结果就是`username:smith`，参数为1自然就是`username:lily`

ModelAndView的常用方法有 `addObject()`**设置属性默认存放在当前请求中**，ModelAndView默认使用请求转发（forward）的功能实现转发至页面，如果想使用重定向需要在ModelAndView初始化时传入参数`new ModelAndView("redirect:/index.jsp")`

> 请求转发地址栏不会变化，在Controller中请求被转发到了JSP页面，JSP和Controller共享一个request对象
>
> 重定向地址栏会发生改变，从`http://localhost/um/view?userId=2`变为`http://localhost/view.jsp`，Controller会通知浏览器重新建立一个新的请求来访问view.jsp这个地址，因为创建了一个全新的请求，所以地址栏发生了变化，而且页面的结果发生了变化，不再是`username:smith`，而是`username:`，原因就是ModelAndView设置属性默认存放在当前请求中，重定向第二次请求中没有属性，所以无法获取到绑定的数据

什么时候使用重定向呢，当页面显示与数据绑定关系不大时可以使用，比如注册完毕跳转回首页，就可以使用重定向



除了ModelAndView有时还会使用ModelMap完成数据绑定或者页面返回工作

```java
/**
 * 处理数据绑定的第二种方式
 * @param userId 用户ID
 * @param modelMap Spring提供
 * @return 根据是否有ResponseBody注解，表示不同的含义
 * 1. 如果有ResponseBody，则MVC直接响应字符串本身到页面
 * 2. 如果没有，则MVC会处理字符串指代的页面，将绑定数据与JSP组合渲染以后返回html页面
 */
@GetMapping("/xxxx")
// @ResponseBody
public String showView1(Integer userId, ModelMap modelMap) {
  String view = "/view.jsp";
  User user = new User();
  if (userId == 1) {
    user.setUsername("lily");
  } else if (userId == 2) {
    user.setUsername("smith");
  }
  modelMap.addAttribute("u", user);
  return view;
}
```

#### 10 整合Freemarker
##### 10.1 SSM

1. 在pom中导入依赖

   ```xml
   <dependency>
     <groupId>org.freemarker</groupId>
     <artifactId>freemarker</artifactId>
     <version>2.3.22</version>
   </dependency>
   <dependency>
     <groupId>org.springframework</groupId>
     <artifactId>spring-context-support</artifactId>
     <version>5.0.8.RELEASE</version>
   </dependency>
   ```
   重新配置Tomcat，将引入的jar包加入lib目录打包

2. 启用Freemarker模板引擎，在Spring配置文件中配置

   ```xml
   <!--Freemarker配置-->
   <bean id="ViewResolver" class="org.springframework.web.servlet.view.freemarker.FreeMarkerViewResolver">
     <!--设置向浏览器输出结果的时候使用的字符集-->
     <property name="contentType" value="text/html;charset=utf-8"/>
     <property name="suffix" value=".ftl"/>
   </bean>
   <bean id="freemarkerConfig" class="org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer">
     <!--freemarker不像jsp天然被MVC支持，这里存放在WEB-INF目录下外界无法直接访问，保证了ftl文件的安全-->
     <property name="templateLoaderPath" value="/WEB-INF/ftl/"/>
     <property name="freemarkerSettings">
       <props>
         <!--设置产生页面结果的时候使用的字符集-->
         <prop key="defaultEncoding">UTF-8</prop>
       </props>
     </property>
   </bean>
   ```

3. 创建Controller类

   ```java
   @Controller
   @RequestMapping("/fm")
   public class FreemarkerController {
     @GetMapping("/test")
     public ModelAndView showTest() {
       ModelAndView mav = new ModelAndView("/test");
       User user = new User();
       user.setUsername("allen");
       mav.addObject("u", user);
       return mav;
     }
   }
   ```

4. 编写ftl文件

   ```ftl
   <h1>${u.username}</h1>
   ```

5. 访问`http://localhost/fm/test`，页面中就可以看见`allen`了

##### 10.2 Springboot
1. 引入依赖

   ```xml
   <!--Freemarker-->
   <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-freemarker</artifactId>
   </dependency>
   ```

2. 在`application.properties`中配置

   ```properties
   spring.freemarker.charset=UTF-8
   spring.freemarker.suffix=.ftl
   spring.freemarker.content-type=text/html; charset=utf-8
   spring.freemarker.template-loader-path=classpath:/templates
   spring.mvc.static-path-pattern=/static/**
   ```

3. 静态文件放到`resources/static`目录下，html文件改后缀名为ftl，放到`resources/templates`目录下

4. 编写Controller

   ```java
   @Controller
   public class CMSController {
       @GetMapping("/login.html")
       public ModelAndView login() {
           ModelAndView mav = new ModelAndView("/login");
           return mav;
       }
   }
   ```

5. 启动springboot，访问`http://localhost:8080/login.html`

#### 11 RESTful开发风格

先来看看传统web应用的问题，传统web应用基于JSP或Freemarker等模板引擎开发，在数据绑定渲染后向浏览器输出html页面

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/springmvc/传统web应用的问题.png)

毫无疑问浏览器是支持html页面的，问题就在于目前互联网发展呈现多元化趋势，不是只有浏览器web这一种前端，还有诸如微信小程序、APP等等，像这些客户端是不支持html的，这时我们希望这些客户端也能通过某种方式向后端进行通信，那怎么办呢，RESTful就是来解决这类问题的

1. REST与RESTful

   所谓REST就是Representational State Transfer的缩写，表现状态转换，即资源在网络中以某种表现形式进行状态转移，而RESTful是基于REST这种理念的一种开发风格，是具体的开发规则

   ![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/springmvc/RESTful传输数据.png)

   可以看到各种前端通过REST的API向后端请求，而后端不会返回html页面，而是返回具体的数据，比如JSON、XML，而前端收到数据后怎么展现是前端的事情，前后端进行了解耦，具体开发规范如下：

   - 所有资源以URL作为交互入口

   - 有明确的语义规范（POST、DELETE、PUT、GET），分别对应增删改查，浏览器不支持PUT和DELETE

   - 后端只返回数据（JSON、XML），不包含任何展现的工作

2. RESTful既然是通过URL作为交互入口，那么对URI的命名是有要求的

   ![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/springmvc/RESTful的URI命名要求.png)

   > URI必须使用名词，不要使用动词，请求方式已经暗含了操作方式，而且如果动词如果和请求方式不一致也会造成URI语义混乱

3. 编写控制类实现RESTful风格开发，这里先直接返回按json格式书写的字符串，注意路径是有明确语义的

   ```java
   @Controller
   @RequestMapping("/restful")
   public class RestfulController {
       @GetMapping("/request")
       @ResponseBody
       public String doGetRequest() {
           return "{\"message\":\"返回查询结果\"}";
       }
   }
   ```

4. 前台写一个html页面，用ajax到后台获取返回的字符串，这里jquery会自动把字符串转化为json格式

   ```html
   <!DOCTYPE html>
   <html lang="en">
     <head>
       <meta charset="UTF-8">
       <title>Title</title>
       <script src="/jquery.min.js"></script>
       <script>
         $(function () {
           $("#btnGet").click(function () {
             $.ajax({
               url: "/restful/request",
               type: "get",
               dataType:"json",
               success:function (json) {
                 $("#message").text(json.message)
               }
             })
           })
         })
       </script>
     </head>
     <body>
       <h1>RESTful测试</h1>
       <input type="button" id="btnGet" value="发送Get请求">
       <h2 id="message"></h2>
     </body>
   </html>
   ```

5. 按发送按钮后ajax异步获取数据，但是此时发现页面显示中文乱码，按F12调试发现返回的数据是json格式的（因为自动转换了），但是编码却是ISO-8859-1，西欧字符集是不支持中文的，找到问题后，只需要在xml里面将json格式的编码也配置成和html一样的utf-8即可

   ```xml
   <mvc:annotation-driven>
     <mvc:message-converters>
       <bean class="org.springframework.http.converter.StringHttpMessageConverter">
         <property name="supportedMediaTypes">
           <list>
             <value>text/html;charset=utf-8</value>
             <value>application/json;charset=utf-8</value>
           </list>
         </property>
       </bean>
     </mvc:message-converters>
   </mvc:annotation-driven>
   ```

   这里使用ajax发送的请求，而小程序、app同样也是发http请求，不过是自己的函数实现的，作为后台，我不管前台如何发送，通过什么方式发送与我无关，我只管传送数据，前台拿到数据如何展现也是前台的事情

6. 其他三种请求方式请求同一个地址时，表示不同的操作

   ```java
   @PostMapping("/request")
   @ResponseBody
   public String doPostRequest() {
     return "{\"message\":\"数据新建成功\"}";
   }
   
   @PutMapping("/request")
   @ResponseBody
   public String doPutRequest() {
     return "{\"message\":\"数据更新成功\"}";
   }
   
   @DeleteMapping("/request")
   @ResponseBody
   public String doDeleteRequest() {
     return "{\"message\":\"数据删除成功\"}";
   }
   ```

   html页面同步编写请求按钮

   ```html
   <script>
     $(function () {
       $("#btnPost").click(function () {
         $.ajax({
           url: "/restful/request",
           type: "post",
           dataType:"json",
           success:function (json) {
             $("#message").text(json.message)
           }
         })
       })
     })
     ...
   </script>
   
   <input type="button" id="btnPost" value="发送Post请求">
   <input type="button" id="btnPut" value="发送Put请求">
   <input type="button" id="btnDelete" value="发送Delete请求">
   ```

   访问同一个地址就可以拿到不同的数据了，这里的程序仍不完美，比如字符串表示json始终不方便，请求路径是写死的，如何在路径里面传递参数给后台呢，每一个方法上都加了@ResponseBody注解，代码冗余，下面我们来解决这些问题

7. 在Spring4以后，提供了一个@RestController注解，只要在类上加上这个注解，类里的方法都默认加上了@ResponseBody注解，默认将返回的字符串直接向响应里面输出，而不是页面的跳转

8. 对于路径传参，只需要在路径里面将参数用`{}`包裹起来，再在方法参数前增加@PathVariable注解绑定参数就可以获取了

   ```java
   @RestController
   @RequestMapping("/restful")
   public class RestfulController {
     @GetMapping("/request")
     // @ResponseBody
     public String doGetRequest() {
       return "{\"message\":\"返回查询结果\"}";
     }
   
     @PostMapping("/request/{rid}")
     // @ResponseBody
     public String doPostRequest(@PathVariable("rid") Integer requestId) {
       return "{\"message\":\"数据新建成功\",\"id\":" + requestId + "}";
     }
   }
   ```

   html页面编写post请求

   ```html
   <script>
     $(function () {
       $("#btnPost").click(function () {
         $.ajax({
           url: "/restful/request/100",
           type: "post",
           dataType: "json",
           success: function (json) {
             $("#message").text(json.message + ":" + json.id)
           }
         })
       })
     })
   </script>
   ```

   结果是

   ```html
   数据新建成功:100
   ```

9. 简单请求与非简单请求，简单请求是指标准结构的HTTP请求，对应GET/POST请求，非简单请求是复杂要求的HTTP请求，指PUT/DELETE、拓展的标准请求，两者最大区别是非简单请求发送前需要发送**预检请求**，预检请求就是在发送真正的请求之前会先发送一次预检请求看服务器是否能正常提供服务，如果正常再发真正的请求，这样可以减轻服务器压力

   在html编写ajax请求，发送data数据

   ```html
   <script>
     $(function () {
       $("#btnPost").click(function () {
         $.ajax({
           url: "/restful/request/100",
           type: "post",
           data: "name=allen&age=23",
           dataType: "json",
           success: function (json) {
             $("#message").text(json.message + ":" + json.id)
           }
         })
       })
     })
     $(function () {
       $("#btnPut").click(function () {
         $.ajax({
           url: "/restful/request",
           type: "put",
           data: "name=allen&age=23",
           dataType: "json",
           success: function (json) {
             $("#message").text(json.message)
           }
         })
       })
     })
   </script>
   ```

   后台编写实体类Person接收数据

   ```java
   @PostMapping("/request/{rid}")
   // @ResponseBody
   public String doPostRequest(@PathVariable("rid") Integer requestId, Person person) {
     System.out.println(person.getName() + ":" + person.getAge());
     return "{\"message\":\"数据新建成功\",\"id\":" + requestId + "}";
   }
   
   @PutMapping("/request")
   // @ResponseBody
   public String doPutRequest(Person person) {
     System.out.println(person.getName() + ":" + person.getAge());
     return "{\"message\":\"数据更新成功\"}";
   }
   ```

   后台打印结果分别是

   ```txt
   allen:23
   null:null
   ```

   这是因为以前的web是只支持浏览器的，而浏览器只支持GET和POST，对PUT和DELETE支持不好，如今MVC为此提供了解决方案，就是在`web.xml`配置Spring提供的过滤器，就解决了这个问题

   ```xml
   <filter>
     <filter-name>formContentFilter</filter-name>
     <filter-class>org.springframework.web.filter.FormContentFilter</filter-class>
   </filter>
   <filter-mapping>
     <filter-name>formContentFilter</filter-name>
     <url-pattern>/*</url-pattern>
   </filter-mapping>
   ```

10. 对于json序列化，可以使用jackson完成，首先引入jackson的jar包依赖，注意引入版本2.9之后的，之前的版本已被发现安全漏洞

    ```xml
    <!--jackson相关-->
    <dependency>
      <groupId>com.fasterxml.jackson.core</groupId>
      <artifactId>jackson-core</artifactId>
      <version>2.10.0</version>
    </dependency>
    <dependency>
      <groupId>com.fasterxml.jackson.core</groupId>
      <artifactId>jackson-databind</artifactId>
      <version>2.10.0</version>
    </dependency>
    <dependency>
      <groupId>com.fasterxml.jackson.core</groupId>
      <artifactId>jackson-annotations</artifactId>
      <version>2.10.0</version>
    </dependency>
    ```

    记得引完jar包，将jar包加入项目artifact发布

    

    然后编写Controller方法，返回值为对象，这样jackson就会自动将对象序列化为json

    ```java
    @GetMapping("/person")
    public Person findByPersonId(Integer id) {
      Person p = new Person();
      if (id == 1) {
        p.setName("allen");
        p.setAge(23);
      } else if (id == 2) {
        p.setName("mikasa");
        p.setAge(22);
      }
      return p;
    }
    ```

    启动项目，浏览器输入`http://localhost/restful/person?id=2`

    结果就是json字符串`{"name":"mikasa","age":22}`

    

    有时候不止查询一个对象怎么办呢，用List返回即可

    ```java
    @GetMapping("/persons")
    public List<Person> findPersons() {
      List<Person> list = new ArrayList<>();
      Person p1 = new Person();
      p1.setName("allen");
      p1.setAge(23);
      Person p2 = new Person();
      p2.setName("mikasa");
      p2.setAge(22);
      list.add(p1);
      list.add(p2);
      return list;
    }
    ```

    浏览器输入`http://localhost/restful/persons`

    结果是`[{"name":"allen","age":23},{"name":"mikasa","age":22}]`

    对于这样的数据，前台如何处理呢，这里用ajax演示

    ```html
    <script>
      $(function () {
        $("#btnPersons").click(function () {
          $.ajax({
            url: "/restful/persons",
            type: "get",
            dataType: "json",
            success: function (json) {
              console.info(json)
              for (let i = 0; i < json.length; i++) {
                let p = json[i]
                $("#divPersons").append("<h2>" + p.name + "-" + p.age + "</h2>")
              }
            }
          })
        })
      })
    </script>
    
    <input type="button" id="btnPersons" value="查询所有人员">
    <div id="divPersons"></div>
    ```

    这样就可以将数据提取出来了

11. jackson对时间日期格式也有相应的支持，只不过需要设置说明，在实体类中增加时间类型属性，在Controller方法中设置属性

    ```java
    @GetMapping("/persons")
    public List<Person> findPersons() {
      List<Person> list = new ArrayList<>();
      Person p1 = new Person();
      p1.setName("allen");
      p1.setAge(23);
      p1.setBirthday(new Date());
      Person p2 = new Person();
      p2.setName("mikasa");
      p2.setAge(22);
      p2.setBirthday(new Date());
      list.add(p1);
      list.add(p2);
      return list;
    }
    ```

    前台对应修改代码

    ```html
    <script>
      $(function () {
        $("#btnPersons").click(function () {
          $.ajax({
            url: "/restful/persons",
            type: "get",
            dataType: "json",
            success: function (json) {
              console.info(json)
              for (let i = 0; i < json.length; i++) {
                let p = json[i]
                $("#divPersons").append("<h2>" + p.name + "-" + p.age + "-" + p.birthday + "</h2>")
              }
            }
          })
        })
      })
    </script>
    ```

    结果是很长的数字，代表从1970-01-01到现在的毫秒数，想要时间按指定格式输出可以使用jackson提供的注解@JsonFormat

    ```java
    public class Person {
        private String name;
        private Integer age;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
        private Date birthday;
        // getter and setter
    }
    ```

    timezone的设置是为了将时间调回本地时间，因为它默认是按照格林尼治时间零时区显示的，JsonFormat不仅可以对时间进行处理，也可以处理数字、货币的格式化输出

#### 12 跨域访问

跨域访问的问题是由于浏览器的同源策略限制产生的，同源策略会阻止一个域加载的脚本去访问另一个域上的资源，这是浏览器出于网站安全因素的考量，只有自己网站的请求可以访问自己网站的资源，如果不同域名下强行访问，就会报CORS错误，只要协议、域名、端口任意一个不同就认为是跨域

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/springmvc/同源策略.png)

但是浏览器允许部分标签跨域访问，大都是静态资源相关的

- `<img>`用于显示图片，可以跨域访问别的域上的图片

- `<script>`用于加载脚本文件

- `<link>`用于加载css文件

需要跨域访问的时候怎么办呢，在前台可以通过CORS机制使用额外的HTTP头通知浏览器可以访问其他的域，需要在URL响应头包含`Access-Control-*`，当然这个响应头不是我们想加就能加上的，是需要服务器对对应的资源进行授权才可以，SpringMVC主要有两种办法解决：

- 添加@CrossOrigin注解，这是局部注解
- 添加全局配置`<mvc:cors>`，一劳永逸



这里模拟一下两台服务器的跨域访问，首先我们将前面的restful项目复制一份，改名为restful-cors，将端口号从80改为8080，JMX端口从1099改为1100，修改项目结构和artifact，将html的post请求地址改为`http://localhost/restful/persons`，这样就形成了跨域访问，启动两个项目，会发现8080项目的post请求被浏览器阻止，这时在80项目的Controller类上增加注解，说明允许8080域名访问

```java
@RestController
@RequestMapping("/restful")
@CrossOrigin(origins = {"http://localhost:8080"})
public class RestfulController {...}
```

重启项目就会发现post请求可以正常访问了，并且在请求的响应头上加上了`Access-Control-Allow-Origin: http://localhost:8080`这样的数据，说明解决了跨域问题，设置对个域名，在`{}`里用`,`分隔即可，如果想所有的域名都可以访问可以直接设置`origins = "*"`，但是不推荐，很不安全，还可以设置`maxAge = 3600`表示将预检请求缓存一小时，在一小时内，非简单请求就不会发送预检请求，而是直接发送真实请求，减轻服务器压力



局部注解虽然好用，但某些情况不够方便，如果想一次配置全部解决可以使用全局配置，在spring配置文件中如下配置

```xml
<!--CORS跨域配置-->
<mvc:cors>
  <mvc:mapping path="/restful/**"
               allowed-origins="http://localhost:8080,http://www.heeh.com"
               max-age="3600"/>
</mvc:cors>
```

> 如果同时配置了注解配置与全局配置，会以注解配置为准

#### 13 拦截器

拦截器Interceptor，主要是为了对URL请求进行前置后置过滤，Interceptor与Filter作用相似，但是实现方式不同，Interceptor底层就是基于AOP实现的

1. 引入servlet的jar包

   ```xml
   <dependency>
     <groupId>javax.servlet</groupId>
     <artifactId>javax.servlet-api</artifactId>
     <version>3.1.0</version>
     <scope>provided</scope>
   </dependency>
   ```

2. 编写拦截器类，需要实现HandlerInterceptor接口，拦截器的处理主要有三个阶段

   - preHandle

     在请求产生之后，还没有进Controller之前，对这个请求进行预置处理

   - postHandle

     在目标资源已经被MVC处理后执行，比如Controller方法return了之后，但是还没有产生响应文本之前执行

   - afterCompletion

     产生了响应文本之后执行，

   ```java
   package com.heeh.restful.interceptor;
   
   import org.springframework.web.servlet.HandlerInterceptor;
   import org.springframework.web.servlet.ModelAndView;
   
   import javax.servlet.http.HttpServletRequest;
   import javax.servlet.http.HttpServletResponse;
   
   public class MyInterceptor implements HandlerInterceptor {
     @Override
     public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
       System.out.println(request.getRequestURL() + "-准备执行");
       return HandlerInterceptor.super.preHandle(request, response, handler);
     }
   
     @Override
     public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
       System.out.println(request.getRequestURL() + "-目标处理成功");
       HandlerInterceptor.super.postHandle(request, response, handler, modelAndView);
     }
   
     @Override
     public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
       System.out.println(request.getRequestURL() + "-响应内容已产生");
       HandlerInterceptor.super.afterCompletion(request, response, handler, ex);
     }
   }
   
   ```

3. 在Spring配置文件中配置拦截器，说明拦截范围

   ```xml
   <mvc:interceptors>
     <mvc:interceptor>
       <mvc:mapping path="/**"/>
       <bean class="com.heeh.restful.interceptor.MyInterceptor"/>
     </mvc:interceptor>
   </mvc:interceptors>
   ```

4. 但是如果配置拦截所有请求，则会将静态资源的请求也给拦截下来，这是不受`<mvc:default-servlet-handler/>`这个配置的影响的，如果想不拦截静态资源，需要进一步配置

   ```xml
   <mvc:interceptors>
     <mvc:interceptor>
       <mvc:mapping path="/**"/>
       <mvc:exclude-mapping path="/**.ico"/>
       <mvc:exclude-mapping path="/**.jpg"/>
       <mvc:exclude-mapping path="/**.gif"/>
       <mvc:exclude-mapping path="/**.js"/>
       <mvc:exclude-mapping path="/**.css"/>
       <bean class="com.heeh.restful.interceptor.MyInterceptor"/>
     </mvc:interceptor>
   </mvc:interceptors>
   ```

   这样就不会拦截这些被排除的静态资源，但是静态资源种类繁多，不可能一个个地去配置吧，这里可以专门建立一个静态资源文件夹，比如在webapp目录下新建一个resoources目录，然后分别建立js、css、img文件夹用于存放静态资源，然后只需配置一句话就可以搞定了

   ```xml
   <mvc:interceptors>
     <mvc:interceptor>
       <mvc:mapping path="/**"/>
       <mvc:exclude-mapping path="/resources/**"/>
       <bean class="com.heeh.restful.interceptor.MyInterceptor"/>
     </mvc:interceptor>
   </mvc:interceptors>
   ```

5. 但设置了多个拦截器时，拦截器执行顺序是怎么样的呢，响应产生的前后会相反，原因如下

   ![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/springmvc/多Interceptor执行顺序.png)

6. 拦截器preHandle方法中的返回值是一个布尔值，为true继续执行接下来的方法，为false则请求会被拦截器阻挡，在preHandle方法中产生的消息会返回给浏览器

下面开发一个实际的例子，用户流量拦截器，用于对用户的基础数据进行采集，比如IP地址、设备等，再用logback对采集的数据进行日志存储

1. 引入logback的jar包，将其加入artifact

   ```xml
   <dependency>
     <groupId>ch.qos.logback</groupId>
     <artifactId>logback-classic</artifactId>
     <version>1.2.3</version>
   </dependency>
   ```

2. 编写拦截器类AccessHistoryInterceptor用于拦截记录，先不实现，在resources目录下建立logback的配置文件`logback.xml`

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <configuration>
     <!--向控制台打印日志-->
     <appender name="console" class="ch.qos.logback.core.ConsoleAppender">
       <encoder>
         <pattern>[%thread] %d %level %logger{10} - %msg%n</pattern>
       </encoder>
     </appender>
     <!--按天保存日志，一天一个日志文件-->
     <appender name="accessHistoryLog" class="ch.qos.logback.core.rolling.RollingFileAppender">
       <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
         <fileNamePattern>C:/Users/22829/IdeaProjects/restful/logs/history.%d.log</fileNamePattern>
       </rollingPolicy>
       <encoder>
         <pattern>[%thread] %d %level %logger{10} - %msg%n</pattern>
       </encoder>
     </appender>
     <root level="debug">
       <appender-ref ref="console"/>
     </root>
     <!--additivity设置为true则同时会向控制台打印日志-->
     <logger name="com.heeh.restful.interceptor.AccessHistoryInterceptor" level="INFO" additivity="false">
       <appender-ref ref="accessHistoryLog"/>
     </logger>
   </configuration>
   ```

3. 编辑拦截器类，实现方法获取用户信息

   ```java
   package com.heeh.restful.interceptor;
   
   import org.slf4j.Logger;
   import org.slf4j.LoggerFactory;
   import org.springframework.web.servlet.HandlerInterceptor;
   import org.springframework.web.servlet.ModelAndView;
   
   import javax.servlet.http.HttpServletRequest;
   import javax.servlet.http.HttpServletResponse;
   
   public class AccessHistoryInterceptor implements HandlerInterceptor {
     private Logger logger = LoggerFactory.getLogger(AccessHistoryInterceptor.class);
   
     @Override
     public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
       StringBuilder log = new StringBuilder();
       // 获取用户IP地址
       log.append(request.getRemoteAddr());
       log.append("|");
       // 获取用户访问地址
       log.append(request.getRequestURL());
       log.append("|");
       // 获取用户浏览器标识
       log.append(request.getHeader("user-agent"));
       // 保存日志
       logger.info(log.toString());
       return true;
     }
   }
   ```

   启动项目，前台用户的操作就会被记录到日志文件中了

#### 14 SpringMVC处理流程

这里通过画图讲解，首先一个请求从浏览器来到后台后会首先被中央处理器DispatcherServlet处理，查找处理器Handler，由处理映射器HandlerMapper查找执行链并返回

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/springmvc/SpringMVC处理流程1.png)

> **处理器Handler：**指拦截器类、控制器类等
> **执行链：**指请求的整个处理流程，会经过哪些拦截器和控制器处理，以及处理顺序等一系列执行流程
> ![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/springmvc/SpringMVC处理流程2.png)

中央处理器拿到执行链之后会向处理适配器HandlerAdapter请求执行执行链，而处理适配器则会根据执行链去调用相应的处理器执行，处理器返回执行结果给处理适配器，然后处理适配器将结果返回给中央处理器，中央处理器拿到结果后根据结果去寻找对应的视图解析器，视图解析器解析完成后返回视图对象给中央处理器，拿到视图对象后中央处理器就按照视图对象将数据和视图绑定到一起，一般会形成html页面，然后将其响应给浏览器

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/springmvc/SpringMVC处理流程3.png)

