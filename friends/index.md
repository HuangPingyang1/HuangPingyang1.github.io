# 友链

>感谢 @Ryan4Yin 提供了友链页面模板~

在友链形成的网络中漫游，是一件很有意思的事情。

**以前的人们通过信笺交流，而我们通过友链串联起一个「世界」。希望你我都能在这个「世界」中有所收获**

**注：** <span style="color:red;">下方友链次序每次刷新页面随机排列。<span>

<div class="linkpage"><ul id="friendsList"></ul></div>

## 交换友链

如果你觉得我的博客有些意思，而且也有自己的独立博客，欢迎与我交换友链~

可通过 [Issues](https://github.com/HuangPingyang1/HuangPingyang1.github.io/issues) 或者评论区提交友链申请，格式如下：

    站点名称：Yuepu`s Blog
    站点地址: https://pingyangblog.com/
    个人形象：https://pingyangblog.com/images/avatar.jpg
    站点描述：不急，但是不停~


<script type="text/javascript">
// 以下为样例内容，按照格式可以随意修改
var myFriends = [
    ["https://chee5e.space", "https://chee5e.space/images/avatar.jpg", "@芝士部落格", "有思想，也有忧伤和理想，芝士就是力量"], 
    ["https://blog.k8s.li/", "/avatar/muzi.png", "@木子", "垃圾佬、搬砖社畜、运维工程师 <= DevOps"], 
    ["https://panqiincs.me/", "https://panqiincs.me/images/avatar.jpg", "@辛未羊", "人生如逆旅，我亦是行人"], 
    ["https://ryan4yin.space/", "/avatar/myself.jpg", "@ryan4yin", "k8s技术圈群友,devops engineer"]
    ["https://zhaoqi.vip/", "", "@zhaoqi", "京东DevOps"]
    ["https://www.junmajinlong.com/", "", "@骏马金龙", "Linux、shell教程"]
    ["https://coolshell.cn/", "", "@左耳朵耗子-陈皓", ""]
    ["https://ruanyifeng.com", "", "@阮一峰", ""]
    ["https://jweny.top/", "", "@奇虎360云安全Dev", ""]
    ["https://www.yunyoujun.cn/", "", "@云游君", "H5小空调作者"]
    ["https://www.qianguyihao.com/", "", "@千古壹号", "github著有前端教程"]
    ["https://immmmm.com/", "", "@木木木木木木", ""]
    ["https://hjxlog.com/", "", "@hjx", "java Dev"]
];



// 以下为核心功能内容，修改前请确保理解您的行为内容与可能造成的结果
var  targetList = document.getElementById("friendsList");
while (myFriends.length > 0) {
    var rndNum = Math.floor(Math.random()*myFriends.length);
    var friendNode = document.createElement("li");
    var friend_link = document.createElement("a"), 
        friend_img = document.createElement("img"), 
        friend_name = document.createElement("h4"), 
        friend_about = document.createElement("p")
    ;
    friend_link.target = "_blank";
    friend_link.href = myFriends[rndNum][0];
    friend_img.src=myFriends[rndNum][1];
    friend_name.innerText = myFriends[rndNum][2];
    friend_about.innerText = myFriends[rndNum][3];
    friend_link.appendChild(friend_img);
    friend_link.appendChild(friend_name);
    friend_link.appendChild(friend_about);
    friendNode.appendChild(friend_link);
    targetList.appendChild(friendNode);
    myFriends.splice(rndNum, 1);
}
</script>


<style>

.linkpage ul {
    color: rgba(255,255,255,.15)
}

.linkpage ul:after {
    content: " ";
    clear: both;
    display: block
}

.linkpage li {
    float: left;
    width: 48%;
    position: relative;
    -webkit-transition: .3s ease-out;
    transition: .3s ease-out;
    border-radius: 5px;
    line-height: 1.3;
    height: 90px;
    display: block
}

.linkpage h3 {
    margin: 15px -25px;
    padding: 0 25px;
    border-left: 5px solid #51aded;
    background-color: #f7f7f7;
    font-size: 25px;
    line-height: 40px
}

.linkpage li:hover {
    background: rgba(230,244,250,.5);
    cursor: pointer
}

.linkpage li a {
    padding: 0 10px 0 90px
}

.linkpage li a img {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    position: absolute;
    top: 15px;
    left: 15px;
    cursor: pointer;
    margin: auto;
    border: none
}

.linkpage li a h4 {
    color: #333;
    font-size: 18px;
    margin: 0 0 7px;
    padding-left: 90px
}

.linkpage li a h4:hover {
    color: #51aded
}

.linkpage li a h4, .linkpage li a p {
    cursor: pointer;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
    line-height: 1.4;
    margin: 0 !important;
}

.linkpage li a p {
    font-size: 12px;
    color: #999;
    padding-left: 90px
}

@media(max-width: 460px) {
    .linkpage li {
        width:97%
    }

    .linkpage ul {
        padding-left: 5px
    }
}

</style>

