# Nginx File Server


## 文件服务
直接查看server块配置
```bash
server {
    listen    1234;
    server_name 127.0.0.1;
    charset utf-8; # 避免中文乱码 
    location / {
	    root /download;
        autoindex on; # 索引,开启目录文件列表
        autoindex_exact_size on; # 显示文件大小 
        autoindex_localtime on; # 显示文件时间
        # 密码，按需开启
        auth_basic "Some description";
    	auth_basic_user_file /nginx/passwd;	# 自定义一个绝对路径的密码文件
    	
    access_log  /var/log/nginx/download-access.log;
    error_log   /var/log/nginx/download-error.log;
	}
}
```
到这里就搭建好了简单的文件服务，可以在浏览器中输入ip或域名访问目录文件了。
![127.0.0.1](https://img-blog.csdnimg.cn/02df31e942ad4c27abc1ae2af028f8f5.png)
### 身份认证
如果不希望自己的文件被他人所下载和访问，可以增加一下身份验证。幸运的是，Nginx 已经为我们提供了简单的身份认证的功能，开箱即用。
#### 概述
`ngx_http_auth_basic_module`模块允许通过使用“HTTP基本认证”协议验证用户名和密码来限制对资源的访问。

访问还可以根据地址、子请求的结果或JWT进行限制。同时通过地址和密码限制访问由满足指令控制。
#### 配置Nginx
在`location`块中添加以下配置：
```bash
location / {
	auth_basic "Some description";
	auth_basic_user_file /nginx/passwd;	# 自定义一个绝对路径的文件
```
#### 生成密码
为了安全考虑，`auth_basic` 功能必须在起“用户名:密码”文件中使用经过 Hash 的密码值，故需要对明文密码进行处理。
可以选择的生成工具有` Apache` 服务器发行版中提供的 `htpasswd `工具，以及 `openssl passwd` 命令。

```bash
echo "账户名:$(openssl passwd 密码)" > /nginx/passwd
$ echo "nginx:$(openssl passwd 123456)" > /nginx/passwd
$ cat /nginx/passwd
nginx:Kj1uQfCRjT/9g
```
`nginx -s reload` 重启一下nginx服务就可以了。
## 开启文件在线预览和强制下载
> nginx 默认配置下， `.txt`是可以在线打开，而`.md` 会有弹窗，也就是下载。

在上面的`location`代码块中，添加以下配置
```bash
#################default_type 方式 ##################
# 配置在线预览
if ($request_filename ~* ^.*?\.md {
    default_type text/plain; 
    charset utf-8;
}
# 配置下载文件模式
if ($request_filename ~* ^.*?\.txt {
    types        { }
    default_type application/octet-stream; 
}
#################add_header  方式 ##################
# 配置在线预览
if ($request_filename ~* ^.*?\.md {
    add_header Content-Type "text/plain; 
    charset=utf-8";
}
# 配置下载文件模式
if ($request_filename ~* ^.*?\.txt {
    types        { }
    add_header Content-Type "application/octet-stream; 
    charset=utf-8";
}
##############Content-Disposition 方式###############
# 配置文件为下载模式 
if ($request_filename ~* ^.*?\.(html|doc|zip|docx)$) {
    add_header Content-Disposition attachment;	# 添加响应头，配置文件作为附件下载
    add_header Content-Type application/octet-stream;
}
# 配置文件在线预览模式
if ($request_filename ~* ^.*?\.(md)$) {
	add_header Content-Type "text/plain;charset=utf-8";
}
```
**Content-Disposition 是什么？**

在常规的 HTTP 应答中，Content-Disposition 响应头指示回复的内容该以何种形式展示，是以内联的形式（即网页或者页面的一部分），还是以附件的形式下载并保存到本地。

[点击查看](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Content-Disposition)了解详情
## NGINX是如何配置生效的
nginx.conf配置文件中有一段配置

```bash
http {
    include       mime.types;
    default_type  application/octet-stream;
    ···
｝
```
> `application/octet-stream`: 大多数浏览器会将其视为二进制文件并下载。`default_type` 仅适用于未在`mime.types`文件中定义的文件扩展名

首先nginx会读取 `mime.types` 中定义好的 数据类型与文件类型关系。然后使用`default_type` 将`mime.types` 中未定义的的都设置为`application/octet-stream`。

## 参阅
- [如何让 Google Chrome 显示纯文本 HTTP 响应，而不是将其下载到文件中？](https://superuser.com/questions/126354/how-can-i-make-google-chrome-display-a-plain-text-http-response-rather-than-dow/1675596#1675596)
- [反向 ssl 代理](https://www.nginx.com/resources/wiki/start/topics/examples/SSL-Offloader/)
- [Content-Disposition](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Content-Disposition)
