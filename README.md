# MCWebBridgeNative 

利用的url拼接地址 打开任意controller(不需要预埋import,不需要预埋实现方法,很方便)并且可以进行传参,或者执行预埋的方法

主要作者比较懒，有问题可以直接发邮件chenxingghost@gmail.com或者在issues提问,还有待完善的地方慢慢修改
简书地址:http://www.jianshu.com/p/760ca42f6475
---
#Examples【示例】
![image](https://github.com/CZXBigBrother/MCWebBridgeNative/blob/master/Gif/record.gif)
知道你们懒,所以实现上面的方法只需要一行代码!是不是很爽
```
 -(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
     return [MCURLBridgeNative MC_autoExecute:request withReceiver:self];
}
```
---
#使用方法
上面的全自动判断执行的方法,下面介绍下自定义的内容
```
/**
 *  知道你们懒 给你们一个全自动的方法
 */
+ (BOOL)MC_autoExecute:(NSURLRequest *)request withReceiver:(id)receiver;
/**
 *  创建并获取Controller对象
 */
+ (id)MC_getViewControllerRequestURL:(NSURLRequest *)request;
/**
 *  将创建的Controller push,如果没有navigation则执行present
 */
+ (void)MC_pushViewControllerRequestURL:(NSURLRequest *)request;
/**
 *  将创建的Controller present
 */
+ (void)MC_presentViewControllerRequestURL:(NSURLRequest *)request;
/**
 *  根据showtype字段判断是push还是present,controller,如没有这个字段则执行MC_push方法
 */
+ (void)MC_showViewControllerRequestURL:(NSURLRequest *)request;
/**
 *  执行一个本地的方法
 */
+ (void)MC_msgSendFuncRequestURL:(NSURLRequest *)request withReceiver:(id)receiver;

/**
 *  判断scheme协议是否和设定的相同
 */
+ (BOOL)MC_checkScheme:(NSURLRequest *)request;
/**
 *  判断host是不是获取controller
 */
+ (BOOL)MC_checkHostisEqualVc:(NSURLRequest *)request;
/**
 *  判断host是不是获取function
 */
+ (BOOL)MC_checkHostisEqualFunc:(NSURLRequest *)request;
```
Web需要对应的内容,下面这是示例
```
    <a href="mc://mcvc?class=TestViewController">打开test控制器</a><br>
    <a href="mc://mcvc?class=TestViewController&showtype=push&dataString=MCstring&dataInteger=123">push打开test控制器并传值</a><br>
    <a href="mc://mcvc?class=TestViewController&showtype=present&dataString=MCstring&dataInteger=123">present打开test控制器并传值</a><br>
    <a href="mc://mcfunc?func=test">执行本地方法</a><br>
    <a href="mc://mcfunc?func=test:&data=MCstring">执行本地方法并传值</a><br>
```
介绍一下结构
mc://mcvc?class=TestViewController&showtype=push&dataString=MCstring&dataInteger=123"
* 第一部分mc:// (这是客户端和web预定的协议,可用MC_checkScheme方法执行判断)
* 第二部分mcvc?或者mcfunc? (host,判断是打开controller还是执行本地方法)
* 第三部分class或者func字段 (class字段是用来生成需要打开的controller的类名,func字段是用来打执行需要执行的本地方法)
* showtype字段是 MC_autoExecute:withReceiver: 和MC_showViewControllerRequestURL:方法 自动判断显示controller的方式,如何使用MC_pushViewControllerRequestURL:和MC_presentViewControllerRequestURL方法会无视这个字段
* 第四部分后面的部分就是你们需要传输的字段,这个库会自动按照字段名对应相同名字的属性进行赋值,暂时不能支持NSArray NSDictionary NSSet 或自定义类,如果需要可以使用MJExension库替换 MC_ObjectWithkeyValues这个方法中的使用

---
#使用示例
##示例1 半自动啦
```
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([MCURLBridgeNative MC_checkScheme:request]) {
        if ([MCURLBridgeNative MC_getViewControllerRequestURL:request]) {
            [MCURLBridgeNative MC_pushViewControllerRequestURL:request];
        }else {
            [MCURLBridgeNative MC_msgSendFuncRequestURL:request withReceiver:self];
        }
        return NO;
    }
    return YES;
}
```
##示例2 喜欢自己创建类的朋友
```
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([MCURLBridgeNative MC_checkScheme:request]) {
        if ([MCURLBridgeNative MC_getViewControllerRequestURL:request]) {
            id VC = [MCURLBridgeNative MC_getViewControllerRequestURL:request];
            [self.navigationController pushViewController:VC animated:YES];
        }
        return NO;
    }
    return YES;
}
```
#加密
执行显示url里的内容不是很安全,特地加了加密工具,支持RSA 和 DES 加密
已内置DES解密方法
```
[MCURLBridgeNative MC_DESDecrypt:request key:@"mc"]
```
任何解密之后需要重新生成一个新的NSURLRequest对象
```
加密前:mc://mcvc?class=TestViewController&showtype=push&dataString=MCstring&dataInteger=123
加密后:mc://j97nAm965gnrIXpHYmW+a8kNd5UpDJcuqJYyrNSlOfWR5C2gOs7LAmySYbtGFzPolyMefbL2IuSLsF1zrEbwNOEZLT7LCQ945mhWKf58hEQ=
(协议://)协议头不要加密用来判断
[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@",协议头,"解密后的内容"]]]

```
#示例
```
    if ([MCURLBridgeNative MC_checkScheme:request]) {
        return [MCURLBridgeNative MC_autoExecute:[MCURLBridgeNative MC_DESDecrypt:request key:@"mc"] withReceiver:self];
    }
```
