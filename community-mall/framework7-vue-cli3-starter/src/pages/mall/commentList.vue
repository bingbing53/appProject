<template>
  <f7-page>
    <van-tabs @click="clickTab" v-model="active" sticky class="my_detail">
      <van-icon name="arrow-left" class="my_coin2" @click="$commonUtils.onClickLeft" />
      <van-image-preview
        v-model="showImage"
        :startPosition="startIndex"
        :loop="false"
        :images="perimageArrmy"
        :showIndex="true"
      ></van-image-preview>
      <van-tab title="全部">
        <van-pull-refresh
          v-model="commentListAll.isLoading"
          @refresh="commentRefreshAll"
          class="my_refresh"
        >
          <van-list
            v-model="commentListAll.loading"
            :finished="commentListAll.finished"
            finished-text="没有更多了"
            :immediate-check="false"
            @load="getCommentListAll"
          >
            <f7-list media-list style="z-index:0; font-size:14px!important">
              <f7-list-item
                :title="item.name"
                :subtitle="substringDate(item.date)"
                v-for="(item,index) in commentListAll.rows"
              >
                <div>
                  <p>
                    <van-rate
                      color="#ee0a24"
                      :size="16"
                      void-icon="star"
                      void-color="#eee"
                      v-model="item.comment"
                      readonly 
                    />
                  </p>
                  <p v-if="item.content">{{item.content}}</p>
                  <p v-else>该买家没有评价文字.....</p>
                  <div class="commitImage mt-10">
                    <template v-if="item.pics && item.pics.length >= 1">
                      <div>
                        <van-image
                          :src="formatImage(image)"
                          alt
                          width="80px"
                          height="80px"
                          fit="cover"
                          v-for="(image,ppp) in item.pics"
                          class="mr-5"
                          @click="previewImgmy(item.pics,ppp)"
                        />
                      </div>
                    </template>
                  </div>
                </div>
                <img
                  :src="formatImage(item.url)"
                  style="width: 40px; height: 40px; border-radius: 50%"
                  slot="media"
                />
              </f7-list-item>
            </f7-list>
          </van-list>
        </van-pull-refresh>
      </van-tab>
      <van-tab title="好评">
        <van-pull-refresh
          v-model="commentListGood.isLoading"
          @refresh="commentRefreshGood"
          class="my_refresh"
        >
          <van-list
            v-model="commentListGood.loading"
            :finished="commentListGood.finished"
            finished-text="没有更多了"
            :immediate-check="false"
            @load="getCommentListGood"
          >
            <f7-list media-list style="z-index:0; font-size:14px!important">
              <f7-list-item
                :title="item.name"
                :subtitle="substringDate(item.date)"
                v-for="(item,index) in commentListGood.rows"
              >
                <div>
                  <p>
                    <van-rate
                      color="#ee0a24"
                      :size="16"
                      void-icon="star"
                      void-color="#eee"
                      v-model="item.comment"
                      readonly 
                    />
                  </p>
                  <p v-if="item.content">{{item.content}}</p>
                  <p v-else>该买家没有评价文字.....</p>
                  <div class="commitImage mt-10">
                    <template v-if="item.pics && item.pics.length > 1">
                      <div>
                        <van-image
                          :src="formatImage(image)"
                          alt
                          width="80px"
                          height="80px"
                          fit="cover"
                          v-for="(image,ppp) in item.pics"
                          class="mr-5"
                          @click="previewImgmy(item.pics,ppp)"
                        />
                      </div>
                    </template>
                  </div>
                </div>
                <img
                  :src="formatImage(item.url)"
                  style="width: 40px; height: 40px; border-radius: 50%"
                  slot="media"
                />
              </f7-list-item>
            </f7-list>
          </van-list>
        </van-pull-refresh>
      </van-tab>
      <van-tab title="中评">
        <van-pull-refresh
          v-model="commentListMiddle.isLoading"
          @refresh="commentRefreshMiddle"
          class="my_refresh"
        >
          <van-list
            v-model="commentListMiddle.loading"
            :finished="commentListMiddle.finished"
            finished-text="没有更多了"
            :immediate-check="false"
            @load="getCommentListMiddle"
          >
            <f7-list media-list style="z-index:0;font-size:14px!important">
              <f7-list-item
                class="my_item"
                :title="item.name"
                :subtitle="substringDate(item.date)"
                v-for="(item,index) in commentListMiddle.rows"
              >
                <div>
                  <p>
                    <van-rate
                      color="#ee0a24"
                      :size="16"
                      void-icon="star"
                      void-color="#eee"
                      v-model="item.comment"
                      readonly 
                    />
                  </p>
                  <p v-if="item.content">{{item.content}}</p>
                  <p v-else>该买家没有评价文字.....</p>
                  <div class="commitImage mt-10">
                    <template v-if="item.pics && item.pics.length > 1">
                      <div>
                        <van-image
                          :src="formatImage(image)"
                          alt
                          width="80px"
                          height="80px"
                          fit="cover"
                          v-for="(image,ppp) in item.pics"
                          class="mr-5"
                          @click="previewImgmy(item.pics,ppp)"
                        />
                      </div>
                    </template>
                  </div>
                </div>
                <img
                  :src="formatImage(item.url)"
                  style="width: 40px; height: 40px; border-radius: 50%"
                  slot="media"
                />
              </f7-list-item>
            </f7-list>
          </van-list>
        </van-pull-refresh>
      </van-tab>
      <van-tab title="差评">
        <van-pull-refresh
          v-model="commentListBad.isLoading"
          @refresh="commentRefreshBad"
          class="my_refresh"
        >
          <van-list
            v-model="commentListBad.loading"
            :finished="commentListBad.finished"
            finished-text="没有更多了"
            :immediate-check="false"
            @load="getCommentListBad"
          >
            <f7-list media-list style="z-index:0;font-size:14px!important;">
              <f7-list-item
                class="my_item"
                :title="item.name"
                :subtitle="substringDate(item.date)"
                v-for="(item,index) in commentListBad.rows"
              >
                <div>
                  <p class="mb-5">
                    <van-rate
                      color="#ee0a24"
                      :size="16"
                      void-icon="star"
                      void-color="#eee"
                      v-model="item.comment"
                      readonly 
                    />
                  </p>
                  <p v-if="item.content">{{item.content}}</p>
                  <p v-else>该买家没有评价文字.....</p>
                  <div class="commitImage mt-10">
                    <template v-if="item.pics && item.pics.length > 1">
                      <div>
                        <van-image
                          :src="formatImage(image)" 
                          alt
                          width="80px"
                          height="80px"
                          fit="cover"
                          v-for="(image,ppp) in item.pics"
                          class="mr-5"
                          @click="previewImgmy(item.pics,ppp)"
                        />
                      </div>
                    </template>
                  </div>
                </div>
                <img
                  v-if="item.url"
                  :src="formatImage(item.url)"
                  style="width: 40px; height: 40px; border-radius: 50%"
                  slot="media"
                />
                <img
                  v-else
                  src="@/assets/people.png"
                  style="width: 40px; height: 40px; border-radius: 50%;border:1px solid #eee"
                  slot="media"
                />
              </f7-list-item>
            </f7-list>
          </van-list>
        </van-pull-refresh>
      </van-tab>
    </van-tabs>
  </f7-page>
</template>

<script>
import { productCommuntList } from "@/api/api_mall.js";
export default {
  data() {
    return {
      active: 0,
      id: "",
      valuePate: 5,
      commentListAll: {
        isLoading: false,
        pageNumber: 1,
        totalPage: 0,
        loading: false,
        finished: false,
        rows: []
      },
      commentListGood: {
        isLoading: false,
        pageNumber: 1,
        totalPage: 0,
        loading: false,
        finished: false,
        rows: []
      },
      commentListMiddle: {
        isLoading: false,
        pageNumber: 1,
        totalPage: 0,
        loading: false,
        finished: false,
        rows: []
      },
      commentListBad: {
        isLoading: false,
        pageNumber: 1,
        totalPage: 0,
        loading: false,
        finished: false,
        rows: []
      },
      //图片预览
      showImage: false,
      perimageArrmy: [],
      startIndex: 0
    };
  },
  methods: {
    substringDate(time) {
      // return time.substring(0, 10);
    },
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
      console.log(this.perimageArrmy);
    },
    //格式化图片路径
    formatImage(url, size) {
      return this.$commonUtils.formatPicture(url, size);
    },
    clickTab() {
      if (this.active == 1) {
        this.commentListGood.rows = [];
        this.commentListGood.pageNumber = 1;
        this.getCommentListGood();
      } else if (this.active == 2) {
        this.commentListMiddle.rows = [];
        this.commentListMiddle.pageNumber = 1;
        this.getCommentListMiddle();
      } else if (this.active == 3) {
        this.commentListBad.rows = [];
        this.commentListBad.pageNumber = 1;
        this.getCommentListBad();
      }
    },
    //************************************* */ 全部数据start******************************************
    getCommentListAll() {
      let param = {
        productId: this.id,
        pageSize: 10,
        pageNum: this.commentListAll.pageNumber,
        star: "all"
      };
      let _this = this;
      productCommuntList(param)
        .then(res => {
          res.data.data.list.forEach((item, index) => {
            item.url = item.userHeadimage;
            item.comment = item.star;
            item.name = item.userName;
            item.date = item.createTime;
          });
          _this.handleData(res.data, 0);
          this.commentListAll.totalPage = res.data.data.totalPage;
          this.commentListAll.isLoading = false;
          this.commentListAll.loading = false;

          if (res.data.data.totalPage <= res.data.data.pageNum) {
            this.commentListAll.finished = true;
          } else {
            this.commentListAll.pageNumber++;
          }
        })
        .catch(err => {});
    },
    commentRefreshAll(index) {
      this.commentListAll.totalPage = 0;
      this.commentListAll.pageNumber = 1;
      this.initAll(); //加载数据
    },
    async initAll() {
      this.commentListAll.rows = [];
      let param = {
        productId: this.id,
        pageSize: 10,
        pageNum: 1,
        star: "all"
      };
      let _this = this;
      productCommuntList(param)
        .then(res => {
          res.data.data.list.forEach((item, index) => {
            item.url = item.userHeadimage;
            item.comment = item.star;
            item.name = item.userName;
            item.date = item.createTime;
          });
          _this.handleData(res.data, 0);
          this.commentListAll.totalPage = res.data.data.totalPage;
          this.commentListAll.isLoading = false;
          this.commentListAll.loading = false;

          if (res.data.data.totalPage <= res.data.data.pageNum) {
            this.commentListAll.finished = true;
          } else {
            this.commentListAll.pageNumber++;
          }
        })
        .catch(err => {});
    },
    //************************************* */ 全部数据end******************************************
    //************************************* */ 好评数据start******************************************
    //好评数据
    getCommentListGood() {
      let param = {
        productId: this.id,
        pageSize: 10,
        pageNum: this.commentListGood.pageNumber,
        star: "good"
      };
      let _this = this;
      productCommuntList(param)
        .then(res => {
          res.data.data.list.forEach((item, index) => {
            item.url = item.userHeadimage;
            item.comment = item.star;
            item.name = item.userName;
            item.date = item.createTime;
          });
          _this.handleData(res.data, 1);
          this.commentListGood.totalPage = res.data.data.totalPage;
          this.commentListGood.isLoading = false;
          this.commentListGood.loading = false;

          if (res.data.data.totalPage <= res.data.data.pageNum) {
            this.commentListGood.finished = true;
          } else {
            this.commentListGood.pageNumber++;
          }
        })
        .catch(err => {});
    },
    commentRefreshGood(index) {
      this.commentListGood.totalPage = 0;
      this.commentListGood.pageNumber = 1;
      this.initGood(); //加载数据
    },
    async initGood() {
      this.commentListGood.rows = [];
      let param = {
        productId: this.id,
        pageSize: 10,
        pageNum: 1,
        star: "good"
      };
      let _this = this;
      productCommuntList(param)
        .then(res => {
          res.data.data.list.forEach((item, index) => {
            item.url = item.userHeadimage;
            item.comment = item.star;
            item.name = item.userName;
            item.date = item.createTime;
          });
          _this.handleData(res.data, 1);
          this.commentListGood.totalPage = res.data.data.totalPage;
          this.commentListGood.isLoading = false;
          this.commentListGood.loading = false;

          if (res.data.data.totalPage <= res.data.data.pageNum) {
            this.commentListGood.finished = true;
          } else {
            this.commentListGood.pageNumber++;
          }
        })
        .catch(err => {});
    },
    //************************************* */ 好评数据end*******************************
    //************************************* */ 中评数据start******************************
    //中评数据
    getCommentListMiddle() {
      let param = {
        productId: this.id,
        pageSize: 10,
        pageNum: this.commentListMiddle.pageNumber,
        star: "middle"
      };
      let _this = this;
      productCommuntList(param)
        .then(res => {
          res.data.data.list.forEach((item, index) => {
            item.url = item.userHeadimage;
            item.comment = item.star;
            item.name = item.userName;
            item.date = item.createTime;
          });
          _this.handleData(res.data, 2);
          this.commentListMiddle.totalPage = res.data.data.totalPage;
          this.commentListMiddle.isLoading = false;
          this.commentListMiddle.loading = false;

          if (res.data.data.totalPage <= res.data.data.pageNum) {
            this.commentListMiddle.finished = true;
          } else {
            this.commentListMiddle.pageNumber++;
          }
        })
        .catch(err => {});
    },
    commentRefreshMiddle(index) {
      this.commentListMiddle.totalPage = 0;
      this.commentListMiddle.pageNumber = 1;
      this.initMiddle(); //加载数据
    },
    async initMiddle() {
      this.commentListMiddle.rows = [];
      let param = {
        productId: this.id,
        pageSize: 10,
        pageNum: 1,
        star: "middle"
      };
      let _this = this;
      productCommuntList(param)
        .then(res => {
          res.data.data.list.forEach((item, index) => {
            item.url = item.userHeadimage;
            item.comment = item.star;
            item.name = item.userName;
            item.date = item.createTime;
          });
          _this.handleData(res.data, 2);
          this.commentListMiddle.totalPage = res.data.data.totalPage;
          this.commentListMiddle.isLoading = false;
          this.commentListMiddle.loading = false;

          if (res.data.data.totalPage <= res.data.data.pageNum) {
            this.commentListMiddle.finished = true;
          } else {
            this.commentListMiddle.pageNumber++;
          }
        })
        .catch(err => {});
    },
    //************************************* */ 中评数据end******************************
    //************************************* */ 差评数据start******************************
    getCommentListBad() {
      let param = {
        productId: this.id,
        pageSize: 10,
        pageNum: this.commentListBad.pageNumber,
        star: "bad"
      };
      let _this = this;
      productCommuntList(param)
        .then(res => {
          res.data.data.list.forEach((item, index) => {
            item.url = item.userHeadimage;
            item.comment = item.star;
            item.name = item.userName;
            item.date = item.createTime;
          });
          _this.handleData(res.data, 3);
          this.commentListBad.totalPage = res.data.data.totalPage;
          this.commentListBad.isLoading = false;
          this.commentListBad.loading = false;

          if (res.data.data.totalPage <= res.data.data.pageNum) {
            this.commentListBad.finished = true;
          } else {
            this.commentListBad.pageNumber++;
          }
        })
        .catch(err => {});
    },
    commentRefreshBad(index) {
      this.commentListBad.totalPage = 0;
      this.commentListBad.pageNumber = 1;
      this.initBad(); //加载数据
    },
    async initBad() {
      this.commentListBad.rows = [];
      let param = {
        productId: this.id,
        pageSize: 10,
        pageNum: 1,
        star: "bad"
      };
      let _this = this;
      productCommuntList(param)
        .then(res => {
          res.data.data.list.forEach((item, index) => {
            item.url = item.userHeadimage;
            item.comment = item.star;
            item.name = item.userName;
            item.date = item.createTime;
          });
          _this.handleData(res.data, 3);
          this.commentListBad.totalPage = res.data.data.totalPage;
          this.commentListBad.isLoading = false;
          this.commentListBad.loading = false;

          if (res.data.data.totalPage <= res.data.data.pageNum) {
            this.commentListBad.finished = true;
          } else {
            this.commentListBad.pageNumber++;
          }
        })
        .catch(err => {});
    },
    //************************************* */ 差评数据end******************************
    // *********************************下拉刷新，上拉加载公用******************************
    handleData(res, index) {
      let _this = this;
      res.data.list.forEach(function(item, ppp) {
        if (item.pics) item.pics = item.pics.split(",");
        if (index == 0) {
          _this.commentListAll.rows.push(item);
        } else if (index == 1) {
          _this.commentListGood.rows.push(item);
        } else if (index == 2) {
          _this.commentListMiddle.rows.push(item);
        } else if (index == 3) {
          _this.commentListBad.rows.push(item);
        }
      });
    }
    // *********************************下拉刷新，上拉加载公用end***************************
  },
  mounted() {
    let _this = this;
    var params = this.$f7route.params;
    if (params.id) {
      this.id = params.id;
      _this.getCommentListAll();
    }
  }
};
</script>

<style>
.my_item .item-subtitle {
  color: #999 !important;
  font-size: 14px !important;
  margin-top: 5px;
}
.my_detail .van-sticky {
  padding-left: 50px;
  background: #fff;
}
.my_refresh .van-pull-refresh__track {
  margin-top: -36px;
}
</style>