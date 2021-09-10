# 云IDE：code-server安装使用


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

添加插件的步骤和vscode一致,不再累赘, 可以自己去用用实际的vscode.

