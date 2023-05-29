# HHDownloadManager
文件下载，多文件队列下载。

文件上传是一片一片的 流的形式。 避免下载大的文件的时候内存会爆掉。
流：
- inputstream  （读文件到内存）
- outputstream  （从内存读到nsdata，socket，文件）
数据源：nsdata，socket，文件


下载的文件都放在内存会爆的，所以下载一点存储一点。
NSOutputStream写入data到文件
// 写入文件的temp地址
[NSOutputStream outputStreamToFileAtPath:[self fileFullPathOfURL:URL] append:YES]; 

### 开始下载
1. openOutputStream
2. 将文件总大小保存到plist

### 下载过程
1. 在下载接收数据代理中 写入数据到temp路径文件
[downloadModel.outputStream write:data.bytes maxLength:data.length];

### 下载结束
1. closeOutputStream
2. 将文件move到目标路径


### url有中文的情况
所有从外面传的urlString如果包含中文都需要编码
是否包含中文
```
- (BOOL)hasChinese:(NSString *)str
{
    for (int i = 0; i < [str length]; i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}
```
编码
```
NSString *URLString = [originalURLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

```

### 下载路径
1. 文件路径
2. 文件总大小plist文件路径
3. 文件已下载大小
