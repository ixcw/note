#### 1 v2ray

前期准备：

1. 首先准备一台服务器，一般是 vps，操作系统可以是 centos7 也可以是 ubuntu18，选择性价比高的国外 vps 购买即可
2. 然后准备一个域名，一般在 namesilo 购买，选择性价比高的购买即可
3. 准备好搭建脚本 `v2ray_mod.sh`

开始操作：

1. 通过 ssh 客户端登录 vps 主机，将脚本上传至服务器

   改变脚本权限，使其可以执行

   ```sh
   chmod 777 v2ray_mod.sh
   ```

2. 在 namesilo 配置好域名解析，解析至当前服务器 ip 地址，

   配置路径为：domain manager => manage dns for this domain（蓝色球）

   删掉所有默认 records，添加 A record

   添加两个

   一个 hostname 留空

   一个 hostname 填写 www

   后面都填 vps 的 ipv4 地址

   等待域名解析生效，大约十几分钟

3. 在服务器执行脚本，选择第4项安装V2ray-VMESS+WS+TLS(推荐)，其余根据提示随意，等待安装结束