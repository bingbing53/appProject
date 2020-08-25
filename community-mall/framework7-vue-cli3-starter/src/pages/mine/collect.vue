<template>
  <f7-page class="order_List bgcg">
    <van-nav-bar class="myNavBare" title="我的收藏" left-arrow @click-left="$commonUtils.onClickLeft" />
    <div class="mine bgcw">
      <van-tabs v-model="tabActive" sticky @change="tabChange">
        <van-tab title="文章">
          <van-pull-refresh v-model="article.isLoading" @refresh="articleList(1)">
            <van-list
              v-model="article.isUpLoading"
              :finished="article.finished"
              finished-text="没有更多了"
              @load="articleList(0)"
            >
              <div v-for="item in article.records" class="borderScale pd-5">
                <van-row v-if="item.images.length == 3" @click="toArticleDetail(item.id)">
                  <van-col :span="24">
                    <p class="mb-10 pd-5 title2 pl-10">{{item.articleTitle}}</p>
                  </van-col>
                  <div class="pl-5 pr-5">
                    <van-col :span="8" class="tc pr-5">
                      <van-image
                        :src="formatImage(item.images[0])"
                        fit="cover"
                        alt
                        height="80px"
                        width="100%"
                      />
                    </van-col>
                    <van-col :span="8" class="tc pr-5">
                      <van-image
                        :src="formatImage(item.images[1])"
                        fit="cover"
                        alt
                        height="80px"
                        width="100%"
                      />
                    </van-col>
                    <van-col :span="8" class="tc">
                      <van-image
                        :src="formatImage(item.images[2])"
                        fit="cover"
                        alt
                        height="80px"
                        width="100%"
                      />
                    </van-col>
                  </div>
                  <van-col :span="24" class="f-12 pl-5 pr-5">
                    <span class="c-666 mr-10 ml-10">{{item.sysOrgCode_dictText}}</span>
                    <span class="c-666 mr-5">浏览数 {{item.hits}}</span>
                    <span class="c-666 mr-5">{{formatDate(item.createDate)}}</span>
                  </van-col>
                </van-row>
                <van-row v-else-if="item.images.length == 1" @click="toArticleDetail(item.id)">
                  <van-col :span="16">
                    <div class="my_box">
                      <p class="mt-10 title2 pl-10">{{item.articleTitle}}</p>
                      <div class="f-12 pl-10 pr-10">
                        <span class="c-666 mr-5">{{item.sysOrgCode_dictText}}</span>
                        <span class="c-666 mr-5">浏览数 {{item.hits}}</span>
                        <span class="c-666 mr-5">{{formatDate(item.createDate)
                          
                          }}</span>
                      </div>
                    </div>
                  </van-col>
                  <div class="pl-10">
                    <van-col :span="8" v-for="(image,pos) in item.images" class="tc pd-5">
                      <van-image :src="formatImage(image)" fit="cover" height="80px" width="100%" />
                    </van-col>
                  </div>
                </van-row>
                <van-row v-else-if="item.images.length == 0" @click="toArticleDetail(item.id)">
                  <van-col :span="24">
                    <div class="my_box">
                      <p class="mt-10 title2 pl-10">{{item.articleTitle}}</p>
                      <div class="f-12 pl-10 pr-10">
                        <span class="c-666 mr-5">{{item.sysOrgCode_dictText}}</span>
                        <span class="c-666 mr-5">浏览数 {{item.hits}}</span>
                        <span class="c-666 mr-5">{{formatDate(item.createDate)}}</span>
                      </div>
                    </div>
                  </van-col>
                </van-row>
                <van-row v-else @click="toVideo(item.id,item.images)">
                  <van-col :span="24">
                    <div class="relativePost">
                      <p class="mt-10 absolutePost">{{item.articleTitle}}</p>
                      <div class="absolutePost2">
                        <img src="@/assets/shipin.png" alt width="40px" />
                      </div>
                      <div class="pd-10">
                        <van-image
                          :src="formatImage(item.images.img,3)"
                          height="140px"
                          width="100%"
                          fit="cover"
                        />
                      </div>
                      <div class="f-12 pl-10 pr-10">
                        <span class="c-666 mr-5">{{item.sysOrgCode_dictText}}</span>
                        <span class="c-666 mr-5">浏览数 {{item.hits}}</span>
                        <span class="c-666 mr-5">{{formatDate(item.createDate)}}</span>
                      </div>
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
              <f7-row
                v-for="(detail,pos) in goods.records"
                :key="pos"
                class="mg-10 pd-10 bgcw border-radius4 borderScale"
                @click="toDetail(detail.id,detail.productCategoryCode)"
              >
                <f7-col width="60">
                  <h4 class="mb-10">{{detail.name}}</h4>
                  <div class="f-12 c-666">
                    <span>已卖出 {{detail.sale}}件</span> |
                    <span>好评: {{detail.goodReviewRatio}}%</span>
                  </div>
                  <div class="c-14 mt-10">
                    <p>
                      <span class="mr-10">
                        <i class="f-10 c-red">￥</i>
                        <b class="c-red f-18">{{detail.price}}</b>
                      </span>
                      <span>市场价</span>
                    </p>
                  </div>
                  <div class="c-14 mt-5">
                    <p>
                      <span class="c-red f-12 mr-10">￥{{detail.coinPrice}} + {{detail.coin}}公益币</span>
                      <span>公益价</span>
                    </p>
                  </div>
                </f7-col>
                <f7-col width="40">
                  <div>
                    <van-image
                      :src="formatImage(detail.pic)"
                      fit="cover"
                      alt
                      width="100%"
                      height="110px"
                    />
                  </div>
                </f7-col>
              </f7-row>
            </van-list>
          </van-pull-refresh>
        </van-tab>
      </van-tabs>
    </div>
  </f7-page>
</template>
<script>
import {
  articleCollectList,
  activityCollectList,
  goodsCollectList
} from "@/api/api_cms";
import Vue from "vue";
import { Skeleton } from "vant";
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
    this.$commonUtils.setTitle("我的收藏");
  },
  methods: {
    formatDate(date) {
      return this.$commonUtils.getTimeFormatText(date);
    },
    formatImage(url,size) {
      return this.$commonUtils.formatPicture(url,size);
    },
    toArticleDetail(id) {
      this.$f7router.navigate(`/cms/articleDetail/${id}/`);
    },
    toVideo(id, images) {
      images = JSON.stringify(images);
      wx.jumpPage({
        page: "videoPage",
        id: id,
        images: images
      });
    },
    toDetail(id, productCategoryCode) {
      productCategoryCode = productCategoryCode.substring(0, 3);
      if (productCategoryCode == "G02") {
        this.$f7router.navigate(`/goodsDetails/${id}/`);
      } else if (productCategoryCode == "G01") {
        this.$f7router.navigate(`/goodsDetail/${id}/`);
      }
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
      articleCollectList("collect", { pageNo: this.article.current + 1 })
        .then(res => {
          var result = res.data;
          result.records.forEach(function(item) {
            if (item.images && item.articleType == "0") {
              item.images = item.images.split(",");
            } else if (item.images && item.articleType == "1") {
              item.images = JSON.parse(item.images);
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
      goodsCollectList({ pageNo: this.goods.current + 1 })
        .then(res => {
          var result = res.data;
          result.records.forEach(function(item) {
            if (item.images) {
              item.images = item.images.split(",");
            }
            _this.goods.records.push(item);
          });

          this.goods.total = result.total;
          this.goods.pages = result.pages;
          this.goods.current = result.current;

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
.my_box {
  height: 90px;
  display: flex;
  flex-direction: column;
  /* align-items: center; */
  align-content: space-between;
  justify-content: space-between;
}

.relativePost {
  position: relative;
  z-index: 999999;
}
.absolutePost {
  position: absolute;
  top: 0px;
  right: 10px;
  left: 10px;
  height: 20px;
  padding: 5px 10px;
  color: #fff;
  background: rgba(0, 0, 0, 0.2);
  z-index: 999999;
}
.absolutePost2 {
  position: absolute;
  top: 50%;
  left: 50%;
  margin-top: -20px;
  margin-left: -20px;
  /* background-color:#eee; */
  /* color:#eee; */
  border-radius: 50%;
  z-index: 999999;
}
.title2 {
  text-overflow: -o-ellipsis-lastline;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
}
</style>