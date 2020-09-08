<template>
  <div class="tian">
    <!-- <van-tabs v-model="active" sticky>
      <van-tab v-for="index in 4" :title="'选项 ' + index">内容 {{ index }}</van-tab>
    </van-tabs>-->
    <van-sticky>
      <van-tabs
        @click="changTab"
        sticky
        v-model="active"
        style="z-index:99;"
        color="#4374f2"
      >
        <van-tab title="楼院提案" name="a"></van-tab>
        <van-tab title="我的提案" name="b"></van-tab>
      </van-tabs>
    </van-sticky>
    <!-- 楼院提案 -->
    <van-pull-refresh
      v-if="active == 'a'"
      v-model="isLoading"
      @refresh="onRefresh"
      style="z-index:0;"
    >
      <van-cell v-for="(item, index) in ProposalList" :key="index">
        <div class="ProposalList">
          <div @click="goProposalDetail" class="ProposalTitle">
            <span class="hasgongshi">{{
              item.hasgongshi === 1 ? "已公示" : "未公示"
            }}</span>
            <h2>{{ item.title }}</h2>
            <a @click="goDetail(item.id)">查看详情</a>
          </div>
          <div class="ProposalMsg">
            <p>
              <span>提案人:</span>
              {{ item.name }}
              {{ item.address }}
            </p>
            <p>
              <span>提案日期：</span>
              {{ item.data }}
            </p>
          </div>

          <div class="ProposalData">
            <span class="fl">
              <img src="../../assets/img/统计.png" alt />
              居民投票数{{ item.toupiaoshu }}
            </span>
            <span class="fl">
              <img src="../../assets/img/赞同-fill.png" alt />
              赞成数 {{ item.zancheng }}
            </span>
            <span class="fr">
              <img src="../../assets/img/赞同-fill(1).png" alt />
              反对数 {{ item.fandui }}
            </span>
          </div>
        </div>
      </van-cell>
      <van-list
        v-model="scrollParam.loading"
        :finished="scrollParam.finished"
        finished-text="没有更多了"
        @load="getpageList"
      ></van-list>
    </van-pull-refresh>
    <!-- 我的提案 -->
    <van-pull-refresh
      v-if="active == 'b'"
      v-model="isLoading"
      @refresh="onRefresh"
      style="z-index:0;"
    >
      <van-cell v-for="(item, index) in ProposalList" :key="index">
        <div class="ProposalList">
          <div @click="goProposalDetail" class="ProposalTitle">
            <span class="hasgongshi">{{
              item.hasgongshi === 1 ? "已公示" : "未公示"
            }}</span>
            <h2>我的{{ item.title }}</h2>
            <a @click="goDetail(item.id)">查看详情</a>
          </div>
          <div class="ProposalMsg">
            <p>
              <span>提案人:</span>
              {{ item.name }}
              {{ item.address }}
            </p>
            <p>
              <span>提案日期：</span>
              {{ item.data }}
            </p>
          </div>

          <div class="ProposalData">
            <span class="fl">
              <img src="../../assets/img/统计.png" alt />
              居民投票数{{ item.toupiaoshu }}
            </span>
            <span class="fl">
              <img src="../../assets/img/赞同-fill.png" alt />
              赞成数 {{ item.zancheng }}
            </span>
            <span class="fr">
              <img src="../../assets/img/赞同-fill(1).png" alt />
              反对数 {{ item.fandui }}
            </span>
          </div>
        </div>
      </van-cell>
      <van-list
        v-model="scrollParam.loading"
        :finished="scrollParam.finished"
        finished-text="没有更多了"
        @load="onLoad"
      ></van-list>
    </van-pull-refresh>
    <van-button class="addBtn" @click="addProposal">新增提案</van-button>
  </div>
</template>
<script>
import { getProposalList } from "@/api/proposal";
export default {
  data() {
    return {
      active: "a",
      isLoading: false,
      //   滚动列表参数
      scrollParam: {
        loading: false,
        finished: true,
      },
      type: 0, //类型 0 楼院提案 1 我的提案
      //   列表页数据
      ProposalList: [
        {
          title: "关于修建小区健身的提案",
          name: "王大妈",
          address: "地址",
          data: "2020年4月15日",
          hasgongshi: 1,
          toupiaoshu: 100,
          zancheng: 10,
          fandui: 10,
        },
      ],
    };
  },
  methods: {
    //   初始化
    init() {},
    // 下拉刷新
    onRefresh() {
      this.getpageList();
    },
    onLoad(){
        alert(2)
    }.
    // 点击tab切换事件
    changTab(name) {
      if (name == "a") {
        this.type = 0;
        this.getpageList();
      } else {
        this.type = 1;
        this.getpageList();
      }
    },
    // 获取列表
    getpageList() {
      let data = {
        type: this.type,
      };
      getProposalList(data).then((res) => {
        let data = res.data;
        this.ProposalList = data;
        this.isLoading = false;
      });
    },
    // 跳转提案详情
    goProposalDetail() {},
    // 新增提案
    addProposal() {
      this.$router.push({
        name: "addProposal",
      });
    },
    // 跳转详情
    goDetail(id) {
      this.$store.commit("setClassificationId", id);
      this.$router.push({
        name: "viewProposal",
        query: {
          id: id,
        },
      });
    },
  },
  mounted() {
    this.getpageList();
  },
};
</script>
<style scope>
.van-sticky .van-sticky .van-tab--active {
  font-size: 16px;
  color: #5eafee;
}
.van-cell {
  line-height: 30px;
  padding-left: 15px;
  padding-right: 15px;
}
.ProposalList {
  border: 1px solid #ccc;
  /* padding: 5px 5px 5px 20px;
  margin: 20px 0px; */
  border-radius: 20px;
}

.ProposalTitle {
  margin: 5px 25px;
  /* margin-left: 25px; */
  padding-left: 95px;
  position: relative;
  border-bottom: 1px solid rgba(51, 51, 51, 0.1);
  /* opacity: 0.1; */
}
.ProposalTitle span {
  font-size: 24px;
  font-family: PingFang SC;
  font-weight: 500;
  color: #3599ff;
  position: absolute;
  left: 0;
  top: 0;
}
.ProposalTitle h2 {
  font-size: 28px;
  font-family: PingFang SC;
  font-weight: 500;
  color: #333333;
  display: inline-block;
}
.ProposalTitle a {
  float: right;
  font-size: 24px;
  font-family: PingFang SC;
  font-weight: 500;
  color: #7d7d7d;
}
.ProposalMsg {
  margin: 0 25px 5px 25px;
  padding-bottom: 5px;
  border-bottom: 1px solid rgba(51, 51, 51, 0.1);
}
.ProposalMsg p {
  font-size: 26px;
  font-family: PingFang SC;
  font-weight: 500;
  color: #333333;
}
.ProposalMsg p span {
  font-size: 26px;
  color: #7d7d7d;
}
.ProposalData {
  margin: 0 25px;
  font-size: 24px;
  font-family: PingFang SC;
  font-weight: 500;
  color: #656565;
  overflow: hidden;
  position: relative;
  padding: 10px 0;
}
.ProposalData span:first-child {
  margin-right: 60px;
}
.ProposalData span {
  position: relative;
  padding-left: 35px;
}
.ProposalData span img {
  width: 30px;
  height: 28px;
  margin-right: 8px;
  position: absolute;
  top: 15px;
  left: 0;
}
.fl {
  float: left;
}
.fr {
  float: right;
}
/* 新增提案 */
.addBtn {
  width: 100%;
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
}
</style>
