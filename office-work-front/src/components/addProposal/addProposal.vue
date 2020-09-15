<template>
  <div class="wrap">
    <div class="wrapcontent">
      <div class="addProposal">
        <!-- <van-row>
          <label>提案编号：</label>
          <input class="input" v-model="proposalNo" placeholder />
        </van-row>-->
        <van-row>
          <label>提案分类：</label>
          <!-- <div class="option"> -->
          <!-- <select @change="getValue" v-model="type">
              <option>--请选择--</option>
              <option
                v-for="(item, index) in ProposalTypeList"
                :key="index"
                :value="item.value"
              >{{ item.text }}</option>
          </select>-->
          <van-dropdown-menu class="option">
            <van-dropdown-item v-model="value" :options="ProposalTypeLists" />
          </van-dropdown-menu>
          <!-- </div> -->
        </van-row>
        <van-row>
          <label>提案标题：</label>
          <input class="input" v-model="title" placeholder />
        </van-row>
        <van-row>
          <label>提案内容：</label>
          <textarea class="textarea" v-model="content" placeholder />
        </van-row>
        <van-cell center title="是否公示">
          <template #right-icon>
            <van-switch :active-value="1" :inactive-value="0" v-model="publicity" size="24" />
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
          <van-button type="info" size="normal" @click="send">提交</van-button>
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
      proposalNo: null,
      type: 1,
      title: "",
      content: "",
      publicity: 0, //是否公示
      canvote: 0, //是否投票
      canjudge: 0, //是否允许居民发表意见
      selecttype: "",
      ProposalTypeList: [],
      ProposalTypeLists: [
        { text: "环境", value: 1 },
        { text: "安全", value: 2 },
        { text: "卫生", value: 3 },
      ],
      value: 1,
    };
  },

  methods: {
    //  初始化
    init() {},
    getProposalTypeList() {
      getProposalType().then((res) => {
        this.ProposalTypeList = res;
      });
    },
    // 提交
    send() {
      let data = {
        proposalNo: this.proposalNo,
        type: this.value,
        title: this.title,
        content: this.content,
        publicity: this.publicity,
        canvote: this.canvote,
        canjudge: this.canjudge,
      };
      console.log(data);
      addProposal(data).then((res) => {
        this.$router.push({
          name: "Proposal",
        });
      });
    },
    // getValue() {
    //   console.log(this.type, "this.type");
    // },
  },

  mounted() {
    this.proposalNo = null;
    this.type = null;
    this.publicity = 0;
    this.canvote = 0;
    this.canjudge = 0;
    this.content = this.$route.query.content || null;
    this.title = this.$route.query.title || null;
    console.log(this.content, this.title, 1111);
    // console.log(this.value);
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
  display: inline-block;
}
.option .van-dropdown-menu__bar {
  width: auto;
  margin-left: 1.33vw;
  height: auto;
  display: inline-block;
  box-shadow: none;
}
.option .van-dropdown-item--down {
  margin: 0 30px;
}
</style>
