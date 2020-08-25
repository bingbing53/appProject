<template>
  <f7-page class="repair bgcw" style="background:#fff!important;">
    <div>
      <van-pull-refresh v-model="repaitList.isLoading" @refresh="onRefresh">
        <van-list
          v-model="repaitList.loading"
          :finished="repaitList.finished"
          finished-text="没有更多了"
          @load="getrepairList"
        >
          <div v-for="(item,index) in repaitList.items" class="pl-10 pr-10 bgcw">
            <f7-row @click="toDetail(item.id)" class="broder_b ">
              <f7-col width="80" class="pt-10 pb-10">
                <div
                  class="f-12 c-999 pt-5 online"
                  style="color: #666;text-align: center;"
                >{{item.serviceDate}}</div>
                <div class="f-16 online demand">
                  <!-- <span>【服务需求】</span> -->
                  <van-tag plain type="danger">{{item.orderType_dictText}}</van-tag>
                  {{item.content}}
                </div>
              </f7-col>
              <f7-col width="20" class="pt-10 pb-10">
                <div class="statusItem">
                  <span>{{item.status_dictText}}</span>
                </div>
              </f7-col>
              <f7-col width="100" class="pt-10 pb-10">
                <div class="f-12 c-999" style="text-align: right;margin-top: 4px; ">查看详情>></div>
              </f7-col>
            </f7-row>
            <!-- </f7-link> -->
          </div>
        </van-list>
      </van-pull-refresh>
    </div>

    <f7-fab position="right-bottom" slot="fixed" @click="repairForm"  color="red">
      <f7-icon ios="f7:add" aurora="f7:add" md="material:add"></f7-icon>
    </f7-fab>

  </f7-page>
</template>

<script>
import { reportType, repairList } from "@/api/api_estate.js";
export default {
  data() {
    return {
      repaitList: {
        items: [],
        isLoading: false,
        loading: false,
        finished: false,
        totalPage: 0,
        pageNo: 1
      }
    };
  },
  created() {

  },
  methods: {
    repairForm(){
        this.$f7router.navigate(`/estate/RepairForm/forceClose/`);
    },
    getrepairList() {
      let _this = this;
      let pageNo = this.repaitList.pageNo;
      repairList({ pageNo: this.repaitList.pageNo })
        .then(res => {
          this.handleData(res);
          this.repaitList.totalPage = res.pages;
          this.repaitList.loading = false;
          if (res.data.pages <= res.data.current) {
            this.repaitList.finished = true;
          } else {
            this.repaitList.pageNo++;
          }
        })
        .catch(err => {
          this.$commonUtils.jumpLogin(err);
        });
    },
    onRefresh() {
      this.repaitList.totalPage = 0;
      this.repaitList.pageNo = 1;
      this.init(); //加载数据
    },
    async init() {
      let res = await repairList(this.repaitList.pageNo);
      console.log(res);
      this.repaitList.items = [];
      this.handleData(res);
      this.repaitList.totalPage = res.data.pages;
      this.repaitList.isLoading = false; //关闭下拉刷新效果
      this.repaitList.finished = false;
      if (res.data.pages <= res.data.current) {
        this.repaitList.finished = true;
      } else {
        this.repaitList.pageNo++;
      }
    },
    handleData(res) {
      let _this = this;
      res.data.records.forEach((item, index) => {
        _this.repaitList.items.push(item);
      });
    },
    toDetail(id) {
      this.$f7router.navigate(`/estate/repairDetail/${id}/`);
    }
  },
  mounted() {
    // this.getrepairList();
  },
  created() {
    this.$commonUtils.setTitle("报修");
  },
};
</script>
<style scoped>
.demand {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  line-height: 28px;
}
.statusItem {
  font-size: 12px;
  background: #fcc53f;
  border-radius: 4px;
  padding: 3px;
  color: #fff;
  text-align: center;
  margin-top: 8px;
}
</style>