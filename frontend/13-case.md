#### 1 文件下载

使用 blob 加创建 a 标签的方式下载，缺点是不能监听下载进度，下载完成之前会一直等待

```js
 fetch(url)
   .then(res => res.blob())
   .then(blob => {
     console.log(blob)
     const a = document.createElement("a");
     const objectUrl = window.URL.createObjectURL(blob);
     a.download = name;
     a.href = objectUrl;
     a.click();
     window.URL.revokeObjectURL(objectUrl);
     a.remove();
     util.uniShowToast('视频下载成功')
   })
```

> 相关API：[URL](https://developer.mozilla.org/zh-CN/docs/Web/API/URL)

