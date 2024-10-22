#### 1 钉钉
##### 1.1 shizuku

通过 adb 运行 shizuku

```sh
adb shell sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh
```

##### 1.2 lspatch

shizuku 运行后，勾选 lspatch，在 lspatch 中管理应用，将钉钉助手通过集成模式嵌入钉钉，重新安装新的钉钉安装包，钉钉设置中出现钉钉助手选项

##### 1.3 定位

由于助手地图出错无法定位，可手动定位，打开 [腾讯位置服务](https://lbs.qq.com/getPoint/) 获取经纬度，然后复制如下代码

```json
[{"mAddress":"太升国际","mLatitude":"26.543996","mLongitude":"106.777709"}]
```

导入钉钉助手，点击位置列表最右边，导入复制代码

> 钉钉版本 6.5.56 钉钉助手版本 1.4.4