# Hugo+GitHub Action+Github Pages搭建个人博客


现在市面上的博客很多，如CSDN，博客园，简书等平台，可以直接在上面发表，用户交互做的好，写的文章百度也能搜索的到。缺点是比较不自由，会受到平台的各种限制和恶心的广告。

而自己购买域名和服务器，搭建博客的成本实在是太高了，不光是说这些购买成本，单单是花力气去自己搭这么一个网站，还要定期的维护它，对于我们大多数人来说，实在是没有这样的精力和时间。

那么就有第三种选择，直接在github page平台上托管我们的博客。这样就可以安心的来写作，又不需要定期维护，而且Hugo作为一个快速简洁的博客框架，用它来搭建博客真的非常容易。

### 前言

Hugo 是一个基于Go语言开发的静态博客框架，号称世界上最快的构建网站工具。本文是我在网上看的其他人的博客和一些up主的视频，通过他们的分享成功搭建好了的案例，在这里我也进行一次总结，方便以后使用。

###  目的

通过把博客文章的源代码托管到GitHub仓库，利用[GitHub Actions for Hugo](https://github.com/peaceiris/actions-hugo)功能持续集成部署，利用GitHub Pages实现网站的发布和访问，生成一个自己专属的个人博客网站。

###  流程及原理

- 本地新建文章，push到 Github仓库的 main分支。main分支存放博客文章的源码。
- push 操作自动触发预先配置的Actions。
- GitHub Action自动执行yml文件中的"action"，构建打包，推送至gh-pages分支。
- 通过 Github Pages生成的 URL 访问即可。

###  详细步骤

####  安装git和关联GitHub

这里我选择的是在Linux上搭建的，所以可以直接通过yum一条命令就能实现安装Git，其他平台的安装就不赘述了，自行百度下吧。

- **安装git**

  ```
  yum install -y git
  ```

- **创建GitHub账户和仓库**

  没账号的登录[GitHub](https://github.com/)创建账号，有账号的直接登录账号，点击右上角的加号—>New repository，创建一个仓库，名称必须为yourname.github.io, 其中yourname是你的github名称，按照这个规则创建才有用。点击Create repository完成创建。

- **本地Git关联远程的GitHub账户：**

  回到Linux中，用以下命令配置Github账户信息，用户名（Your Name）和邮箱（you@example.com）换成你自己的：
  ```
  git config --global user.email "you@example.com"；
  git config --global user.name "Your Name"
  ```
  由于本地的 Git 仓库和 GitHub 仓库之间的传输是通过SSH加密的，所以我们需要配置验证信息,使用以下命令生成 SSH Key：

  ```
  ssh-keygen -t rsa -C "youremail@example.com"
  ```
  输入命令之后，直接三个回车即可，默认不需要设置密码；

  找到~/.ssh 的文件夹中的 id_rsa.pub 密钥，将内容全部复制：
  ```bash
  cat ~/.ssh/id_rsa.pub
  ```
  回到GitHub中->Settings->SSH and GPG keys，新建SSH Key: New SSH key，填入刚刚复制的内容，粘贴到github的输入框中，点击Add SSH key即可保存本地的秘钥到github账号。

  验证是否关联成功：

  ```bash
  [root@web-blog public]# ssh -T git@github.com
  You've successfully authenticated, but GitHub does not provide shell access
  ```

####  安装Hugo

##### 下载Hugo

```bash
[root@web-blog ~]# wget https://github.com/gohugoio/hugo/releases/download/v0.80.0/hugo_0.80.0_Linux-64bit.tar.gz

#解压后复制到bin目录
[root@web-blog ~]# tar -zxf hugo_0.80.0_Linux-64bit.tar.gz && cp hugo /use/local/bin

#hugo version查看版本
[root@web-blog ~]# hugo version
Hugo Static Site Generator v0.80.0-792EF0F4 linux/amd64 BuildDate: 2020-12-31T13:37:58Z
```

#####  生成博客

命令：`hugo new site myblog `

myblog为博客的目录名，可以修改为你自己想取的名字。

```bash
[root@web-blog ~]# hugo new site myblog
Congratulations! Your new Hugo site is created in /root/myblog.

Just a few more steps and you're ready to go:

1. Download a theme into the same-named folder.
   Choose a theme from https://themes.gohugo.io/ or
   create your own with the "hugo new theme <THEMENAME>" command.
2. Perhaps you want to add some content. You can add single files
   with "hugo new <SECTIONNAME>/<FILENAME>.<FORMAT>".
3. Start the built-in live server via "hugo server".

Visit https://gohugo.io/ for quickstart guide and full documentation.
```

#####  下载主题

主题官网：https://themes.gohugo.io ，找到想要的主题，点进去，复制下载命令，我这里下载的是even主题，在myblog目录下：

```bash
git clone https://github.com/olOwOlo/hugo-theme-even.git themes/even
```

主题被下载到站点目录myblog下的themes/even下。

##### 启动博客

下载完成之后需要把主题even下的./exampleSite/config.toml复制到站点根目录下，这个文件中有博客首页的一些配置项，如“关于”“标签”“分类”等的开关，设置为true或者把注释解开即可在博客上看到该项了。

为了测试文章排版效果，还需要把./exampleSite/content/下的所有文件复制到站点目录的content目录下：

```bash
[root@web-blog myblog]# cp themes/even/exampleSite/config.toml ./
[root@web-blog myblog]# vim config.toml
baseURL = "https://example.com"
title = "Your title"
themesDir = "../.."
theme = "even"
paginate = 8

[menu]
  [[menu.main]]
    identifier = "home"
    name = "Home"
    url = "/"
    weight = 1
  [[menu.main]]
    identifier = "tags"
    name = "Tags"
    url = "/tags/"
    weight = 2
  [[menu.main]]
    identifier = "about"
    name = "About"
    url = "/about/"
    weight = 3

#复制测试文本到站点目录
[root@web-blog myblog]# cp themes/even/exampleSite/content/* ./content
[root@web-blog myblog]# ll content
total 8
-rw-r--r-- 1 root root  486 May 13 17:02 about.md
drwxr-xr-x 2 root root 4096 May 13 17:02 post
```

启动博客，在myblog目录下键入命令：

```bash
[root@web-blog myblog]# hugo server 
Start building sites … 

                   | ZH-CN  
-------------------+--------
  Pages            |     8  
  Paginator pages  |     0  
  Non-page files   |     0  
  Static files     |    38  
  Processed images |     0  
  Aliases          |     1  
  Sitemaps         |     1  
  Cleaned          |     0  

Built in 39 ms
Watching for changes in /opt/myblog/{archetypes,content,data,layouts,static,themes}
Watching for config changes in /opt/myblog/config.toml
Environment: "development"
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
Press Ctrl+C to stop
```

打开浏览器访问http://localhost:1313/，预览博客网页效果。按Ctrl+C可以停止服务。

#####  写一篇文章

```bash
[root@web-blog myblog]# hugo new post/index.md
/opt/myblog/content/post/index.md created
```

生成的 Markdown 文件在myblog/context/post目录下：

```bash
[root@web-blog myblog]# vim /opt/myblog/content/post/index.md
---
title: "index"
date: 2021-03-30T15:56:50+08:00
draft: true
---
```

我们可以使用**typora**一类的Markdown编辑器编写好文章后再复制粘贴进去。

##### 编译博客

预览主题效果满意之后就可以编译了：

```bash
[root@web-blog myblog]# hugo --theme=even --baseUrl="https://YourName.github.io/" --buildDrafts
Start building sites … 

                   | ZH-CN  
-------------------+--------
  Pages            |     8  
  Paginator pages  |     0  
  Non-page files   |     0  
  Static files     |    38  
  Processed images |     0  
  Aliases          |     1  
  Sitemaps         |     1  
  Cleaned          |     0  

Total in 70 ms
```

> --theme=even：指定要使用的主题
>
> --baseUrl="https://YourName.github.io/" ：指定git远程仓库地址
>
> --buildDrafts：编译draft为true的文章。# hugo 会忽略所有通过 draft: true 标记为草稿的文件。

上面三个参数都可以在config.toml配置文件中进行修改，若修改了则只需要运行`hugo`就可以进行编译了。

Hugo会把博客编译成HTML静态网页，保存在./public目录下：

```
[root@web-blog myblog]# ll public/
total 124
-rw-r--r-- 1 root root  7844 May 21 10:46 404.html
-rw-r--r-- 1 root root  4930 May 13 17:02 android-chrome-192x192.png
-rw-r--r-- 1 root root  5498 May 13 17:02 android-chrome-512x512.png
-rw-r--r-- 1 root root  2530 May 13 17:02 apple-touch-icon.png
-rw-r--r-- 1 root root   246 May 13 17:02 browserconfig.xml
drwxr-xr-x 2 root root  4096 May 21 10:46 categories
-rw-r--r-- 1 root root   737 May 13 17:02 favicon-16x16.png
-rw-r--r-- 1 root root  1019 May 13 17:02 favicon-32x32.png
-rw-r--r-- 1 root root 15086 May 13 17:02 favicon.ico
drwxr-xr-x 4 root root  4096 May 13 17:02 fonts
drwxr-xr-x 3 root root  4096 May 13 17:02 img
-rw-r--r-- 1 root root  7550 May 21 10:46 index.html
-rw-r--r-- 1 root root   469 May 21 10:46 index.xml
drwxr-xr-x 2 root root  4096 May 21 10:46 js
drwxr-xr-x 9 root root  4096 May 13 17:02 lib
-rw-r--r-- 1 root root   403 May 13 17:02 manifest.json
-rw-r--r-- 1 root root  2556 May 13 17:02 mstile-150x150.png
drwxr-xr-x 3 root root  4096 May 21 10:46 page
-rw-r--r-- 1 root root    66 May 21 10:46 robots.txt
-rw-r--r-- 1 root root  1355 May 13 17:02 safari-pinned-tab.svg
drwxr-xr-x 2 root root  4096 May 21 10:46 sass
-rw-r--r-- 1 root root   570 May 21 10:46 sitemap.xml
-rw-r--r-- 1 root root  3885 May 13 17:02 sitemap.xsl
drwxr-xr-x 2 root root  4096 May 21 10:46 tags
```

#####  推送到GitHub

逐步使用下列命令推送public目录下的文件到GitHub进行托管：

```bash
rm -rf public		
hugo 		#编译
cd public	#切换到public目录
git init	#初始化本地git仓库
git add .	#添加所有文件到本地git库
git commit -m "first commit"	#提交改动到本地git仓库并添加备注
git remote add origin https://github.com/YourName/YourName.github.io.git	#添加远程仓库源地址，注意地址后面要加上.git
git push -u origin master       #推送到github远程仓库YourName.github.io的master分支
```

为了减少后续的重复步骤，可以使用脚本进行推送：

```shell
#!/bin/bash

myblog_dir=/opt/myblog      #博客网站根目录
public=/opt/myblog/public   #生成的git静态网页
msg="build site `date`"         #git commit的备注信息

if [ -e $public ];then
        cd $myblog_dir
        rm -rf $public  #删除原有静态文件
        hugo --theme=m10c --baseUrl="https://YourName.github.io/" --buildDrafts     #指定主题编译成静态文件，存放在public
        cd $public
        git init
        git add .
        
        if [ $# -eq 1 ];then
          msg = "$1"
        fi
        git commit -m "$msg"
        git remote add origin https://github.com/YourName/YourName.github.io.git	#添加仓库源
        git push -u origin master  #推送到GitHub
        if [ $? -eq 0 ];then
                echo "文章已更新至github！"
        fi
fi
```

####  使用GitHub Pages实现访问

回到GitHub网站上，查看仓库上有没有刚刚推送的文件。再到YourName.github.io仓库的Settings->Pages，可以看到：

> GitHub Pages
>
> [GitHub Pages](https://pages.github.com/) is designed to host your personal, organization, or project pages from a GitHub repository.
>
>  Your site is published at https://YourName.github.io/

到这一步即可访问YourName.github.io来访问你的个人专属博客了。

####  使用GitHub Action自动化部署

> 每次写了博客，总得手动部署一下，虽然也只是一两行的命令，但还是觉得有些麻烦。之前看过另外一位博友的文章，得知可以利用 Github Action 实现博客的备份和自动生成的功能。这里记录一下。

#####  配置github_token

> 为什么需要token？ 当我们在通过Git提交源码之后，Github Actions会编译生成静态文件并通过Git Push到 gh-pages分支，这一步需要 Git 账户认证。

- 生成个人令牌：回到GitHub账号下的Setting -> Developer setting -> Personal access tokens-> Generate，生成并记录下来。

- 添加secret：回到GitHub账号youname.github.io仓库下的settings->secret->add。添加进刚才生成token，要特别注意变量名Name要设置为“GITHUB_TOKEN”的格式并记录下来，以便后面配置Action时，yaml文件的调用。

##### 配置GitHub Action

在youname.github.io仓库下，选择“Actions”，新建Action->Simple workflow ，之后会跳转到一个编辑yaml文件的页面，修改yml文件名为gh-pages.yml。会在仓库的main分支下生成.github/workflows/gh-pages.yaml文件。

yml文件代码可以参考如下，根据需要修改：

```yaml
# based on https://github.com/peaceiris/actions-hugo
name: github pages

on:
  push:  #  在push操作时触发
    branches:
      - main  # Set a branch to deploy

jobs:
  deploy:
    runs-on: ubuntu-18.04
    steps:
      - uses: actions/checkout@v2
        with:
          submodules: true  # Fetch Hugo themes (true OR recursive)
          fetch-depth: 0    # Fetch all history for .GitInfo and .Lastmod

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: '0.79.1'
          # extended: true

      - name: Build
        run: hugo --minify

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.ACCESS_TOKEN }}
          #publish_branch: gh-pages			#默认编译到gh-pages分支，可不写
          publish_dir: ./public
          cname: huang.pingyangblog.com
```

#####  推送博客源码

回到Linux的hugo站点目录下：

```bash

[root@web-blog myblog]# rm -rf public/					#删除之前编译的public目录

[root@web-blog myblog]# git checkout -b main			#本地创建main分支并切换至main分支

[root@web-blog myblog]# git pull origin main			#拉取刚刚在GitHub上新建的gh-pages.yml文件

[root@web-blog myblog]# git add .						#添加博客和主题所有文件到本地仓库

[root@web-blog myblog]# git commit -m "first commit"	#提交修改文件

[root@web-blog myblog]# git push origin main			#推送到GitHub的main分支
```

推送没问题回到GitHub，等待片刻查看Actions 是否部署成功，成功会显示绿色，并且在代码分支上会多出一条分支gh-pages，存放的是之前在本地hugo编译的public目录下的静态文件。

##### 修改Pages源分支

再到Settings->Pages选项下，修改source源分支为gh-pages，点击save。再访问https://yourname.github.io即可查看搭建的博客了。

至此，整个搭建就全部结束了，后续可以在本地使用hugo new命令新建文章push到GitHub，再到GitHub端进行编辑文章。

##### 域名绑定

自行购买服务器和域名，进行备案后，到Pages的域名绑定选项绑定即可。这里就不赘述了。

我这里是购买了一个十年的域名，然后服务器购买最低配最便宜的就行了，仅仅只是为了备案使用而已，或者选择境外的服务器则无需备案了。

###  搭建遇到的问题

####  hugo配置文件参数错误

在本地使用`hugo server`命令进行本地编译预览时报错:

`WARN 2020/02/17 20:51:06 found no layout file for "HTML" for "page": You should create a template file which matches Hugo Layouts Lookup Rules for this combination.`

意思为：“找不到用于“页面”的“ HTML”布局文件”。

原因是没有指定所使用的主题。由于`hugo new site mysite`新建出来的站点目录中，存放主题的目录名为“themes”，导致我以为hugo的站点配置文件config.toml里指定的主题键名为”themes“，而实际应该是“theme”才对，才能正常编译。

```bash
[root@web-blog myblog]# vim themes/even/exampleSite/config.toml
baseURL = "http://localhost:1313/"
languageCode = "en"
defaultContentLanguage = "en"                             # en / zh-cn / ... (This field determines which i18n file to use)
title = "Even - A super concise theme for Hugo"
preserveTaxonomyNames = true
enableRobotsTXT = true
enableEmoji = true
theme = "even"
```

####  编译成功访问页面没有文章显示

使用`hugo new post/index.md`新建的文章，是以`./archetypes/default.md`为模板创建的，默认的draft的值为true，hugo在编译时会忽略所有draft为true的文章，导致编译成功访问站点时发现没有文章显示。

**解决办法：文章中draft（草稿）的值需设置为false，或者去掉./archetypes/default.md文件中的draft参数**

####  每次git push之后，刷新站点就显示404

写完文章push到github上之后，再刷新站点会显示404，网页找不到。然后到github pages检查发现之前绑定的域名被清空了。

**解决办法：需要在gh-pages.yaml文件中加上cname选项，值为自己的域名。**

```yaml
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.ACCESS_TOKEN }}
          publish_dir: ./public
          cname: domain.com
```

### 参考链接

Hugo官网：https://gohugo.io/

Hugo中文网：https://www.gohugo.cn/hosting-and-deployment/hosting-on-github/

Hugo中文帮助手册：https://hugo.aiaide.com/

[Github Action 官方文档](https://docs.github.com/cn/actions/guides/about-continuous-integration)

[GitHub Actions 入门教程](https://www.ruanyifeng.com/blog/2019/09/getting-started-with-github-actions.html)

###  Git操作命令总结

- **git push**

  git push 命用于从将本地的分支版本上传到远程并合并。命令格式如下：

  `git push <远程主机名> <本地分支名>:<远程分支名>`

  如果本地分支名与远程分支名相同，则可以省略冒号：
  `git push <远程主机名> <本地分支名>`
- **git push -f**
> 覆盖远程GitHub仓库的代码，强制推送。主要是为了解决本地仓库内容和远程仓库不一致而导致的push失败报错的问题，（在正常的开发项目中一般不建议这样操作，因为会覆盖所有其他成员提交的代码，只保留你自己的，属于危险操作！）：

```
git push -f origin master		#强制推送到origin源
git push -u origin master		#正常推送到origin源
```

- **git checkout -b main**			#创建main分支并切换到main分支

- **git remote -v**					       #查看本地添加的源地址

- 添加主题：使用git添加子模块的方式添加主题源地址，信息保存在.gitmodule

  ```
  git submodule add https://github.com/halogenica/beautifulhugo.git themes/beautifulhugo
  ```

  

