# JxbDebugTool
一个iOS调试工具，监控所有HTTP请求，自动捕获Crash分析。

1.当出现功能异常时，有很大可能是与服务器的接口交互有数据异常，不管是客户端参数传错还是服务器返回结果错误，都不需要连接电脑调试了，只要打开debug工具就可以观察每次http/https请求的信息了，测试人员都可以使用哦，极大的提交了查找问题的效率！

2.自动捕获Crash日志，不需要再为不是必现得crash而头疼了，一看就了解问题所以，工具会显示crash的堆栈信息。

3.打印系统日志，NSLog输出的log可以在DebugTool中及时查看，解决了只能连接电脑调式才能看到log，大大的方便咯。

-------
##支持CocoaPods引入
`pod 'JxbDebugTool', '~> 4.4', :configurations => ['Debug']`

-------
##启用代码
```object-c

#import "JxbDebugTool.h"

#if DEBUG
[[JxbDebugTool shareInstance] setMainColor:HEXCOLOR(0xff755a)]; //设置主色调
[[JxbDebugTool shareInstance] enableDebugMode];//启用debug工具
#endif
```


##展示图
![](https://raw.githubusercontent.com/JxbSir/JxbDebugTool/master/1.pic.jpg)
