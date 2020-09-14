<template>
  <div class="my-proposal-edit">
    <!-- 提案内容 -->
    <div class="proposal-content-edit">
      <h2>提案内容</h2>
      <a class="go-meeting">进入会议</a>
      <div class="proposal-num">
        <label>提案编号：</label>
        <span>111</span>
      </div>
      <div class="proposal-title">
        <label>提案标题：</label>
        <span>学习党的十九届四中全会精神</span>
        <div class="proposal-type displayL">
          <label>提案分类：</label>
          <span class="widthMin">学习</span>
        </div>
      </div>
      <div class="proposal-content">
        <label>提案内容：</label>
        <p>
          2019年12月27日上午，方舟苑社区党委根据街道党委“不忘初心、牢记使命”的工作部署，及上级部门工作有关要求，依托新时代文明实践站，在9号楼地下活动室进行了以“党的十九届四中全会精神”为主题的宣讲活动。
          会上，党委书记苏彦荣带领同志们学习了《党的十九届四中全会精神》。结合社区实际，深入浅出，具体生动地讲解如何切实把十九届四中全会精神贯彻好、落实好，让广大党员干部群众看到我们党增强治理体系和治理能力现代化的决心，并在日常工作学习中，严格要求自己，为党和国家的发展作出贡献。
        </p>
      </div>
      <div class="proposal-people">
        <label>提案创建人：</label>
        <span>丽丽</span>
        <div class="proposal-date displayL">
          <label>提案日期：</label>
          <span class="widthMin">2020-9-11</span>
        </div>
      </div>

      <div class="has-vote">
        <label>是否可投票：</label>
        <span>是</span>
      </div>
      <div class="has-comment">
        <label>是否可评论：</label>
        <span>是</span>
      </div>
      <div class="has-publicity">
        <label>是否公示：</label>
        <span>是</span>
      </div>
      <div class="proposal-state">
        <div>
          <label>总票数：</label>
          <span>10</span>
        </div>
        <div>
          <label>赞成数：</label>
          <span>10</span>
        </div>
        <div>
          <label>反对数：</label>
          <span>10</span>
        </div>
        <div>
          <label>浏览量：</label>
          <span>10</span>
        </div>
      </div>
    </div>
    <!-- 评论列表 -->
    <div class="proposal-content-comment">
      <h2>评论列表</h2>
      <ul class="comment-content">
        <li class="comment-list">
          <label>丽丽</label>
          <span>2020-9-11</span>
          <a>删除</a>
          <p>让广大党员干部群众看到我们党增强治理体系和治理能力现代化的决心，并在日常工作学习中，严格要求自己，为党和国家的发展作出贡献</p>
        </li>
        <li class="comment-list">
          <label>丽丽</label>
          <span>2020-9-11</span>
          <a>删除</a>
          <p>让广大党员干部群众看到我们党增强治理体系和治理能力现代化的决心，并在日常工作学习中，严格要求自己，为党和国家的发展作出贡献</p>
        </li>
        <li class="comment-list">
          <label>丽丽</label>
          <span>2020-9-11</span>
          <a>删除</a>
          <p>让广大党员干部群众看到我们党增强治理体系和治理能力现代化的决心，并在日常工作学习中，严格要求自己，为党和国家的发展作出贡献</p>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  name: "HelloWorld",
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="../assets/css/reset.css"></style>
<style scoped >
.fl {
  float: left;
}
.fr {
  float: right;
}
.displayL {
  display: inline;
}
/* 提案内容 */
.proposal-content-edit {
  position: relative;
}
.go-meeting {
  position: absolute;
  top: 10px;
  right: 10px;
  background-color: #3b6bf3;
  color: #fff;
  padding: 10px 20px;
  border-radius: 20px;
}
.proposal-content-edit .widthMin {
  width: 200px;
}
.proposal-content-edit {
  /* border: 1px solid red; */
  width: 800px;
  padding: 10px;
  margin-bottom: 20px;
}
.proposal-content-edit h2,
.proposal-content-comment h2 {
  font-size: 18px;
  color: #606266;
  line-height: 35px;
}
.proposal-content-edit div {
  font-size: 16px;
  color: #606266;
}
.proposal-content-edit div label,
.proposal-content-comment div label {
  line-height: 30px;
}
.proposal-content-edit div span {
  display: inline-block;
  /* border: 1px solid rgba(51, 51, 51, 0.5); */
  width: 350px;
}
.proposal-content-edit div p {
  line-height: 24px;
  font-size: 15px;
  text-indent: 2em;
  border: 1px solid rgba(51, 51, 51, 0.1);
  padding: 10px;
  border-radius: 10px;
  margin-bottom: 10px;
}
.proposal-state > div {
  display: inline;
  margin-right: 10px;
}
.proposal-state > div span {
  width: 50px;
}
/* 评论列表 */
.proposal-content-comment {
  /* border: 1px solid blue; */
  padding: 10px;
  width: 800px;
}
.proposal-content-comment span {
  display: inline;
  font-size: 12px;
  margin-left: 20px;
}
.comment-list {
  padding: 10px;
  border: 1px solid rgba(51, 51, 51, 0.1);
  box-shadow: inset 0 0 5px #ccc;
  position: relative;
  margin-bottom: 20px;
}
.comment-list p {
  margin: 5px 10px;
}
.proposal-content-comment li {
  font-size: 16px;
  color: #606266;
}
.comment-list a {
  position: absolute;
  right: 20px;
  top: 5px;
  color: red;
  font-size: 14px;
}
</style>
