#### 1 变量

可用`set`关键字设置变量，引用时使用`%%`

```bash
set message=update
echo %message%
```

可使用`/p`接收输入，这时`please input commit message: `变成了提示语句，而不是赋值

```bash
set /p message=please input commit message: 
```

#### 2 关闭命令提示

可使用`@echo off`关闭命令提示，否则每条命令执行都将会显示到命令行

#### 3 打印信息

使用`echo`向命令行打印信息

#### 4 暂停脚本

使用`pause`暂停脚本，否则脚本命令执行完毕会立刻关掉命令行窗口

5 注释

使用`@REM`进行注释，vscode中可以直接使用快捷键`ctrl + /`

#### 更新git仓库脚本示例

```bash
@echo off
cd note
set /p message=please input commit message: 
git pull
git cmp %message%
echo %message% update successfully
pause
```
