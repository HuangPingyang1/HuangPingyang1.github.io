# pingyangblog.com

Built using [Hugo](https://github.com/gohugoio/hugo) and hosted on [GitHub Pages](https://pages.github.com/).

Address: https://pingyangblog.com

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
> 文章内的图片引用：
		相对路径：放在文章同级目录下直接引用：![口琴](harmonica.jpg)
		绝对路径：放在./static/images下引用：![口琴](/images/harmonica.jpg)/

## transplant

Install hugo and git, use `git clone ` to localhost, then start go on write the article.
