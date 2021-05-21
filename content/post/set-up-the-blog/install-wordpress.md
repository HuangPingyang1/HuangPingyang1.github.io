---
title: "基于docker搭建wordpress博客网站"
date: 2021-05-21T16:46:59+08:00
lastmod: 2021-05-21T16:46:59+08:00
draft: false
keywords: []
description: ""
tags: []
categories: []
author: ""

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: false
toc: false
autoCollapseToc: false
postMetaInFooter: false
hiddenFromHomePage: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
reward: false
mathjax: false
mathjaxEnableSingleDollar: false
mathjaxEnableAutoNumber: false

# You unlisted posts you might want not want the header or footer to show
hideHeaderAndFooter: false

# You can enable or disable out-of-date content warning for individual post.
# Comment this out to use the global config.
#enableOutdatedInfoWarning: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

### 安装docker
[见安装docker](http://note.youdao.com/noteshare?id=fd90d9aefd15a6b124d9008acfa73a9f&sub=BF0BE6D614EC4FD2B08DFE0A9638FA6E)

### 原理
- docker网络模式使用默认的bridge桥接模式，容器都连接在docker0网桥上，实现容器间网络互通
- mysql容器和wordpress容器不做外网端口映射，对外不暴露端口，只暴露nginx容器的80端口到外网。同时nginx容器配置反向代理->转发到wordpress容器的80端口提供服务访问。

### 一、安装mysql数据库
- #### 运行mysql容器

```
docker run -d --restart=always --name mysql -v /srv/mysql/data:/var/lib/mysql -v /srv/mysql/conf:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=123456  mysql:5.7
```
> -v /srv/mysql/data:/var/lib/mysql -v /srv/mysql/conf:/etc/mysql/conf.d

挂载本地配置到mysql容器实现数据持久化。

> -e MYSQL_ROOT_PASSWORD=123456 

指定mysql数据库的登录密码

- #### 新建一个数据库供wordpress使用

```
docker exec mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e"create database wordpress"'
```
> 'create database wordpress'：
数据库名称wordpress可自行修改。

- #### 添加wordpress容器访问mysql数据库的权限

```
docker exec mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e"grant all privileges on *.* to 'root'@'%' identified by 'password'; flush privileges"
```
>  by 'password'："password"为需自行修改的密码。
- #### 修改数据库密码（*视个人情况是否需要修改*）

```
docker exec mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e"set password for root@localhost = password('123')"'
```
> password('123') ：“123”为需要修改的密码。
### 二、安装wordpress
- #### 拉取官方提供的镜像，运行容器

```
docker pull wordpress
docker run --restart=always -d -v /srv/wordpress/html:/var/www/html --name=wordpress wordpress
```
> -v /srv/wordpress/html:/var/www/html

挂载wordpress容器的数据文件到本地。

- #### 配置mysql数据库信息

访问wordpress时需要提供数据库信息，用于访问mysql数据库，存放博客后续产生的数据。

读取的配置文件为站点路径下的wp-config.php：

```
#复制一份配置文件为wp-config.php
cp /srv/wordpress/html/wp-config-sample.php /srv/wordpress/html/wp-config.php

#编辑配置文件，填入数据库信息
[root@web-blog html]# vim wp-config.php
/** The name of the database for WordPress */
define( 'DB_NAME', 'WordPress' );

/** MySQL database username */
define( 'DB_USER', 'root' );

/** MySQL database password */
define( 'DB_PASSWORD', '123456' );

/** MySQL hostname */
define( 'DB_HOST', '172.17.0.2:3306' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );
```
依次修改数据库名：DB_NAME,账号：DB_USER，密码：123456，数据库地址端口：172.17.0.2:3306

其中数据库地址的查看方式为：
```
[root@web-blog html]# docker inspect mysql | grep -i "ipaddress"
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",
```
### 三、安装nginx
- #### 修改nginx.conf配置文件
创建配置文件和日志目录：

```
mkdir -p /srv/nginx/conf && mkdir -p /srv/nginx/logs
```
新建wordpress.conf文件，配置代理转发

```
[root@web-blog conf]# vim wordpress.conf 

upstream wordpress {
    server 172.17.0.3:80;
}

server {
    listen    80;
    server_name 127.0.0.1;

    # 跳转到 https 站点
    # rewrite ^(.*)$ https://$host$request_uri;

    access_log  /var/log/nginx/access.log;
    error_log   /var/log/nginx/error.log;

    location / {
        proxy_redirect off; # 禁止跳转
        proxy_set_header Host $host;    # 域名转发
        proxy_set_header X-Real-IP $remote_addr;    # IP转发
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://wordpress;
   }
}
```
- #### 运行nginx容器

```
docker run --restart=always -d --name=nginx -v /srv/nginx/conf:/etc/nginx/conf.d -v /srv/nginx/logs:/var/log/nginx -p 80:80 nginx
```
> -v /srv/nginx/conf:/etc/nginx/conf.d

挂载本地wordpress配置到nginx容器的conf目录下
> -p 80:80

映射本地的80端口到nginx容器。

直接访问http://localhost就能访问wordpress了。至此，docker搭建wordpress博客就完成了。


---
##### 若是云服务器，还需开放对应的安全组端口才能访问。
