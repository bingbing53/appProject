<template>
  <f7-page class="report bgcw" style="background:#fff!important;">
    <div class>
      <van-image-preview
        v-model="showImage"
        :startPosition="startIndex"
        :loop="false"
        :images="perimageArrmy"
        :showIndex="true"
      ></van-image-preview>
      <van-pull-refresh v-model="reportList.isLoading" @refresh="onRefresh">
        <van-list
          v-model="reportList.loading"
          :finished="reportList.finished"
          finished-text="没有更多了"
          @load="getreportList"
        >
          <div v-for="(item,index) in reportList.items" :key="index">
            <f7-row class="pd-10 broder_b">
              <f7-col width="100">
                <div class="f-16 online pl-5" style="line-height:26px">
                  <span class="c-666">【{{item.feedType_dictText}}】</span>
                  <span class="c-000">{{item.content}}</span>
                </div>
              </f7-col>
              <f7-col width="100" v-if="item.image">
                <div class="flexImagebox mt-10" v-if="item.image.length ==3">
                  <van-image
                    :src="formatImage(image)"
                    alt
                    width="110px"
                    height="100px"
                    fit="cover"
                    v-for="(image,ppp) in item.image"
                    @click="previewImgmy(item.image,ppp)"
                  />
                </div>
                <div class="flexImagebox2 mt-10" v-else-if="item.image.length <3">
                  <van-image
                    :src="formatImage(image)"
                    alt
                    width="110px"
                    height="100px"
                    fit="cover"
                    class="mr-3"
                    v-for="(image,ppp) in item.image"
                    @click="previewImgmy(item.image,ppp)"
                  />
                </div>
              </f7-col>
              <f7-col width="100" v-else>
                <div style="height:25px"></div>
              </f7-col>
              <f7-col width="100">
                <div class="c-999 mt-10 pt-10 f-12">
                  <span class="f-14">{{item.inDate}}</span>
                  <span
                    class="fr pr-10"
                    v-if="item.isHandle == 1"
                    @click="toDetail(item.id)"
                  >查看处理结果>></span>
                  <span class="fr pr-10" v-if="item.isHandle == 0">未处理，请耐心等待....</span>
                </div>
              </f7-col>
            </f7-row>
          </div>
        </van-list>
      </van-pull-refresh>
    </div>
    <van-popup v-model="show_detail" position="bottom" round :style="{ height: '65%' }">
      <div class="pd-10">
        <div class="f-12 bgcw text">
        <p class="f-20 c-000">问题处理结果</p>
      </div>
        <div class="mt-10">
          <div class="broder_b pd-10" v-for="(items,indexs) in reportDetail">
            <div class="mb-10">
              <span>处理时间：</span>
              <span class="c-666">{{items.createTime}}</span>
            </div>
            <div class="mb-10">
              <span>图片描述:</span>
              <div class="flexImagebox mt-10" v-if="items.image.length ==3">
                <van-image
                  :src="formatImage(image)"
                  alt
                  width="110px"
                  height="100px"
                  fit="cover"
                  class="mr-3"
                  v-for="(image,idx) in items.image"
                />
              </div>
              <div class="flexImagebox2 mt-10" v-else-if="items.image.length <3">
                <van-image
                  :src="formatImage(image)"
                  alt
                  width="110px"
                  height="100px"
                  fit="cover"
                  class="mr-3"
                  v-for="(image,idx) in items.image"
                />
              </div>
            </div>
            <div class="mb-10">
              <span>描述：</span>
              <p class="c-666 mt-10" v-html="items.handleDes"></p>
            </div>
          </div>
        </div>
      </div>
    </van-popup>
    <f7-fab position="right-bottom" slot="fixed" @click="reporeForm" color="red">
      <f7-icon ios="f7:add" aurora="f7:add" md="material:add"></f7-icon>
    </f7-fab>
  </f7-page>
</template>

<script>
import { reportType, reportList, reportDetail } from "@/api/api_estate.js";
export default {
  data() {
    return {
      reportList: {
        items: [],
        isLoading: false,
        loading: false,
        finished: false,
        totalPage: 0,
        pageNo: 1
      },
      reportDetail: [],
      show_detail: false,
      //图片预览
      perimageArrmy: [],
      startIndex: 0,
      showImage: false
    };
  },
  created() {
    this.$commonUtils.setTitle("报事");
  },

  methods: {
    //图片预览
    previewImgmy(img, index) {
      this.perimageArrmy = [];
      let _this = this;
      this.showImage = true;
      this.startIndex = index;
      img.forEach((item, index2) => {
        item = _this.formatImage(item, 1);
        _this.perimageArrmy.push(item);
      });
    },
    reporeForm() {
      this.$f7router.navigate(`/estate/ReportForm/forceClose/`);
    },
    getreportList() {
      let pageNo = this.reportList.pageNo;
      reportList({ pageNo: this.reportList.pageNo })
        .then(res => {
          this.handleData(res);
          this.reportList.totalPage = res.pages;
          this.reportList.loading = false;
          if (res.data.pages <= res.data.current) {
            this.reportList.finished = true;
          } else {
            this.reportList.pageNo++;
          }
        })
        .catch(err => {
          this.$commonUtils.jumpLogin(err);
        });
    },
    onRefresh() {
      this.reportList.totalPage = 0;
      this.reportList.pageNo = 1;
      this.init(); //加载数据
    },
    async init() {
      let res = await reportList(this.reportList.pageNo);
      console.log(res);
      this.reportList.items = [];
      this.handleData(res);
      this.reportList.totalPage = res.data.pages;
      this.reportList.isLoading = false; //关闭下拉刷新效果
      this.reportList.finished = false;
      if (res.data.pages <= res.data.current) {
        this.reportList.finished = true;
      } else {
        this.reportList.pageNo++;
      }
    },
    async loadData() {
      let _this = this;
      let res = await reportList({ pageNo: 1 });
      if (res.status == 200) {
        res.data.records.forEach((item, index) => {
          if (item.image) {
            item.image = item.image.split(",");
            for (let i in item.image) {
              item.image[i] = _this.$commonUtils.formatPicture(item.image[i]);
            }
          }
        });
        this.reportList.items = res.data.records;
      }
    },
    handleData(res) {
      let _this = this;
      res.data.records.forEach((item, index) => {
        if (item.image) {
          item.image = item.image.split(",");
          // for (let i in item.image) {
          //   item.image[i] = _this.$commonUtils.formatPicture(item.image[i]);
          // }
        }
        _this.reportList.items.push(item);
      });
    },
    toDetail(id) {
      this.show_detail = true;
      this.getDetail(id);
    },
    //获取详情的数据
    getDetail(id) {
      let _this = this;
      reportDetail(id)
        .then(res => {
          res.data.feedHandles.forEach(function(item, index) {
            item.image = JSON.parse(item.image);
          });
          _this.reportDetail = res.data.feedHandles;
        })
        .catch(err => {});
    },
    //格式化图片路径
    formatImage(url,type) {
      return this.$commonUtils.formatPicture(url,type);
    }
  },
  mounted() {
    if (this.GLOBAL.fromPage == 1) {
      //  window.history.go(0)
      window.location.reload();
    }
  }
};
</script>
<style scoped>
.flexImagebox {
  display: flex;
  justify-content: space-around;
  width: 100%;
  height: 100px;
}
.flexImagebox2 {
  display: flex;
  justify-content: flex-start;
  width: 100%;
  height: 100px;
}
</style>