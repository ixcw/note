#### 1 nuxt

#### * 问题

##### 问题1

nuxt@3.1.2，在`.nuxt/tsconfig.json`文件中配置了

```json
"compilerOptions": {
    "types": [
      "node"
    ]
}
```

报错：

```bash
找不到“node”的类型定义文件。
程序包含该文件是因为:
在 compilerOptions 中指定的类型库 "node" 的入口点
```

解决方法：注释掉`"node"`，原因：[types](https://www.typescriptlang.org/tsconfig#types)

