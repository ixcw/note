#### 1 Spring简介

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/SpringIoC.png)

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/SpringAOP.png)

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/SpringJDBC声明式事务.png)

- IoC（Inverse of Control）控制反转，将控制权交由别人控制，是一种设计理念，由代理人来创建管理对象，消费者通过代理人获取对象，目的是为了降低对象之间的耦合，加入IoC容器将对象统一管理
- DI（Dependency Injection）依赖注入，IoC是设计理念，是程序设计遵循的标准，是宏观的目标，而DI则是具体的技术实现，是微观实现，可理解为IoC的具体实现，在运行时完成对象的创建绑定工作，在Java中利用反射技术实现对象注入
- 狭义的Spring指Spring框架，广义的Spring指Spring生态体系，Spring IoC负责创建管理对象，并在此基础上拓展功能，比如AOP

#### 2 传统开发的缺点
对象直接引用导致对象硬性关联，难以维护，对象是直接new出来的，比如new一个service，然后在service里面又new一个dao，如果将来dao变了，又要去修改service的源码，然后编译测试发布上线，整套流程繁琐复杂，如果采用spring，则由spring ioc创建管理对象的依赖，使用者直接从ioc容器提取就可以了
![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/springioc容器.png)

ioc容器相当于在内存里开辟了一段空间，由spring管理，上图中A对象依赖于B对象，ioc容器通过反射技术将A的依赖B注入到A中

下面通过例子说明：

```java
// 苹果实体类
public class Apple {
    private String title;
    private String color;
    private String origin;

    // 有参和无参构造方法，getter 和 setter
}

// 孩子实体类
public class Child {
    private String name;
    private Apple apple;
  
    // 有参和无参构造方法，getter 和 setter
  
    public void eat() {
        System.out.println(name + "吃到了" + apple.getOrigin() + "种植的" + apple.getTitle());
    }
}

// 应用类
public class Application {
    public static void main(String[] args) {
        Apple apple1 = new Apple("红富士", "红色", "欧洲");
        Apple apple2 = new Apple("青苹果", "绿色", "中亚");
        Apple apple3 = new Apple("金帅", "黄色", "中国");
        Child lily = new Child("莉莉", apple1);
        Child andy = new Child("安迪", apple2);
        Child luna = new Child("露娜", apple3);
        lily.eat();  // 莉莉吃到了欧洲种植的红富士
        andy.eat();  // 安迪吃到了中亚种植的青苹果
        luna.eat();  // 露娜吃到了中国种植的金帅
    }
}
```

在这个例子中：

1. 如果随着季节变化，苹果类发生了变化，由于这里的苹果类的信息是写死在代码里的，那么势必要修改源码，这是很麻烦的，需要重新编译发布上线
2. 苹果对象的数量是固定写死的，这里是3个，如果将来想新增种类，增加个数，也要修改源码
3. 对象之间是硬关联的，在这个例子中，苹果对象通过构造方法生成然后赋值到孩子对象，这种关系在程序编译时就已经确定了，想要修改，只能**修改源码**

可见，一旦需求发生变化，像这种硬关联写死的代码，修改维护起来非常麻烦

#### 3 引入IoC

1. 在`pox.xml`引入`spring-context`，这是spring的上下文的模块，这是使用ioc的最小依赖范围

    ```xml
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context</artifactId>
      <version>5.2.1.RELEASE</version>
    </dependency>
    ```
    
2. 在resources资源目录下新建配置文件`applicationContext.xml`，这是ioc的核心配置文件，所有对象的创建关联在这里完成，开头的约束可以访问spring官网https://spring.io/获取，在spring core的文档的`The IoC Container` => `Configuration Metadata`可以找到，粘贴约束后idea会提示configure application context，按照提示完成即可，idea就会知道当前工程引入了spring，会提供优化支持

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://www.springframework.org/schema/beans
            https://www.springframework.org/schema/beans/spring-beans.xsd">
    
        <!--在IoC容器启动时，由spring自动实例化一个apple对象，将其取名为sweetApple，然后放到IoC容器中-->
        <bean id="sweetApple" class="com.heeh.spring.ioc.entity.Apple">
            <property name="title" value="红富士"/>
            <property name="color" value="红色"/>
            <property name="origin" value="欧洲"/>
        </bean>
    
        <bean id="sourApple" class="com.heeh.spring.ioc.entity.Apple">
            <property name="title" value="青苹果"/>
            <property name="color" value="绿色"/>
            <property name="origin" value="中亚"/>
        </bean>
    
        <bean id="softApple" class="com.heeh.spring.ioc.entity.Apple">
            <property name="title" value="金帅"/>
            <property name="color" value="黄色"/>
            <property name="origin" value="中国"/>
        </bean>
    </beans>
    ```

    ioc容器启动后，ioc容器中将会创建3个对象，分别是sweetApple、sourApple、softApple

    >也有用name代替bean的id的：
    >
    >- 相同点
    >
    > 都是设置对象在ioc容器中的唯一标识，两者在同一个配置文件中都不允许重复
    >
    > 但是在不同配置文件中允许重复，只是新创建的重名对象会覆盖掉旧的对象
    >
    >- 不同点
    >
    > id的要求更严格，一次只能定义一个对象标识（更推荐）
    >
    > name更宽松，一次可以定义多个对象标识，可以通过逗号或空格隔开，比如`name="apple1,apple2"`
    >
    >如果bean里面没有id也没有name，那么ioc就会使用全类名作为对象标识，获取bean时也使用全类名获取
    
3. 配置好配置文件后，就可以使用ioc容器了

    ```java
    public class SpringApplication {
        public static void main(String[] args) {
            // 加载指定的xml配置文件来初始化ioc容器，context就指代ioc容器
            ApplicationContext context = new 
            ClassPathXmlApplicationContext("classpath:applicationContext.xml");
            // 从ioc容器中获取创建好的对象，参数说明bean的id、类型
            // 如不说明类型，则返回的是Object，需要强制类型转换，用得较少
            // Apple sweetApple = (Apple) context.getBean("sweetApple");
            Apple sweetApple = context.getBean("sweetApple", Apple.class);
            System.out.println(sweetApple.getTitle());  // 红富士
        }
    }
    ```
    

可以看出，不需要通过new的方式主动去创建实例，而是通过**配置的方式**让ioc容器帮我们创建，我们只需要获取创建好的对象就可以了，修改维护的时候也**不需要去修改源码**，而是直接去**修改配置文件**就行了



获取context的参数叫做路径表达式，意思是加载类路径下的指定xml配置文件，需要注意源代码的resources目录并不是类路径，target目录下的classes目录才是，编译后resources目录下的xml文件会放到classes目录下，如果想一次性加载多个配置文件，可以定义字符串数组，作为参数传入

```java
String[] configLocations = new 
String[] {"classpath:applicationContext.xml", "classpath:applicationContext-1.xml"};
ApplicationContext context = new ClassPathXmlApplicationContext(configLocations);
```

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/spring路径表达式.png)

4. ioc容器还可以维护对象之间的关联关系，继续在`applicationContext.xml`中配置bean，这里apple属性由于是一个apple对象，这里就不直接赋值了，而是指明这里引用的是哪一个对象，ioc容器会通过反射技术将对象赋予到apple属性中

    ```xml
    <bean id="lily" class="com.heeh.spring.ioc.entity.Child">
      <property name="name" value="莉莉"/>
      <property name="apple" ref="sweetApple"/>
    </bean>
    
    <bean id="andy" class="com.heeh.spring.ioc.entity.Child">
      <property name="name" value="安迪"/>
      <property name="apple" ref="sourApple"/>
    </bean>
    
    <bean id="luna" class="com.heeh.spring.ioc.entity.Child">
      <property name="name" value="露娜"/>
      <property name="apple" ref="softApple"/>
    </bean>
    ```

    这时就可以获取到孩子对象了

    ```java
    Child lily = context.getBean("lily", Child.class);
    Child andy = context.getBean("andy", Child.class);
    Child luna = context.getBean("luna", Child.class);
    lily.eat();  // 莉莉吃到了欧洲种植的红富士
    andy.eat();  // 安迪吃到了中亚种植的青苹果
    luna.eat();  // 露娜吃到了中国种植的金帅
    ```

    这里在代码层面没有描写对象的关联关系，却起到了对象关联的效果，这都是在配置文件中配置完成的，ioc容器在启动过程中根据配置文件中的配置进行动态初始化以及动态绑定，这些是利用java的反射技术完成的，ioc的目的就在于提高程序的可维护性，因为就编写代码的复杂麻烦程度来说，ioc并没有更简单，但是可维护性大大提高，对象间的关系通过反射技术动态设置，非常灵活，就在这里的例子来说，如果想增加苹果种类，只需要在配置文件中配置相应的bean，然后修改孩子bean的对象引用，不用修改源代码就达到了新增苹果种类，改变孩子口味喜好的目的

#### 4 初始化IoC

bean的配置方式有三种，通过xml配置，基于注解配置，基于Java Config配置，本质都是告诉ioc容器如何管理配置bean

上面配置bean的方式就是通过xml的方式来配置bean，需要注意bean标签里面的property不是必须的，如果不写，则是通过bean的无参构造函数创建对象

- 如果想通过有参构造方法实例化对象则可以如下配置，通过构造方法实例化对象是用得最多的

    ```xml
    <bean id="apple1" class="com.heeh.spring.ioc.entity.Apple">
      <constructor-arg name="title" value="金帅"/>
      <constructor-arg name="color" value="黄色"/>
      <constructor-arg name="origin" value="中国"/>
    </bean>

    <!--或者是-->

    <bean id="apple2" class="com.heeh.spring.ioc.entity.Apple">
      <constructor-arg index="0" value="金帅"/>
      <constructor-arg index="1" value="黄色"/>
      <constructor-arg index="2" value="中国"/>
    </bean>
    ```

    更推荐使用name而不是index索引位置，因为可以减少出错概率，如果bean的属性里面包含了数字类型，则value可以通过字符串的形式设置，`value="19.8"`，**ioc容器会自动将字符串类型的数字转换为对应数字类型的类型**，赋值给有参构造函数，创建对象

- 通过静态工厂的方式创建对象

    1. 编写静态工厂类

       ```java
       /**
        * 静态工厂通过静态方法创建对象，对外隐藏了创建对象的细节
        */
       public class AppleStaticFactory {
           public static Apple createSweetApple() {
               Apple apple = new Apple();
               apple.setTitle("红富士");
               apple.setColor("红色");
               apple.setOrigin("欧洲");
               return apple;
           }
       }
       ```

    2. 配置xml

       ```xml
       <!--利用静态工厂获取对象-->
       <bean id="apple4" class="com.heeh.spring.ioc.factory.AppleStaticFactory"
             factory-method="createSweetApple"/>
       ```

       这里的class不再指向具体的实体类，而是指向静态工厂，并且说明调用的相关静态方法，这样做的好处是静态工厂对外隐藏了创建对象的细节，配置文件中只需调用静态工厂就可以获取对象了

- 通过工厂实例的方式创建对象

    1. 编写工厂实例类

       ```java
       /**
        * 工厂实例方法创建对象是指ioc容器对工厂类进行实例化，然后调用相应的实例方法创建对象
        */
       public class AppleFactoryInstance {
           public Apple createSweetApple() {
               Apple apple = new Apple();
               apple.setTitle("红富士");
               apple.setColor("红色");
               apple.setOrigin("欧洲");
               return apple;
           }
       }
       ```

    2. 配置xml

       ```xml
       <!--通过工厂实例获取对象，先获取工厂实例，然后通过工厂实例调用相应的实例方法创建对象-->
       <bean id="factoryInstance" class="com.heeh.spring.ioc.factory.AppleFactoryInstance"/>
       <bean id="apple5" factory-bean="factoryInstance" factory-method="createSweetApple"/>
       ```

不管是静态工厂还是工厂实例，由于创建对象的细节是写在代码里的，都可以更加灵活的编写业务逻辑，这是引入工厂模式的原因，但是随着spring功能的升级，这种方式用得越来越少了

#### 5 依赖注入

依赖注入是指在运行时将容器内对象利用反射赋给其他对象的操作

- 基于setter方法注入

  这个方式就是前面讲的bean里面的property标签，由于实体类编写了getter和setter方法，这里的property就是在运行时利用反射调用setter方法把value字符串值赋给name属性，如果不是静态数值，而是自定义对象，则使用ref指向对象，原理都是一样的，都是反射调用setter方法

  ```xml
  <bean id="andy" class="com.heeh.spring.ioc.entity.Child">
    <property name="name" value="安迪"/>
    <property name="apple" ref="sourApple"/>
  </bean>
  ```

- 基于构造方法注入

  这个方法就是通过构造方法实例化对象，只不过如果不是静态数据，需要使用ref指向引用的对象

  ```xml
  <bean id="andy" class="com.heeh.spring.ioc.entity.Child">
    <constructor-arg name="name" value="安迪"/>
    <constructor-arg name="apple" ref="sourApple"/>
  </bean>
  ```

#### 6 IoC在实际项目中的优势

1. 新建两个配置文件`applicationContext-service.xml`和`applicationContext-dao.xml`，模拟两个人分别开发不同模块的过程

2. 李四开发dao，定义好dao接口，编写接口实现类并将其配置到`applicationContext-dao.xml`中，将配置的bean的id告知张三，张三开发service，service类的属性包含李四开发的dao接口，张三配置配置文件`applicationContext-service.xml`，在bean中用property通过ref指向李四告知的bean的id注入了李四开发的接口实现类，在业务逻辑里面调用了接口实现类的方法，至于这个接口实现类是如何实现的张三并不关心

3. 在程序的总入口，首先获取ioc容器，将两人的配置文件都引入进来

   ```java
   ApplicationContext context = new ClassPathXmlApplicationContext("classpath:applicationContext-*.xml");
   ```

   然后调用service实现业务
   
4. 假设李四的dao这边需求发生了变化，比如数据库由mysql换成了oracle，接口实现类必然要发生变化，但是由于定义了dao接口，只需要编写新的接口实现类就行了，然后将xml中原来的bean的class属性替换为新的接口实现类，这样就完成了新需求的开发，而张三那边，由于约定的bean的id不变，张三不需要改动配置文件或代码，甚至不需要知道数据库发生了变化，李四重写了代码，整个系统就完成了升级

在这个例子中，在约定好依赖的bean的id后，两人就各自开发自己的模块，互不干扰，各自开发的对象之间进行了解耦，进而人与人之间的工作也进行了解耦，分工明确，这就是为什么spring的ioc在需要合作的开发领域这么受重视的原因

#### 7 注入集合对象

前面讲到的都是注入单个对象，但实际工作中集合是用得很多的

- List

  ```xml
  <bean id="..." class="...">
    <property name="someList">
      <list>
        <value>静态数据</value>
        <ref bean="beanid"></ref>
      </list>
    </property>
  </bean>
  ```

  > 这里注入的List是ArrayList

- Set

  ```xml
  <bean id="..." class="...">
    <property name="someSet">
      <set>
        <value>静态数据</value>
        <ref bean="beanid"></ref>
      </set>
    </property>
  </bean>
  ```

  > 这里注入的Set是LinkedHashSet，插入的数据是有序的，双向链表维护顺序

- Map

  ```xml
  <bean id="..." class="...">
    <property name="someMap">
      <map>
        <entry key="k1" value="v1"></entry>
        <entry key="k1" value-ref="beanid"></entry>
      </map>
    </property>
  </bean>
  
  <!--如果不想每次注入map都要创建相应的map的bean，可以将map的bean的创建直接放到entry里面，这时的bean不用写id-->
  
  <bean id="..." class="...">
    <property name="someMap">
      <map>
        <entry key="dev-88178" value-ref="computer1"></entry>
        <entry key="dev-88179">
          <bean class="com.heeh.spring.ioc.entity.Computer">
            <constructor-arg name="brand" value="联想"/>
            <constructor-arg name="type" value="R9000P"/>
          </bean>
        </entry>
      </map>
    </property>
  </bean>
  ```

  > 这里注入的Map是LinkedHashMap，也是有序的

- Properties

  ```xml
  <bean id="..." class="...">
    <property name="someProperties">
      <props>
        <prop key="k1">v1</prop>
        <prop key="k1">v2</prop>
      </props>
    </property>
  </bean>
  ```

  > 获取数据：getProperty("k1")获取v1

#### 8 查看IoC容器中的对象

获取容器内所有bean的id，是一个字符串数组

```java
String[] beanNames = context.getBeanDefinitionNames();
for (String beanName : beanNames) {
  System.out.println(beanName);
  // 获取bean类型
  System.out.println(context.getBean(beanName).getClass().getName());
}
```

#### 9 Bean的scope属性

scope就是决定对象何时被创建以及作用范围，将决定容器中的对象数量是一个还是多个，scope默认单例（singleton），指全局共享一个对象实例，可选择多例（prototype原型），每次使用都会创建一个实例

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/singleton单例示意图.png)

上图是单例模式，ioc容器中的单例是多线程的，意味着存在线程安全问题，解决办法是加锁，或者采用多例，经验是如果对象在运行过程中不会变化就采用单例，如果会发生变化则采用多例

单例在ioc容器启动时就会被实例化，而多例是在调用getBean()或者对象注入时才会被实例化，也就是在需要调用的时候才会实例化

#### 10 Bean的生命周期

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/Bean的生命周期.png)

> 1. ioc容器准备初始化，解析xml文件
> 2. 调用构造方法进行对象实例化
> 3. 为对象注入属性
> 4. 调用init-method方法对对象进行初始化（），init-method是可选的
> 5. ioc容器初始化完毕，启动ioc容器
> 6. 调用bean，执行业务代码
> 7. ioc容器准备销毁，调用destroy-method方法释放资源，destroy-method也是可选的，需要自己设置调用
> 8. ioc容器销毁完毕



这里通过例子说明，假设有一个订单实体类，里面有单价、采购数量和采购总价等属性，采购总价需要通过单价和采购数量计算出来，如果在实体类里面直接定义方法计算，那么每次调用计算方法都会计算一次采购总价，而由于单价和采购数量不变，采购总价也不会变，但是却需要计算多次，这显然是不合理的，下面可以通过Bean的生命周期解决这个问题

1. 创建Order实体类

   ```java
   public class Order {
       private Float price;
       private Integer quantity;
       private Float total;
   
       public Order() {
           System.out.println("创建Order对象：" + this);
       }
   
       public void init() {
           System.out.println("init()方法执行");
           total = price * quantity;
       }
   
       public void pay() {
           System.out.println("订单金额为：" + total);
       }
   
       public Float getPrice() {
           return price;
       }
   
       public void setPrice(Float price) {
           System.out.println("设置price：" + price);
           this.price = price;
       }
   
       public Integer getQuantity() {
           return quantity;
       }
   
       public void setQuantity(Integer quantity) {
           System.out.println("设置quantity：" + quantity);
           this.quantity = quantity;
       }
   
       public Float getTotal() {
           return total;
       }
   
       public void setTotal(Float total) {
           this.total = total;
       }
   
       private void destroy() {
           System.out.println("释放与订单对象相关的资源");
       }
   }
   ```

2. 配置xml

   ```xml
   <bean id="order1" class="com.heeh.spring.ioc.entity.Order" init-method="init" destroy-method="destroy">
     <property name="price" value="19.8"/>
     <property name="quantity" value="1000"/>
   </bean>
   ```

3. 调用对象方法

   ```java
   Order order1 = context.getBean("order1", Order.class);
   order1.pay();
   ((ClassPathXmlApplicationContext)context).registerShutdownHook();
   
   // 输出结果
   // 创建Order对象：com.heeh.spring.ioc.entity.Order@553f17c
   // 设置price：19.8
   // 设置quantity：1000
   // init()方法执行
   // 订单金额为：19800.0
   // 释放与订单对象相关的资源
   ```

#### 11 基于注解配置IoC

基于xml配置虽然容易使用，但是却非常繁琐，需要在xml配置文件和代码之间来回切换，如果有大量的bean，需要书写大量的bean标签和property标签，在需要使用bean的时候也需要查阅xml配置文件找bean的id，体验很差，而注解基于声明式的原则，相当于把配置信息直接写到了代码里面，而不是 写到xml，这是很方便的，对于开发轻量级的应用更适合，注解有三种

##### 11.1 组件类型注解
声明当前类的职责与功能，Component是通用注解，其他三个职责细分

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/四种组件类型注解.png)

1. 要想使用注解，首先需要在xml中开启注解扫描，使用注解的xml和仅仅使用xml的xml的约束不同，同样在spring官网文档，找到`Annotation-based Container Configuration`，复制约束粘贴到xml中

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:context="http://www.springframework.org/schema/context"
      xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        https://www.springframework.org/schema/context/spring-context.xsd">

      <context:component-scan base-package="com.heeh"/>

    </beans>
    ```

2. 在`com.heeh`包下面创建对应的dao、service、controller，并且在相应类上打上注解，组件型注解默认beanId为类名首字母小写，如果自己定义则在注解括号里写上`@Repository("beanId")` ，不过实际工作中很少自定义，默认的就是大家一致遵循的标准，不用特别沟通，更方便

3. 编写业务代码时先获取xml，初始化ioc容器

    ```java
    ApplicationContext context = new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
    // 获取ioc容器中的beanId，以字符串数组的形式返回
    String[] ids = context.getBeanDefinitionNames();
    // 遍历ioc容器中的bean，并且打印到控制台
    for(String id : ids) {
      System.out.println(id + ":" + context.getBean(id));
    }

    // 结果
    // userDao:com.heeh.spring.ioc.dao.UserDao@15b3e5b
    // org.springframework.context....
    // org.springframework.context....
    // ...
    ```

##### 11.2 自动装配注解
根据属性特征自动注入对象

在完成了基本的注解后，还需要对属性进行注入，主要有两种属性装配注解

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/两类自动装配注解.png)

> 需要注意，@Autowired装配注解写在不同的地方，效果一样，但是原理不一样

```java
@Service
public class UserService {
  // 直接写在属性上，ioc容器会自动通过反射技术将private修饰符改为public
  // 然后对属性直接进行赋值，不再执行set方法
  // 赋值完毕后再将public改回private
  @Autowired
  private UserDao userDao;
  
  public UserService() {
    System.out.println("正在创建UserService：" + this);
  }
  
  public UserDao getUserDao() {
    return userDao;
  }
  
  // 如果装配注解写在set方法上，则自动按类型/名称对set方法的参数进行注入
  // 然后执行set方法对属性进行赋值
  // @Autowired
  public void setUserDao(UserDao userDao) {
    System.out.println("setUserDao：" + userDao);
    this.userDao = userDao;
  }
}

// 调用业务
ApplicationContext context = new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
UserService userService = context.getBean("userService", UserService.class);
System.out.println(userService.getUserDao());

// 结果
// @Autowired直接放属性上，会发现没有调用set方法：
// 正在创建UserDao：com.heeh...UserDao@66666e
// 正在创建UserService：com.heeh...UserService@88888e
// com.heeh...UserDao@66666e
// 
// @Autowired放在set方法上，就会调用set方法了：
// 正在创建UserDao：com.heeh...UserDao@66666e
// 正在创建UserService：com.heeh...UserService@88888e
// setUserDao：com.heeh...UserDao@66666e
// com.heeh...UserDao@66666e
```

一般并不推荐使用@Autowired完成注入，原因是它是按照类型注入的，如果注入的对象是通过接口开发的，那么属性必然填的是接口名称，当只有一个接口实现类的时候没有问题，如果写了多个接口实现类（需求发生变化或者本身业务需要），那么按照类型注入将不知道该匹配哪一个接口实现类，将会报错`NoUniqueBeanDefinitionException`，当然问题也可以解决，那就是想办法只留下一个接口实现类，比如将不需要的接口实现类的注解去掉，不让ioc容器管理，或者在需要注入的接口实现类上再加一个`@Primary`注解，表示这个类是最主要的需要注入的实现类，但是这些方式始终是曲线救国，最合理的方式还是像通过xml配置的一样，通过唯一的beanId唯一标识bean，而通过注解的形式就不是beanId了，而是名称

> beanId和名称本质上是一样的东西，都是对象名，但是使用beanId时，bean的接口和接口实现类的对应关系是直接在bean里面定义好的，在调用的时候，对应关系发生变化，调用者不需要知道，但是使用名称的话调用者必须知道发生了变化，否则无法通过名称定位到要调用的bean，所以通过xml配置更适合多人合作的项目



最常用的按名称注入的注解是`@Resource`，不仅可以按名称注入，不满足名称的条件下还可以按类型注入，非常全能

1. 如果设置了name属性`@Resource(name="uDao")`，那么name属性就作为名称，ioc容器会按照这个名称去匹配对应的bean

2. 如果没有设置name属性，那么ioc容器会默认以此处的属性名作为名称去匹配对应的bean

3. 如果按照名称匹配失败，那么就会自动按类型去匹配，这里就和`@Autowired`一样了

一般建议设置name或者不设置name但是要保证属性名和bean的名称一致

##### 11.3 元数据注解
更细化的辅助ioc容器管理对象

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/元数据注解.png)

> @Value可以直接在代码里面对属性注入静态数据：`@Value("数据")`，也许你会问，这样一来，都是在代码里面写死数据，还不如直接在代码里面赋值呢，答案是直接注入静态数据只是一个用法，@Value还可以将配置文件中的数据引入，这是更多的用法，下面来看一下

1. 新增一个数据配置文件`config.properties`：

    ```properties
    metaData=数据
    ```
    
2. 在xml配置文件中增加配置，通过ioc容器在初始化时加载数据配置文件

    ```xml
    <context:property-placeholder location="classpath:config.properties"/>
    ```

3. 使用注解引入数据，注入数据的原理和@Autowired是一样的（反射）

    ```java
    @Value("${metaData}")
    private String metaData;
    ```

基于注解配置总结：基于注解其实只是基于xml的一种延伸，开发体验更好，日常使用更多，但是注解是写在代码里的，想要修改还得修改源代码，正所谓鱼与熊掌不可兼得，xml固然维护方便，但是开发体验不好，注解使用方便，但是不易维护

#### 12 基于Java Config配置

这是spring3.0版本之后推出的，主要是使用java代码来替代xml文件，有如下优势：

1. 完全摆脱了xml文件，使用独立的Java类来管理对象和依赖

2. 基于注解配置相对分散，需要在每一个类上面增加注解，Java Config可对配置进行集中管理

3. 因为使用了Java代码配置，在编译时就能检查依赖，不易出错

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/JavaConfig核心注解.png)

首先，新增一个类用于替代xml文件：

```java
// 注解表示当前类是一个配置类，用于代替applicationContext.xml
@Configuration
// 作用和<context:component-scan>一样，扫描指定包下的注解
@ComponentScan(basePackage="com.heeh")
public class Config{
    // 利用方法创建对象，将返回的对象放入ioc容器，beanId就是方法名
    // 这里使用了new，也许你会问不是不要new，避免硬关联吗，但是这里是不冲突的
    // 这里的new只是为了调用构造函数创建对象，然后将其放入ioc容器，之后就由ioc容器管理了
    // 和xml是一样的
    @Bean
    public UserDao userDao() {
        UserDao userDao = new UserDao();
        return userDao;
    }
}
```

然后调用业务

```java
// 初始化ioc容器
ApplicationContext context = new AnnotationConfigApplicationContext(Config.class);
// 获取ioc容器中的beanId，以字符串数组的形式返回
String[] ids = context.getBeanDefinitionNames();
// 遍历ioc容器中的bean，并且打印到控制台
for(String id : ids) {
  System.out.println(id + ":" + context.getBean(id));
}

// 结果
// config:com.heeh...Config...@88888e
// userDao:com.heeh...UserDao@66666e
```

对象的依赖注入依靠setter方法实现，这里的注入和按名称注入一样，名称不匹配，则按类型注入，类型不匹配就报错

```java
@Bean
public UserService userService(UserDao userDao) {
  UserService userService = new UserService();
  userService.setUserDao(userDao);
  return userService;
}
```

基于Java Config配置的缺点也是显而易见的，由于配置写在了代码里面，将来维护修改也会比较麻烦，但是开发时的体验好，适合用于快速开发迭代的敏捷开发工程，Spring Boot就属于敏捷开发框架，默认基于Java Config进行配置，xml更多的用于大型的团队合作中通过xml配置将工作分开，各司其职，选择什么样的配置方式需要根据实际情况选择

#### 13 Spring Test模块

Spring Test是spring中用于测试的模块，对JUnit单元测试框架有良好的整合，可以在junit在单元测试时自动初始化ioc容器，不需要手动使用ApplicationContext

1. maven引入spring-test和junit依赖

   ```xml
   <dependency>
     <groupId>org.springframework</groupId>
     <artifactId>spring-test</artifactId>
     <version>5.2.1.RELEASE</version>
   </dependency>
   <dependency>
     <groupId>junit</groupId>
     <artifactId>junit</artifactId>
     <version>4.12</version>
     <scope>test</scope>
   </dependency>
   ```

2. 利用@RunWith和@ContextConfiguration描述测试用例类，测试用例类从ioc容器获取对象完成测试

   ```java
   import org.junit.Test;
   import org.junit.runner.RunWith;
   import org.springframework.test.context.ContextConfiguration;
   import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
   
   import javax.annotation.Resource;
   
   // 在测试用例执行前自动初始化ioc容器
   @RunWith(SpringJUnit4ClassRunner.class)
   // 加载配置文件
   @ContextConfiguration(locations = {"classpath:applicationContext.xml"})
   public class SpringTestor {
       @Resource
       private UserService userService;
   
       @Test
       public void testUserService() {
           userService.createUser();
       }
   }
   ```

#### 14 引入AOP

AOP是spring提供的可插拔组件技术，举个例子，假设系统有两个模块，一个用户模块，一个员工模块，现在有个需求，两个模块的业务处理过程中都要实现权限过滤的功能，有权限的人才能进行操作，原本的操作可能是在每个模块里面都增加权限判断的代码，这样不仅代码重复，而且如果未来需求发生变化，不需要权限过滤了，又要一个个地删除相关代码，非常麻烦，试想此时增加一个权限切面，在两个模块执行之前对权限进行拦截，模块运行结束之后又增加一个日志切面来记录运行结果，如果不需要了，直接移除切面即可，切面与模块彼此独立，非常方便，为什么叫切面呢，因为业务的执行过程就像线性的过程，切面直接穿插到这个过程中，就像一个个横切面一样，所以叫做切面

下面正式介绍AOP，Aspect Oriented Programming，面向切面编程，通常做法是将与业务无关的功能或者通用的功能抽象出来封装为切面类，通过配置的形式加入系统中，可配置在方法运行前、运行后，做到即插即用，最终目的是在不修改源码的情况下，对程序功能进行拓展，也避免了代码重复

1. 引入spring-context和aspectjweaver坐标

   ```xml
   <dependency>
     <groupId>org.springframework</groupId>
     <artifactId>spring-context</artifactId>
     <version>5.2.1.RELEASE</version>
   </dependency>
   <!--aspectjweaver是aop的底层依赖-->
   <dependency>
     <groupId>org.aspectj</groupId>
     <artifactId>aspectjweaver</artifactId>
     <version>1.8.9</version>
   </dependency>
   ```

   

2. 配置xml，到spring官网找到the aop schema，复制约束

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans https://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/aop https://www.springframework.org/schema/aop/spring-aop.xsd">
   
       <!-- bean definitions here -->
   
   </beans>
   ```

3. 创建相关的类

   ```java
   public class EmployeeDao {
     public void insert() {
       System.out.println("新增员工数据");
     }
   }
   
   public class UserDao {
     public void insert() {
       System.out.println("新增用户数据");
     }
   }
   
   public class EmployeeService {
     private EmployeeDao employeeDao;
   
     public void entry() {
       System.out.println("执行员工入职业务逻辑");
       employeeDao.insert();
     }
   
     public EmployeeDao getEmployeeDao() {
       return employeeDao;
     }
   
     public void setEmployeeDao(EmployeeDao employeeDao) {
       this.employeeDao = employeeDao;
     }
   }
   
   public class UserService {
     private UserDao userDao;
   
     public void createUser() {
       System.out.println("执行创建用户业务逻辑");
       userDao.insert();
     }
   
     public String generateRandomPassword(String type, Integer length) {
       System.out.println("按" + type + "方式生成" + length + "密码");
       return "Zxcqui1";
     }
   
     public UserDao getUserDao() {
       return userDao;
     }
   
     public void setUserDao(UserDao userDao) {
       this.userDao = userDao;
     }
   }
   
   public class SpringApplication {
     public static void main(String[] args) {
       ApplicationContext context = new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
       UserService userService = context.getBean("userService", UserService.class);
       userService.createUser();
     }
   }
   ```
   
4. 配置bean

   ```xml
   <bean id="userDao" class="com.heeh.spring.aop.dao.UserDao"/>
   <bean id="employeeDao" class="com.heeh.spring.aop.dao.EmployeeDao"/>
   <bean id="userService" class="com.heeh.spring.aop.service.UserService">
     <property name="userDao" ref="userDao"/>
   </bean>
   <bean id="employeeService" class="com.heeh.spring.aop.service.EmployeeService">
     <property name="employeeDao" ref="employeeDao"/>
   </bean>
   ```
   执行结果

   ```txt
   执行创建用户业务逻辑
   新增用户数据
   ```

5. 此时需求发生变化，需要打印方法执行时间，此时aop就排上用场了，先编写切面类

   ```java
   package com.heeh.spring.aop.aspect;
   
   import org.aspectj.lang.JoinPoint;
   
   import java.text.SimpleDateFormat;
   import java.util.Date;
   
   public class MethodAspect {
       /**
        * 切面方法，用于拓展额外功能
        * @param joinPoint 连接点，通过连接点可以获取目标类/方法的信息，目标就是要增强的类/方法
        */
       public void printExecutionTime(JoinPoint joinPoint) {
           SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
           String now = sdf.format(new Date());
           // 获取目标类的名称
           String className = joinPoint.getTarget().getClass().getName();
           // 获取目标方法名称
           String methodName = joinPoint.getSignature().getName();
           System.out.println("---->" + now + ":" + className + "." + methodName);
       }
   }
   ```

6. 配置xml

   ```xml
   <!--AOP配置-->
   <bean id="methodAspect" class="com.heeh.spring.aop.aspect.MethodAspect"/>
   <aop:config>
     <!--切点，使用表达式描述切面的作用范围，这里的表达式说明切面作用在com.heeh包下所有类的所有方法上-->
     <aop:pointcut id="pointcut" expression="execution(public * com.heeh..*.*(..))"/>
     <!--定义切面类，上面的bean定义，ioc只会把它当成普通的bean，需要在这里配置说明它是切面bean-->
     <aop:aspect ref="methodAspect">
       <!--before通知，表示在目标方法运行之前执行printExecutionTime切面方法-->
       <aop:before method="printExecutionTime" pointcut-ref="pointcut"/>
     </aop:aspect>
   </aop:config>
   ```

   运行结果

   ```txt
   ---->2021-04-09 15:21:30 188:com.heeh.spring.aop.service.UserService.createUser
   执行创建用户业务逻辑
   ---->2021-04-09 15:21:30 244:com.heeh.spring.aop.dao.UserDao.insert
   新增用户数据
   ```
   如果将来不需要这个切面功能了，修改xml配置文件即可

#### 15 AOP关键概念

AspectJ是Eclipse提供的基于Java平台的面向切面编程语言，但是aop不是完全依赖于aspectj，aop使用aspectjweaver实现类与方法的匹配，前面xml配置的范围指定就是依赖于此，aop利用代理模式实现对象运行时的功能拓展

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/AOP关键概念.png)

#### 16 JoinPoint核心方法

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/JoinPoint核心方法.png)

在切面类中新增获取目标参数信息

```java
Object[] args = joinPoint.getArgs();
System.out.println("---->参数个数：" + args.length);
for (Object arg : args) {
  System.out.println("---->参数：" + arg);
}
```

因为没有调用有参数的方法，所以此时运行结果为

```txt
---->2021-04-09 16:01:58 467:com.heeh.spring.aop.service.UserService.createUser
---->参数个数：0
执行创建用户业务逻辑
---->2021-04-09 16:01:58 504:com.heeh.spring.aop.dao.UserDao.insert
---->参数个数：0
新增用户数据
```

在应用类中增加调用

```java
public class SpringApplication {
    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
        UserService userService = context.getBean("userService", UserService.class);
        userService.createUser();
        userService.generateRandomPassword("MD5", 16);
    }
}
```

传入参数后的结果为

```txt
---->2021-04-09 16:06:04 452:com.heeh.spring.aop.service.UserService.createUser
---->参数个数：0
执行创建用户业务逻辑
---->2021-04-09 16:06:04 507:com.heeh.spring.aop.dao.UserDao.insert
---->参数个数：0
新增用户数据
---->2021-04-09 16:06:04 521:com.heeh.spring.aop.service.UserService.generateRandomPassword
---->参数个数：2
---->参数：MD5
---->参数：16
按MD5方式生成16位密码
```

获取目标参数在线上调试的时候有用，如果不知道输入的参数是什么，又需要知道的时候就可以利用getArgs()打印了

#### 17 PointCut切点表达式

前面在配置aop的时候，指明了aop的作用范围，现在来解析一下这个表达式

```xml
<aop:pointcut id="pointcut" expression="execution(public * com.heeh..*.*(..))"/>
```

见下图

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/PointCut切点表达式.png)

> public可以不写，因为默认就是public修饰的，举个例子，如果只想匹配Service类，可以这么写
>
> ```xml
> * com.heeh..*Service.*(..)
> ```

#### 18 通知类型

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/AOP五种通知类型.png)

After Returning通知在切面方法里除了`JoinPoint joinPoint`参数外需要在方法里面增加`Object ret`参数，用于接收返回值，目标方法一旦产生返回值就会由aop自动注入到ret参数中，在xml配置中需要指明用于接收返回值的参数ret

```xml
<aop:after-returning method="doAfterReturning" returning="ret" pointcut-ref="pointcut"/>
```

After Throwing通知在切面方法里除了`JoinPoint joinPoint`参数外需要在方法里面增加`Throwable th`参数，用于接收异常信息，目标方法一旦产生异常就会由aop自动注入到th参数中，在xml配置中需要指明用于接收异常的参数th

```xml
<aop:after-throwing method="doAfterThrowing" throwing="th" pointcut-ref="pointcut"/>
```

假设生产环境中系统越来越慢，如何定位到是哪一个方法执行缓慢呢？难道要为每一个方法都增加判断代码吗，这显然是不可能的，但是使用Around环绕通知可以轻松解决，Around通知可以自定义执行时机，可以执行前面四种通知类型的所有操作

1. 定义切面类

   ```java
   package com.heeh.spring.aop.aspect;
   
   import org.aspectj.lang.ProceedingJoinPoint;
   
   import java.text.SimpleDateFormat;
   import java.util.Date;
   
   public class MethodChecker {
       /**
        * @param pjp 是JoinPoint的升级版，在原有功能外，还可以控制目标方法是否执行
        * @return
        */
       public Object check(ProceedingJoinPoint pjp) throws Throwable {
           try {
               long startTime = new Date().getTime();
               // 执行目标方法，如果不写这句话，则目标方法不会执行，这里的返回值就是目标方法执行后的返回值
               Object ret = pjp.proceed();
               long endTime = new Date().getTime();
               long duration = endTime - startTime;
               if (duration >= 1000) {
                   String className = pjp.getTarget().getClass().getName();
                   String methodName = pjp.getSignature().getName();
                   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
                   String now = sdf.format(new Date());
                   System.out.println("=====" + now + ":" + className + "." + methodName +
                           "(" + duration + "ms)=====");
               }
               return ret;
           } catch (Throwable throwable) {
               System.out.println("Exception message:" + throwable.getMessage());
               throw throwable;
           }
       }
   }
   ```

2. 配置xml

   ```xml
   <bean id="methodChecker" class="com.heeh.spring.aop.aspect.MethodChecker"/>
   <aop:config>
     <aop:pointcut id="pointcut" expression="execution(* com.heeh..*.*(..))"/>
     <aop:aspect ref="methodChecker">
       <!--环绕通知-->
       <aop:around method="check" pointcut-ref="pointcut"/>
     </aop:aspect>
   </aop:config>
   ```

3. 为了测试，让方法沉睡3s

   ```java
   public void createUser() {
     try {
       Thread.sleep(3000);
     } catch (InterruptedException e) {
       e.printStackTrace();
     }
     System.out.println("执行创建用户业务逻辑");
     userDao.insert();
   }
   ```

4. 调用createUser方法，结果为

   ```txt
   新增用户数据
   =====2021-04-09 17:23:20 104:com.heeh.spring.aop.service.UserService.createUser(3066ms)=====
   ```

   这个信息将来保存到日志文件中，查看日志就可以对系统进行优化了

#### 19 基于注解配置AOP

1. 在xml配置文件中开启注解扫描

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:context="http://www.springframework.org/schema/context"
          xmlns:aop="http://www.springframework.org/schema/aop"
          xsi:schemaLocation="
           http://www.springframework.org/schema/beans
           https://www.springframework.org/schema/beans/spring-beans.xsd
           http://www.springframework.org/schema/context                                                             https://www.springframework.org/schema/context/spring-context.xsd
           http://www.springframework.org/schema/aop                                                                 https://www.springframework.org/schema/aop/spring-aop.xsd">
   
   <!--初始化ioc容器，开启注解扫描-->
   <context:component-scan base-package="com.heeh"/>
   <!--启用AOP注解模式-->
   <aop:aspectj-autoproxy/>
   
   </beans>
   ```

2. 编写注解

   ```java
   @Repository
   public class EmployeeDao {
       public void insert() {
           System.out.println("新增员工数据");
       }
   }
   
   @Service
   public class EmployeeService {
       @Resource
       private EmployeeDao employeeDao;
       ...
   }
   
   @Component
   @Aspect
   public class MethodChecker {
       /**
        * @param pjp 是JoinPoint的升级版，在原有功能外，还可以控制目标方法是否执行
        * @return
        */
       @Around("execution(* com.heeh..*Service.*(..))")
       public Object check(ProceedingJoinPoint pjp) throws Throwable {...}
   }
   ```

3. 调用业务

   ```java
   userService.createUser();
   ```

4. 执行结果

   ```txt
   执行创建用户业务逻辑
   新增用户数据
   =====2021-04-09 18:15:04 690:com.heeh.spring.aop.service.UserService.createUser(3044ms)=====
   ```

#### 20 AOP实现原理

AOP基于代理模式实现动态功能拓展，包含两种形式：

1. 目标类有接口，通过JDK动态代理实现功能拓展
2. 目标类没有接口，通过CGLib组件实现功能拓展

##### 20.1 代理模式与动态代理

代理模式是指通过代理对象对原对象实现功能拓展，静态代理通过手动创建代理类，让代理类持有目标对象的引用，同时在代理类中对原始的业务逻辑形成拓展，代理类和委托类要实现相同的接口，在代理类中持有一个委托类的对象。动态代理是在运行时通过接口的结构自动生成代理类

##### 20.2 JDK动态代理

InvocationHandler是JDK提供的反射类，用于在JDK动态代理中对目标方法进行增强，InvocationHandler实现类与切面类的环绕通知类似

##### 20.3 CGLib

CGLib是运行时字节码增强技术，Code Generation Library，AOP会通过继承目标类的方式，在运行时生成目标继承类字节码的方式进行行为拓展

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/CGLib.png)



#### 21 Spring JDBC

Spring JDBC是Spring用于处理关系型数据库的模块，对JDBC进行封装，简化了开发工作，也许你会问有了MyBatis为什么还要学这个，因为mybatis的封装程度很高，但是相对的执行效率更低，适合敏捷开发，而spring jdbc只是对原生jdbc的简单封装，而且有spring的支持，开发起来也不会难以管理，这是介于原生jdbc和mybatis之间折中的选择

1. pom引入Spring JDBC依赖

   ```xml
   <dependency>
     <groupId>org.springframework</groupId>
     <artifactId>spring-context</artifactId>
     <version>5.2.1.RELEASE</version>
   </dependency>
   <dependency>
     <groupId>org.springframework</groupId>
     <artifactId>spring-jdbc</artifactId>
     <version>5.2.1.RELEASE</version>
   </dependency>
   <dependency>
     <groupId>mysql</groupId>
     <artifactId>mysql-connector-java</artifactId>
     <version>5.1.46</version>
   </dependency>
   ```

2. xml配置DataSource数据源

   ```xml
   <!--数据源-->
   <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
     <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
     <property name="url" value="jdbc:mysql://localhost:3306/rbac-oa?useSSL=false&amp;useUnicode=true&amp;
               characterEncoding=UTF-8&amp;serverTimezone=Asia/Shanghai&amp;allowPublicKeyRetrieval=true"/>
     <property name="username" value="james"/>
     <property name="password" value="james"/>
   </bean>
   <!--JdbcTemplate提供了CRUD的API-->
   <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
     <property name="dataSource" ref="dataSource"/>
   </bean>
   ```

3. 在Dao注入JdbcTemplate对象，实现CRUD

   ```java
   public class EmployeeDao {
     private JdbcTemplate jdbcTemplate;
   
     public Employee findById(Integer employeeId) {
       String sql = "select * from adm_employee where employee_id = ?";
       Employee employee = jdbcTemplate.queryForObject(sql, new Object[]{employeeId},
                                new BeanPropertyRowMapper<Employee>(Employee.class));
       return employee;
     }
   
     public JdbcTemplate getJdbcTemplate() {
       return jdbcTemplate;
     }
   
     public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
       this.jdbcTemplate = jdbcTemplate;
     }
   }
   ```

   ```xml
   <bean id="employeeDao" class="com.heeh.spring.jdbc.dao.EmployeeDao">
     <property name="jdbcTemplate" ref="jdbcTemplate"/>
   </bean>
   ```

   ```java
   public class JdbcApplication {
     public static void main(String[] args) {
       ApplicationContext context = new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
       EmployeeDao employeeDao = context.getBean("employeeDao", EmployeeDao.class);
       Employee employee = employeeDao.findById(3);
       System.out.println(employee);
       // Employee{employeeId=3, name='王美美', departmentId=2, title='高级研发工程师', level=6}
     }
   }
   ```

#### 22 事务管理

##### 22.1 编程式事务

编程式事务是指通过代码手动提交回滚事务的事务控制方法，spring jdbc通过TransactionManager事务管理器实现事务控制，提供了commit和rollback方法

1. 配置事务管理器

   ```xml
   <!--事务管理器-->
   <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
     <property name="dataSource" ref="dataSource"/>
   </bean>
   ```

2. 在需要进行事务管理的类中注入事务管理器，配置bean注入

3. 定义事务配置，管理事务

   ```java
   // 定义事务配置
   TransactionDefinition definition = new DefaultTransactionDefinition();
   // 开始事务，返回当前事务状态
   TransactionStatus status = transactionManager.getTransaction(definition);
   try{
     ...
     transactionManager.commit(status);
   } catch(RuntimeException e) {
     transactionManager.rollback(status);
     throw e;
   }
   ```

##### 22.2 声明式事务

声明式事务是指在不修改源代码的情况下通过配置的形式自动实现事务控制，本质就是AOP环绕通知，这其实就是AOP的一个典型的应用场景，当目标方法成功执行时，自动提交事务，目标方法抛出**运行时异常**时自动回滚

配置TransactionManager事务管理器

```xml
<!--事务管理器-->
<bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
  <property name="dataSource" ref="dataSource"/>
</bean>
<!--配置事务通知，决定哪些方法使用事务-->
<tx:advice id="txAdvice" transaction-manager="transactionManager">
  <tx:attributes>
    <!--目标方法名为batchImport，启用声明式事务，成功提交，运行时异常回滚-->
    <tx:method name="batchImport" propagation="REQUIRED"/>
    <tx:method name="batch*" propagation="REQUIRED"/>
    <!--以find开头的方法不开启声明式事务-->
    <tx:method name="find*" propagation="NOT_SUPPORTED" read-only="true"/>
    <tx:method name="get*" propagation="NOT_SUPPORTED" read-only="true"/>
  </tx:attributes>
</tx:advice>
<!--定义声明式事务的作用范围-->
<aop:config>
  <aop:pointcut id="pointcut" expression="execution(* com.heeh..*Service.*(..))"/>
  <aop:advisor advice-ref="txAdvice" pointcut-ref="pointcut"/>
</aop:config>
```

##### 22.3 事务传播行为

事务传播行为是指多个拥有事务的方法在嵌套调用时的事务控制方式

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/事务传播行为.png)

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/propagation_required.png)

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/spring/propagation_requires_new.png)

##### 22.4 注解配置声明式事务

1. 配置xml

   ```xml
   <!--初始化ioc容器，开启注解扫描-->
   <context:component-scan base-package="com.heeh"/>
   <!--启用注解配置声明式事务-->
   <tx:annotation-driven transaction-manager="transactionManager"/>
   
   <!--数据源-->
   <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
     <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
     <property name="url" value="jdbc:mysql://localhost:3306/rbac-oa?useSSL=false&amp;useUnicode=true&amp;
               characterEncoding=UTF8&amp;serverTimezone=Asia/Shanghai&amp;allowPublicKeyRetrieval=true"/>
     <property name="username" value="james"/>
     <property name="password" value="james"/>
   </bean>
   <!--JdbcTemplate提供了CRUD的API-->
   <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
     <property name="dataSource" ref="dataSource"/>
   </bean>
   <!--事务管理器-->
   <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
     <property name="dataSource" ref="dataSource"/>
   </bean>
   ```

2. 在需要使用事务的类上加上`@Transactional`注解，表示将声明式事务应用于当前类的所有方法，默认传播行为REQUIRED

