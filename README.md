#### 配置文件：config.toml。
> 可以配置：主题名、使用的git URL，文章的归档、分类、关于我、友链等功能

#### 图片地址：./themes/even/static

#### 文章的原型：./archetypes/default.md 。（hugo new post/txt生成的文章以default.md为原型创建）
> ./archetypes/default.md（hugo new post/xxx.md生成的文章以default.md为原型创建），里面可以设置draft为false。
> 由于hugo编译的时候会忽略"draft：true"的文章，所以文章里面的draft必须改为false。

