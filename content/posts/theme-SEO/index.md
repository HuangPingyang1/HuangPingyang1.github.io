---
title: "主题优化-添加评论系统和内置搜索"
subtitle: ""
date: 2021-06-04T16:32:38+08:00
lastmod: 2021-06-04T16:32:38+08:00
draft: false
tags: []
categories: []

---
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

###  内置搜索系统
- **原理：在执行push操作触发Actions编译站点代码到./public目录后，再执行生成索引文件操作，生成index.json到./public目录，并自动上传文章索引至algolia上，以实现站内搜索功能。**

####  algolia实现内置搜索
- 前往官方网站https://www.algolia.com/ 使用 GitHub 或 Google 帐号登录。登录完成后根据提示信息填写一些基本的信息即可，注册完成后前往 Dashboard，我们可以发现 Algolia 会默认给我们生成一个 app。

- 选择 Indices，添加一个新的索引，index-name索引名自定义填写，并记录下来，后面网站配置要用到。再选择API keys，记录“Search-Only API Key”、“Admin API Key”两个秘钥。
- 由于我这里使用的主题是[LoveIt](https://github.com/dillonzq/LoveIt)，主题配置文件config.toml内置支持algolia插件，所以只需要在站点目录下的config.toml中，配置刚刚生成的索引和Search-Only API Key即可：

```toml
[root@web-blog web]# vim config.toml
      [languages.zh-cn.params.search]
        enable = true
        # 搜索引擎的类型 ("lunr", "algolia")
        type = "algolia"
        # 文章内容最长索引长度
        contentLength = 4000
        # 搜索框的占位提示语
        placeholder = ""
        # 最大结果数目
        maxResultLength = 10
        # 结果内容片段长度
        snippetLength = 50
        # 搜索结果中高亮部分的 HTML 标签
        highlightTag = "em"
        # 是否在搜索索引中使用基于 baseURL 的绝对路径
        absoluteURL = false
        [languages.zh-cn.params.search.algolia]
          index = "yuepu-blog"				#索引名称
          appID = "SSC09FNCJM"				#应用ID
          searchKey = "b42948e51daaa93df92381c8e2ac0f93"		#Search-Only API Key
```

####  利用GitHub Action配置自动上传索引文件

编辑GitHub Action的CI/CD 配置文件gh-pages.yml，安装algoliasearch，并且使用Node.js配置秘钥文件：

```toml
[root@web-blog web]# vim .github/workflows/gh-pages.yml
...
      - name: Use Node.js
        uses: actions/setup-node@v1
        with:
          node-version: '15.x'
      - name: Push Argolia Index
        run: |
          npm install algoliasearch			#安装algoliasearch插件
          node push_argolia_index.js		#使用我们配置的js文件
        env:
          ALGOLIA_ADMIN_KEY: ${{ secrets.ALGOLIA_ADMIN_KEY }}
```

然后在站点根目录新建push_argolia_index.js文件，内容如下：

```js
/*
上传 algolia 索引文件
参考：https://www.algolia.com/doc/guides/getting-started/quick-start/tutorials/quick-start-with-the-api-client/javascript/?client=javascript
*/

// For the default version
const algoliasearch = require('algoliasearch');

const appID = "747LJ10EI7"
const indexName = "ryan-space"
const adminKey = process.env.ALGOLIA_ADMIN_KEY
const indexFile = "./public/index.json"

const client = algoliasearch(appID, adminKey);
const index = client.initIndex(indexName);
const indexJson = require(indexFile);

index.saveObjects(indexJson, {
  autoGenerateObjectIDIfNotExist: true
}).then(({ objectIDs }) => {
  console.log(objectIDs);
});
```

这里我们一直没有用到的Admin API Key，需要在Setting -> Secrets，新建仓库秘钥，名字取为`ALGOLIA_ADMIN_KEY`，以便Action 和 js中调用。

至此，配置就完成了。

### 参考
- [Hugo 博客使用 utterances 作为评论系统](https://www.midfang.com/hugo-utterances-comment-system/)
- [algolia官网](https://www.algolia.com/)
- 上传 algolia 索引文件
参考：https://www.algolia.com/doc/guides/getting-started/quick-start/tutorials/quick-start-with-the-api-client/javascript/?client=javascript
