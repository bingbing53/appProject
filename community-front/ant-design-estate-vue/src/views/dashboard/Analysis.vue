<template>
  <div class="page-header-index-wide">

    <a-row :gutter="24">
      <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
        <chart-card :loading="loading" title="小区数" :total="count.villageCont | NumberFormat">
          <template slot="footer">物业管辖小区数</template>
        </chart-card>
      </a-col>
      <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
        <chart-card :loading="loading" title="楼宇数" :total="count.buildingCount | NumberFormat">
          <template slot="footer">物业管辖楼宇数</template>
        </chart-card>
      </a-col>
      <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
        <chart-card :loading="loading" title="房屋数" :total="count.houseCount | NumberFormat">
          <template slot="footer">物业管辖房屋数</template>
        </chart-card>
      </a-col>
      <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
        <chart-card :loading="loading" title="居民数" :total="count.personCount | NumberFormat">
          <template slot="footer">物业管辖居民数</template>
        </chart-card>
      </a-col>
    </a-row>

    <a-row :gutter="24">
      <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
        <chart-card :loading="loading" title="服务订单数" :total="count.orderCount | NumberFormat">
          <template slot="footer">服务订单数</template>
        </chart-card>
      </a-col>
      <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
        <chart-card :loading="loading" title="小区问题数" :total="count.feedBackCount | NumberFormat">
          <template slot="footer">小区问题数</template>
        </chart-card>
      </a-col>
      <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
        <chart-card :loading="loading" title="服务满意率" :total="count.orderDegree+'%'">
          <template slot="footer">服务满意率</template>
        </chart-card>
      </a-col>
    </a-row>

    <a-card :loading="loading" :bordered="false" title="服务数据">
      <bar-multid title="服务数据柱状图" :height="height" :dataSource="countOrderFeedBack" :fields="fields"/>
    </a-card>

    <!--<a-card :loading="loading" :bordered="false" :body-style="{padding: '0'}">-->
      <!--<div class="salesCard">-->
        <!--<a-tabs default-active-key="1" size="large" :tab-bar-style="{marginBottom: '24px', paddingLeft: '16px'}">-->
          <!--<div class="extra-wrapper" slot="tabBarExtraContent">-->
            <!--<div class="extra-item">-->
              <!--<a>今日</a>-->
              <!--<a>本周</a>-->
              <!--<a>本月</a>-->
              <!--<a>本年</a>-->
            <!--</div>-->
            <!--<a-range-picker :style="{width: '256px'}" />-->
          <!--</div>-->
          <!--<a-tab-pane loading="true" tab="销售额" key="1">-->
            <!--<a-row>-->
              <!--<a-col :xl="16" :lg="12" :md="12" :sm="24" :xs="24">-->
                <!--<bar title="销售额排行" :dataSource="barData"/>-->
              <!--</a-col>-->
              <!--<a-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">-->
                <!--<rank-list title="门店销售排行榜" :list="rankList"/>-->
              <!--</a-col>-->
            <!--</a-row>-->
          <!--</a-tab-pane>-->
          <!--<a-tab-pane tab="访问量" key="2">-->
            <!--<a-row>-->
              <!--<a-col :xl="16" :lg="12" :md="12" :sm="24" :xs="24">-->
                <!--<bar title="销售额趋势" :dataSource="barData"/>-->
              <!--</a-col>-->
              <!--<a-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">-->
                <!--<rank-list title="门店销售排行榜" :list="rankList"/>-->
              <!--</a-col>-->
            <!--</a-row>-->
          <!--</a-tab-pane>-->
        <!--</a-tabs>-->
      <!--</div>-->
    <!--</a-card>-->

    <!--<a-row :gutter="12">-->
      <!--<a-col :xl="12" :lg="24" :md="24" :sm="24" :xs="24">-->
        <!--<a-card :loading="loading" :bordered="false" title="实时访问统计" :style="{ marginTop: '24px' }">-->
          <!--<a-dropdown :trigger="['click']" placement="bottomLeft" slot="extra">-->
            <!--<a class="ant-dropdown-link" href="#">-->
              <!--<a-icon type="ellipsis" />-->
            <!--</a>-->
            <!--<a-menu slot="overlay">-->
              <!--<a-menu-item>-->
                <!--<a href="javascript:;">操作一</a>-->
              <!--</a-menu-item>-->
              <!--<a-menu-item>-->
                <!--<a href="javascript:;">操作二</a>-->
              <!--</a-menu-item>-->
            <!--</a-menu>-->
          <!--</a-dropdown>-->
          <!--<div style="height: 105px">-->
            <!--<a-row>-->
              <!--<a-col :span="8">-->
                <!--<div class="head-info" :class="center && 'center'">-->
                  <!--<span>今日IP</span>-->
                  <!--<p><a>{{ loginfo.todayIp }}</a></p>-->
                <!--</div>-->
              <!--</a-col>-->
              <!--<a-col :span="8">-->
                <!--<div class="head-info" :class="center && 'center'">-->
                  <!--<span>今日访问</span>-->
                  <!--<p><a>{{ loginfo.todayVisitCount }}</a></p>-->
                <!--</div>-->
              <!--</a-col>-->
              <!--<a-col :span="8">-->
                <!--<div class="head-info" :class="center && 'center'">-->
                  <!--<span>访问总览</span>-->
                  <!--<p><a>{{ loginfo.totalVisitCount }}</a></p>-->
                <!--</div>-->
              <!--</a-col>-->
            <!--</a-row>-->
          <!--</div>-->
        <!--</a-card>-->
      <!--</a-col>-->
      <!--<a-col :xl="12" :lg="24" :md="24" :sm="24" :xs="24">-->
        <!--<a-card :loading="loading" :bordered="false" title="销售额类别占比" :style="{ marginTop: '24px' }">-->
          <!--<a-dropdown :trigger="['click']" placement="bottomLeft" slot="extra">-->
            <!--<a class="ant-dropdown-link" href="#">-->
              <!--<a-icon type="ellipsis" />-->
            <!--</a>-->
            <!--<a-menu slot="overlay">-->
              <!--<a-menu-item>-->
                <!--<a href="javascript:;">操作一</a>-->
              <!--</a-menu-item>-->
              <!--<a-menu-item>-->
                <!--<a href="javascript:;">操作二</a>-->
              <!--</a-menu-item>-->
            <!--</a-menu>-->
          <!--</a-dropdown>-->
          <!--<p>card content</p>-->
          <!--<p>card content</p>-->
          <!--<p>card content</p>-->
        <!--</a-card>-->
      <!--</a-col>-->
    <!--</a-row>-->
  </div>
</template>

<script>
  import ChartCard from '@/components/ChartCard'
  import { getAction } from '@/api/manage'
  import BarMultid from '@/components/chart/BarMultid'

  export default {
    name: "Analysis",
    components: {
      ChartCard,
      BarMultid
    },
    data() {
      return {
        loading: true,
        count:{
          villageCont:0,
          buildingCount:0,
          houseCount:0,
          personCount:0,

          orderCount:0,
          feedBackCount:0,
          orderDegree:0
        },
        countOrderFeedBack:{},
        fields:[],
        height:420,
        url:{
          villageCount:'/statis/index/villageCount',
          buildingCount:'/statis/index/buildingCount',
          houseCount:'/statis/index/houseCount',
          personCount:'/statis/index/personCout',

          orderCount:'/statis/index/orderCount',
          feedCount:'/statis/index/feedCount',
          degree:'/statis/index/degree',

          countOrderFeedBackMonthly:'statis/index/countOrderFeedBackMonthly'
        }
      }
    },
    created() {
      setTimeout(() => {
        this.loading = !this.loading
      }, 1000)

      this.getVillageCount()
      this.getBuildingCount()
      this.getHouseCount()
      this.getPersonCount()
      this.getOrderCount()
      this.getFeedCount()
      this.getOrderDegree()
      this.countOrderFeedBackMonthly()
    },
    methods: {
      countOrderFeedBackMonthly(){
        var _this = this;
        getAction(this.url.countOrderFeedBackMonthly).then(res=>{
          if(res.success){
            let result = res.result;
            let countOrderFeedBack = [];
            var order = {'type':'订单数'};
            var feedBack = {'type':'反馈数'};
            result.forEach(function(item){
                _this.fields.push(item.time);
                if(item.name == 'order'){
                  order[item.time] = item.total;
                }else if(item.name == 'feedback'){
                  feedBack[item.time] = item.total;
                }
            });
            countOrderFeedBack.push(order);
            countOrderFeedBack.push(feedBack);
            console.log(countOrderFeedBack);
            this.countOrderFeedBack = countOrderFeedBack;
          }
        })
      },
      getOrderDegree(){
        getAction(this.url.degree).then(res=>{
          if(res.success){
            let result = res.result;
            if(!!result.judge && !!result.count) {
              let degree = (result.judge / result.count) / 5 * 100
              this.count.orderDegree = degree;
            }else{
              this.count.orderDegree = 0;
            }
          }
        })
      },
      getFeedCount(){
        getAction(this.url.feedCount).then(res=>{
          if(res.success){
            this.count.feedBackCount = res.result;
          }
        })
      },
      getOrderCount(){
        getAction(this.url.orderCount).then(res=>{
          if(res.success){
            this.count.orderCount = res.result;
          }
        })
      },
      getVillageCount(){
        getAction(this.url.villageCount).then(res=>{
            if(res.success){
              this.count.villageCont = res.result;
            }
        })
      },
      getBuildingCount(){
        getAction(this.url.buildingCount).then(res=>{
          if(res.success){
            this.count.buildingCount = res.result;
          }
        })
      },
      getHouseCount(){
        getAction(this.url.houseCount).then(res=>{
          if(res.success){
            this.count.houseCount = res.result;
          }
        })
      },
      getPersonCount(){
        getAction(this.url.personCount).then(res=>{
          if(res.success){
            this.count.personCount = res.result;
          }
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  .extra-wrapper {
    line-height: 55px;
    padding-right: 24px;

    .extra-item {
      display: inline-block;
      margin-right: 24px;

      a {
        margin-left: 24px;
      }
    }
  }

  /* 首页访问量统计 */
  .head-info {
    position: relative;
    text-align: left;
    padding: 0 32px 0 0;
    min-width: 125px;

    &.center {
      text-align: center;
      padding: 0 32px;
    }

    span {
      color: rgba(0, 0, 0, .45);
      display: inline-block;
      font-size: .95rem;
      line-height: 42px;
      margin-bottom: 4px;
    }
    p {
      line-height: 42px;
      margin: 0;
      a {
        font-weight: 600;
        font-size: 1rem;
      }
    }
  }
</style>