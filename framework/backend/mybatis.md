#### 1 MyBatis

重点掌握：

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/mybatis/MyBatis高级特性.png)

MyBatis是持久层框架，使用XML将SQL与程序解耦，便于维护，是JDBC的延伸、封装

#### 2 MyBatis配置文件

一般约定配置文件名为`mybatis-config.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- MyBatis约束 -->
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<!-- mybatis的主配置文件 -->
<configuration>
    <!--全局设置-->
    <settings>
        <!-- 将数据库中的下划线命名转换为驼峰命名，与实体类中的成员变量命名保持一致 -->
        <!-- 比如 goods_id => goodsId -->
        <setting name="mapUnderscoreToCamelCase" value="true"/>
    </settings>
    <!-- 配置环境,default表示选择哪个环境作为配置 -->
    <!-- 比如可增加生产环境id为prd，想切换到生产环境，修改此处default为prd即可 -->
    <environments default="mysql">
        <!-- 配置mysql的环境，不同的环境不同的id名字 -->
        <environment id="mysql">
            <!-- 配置事务类型，采用JDBC的方式对数据库事务进行commit/rollback -->
            <transactionManager type="JDBC"></transactionManager>
            <!-- 配置数据源（连接池） -->
            <dataSource type="POOLED">
                <!-- 配置连接数据库的4个基本信息 -->
                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/mybatis_demo?useUnicode=true&amp;characterEncoding=UTF-8"/>
                <property name="username" value="james"/>
                <property name="password" value="james"/>
            </dataSource>
        </environment>
        <environment id="prd">
            <transactionManager type="JDBC"></transactionManager>
            <dataSource type="POOLED">
                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://192.168.1.155:3306/mybatis_demo?useUnicode=true&amp;characterEncoding=UTF-8"/>
                <property name="username" value="james"/>
                <property name="password" value="james"/>
            </dataSource>
        </environment>
    </environments>

    <!-- 指定实体类对应的映射配置文件的位置 -->
    <mappers>
        <!--位于resources资源目录下的mappers文件夹下-->
        <mapper resource="mappers/goods.xml"/>
    </mappers>
</configuration>
```

#### 3 SqlSessionFactory & SqlSession

- SqlSessionFactory是MyBatis的核心对象，用于加载配置文件，初始化MyBatis，创建SqlSession对象，通常要保证SqlSessionFactory全局唯一，使用静态代码块对其初始化

- SqlSession是MyBatis操作数据库的核心对象，使用JDBC方式与数据库交互，SqlSession对象提供了对数据表相应的CRUD

#### 4 MyBatis工具类

1. 首先先创建工具类

   ```java
   package me.james.utils;
   
   import org.apache.ibatis.io.Resources;
   import org.apache.ibatis.session.SqlSession;
   import org.apache.ibatis.session.SqlSessionFactory;
   import org.apache.ibatis.session.SqlSessionFactoryBuilder;
   
   import java.io.IOException;
   import java.io.Reader;
   
   /**
    * MyBatis工具类，创建全局唯一的SqlSessionFactory对象
    */
   public class MyBatisUtil {
       private static SqlSessionFactory sqlSessionFactory = null;
   
       // 用静态代码块初始化SqlSessionFactory，随着类的加载而执行，而且只执行一次
       static {
           Reader reader = null;
           try {
               reader = Resources.getResourceAsReader("mybatis-config.xml");
               sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
           } catch (IOException e) {
               e.printStackTrace();
               throw new ExceptionInInitializerError(e);
           }
       }
   
       /**
        * 获取SqlSession对象
        *
        * @return
        */
       public static SqlSession openSession() {
           return sqlSessionFactory.openSession();
       }
   
       /**
        * 关闭SqlSession连接
        * POOLED是返还连接给连接池
        * UNPOOLED是直接关闭连接
        *
        * @param session
        */
       public static void closeSession(SqlSession session) {
           if (session != null) {
               session.close();
           }
       }
   }
   
   ```

2. 使用工具类

   ```java
   SqlSession session = null;
   try {
     session = MyBatisUtil.openSession();
     Connection connection = session.getConnection();
     System.out.println(connection);
   } catch (Exception e) {
     e.printStackTrace();
   } finally {
     MyBatisUtil.closeSession(session);
   }
   ```

#### 5 数据查询步骤

1. 根据数据库表编写实体类

2. 创建对应实体类的xml配置文件，说明实体类和数据库表的映射关系，一般和实体类命名保持一致，小写，比如`goods.xml`

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE mapper
           PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
           "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
   
   <!-- namespace必须唯一 -->
   <mapper namespace="goods">
       <!-- 配置查询所有，id的值是接口里具体的方法名称，resultType说明查询返回的结果类型 -->
       <select id="selectAll" resultType="com.imooc.mybatis.entity.Goods">
           select * from t_goods
       </select>
   </mapper>
   ```
   
3. 调用SqlSession的selectList或者selectOne方法查询数据，多条返回数据用selectList，单条用selectOne

   ```java
   // 如果能确保"selectAll"名称是全局唯一的，那么可以写为"selectAll"
   List<Goods> list = session.selectList("goods.selectAll");
   for(Goods g : list) {
    System.out.println(g.getTitle());
   }
   ```
   
#### 6 数据查询分类
##### 6.1 SQL传参

- 传入单个参数进行sql条件查询，传入参数可以来自于前端，或者后端自定义
  ```xml
  <select id="selectById" parameterType="Integer" resultType="com.imooc.mybatis.entity.Goods">                select * from t_goods where goods_id = #{value}
  </select>
  ```
  调用：
  ```java
  Goods goods = session.selectOne("goods.selectById", 1602);
  System.out.println(goods.getTitle());
  ```
  
- 传入多个参数的情况

  ```xml
  <select id="selectByPriceRange" parameterType="java.util.Map"                                               resultType="com.imooc.mybatis.entity.Goods">
    select * from t_goods
    where
    current_price between #{min} and #{max}
    order by current_price
    limit 0, #{limit}
  </select>
  ```

  调用：

  ```java
  Map param = new HashMap();
  param.put("min", 100);
  param.put("max", 500);
  param.put("limit", 10);
  List<Goods> list = session.selectList("selectByPriceRange", param);
  for (Goods goods : list) {
    System.out.println(goods.getCurrentPrice);
  }
  ```

##### 6.2 接收返回结果

- 返回多个参数的情况，用Map接收，结果是HashMap对象，但是这样的HashMap的结果是乱序的，因为hash值不稳定，因此改用LinkedHashMap，插入的数据顺序与插入时顺序一致，key是字段名，value是字段对应的值，字段类型根据表结构自动判断，缺点是太过灵活，任何结果都可以被包装在内，缺少编译时检查，容易出错

  ```xml
  <select id="selectGoodsMap" resultType="java.util.LinkedHashMap">
    select g.*, c.category_name from t_goods g, t_category c
    where g.categoryId = c.categoryId
  </select>
  ```
  
- 如果不想采用LinkedHashMap接收，多人开发的时候，基于方便合作的需求，可以用ResultMap做结果映射，ResultMap可以将查询结果映射为复杂类型的Java对象，ResultMap适合用于用Java对象保存多表关联的查询结果，还支持对象关联查询等高级特性，要使用Java对象映射查询结果，一般是新建DTO（Data Transfer Object）对象，在不改动实体类的情况下用来拓展实体类，因为实体类一般就是和数据表字段一一对应，所以最好不要改动，采用DTO对象与查询结果对接，DTO对象里面直接new出要拓展的实体类，这样就把实体类的属性全部拿了过来，再进行拓展

   ```java
   public class GoodsDTO {
       private Goods goods = new Goods();
       private String categoryName;
       private String test;
       // getter and setter
   }
  ```

   编辑xml：

   ```xml
   <!--id：唯一标识符，type：DTO对象-->
   <resultMap id="rmGoods" type="com.imooc.mybatis.dto.GoodsDTO">
     <!--id：主键，property：属性名，column：字段名-->
     <id property="goods.goodsId" column="goods_id"></id>
     <!--除id主键外的字段用result，以此类推-->
     <result property="goods.title" column="title"></result>
     ...
   </resultMap>
   <select id="selectGoodsDTO" resultMap="rmGoods">
     select g.*, c.category_name from t_goods g, t_category c
     where g.categoryId = c.categoryId
   </select>
   ```

在Java中使用：

   ```java
   List<GoodsDTO> list = session.selectList("goods.selectGoodsDTO");
   for (GoodsDTO goodsDTO : list) {
       System.out.println(goodsDTO.getGoods().getTitle());
   }
   ```

#### 7 数据写入

##### 7.1 数据插入

修改xml
```xml
<insert id="insert" parameterType="com.imooc.mybatis.entity.Goods">
    insert into t_goods (title, sub_title, ...) values (#{title}, #{subTitle}, ...)
</insert>
```
使用：
```java
try{
  Goods goods = new Goods();
  goods.setTitle("测试商品");
  goods.setSubTitle("测试商品子标题");
  ...
  // num：本次成功插入的记录条数
  int num = session.insert("goods.insert", goods);
  session.commit();
  System.out.println(goods.getGoodsId());  //null，id没有自动回填，需要进一步配置xml
} catch (Exception e) {
     if (session != null) {
     session.rollback();
     }
     e.printStackTrace();
}
```
第一种方式是添加`selectKey`标签，获得插入记录成功后返回的自增id值
```xml
<insert id="insert" parameterType="com.imooc.mybatis.entity.Goods">
  insert into t_goods (title, sub_title, ...) values (#{title}, #{subTitle}, ...)
  <!--获取返回的主键值保存到属性里面-->
  <selectKey resultType="Integer" keyProperty="goodsId" order="AFTER">
    select last_insert_id()
  </selectKey>
</insert>
```

第二种方式是在`insert`标签里设置`useGeneratedKeys`属性为`true`，表示开启自动生成主键

```xml
<insert id="insert" parameterType="com.imooc.mybatis.entity.Goods"
        useGeneratedKeys="true" keyProperty="goodsId" keyColumn="goods_id">
  insert into t_goods (title, sub_title, ...) values (#{title}, #{subTitle}, ...)
</insert>
```

> 两种方式的区别是：
>
> - selectKey标签需要明确编写获取最新主键的SQL语句
>
> - useGeneratedKeys属性会根据数据库驱动生成对应的SQL语句
>
> 但是注意：
>
> - selectKey支持所有的关系型数据库
>
> - useGeneratedKeys只支持“自增主键”类型的数据库，不支持的数据库有Oracle，DB2等

##### 7.2 数据更新

相应的xml：

```xml
<update id="update" parameterType="com.imooc.mybatis.entity.Goods">
  update t_goods
  set title=#{title},
  sub_title=#{subTitle},
  category_id=#{categoryId}
  where goods_id = #{goodsId}
</update>
```

##### 7.3 数据删除

相应的xml：

```xml
<delete id="deleteUser" parameterType="Integer">
  delete
  from t_goods
  where goods_id = #{value}
</delete>
```

#### 8 预防SQL注入攻击

要防范SQL注入攻击，需要了解MyBatis的两种传值方式`#{}`和`${}`，区别如下：

- `${}`：文本替换，未经任何处理直接对SQL文本替换
- `#{}`：预编译传值，使用预编译传值就可以预防SQL注入攻击了，预编译传值会对字符中的特殊字符转义处理，会调用PreparedStatement处理SQL

既然`${}`有SQL注入攻击风险，为什么还要使用呢，因为某些场景会很方便，比如输入条件查询排序时：

```java
param.put("order", " order by title desc");
```

这样的语句用预编译就不行，得用文本替换才能生效，但是注意这里的传值得是后台自己生成的，不能交给客户端写入，以防止攻击

#### 9 工作流程

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/mybatis/MyBatis工作流程.png)

#### 10 日志管理

日志文件是用于记录系统操作事件的记录文件或文件集合，保存历史数据，是诊断问题及理解系统活动的依据。常用的有log4j和logback，它们都是同一个人开发的，也是基于SLF4J日志门面开发

1. 先在`pom.xml`中引入依赖：`logback-classic`，就可以在控制台看到日志信息了，如果需要定制则进行下一步

2. 在resources目录下新建文件`logback.xml`，文件名是强制的

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <configuration>
       <appender name="console" class="ch.qos.logback.core.ConsoleAppender">
           <!--定义日志输出格式-->
           <encoder>
               <!--时间（精确到毫秒）
                   线程
                   日志级别（按5个字符右对齐）
                   类（最多允许36个字符，如果超出则使用简写形式对类的完整路径进行压缩）
                   日志内容（换行）-->
               <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
           </encoder>
       </appender>
       <!--日志打印的根标签，level定义日志级别，级别从高到低有：
           error：错误级别，系统的故障日志
           warn：警告级别，存在风险或使用不当的日志
           info：消息级别，一般性的消息
           debug：调试级别，程序内部用于调试的信息
           trace：跟踪级别，程序运行的跟踪信息
           这里定义了debug级别，则日志输出的时候会把所有高于debug级别的日志全部输出
           一般生产环境定义info，开发环境定义debug，方便调试-->
       <root level="debug">
           <!--引用上面定义好的appender-->
           <appender-ref ref="console"/>
       </root>
   </configuration>
   ```
#### 11 动态SQL

动态SQL是指根据参数数据动态组织SQL的技术，可以使用MyBatis的where和if标签实现

```xml
<!--动态SQL，包含限制标签where if-->
<select id="dynamicSQL" parameterType="java.util.Map"
        resultType="com.imooc.mybatis.entity.Goods">
  select * from t_goods
  <!-- where 1=1 -->
  <where>
    <if test="categoryId != null">
      and category_id = #{categoryId}
    </if>
    <if test="currentPrice != null">
      and current_price &lt; #{currentPrice}
    </if>
  </where>
</select>
```

> 如果不使用where标签而直接使用where，则会出现语法错误，可以增加一个1=1的永真条件，但是很麻烦，不常用，直接用where标签，MyBatis会智能拼接满足条件的SQL语句

#### 12 缓存

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/mybatis/缓存的范围.png)

##### 12.1 一级缓存
一级缓存存在于SqlSession会话中，随着SqlSession的关闭而消失

##### 12.2 二级缓存
二级缓存存在于整个Mapper Namespace中，二级缓存默认不开启，开启后，默认所有的查询操作均使用缓存

##### 12.3 二级缓存开启办法
在mapper标签下新增cache标签进行配置：
```xml
<!-- eviction：缓存清除策略 flushInternal：刷新间隔 size：最大缓存数量 readOnly：只读 -->
<cache eviction="LRU" flushInterval="600000" size="512" readOnly="true"/>
```
- eviction：当缓存对象数量达到上限后，自动触发对应算法对缓存对象清除，这里有四种清除算法
  1. LRU：最近最久未使用算法，即移除最长时间未被使用的对象，默认使用这种算法
  2. FIFO：先进先出算法，按对象进入缓存的顺序移除
  3. SOFT：软引用算法，移除基于JVM垃圾回收器状态和软引用规则的对象
  4. WEAK：弱引用算法，比SOFT更加积极地移除
  
  >需要注意LRU更合理，3和4是基于JVM的移除，很少使用，了解即可

- flushInternal：间隔多长时间自动清空缓存，单位毫秒
- size：缓存存储的上限，用于保存对象或集合（一个集合算一个对象）的数量上限，一般不建议将集合缓存，因为集合结果多变，缓存命中率比较低
- readOnly：设置为true时，每次从缓存中取到的是缓存对象本身，效率高，为false时，取到的是缓存对象的副本，每一次取到的对象都是不同的，安全性高，一般使用true

>写操作commit后会对该namespace缓存强制清空，防止获取到的数据与数据库中的数据不一致

##### 12.4 不使用缓存
可以配置`useCache="false"`不使用缓存，一般查询全部这种返回集合的查询结果不建议放进缓存，非常浪费内存，而且未来数据表增大之后，更是如此
```xml
<select id="selectAll" ... useCache="false">
  select ...
</select>
```

##### 12.4 强制清空缓存
可以配置`flushCache="true"`强制清空缓存，在某些情况下，比如insert插入数据操作后，希望立马清空缓存，而不是等到commit后清空，就可以设置，效果和commit之后清空是一样的
```xml
<insert id="insert" ... flushCache="true">
  select ...
</insert>
```

#### 13 多表级联查询

通过对象获取其他对象的方式叫做对象关联查询，主要有一对多和多对一

- 一对多

  1. 在一的一方实体类Goods中增加多的一方实体类GoodsDetail的集合属性：

     ```java
     private List<GoodsDetail> goodsDetails;
     ```
     
  2. 编写GoodsDetail类的xml配置文件`goods_detail.xml`
     ```xml
     <mapper namespace="goodsDetail">
         <select id="selectByGoodsId" parameterType="Integer"                        resultType="com.imooc.mybatis.entity.GoodsDetail">
             select * from t_goods_detail where goods_id = #{value}
         </select>
     </mapper>
     ```
     
  3. 在Goods的xml配置文件中新增：
     
     ```xml
     <resultMap id="rmGoods1" type="com.imooc.mybatis.entity.Goods">
       <id property="goodsId" column="goods_id"></id>
       <!--得到结果后，对所有Goods对象遍历得到goods_id字段值，并代入到goodsDetail命名空间的
       selectByGoodsId的SQL中执行查询，得到商品详情的集合后赋值给goodsDetail list对象-->
       <collection property="goodsDetails" select="goodsDetail.selectByGoodsId" column="goods_id"/>
     </resultMap>
     <select id="selectOneToMany" resultMap="rmGoods1">
       select * from t_goods limit 0,1
     </select>
     ```
     
   4. 在Mybatis配置文件`mybatis-config.xml`中添加mapper映射配置

      ```xml
      <mappers>
        <mapper resource="mappers/goods.xml"/>
        <mapper resource="mappers/goods_detail.xml"/>
      </mappers>
      ```

   5. 在Java中查询

      ```java
      List<Goods> list = session.selectList("goods.selectOneToMany");
      for(Goods goods : list) {
        System.out.println(goods.getTitle() + ":" + goods.getGoodsDetails().size());  // 商品名称:11
      }
      ```

      

- 多对一

  1. 在GoodsDetail中增加Goods属性

     ```java
     private Goods goods;
     ```

   2. 在`goods_detail.xml`增加对象关联的描述
  
      ```xml
      <resultMap id="rmGoodsDetail" type="com.imooc.mybatis.entity.GoodsDetail">
        <id column="gd_id" property="gdId"/>
        <!--只要符合下划线驼峰命名对应，就不需要写result，但是这里因为用了association，goods_id会优先赋值给
        goods，所以需要手动写result，完成字段映射-->
        <result column="goods_id" property="goodsId"/>
        <!--association从多的一方关联到一的一方，查询得到结果后，得到goods_id字段值，并代入到goods命名空间的
              selectById的SQL中执行查询，将查询得到goods赋值给GoodsDetail的goods属性-->
        <association property="goods" select="goods.selectById" column="goods_id"></association>
      </resultMap>
      <select id="selectManyToOne" resultMap="rmGoodsDetail">
        select * from t_goods_detail limit 0,1
      </select>
      ```
  
   3. 在Java中查询
  
      ```java
      List<GoodsDetail> list = session.selectList("goodsDetail.selectManyToOne");
      for(GoodsDetail gd : list) {
        System.out.println(gd.getGdPicUrl() + ":" + gd.getGoods().getTitle());
      }
      ```

#### 14 分页
##### 14.1 PageHelper分页插件
[如何使用分页插件](https://pagehelper.github.io/docs/howtouse/)

##### 14.2 数据库分页原理
- mysql

  ```sql
  -- 10：起始行号 20：起始行号后取多少条记录
  select * from tb_name limit 10,20;
  ```

- oracle

  三层查询，比较麻烦

#### 15 C3P0连接池

#### 16 批处理

#### 17 注解开发
![](https://cdn.jsdelivr.net/gh/ixcw/note/images/framework/backend/mybatis/常用注解.png)