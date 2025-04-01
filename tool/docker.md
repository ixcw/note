#### 4 常用docker命令

列出所有的容器（包括正在运行的和已停止的容器）：

> `-a` 或 `-all`  ：列出所有的容器，列出的容器列表中的 status 列显示运行状态：Up（正在运行）Exited（已停止）

```sh
docker ps -a
```

查看指定容器的日志：

> `-f` 或 `--follow`：持续输出日志（实时流式显示，直到手动终止 `Ctrl+C`）
>
> container-id：容器 id，可通过查看的容器列表获得

```sh
docker logs -f container-id
```

