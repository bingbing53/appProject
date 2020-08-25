<template>
  <f7-page class="order_List">
    <van-nav-bar class="myNavBare" title="我的评论" left-arrow @click-left="$commonUtils.onClickLeft" />
    <div class="mine">
      <van-tabs v-model="tabActive" sticky @change="tabChange">
        <van-tab title="文章">
          <van-pull-refresh v-model="article.isLoading" @refresh="articleList(1)">
            <van-list
              v-model="article.isUpLoading"
              :finished="article.finished"
              finished-text="没有更多了"
              @load="articleList(0)"
            >
              <div v-for="(item,idx) in article.records" class="broder_b pd-5">
                <van-row class="pd-10">
                  <van-col :span="4">
                    <van-image round width="36" height="36" :src="item.head_path" class />
                  </van-col>
                  <van-col :span="20">
                    <van-icon
                      name="delete"
                      class="fr"
                      color="#ee0a24"
                      size="22"
                      @click="delArticleComment(item.id,idx)"
                    />
                    <p>{{item.name}}</p>
                    <p class="f-12 c-666 mt-5">{{substringDate(item.create_time)}}</p>
                  </van-col>
                  <van-col :span="24">
                    <p class="pl-5 pr-5 pt-5">{{item.review_content}}</p>
                  </van-col>
                  <van-col :span="24" @click="toArticleDetail(item.relationContent.id)">
                    <div class="bgcg pd-5 mt-10 border-radius3">
                      <van-row class="pd-10">
                        <van-col :span="4">
                          <img
                            :src="formatImage(item.relationContent.images[0])"
                            alt
                            width="40"
                            height="40"
                          />
                        </van-col>
                        <van-col :span="20" class="f-14 c-999">{{item.relationContent.articleTitle}}</van-col>
                      </van-row>
                    </div>
                  </van-col>
                </van-row>
              </div>
            </van-list>
          </van-pull-refresh>
        </van-tab>
        <van-tab title="商品">
          <van-pull-refresh v-model="goods.isLoading" @refresh="goodsList(1)">
            <van-list
              v-model="goods.isUpLoading"
              :finished="goods.finished"
              finished-text="没有更多了"
              @load="goodsList(0)"
            >
              <div v-for="(detail,pos) in goods.records" :key="pos" class="pd-5 broder_b">
                <van-row class="pd-10">
                  <van-col :span="4">
                    <van-image round width="36" height="36" :src="detail.userHeadimage" class />
                  </van-col>
                  <van-col :span="20">
                    <p>{{detail.userName}}</p>
                    <p class="f-12 c-666 mt-5">{{substringDate(detail.createTime)}}</p>
                  </van-col>
                  <van-col :span="24">
                    <p class="pl-5 pr-5 pt-5">{{detail.content}}</p>
                  </van-col>
                  <van-col
                    :span="24"
                    @click="toDetail(detail.pmsProduct.id,detail.pmsProduct.productCategoryCode)"
                  >
                    <div class="bgcg pd-5 mt-10 border-radius3" v-if="!!detail.pmsProduct">
                      <van-row class="pd-10">
                        <van-col :span="4">
                          <img :src="formatImage(detail.pmsProduct.pic)" alt width="40" height="40" />
                        </van-col>
                        <van-col :span="20" class="f-14 c-999">{{detail.pmsProduct.name}}</van-col>
                      </van-row>
                    </div>
                  </van-col>
                </van-row>
              </div>
            </van-list>
          </van-pull-refresh>
        </van-tab>
      </van-tabs>
    </div>
  </f7-page>
</template>
<script>
import {
  commentType,
  commentTypeGoods,
  articleDelComment
} from "@/api/api_cms";
import Vue from "vue";
import { Skeleton, Dialog } from "vant";
Vue.use(Skeleton);
export default {
  name: "collect",
  data() {
    return {
      tabActive: 0,
      article: {
        isLoading: false,
        isUpLoading: false,
        finished: false,
        total: -1,
        pages: 1,
        current: 0,
        records: []
      },
      goods: {
        isLoading: false,
        total: -1,
        pages: 1,
        current: 0,
        records: []
      }
    };
  },
  created() {
    //  this.articleList(0)
    // this.goodsList(0)
  },
  methods: {
    substringDate(time) {
      return time.substring(0, 19);
    },
    formatImage(url) {
      return this.$commonUtils.formatPicture(url);
    },
    toDetail(id, productCategoryCode) {
      if (productCategoryCode)
        productCategoryCode = productCategoryCode.substring(0, 3);
      if (productCategoryCode == "G02") {
        this.$f7router.navigate(`/goodsDetails/${id}/`);
      } else if (productCategoryCode == "G01") {
        this.$f7router.navigate(`/goodsDetail/${id}/`);
      }
    },
    //删除文章
    delArticleComment(id, idx) {
      let _this = this;
      Dialog.confirm({
        title: "确认删除该评论吗?"
      })
        .then(() => {
          // on confirm
          articleDelComment(id)
            .then(res => {
              // console.log(res);
              _this.article.records.splice(idx, 1);
            })
            .catch(err => {});
        })
        .catch(() => {
          // on cancel
        });
    },
    //点击去文章详情
    toArticleDetail(id) {
      // return;
      this.$f7router.navigate(`/cms/articleDetail/${id}/`);
    },
    tabChange() {},
    articleList(type) {
      let _this = this;
      if (type == 1) {
        this.article.total = 0;
        this.article.pages = 1;
        this.article.current = 0;
        this.article.records = [];
      }
      commentType("1", { pageNo: this.article.current + 1 })
        .then(res => {
          let result = res.data;
          result.records.forEach(function(item) {
            if (item.images) {
              item.images = item.images.split(",");
            }
            if (item.relationContent.images) {
              item.relationContent.images = item.relationContent.images.split(
                ","
              );
            }
            _this.article.records.push(item);
          });

          this.article.total = result.total;
          this.article.pages = result.pages;
          this.article.current = result.current;

          this.article.isLoading = false;
          this.article.isUpLoading = false;
          this.article.finished = false;

          if (this.article.current >= this.article.pages) {
            this.article.finished = true;
          }
        })
        .catch(err => {
          this.article.isLoading = false;
          this.article.isUpLoading = false;
          this.article.isUpLoading = false;
        });
    },
    goodsList(type) {
      let _this = this;
      if (type == 1) {
        this.goods.total = 0;
        this.goods.pages = 1;
        this.goods.current = 0;
        this.goods.records = [];
      }
      commentTypeGoods({ pageNo: this.goods.current + 1 })
        .then(res => {
          let result = res.data.data;
          result.list.forEach(function(item) {
            if (item.images) {
              item.images = item.images.split(",");
            }
            _this.goods.records.push(item);
          });

          this.goods.total = result.total;
          this.goods.pages = result.totalPage;
          this.goods.current = result.pageNum;

          this.goods.isLoading = false;
          this.goods.isUpLoading = false;
          this.goods.finished = false;

          if (this.goods.current >= this.goods.pages) {
            this.goods.finished = true;
          }
        })
        .catch(err => {
          this.goods.isLoading = false;
          this.goods.isUpLoading = false;
          this.goods.isUpLoading = false;
        });
    }
  }
};
</script>

<style scoped>


</style>