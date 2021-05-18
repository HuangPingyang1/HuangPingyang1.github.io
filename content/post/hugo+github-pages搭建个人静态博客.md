---
title: "Hugo+github Pages搭建个人静态博客"
date: 2021-04-06T11:31:12+08:00
draft: true
---

### Linux安装git并设置远程仓库
1. #### 安装git
```
yum install -y git
```
2. #### 配置本地git连接github
设置默认的github用户名和邮箱
```
git config --global user.email "you@example.com"；
git config --global user.name "Your Name"
```
由于本地的 Git 仓库和 GitHub 仓库之间的传输是通过SSH加密的，所以我们需要配置验证信息,使用以下命令生成 SSH Key：

```
ssh-keygen -t rsa -C "youremail@example.com"
```
直接三个回车即可，默认不需要设置密码；

找到~/.ssh 的文件夹中的 id_rsa.pub 密钥，将内容全部复制：
```
cat ~/.ssh/id_rsa.pub
```
打开 GitHub->Settings->SSH and GPG keys，新建SSH Key: New SSH key，填入刚刚复制的内容，粘贴到github的输入框中，点击Add SSH key即可保存本地的秘钥到github账号。

验证：

```
[root@web-blog public]# ssh -T git@github.com
You've successfully authenticated, but GitHub does not provide shell access
```
本地添加github仓库源

```
git remote add origin https://github.com/HuangPingyang1/HuangPingyang1.github.io.git
#注意仓库地址后面需要加上.git
```
### 安装hugo
1. #### 下载hugo

```
wget https://github.com/gohugoio/hugo/releases/download/v0.80.0/hugo_0.80.0_Linux-64bit.tar.gz

#解压后复制到bin目录
tar -zxf hugo_0.80.0_Linux-64bit.tar.gz && cp hugo /use/local/bin

#hugo version查看版本
[root@web-blog ~]# hugo version
Hugo Static Site Generator v0.80.0-792EF0F4 linux/amd64 BuildDate: 2020-12-31T13:37:58Z
```
2. #### 用hugo生成博客
命令：hugo new site myblog 

*myblog为博客的目录名，这个看个人意愿取名*

```
wjy@ubuntu:~$ hugo new site myblog
Congratulations! Your new Hugo site is created in /home/wjy/myblog.

Just a few more steps and you're ready to go:

1. Download a theme into the same-named folder.
   Choose a theme from https://themes.gohugo.io/ or
   create your own with the "hugo new theme <THEMENAME>" command.
2. Perhaps you want to add some content. You can add single files
   with "hugo new <SECTIONNAME>/<FILENAME>.<FORMAT>".
3. Start the built-in live server via "hugo server".

Visit https://gohugo.io/ for quickstart guide and full documentation.
```
3. #### 下载并设置主题
主题官网：https://themes.gohugo.io ，找到想要的主题，点击去，复制下载命令，下载到 myblog 目录下的 themes 目录下，

例如，在 themes 目录下命令：

```
git clone https://github.com/vaga/hugo-theme-m10c.git m10c
```
下载后目录名默认为链接的最后的“/”后的目录名，在链接后面加 m10c，相当于把下载的主题放在 m10c 目录下，而不是使用默认的名字。
4. #### 在本地启动博客
在 myblog 目录下命令：
```
root@ubuntu:/home/wjy/myblog# hugo server -t m10c --buildDrafts
Start building sites … 

                   | EN  
-------------------+-----
  Pages            |  7  
  Paginator pages  |  0  
  Non-page files   |  0  
  Static files     |  1  
  Processed images |  0  
  Aliases          |  1  
  Sitemaps         |  1  
  Cleaned          |  0  

Built in 11 ms
Watching for changes in /home/wjy/myblog/{archetypes,content,data,layouts,static,themes}
Watching for config changes in /home/wjy/myblog/config.toml
Environment: "development"
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
Press Ctrl+C to stop
```
-t：指定主题（主题目录名）

访问 Web Server is available at http://localhost:1313/ (bind address 127.0.0.1) 里的本地网址，即可打开博客网页。
5. #### 写一篇文章
- 生成md文件

在 myblog 目录下：

```
root@ubuntu:/home/wjy/myblog# hugo new post/blog.md
/home/wjy/myblog/content/post/blog.md created
```
生成的 md 文件在myblog/context/post目录下：

```
root@ubuntu:/home/wjy/myblog/content/post# ls
blog.md
```
- 编写

可以先在Windows下写好博客，编写完后，保存，用记事本打开，全选，复制，在Linux下编辑blog.md，打开文件命令：

```
vim blog.md
```
粘贴，保存退出（键入 ESC : wq ，回车），这样，文章就写好了，可以重新运行看看文章。
6. #### 将个人博客部署到远程服务器
- 生成静态网页
（到新建的博客路径下执行）：
```
cd /srv/myblog
hugo --theme=m10c --baseUrl="https://huangpingyang1.github.io/" --buildDrafts
```
其中：

--theme=m10c 指定主题

--baseUrl="https://huangpingyang1.github.io/" 指定仓库地址

会把博客编译成网页形式，在myblog/public目录里面
- 上传到GitHub

```
cd public
git init        //初始化git库。
git add *       //添加文件到本地git库。
git commit -m "备注"        //提交改动到本地仓库并添加备注
git push -u origin master       //推送到github远程仓库
```
至此，即可登录github使用github pages提供域名和托管服务访问静态博客了。

##### 部署脚本

```
#!/bin/bash
stty erase ^H

mysite_dir=/srv/mysite      #博客网站根目录
public=/srv/mysite/public   #生成的git静态网页
msg="build site `date`"         #git commit的备注信息

if [ -e $public ];then
        cd $mysite_dir
        rm -rf $public  #删除原有静态文件
        hugo --theme=m10c --baseUrl="https://huangpingyang1.github.io/" --buildDrafts     #指定主题编译成静态文件，存放在public
        cd $public
        git init
        git add *
        if [ $# -eq 1 ];then
          msg = "$1"
        fi
        git commit -m "$msg"
        git push -f git@github.com:HuangPingyang1/HuangPingyang1.github.io.git master
        if [ $? -eq 0 ];then
                echo "文章已更新至github！"
        fi
fi
```

