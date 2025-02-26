#### 1 项目初始化出现网络问题

运行 nuxt3 项目的初始化命令

```sh
pnpm dlx nuxi@latest init nuxt3-init
```

报错网络问题

> Failed to download https://raw.githubusercontent.com/nuxt

将下面的 ip 解析加入 hosts，路径为  `C:\Windows\System32\drivers\etc\hosts`

```text
151.101.109.194 github.global.ssl.fastly.net
10.10.211.68 assets-cdn.github.com
185.199.111.133 raw.githubusercontent.com
```

cmd 运行命令刷新 dns

```sh
ipconfig/flushdns
```

