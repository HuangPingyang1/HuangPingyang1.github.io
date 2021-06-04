# 主题优化-添加评论系统和内置搜索

###  添加评论系统

####  启用评论系统utterances

- 在hugo的配置文件（config.toml）中启用utterances，打开config.toml，添加如下：

  ```toml
        # Utterances comment 评论系统设置 (https://utteranc.es/)
        [params.page.comment.utterances]
          enable = true
          # owner/repo
          repo = "YourUsername/YourUsername.github.io"	##自己的github仓库地址
          issueTerm = "pathname"
          label = ""
          lightTheme = "github-light"
          darkTheme = "github-dark"
  ```

repo的格式为：github用户名/创建的仓库名

#### github上安装 utterances

- 首先必须在 github 上进行安装 utterances，访问 [utterances应用程序](https://github.com/apps/utterances) 然后点击 Install 按钮进行安装。
- 在这里可以选择可以关联的存储库，可以选择我们所拥有的库(也包括未来建立的库)或者某一个仓库，这里只选择某一个需要进行评论的库，这样比较好。
- 安装完成即可，随后访问 [utterances应用程序](https://github.com/apps/utterances) 就不再是安装而是是执行配置项目。
- 此时服务端配置已经完成，接着访问博客测试下评论。

###  内置搜索系统（暂未实现）
- 实现原理：
每次把博客编译成静态文章，同时生成所有文章的索引保存在json文件中，然后上传至algolia搜索账号中，algolia通过本地配置的appid和key实现连接，并提供搜索服务。


