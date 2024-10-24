#### 1 操作准备

MobaXterm（ssh客户端）

```text
123.207.202.192
root
Tengxunyun0708
```

 `dist.zip` （前端打包好的压缩包）

#### 2 操作步骤

由于前端项目是部署在 docker 环境中的，所以大致步骤是需要将压缩包上传至服务器，并解压复制至 docker 环境中，最后重启 docker 环境生效，因为是两个环境（外部服务器环境和 docker环境），所以需要开启两个终端方便操作

1. 首先登录至服务器，进入上传目录，清除旧文件，上传新文件，然后解压

   ```sh
   ls
   cd mogu_web
   rm -rf /root/mogu_web/*
   unzip dist.zip
   ```

2. 新开一个终端，用于进入 docker 环境，因为进入环境后不能退出，所以需要新开一个终端用于操作

   ```sh
   docker exec -it vue_mogu_web /bin/bash
   ```

3. 将 docker 环境中的旧文件清除

   ```sh
   # docker环境下执行
   rm -rf /usr/share/nginx/html/*
   ```

4. 将第 1 步解压得到的文件复制到 docker 环境中

   ```sh
   docker cp /root/mogu_web/dist/ vue_mogu_web:/usr/share/nginx/html/
   ```

5. 返回 docker 环境，进入到复制的文件夹内，将解压的文件复制到 nginx 目录，然后删除复制过来的文件夹

   解压过来的文件中有一个文件是脚本文件，需要进行正则处理然后赋予执行权限

   ```sh
   # docker环境下执行
   cd dist
   cp -r * /usr/share/nginx/html/
   cd ..
   rm -rf /usr/share/nginx/html/dist/
   sed -i 's/\r$//' /usr/share/nginx/html/env.sh
   chmod +x /usr/share/nginx/html/env.sh
   ```

7. 在外部环境中重启 docker，完成

   ```sh
   docker restart vue_mogu_web
   ```

