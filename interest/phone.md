#### 1 钉钉

版本：

钉钉 6.5.45

shizuku 12.14.0.r914

lspatch 0.5.1

钉钉助手 1.4.4

mt管理器 2.14.5-clone

##### 1.1 shizuku

通过 adb 运行 shizuku

```sh
adb shell sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh
```

##### 1.2 lspatch

shizuku 运行后，勾选 lspatch

lspatch 打开获取应用列表权限

在 lspatch 中管理应用，将钉钉助手通过集成模式嵌入钉钉

重新安装新的钉钉安装包，钉钉设置中出现钉钉助手选项

##### 1.3 定位

由于助手地图出错无法定位，可手动定位

打开 [腾讯位置服务](https://lbs.qq.com/getPoint/) 获取经纬度，然后 **复制** 如下代码

```json
[{"mAddress":"太升国际","mLatitude":"26.543996","mLongitude":"106.777709"}]
```

导入钉钉助手，点击位置列表最右边，**导入** 复制代码

##### 1.4 mt管理器修改包名

钉钉会检测别的应用的包名，修改包名，绕过检测

打开 mt管理器，找到需要修改包名的 apk安装包

点击查看，记下当前包名，比如：`org.lsposed.lspatch`

以及查看安装包是否加固，非加固才能修改，否则需要脱壳

需要修改两个文件：

`AndroidManifest.xml`：选择反编译，替换 package 名称为想修改的名称

`resources.arsc`：选择Arsc编辑器，同样的操作

##### 1.5 wifi

连上需要记录的 wifi，右上角选择添加 wifi 即可













