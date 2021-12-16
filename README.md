# hyoung.site

Built using [Hugo](https://github.com/gohugoio/hugo) and hosted on [GitHub Pages](https://pages.github.com/).

Address: https://hyoung.site

## Editing

Launch a local Hugo server including live reload by running (append `-F` for including future posts):

```shell
hugo server -D --debug
```

You can manually create content files (for example as `content/<CATEGORY>/<FILE>.<FORMAT>`) and provide metadata in them, however you can use the `new` command to do a few things for you (like add title and date):

```shell
hugo new posts/my-first-post.md
```

Edit the newly created file under `content/post`, update the header of the post to say `draft: false`,
you can view the live changes in the browser http://localhost:1313/


## Deploy to Github Pages


Push updates to `main` branch will trigger a github action to deploy the updates automatically.

see [.github/workflows/gh-pages.yml](/.github/workflows/gh-pages.yml) for details.

## picture

The custom picture in `static` folder .

文章内的图片引用：
- 相对路径：放在文章同级目录下直接引用：`![图片名](images.jpg)`
- 绝对路径：放在./static/images下引用：`![图片名](/images/images.jpg "图片下方说明")`
- 文章首页加载图片，在文章开头：
```
resources:
- name: "featured-image"
  src: "xxx.jpg"
```
音视频引用：

- 网易云：替换音乐id，在网易云网页端搜索音乐，开发者模式查看音乐id，在填入代码到文章中即可：`{{< music server="netease" type="song" id="298317" >}}`
- 其他三方音乐：直接web搜索音乐，点击歌曲播放页的生成外链，复制代码到文章中即可：`<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=330 height=86 src="//music.163.com/outchain/player?type=2&id=559227860&auto=1&height=66"></iframe>`

```
## transplant

Install hugo and git, use `git clone ` to localhost, then start go on write the article.
