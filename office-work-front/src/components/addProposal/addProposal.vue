<template>
  <div class="addProposal">
    <van-row>
      <label>提案分类</label>
      <span>提案分类内容</span>
    </van-row>
    <van-row>
      <label>提案标题</label>
      <span>提案标题</span>
    </van-row>
    <van-row>
      <label>提案内容</label>
      <p class="label_msg">
        您好，这是本次小区改建的主要提案内容之一，你
        积分的结合房价多少附近可兑换防静电带回家回到家，
        第三方接电话度计划几点几分跨时代讲课的佳都科技近
      </p>
    </van-row>
    <!-- <van-row>
      <label>是否公示</label>
      <van-switch v-model="checked" size="24" />
    </van-row>-->
    <van-cell center title="是否公示">
      <template #right-icon>
        <van-switch v-model="isPublicity" size="24" />
      </template>
    </van-cell>
    <van-row>
      <p class="hasExplain">说明：如公示，则该提案会被发布到社区公众号中进行公示，社区居民将会看到您的提案</p>
    </van-row>
    <van-cell center title="是否投票">
      <template #right-icon>
        <van-switch v-model="isVote" size="24" />
      </template>
    </van-cell>
    <van-row>
      <p class="hasExplain">说明：如允许投票，则社区居民可以对该提案投赞同或反对票</p>
    </van-row>
    <van-cell center title="是否允许居民发表意见">
      <template #right-icon>
        <van-switch v-model="isOpinion" size="24" />
      </template>
    </van-cell>
    <van-row>
      <p class="hasExplain">说明：如允许,则居民可针对改提案提出自己的建议</p>
    </van-row>
    <div class="btnSure">
      <van-button type="info" size="normal" @click="send">提交</van-button>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      isPublicity: false, //是否公示
      isVote: false, //是否投票
      isOpinion: false, //是否允许居民发表意见
    };
  },
  methods: {
    //  初始化
    init() {},
    // 提交
    send() {},
  },
  mounted() {},
};
</script>
<style scope>
.addProposal {
  margin: 20px 30px;
  position: fixed;
  top: 0;
  bottom: 0;
  /* border: 1px solid red; */
  background: #fff;
  font-size: 16px;
}
.addProposal .van-row {
  margin: 0 30px;
  /* height: 101px; */
  line-height: 100px;
  /* padding: 30px 0; */
  /* padding-left: 35px; */
  border-bottom: 1px solid rgba(51, 51, 51, 0.1);
  font-size: 28px;
  font-family: PingFang SC;
  font-weight: 500;
  color: #656565;
}
.van-row label {
  margin-right: 15px;
}
.van-row span {
  color: #333;
}
.van-row p.label_msg {
  line-height: 20px;
  margin-top: -8px;
  margin-bottom: 15px;
  text-indent: 2em;
  color: #333;
  font-size: 13px;
}
.btnSure {
  margin-top: 150px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 36px;
  font-family: PingFang SC;
  font-weight: bold;
  color: #ffffff;
}
.van-button--normal {
  width: 200px;
  border-radius: 25px;
}
/* .van-button {
  margin-left: calc((100%-58) / 2);
} */
.hasExplain {
  line-height: 40px;
  font-size: 24px;
  font-family: PingFang SC;
  font-weight: 500;
  color: #333333;
  margin-bottom: 15px;
}
.van-cell::after {
  border-bottom-color: transparent;
}
</style>