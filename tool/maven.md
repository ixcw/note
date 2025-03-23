#### 1 Maven介绍

maven是项目管理工具，对项目提供构建和依赖管理。主要作用如下：

- 为项目提供了统一的管理方式，脱离IDE的束缚
- 管理项目依赖的jar包及jar包版本，自动下载、更新
- 项目的打包发布，打包为jar包或者用于web服务器的war包

#### 2 Maven项目标准结构

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/tool/maven/Maven项目标准结构.png)

#### 3 更换阿里镜像

由于maven的中央仓库位于国外，下载jar包很慢，所以更换为阿里云Maven中央仓库作为下载源，速度更快更稳定

找到 `maven安装目录\conf\settings.xml` 或者 `C:\Users\用户名\.m2\settings.xml` 文件，修改并添加以下标签：

```xml
<mirror>
    <id>aliyunmaven</id>
    <mirrorOf>central</mirrorOf>
    <name>aliyun public repository</name>
    <url>https://maven.aliyun.com/repository/public</url>
</mirror>
```

#### 4 设置本地仓库

maven默认本地仓库的位置在C盘，为了不占用太多C盘空间，可以修改位置，依然修改上述xml文件：

```xml
<localRepository>D:\Software\apache-maven-3.5.2\maven_repository</localRepository>
```

> 设置之后要想设置生效，得在IDE中再配置一下maven所用的`settings.xml`文件为上面所修改的xml文件

#### 5 项目打包

##### 5.1 jar包

maven项目打jar包是通过plugins（插件）`maven-assembly-plugin`来实现的

1. 先在`pom.xml`配置文件中添加插件：
  ```xml
  <build>
    <!--配置插件-->
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-assembly-plugin</artifactId>
        <version>2.5.5</version>
        <configuration>
          <!--指定打包的应用程序的入口类，即main函数所在的类-->
          <archive>
            <manifest>
              <mainClass>me.james.maven.ExampleMainClass</mainClass>
            </manifest>
          </archive>
          <!--all in one，在打包时会将所有项目引用到的jar包全部打包到打包的jar包中-->
          <descriptorRefs>
            <descriptorRef>jar-with-dependencies</descriptorRef>
          </descriptorRefs>
        </configuration>
      </plugin>
    </plugins>
  </build>
  ```

2. 编辑maven配置，在Goals框中填写：`assembly:assembly`，表示使用assembly插件进行装配，即打包jar包，然后运行这个配置即可
3. 打包完成后会有两个jar包一个是只有项目jar包的jar包，另一个是包含了所有引用jar包的jar包，带有后缀`jar-with-dependencies`
4. 要运行打包的jar包，可以在打包的jar包所在目录里启用cmd，使用命令`java -jar 打包的jar包包名`，即可通过指定的程序入口类运行该jar包，获得和项目运行一样的效果

##### 5.2 war包

maven项目打war包是通过plugins（插件）`maven-war-plugin`来实现的

1. 先在`pom.xml`配置文件中添加插件：

   ```xml
   <build>
     <plugins>
       <plugin>
         <groupId>org.apache.maven.plugins</groupId>
         <artifactId>maven-war-plugin</artifactId>
         <version>3.2.2</version>
       </plugin>
     </plugins>
   </build>
   ```
   
2. 指定打包方式，打包名称：

   ```xml
   <!--如果没有指定，则默认为jar-->
   <packaging>war</packaging>
   <!--指定打包名称为xxx-->
   <build>
     <finalName>xxx</finalName>
   </build>
   ```

3. 编辑maven配置，在Goals框中填写：`package`，表示使用maven的打包命令

4. 要运行war包，只需要将其拷贝到tomcat安装目录的webapps目录下，再启动tomcat，tomcat会将war包自动解压，访问`localhost:8080/项目名字/index.jsp`即可

#### 6 Maven常用命令

![](https://cdn.jsdelivr.net/gh/ixcw/note/images/tool/maven/Maven常用命令.png)