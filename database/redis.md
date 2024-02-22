#### 1 Redis简介

- redis是key-value型的nosql数据库，not only sql
- redis将数据存在内存中，同时也能将数据持久化到磁盘上
- redis常用于缓存，利用内存的高效提高程序的处理速度

#### 2 Redis安装

- Linux

  提前安装好gcc编译器，然后执行下面的命令

  ```sh
  wget https://download.redis.io/releases/redis-6.2.1.tar.gz
  tar xzf redis-6.2.1.tar.gz
  cd redis-6.2.1
  make
  ```
  之后可以在redis安装目录下用命令启动
  
  ```sh
  ./src/redis-server redis.conf
  ```
- Windows

  redis本身不支持windows，但是微软为其提供了支持，只是已经很久没有更新了，可用来学习，生产环境用linux版本的redis

  可以到github下载：https://github.com/MicrosoftArchive/redis/releases，下载好后解压，双击`redis-server.exe`就可以运行了，如果想加载指定配置文件，可以在redis目录下用命令行启动

  ```cmd
  redis-server redis.windows.conf
  ```

#### 3 守护进程

由于直接用命令启动redis，redis是在命令行的前台运行的，退出后redis就停止运行了，很不方便，因此需要让redis在后台运行

1. 编辑redis的配置文件`redis.conf`

   ```sh
   vim redis.conf
   ```

   找到守护进程设置，改为yes

   ```config
   ################################# GENERAL #####################################
   
   # By default Redis does not run as a daemon. Use 'yes' if you need it.
   # Note that Redis will write a pid file in /var/run/redis.pid when daemonized.
   # When Redis is supervised by upstart or systemd, this parameter has no impact.
   daemonize no
   ```

2. 此时再用命令启动，redis就会在后台运行了，不会随着退出或终端关闭而结束运行

   ```sh
   ./src/redis-server redis.conf
   ```
3. redis安装目录的src目录下有redis客户端`redis-cli`，可以运行它与redis交互，输入exit可以退出

   ```sh
   ./src/redis-cli
   ```

   可以输入ping检查redis服务是否正常，PONG就是正常

   ```sh
   127.0.0.1:6379> ping
   PONG
   ```
   
   可以利用客户端正常关闭redis服务

   ```sh
   ./src/redis-cli shutdown
   ```

#### 4 Redis基本配置

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/database/redis/redis常用配置.png)

修改`redis.conf`配置文件可以修改常用配置
- port

  port默认端口是6379，不过不建议使用默认端口，容易受到黑客攻击

  ```sh
  port 6379
  ```
  修改端口后redis的客户端访问时需要指定修改的端口，否则会不能访问，因为默认访问的是6379端口
  ```sh
  ./src/redis-cli -p 6380
  ```
  
- logfile

  logfile默认是空的，可以修改为

  ```sh
  logfile "redis.log"
  ```

  这时启动redis后就会在redis安装目录下生成`redis.log`日志文件

- databases

  redis默认有16个数据库，名字是数字，从0开始，可以用select命令选择想用的数据库，超过15会报越界错误，如果觉得16个不够用，可以修改配置文件进行扩展，最多255个，选择范围就是 0 ~ 254

  ```sh
  databases 16
  ```

- dir

  指定数据文件存储目录，默认是`./`，即当前redis安装目录，一般不用修改

- requirepass

  可以给redis设置密码，把requirepass取消注释，修改密码

  ```sh
  requirepass 123456
  ```

  然后正常启动redis服务，通过客户端交互时，先输入密码认证，然后才可以交互

  ```sh
  ./src/redis-cli -p 6380
  127.0.0.1:6380> auth 123456
  OK
  ```

#### 5 Redis通用命令

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/database/redis/redis通用命令.png)

- 不同编号的数据库保存的数据彼此独立

- set重复设置会覆盖以前的值

- keys查询结果只显示key不显示value

  ```sh
  keys * # 查询所有的key
  ```
  
- expire设置key的过期时间，从expire命令生效的时间开始计算，单位s

  ```sh
  expire name 30
  ```

  结合ttl来使用，ttl查看剩余过期时间

  ```sh
  ttl name # (integer) 22
  ttl name # (integer) 18
  ttl name # (integer) 9
  ```
#### 6 Redis数据类型

redis有5种数据类型，String、Hash、List、Set、Zset，下面分别讲解

- String 字符串

  ![](https://cdn.jsdelivr.net/gh/ixcw/note/images/database/redis/redis字符串命令.png)

  > incr/decr/incrby/decrby只能对数字类型的字符串使用，对不是数字类型的字符串使用会报错

- Hash 哈希

  hash类型用于存储结构化类型的数据，它的值可以存储键值对

  ![](https://cdn.jsdelivr.net/gh/ixcw/note/images/database/redis/redis哈希命令.png)

  > hdel只能删除哈希类型的值里面的指定键值，不能删除整个哈希类型的键值，需要整个删除使用del
  >
  > hlen返回哈希类型里面有多少个属性

- List 集合列表

  ![](https://cdn.jsdelivr.net/gh/ixcw/note/images/database/redis/redis列表命令.png)
  从右或左插入元素

  ![](https://cdn.jsdelivr.net/gh/ixcw/note/images/database/redis/redis列表命令1.png)
  从右或左删除元素，一次删一个

  > list按插入的顺序排序，最大长度是2的32次方-1，约为40亿
  >
  > 可以用lrange查看list
  >
  > ```sh
  > lrange list 0 -1 # 0为开始位置，-1表示结尾位置
  > ```

- Set 集合和Zset有序集合

  set集合是字符串的无序集合，zset是有序集合，它们的元素都不可重复，set不常用

  ```sh
  sadd set1 a # 创建set1集合，添加元素a
  smembers set1 # 查询set1集合中的元素
  sinter set1 set2 # 查询两个集合的交集
  sunion set1 set2 # 查询两个集合的并集
  sdiff set1 set2 # 查询两个集合的差集，set1有set2无
  
  zadd zset1 100 a # 创建zset1集合，添加100作为分数进行排序
  zadd zset1 101 b
  zadd zset1 99 c
  zrange zset1 0 -1 # c a b
  zrange zset1 0 -1 withscores # c 99 a 100 b 101
  zrangebyscore zset1 100 101 # a b
  ```

#### 7 Jedis

实际应用中，不管是mysql、oracle还是redis，都不会直接和数据库进行交互，而是通过与编程语言结合的方式，通过编程语言去操作数据库，Java里面操作redis的工具就是jedis，jedis是用java开发的redis客户端工具包，只是对redis命令的封装

1. 默认情况下，redis出于安全考虑，只允许本地访问，为了可以远程访问，需要修改redis配置文件

   ```sh
   vim redis.conf
   ```

   关闭保护模式，yes改为no

   ```sh
   protected-mode no
   ```

   修改绑定的本地ip地址，`127.0.0.1`改为`0.0.0.0`，表示所有ip的主机都可以访问，但是生产环境不要这样写，应该指定特定的ip地址，防止别的机器连进来

   ```sh
   bind 0.0.0.0
   ```

2. 修改防火墙，开放6379端口

   ```sh
   firewall-cmd --zone=public --permanent --add-port=6379/tcp
   firewall-cmd --reload
   ```

3. 访问redis官网，找到client，选择java，访问jedis在github的项目，找到maven坐标，就可以在maven项目中使用了

4. 打开idea创建maven项目，引入jedis坐标，就可以编写java代码了，jedis的方法名和redis命令名几乎是一样的

   ```java
   package com.heeh.jedis;
   
   import redis.clients.jedis.Jedis;
   
   import java.util.HashMap;
   import java.util.List;
   import java.util.Map;
   
   public class JedisTestor {
       public static void main(String[] args) {
           try (Jedis jedis = new Jedis("192.168.74.130", 6379)) {
               jedis.select(2);
               System.out.println("redis连接成功");  //redis连接成功
               //字符串
               jedis.set("sn", "7788-2299");
               String sn = jedis.get("sn");
               System.out.println(sn);  //7788-2299
               jedis.mset(new String[]{"title", "奶粉", "num", "20"});
               List<String> list = jedis.mget(new String[]{"sn", "title", "num"});
               System.out.println(list);  //[7788-2299, 奶粉, 20]
               Long num = jedis.incr("num");
               System.out.println(num);  //21
               //Hash
               jedis.hset("student:3312", "name", "张三");
               String name = jedis.hget("student:3312", "name");
               System.out.println(name);  //张三
               Map<String, String> studentMap = new HashMap<>();
               studentMap.put("name", "李四");
               studentMap.put("age", "18");
               studentMap.put("id", "3313");
               jedis.hmset("student:3313", studentMap);
               Map<String, String> smap = jedis.hgetAll("student:3313");
               System.out.println(smap);  //{name=李四, age=18, id=3313}
               //List
               jedis.del("letter");
               jedis.rpush("letter", new String[]{"d", "e", "f"});
               jedis.lpush("letter", new String[]{"c", "b", "a"});
               List<String> letter = jedis.lrange("letter", 0, -1);
               System.out.println(letter);  //[a, b, c, d, e, f]
               jedis.rpop("letter");
               jedis.lpop("letter");
               letter = jedis.lrange("letter", 0, -1);
               System.out.println(letter);  //[b, c, d, e]
           } catch (Exception e) {
               e.printStackTrace();
           }
       }
   }
   ```
   >redis保存中文及特殊符号采用Unicode进行存储，底层默认使用utf-8，utf-8中一个中文使用3个字节表达，所以在`redis-cli`中查询时中文的结果是Unicode编码，形如`"\xe5\xbc\xa0\xe4\xb8\x89"`，中文意思是`张三`，`\xe5`表示一个字节，这样存储可以避免中文乱码，jedis从redis中取出数据时会把Unicode转换为中文


#### 8 利用Redis缓存数据

1. 创建实体类`Goods`，添加数据模拟从数据库中取出了数据

2. 将对象序列化为json，保存到redis，取出时再反序列化为对象，在`pom.xml`中添加fastjson用于处理json，fastjson 是一个java库，可以将java对象转换为json格式，当然它也可以将json字符串转换为java对象

   ```java
   package com.heeh.jedis;
   
   import com.alibaba.fastjson.JSON;
   import com.heeh.entity.Goods;
   import redis.clients.jedis.Jedis;
   
   import java.util.ArrayList;
   import java.util.List;
   import java.util.Scanner;
   
   public class CacheSample {
       public CacheSample() {
           Jedis jedis = new Jedis("192.168.74.130", 6379);
           try {
               List<Goods> goodsList = new ArrayList<>();
               goodsList.add(new Goods(8818, "红富士苹果", "", 3.5f));
               goodsList.add(new Goods(8819, "广东芒果", "", 3.5f));
               goodsList.add(new Goods(8820, "进口荔枝", "", 3.5f));
               jedis.select(3);
               for (Goods goods : goodsList) {
                   String json = JSON.toJSONString(goods);
                   System.out.println(json);
                   String key = "goods:" + goods.getGoodsId();
                   jedis.set(key, json);
               }
           } catch (Exception e) {
               e.printStackTrace();
           } finally {
               jedis.close();
           }
       }
   
       public static void main(String[] args) {
           new CacheSample();
           System.out.println("请输入要查询的商品编号：");
           String goodsId = new Scanner(System.in).next();
           Jedis jedis = new Jedis("192.168.74.130", 6379);
           try {
               jedis.select(3);
               String key = "goods:" + goodsId;
               if (jedis.exists(key)) {
                   String json = jedis.get(key);
                   System.out.println(json);
                   Goods goods = JSON.parseObject(json, Goods.class);
                   System.out.println(goods.getGoodsId());
                   System.out.println(goods.getGoodsName());
                   System.out.println(goods.getDescription());
                   System.out.println(goods.getPrice());
               } else {
                   System.out.println("您输入的商品编号不存在，请重新输入！");
               }
           } catch (Exception e) {
               e.printStackTrace();
           } finally {
               jedis.close();
           }
       }
   }
   ```