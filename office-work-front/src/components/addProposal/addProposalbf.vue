<template>
  <div class="wrap">
    <div class="wrapcontent">
      <div class="addProposal">
        <van-row>
          <label>提案编号</label>
          <!-- <span>提案分类内容</span> -->
          <input class="input" :disabled="disabled" v-model="proposalNo" placeholder />
        </van-row>
        <van-row>
          <label>提案分类</label>
          <!-- <span>提案分类内容</span> -->
          <!-- <input class="input" :disabled="disabled" v-model="type" placeholder /> -->
          <div class="option">
            <select :disabled="disabled" @change="getValue" v-model="type">
              <option>--请选择--</option>
              <option
                v-for="(item, index) in ProposalTypeList"
                :key="index"
                :value="item.value"
              >{{ item.text }}</option>
            </select>
          </div>
        </van-row>
        <van-row>
          <label>提案标题</label>
          <!-- <span>提案标题</span> -->
          <input :disabled="disabled" class="input" v-model="title" placeholder />
        </van-row>
        <van-row>
          <label>提案内容</label>
          <!-- <p class="label_msg">
        您好，这是本次小区改建的主要提案内容之一，你
        积分的结合房价多少附近可兑换防静电带回家回到家，
        第三方接电话度计划几点几分跨时代讲课的佳都科技近
          </p>-->
          <textarea class="textarea" :disabled="disabled" v-model="content" placeholder />
        </van-row>
        <!-- <van-row>
      <label>是否公示</label>
      <van-switch v-model="checked" size="24" />
        </van-row>-->
        <van-cell center title="是否公示">
          <template #right-icon>
            <van-switch
              :active-value="1"
              :inactive-value="0"
              @change="changePublicity"
              v-model="publicity"
              size="24"
            />
          </template>
        </van-cell>
        <van-row>
          <p class="hasExplain">说明：如公示，则该提案会被发布到社区公众号中进行公示，社区居民将会看到您的提案</p>
        </van-row>
        <van-cell center title="是否投票">
          <template #right-icon>
            <van-switch :active-value="1" :inactive-value="0" v-model="canvote" size="24" />
          </template>
        </van-cell>
        <van-row>
          <p class="hasExplain">说明：如允许投票，则社区居民可以对该提案投赞同或反对票</p>
        </van-row>
        <van-cell center title="是否允许居民发表意见">
          <template #right-icon>
            <van-switch :active-value="1" :inactive-value="0" v-model="canjudge" size="24" />
          </template>
        </van-cell>
        <van-row>
          <p class="hasExplain">说明：如允许,则居民可针对改提案提出自己的建议</p>
        </van-row>
        <div class="btnSure">
          <van-button v-if="!disabled || id == undefined" type="info" size="normal" @click="send">提交</van-button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { addProposal, getProposalList, getProposalType } from "@/api/proposal";
export default {
  data() {
    return {
      id: null, //我的楼俺跳转的有id
      disabled: false, //禁用
      proposalNo: 8,
      type: "",
      title: "",
      content: "",
      publicity: 0, //是否公示
      canvote: 0, //是否投票
      canjudge: 0, //是否允许居民发表意见
      selecttype: "",
      ProposalTypeList: [],
    };
  },

  methods: {
    //  初始化
    init() {},
    // 是否公示
    changePublicity(val) {
      console.log(val, "val");
      //   if (val == 1) {
      //     this.disabled = true;
      //   } else {
      //     this.disabled = false;
      //   }
    },
    getProposalTypeList() {
      getProposalType().then((res) => {
        console.log(res, 1111111);
        this.ProposalTypeList = res;
      });
    },
    // 提交
    send() {
      let data = {
        proposalNo: this.proposalNo,
        type: this.type,
        title: this.title,
        content: this.content,
        publicity: this.publicity,
        canvote: this.canvote,
        canjudge: this.canjudge,
      };
      addProposal(data).then((res) => {
        this.$router.push({
          name: "proposal",
        });
      });
    },
    getValue() {
      console.log(this.type, "this.type");
    },
  },
  //   watch: {
  //     $route: {
  //       handler: function(val, oldval) {
  //         console.log(val, "val");
  //         console.log(oldval, "oldval");
  //       },
  //     },
  //     deep: true,
  //   },
  beforeRouteEnter(to, from, next) {
    console.log(from, "form.name");
    let item = JSON.parse(localStorage.getItem("item"));
    console.log(item, "item");
    if (from.name == "publicopinion") {
      //   this.content = item.content;
      //   this.title = item.title;
    }
    next();
  },
  beforeRouteLeave() {
    localStorage.removeItem("item");
  },
  mounted() {
    console.log(this.$route.query, "this.$route.query");
    this.proposalNo = null;
    this.type = null;
    // this.title = JSON.parse(localStorage.getItem("item")).title ;
    // this.content = JSON.parse(localStorage.getItem("item")).content ;
    this.publicity = 0;
    this.canvote = 0;
    this.canjudge = 0;
    this.content = this.$route.query.content || null;
    this.title = this.$route.query.title || null;
    console.log(this.content, this.title, 1111);
    this.getProposalTypeList();
  },
};
</script>
<style scope>
.wrap {
  position: fixed;
  top: 0;
  bottom: 0;
  /* border: 1px solid red; */
}

.wrapcontent {
  height: 100%;
  overflow: scroll;
  /* border: 1px solid blue; */
}
.input {
  border: 0;
  margin-left: 10px;
}
.textarea {
  border: none;
  height: 150px;
  width: 100%;
  text-indent: 50px;
}
.addProposal {
  margin: 20px 30px;
  /* position: fixed; */
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
  margin-top: 90px;
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
.option {
  display: inline;
  /* margin: 100px; */
  /* width: 140px;
  height: 40px; */
  border: 1px solid #cccccc;
  position: relative;
}
.option select {
  border: none;
  outline: none;
  padding-left: 20px;
}
</style>
