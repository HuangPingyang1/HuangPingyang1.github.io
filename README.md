# pingyangblog.com

Ryan4Yin's Space, built using [Hugo](https://github.com/gohugoio/hugo) and hosted on [GitHub Pages](https://pages.github.com/).

Address: https://pingyangblog.com

## Editing

Launch a local Hugo server including live reload by running (append `-F` for including future posts):

```shell
hugo server -D --debug
```

You can manually create content files (for example as `content/<CATEGORY>/<FILE>.<FORMAT>`) and provide metadata in them, however you can use the `new` command to do a few things for you (like add title and date):

```shell
hugo new post/my-first-post.md
```

Edit the newly created file under `content/post`, update the header of the post to say `draft: false`,
you can view the live changes in the browser http://localhost:1313/


## Deploy to Github Pages


Push updates to `main` branch will trigger a github action to deploy the updates automatically.

see [.github/workflows/gh-pages.yaml](/.github/workflows/gh-pages.yaml) for details.

## picture

The custom picture in `static` folder .

## transplant

Install hugo and git, use `git clone ` to copy the all file.
