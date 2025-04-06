#### 1 Spring Boot

##### 1.1 优点

目前新的 java 项目基本都是采用 spring boot 去开发，这已经成为了 java 开发领域的一个事实标准，为什么会造成这种现象呢？当然是因为 spring boot 拥有很多优点

1. 简化项目配置

   在以往使用 spring 开发时，虽然 spring 是个很好的框架，但是却需要编写大量的配置文件，而且每个 spring 项目编写的配置文件还都差不多，这就导致了大量的重复性工作，降低了开发效率

   spring boot 就是致力于解决这个问题，提高项目的开发效率，spring boot 是提倡约定大于配置的，只要按照 spring boot 的约定去做，对于一些约定俗成的重复配置就可以不用去单独配置了，spring boot 将大家常用的一些配置，比如端口、数据库、超时时间等等进行了默认配置，一般而言是没有必要去修改的，有这个需要再去修改，没有需要就直接使用默认的，省去了配置，很方便

2. 起步式依赖

   安装依赖时，只需要指明需要的某个依赖，这个依赖所需要的其他的依赖列表，我们不需要关心，spring boot 会自动为我们下载安装

3. 独立的 spring 项目

   在以往开发项目时，我们需要使用 tomcat 做容器，然后把项目打包成 war 包，然后把 war 包放到 tomcat 容器中去运行，但是如果使用 spring boot，spring boot 已经内嵌了一个 tomcat，可以直接运行项目，不再需要我们去单独启动 tomcat 和做环境配置，这给运行部署项目带来了莫大的便利

4. 监控能力强

   自带强大的监控能力，只需少量配置，就能了解系统的运行情况

那我们说，spring boot 这么好，它是一个新框架吗，不是，看名称就能知道，它也是建立在 spring 框架的基础之上的，只不过解决了 spring 开发繁琐的痛点

##### 1.2 版本

打开 [spring boot](https://spring.io/projects/spring-boot#learn) 的官网，会发现有 CURRENT、GA、SNAPSHOT 版本，CURRENT 是当前版本，GA 是稳定版本，SNAPSHOT 是快照版本，一般而言，选择 GA 版本就好，spring boot 2.0 版本的重要更新包括支持 http 2.0，jdk 要求最低 8 等等

#### 2 新建 spring boot 项目

##### 2.1 通过 idea 新建

spring boot 项目的新建可以通过 spring 官网，也可以通过 idea，一般我们都是通过 idea 去新建

打开 idea，不同版本的 idea 可能会有所不同，这里使用的是 2024 版

点击新建项目，选择生成器，选择 spring boot，依次填写项目名称、项目位置、git 仓库、开发语言（java）、项目类型（maven）、组名（反转的域名，用于唯一标识项目）、工件（通常为项目名称）、jdk、打包（jar 或 war）

> 使用 idea 2024 创建时发现只能选 java 17，原因是 spring boot 3.0 发布时，宣布 java 17将成为主流版本，默认不支持 8 了，可以把服务器 url 从 `start.spring.io` 改为阿里的 `start.aliyun.com`

点击下一步，选择 spring boot 版本为 2.4.2，勾选依赖项，找到 web  =>  spring web，然后点击创建，就成功创建了 spring boot 项目，项目会自动下载加载 maven 依赖，项目目录如下：

```text
│  pom.xml
├─.idea
└─src
    ├─main
    │  ├─java
    │  │  └─com
    │  │      └─example
    │  │          └─startboot
    │  │              │  StartBootApplication.java       
    │  └─resources
    │      │  application.properties
    │      └─static
    │              index.html      
    └─test
```

这是标准的 maven 项目的目录结构，`pom.xml` 是项目配置和 maven 依赖列表，`main/java` 存放 java 源代码，`main/resources` 存放其他资源和项目配置文件，`test` 是测试目录，一般用不到

##### 2.2 体验接口

先来复习一下 web 开发的三层结构，一般分为三层 Controller、Service、DAO

- Controller：对外提供接口，负责处理路由
- Service：处理业务逻辑
- DAO：与数据库交互

首先建立 Controller，在 java 目录下的包 `com.example.startboot` 下新建类 `ParaController`

```java
// src\main\java\com\example\startboot\controller\ParaController.java

package com.example.startboot.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ParaController {

    @GetMapping("/firstrequest")
    public String firstRequest() {
        return "Hello Spring Boot!";
    }
}
```

这里用到了两个注解 `@RestController` 和 `@GetMapping`，分别解释一下

1. @RestController

   相当于两个注解的组合： `@Controller` + `@ResponseBody`

   - `@Controller`：标识该类为 Spring MVC 控制器
   - `@ResponseBody`：将方法返回值直接序列化为 HTTP 响应体（如 JSON/XML），而非视图跳转

   适用于构建前后端分离的 Web 服务，返回数据（如 JSON）而非 HTML 页面

2. @GetMapping

   相当于 `@RequestMapping(method = RequestMethod.GET)` 的简写，`@GetMapping` 是 Spring MVC 中的一个注解，用于将 **HTTP GET 请求** 映射到特定的控制器方法，专门用于简化 GET 请求的处理

定义好之后在主类 `StartBootApplication.java` 中启动项目

这时在浏览器中访问 `http://localhost:8080/firstrequest` 就能得到响应 `Hello Spring Boot!`

##### 2.3  接收参数

前面实现的 `ParaController` ，里面的路由路径是写死的，没有办法接收前端传递过来的参数，其实要接收 get 参数很简单，再加一个参数注解即可

```java
package com.example.startboot.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ParaController {

    @GetMapping("/firstrequest")
    public String firstRequest() {
        return "Hello Spring Boot!";
    }

    @GetMapping("/para")
    public String requestPara(@RequestParam Integer num) {
        num = num + 1;
        return "reveived param: " + num;
    }
}
```

`@RequestParam`：声明参数注解，用于获取 param 参数

前端通过 url 地址传参`http://localhost:8080/para?num=10`

那么 post 请求又怎么做呢，当然也是有相关注解的：

```java
package com.example.startboot.controller;

import com.example.startboot.pojo.Student;
import org.springframework.web.bind.annotation.*;

@RestController
public class ParaController {

    @GetMapping("/firstrequest")
    public String firstRequest() {
        return "Hello Spring Boot!";
    }

    @GetMapping("/para")
    public String requestPara(@RequestParam Integer num) {
        num = num + 1;
        return "reveived param: " + num;
    }

    @PostMapping("/post")
    public String postRequest(@RequestBody Student student) {
        return "reveived body param: " + student;
    }
}
```

`@RequestBody`：表明接收的是 post 的 body 参数，一般前端传递过来的都是一个 json 对象

我们还需要建立一个 pojo 对象去接收 json 形式的参数

> 什么是 pojo 呢，pojo 就是 Plain Old Java Object 的缩写，普通 Java 对象，是指一个简单的 Java 类，这是与框架无关的普通类，只有私有的属性、公有的 Getter/Setter 和基本的构造方法，pojo 类不写业务逻辑，只负责数据描述和存储
>
> 同一个 pojo 可以在不同场景使用：
>
> - **Web 层**：接收 HTTP 请求参数（如 `@RequestBody Student student`）
> - **Service 层**：作为业务方法的参数或返回值
> - **DAO 层**：与数据库表映射（如 JPA/Hibernate 的 `@Entity`）

新建 pojo 包，再新建 `Student` 的 pojo 类

> 注意，一定要写 Getter/Setter 和 无参/有参构造方法，可以通过 idea 快捷键 `alt + ins` 快速生成

```java
package com.example.startboot.pojo;

/**
 * 学生实体类
 */
public class Student {
    private Integer id;
    private String name;

    public Student() {
    }

    public Student(Integer id, String name) {
        this.id = id;
        this.name = name;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Student{" +
                "id=" + id +
                ", name='" + name + '\'' +
                '}';
    }
}
```

这时打开 postman 或者 apifox 等模拟请求的软件，建立 post 请求，发送方式选择 body raw，content-type 设置为 `application/json`，填写 json，就会得到接口响应

```sh
地址：http://localhost:8080/post

请求：
{
    "id": 666,
    "name": "好学生"
}

响应：
reveived body param: Student{id=666, name='好学生'}
```

#### 3 配置文件

虽然 spring boot 配置很少，但是仍然是有配置的，在 spring boot 中有两种配置文件，一种是 properties 后缀的配置文件，另一种是 yml 后缀的配置文件，主要区别在于书写风格上

properties：

```properties
server.port=8080
```

yml:

```yaml
server:
	port: 8080
```

选择自己喜欢的风格即可，比如如下配置

```properties
server.port=8081  # 配置项目启动端口号
spring.application.name=first-spring-boot  # 配置项目名称
server.servlet.context-path=/first  # 配置统一路由 url 前缀
```

有时候我们有些参数不想写死在代码里，而是希望写在配置文件中，方便后续的维护修改，这时可以利用自定义配置实现

我们先实现写死的情况，新建一个 `PropertiesController`

```java
package com.example.startboot.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 配置相关
 */
@RestController
public class PropertiesController {
    Integer grade = 5;
    Integer classNum = 9;

    @GetMapping("/gradeclass")
    public String gradeClass() {
        return "年级：" + grade + " 班级：" + classNum;
    }
}
```

此时 grade 和 classNum 是写死的，如果想再修改的话，就必须修改源代码

现在我们可以把它做成配置的，首先为需要配置的属性添加注解 `@Value`

```java
package com.example.startboot.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 配置相关
 */
@RestController
public class PropertiesController {
    @Value("${school.grade}")
    Integer grade;
    @Value("${school.classNum}")
    Integer classNum;

    @GetMapping("/gradeclass")
    public String gradeClass() {
        return "年级：" + grade + " 班级：" + classNum;
    }
}

```

然后到配置文件 `application.properties` 中进行自定义配置

```properties
server.port=8080

school.grade=6
school.classNum=9
```

这样就能成功读取到配置，并赋值给配置属性了，后续想要修改可以直接修改配置文件

如果属性是静态的，则必须通过 setter 去注入

```java
package com.example.startboot.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 配置相关
 */
@RestController
public class PropertiesController {
    @Value("${school.grade}")
    Integer grade;
    @Value("${school.classNum}")
    Integer classNum;
    @Value("${school.age}")
    static Integer age;

    @GetMapping("/gradeclass")
    public String gradeClass() {
        return "年级：" + grade + " 班级：" + classNum + " 年龄：" + age;
    }
}
```

如上，如果和普通成员变量一样进行注解，age 的打印将会是 null，下面编写 setter 函数，将注解移动到 setter 函数上

```java
package com.example.startboot.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 配置相关
 */
@RestController
public class PropertiesController {
    @Value("${school.grade}")
    Integer grade;
    @Value("${school.classNum}")
    Integer classNum;

    static Integer age;

    @Value("${school.age}")
    public void setAge(Integer age) {
        PropertiesController.age = age;
    }

    @GetMapping("/gradeclass")
    public String gradeClass() {
        return "年级：" + grade + " 班级：" + classNum + " 年龄：" + age;
    }
}
```

这时就能成功打印 age 了

#### 4 业务开发

##### 4.1 连通数据库

接下来打通数据库链路，首先引入数据库的相关依赖，分别是 mybatis、mysql

```xml
 <dependency>
     <groupId>org.mybatis.spring.boot</groupId>
     <artifactId>mybatis-spring-boot-starter</artifactId>
     <version>2.1.1</version>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>
```

然后编写配置文件 `application.properties` ，配置数据库连接相关的配置，指定驱动名称，配置数据库连接地址、数据库用户名、数据库密码

```properties
server.port=8080

school.grade=6
school.classNum=9
school.age=18

spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.url=jdbc:mysql://localhost:3306/interview?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8&useSSL=true
spring.datasource.username=root
spring.datasource.password=123456
```

##### 4.2 service & mapper

新建一个 service 包，新建 `StudentService` 类，添加 `@Service` 注解

```java
package com.example.startboot.service;

import com.example.startboot.pojo.Student;
import org.springframework.stereotype.Service;

@Service
public class StudentService {
    public Student getStudent(Integer id) {
        
    }
}
```

再新建一个 mapper 包，新建 `StudentMapper` 接口，添加 `@Mapper` 和 `@Repository` 注解，这样就能被 spring 框架识别到

> 为什么需要 mapper 呢？在传统的 jdbc 开发中，sql 语句和 java 业务代码是混合在一起的，如有修改会导致难以维护，且修改源码需要重新编译，而 mapper 的方式将 sql 与业务代码进行了解耦，修改 sql 只需调整注解或 XML 文件就行了，更方便维护，而且得益于 mapper 标准，还可以自动生成 sql，减少重复代码

```java
package com.example.startboot.mapper;

import com.example.startboot.pojo.Student;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface StudentMapper {
    @Select("SELECT * FROM students WHERE id = #{id}")
    Student findById(long id);
}
```

回到 `StudentService` ， 导入 mapper，使用 mapper 查询数据并在 service 方法中返回查询结果

```java
package com.example.startboot.service;

import com.example.startboot.mapper.StudentMapper;
import com.example.startboot.pojo.Student;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class StudentService {

    @Autowired
    StudentMapper studentMapper;

    public Student getStudent(Integer id) {
        return studentMapper.findById(id);
    }
}
```

最后在 controller 包下新建 `StudentController` 类

```java
package com.example.startboot.controller;

import com.example.startboot.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class StudentController {
    @Autowired
    StudentService studentService;

    @GetMapping("/student")
    public String requestPara(@RequestParam Integer id) {
        return studentService.getStudent(id).toString();
    }
}
```

这时再访问 `http://localhost:8080/student?id=1` 就能得到返回结果 `Student{id=1, name='张三'}`

> `@Autowired` 是 Spring 框架的核心注解，用于 **自动依赖注入（DI, Dependency Injection）**。它的主要功能是让 Spring 容器自动将合适的 Bean 注入到目标位置（如字段、构造方法、Setter 方法等），无需手动通过 `new` 创建对象。

#### 5 电商项目初始化

有了前面的章节知识铺垫，从本章开始，我们将会使用 spring boot 创建一个电商项目，为什么选择电商呢，主要从以下几点考虑：

1. 项目规模比一般的项目规模大，比如相比图书管理系统而言，电商项目拥有更多业务场景
2. 电商项目涉及到的技术点是通用的，可以复制到别的项目
3. 电商项目的需求量大，网上商城是很多企业都会涉及到的业务

首先安装两个 idea 插件，有助于提高开发效率，分别是 maven helper 和 free mybatis tool，可以更好的管理 maven 和自动生成 mapper

##### 5.1 数据库设计

项目开发的第一步，自然是需求分析，而需求分析完成后，就开始数据库的设计，这是项目开发中最开始，也是最核心的一步，有关数据库设计的部分，可以参考数据库笔记，这里只展示设计结果，项目共有 6 张表，分别是：

用户表

```sql
CREATE TABLE `users` (
  `id` int(64) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `name` varchar(32) NOT NULL COMMENT '用户名',
  `password` varchar(50) NOT NULL COMMENT '用户密码，MD5加密',
  `signature` varchar(255) DEFAULT NULL COMMENT '用户签名',
  `role` int(4) NOT NULL DEFAULT '1' COMMENT '用户角色，1-普通用户，2-管理员',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

分类表

```sql
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类id',
  `name` varchar(32) NOT NULL COMMENT '分类名称',
  `rank` int(11) NOT NULL COMMENT '分类等级',
  `order` int(11) NOT NULL COMMENT '分类排序',
  `parent_id` int(11) NOT NULL COMMENT '父分类id',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

商品表

```sql
CREATE TABLE `goods` (
  `id` int(64) NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `name` varchar(100) NOT NULL COMMENT '商品名称',
  `image` varchar(500) NOT NULL COMMENT '商品图片',
  `detail` varchar(500) NOT NULL COMMENT '商品详情',
  `category_id` int(11) NOT NULL COMMENT '分类id',
  `price` int(11) NOT NULL COMMENT '价格，单位-分',
  `stock` int(11) NOT NULL COMMENT '库存数量',
  `status` int(6) NOT NULL COMMENT '商品状态，0-下架，1-上架',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

购物车表

```sql
CREATE TABLE `carts` (
  `id` int(64) NOT NULL AUTO_INCREMENT COMMENT '购物车id',
  `users_id` int(11) NOT NULL COMMENT '用户id',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `quantity` int(11) NOT NULL COMMENT '商品数量',
  `selected` int(6) NOT NULL COMMENT '是否已勾选，0-未勾选，1-已勾选',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

订单表

```sql
CREATE TABLE `orders` (
  `id` int(64) NOT NULL AUTO_INCREMENT COMMENT '订单id',
  `users_id` int(11) NOT NULL COMMENT '用户id',
  `order_no` varchar(128) NOT NULL COMMENT '订单编号',
  `order_status` int(10) NOT NULL COMMENT '订单状态，0-已取消，10-未付款，20-已付款，30-已发货，40-已完成',
  `total_price` int(64) NOT NULL COMMENT '订单总价',
  `receiver_name` varchar(32) NOT NULL COMMENT '收货人姓名快照',
  `receiver_phone` varchar(32) NOT NULL COMMENT '收货人手机号快照',
  `receiver_address` varchar(128) NOT NULL COMMENT '收货人地址快照',
  `postage` int(11) NOT NULL DEFAULT '0' COMMENT '运费',
  `payment_type` int(4) NOT NULL DEFAULT '1' COMMENT '支付类型，1-在线支付',
  `delivery_time` timestamp NULL DEFAULT NULL COMMENT '发货时间',
  `pay_time` timestamp NULL DEFAULT NULL COMMENT '支付时间',
  `end_time` timestamp NULL DEFAULT NULL COMMENT '完成时间',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

订单物品表

```sql
CREATE TABLE `order_items` (
  `id` int(64) NOT NULL AUTO_INCREMENT COMMENT '订单物品id',
  `order_no` varchar(128) NOT NULL COMMENT '归属订单编号',
  `goods_id` int(11) NOT NULL COMMENT '商品id',
  `goods_name` varchar(100) NOT NULL COMMENT '商品名称',
  `goods_image` varchar(128) NOT NULL COMMENT '商品图片',
  `unit_price` int(11) NOT NULL COMMENT '商品单价快照',
  `quantity` int(11) NOT NULL COMMENT '商品数量',
  `total_price` int(11) NOT NULL COMMENT '商品总价快照',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

数据库的表设计不是一蹴而就的，可能一开始没有考虑得很全面，没关系，做项目的过程中，需要增删字段的话，直接增删就可以了

##### 5.2 初始化项目

项目初始化和前面的示例是一样的，完成项目的创建后，我们添加 `mybatis-generator-maven-plugin` 插件依赖

```xml
<plugin>
    <groupId>org.mybatis.generator</groupId>
    <artifactId>mybatis-generator-maven-plugin</artifactId>
    <version>1.3.7</version>
    <configuration>
        <verbose>true</verbose>
        <overwrite>true</overwrite>
    </configuration>
</plugin>
```

然后在 `resources` 资源目录，新建配置文件 `generatorConfig.xml`

> 配置数据库驱动的位置：`classPathEntry` 的 `location` 需要指定本地电脑上的 `mysql-connector-java` 的依赖 jar 包

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
  PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
  "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">
<generatorConfiguration>
  <!-- 数据库驱动配置 -->
  <classPathEntry location="D:\Develop\apache-maven-3.2.5\local-repository\mysql\mysql-connector-java\8.0.27\mysql-connector-java-8.0.27.jar"/>
  <context id="MysqlTables" targetRuntime="MyBatis3">
    <property name="autoDelimitKeywords" value="true"/>
    <!-- 可以使用``包括字段名，避免字段名与sql保留字冲突报错 -->
    <property name="beginningDelimiter" value="`"/>
    <property name="endingDelimiter" value="`"/>
    <!-- 可选，旨在创建class时，对注释进行控制 -->
    <commentGenerator>
      <property name="suppressDate" value="true"/>
      <property name="suppressAllComments" value="true"/>
    </commentGenerator>
    <!-- 数据库链接地址账号密码 -->
    <jdbcConnection driverClass="com.mysql.cj.jdbc.Driver"
      connectionURL="jdbc:mysql://127.0.0.1:3306/boot_mall?useUnicode=true&amp;characterEncoding=UTF-8&amp;zeroDateTimeBehavior=convertToNull"
      userId="root"
      password="123456">
      <property name="nullCatalogMeansCurrent" value="true"/>
    </jdbcConnection>
    <!-- 可选，类型处理器，在数据库类型和java类型之间的转换控制 -->
    <javaTypeResolver>
      <property name="forceBigDecimals" value="false"/>
    </javaTypeResolver>
    <!-- 生成Model类存放位置 -->
    <javaModelGenerator targetPackage="com.mall.bootmall.model.pojo"
      targetProject="src/main/java">
      <!-- 是否允许子包，即targetPackage.schemaName.tableName -->
      <property name="enableSubPackages" value="true"/>
      <!-- 是否对类CHAR类型的列的数据进行trim操作 -->
      <property name="trimStrings" value="true"/>
      <!-- 建立的Model对象是否不可改变，即生成的Model对象不会有setter方法，只有构造方法 -->
      <property name="immutable" value="false"/>
    </javaModelGenerator>
    <!-- 生成mapper映射文件存放位置 -->
    <sqlMapGenerator targetPackage="mappers" targetProject="src/main/resources">
      <property name="enableSubPackages" value="true"/>
    </sqlMapGenerator>
    <!-- 生成mapper类存放位置 -->
    <javaClientGenerator type="XMLMAPPER" targetPackage="com.mall.bootmall.model.mapper"
      targetProject="src/main/java">
      <property name="enableSubPackages" value="true"/>
    </javaClientGenerator>
    <!-- 生成对应表及类名 -->
    <table tableName="users" domainObjectName="Users"
       enableCountByExample="false"
       enableUpdateByExample="false"
       enableDeleteByExample="false"
       enableSelectByExample="false"
       selectByExampleQueryId="false">
    </table>
    <table tableName="categories" domainObjectName="Categories"
       enableCountByExample="false"
       enableUpdateByExample="false"
       enableDeleteByExample="false"
       enableSelectByExample="false"
       selectByExampleQueryId="false">
    </table>
    <table tableName="goods" domainObjectName="Goods"
       enableCountByExample="false"
       enableUpdateByExample="false"
       enableDeleteByExample="false"
       enableSelectByExample="false"
       selectByExampleQueryId="false">
    </table>
    <table tableName="carts" domainObjectName="Carts"
       enableCountByExample="false"
       enableUpdateByExample="false"
       enableDeleteByExample="false"
       enableSelectByExample="false"
       selectByExampleQueryId="false">
    </table>
    <table tableName="orders" domainObjectName="Orders"
       enableCountByExample="false"
       enableUpdateByExample="false"
       enableDeleteByExample="false"
       enableSelectByExample="false"
       selectByExampleQueryId="false">
    </table>
    <table tableName="order_items" domainObjectName="OrderItems"
       enableCountByExample="false"
       enableUpdateByExample="false"
       enableDeleteByExample="false"
       enableSelectByExample="false"
       selectByExampleQueryId="false">
    </table>
  </context>
</generatorConfiguration>
```

使用 maven 重新加载依赖，然后打开 maven 的插件选项，找到 `mybatis-generator`，继续点开菜单，双击 `mybatis-generator:generate`，如果终端打印 `BUILD SUCCESS`，则 pojo 和 mapper 类生成成功，resources 目录下也成功生成了对应的 xml 文件，用于存放 sql 语句

>DAO 和 Mapper：
>
>- **DAO 和 Mapper 本质相同**，都是用来操作数据库的接口
>- **DAO 是通用术语，Mapper 是 MyBatis 的特定叫法**
>- **现代 MyBatis 项目推荐用 `Mapper`**，更贴合框架设计
>
>DAO 是标准名称，Mapper 是 MyBatis 的实现方式
>
>就像「手机」和「iPhone」的关系 —— iPhone 也是手机，但 iPhone 特指苹果的实现

##### 5.3 连通数据库

新建 controller 包，新建 `UserController` 类

```java
package com.mall.bootmall.controller;

import com.mall.bootmall.model.pojo.Users;
import org.springframework.stereotype.Controller;

@Controller
public class UserController {

    public Users personalPage() {}
}
```

可以看到我们首先定义了一个个人主页 controller，用于返回个人信息，返回值是 Users pojo 对象，根据后端三层开发理论，controller 需要调用 service 去实现业务逻辑，现在去新建 service，再新建 `UserService` 接口

> 这里注意，service 被新建成了接口，接口只定义需要实现的方法，调用方比如 controller 不关心具体实现，更灵活，实现了功能上的解耦

```java
package com.mall.bootmall.service;

import com.mall.bootmall.model.pojo.Users;
import org.springframework.stereotype.Service;

@Service
public interface UserService {
    Users getUserById(Integer id);
}
```

接下来在 service 包下新建 impl 包，用于存放 service 接口的实现类，新建 `UserServiceImpl` 实现类

```java
package com.mall.bootmall.service.impl;

import com.mall.bootmall.model.pojo.Users;
import com.mall.bootmall.service.UserService;

@Service
public class UserServiceImpl implements UserService {
    @Override
    public Users getUserById(Long id) {
        return null;
    }
}
```

有了 service 实现类，接下来就连接数据库，查询数据，我们前面实现的 mapper 类，这时就派上用场了，注入 mapper 的依赖，使用 mapper 查询数据

```java
package com.mall.bootmall.service.impl;

import com.mall.bootmall.model.mapper.UsersMapper;
import com.mall.bootmall.model.pojo.Users;
import com.mall.bootmall.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    UsersMapper usersMapper;

    @Override
    public Users getUserById(Integer id) {
        return usersMapper.selectByPrimaryKey(id);
    }
}

```

> 这里 `@Autowired` 会报错：必须在有效 Spring Bean 中定义自动装配成员，依赖注入是 spring 的核心功能，但是被注入的对象必须由 spring 管理，不能是普通的对象，所以 UsersMapper 的写法是有问题的，没有声明成 spring 的 bean
>
> 给生成的 mapper 接口加上 `@Repository` 注解
>
> ```java
> package com.mall.bootmall.model.mapper;
> 
> import com.mall.bootmall.model.pojo.Users;
> import org.springframework.stereotype.Repository;
> 
> @Repository
> public interface UsersMapper {
>     int deleteByPrimaryKey(Integer id);
> 
>     int insert(Users record);
> 
>     int insertSelective(Users record);
> 
>     Users selectByPrimaryKey(Integer id);
> 
>     int updateByPrimaryKeySelective(Users record);
> 
>     int updateByPrimaryKey(Users record);
> }
> ```

在主应用文件中，添加 mapper 文件夹的 `@MapperScan` 注解，目的是告诉 mybatis mapper 接口文件在哪儿

```java
package com.mall.bootmall;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan(basePackages = "com.mall.bootmall.model.mapper")
public class BootMallApplication {

    public static void main(String[] args) {
        SpringApplication.run(BootMallApplication.class, args);
    }

}
```

此时还有配置工作需要完成，打开 `application.properties` 配置 mapper 目录，目的是告诉 mybatis mapper 接口对应的 xml 文件在哪儿

```properties
server.port=8080

spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.url=jdbc:mysql://localhost:3306/boot_mall?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8&useSSL=true
spring.datasource.username=root
spring.datasource.password=123456

mybatis.mapper-locations=classpath:mappers/*.xml
```

继续完善 `UserController` 类

```java
package com.mall.bootmall.controller;

import com.mall.bootmall.model.pojo.Users;
import com.mall.bootmall.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class UserController {
    @Autowired
    UserService userService;

    @GetMapping("/test")
    @ResponseBody
    public Users personalPage() {
        return userService.getUserById(1);
    }
}
```

这时访问 `http://localhost:8080/test` 就能得到用户 id 为 1 的用户数据返回了：

```json
{
    "id": 1,
    "name": "张三",
    "password": "123456",
    "signature": "你好",
    "role": 1,
    "createTime": "2025-04-03T11:24:07.000+00:00",
    "updateTime": "2025-04-03T11:24:07.000+00:00"
}
```

##### 5.4 log4j2 日志

日志是项目中必不可少的关键部分，系统一旦发生问题，我们需要借助日志去排查问题，也可以通过日志去监控系统的运行状态，日志级别从高到低有 error、warn、info、debug、trace 等级别

- **error：**系统已经发生了错误，需要人工去干预修复的级别
- **warn：**一般较少使用
- **info：**用于记录系统运行状态，以便后续排查问题，比如记录用户的请求
- **debug：**开发阶段常用
- **trace：**繁杂的日志，比如框架日志，普通开发一般也用不到

可见我们常用的就 3 种级别：error、info、debug

首先我们需要排除自带的 logback 依赖，来到 `pom.xml`，找到 `spring-boot-starter-web` 依赖，添加排除项排除 `spring-boot-starter-logging`

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <exclusions>
        <exclusion>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-logging</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

这时重新启动项目，会发现之前打印的 info 级别的日志都不见了，我们添加 log4j2 的日志依赖：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-log4j2</artifactId>
</dependency>
```

重新加载 maven 依赖，下面进行日志的配置，在 `resources` 目录下新建 `log4j2.xml` 日志配置文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="fatal">
  <Properties>
    <Property name="baseDir" value="${sys:user.home}/logs"/>
  </Properties>

  <Appenders>
    <Console name="Console" target="SYSTEM_OUT">
      <!--控制台只输出level及以上级别的信息（onMatch），其他的直接拒绝（onMismatch） -->
      <ThresholdFilter level="info" onMatch="ACCEPT" onMismatch="DENY"/>
      <PatternLayout
        pattern="[%d{MM:dd HH:mm:ss.SSS}] [%level] [%logger{36}] - %msg%n"/>
    </Console>

    <!--debug级别日志文件输出-->
    <RollingFile name="debug_appender" fileName="${baseDir}/debug.log"
      filePattern="${baseDir}/debug_%i.log.%d{yyyy-MM-dd}">
      <!-- 过滤器 -->
      <Filters>
        <!-- 限制日志级别在debug及以上在info以下 -->
        <ThresholdFilter level="debug"/>
        <ThresholdFilter level="info" onMatch="DENY" onMismatch="NEUTRAL"/>
      </Filters>
      <!-- 日志格式 -->
      <PatternLayout pattern="[%d{HH:mm:ss:SSS}] [%p] - %l - %m%n"/>
      <!-- 策略 -->
      <Policies>
        <!-- 每隔一天转存 -->
        <TimeBasedTriggeringPolicy interval="1" modulate="true"/>
        <!-- 文件大小 -->
        <SizeBasedTriggeringPolicy size="100 MB"/>
      </Policies>
    </RollingFile>

    <!-- info级别日志文件输出 -->
    <RollingFile name="info_appender" fileName="${baseDir}/info.log"
      filePattern="${baseDir}/info_%i.log.%d{yyyy-MM-dd}">
      <!-- 过滤器 -->
      <Filters>
        <!-- 限制日志级别在info及以上在error以下 -->
        <ThresholdFilter level="info"/>
        <ThresholdFilter level="error" onMatch="DENY" onMismatch="NEUTRAL"/>
      </Filters>
      <!-- 日志格式 -->
      <PatternLayout pattern="[%d{HH:mm:ss:SSS}] [%p] - %l - %m%n"/>
      <!-- 策略 -->
      <Policies>
        <!-- 每隔一天转存 -->
        <TimeBasedTriggeringPolicy interval="1" modulate="true"/>
        <!-- 文件大小 -->
        <SizeBasedTriggeringPolicy size="100 MB"/>
      </Policies>
    </RollingFile>

    <!-- error级别日志文件输出 -->
    <RollingFile name="error_appender" fileName="${baseDir}/error.log"
      filePattern="${baseDir}/error_%i.log.%d{yyyy-MM-dd}">
      <!-- 过滤器 -->
      <Filters>
        <!-- 限制日志级别在error及以上 -->
        <ThresholdFilter level="error"/>
      </Filters>
      <!-- 日志格式 -->
      <PatternLayout pattern="[%d{HH:mm:ss:SSS}] [%p] - %l - %m%n"/>
      <Policies>
        <!-- 每隔一天转存 -->
        <TimeBasedTriggeringPolicy interval="1" modulate="true"/>
        <!-- 文件大小 -->
        <SizeBasedTriggeringPolicy size="100 MB"/>
      </Policies>
    </RollingFile>
  </Appenders>
  <Loggers>
    <Root level="debug">
      <AppenderRef ref="Console"/>
      <AppenderRef ref="debug_appender"/>
      <AppenderRef ref="info_appender"/>
      <AppenderRef ref="error_appender"/>
    </Root>
  </Loggers>
</Configuration>
```

这时重新运行项目，项目就会重新输出 info 级别日志了，打开 c 盘下的用户文件夹，会生成一个 logs 文件夹，里面存放了项目日志文件，如有需要，将来可打开日志文件用于排查项目问题

#### 6 用户模块

##### 6.1 封装统一返回对象

一般前后端会约定一个通用的返回对象格式，这样有利于前端封装请求接口，后端也能统一规范返回标准

首先成功和错误的状态码有很多，每次都自己去写，麻烦且容易出错，这里也是统一封装状态码成枚举值，直接调用枚举值，方便易维护，新建 `exception` 包，新建一个新的枚举类 `ExceptionEnum`

```java
package com.mall.bootmall.exception;

/**
 * 异常枚举
 */
public enum ExceptionEnum {
    NEED_USER_NAME(10001, "用户名不能为空");

    Integer code;
    String msg;

    ExceptionEnum(Integer code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
```

然后新建 common 包，这个包用于存放一些公共的封装，新建 `ApiRestResponse` 类

```java
package com.mall.bootmall.common;

import com.mall.bootmall.exception.ExceptionEnum;

/**
 * 统一返回对象
 */
public class ApiRestResponse<T> {
    private Integer code;
    private String msg;
    private T data;
    private static final int OK_CODE = 200;
    private static final String OK_MSG = "SUCCESS";

    public ApiRestResponse(Integer code, String msg, T data) {
        this.code = code;
        this.msg = msg;
        this.data = data;
    }

    public ApiRestResponse(Integer code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    /**
     * 默认请求成功
     */
    public ApiRestResponse() {
        this(OK_CODE, OK_MSG);
    }

    /**
     * 静态成功方法
     * @return 成功响应对象
     * @param <T>
     */
    public static <T> ApiRestResponse<T> success() {
        return new ApiRestResponse<>();
    }

    /**
     * 重载的静态成功方法
     * @param result 处理结果
     * @return 包含处理结果的成功响应对象
     * @param <T>
     */
    public static <T> ApiRestResponse<T> success(T result) {
        ApiRestResponse<T> response = new ApiRestResponse<T>();
        response.setData(result);
        return response;
    }

    public static <T> ApiRestResponse<T> error(ExceptionEnum ex) {
        return new ApiRestResponse<>(ex.getCode(), ex.getMsg());
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    @Override
    public String toString() {
        return "ApiRestResponse{" +
                "code=" + code +
                ", msg='" + msg + '\'' +
                ", data=" + data +
                '}';
    }
}
```

##### 6.2 注册接口

###### 6.2.1 controller 校验参数

在 `UserController` 中新建注册方法 `register`：

```java
package com.mall.bootmall.controller;

import ...

@Controller
public class UserController {
    @Autowired
    UserService userService;

    @GetMapping("/test")
    @ResponseBody
    public Users personalPage() {
        return userService.getUserById(1);
    }

    @PostMapping("/register")
    @ResponseBody
    public ApiRestResponse register(@RequestParam("userName") String userName, @RequestParam("password") String password) {
        if (!StringUtils.hasText(userName)) {
            return ApiRestResponse.error(ExceptionEnum.NEED_USER_NAME);
        }
        if (!StringUtils.hasText(password)) {
            return ApiRestResponse.error(ExceptionEnum.NEED_PASSWORD);
        }
        if (password.length() < 6) {
            return ApiRestResponse.error(ExceptionEnum.PASSWORD_TOO_SHORT);
        }

    }
}
```

在注册方法中对用户名和密码做了非空校验和返回错误响应

###### 6.2.2 service 注册业务

接着我们来到 `UserService` 接口，定义注册方法，实现注册业务

```java
package com.mall.bootmall.service;

import com.mall.bootmall.model.pojo.Users;
import org.springframework.stereotype.Service;

@Service
public interface UserService {

    Users getUserById(Integer id);

    void register(String userName, String password);
}
```

然后来到实现类 `UserServiceImpl`，对注册方法进行实现，首先实现重名校验，注册时用户名自然是不允许和数据库中的用户名重复的，但是此时 mapper 类中没有检查重名的 sql 查询，因此我们得自己去实现一个查询重名的方法，来到 `UsersMapper` 接口，定义查询重名的方法 `selectByUserName`，作用是根据用户名去查询用户，如果查到了，就证明重名了

```java
package com.mall.bootmall.model.mapper;

import com.mall.bootmall.model.pojo.Users;
import org.springframework.stereotype.Repository;

@Repository
public interface UsersMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Users record);

    int insertSelective(Users record);

    Users selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Users record);

    int updateByPrimaryKey(Users record);

    Users selectByUserName(String userName);
}
```

定义好 mapper 接口后来到 mapper 接口对应的 xml 文件，实现 sql 语句

```xml
<select id="selectByUserName" parameterType="java.lang.String" resultMap="BaseResultMap">
    select
    <include refid="Base_Column_List" />
    from users
    where name = #{username, jdbcType=VARCHAR}
</select>
```

> `<include refid="Base_Column_List" />` 是自己自定义的列名列表，将常用列名做了封装，自定义如下：
>
> ```xml
> <sql id="Base_Column_List">
>     id, `name`, `password`, signature, `role`, create_time, update_time
> </sql>
> ```
>
> 好处是省去了重复书写列名的麻烦，以及提高了后续的可维护性

回到 service 的实现类 `UserServiceImpl`，调用 mapper 实现查询：

```java
package com.mall.bootmall.service.impl;

import ...

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    UsersMapper usersMapper;

    @Override
    public Users getUserById(Integer id) {
        return usersMapper.selectByPrimaryKey(id);
    }

    @Override
    public void register(String userName, String password) {
        Users user = usersMapper.selectByUserName(userName);
        if (user != null) {

        }
    }
}
```

这里如果查到了重名，我们想的肯定是把异常返回给前端，但是这里是 service 层，不能把 controller 要做的事抢过来做，所以这里我们可以定义自定义异常，通过自定义异常将异常返回给 controller

###### 6.2.3 自定义异常处理

在 exception 包下定义自定义异常 `CustomException` 类，自定义异常类继承了 `Exception` 类，通过传入异常枚举值，构建自定义异常

```java
package com.mall.bootmall.exception;

public class CustomException extends Exception {
    private final Integer code;
    private final String msg;

    public CustomException(Integer code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    public CustomException(ExceptionEnum exceptionEnum) {
        this(exceptionEnum.getCode(), exceptionEnum.getMsg());
    }

    public Integer getCode() {
        return code;
    }

    public String getMsg() {
        return msg;
    }
}
```

返回 `UserServiceImpl` 实现类，使用自定义异常抛出错误

```java
package com.mall.bootmall.service.impl;

import ...

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    UsersMapper usersMapper;

    @Override
    public Users getUserById(Integer id) {
        return usersMapper.selectByPrimaryKey(id);
    }

    @Override
    public void register(String userName, String password) throws CustomException {
        Users user = usersMapper.selectByUserName(userName);
        if (user != null) {
            throw new CustomException(ExceptionEnum.USER_NAME_EXISTED);
        }
    }
}
```

service 接口需要同步抛出异常

```java
package com.mall.bootmall.service;

import ...

@Service
public interface UserService {

    Users getUserById(Integer id);

    void register(String userName, String password) throws CustomException;
}
```

返回 `UserController` 中，继续编写注册方法 `register`：

```java
package com.mall.bootmall.controller;

import ...

@Controller
public class UserController {
    @Autowired
    UserService userService;

    @GetMapping("/test")
    @ResponseBody
    public Users personalPage() {
        return userService.getUserById(1);
    }

    @PostMapping("/register")
    @ResponseBody
    public ApiRestResponse register(@RequestParam("userName") String userName, @RequestParam("password") String password) throws CustomException {
        if (!StringUtils.hasText(userName)) {
            return ApiRestResponse.error(ExceptionEnum.NEED_USER_NAME);
        }
        if (!StringUtils.hasText(password)) {
            return ApiRestResponse.error(ExceptionEnum.NEED_PASSWORD);
        }
        if (password.length() < 6) {
            return ApiRestResponse.error(ExceptionEnum.PASSWORD_TOO_SHORT);
        }
        userService.register(userName, password);
        return ApiRestResponse.success();
    }
}
```

这里同步抛出了自定义异常，调用 service 的 `register` 方法，如果发生自定义异常中的错误，则会抛出自定义异常，如果没有发生错误，则正常返回成功的响应

###### 6.2.4 全局异常处理

接下来对注册接口进行测试：

- 正常注册 - 成功
- 不填用户名 - 返回自定义错误响应
- 不填密码 - 返回自定义错误响应
- 密码小于6位 - 返回自定义错误响应

这些测试都没有问题，但是当填写重复用户名，就会触发 service 中的自定义异常抛出，结果是：

前台获得返回的系统异常 500：

```json
{
    "timestamp": "2025-04-03T19:05:39.169+00:00",
    "status": 500,
    "error": "Internal Server Error",
    "path": "/register"
}
```

后台控制台报错：

```sh
com.mall.bootmall.exception.CustomException: 用户名已存在
```

虽然这确实如我们所望，触发了自定义异常，但是前台获得的返回响应是不友好的，直接暴露系统错误给前台对于系统安全来说也是隐患，为了避免这种情况发生，我们需要对抛出的自定义异常进行全局处理，在 exception 包下新建 `GlobalExceptionHandler` 类，并且引入日志，记录错误日志到日志文件中

```java
package com.mall.bootmall.exception;

import com.mall.bootmall.common.ApiRestResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

@ControllerAdvice
public class GlobalExceptionHandler {
    private final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(Exception.class)
    @ResponseBody
    public Object handleException(Exception ex){
        log.error("Default Exception", ex);
        return ApiRestResponse.error(ExceptionEnum.SYSTEM_ERROR);
    }

    @ExceptionHandler(CustomException.class)
    @ResponseBody
    public Object handleCustomException(CustomException ex){
        log.error("Custom Exception", ex);
        return ApiRestResponse.error(ex.getCode(), ex.getMessage());
    }
}
```

> `@ControllerAdvice` 和 `@ExceptionHandler` 是 Spring MVC 中用于全局异常处理的两个核心注解，它们能优雅地捕获并处理控制器层抛出的异常，避免向客户端暴露不友好的错误信息
>
> `@ControllerAdvice`：定义全局异常处理类，可拦截所有 `@Controller` 或 `@RestController` 抛出的异常
>
> `@ExceptionHandler`：标注具体的异常处理方法，指定要捕获的异常类型

##### 6.3 MD5 加密

到目前为止，用户的密码是以明文的形式存储到数据库中的，这给黑客攻击数据库获取密码带来了机会，需要杜绝此种情况的发生，因此我们需要引入 MD5 对密码进行加密存储

























