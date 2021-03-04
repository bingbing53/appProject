<template>
  <div class="page-header-index-wide">
    <div v-for="appData in app" :key="appData.code">
      <a-row :gutter="24">
        <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
          <chart-card :loading="loading" :title="appData.name + '下载量'" :total="appData.download | NumberFormat">
          </chart-card>
        </a-col>
        <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
          <chart-card :loading="loading" :title="appData.name + '活跃用户数'" :total="appData.activeUser | NumberFormat">
          </chart-card>
        </a-col>
      </a-row>
      <a-row>
        <a-col>
          <div :id="appData.code" class="my-chart"></div>
        </a-col>
      </a-row>
      <a-row>
        <a-col>
          <div :id="appData.code + '_total_download'" class="my-chart"></div>
        </a-col>
      </a-row>
    </div>
  </div>
</template>

<script>
  import {getAction} from '@/api/manage'
  import ChartCard from '@/components/ChartCard'
  let echarts = require("echarts");

  export default {
    name: "Analysis",
    components: {
      ChartCard
    },
    data() {
      return {
        loading: true,
        url: {
          countAppDownload: '/data/app/download',
          countActiveUser: '/data/app/user/active',
          countAppDownloadPerDay: '/data/app/download/perDay',
          countActiveUserPerDay: '/data/app/user/active/perDay',
          totalAppDownloadPerDay: '/data/app/download/total/perDay'
        },
        app: [
          {
            name: "社区e家APP",
            code: "shequyijia",
            download: 0,
            activeUser: 0,
            perDay: {
              data: {},
              dateArr: [],
              downloadArr: [],
              activeUserArr: []
            },
            totalDownloadPerDay: {
              dateArr: [],
              downloadArr: []
            }
          }
        ]
      }
    },
    methods: {
      /**
       * 获取app下载量
       */
      countAppDownload(appData) {
        getAction(this.url.countAppDownload, {appCode: appData.code}).then(res => {
          if (res.success) {
            appData.download = res.result;
          }
        })
      },
      /**
       * 获取活跃用户数
       */
      countActiveUser(appData) {
        getAction(this.url.countActiveUser, {appCode: appData.code}).then(res => {
          if (res.success) {
            appData.activeUser = res.result;
          }
        })
      },
      /**
       * 获取每日app下载量
       */
      countAppDownloadPerDay(appData) {
        return getAction(this.url.countAppDownloadPerDay, {appCode: appData.code}).then(res => {
          if (res.success) {
            return res.result;
          }
        })
      },
      /**
       * 获取每日活跃用户数
       */
      countActiveUserPerDay(appData) {
        return getAction(this.url.countActiveUserPerDay, {appCode: appData.code}).then(res => {
          if (res.success) {
            return res.result;
          }
        })
      },
      /**
       * 获取总下载量每日数据
       */
      totalAppDownloadPerDay(appData) {
        let _this = this;
        getAction(this.url.totalAppDownloadPerDay, {appCode: appData.code}).then(res => {
          if (res.success) {
            for (let [date, download] of Object.entries(res.result)) {
              appData.totalDownloadPerDay.dateArr.push(date);
              appData.totalDownloadPerDay.downloadArr.push(download);
            }
            _this.showTotalDownloadPerDay(appData);
          }
        })
      },
      /**
       * 加载汇总数据
       */
      loadTotalData() {
        for (let appData of this.app) {
          this.countAppDownload(appData);
          this.countActiveUser(appData);
          this.totalAppDownloadPerDay(appData);
        }
      },
      /**
       * 加载每日数据
       */
      loadPerDayData() {
        let _this = this;
        for (let appData of this.app) {
          Promise.all([this.countAppDownloadPerDay(appData), this.countActiveUserPerDay(appData)]).then(
            ([downloadPerDay, activeUserPerDay]) => {
              appData.perDay = {
                data: {},
                dateArr: [],
                downloadArr: [],
                activeUserArr: []
              };
              let perDayData = appData.perDay.data;
              for (let [date, download] of Object.entries(downloadPerDay)) {
                perDayData[date] = {download: download};
              }
              for (let [date, activeUser] of Object.entries(activeUserPerDay)) {
                perDayData[date] = perDayData[date] ? perDayData[date] : {};
                perDayData[date].activeUser = activeUser;
              }
              let dataEntries = Object.entries(perDayData);
              dataEntries.sort((a, b) => a[0] == b[0] ? 0 : (a[0] > b[0] ? 1 : -1));
              for (let [date, count] of dataEntries) {
                appData.perDay.dateArr.push(date);
                appData.perDay.downloadArr.push(count.download ? count.download : 0);
                appData.perDay.activeUserArr.push(count.activeUser ? count.activeUser : 0);
              }
              _this.showPerDay(appData);
            }
          ).catch(reason => {
            _this.$message.error("请求异常：" + reason);
          });
        }
      },
      /**
       * 展示每日数据
       */
      showPerDay(appData) {
        let appEcharts = echarts.init(document.getElementById(appData.code));
        appEcharts.setOption({
          title: {
            text: appData.name + '每日数据',
            left: 'center',
            top: '2%'
          },
          legend: {
            data: ['下载量', '活跃用户数'],
            bottom: '12%'
          },
          tooltip: {
            trigger: 'axis'
          },
          grid: {
            left:'50',
            right: '80',
            bottom: '20%',
            containLabel: true
          },
          xAxis: {
            type: 'category',
            boundaryGap: false,
            data: appData.perDay.dateArr
          },
          yAxis: {
            type: 'value'
          },
          dataZoom: {
            type: 'slider',
            xAxisIndex: 0,
            startValue: Math.max(appData.perDay.dateArr.length - 7, 0),
            endValue: Math.max(appData.perDay.dateArr.length - 1, 0)
          },
          series: [
            {
              name: '下载量',
              type: 'line',
              data: appData.perDay.downloadArr
            },
            {
              name: '活跃用户数',
              type: 'line',
              data: appData.perDay.activeUserArr
            }
          ]
        })
      },
      /**
       * 展示总下载量每日情况
       */
      showTotalDownloadPerDay(appData) {
        let appEcharts = echarts.init(document.getElementById(appData.code + '_total_download'));
        appEcharts.setOption({
          title: {
            text: appData.name + '总下载量',
            left: 'center',
            top: '2%'
          },
          legend: {
            data: ['总下载量'],
            bottom: '12%'
          },
          tooltip: {
            trigger: 'axis'
          },
          grid: {
            left:'50',
            right: '80',
            bottom: '20%',
            containLabel: true
          },
          xAxis: {
            type: 'category',
            boundaryGap: false,
            data: appData.totalDownloadPerDay.dateArr
          },
          yAxis: {
            type: 'value'
          },
          dataZoom: {
            type: 'slider',
            xAxisIndex: 0,
            startValue: Math.max(appData.totalDownloadPerDay.dateArr.length - 7, 0),
            endValue: Math.max(appData.totalDownloadPerDay.dateArr.length - 1, 0)
          },
          series: [
            {
              name: '总下载量',
              type: 'line',
              data: appData.totalDownloadPerDay.downloadArr
            }
          ]
        })
      }
    },
    created() {
      setTimeout(() => {
        this.loading = !this.loading
      }, 1000);
      this.loadTotalData();
      this.loadPerDayData();
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
  .my-chart {
    height: 400px;
    width: 100%;
    padding:10px;
    margin-bottom: 24px;
    background: #ffffff;
  }
</style>