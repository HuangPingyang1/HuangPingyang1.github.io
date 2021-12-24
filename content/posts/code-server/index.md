---
title: "云IDE：code-server安装使用"
subtitle: ""
date: 2021-09-10T16:48:03+08:00
lastmod: 2021-09-10T16:48:03+08:00
draft: false
tags: []
categories: []

resources:
- name: "featured-image"
  src: "xxx.jpg"

---

最近新入手了一部IPad Air 4，想着为了不让其成为爱奇艺播放器，发挥生产力功效，于是搜罗资料，查找能否在iPad上实现写代码的方案。最终找到两种方法：

- 利用SSH连接软件，在远程服务器上利用Vim、NEOVim等编辑器软件进行编码。

  首先找到的是一款名为**termius**的软件，下载免费，使用需内购，可是我在下载下来之后进入软件始终都无法创建账号，也就无法进行内购使用了，放弃。网上看使用过的大佬说，并不推荐这种方式，因为编码的效率太低，而且有时切出软件一小段时间后，SSH连接会断开，体验非常差。

- 利用code-server部署一个网页版的VScode，即“云IDE”，这样工作区在不同的设备上都能同步，而且切出后不会掉线。将网页作为WebApp添加到主屏幕上后的体验也接近于原生App(前提是服务器的带宽不能太低)。 

###  环境准备

云服务器，规格 2C4G：

```bash
$ cat /etc/redhat-release 
CentOS Linux release 7.6.1810 (Core)
```

###  下载资源

下载code-server在github上的安装包：

```sh
$ wget https://github.com/cdr/code-server/releases/download/v3.11.0/code-server-3.11.0-linux-amd64.tar.gz

# 解压安装包
$ tar -zxf code-server-3.11.0-linux-amd64.tar.gz && cd code-server-3.11.0-linux-amd64
#
```

###  启动

设置登录web服务的密码，code-server要求以环境变量$PASSWORD为登录密码：

```sh
$ export PASSWORD="123456"
```

运行code-server

```sh
$ ./code-server --port 8080 --host 0.0.0.0 --auth password
```

8080是端口,可以自己修改,注意不要与其他应用冲突。0.0.0.0是代表可以被所有ip访问.

```sh
$ ./code-server --port 8080 --host 0.0.0.0 --auth password
***** Please use the script in bin/code-server instead!
***** This script will soon be removed!
***** See the release notes at https://github.com/cdr/code-server/releases/tag/v3.4.0
[2021-09-10T07:39:08.191Z] info  code-server 3.11.0 4e8cd09ef0412dfc7b148b7639a692e20e4fd6dd
[2021-09-10T07:39:08.192Z] info  Using user-data-dir ~/.local/share/code-server
[2021-09-10T07:39:08.206Z] info  Using config file ~/.config/code-server/config.yaml
[2021-09-10T07:39:08.206Z] info  HTTP server listening on http://0.0.0.0:8080 
[2021-09-10T07:39:08.206Z] info    - Authentication is enabled
[2021-09-10T07:39:08.206Z] info      - Using password from ~/.config/code-server/config.yaml
[2021-09-10T07:39:08.206Z] info    - Not serving HTTPS

```

如图所示就是已经完成配置了。

###  访问

在浏览器中输入服务器ip+端口号：`127.0.0.1:8080`，出现登录页面，输入刚才所设置的密码123456登录，即可进入Web IDE ,愉快的进行coding吧~

###  添加插件

- LeetCode（力扣）
- Thief-Book（一款摸鱼插件）
- Go
- Python
- Markdown All in one(预览Markdown)
- 
在github上还有非常多好玩有用的优秀插件，可以自行去探索，最好能做出一款自己写的插件。

---
###  2021-12-01更新
### 踩坑
#### 坑点1
**登录密码如果使用环境变量，记得一定要使用大写的PASSWORD！！** 原因：因启动参数中的password是小写，导致我一直错误的认为环境变量应该跟它保持一致，也是小写。
```
./code-server --port 8080 --host 0.0.0.0 --auth password
```
而当我使用命令`export password=123456`添加了小写的password的环境变量去登录界面登录时又提示密码错误，且登录界面提示密码在`~/.config/code-server/config.yaml`中，于是我按照提示复制yaml文件中的密码成功登录了。
此时我还没意识到环境变量password其实是没有生效的，然后又去改了yaml中的密码为$password环境变量的值，导致我一直以为环境变量是被使用的。
```
$ cat ~/.config/code-server/config.yaml
bind-addr: 0.0.0.0:8080
auth: password
password: 123456
cert: false
```
#### 坑点2
后面想到是否可以用域名+nginx反向代理的方式访问会更加便捷呢？步骤如下：

- 1、在服务器上安装nginx。
	注意：需要安装ssl模块`./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-http_v2_module`
- 2、在阿里云申请免费证书并下载nginx版本的证书到本地。
- 3、上传证书到服务器上，并解压到到/usr/local/nginx/conf/cert/下。
- 4、在nginx.conf的配置如下：
```
server {
    listen    443;
    server_name code.xxx.com;

    access_log  /var/log/nginx/access.log;
    error_log   /var/log/nginx/error.log;

    ssl     on;
    ssl_certificate cert/xxx.pem;
    ssl_certificate_key cert/xxx.com.key;
    ssl_session_timeout 5m;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;     #表示使用的加密套件的类型。
    ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3; 							 #表示使用的TLS协议的类型。
    ssl_prefer_server_ciphers on;

    proxy_set_header Host $host;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection upgrade;
    proxy_set_header Accept-Encoding gzip;


    location / {
      proxy_pass http://localhost:8080;
   }
}

server {
    listen 80;
    server_name localhost;
    rewrite ^(.*)$ https://$host$1 permanent;   # http重写到https
}

```
踩坑点：最开始由于server模块中没有配置`proxy_set_header`请求头，导致到了登录界面输入密码，却无法跳转进入vs-code界面。后面查看coder官方文档发现，code-server要求请求需使用websocket协议才能进行通信。官网原文:https://coder.com/docs/code-server/latest/guide#using-lets-encrypt-with-nginx
> To work properly, your environment should have WebSockets enabled, which code-server uses to communicate between the browser and server.(为了正常工作，您的环境应该启用 WebSockets，代码服务器使用它在浏览器和服务器之间进行通信。)

