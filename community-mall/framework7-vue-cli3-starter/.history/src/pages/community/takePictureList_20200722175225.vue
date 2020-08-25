<template>
  <f7-page class="picture">
    <div>
      <div v-if="isLen == 0" class="tc pt-150">
        <div>
          <img src="@/assets/pictureKong.png" alt width="100px" />
        </div>
        <p class="c-ccc tc mt-20 f-14" style="line-height:28px">您还没有创建反馈记录呦。如有问题，点击右下角按钮反馈吧</p>
      </div>
      <van-pull-refresh v-model="feedBackList.isLoading" @refresh="onRefresh" v-else>
        <van-list
          v-model="feedBackList.loading"
          :finished="feedBackList.finished"
          finished-text="没有更多了"
          @load="getList"
        >
          <f7-block>
            <div>
              <div v-for="item in feedBackList.records">
                <div class="threeImages">
                  <div class="oneline">
                    <van-tag plain type="danger" class="mr-10">{{item.willTypeName}}</van-tag>
                    {{item.title}}
                  </div>
                  <div class="f-12 c-666 mt-5">
                    <van-icon name="location-o" />
                    {{item.address}}
                  </div>
                  <div class="twoline c-666 f-14 pt-10">{{item.content}}</div>
                  <van-grid square :border="false">
                    <van-grid-item
                      v-for="(image,index) in item.images"
                      @click="imagePreview(item.images,index)"
                      :key="index"
                    >
                      <van-image fit="cover" width="100%" height="100%" :src="image" />
                    </van-grid-item>
                  </van-grid>
                  <div class="clear"></div>
                </div>
                <div class="f-12 c-999 pt-10">
                  {{item.createDate}}
                  <span
                    v-if="!!item.feedBack"
                    class="c-blue"
                    @click="openSheet(item.feedBack)"
                  >已回复</span>
                  <span v-else>未回复</span>
                </div>
                <div class="line mt-10 mb-10"></div>
              </div>
            </div>
          </f7-block>
        </van-list>
        <van-popup v-model="sheetOpen" round position="bottom" :style="{ height: '80%' }">
          <div class="f-12 bgcw text">
            <p class="f-20 c-000">社区回复</p>
          </div>
          <div class="pd-10 rich" v-html="sheetContent"></div>
        </van-popup>
      </van-pull-refresh>
    </div>

    <f7-fab position="right-bottom" slot="fixed" @click="takePicture" color="red" class="myBuuuuuu">
      <f7-icon ios="f7:add" aurora="f7:add" md="material:add"></f7-icon>
    </f7-fab>
  </f7-page>
</template>

<script>
import Vue from "vue";
import { takePictureList } from "@/api/api_community";
import { ImagePreview, Grid, GridItem } from "vant";
Vue.use(Grid)
  .use(GridItem)
  .use(ImagePreview);
export default {
  data() {
    return {
      sheetOpen: false,
      sheetContent: "",
      feedBackList: {
        total: -1,
        pageNo: 1,
        records: [],
        isLoading: false,
        loading: false,
        finished: false,
        totalPage: 0
      },
      showPreloader: false,
      allowInfinite: true,
      isLen: 0
    };
  },
  created() {
    this.$commonUtils.setTitle("随手拍列表");
    this.getLenList();
    setTimeout(function() {
      // document.getElementById("emptyList").style.visibility = "visible";
    }, 500);
  },
  mounted() {},
  methods: {
    takePicture() {
      this.$f7router.navigate(`/community/takePicture/forceClose/`);
    },
    imagePreview(images, position) {
      ImagePreview({
        images,
        startPosition: position,
        onClose() {
          // do something
        }
      });
    },
    openSheet(content) {
      this.sheetContent = content;
      this.sheetOpen = true;
    },
    getLenList() {
      takePictureList({ pageNo: 1 })
        .then(res => {
          // res.data.records =[]
          this.isLen = res.data.records;
        })
        .catch(err => {});
    },
    //下拉刷新
    onRefresh() {
      this.feedBackList.totalPage = 0;
      this.feedBackList.pageNo = 1;
      this.init(); //加载数据
    },
    async init() {
      let _this = this;
      let res = await takePictureList(this.feedBackList.pageNo);
      this.feedBackList.records = [];
      this.handleData(res);
      this.feedBackList.totalPage = res.data.pages;
      this.feedBackList.isLoading = false; //关闭下拉刷新效果
      this.feedBackList.finished = false;
      if (res.data.pages <= res.data.current) {
        this.feedBackList.finished = true;
      } else {
        this.feedBackList.pageNo++;
      }
    },
    //获取随手拍列表
    getList() {
      let that = this;
      let pageNo = this.feedBackList.pageNo;
      takePictureList({ pageNo: this.feedBackList.pageNo })
        .then(res => {
          this.handleData(res);
          this.feedBackList.totalPage = res.pages;
          this.feedBackList.loading = false;
          if (res.data.pages <= res.data.current) {
            this.feedBackList.finished = true;
          } else {
            this.feedBackList.pageNo++;
          }
        })
        .catch(err => {
          this.$commonUtils.jumpLogin(err);
          this.allowInfinite = true;
          if (this.feedBackList.isLoading) {
            wx.toast("刷新成功");
            this.feedBackList.isLoading = true;
          }
        });
    },
    handleData(res) {
      let that = this;
      let result = res.data;
      if (result.records.length > 0) {
        result.records.forEach(function(item, index) {
          let images = [];
          if (!!item.image) {
            try {
              let imageJson = JSON.parse(item.image);
              imageJson.forEach(function(image) {
                images.push(that.$commonUtils.formatPicture(image));
              });
            } catch (e) {}
          }
          item["images"] = images;
          that.feedBackList.records.push(item);
        });
      }
    }
  }
};
</script>
<style scoped>
.line {
  height: 1px;
  background: #eee;
}
.rich >>> img {
  max-width: 100%;
  display: block;
}
.threeImages {
  background: #fff;
}
/* .threeImages span {
  font-size: 12px;
  color: #666;
} */
.threeImages .threeImages_content {
  margin-top: 10px;
  margin-bottom: 8px;
}
.threeImages .threeImages_content div {
  display: inline-block;
  width: 32.5% !important;
  height: 0px;
  padding-bottom: 26.5%;
}
.threeImages .threeImages_content div:nth-child(1) {
  float: left;
  margin-right: 1.3%;
}
.threeImages .threeImages_content div:nth-child(3) {
  float: right;
}
.flowImage {
  transform: translate(-50%, -50%);
  position: absolute;
  top: 50%;
  left: 50%;
}
.flowImageOuter {
  overflow: hidden;
  position: relative;
}
.myBuuuuuu > a {
  background: #f00 !important;
}
</style>