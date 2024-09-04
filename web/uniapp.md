#### 1 域名灵活配置

uniapp 开发小程序，可以在 `package.json` 中增加 uniapp 的独家配置，添加 `uni-app` 属性配置项：

```json
"uni-app": {
  "scripts": {
    "wx-dev": {
      "title": "微信小程序 - 开发服",
      "env": {
        "UNI_PLATFORM": "mp-weixin",
        "NAME": "dev"
      }
    },
    "wx-test": {
      "title": "微信小程序 - 测试服",
      "env": {
        "UNI_PLATFORM": "mp-weixin",
        "NAME": "test"
      }
    },
    "wx-prod": {
      "title": "微信小程序 - 生产服",
      "env": {
        "UNI_PLATFORM": "mp-weixin",
        "NAME": "pro"
      }
    }
  }
}
```

然后在 uniapp 的开发工具 Hbuilder X 里面的运行和发行菜单中就会出现自定义的运行和发行项，名称就是上面定义的 title，点击不同的运行和发行项，就能运行和打包不同环境的项目

UNI_PLATFORM：指定配置生效的平台，这里填写 mp-weixin 表示是微信小程序

NAME：自定义项，可以在不同配置下自己访问自定义项的变量值，以实现不同的配置

通过如上配置后，我们就能实现不同环境的域名配置了，首先定义一个配置文件用于填写配置：

```js
// config.js
const dev = {
  BASE_URL: "https://api-mobile-daily.gg66.cn",
}

const test = {
  BASE_URL: "https://api-mobile-test.gg66.cn",
}

const pro = {
  BASE_URL: "https://api.mobile.gg66.cn",
}

export default {
  dev,
  test,
  pro
}
```

注意这里的变量名称应该与 NAME 自定义项一致，以便正确选中配置

然后就可以进行使用了，先前定义的自定义项 NAME 可以通过 `process.env.NAME` 的方式访问，这个访问是全局的，随时可以访问，于是我们需要访问不同域名时，先导入 `config.js` 然后使用 NAME 值去选取对应变量即可：

```js
// request.js
import config from '@/config'
const BASE_URL = config[process.env.NAME].BASE_URL  // 使用这个变量值即可
```

如果想配置别的想要不同环境使用的变量，同样的定义在 `config.js` 中就好，原理都是一样的