#### 1 简化提交流程
将三条命令简化为一条
```cmd
git add .
git commit -m "message"
git push
```

变为

```cmd
git cmp "message"
```

向`.gitconfig`文件添加了一个别名：

```text
[alias]
    cmp = "!f() { git add -A && git commit -m \"$@\" && git push; }; f"
```

也可以在命令行使用命令更改：

```cmd
git config --global alias.cmp '!f() { git add -A && git commit -m "$@" && git push; }; f'
```

