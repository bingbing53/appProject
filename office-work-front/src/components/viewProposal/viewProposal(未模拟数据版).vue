
<template>
  <div style="padding:15px">
    <div class="tianBox">
      <van-row class="pad35">
        <span class="font28">提案分类</span>
      </van-row>
      <van-row class="pad35">
        <span class="font28">提案标题：</span>尽快尽快尽快将科技将尽快尽快
      </van-row>
      <van-row class="pad35 tianText">
        <span class="font28">提案内容：</span>
        <p class="font26">您好，这是本次小区改建的主要提案内容之一，你 积分的结合房价多少附近可兑换防静电带回家回到家， 第三方接电话度计划几点几分跨时代讲课的佳都科技近</p>
        <p class="font26">您好，这是本次小区改建的主要提案内容之一，你 积分的结合房价多少附近可兑换防静电带回家回到家， 第三方接电话度计划几点几分跨时代讲课的佳都科技近</p>
      </van-row>
      <van-row class="pad35">
        <van-cell center title="是否公示" class="font28">
          <template #right-icon>
            <van-switch v-model="isPublicity" size="24" />
          </template>
        </van-cell>
        <p class="font24">说明：如公示，则该提案则会发布到社区公众号中进行公示， 社区表将会看到您的提案</p>
      </van-row>
      <van-row class="pad35">
        <van-cell center title="是否投票" class="font28">
          <template #right-icon>
            <van-switch v-model="isVote" size="24" />
          </template>
        </van-cell>
        <p class="font24">说明：第三方放松放松sffs第三方放松放松sffs第三方放松放松sffs第三方放松放松sffs第三方放松放松sffs第三方放松放松sffs第三</p>
      </van-row>
      <van-row class="pad35">
        <van-cell center title="是否允许居民发表意见" class="font28">
          <template #right-icon>
            <van-switch v-model="isOpinion" size="24" />
          </template>
        </van-cell>
        <p class="font24">说明：如允许投票，则社区居民可以对该提案投赞同或反对票</p>
      </van-row>
    </div>
    <!-- 提案讨论会 -->
    <h2 class="talkBoxTitle">提案讨论会</h2>
    <div class="talkBox">
      <p style="margin-bottom:20px">
        <label class="font26">参会人：</label>
        <span class="font30">李丽丽</span>
      </p>
      <div class="jiyao">
        <label class="font26">会议纪要：</label>
        <p>您好，这是本次小区改建的主要提案内容之一，你 积分的结合房价多少附近可兑换防静电带回家回到家， 第三方接电话度计划几点几分跨时代讲课的佳都科技近</p>
        <p>您好，这是本次小区改建的主要提案内容之一，你 积分的结合房价多少附近可兑换防静电带回家回到家， 第三方接电话度计划几点几分跨时代讲课的佳都科技近</p>
      </div>
    </div>
    <!-- 居民投票结果 -->
    <h2 class="talkResultTitle">居民投票结果</h2>
    <div class="resultBox">
      <div>
        <span>10</span>
        <p>
          <img src="../../assets/img/统计.png" alt />总票数
        </p>
      </div>
      <div>
        <span>10</span>
        <p>
          <img src="../../assets/img/赞同-fill.png" alt />赞同数
        </p>
      </div>
      <div>
        <span>10</span>
        <p>
          <img src="../../assets/img/赞同-fill(1).png" alt />反对数
        </p>
      </div>
    </div>
    <!-- 居民反馈意见 -->
    <h2 class="issueTitle">居民反馈意见</h2>
    <div class="issueBox">
      <div class="issueDetail">
        <p>这个提案太好了咱村可以实现么？</p>
        <div>
          <span>
            <img src="../../assets/img/人.png" alt />张三
          </span>
          <span>
            <img src="../../assets/img/电话.png" alt />10213065120
          </span>
          <span>
            <img src="../../assets/img/房子222.png" alt />村一社区XX楼XX单元
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      isPublicity: false,
      isVote: false,
      isOpinion: false,
    };
  },
};
</script>

<style scope>
.font24 {
  font-size: 24px;
}
.font26 {
  font-size: 26px;
}
.font30 {
  font-size: 30px;
}
/* 提案分类 */
.tianBox {
  background: #fff;
}
.pad35 {
  line-height: 37px;
  padding: 35px;
  /* height: 109px; */
  font-size: 28px;
  border-bottom: 1px solid rgba(52, 52, 52, 0.1);
}
.tianText {
  font-weight: Medium;
}
.tianText p {
  margin-top: 15px;
  text-indent: 50px;
  line-height: 45px;
}
.van-cell {
  padding: 0px 0px 8px 0px;
  /* border: 1px solid red; */
}
/* 提案讨论会 */
.talkBoxTitle,
.talkResultTitle,
.issueTitle {
  font-size: 32px;
  font-family: PingFang SC;
  font-weight: bold;
  color: #343434;
  line-height: 37px;
  /* border: 1px solid red; */
  padding-top: 50px;
  padding-bottom: 30px;
}
.talkBox,
.resultBox,
.issueBox {
  background: #fff;
  padding: 20px;
}
.jiyao p {
  font-size: 26px;
  font-family: PingFang SC;
  font-weight: 500;
  color: #343434;
  line-height: 39px;
  margin-top: 15px;
  text-indent: 50px;
}
/* 居民投票结果 */
.resultBox {
  display: flex;
  justify-content: space-between;
}
.resultBox div span {
  width: 100%;
  display: inline-block;
  text-align: center;
  font-size: 40px;
  font-family: PingFang SC;
  font-weight: 500;
  color: #343434;
  line-height: 37px;
}
.resultBox div p {
  font-size: 24px;
  font-family: PingFang SC;
  font-weight: 500;
  color: #343434;
  margin-top: 10px;
}
.resultBox div p img {
  width: 30px;
  height: 28px;
  margin-right: 8px;
}

/* 居民反馈意见 */
.issueDetail p {
  font-size: 28px;
  font-family: PingFang SC;
  font-weight: 500;
  color: #343434;
  height: 85px;
  line-height: 85px;
  border-bottom: 1px solid rgba(52, 52, 52, 0.1);
}
.issueDetail div {
  height: 85px;
  line-height: 85px;
}
.issueDetail div span {
  /* display: inline-block; */
  margin-right: 28px;
  font-size: 26px;
  font-family: PingFang SC;
  font-weight: 500;
  color: #343434;
  line-height: 39px;
}
.issueDetail div span img {
  width: 22px;
  height: 20px;
  margin-right: 4px;
}
</style>