<template>
  <div class="tian">
    <van-sticky>
      <van-tabs sticky @click="changTab" v-model="active" style="z-index:99;" color="#4374f2">
        <van-tab title="楼院提案" name="a"></van-tab>
        <van-tab title="我的提案" name="b"></van-tab>
      </van-tabs>
    </van-sticky>
    <!-- 楼院提案 -->
    <van-pull-refresh
      v-if="active=='a'"
      v-model="listOne.isLoading"
      style="z-index:0;"
      @refresh="refreshOne"
    >
      <van-list
        :immediate-check="false"
        :finished="listOne.finished"
        finished-text="没有更多了"
        @load="loadOne"
      >
        <van-cell v-for="(item, index) in listOne.rows" :key="index">
          <div class="ProposalList">
            <div @click="goProposalDetail" class="ProposalTitle">
              {{index+1}}
              <span class="hasgongshi">{{ item.publicity == 1 ? "已公示" : "未公示" }}</span>
              <h2>{{ item.title }}</h2>
              <h2 style="margin-left:20px" @click="deleteitemly(item.id)">删除</h2>

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
      v-show="active == 'b'"
      style="z-index:0;"
      v-model="listTwo.isLoading"
      @refresh="refreshTwo"
    >
      <van-list
        :immediate-check="false"
        finished-text="没有更多了"
        @load="loadTwo"
        :finished="listTwo.finished"
      >
        <van-cell v-for="(item, index) in listTwo.rows" :key="index">
          <div class="ProposalList">
            {{index+1}}
            <div @click="goProposalDetail" class="ProposalTitle">
              <span class="hasgongshi">{{ item.publicity == 1 ? "已公示" : "未公示" }}</span>
              <h2>{{ item.title }}</h2>
              <h2 style="margin-left:20px" @click="deleteitemmy(item.id)">删除</h2>
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
    </van-pull-refresh>-->
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
      active: "a",
      type: 0, //类型 0 楼院提案 1 我的提案
      //   列表页数据
      ProposallyList: [], //楼院
      ProposalmyList: [], //我的提案
      listOne: {
        pageNo: 1,
        isLoading: false,
        finished: false,
        rows: [],
        totalPage: null,
      },
      listTwo: {
        pageNo: 1,
        isLoading: false,
        finished: false,
        rows: [],
        totalPage: null,
      },
    };
  },
  methods: {
    //   初始化
    init() {},
    // 点击tab切换事件
    changTab(name) {
      console.log(this.active, "active");
      if (name == "a") {
        this.type = 0;
        this.listOne.rows = [];
        this.listOne.pageNo = 1;
        this.getOrgList();
      } else {
        this.type = 1;
        this.listTwo.rows = [];
        this.listTwo.pageNo = 1;
        this.getMyList();
      }
    },
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
    refreshOne() {
      //   alert("refreshOne");
      this.listOne.totalPage = 0;
      this.listOne.pageNo = 1;
      this.listOne.rows = [];
      this.getOrgList(); //加载数据
    },
    refreshTwo() {
      //   alert("refreshTwo");
      this.listTwo.totalPage = 0;
      this.listTwo.pageNo = 1;
      this.listTwo.rows = [];
      this.getMyList(); //加载数据
    },
    loadOne() {
      //   alert("loadOne");
      //   this.getOrgList();
    },
    loadTwo() {
      //   alert("loadTwo");
      //   this.getMyList();
    },
    // 获取我的提案
    getMyList() {
      let data = {
        pageNo: this.listTwo.pageNo,
      };
      fetchMyList(data).then((res) => {
        let data = res.list;
        let _this = this;
        console.log(data, "restwo");

        data.forEach(function (item, index) {
          _this.listTwo.rows.push(item);
        });
        this.listTwo.totalPage = res.totalPage;
        this.listTwo.isLoading = false; //关闭下拉刷新效果
        this.listTwo.finished = false; //
        if (res.totalPage <= res.currentPage) {
          this.listTwo.finished = true;
        } else {
          this.listTwo.pageNo++;
        }
        this.listTwo.rows = this.listTwo.rows.conact(data);
        console.log(this.listTwo.rows, "this.listTwo");
      });
    },
    // 获取楼院提案
    getOrgList() {
      let params = {
        pageNo: this.listOne.pageNo,
        pageSize: 6,
      };
      fetchOrgList(params).then((res) => {
        let _this = this;
        let data = res.list;
        console.log(data, "resone");
        data.forEach(function (item, index) {
          _this.listOne.rows.push(item);
        });
        // this.listOne.totalPage = res.totalPage;
        this.listOne.isLoading = false; //关闭下拉刷新效果
        this.listOne.finished = false; //
        // if (res.totalPage <= res.currentPage) {
        //   this.listOne.finished = true;
        // } else {
        //   this.listOne.pageNo++;
        // }
        if (lastPage) {
          this.listOne.finished = true;
          //   debugger;
        } else {
          this.listOne.pageNo++;
        }
        this.listOne.rows = this.listOne.rows.conact(data);
        console.log(this.listOne.rows, "this.listOne");
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
  mounted() {
    this.getOrgList();
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
.addBtn .van-button--normal {
  width: 100% !important;
}
</style>
