#### 1 apktool 介绍

apktool 是款安卓反编译程序，安装前请提前安装 jdk1.8 及以上版本

先保存脚本文件 [apktool.bat](https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/windows/apktool.bat)，然后下载 [apktool.jar](https://bitbucket.org/iBotPeaches/apktool/downloads/)，下载完改名为 `apktool.jar`

拷贝这两个文件到指定目录，将指定目录加入系统变量

#### 2 反编译

打开指定目录，把要反编译的 apk 文件复制过来，执行如下命令：

```sh
apktool.bat d test.apk
```

`test.apk` 是 apk 文件的位置，取决于相对路径，可以是 `./apk/test.apk`，当前目录则是 `test.apk`，执行完后就反编译出与 apk 文件同名的文件夹了