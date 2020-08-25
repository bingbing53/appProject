<template>
  <!--<f7-page>-->
  <van-pull-refresh
    v-model="activity.refreshLoading"
    success-text="刷新成功"
    @refresh="getActivityHistory(1)"
  >
    <van-list
      v-model="activity.pullDownLoading"
      :finished="activity.finished"
      finished-text="没有更多了"
      @load="getActivityHistory(0)"
    >
      <div v-for="item in activity.records" @click="jumpActivity(item.activity.id)">
        <van-row class="pl-10 pr-10 pt-10">
          <van-col span="15">
            <div class="van-multi-ellipsis--l2">
              <b>{{item.activity.title}}</b>
            </div>
            <div class="f-12 pt-10 c-666 mt-10">报名时间：{{item.registerTime}}</div>
            <div class="f-12 c-666 mt-10">开始时间：{{item.activity.startTime}}</div>
          </van-col>
          <van-col span="9">
            <img :src="item.activity.posterUrl" width="100%" height="100" class="border-radius5" />
          </van-col>
        </van-row>
        <div class="pl-10 pr-10">
          <van-tag plain v-if="item.activity.activityState == '1'" type="success" class="mr-5">进行中</van-tag>
          <van-tag plain v-if="item.activity.activityState == '2'" class="mr-5">已结束</van-tag>
          <van-tag plain v-if="item.register == '2'" size="mini">未签</van-tag>
          <van-tag plain type="success" v-if="item.register == '1'" size="mini">已签</van-tag>
          <van-tag plain type="danger" v-if="item.register == '0'" size="mini">缺勤</van-tag>
          <van-tag
            plain
            type="primary"
            size="mini"
            class="ml-10 pl-10 pr-10"
          >时长 | {{item.timeLong || 0}}</van-tag>
          <van-tag
            class="ml-10 pl-10 pr-10"
            plain
            type="primary"
            size="mini"
          >积分 | {{item.points || 0}}</van-tag>
        </div>
        <div class="line mt-10"></div>
      </div>
    </van-list>
  </van-pull-refresh>
  <!--</f7-page>-->
</template>

<script>
import { activityHisList } from "@/api/api_cms.js";
export default {
  data() {
    return {
      activity: {
        refreshLoading: false,
        pullDownLoading: false,
        finished: false,
        total: -1,
        current: 0,
        pages: 1,
        records: []
      }
    };
  },
  created() {
    this.$commonUtils.setTitle("活动历史");
  },
  methods: {
    jumpActivity(id) {
      this.$f7router.navigate(`/cms/activityDetail?id=${id}/`, {
        props: {
          foo: "bar",
          bar: true
        }
      });
    },
    getActivityHistory(type) {
      let _this = this;
      if (type == 1) {
        this.activity.total = 0;
        this.activity.current = 0;
        this.activity.pages = 1;
        this.activity.records = [];
      }

      if (this.activity.current >= this.activity.pages) {
        return;
      }
      activityHisList()
        .then(res => {
          this.activity.refreshLoading = false;
          this.activity.pullDownLoading = false;
          var result = res.data;
          this.activity.total = result.total;
          this.activity.current = result.current;
          this.activity.pages = result.pages;
          if (this.activity.current >= this.activity.pages) {
            this.activity.finished = true;
          }
          result.records.forEach(function(item) {
            try {
              item.activity.posterUrl = _this.$commonUtils.formatPicture(
                item.activity.posterUrl
              );
              _this.activity.records.push(item);
            } catch (e) {}
          });
        })
        .catch(err => {
          this.activity.refreshLoading = false;
          this.activity.pullDownLoading = false;
          this.$commonUtils.jumpLogin(err);
        });
    }
  }
};
</script>
<style scoped>

</style>