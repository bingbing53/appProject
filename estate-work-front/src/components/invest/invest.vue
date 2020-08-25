<template>
  <div>
    <!-- <div v-if="type === 1" v-wechat-title="$route.meta.title='居民调查'  "></div>
    <div v-else-if="type === 2" v-wechat-title="$route.meta.title='家庭调查'  "></div>
    <div v-else-if="type === 3" v-wechat-title="$route.meta.title='房产调查'  "></div>
    <div v-else></div> -->
    <van-tabs v-model="active" class="invest">
      <van-tab title="调查模板">
        <van-pull-refresh v-model="investigationList.isLoading" @refresh="ondataRefreshModues">
          <van-list
            :finished="investigationList.finished"
            finished-text="没有更多了"
            :immediate-check="false"
            @load="getInvestList"
          >
          <div class="bgcy"></div>
            <div >
                <van-search
                class="search"
                  v-model="search"
                  placeholder="请输入搜索关键词"
                  show-action
                  shape="round"
                  @search="onSearch"
                >
                  <div slot="action" @click="onSearch">搜索</div>
                </van-search>
            </div>
            <div
              v-for="(item,index) in investigationList.rows"
              :key="index"
              @click="jumpDetail(item.id)"
              class="bgcw2 mb-10"
            >
            <div class="bgcy"></div>
              <div class="pd-10">
                <div class="f-16 text-c">{{item.title}}</div>
                <div class="c-666 pt-10 f-14">调查描述：{{item.des}}</div>
                <div class="text-c pt-10 c-999 card">
                  <van-row>
                    <van-col span="8" class="c-666 f-14 pt-10">
                      <span class="f-blue">{{item.create_date}}</span>
                      <br />
                      <br />创建时间
                    </van-col>
                    <van-col span="8" class="c-666 f-14 pt-10">
                      <span class="f-blue">{{item.departname}}</span>
                      <br />
                      <br />创建社区
                    </van-col>
                    <van-col span="8" class="c-666 f-14 pt-10">
                      <span class="f-blue">{{item.count}}份</span>
                      <br />
                      <br />已收集
                    </van-col>
                  </van-row>
                </div>
              </div>
            </div>
          
          </van-list>
        </van-pull-refresh>
      </van-tab>
      <van-tab title="调查记录">
        <van-pull-refresh v-model="investigationDataList.isLoading" @refresh="ondataRefresh">
          <van-list
            :finished="investigationDataList.finished"
            finished-text="没有更多了"
            @load="getList"
          >
            <div v-for="(item,index) in investigationDataList.rows" :key="index" class="bgcw2">
              <div class="bgcy"></div>
              <div class="pd-10">
                <div class="f-15 text-c mb-5">{{item.title}}</div>
                <div class="text-c pt-20 c-999 card" @click="gotoHistory(item.uuid)">
                  <van-row>
                    <van-col span="12">
                      <span class="f-blue">{{item.name}}</span>
                      <br />
                      <span class="f-14">被调查人</span>
                    </van-col>
                    <van-col span="12">
                      <span class="f-blue">{{item.create_date}}</span>
                      <br />
                      <span class="f-14">调查时间</span>
                    </van-col>
                  </van-row>
                </div>
              </div>
            </div>

           
          </van-list>
        </van-pull-refresh>
      </van-tab>
    </van-tabs>
  </div>
</template>
<script>
import getInvestigationList from "@/api/invest/invest";
import getDataList from "@/api/invest/invest";
export default {
  data() {
    return {
      dictionary: {},
      type: 0,
      search: "",
      investigationList: {
        pageNo: 1,
        rows: [],
        isLoading: false,
        loading: false,
        finished: false
      },

      investigationDataList: {
        pageNo: 1,
        rows: [],
        isLoading: false,
        finished: false,
        loading: false
      },

      tabIndex: 0,
      active: 0,
      // type: 2
    };
  },
  methods: {
      //调查模板init
    async initModules() {
      let d = await getInvestigationList.getInvestigation({
        pageNo: this.investigationList.pageNo,
        type: this.type,
        title: this.search
      });
      this.investigationList.rows = [];
      d = JSON.parse(d);
       this.handleData(d);
      this.investigationList.totalPage = d.totalPage;
      this.investigationList.isLoading = false; //关闭下拉刷新效果
      this.investigationList.finished = false; //
      if (d.totalPage <= d.currentPage) {
        this.investigationList.finished = true;
      } else {
        this.investigationList.pageNo++;
      }
    },
      // 调查模板 下拉刷新
    ondataRefreshModues() {
        this.investigationList.totalPage = 0;
        this.investigationList.pageNo = 1;
        this.initModules(); //加载数据
    },
    //调查模板load
    async getInvestList() {
      let resdata = await getInvestigationList.getInvestigation({
        pageNo: this.investigationList.pageNo,
        type: this.type,
        title: this.search
      });
      resdata = JSON.parse(resdata);
      this.handleData(resdata);
      this.investigationList.totalPage = resdata.totalPage;
      this.investigationList.isLoading = false; //关闭下拉刷新效果
      if (resdata.totalPage <= resdata.currentPage) {
         this.investigationList.finished = true;
      } else {
        this.investigationList.pageNo += 1;
      }
    },
  
  
    // ********************************调查模板下拉刷新上拉加载公用start***********************************
    handleData(data){
      let _this = this;
      data.list.forEach(function(item, index) {
        item.create_date = item.create_date.substring(0, 10);
        if (item.count === null)
         item.count = 0;
        _this.investigationList.rows.push(item);
      });

    },
    // ********************************调查模板下拉刷新上拉加载公用end*************************************
    //调查记录load
    async getList() {
      let d = await getDataList.getInvestigationDataList(this.type,{
        pageNo: this.investigationDataList.pageNo
      });
      d = JSON.parse(d);
      this.handleDataRecord(d);

      this.investigationDataList.totalPage = d.totalPage;
      this.investigationDataList.isLoading = false; //关闭下拉刷新效果
      this.investigationDataList.finished = false;
      if (d.totalPage <= d.currentPage) {
         this.investigationDataList.finished = true;
      } else {
        this.investigationDataList.pageNo ++;
      }
    },
    //调查记录init
    async init() {
      let d = await getDataList.getInvestigationDataList(this.type,{
        pageNo: this.investigationDataList.pageNo
      });
       this.investigationDataList.rows = [];
      d = JSON.parse(d);
      this.handleDataRecord(d);
      this.investigationDataList.totalPage = d.totalPage;
      this.investigationDataList.isLoading = false; //关闭下拉刷新效果
      this.investigationDataList.finished = false; 
      if (d.totalPage <= d.currentPage) {
        this.investigationDataList.finished = true;
      } else {
        this.investigationDataList.pageNo++;
      }
    },
    // 调查记录 下拉刷新
    ondataRefresh() {
        this.investigationDataList.totalPage = 0;
        this.investigationDataList.pageNo = 1;
        this.init(); //加载数据
    },
  // *****************************调查记录start******************
   handleDataRecord(data){
     let _this = this;
      data.list.forEach(function(item, index) {
        item.create_date = item.create_date.substring(0, 10);
        _this.investigationDataList.rows.push(item);
      });
   },
  // *****************************调查记录end******************

    onSearch() {
      this.investigationList = {
        pageNo: 1,
        rows: [],
      };

      this.getInvestList();
    },
    //跳转被调查人历史记录详情页面
    gotoHistory(uuid) {
      this.$router.push({
        path: `/investhistory${uuid}`
      });
    },
    //跳转详情页面
    jumpDetail(id) {
      // alert(id);
      // return;
      this.$router.push({
        path: `/investdetail${id}`
      });
    }
  },
  mounted() {
    this.type = this.$route.query.type;
    this.getInvestList();//获取调查模板
  }
};
</script>
<style scoped>
.van-tab--active {
  color: #3396fb !important;
}
.van-tabs__wrap {
  position: fixed !important;
  border-bottom: solid 1px #eee;
}
.search_input {
  padding: 12px;
}
.van-field__control{
  line-height: 0.1 !important;
}
</style>

