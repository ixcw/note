#### 1 nestjs 介绍

nestjs 是一款基于 node 的后端开发框架

有人可能会问，我为什么一定要使用开发框架呢，直接使用原生 node 去开发后端可不可以呢？当然是可以的，只不过这就回到了老生常谈的问题，为什么要使用框架？

我们说框架其实是为了简化开发流程的，原因主要有以下两点：

1. 在原生开发时代，很多功能实现是需要我们自己去实现的，因为原生只提供了非常基础的功能，而框架对很多基础功能都做了更高层的封装，这些封装好的功能可以直接使用而不必去自己实现，这就节约了开发时间
2. 在原生开发时代，同种需求场景有不同的技术方案去实现，这就需要技术选型，不同的技术选型带来的开发体验和性能差距是不一样的，而框架是有一整套的完整配套方案的，针对每种需求场景，框架都已经帮你选好了最优的技术方案，直接使用就行，这也节约了开发时间，同时框架的选型必然是最优的，不必担心性能问题

由于 nestjs 是综合性的框架，采用了面向切面编程等优秀思想，方便拓展功能模块，并且开发语言采用了 ts， 因此，如果项目是长期需要迭代的项目，或者对性能有追求，需要多个子项目的项目，比如需要构建微服务架构，那么就很适合使用 nestjs 进行开发

> 适合使用 nodejs 开发的场景：
>
> 1. 有高并发需求，但是又对 CPU密集 不敏感的应用，比如聊天室、爬虫，CPU密集是指对CPU计算能力的依赖，聊天室等应用的瓶颈主要在于网络IO，因此是对IO密集敏感的应用，nodejs采用的是非阻塞IO模型，很适合这类应用
> 2. 没有后端人员，需要快速上线的应用，nodejs 开发后端的速度是不慢的
> 3. serverless或者前后一体的项目

nestjs 与其他常见的 node 框架有什么不同呢，我们可以对比一下 koajs 和 eggjs，为什么不对比 express 呢，因为 nestjs 默认选择了 express 作为 HTTP 服务的实现（express 具有稳定的生态），简单对比一下 npm 下载量和 github 增星的数量可知， nestjs 作为 2017 年诞生的框架，星数已经快追上 express 了（截止2024年10月，星星数 67k，已经超过了 express 的 65k）

其他方面，koa 和 express 只实现了 HTTP 服务，其他的路由等中间逻辑需要自己实现，eggjs 虽然有路由等实现，但是没有使用 ts，nestjs 使用 ts + 注解的开发方式更便捷，性能也更好

#### 2 环境配置

##### 2.1 node环境

nestjs 是基于 nodejs 的，因此想要使用 nestjs，首先需要安装 node，关于 node，可查询相关笔记

##### 2.2 数据库环境

可以使用 [phpStudy](https://xp.cn/php-study) 进行数据库的管理，软件安装后，会自动在安装目录下安装 nginx 和 MySQL 等开发软件，打开 phpStudy，这是一个图形化的操作界面

1. 在首页启动 MySQL
2. 点击左侧的数据库，选择创建数据库，第一次使用会提示先修改root用户的密码，随便修改，比如修改为 123456 即可
3. 再次点击创建数据库，就可以创建数据库了，依次输入数据库名称、用户名、密码即可创建，创建完成后，数据库列表会出现刚刚创建的数据库

##### 2.3 docker

docker 最主要的目的是解决软件运行环境的问题，使得软件部署到不同的地方依然是相同的运行环境，类似于虚拟机，但是无论是性能还是体积都远远优于虚拟机，实现方式也不一样，docker 占用的是进程，而虚拟机则同时占用了软硬件资源，模拟了一个完整的操作系统，docker 有几个核心概念：

1. Client（客户端）：这是用户直接与 docker 交互的方式，提供了一系列的 docker 命令用于和 docker 守护进程交互，常见命令如下

   ```shell
   docker build
   docker pull
   docker run
   ```

2. Host（服务端）：docker 服务端负责监听客户端发出的 docker 命令，主要是 docker daemon 守护进程进行监听的，守护进程就像一个 docker 管理员，监听到 docker 命令后去执行指定的操作，比如拉取镜像（image），组装容器（container），管理网络等

3. Hub（仓库）：docker hub 是一个任何人都可以使用的公共仓库，里面存放了大家创建的公共镜像，可以基于这些镜像创建自己的镜像，如果不想使用这个公共仓库，你也可以使用自己的私人仓库

docker 是用 go 语言编写的，利用 Linux 的内核功能使用 namespace 的技术提供容器隔离机制，下面介绍一些 docker 的运行命令

```shell
docker run -i -t ubuntu /bin/bash
```

运行此命令时，很明显我们想要运行 ubuntu 这个镜像，如果本地没有这个镜像，则 docker 会去 hub 下载，如果本地已有，则跳过下载，然后 docker 会创建一个容器，并分配读写文件系统和网络给它，最后启动容器，执行 /bin/bash，容器是交互式运行的，参数 -i -t 表示附加到终端使用终端进行交互

#### 3 cli脚手架

nestjs 官方为我们提供了 cli 脚手架工具，cli 是 command line interface 命令行界面的缩写，意思是官方提供的搭建项目的工具是通过命令行去使用的，脚手架是 cli 工具作为工程搭建工具的一种形象比喻

首先使用 npm 全局安装 9.0.0 版本的 nestjs cli 脚手架

```sh
npm install -g @nestjs/cli@9.0.0
```

安装完成后检查 nest 版本，输出 9.0.0 即为成功

```sh
nest --version
```

然后选择一个文件夹用于存放项目文件，就可以开始创建 nest 项目了

```sh
nest new nest-demo
```

接着 cli 工具会询问使用哪一种包管理工具，这里我们选择 pnpm，稍等片刻，命令行就会提示创建成功，使用如下命令开启 nest 项目

```sh
cd nest-demo
pnpm run start
```

开启成功后用浏览器访问 `http://localhost:3000/` ，就会得到返回的文本 "Hello World!"

cli 脚手架可以通过命令查看帮助，直接通过命令生成 class、controller 等代码文件，非常方便

```sh
nest --help
```

#### 4 RESTful api

说到这个肯定是不陌生的，RESTful 并不是一个单词，而是 representation state transfer 的缩写，翻译过来是表现状态转移，乍一听这什么玩意儿，其实仔细一想，这是一种接口风格，是前后端遵守的一种风格、规范。为什么需要遵守规范呢，想一想就像不同的计算机之间想要通信，就需要通过网络进行连接，而连接网络需要遵守同一个规范（比如HTTP协议），才能进行通信，因此，前后端如果想要通信，必然需要遵守同一种规范，Restful api 就是这样的一种规范

representation 代表了一种表现形式，不管是前端的数据还是后端的数据，都需要一种表现形式，而 transfer 表示从后端状态的表示转移到前端状态的表示，所以简单来说，这就是一种需要前后端都需要遵守的接口风格，以更方便的进行前后端的通信

常见请求方法有 POST、GET、PUT、DELETE，更多相关知识可以查看相关文档

#### 5 工程目录及命名约定

不知道各位有没有听过一句话，叫做 “约定大于配置”，如何理解呢，约定是大家都一致同意的规范，如果大家都遵守同一个约定，那么办起事来必然是事半功倍的，因为少了很多的沟通成本和调错成本，python 语言就是这样的一种编程语言，里面有许多默认的约定，大家都遵守一种约定（比如 python 的代码缩进约定），使得 python 的代码看起来简洁而优雅，试想如果没有约定，仅靠配置去约束，那代码风格必然千奇百怪，不同的配置，也将花费更多的心力去维护，nest 就是约定大于配置的后端框架，如果大家对工程目录以及文件命名等进行一致的约定，即使是不同的 nest 项目维护起来，必然也是更加轻松的

下面来看 nest 项目的常见约定

**工程目录：**

根据 nest 原作者说法，工程目录应该形如下面约定：

```sh
- src
  - core
  - common
    - middleware
    - interceptors
    - guards
  - user
    - interceptors(scoped interceptors)
    - user.controller.ts
    - user.model.ts
  - store
    - store.controller.ts
    - store.model.ts
```

上面的工程目录可能是一个商店的应用

- core 目录一般存放核心代码，比如鉴权
- common 目录用于存放公共代码，比如中间件、拦截器、守卫等
- 没有模块目录，按照功能划分目录，比如用户、商店目录
- 一个仓库创建多个子项目，子项目之间共享一些库/包

**代码风格：**

类似于 angular 的代码风格，总则：

- 坚持一个文件只定义一个东西（比如服务或组件，不要混合起来），考虑将文件大小限制在400行以内
- 坚持定义简单函数，考虑限制在75行之内

更多详情请参考 angular 官方的 [风格指南](https://angular.cn/style-guide)

#### 6 创建模块

首先打开项目里的 `app.controller.ts` 文件，可以照着注解写一个路由，如下：

```ts
import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller('api')
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('app')
  getApp(): object {
    return {
      code: 0,
      data: 'Hello nestjs',
      msg: '请求成功'
    }
  }
}
```

这时访问 `http://localhost:3000/api/app` 将会得到 json 格式的返回，并且响应头的内容类型自动变为 json 类型，即

```js
Content-Type: application/json; charset=utf-8
```

是不是非常智能

##### 6.1 创建 module

前面只是一个简单的测试，像这种业务代码我们一般并不会直接写在 app 文件中，而是会创建不同的模块

我们将 app 的 controller 和 service 都删掉，创建自己的控制器，此时还剩下 `app.module.ts` 文件，内容如下：

```ts
import { Module } from '@nestjs/common';

@Module({
  imports: [],
  controllers: [],
  providers: [],
})
export class AppModule {}
```

我们新建一个终端，使用 cli 工具新建一个 user 模块

```shell
nest g module user
```

> 这里遇见了一个bug，输入命令后没有报错，但也没有反应，查询 github 的 issue 发现可能是版本问题，于是重新全局安装了最新版 10.4.5，问题解决

会发现 src 目录下新建了一个 user 目录，目录下有新建的 `user.module.ts` 文件：

```ts
import { Module } from '@nestjs/common';

@Module({})
export class UserModule {}
```

而 `app.module.ts` 文件自动更新了代码，引用了 user 模块：

```ts
import { Module } from '@nestjs/common';
import { UserModule } from './user/user.module';

@Module({
  imports: [UserModule],
  controllers: [],
  providers: [],
})
export class AppModule {}
```

##### 6.2 创建 controller

接着创建名为 user 的控制器，使用如下命令

```sh
# --no-spec: 只创建 controller，不创建测试相关的文件
# -d: 预示操作结果，不写入本地磁盘
nest g controller user --no-spec -d
```

查看预期结果后，没有问题就使用如下命令创建 user controller

```sh
nest g controller user --no-spec
```

这将会在 `src/user` 目录下创建 `user.controller.ts` 文件，同时更新同目录下的 `user.module.ts` 文件

```ts
// user.controller.ts

import { Controller } from '@nestjs/common';

@Controller('user')
export class UserController {}
```

```ts
// user.module.ts

import { Module } from '@nestjs/common';
import { UserController } from './user.controller';

@Module({
  controllers: [UserController]
})
export class UserModule {}
```

现在我们去给控制器添加函数

```ts
import { Controller, Get } from '@nestjs/common';

@Controller('user')
export class UserController {

  @Get()
  getUsers(): any {
    return {
      code: 0,
      data: [],
      msg: '请求用户列表成功！'
    }
  }
}
```

导入 Get，使用 Get 注解函数，这时访问 `http://localhost:3000/user` 就能返回如下 json 数据

```js
{
  code: 0,
  data: [],
  msg: '请求用户列表成功！'
}
```

但是通常我们访问后端，是不是一般所有接口都会带个前缀，比如 `/api`，难道我们给每个接口都加上这个前缀吗，这显然是很麻烦的，未来修改维护也会很麻烦，因为要修改多处地方

可以统一处理，打开 `src/` 目录下的 `main.ts` 文件，在 `app` 监听端口前，添加全局的前缀

```ts
// main.ts

import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.setGlobalPrefix('api/v1');
  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
```

这时再访问 `http://localhost:3000/user` 就不管用了，会返回 404 状态码

需要访问 `http://localhost:3000/api/v1/user` 才会返回正确的 json 数据

##### 6.3 创建 service

与创建 controller 一样，创建 service 也是一样的命令

```sh
nest g service user --no-spec -d
```

确认没问题后去掉 `-d` 参数

```sh
nest g service user --no-spec
```

这将会在 `src/user` 目录下创建 `user.service.ts` 文件，同时更新同目录下的 `user.module.ts` 文件

```ts
// user.service.ts

import { Injectable } from '@nestjs/common';

@Injectable()
export class UserService {}
```

```ts
// user.module.ts

import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';

@Module({
  controllers: [UserController],
  providers: [UserService]
})
export class UserModule {}
```

service 层是逻辑层，负责逻辑处理，在 controller 里使用 service 需要在构造函数中引入，在 `user.controller.ts` 中引入 service，并且将 `getUsers` 路由改为返回 service 的 `getUsers`  函数

```ts
// user.controller.ts

import { Controller, Get } from '@nestjs/common';
import { UserService } from './user.service';

@Controller('user')
export class UserController {
  constructor(private userService: UserService) {
    // 语法糖写法，等价于 this.userService = new UserService();
  }

  @Get()
  getUsers(): any {
    return this.userService.getUsers();
  }
}
```

由于此时 service 还没有 `getUsers`  函数，所以我们去创建一个就可以了

```ts
// user.service.ts

import { Injectable } from '@nestjs/common';

@Injectable()
export class UserService {
  getUsers() {
    return {
      code: 0,
      data: [],
      msg: '获取用户列表成功！'
    }
  }

  addUser() {
    return {
      code: 0,
      data: {},
      msg: '添加用户列表成功！'
    }
  }
}
```

#### 7 调试

调试作为软件开发必不可少的一环，nestjs 也是需要的，如果使用 vscode 开发 node 项目，这个调试技巧是通用的

1. 首先在想要调试的地方打上红色的断点

2. 点击 vscode 左侧的 debug 小虫子图标，进入运行调试菜单，首次调试，需要新建一个 `launch.json` 文件

   ```json
   {
     "version": "0.2.0",
     "configurations": [
       {
         "type": "node",
         "request": "launch",
         "name": "Launch NestJS",
         "runtimeArgs": ["--nolazy", "-r", "ts-node/register"],
         "args": ["src/main.ts"],
         "cwd": "${workspaceFolder}",
         "restart": true,
         "console": "integratedTerminal"
       }
     ]
   }
   ```

   



























