<template>
  <div class="page-header-index-wide">
    <a-row :gutter="24">
      <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
        <chart-card :loading="loading" title="文章发布数" :total="count.articleCount.count | NumberFormat">
          <a-tooltip title="总共发布的文章数量" slot="action">
            <a-icon type="info-circle-o" />
          </a-tooltip>
          <div>
            <mini-bar :height="40" :dataSource="count.articlePub"/>
          </div>
          <template slot="footer">文章发布数</template>
        </chart-card>
      </a-col>

      <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
        <chart-card :loading="loading" title="文章浏览量" :total="count.articleCount.hits | NumberFormat">
          <a-tooltip title="文章被点击的次数" slot="action">
            <a-icon type="info-circle-o" />
          </a-tooltip>
          <div>
            <mini-area :dataSource="count.articleHits"/>
          </div>
          <template slot="footer">文章浏览量</template>
        </chart-card>
      </a-col>

      <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
        <chart-card :loading="loading" title="视频发布数" :total="count.videoCount.count | NumberFormat">
          <a-tooltip title="发布的视频总量" slot="action">
            <a-icon type="info-circle-o" />
          </a-tooltip>
          <div>
            <mini-bar :height="40" :dataSource="count.videoPub"/>
          </div>
          <template slot="footer">视频发布数</template>
        </chart-card>
      </a-col>

      <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
        <chart-card :loading="loading" title="视频播放量" :total="count.videoCount.hits | NumberFormat">
          <a-tooltip title="视频的播放总量" slot="action">
            <a-icon type="info-circle-o" />
          </a-tooltip>
          <div>
            <mini-area :dataSource="count.videoHits"/>
          </div>
          <template slot="footer">视频播放量</template>
        </chart-card>
      </a-col>
    </a-row>
  </div>
</template>

<script>
  import ChartCard from '@/components/ChartCard'
  import ACol from "ant-design-vue/es/grid/Col"
  import ATooltip from "ant-design-vue/es/tooltip/Tooltip"
  import MiniArea from '@/components/chart/MiniArea'
  import MiniBar from '@/components/chart/MiniBar'
  import MiniProgress from '@/components/chart/MiniProgress'
  import RankList from '@/components/chart/RankList'
  import Bar from '@/components/chart/Bar'
  import Trend from '@/components/Trend'
  import { getAction } from '@/api/manage'

  export default {
    name: "Analysis",
    components: {
      ATooltip,
      ACol,
      ChartCard,
      MiniArea,
      MiniBar,
      MiniProgress,
      RankList,
      Bar,
      Trend
    },
    data() {
      return {
        loading: true,
        url:{
          getPublishCount:'/statis/index/publishCount',
          getPublishCountMonth:'/statis/index/publicMonthCount/'
        },
        count:{
          articleCount:{
            hits:0,
            count:0
          },
          videoCount:{
            hits:0,
            count:0
          },
          articleHits:[],
          articlePub:[],
          videoHits:[],
          videoPub:[]
        }
      }
    },
    created() {
      setTimeout(() => {
        this.loading = !this.loading
      }, 1000)

      this.getPublishCount();
      this.getPublishCountMonth('0');
      this.getPublishCountMonth('1');
    },
    methods: {
      getPublishCount(){
        var _this = this;
        getAction(this.url.getPublishCount).then(res=>{
          if(res.success){
            let result = res.result;
            if(!!result && result.length > 0){
              for(var i = 0;i<result.length;i++){
                  if(result[i].type == '0'){
                      this.count.articleCount = result[i];
                  }else if(result[i].type == '1'){
                      this.count.videoCount = result[i];
                  }
              }
            }
          }
        })
      },
      getPublishCountMonth(type){
        var _this = this;
        getAction(this.url.getPublishCountMonth+type).then(res=>{
          if(res.success){
            let result = res.result;
            if(!!result && result.length > 0){
              for(var i = 0;i<result.length;i++) {
                if (type == '0') {
                  this.count.articleHits.push({
                    x:result[i].time,
                    y:result[i].hits
                  });
                  this.count.articlePub.push({
                    x:result[i].time,
                    y:result[i].count
                  });
                } else if (type == '1') {
                  this.count.videoHits.push({
                    x:result[i].time,
                    y:result[i].hits
                  });
                  this.count.videoPub.push({
                    x:result[i].time,
                    y:result[i].count
                  });
                }
              }
            }
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