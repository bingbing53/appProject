<template>
  <div class="tian">
    <van-sticky>
      <van-tabs @click="changTab" sticky v-model="active" style="z-index:99;" color="#4374f2">
        <van-tab title="楼院提案" name="楼院提案"></van-tab>
        <van-tab title="我的提案" name="我的提案"></van-tab>
      </van-tabs>
    </van-sticky>
    <!-- 楼院提案 -->
    <van-pull-refresh v-if="active == '0'" style="z-index:0;">
      <van-list finished-text="没有更多了" @load="onLoad">
        <van-cell v-for="(item, index) in ProposallyList" :key="index">
          <div class="ProposalList">
            <div @click="goProposalDetail" class="ProposalTitle">
              <span class="hasgongshi">{{ item.publicity == 1 ? "已公示" : "未公示" }}</span>
              <h2>{{ item.title }}</h2>
              <!-- <h2 style="margin-left:20px" @click="deleteitemly(item.id)">删除</h2> -->

              <a @click="goDetail(item.id, item.publicity)">查看详情</a>
            </div>
            <div class="ProposalMsg">
              <p>
                <span>提案人:</span>
                {{ item.create_name }}
                {{ item.address }}
              </p>
              <p>
                <span>提案日期：</span>
                {{ dealTime(item.create_date) }}
              </p>
            </div>

            <div class="ProposalData">
              <span class="fl">
                <img src="../../assets/img/统计.png" alt />
                居民投票数{{ item.votes }}
              </span>
              <span class="fl">
                <img src="../../assets/img/赞同-fill.png" alt />
                赞成数 {{ item.favors }}
              </span>
              <span class="fr">
                <img src="../../assets/img/赞同-fill(1).png" alt />
                反对数 {{ item.oppositions }}
              </span>
            </div>
          </div>
        </van-cell>
      </van-list>
    </van-pull-refresh>
    <!-- 我的提案 -->
    <!-- <van-pull-refresh
      v-show="active == '1'"
      style="z-index:0;"
    >-->
    <van-list finished-text="没有更多了" @load="onLoadmy">
      <van-cell v-for="(item, index) in ProposalmyList" :key="index">
        <div class="ProposalList">
          <div @click="goProposalDetail" class="ProposalTitle">
            <span class="hasgongshi">{{ item.publicity == 1 ? "已公示" : "未公示" }}</span>
            <h2>{{ item.title }}</h2>
            <!-- <h2 style="margin-left:20px" @click="deleteitemmy(item.id)">删除</h2> -->
            <a @click="goMyDetail(item.id, item.publicity)">查看详情</a>
          </div>
          <div class="ProposalMsg">
            <p>
              <span>提案人:</span>
              {{ item.create_name }}
              {{ item.address }}
            </p>
            <p>
              <span>提案日期：</span>
              {{ dealTime(item.create_date) }}
            </p>
          </div>

          <div class="ProposalData">
            <span class="fl">
              <img src="../../assets/img/统计.png" alt />
              居民投票数{{ item.votes }}
            </span>
            <span class="fl">
              <img src="../../assets/img/赞同-fill.png" alt />
              赞成数 {{ item.favors }}
            </span>
            <span class="fr">
              <img src="../../assets/img/赞同-fill(1).png" alt />
              反对数 {{ item.oppositions }}
            </span>
          </div>
        </div>
      </van-cell>
    </van-list>
    <!-- </van-pull-refresh> -->
    <div class="addBtn">
      <van-button @click="addProposal">新增提案</van-button>
    </div>
  </div>
</template>
<script>
import { fetchMyList, fetchOrgList, deleteProposal } from "@/api/proposal";
export default {
  data() {
    return {
      active: "0",
      type: 0, //类型 0 楼院提案 1 我的提案
      //   列表页数据
      ProposallyList: [], //楼院
      ProposalmyList: [], //我的提案
    };
  },
  methods: {
    //   初始化
    init() {},
    // 删除
    deleteitemly(id) {
      deleteProposal(id).then((res) => {
        console.log(res, "ly删除");
        this.getMyList();
      });
    },
    deleteitemmy(id) {
      deleteProposal(id).then((res) => {
        console.log(res, "my删除");
        this.getMyList();
      });
    },
    // 处理时间
    dealTime(data) {
      var date = new Date(data);
      var Y = date.getFullYear() + "-";
      var M =
        (date.getMonth() + 1 < 10
          ? "0" + (date.getMonth() + 1)
          : date.getMonth() + 1) + "-";
      var D =
        (date.getDate() < 10 ? "0" + date.getDate() : date.getDate()) + " ";
      var h =
        (date.getHours() < 10 ? "0" + date.getHours() : date.getHours()) + ":";
      var m =
        (date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes()) +
        ":";
      var s =
        date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();
      return Y + M + D + h + m + s;
    },
    // 下拉刷新
    onRefreshly() {
      this.pageOneInfo.pageNo = 1;
      this.getOrgList();
    },
    onLoad() {},
    onLoadmy() {},
    // 点击tab切换事件
    changTab(name) {},
    // 获取我的提案
    getMyList() {
      let data = {
        pageNo: this.pageTwoInfo.pageNo,
        pageSize: this.pageTwoInfo.pageSize,
      };
      fetchMyList(data).then((res) => {
        let data = res.list;
        this.ProposalmyList = data;
      });
    },
    // 获取楼院提案
    getOrgList() {
      let data = {
        pageNo: this.pageOneInfo.pageNo,
        pageSize: this.pageOneInfo.pageSize,
      };
      fetchOrgList(data).then((res) => {
        let data = res.list;
        this.ProposallyList = data;
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
    goDetail(id, publicity) {
      this.$store.commit("setClassificationId", id);
      this.$router.push({
        name: "viewProposal",
        query: {
          id: id,
          publicity: publicity,
        },
      });
    },
    // 我的提案新增或修改
    goMyDetail(id, publicity) {
      this.$router.push({
        name: "addMyProposal",
        query: {
          id: id,
          publicity: publicity,
        },
      });
    },
  },
  mounted() {},
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
.addBtn .van-button--normal {
  width: 100% !important;
}
</style>
