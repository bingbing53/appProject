<template>
  <div style="padding:15px">
    <!-- <van-form> -->
    <!-- <van-field v-model="value1" placeholder /> -->
    <!-- </van-form> -->
    <div class="tianBox">
      <van-row class="pad35">
        <label>提案编号：</label>
        <input class="input" v-model="proposalNo" placeholder />
      </van-row>
      <van-row class="pad35">
        <span class="font28">提案分类：</span>
        <!-- <van-field label="提案分类" :disabled="true" v-model="type" placeholder /> -->
        <!-- <input class="input" :disabled="disabled" v-model="text" placeholder />
        <br />-->
        <span style="margin-left:1.33vw">{{type |showName(ProposalTypeList) }}</span>
      </van-row>
      <van-row class="pad35">
        <span class="font28">提案标题：</span>
        <!-- <van-field label="提案标题：" v-model="title" placeholder /> -->
        <input class="input" :disabled="disabled" v-model="title" placeholder />
      </van-row>
      <van-row class="pad35 tianText">
        <span class="font28">提案内容：</span>
        <textarea class="textarea" :disabled="disabled" v-model="content" placeholder />
        <!-- <p class="font26">{{content}}</p> -->
      </van-row>
      <van-row class="pad35">
        <van-cell center title="是否公示" class="font28">
          <template #right-icon>
            <van-switch
              @change="changePublicity"
              v-model="publicity"
              :active-value="1"
              :inactive-value="0"
              size="24"
              :disabled="disabled"
            />
          </template>
        </van-cell>
        <p class="font24">
          说明：如公示，则该提案则会发布到社区公众号中进行公示，
          社区表将会看到您的提案
        </p>
      </van-row>
      <van-row class="pad35">
        <van-cell center title="是否投票" class="font28">
          <template #right-icon>
            <van-switch
              v-model="canvote"
              :active-value="1"
              :inactive-value="0"
              size="24"
              :disabled="disabled"
            />
          </template>
        </van-cell>
        <p class="font24">说明：如允许投票，则社区居民可以对该提案投赞同或反对票</p>
      </van-row>
      <van-row class="pad35">
        <van-cell center title="是否允许居民发表意见" class="font28">
          <template #right-icon>
            <van-switch
              v-model="canjudge"
              :active-value="1"
              :inactive-value="0"
              size="24"
              :disabled="disabled"
            />
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
        <span class="font30">{{ createName }}</span>
      </p>
      <div class="jiyao">
        <label class="font26">会议纪要：</label>
        <p>{{ jiyao }}</p>
      </div>
      <div class="in_order">
        <span @click="goMeeting">发起会议</span>
      </div>
    </div>
    <!-- 居民投票结果 -->
    <h2 class="talkResultTitle">居民投票结果</h2>
    <div class="resultBox">
      <div>
        <span>{{ votes }}</span>
        <p>
          <img src="../../assets/img/统计.png" alt />总票数
        </p>
      </div>
      <div>
        <span>{{ favors }}</span>
        <p>
          <img src="../../assets/img/赞同-fill.png" alt />赞同数
        </p>
      </div>
      <div>
        <span>{{ oppositions }}</span>
        <p>
          <img src="../../assets/img/赞同-fill(1).png" alt />反对数
        </p>
      </div>
    </div>
    <!-- 居民反馈意见 -->
    <h2 class="issueTitle">居民反馈意见</h2>
    <div class="issueBox">
      <div class="issueDetail" v-for="(item, index) in issueList" :key="index">
        <p>{{ item.content }}</p>
        <div>
          <span>
            <img src="../../assets/img/人.png" alt />
            {{ item.baseuser.nickName }}
          </span>
          <span>
            <img src="../../assets/img/电话.png" alt />
            {{ item.baseuser.mobile}}
          </span>
          <span style="overflow: hidden;text-overflow:ellipsis;white-space: wrap;display:block">
            <img src="../../assets/img/房子222.png" alt />
            {{ item.baseuser.address }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getProposalType, getProposalList, voteProposal } from "@/api/proposal";
import groupDetailVue from "../socialgroup/groupDetail.vue";
export default {
  data() {
    return {
      // text:'',
      proposalNo: null,
      ProposalTypeList: [], //分类列表集合
      hasgongshi: 0,
      // 查看编辑控制
      disabled: true,
      type: "楼院提案（禁用状态）",
      id: null, //跳转传过来的id
      publicity: 0, //是否公示
      canvote: 0, //是否投票
      canjudge: 0, //是否允许居民发表意见
      title: "", //提案标题
      //提案内容那
      content: "",
      createName: "", //参会人
      //纪要内容  后台未返回
      jiyao: "",
      votes: 10, //总票数
      favors: 10, //赞同数
      oppositions: 10, //反对数
      issueList: [
        //居民反馈意见
        // {
        //   content: "这个提案太好了咱村可以实现么？",
        //   name: "张三",
        //   phone: "10213065120",
        //   address: "村一社区XX楼XX单元",
        // },
      ],
      ProposalType: "",
    };
  },
  filters: {
    showName(value, list) {
      let item = list.find((item) => {
        return item.value == value;
      });
      item = item || {};
      return item.text;
    },
  },
  methods: {
    //   初始化
    init() {
      this.pageOneInfo.pageNo = 0;
      this.pageTwoInfo.pageNo = 0;
    },
    // 是否公示
    changePublicity(val) {
      console.log(val, "val");
    },
    getProposalVote(id) {
      console.log(id, "id");
      voteProposal(id).then((res) => {
        console.log(res, "pinglun");
        let data = res.rows;
        this.issueList = data;
      });
    },
    getProposalTypeList() {
      getProposalType().then((res) => {
        this.ProposalTypeList = res;
        // let item = res.find((item) => {
        //   return item.value == this.type;
        // });
        // this.text = item[0].text;
      });
    },
    goMeeting() {
      Toaster.postMessage("js call flutter success!!");
    },
  },
  mounted() {
    this.id = this.$route.query.id;
    this.hasgongshi = this.$route.query.publicity;
    console.log(this.hasgongshi);
    // if (this.hasgongshi == 1) {
    //   this.disabled = true;
    // } else {
    //   this.disabled = false;
    // }
    this.getProposalTypeList();
    getProposalList(this.id).then((res) => {
      console.log(res, "resxiangqing");
      this.proposalNo = res.proposalNo;
      this.type = res.type;
      this.publicity = Number(res.publicity);
      this.canvote = Number(res.canvote);
      this.canjudge = Number(res.canjudge);
      this.title = res.title;
      this.content = res.content;
      this.createName = res.createName;
      //   this.jiyao = res.jiyao;
      this.votes = res.votes;
      this.favors = res.favors;
      this.oppositions = res.oppositions;
    });
    this.getProposalVote(this.id);
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
.input {
  border: 0;
  margin-left: 10px;
}
.input:disabled {
  background-color: #fff;
}
.tianBox {
  background: #fff;
}
.pad35 {
  line-height: 37px;
  padding: 30px 0;
  /* height: 109px; */
  margin: 0 30px;
  font-size: 28px;
  border-bottom: 1px solid rgba(52, 52, 52, 0.1);
}
.van-cell::after {
  border-bottom-color: transparent;
}
.tianText {
  font-weight: Medium;
}
.textarea {
  border: none;
  height: 150px;
  width: 100%;
  text-indent: 50px;
  margin-top: 15px;
}
.textarea:disabled {
  background-color: #fff;
}
.tianText p {
  margin-top: 15px;
  text-indent: 50px;
  line-height: 45px;
}
.tianBox .van-cell {
  padding-bottom: 8px;
  padding-left: 0;
  padding-right: 0;
  width: auto;
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
  position: relative;
  padding-left: 35px;
}
.resultBox div p img {
  width: 30px;
  height: 28px;
  margin-right: 8px;
  position: absolute;
  top: -1px;
  left: 0;
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
.issueDetail {
  padding-bottom: 15px;
}
.issueDetail div {
  height: 85px;
  line-height: 85px;
  margin-bottom: 30px;
}
.issueDetail div span {
  /* display: inline-block; */
  margin-right: 28px;
  font-size: 26px;
  font-family: PingFang SC;
  font-weight: 500;
  color: #343434;
  line-height: 39px;
  text-overflow: ellipsis;
  white-space: nowrap;
  overflow: hidden;
}
.issueDetail div span img {
  width: 22px;
  height: 20px;
  margin-right: 4px;
}
.in_order {
  text-align: center;
}

.in_order span {
  display: inline-block;
  width: 253px;
  height: 60px;
  background-color: #4375f2;
  border-radius: 30px;
  color: #fff;
  text-align: center;
  font-size: 28px;
  font-family: PingFang SC;
  font-weight: 500;
  line-height: 60px;
  margin-top: 60px;
}
</style>
