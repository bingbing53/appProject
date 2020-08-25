<template>
  <f7-page
    bg-color="white"
    infinite
    :infinite-distance="50"
    :infinite-preloader="showPreloader"
    @infinite="getComment"
  >
    <f7-block class="pageContent">
      <f7-list v-if="loading" :class="`skeleton-text skeleton-effect-blink`">
        <f7-block>
          <p v-for="n in 3">
            Donec iaculis posuere
            <br />massa p v dignissim.
            <br />Praesent id nibh nec massa mollis egestas. Pellentesque
            <br />habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas...
          </p>
          <f7-skeleton-block style="width: 40px; height: 40px; border-radius: 50%" slot="media"></f7-skeleton-block>
        </f7-block>
      </f7-list>

      <div class="rich_media_title">{{article.articleTitle }}</div>
      <article-user :article="article"></article-user>
      <div v-if="article.articleType == 1" class="rich_des">{{article.des}}</div>
      <van-image-preview
        v-model="showImageDetail"
        startPosition="0"
        :images="perimageArrDetail"
        :showIndex="false"
      ></van-image-preview>
      <div
        v-html="article.content"
        class="rich"
        v-if="article.articleType == 0"
        @click="imageShow($event)"
      ></div>
      <div class="fr f-14 c-999 pt-10" v-if="!!article">阅读数 {{article.hits || 1}}</div>
    </f7-block>

    <div v-if="recommendList.length > 0">
      <div class="line pt-5"></div>
      <van-cell-group title="文章推荐">
        <van-cell v-for="item in recommendList" @click="jumpArticle(item.id)">
          <template v-if="!!item.image">
            <div class="fl" style="width:66%">{{item.article_title}}</div>
            <div v-if="!!item.image" class="fl" style="width:33%;height: 100px;">
              <img :src="item.image" width="100%" />
            </div>
            <div class="clear"></div>
          </template>
          <template v-else>
            <div style="height: 50px;">{{item.article_title}}</div>
          </template>
        </van-cell>
      </van-cell-group>
    </div>

    <div class="line pt-5"></div>
    <van-cell-group title="文章评论">
      <van-cell v-for="item in comments.records">
        <div style="width:100%; height:40px;">
          <div
            style="width: 35px; height: 35px; float:left; border-radius: 50%; overflow: hidden;margin-top: 3px;"
          >
            <img :src="item.head_path" width="35" height="35" />
          </div>
          <div class="fl ml-10">
            <span>{{item.name}}</span>
            <br />
            <span class="mt-5 c-999" style="font-size: 13px;">{{item.create_time}}</span>
          </div>
        </div>
        <div class="pt-10 f-14">{{item.review_content}}</div>
      </van-cell>
    </van-cell-group>
    <div style="height: 60px"></div>

    <f7-toolbar position="bottom" style="height: 50px;background: #fff">
      <f7-row style="width: 100%;" class="text-c pt-5">
        <f7-col width="25" @click="judgeArticle">
          <div class="c-666 f-16">
            <i class="iconfont icon-pinglun"></i>
          </div>
          <div>
            <span class="c-666 f-12 pt-5">评论 {{article.comment}}</span>
          </div>
        </f7-col>
        <f7-col width="25">
          <div class="c-666 f-14">
            <i
              class="iconfont icon-like-b"
              v-if="behaviour.praise == 0"
              @click="praise(1,article.id,0)"
            ></i>
            <i
              class="iconfont icon-like-b c-red"
              v-if="behaviour.praise == 1"
              @click="praise(0,article.id,0)"
            ></i>
          </div>
          <div class="c-666 f-12 pt-5">点赞 {{article.praise}}</div>
        </f7-col>
        <f7-col width="25" @click="collect(behaviour.collect == 0 ? 1:0)">
          <div class="c-666 f-14">
            <i class="iconfont icon-guanzhu" v-if="behaviour.collect == 0"></i>
            <i class="iconfont icon-guanzhu c-red" v-if="behaviour.collect == 1"></i>
          </div>
          <div class="c-666 f-12 pt-5">收藏 {{article.collect}}</div>
        </f7-col>
        <f7-col width="25" @click="toShare(0)">
          <img src="@/assets/share.png" width="19px" class="v_top" style="margin-top:2px" />
          <div class="c-666 f-12 pt-5">分享</div>
        </f7-col>
      </f7-row>
    </f7-toolbar>

    <van-action-sheet v-model="commentSheetOpen">
      <van-cell-group title="评论文章">
        <van-field
          v-model="contentStr"
          rows="5"
          autosize
          type="textarea"
          maxlength="255"
          placeholder="请输入您的精彩点评，不超过255个字符"
          show-word-limit
        />
        <van-cell>
          <van-button type="danger" :disabled="contentStr.length <= 0" @click="submitComment">提交评论</van-button>
        </van-cell>
      </van-cell-group>
      <div style="height: 60px;"></div>
    </van-action-sheet>
  </f7-page>
</template>

<script>
import Vue from "vue";
import { articleDetail, articleRecommend } from "@/api/api_cms";
import {
  getComment,
  getCommentSecond,
  addBrowse,
  addPraise,
  delPraise,
  isPraised,
  isFocused,
  addFocus,
  delFocus,
  addComment
} from "@/api/api_common";
import ArticleUser from "./articleUser";
import { ActionSheet } from "vant";
Vue.use(ActionSheet);
export default {
  components: { ArticleUser },
  data() {
    return {
      loading: true,
      article: {
        poster: ""
      },
      showPreloader: false,
      allowInfinite: true,
      behaviour: {
        collect: 0,
        praise: 0
      },
      //评论列表
      comments: {
        total: 0,
        pages: 1,
        current: 0,
        records: []
      },
      contentStr: "",
      commentSheetOpen: false,
      recommendList: [],
      showImageDetail: false,
      perimageArrDetail: []
    };
  },
  created() {
    this.$commonUtils.setTitle("文章详情");
    let articleId;
    // let articleId = this.$commonUtils.getUrlKey("id");
    let params = this.$f7route.params;
    if (params.id) {
      articleId = params.id;
    }
    this.getDetail(articleId);

    this.loadBrowse(articleId);

    this.isPraised(articleId);
    this.isFocused(articleId);

    this.getRecommend(articleId);
  },
  mounted() {},
  methods: {
    //格式化图片路径
    formatImage(url) {
      return this.$commonUtils.formatPicture(url);
    },
    toShare() {
      let image_share = "";
      let content = "";

      if (this.article.articleType == "0") {
        if (this.article.images) {
          image_share = this.article.images.split(",");
          image_share = this.formatImage(image_share[0]);
        } else {
          image_share = "";
        }
        content = this.article.content;
        content = content.replace(/<[^>]*>|/g, "");
        content = content.replace(/&nbsp;/g, "");
        content = content.substring(0, 1000);
      } else if (this.article.articleType == "1") {
        if (this.article.images) {
          image_share = JSON.parse(this.article.images).img;
          image_share = this.formatImage(image_share);
        } else {
          image_share = "";
        }
        content = this.article.articleDes;
      }
      wx.share({
        picture: image_share,
        title: this.article.articleTitle,
        des: content
      });
    },
    imageShow(e) {
      this.perimageArrDetail = [];
      if (e.target.nodeName == "IMG") {
        this.showImageDetail = true;
        this.perimageArrDetail.push(e.target.currentSrc);
      } else {
        return;
      }
    },
    judgeArticle() {
      if (!!this.article.allowComment && this.article.allowComment == "1") {
        this.commentSheetOpen = !this.commentSheetOpen;
      } else {
        wx.toast("文章不允许评论");
      }
    },
    jumpArticle(id) {
      // window.location.replace('/#/cms/articleDetail?id='+id);
      this.$f7router.updateCurrentUrl(`/cms/articleDetail/${id}/`);
      window.location.reload(1);
    },
    //获取推荐信息
    getRecommend(articleId) {
      let that = this;
      articleRecommend(articleId)
        .then(res => {
          var result = res.data;
          result.forEach(function(item) {
            if (!!item._source) {
              var article = item._source;
              var images = article.images.split(",");
              if (!!images) {
                article.image = that.$commonUtils.formatPicture(images[0]);
              }
              that.recommendList.push(article);
            }
          });
        })
        .catch(err => {});
    },
    //获取一级评论
    getComment() {
      if (!this.allowInfinite) return;
      if (this.comments.pages <= this.comments.current) return;
      this.allowInfinite = false;
      getComment("1", this.article.id)
        .then(res => {
          this.allowInfinite = true;
          this.comments = res.data;
        })
        .catch(err => {
          this.allowInfinite = true;
        });
    },
    //提交评论
    submitComment() {
      wx.loading("提交中");
      addComment("1", this.article.id, { content: this.contentStr })
        .then(res => {
          this.commentSheetOpen = false;
          this.contentStr = "";
          this.article.comment++;

          (this.comments = {
            total: 0,
            pages: 1,
            current: 0,
            records: []
          }),
            this.getComment();
          wx.closeLoading();
          wx.toast("评论成功");
        })
        .catch(err => {
          wx.closeLoading();
          wx.toast("评论失败，请稍后重试");
        });
    },
    isFocused(articleId) {
      isFocused("1", articleId).then(res => {
        var data = res.data;
        this.behaviour.collect = data["collect"];
      });
    },
    collect(type) {
      this.behaviour.collect = type;
      if (type == 0) {
        delFocus("1", this.article.id);
        this.article.collect--;
      } else if (type == 1) {
        addFocus("1", this.article.id);
        this.article.collect++;
      }
    },
    isPraised(articleId) {
      isPraised("1", articleId).then(res => {
        var data = res.data;
        this.behaviour.praise = data["praise"];
      });
    },
    praise(type, id, second) {
      this.behaviour.praise = type;
      if (type == 0) {
        delPraise("1", id, second);
        this.article.praise--;
      } else if (type == 1) {
        addPraise("1", id, second);
        this.article.praise++;
      }
    },
    loadBrowse(articleId) {
      addBrowse("1", articleId);
    },
    getDetail(articleId) {
      articleDetail(articleId)
        .then(res => {
          this.article = res.data;
          if (
            !!this.article.content &&
            this.article.content != null &&
            this.article.content != "null"
          ) {
            this.article.content = this.article.content.replace(
              new RegExp(/(url\("http)/g),
              "url(&quot;https://image.shequyijia.cn/xinyi/net/2018?src=http"
            );
            this.article.content = this.article.content.replace(
              new RegExp(/(url\(http)/g),
              "url(https://image.shequyijia.cn/xinyi/net/2018?src=http"
            );
            this.article.content = this.article.content.replace(
              new RegExp(/(url\(&quot;http)/g),
              "url(&quot;https://image.shequyijia.cn/xinyi/net/2018?src=http"
            );

            this.article.content = this.article.content.replace(
              /<img [^>]*src=['"]([^'"]+)[^>]*>/gi,
              function(match, capture) {
                return match.replace(
                  new RegExp(/(src="http)/g),
                  'src="https://image.shequyijia.cn/xinyi/net/2018?src=http'
                );
              }
            );

            this.article.content = this.article.content.replace(
              /<img [^>]*title=['"]([^'"]+)[^>]*>/gi,
              function(match, capture) {
                return match.replace(
                  new RegExp(/(title="[a-z0-9A-z\.]*")/g),
                  " "
                );
              }
            );
          }
          this.loading = false;
          this.$commonUtils.setTitle(this.article.title);

          if (this.article.articleType == 1 && !!this.article.images) {
            var json = JSON.parse(this.article.images);
            this.article.poster = this.$commonUtils.formatPicture(json["img"]);
            this.article.video = this.$commonUtils.formatPicture(json["video"]);
          }

          this.getComment();
        })
        .catch(err => {
          console.log(err);
        });
    }
  }
};
</script>
<style scoped>
.pageContent {
  width: 100% !important;
  overflow-x: hidden !important;
}
.rich_media_title {
  /*padding-top: 20px;*/
  padding-bottom: 20px;
  font-size: 22px;
  text-indent: 0px !important;
  line-height: 32px !important;
}

.rich_des {
  font-size: 17px !important;
  line-height: 32px !important;
  text-indent: 0px !important;
  letter-spacing: 2px !important;
  overflow-y: hidden;
}

.rich >>> p {
  font-size: 17px !important;
  line-height: 32px !important;
  text-indent: 0px !important;
  letter-spacing: 2px !important;
  overflow-y: hidden;
}

.rich >>> img {
  width: auto !important;
  height: auto!important;
  max-width: 100%;
  display: block;
}
.rich >>> section,
p {
  max-width: 100% !important;
  text-indent: 0px !important;
}
.rich >>> p img {
  /*display:block;*/
  /*width:100%;*/
  max-width: 100% !important;
  height: auto !important;
  margin-left: 0px !important;
  margin-right: 0px !important;
  padding-left: 0px !important;
  padding-right: 0px !important;
}
.rich >>> .rich_media_title {
  margin-bottom: 10px;
  line-height: 1.4;
  font-weight: 400;
  font-size: 24px;
}
.rich >>> .judgeFix {
  position: fixed !important;
  bottom: 0px;
  width: 100%;
  height: 45px;
  z-index: 10;
  background: #fff;
  border-top: solid 1px #eee;
}
.rich >>> .judge {
  border-top: solid 1px #eee;
  position: fixed;
  bottom: 45px;
  width: 100%;
  height: 120px;
  z-index: 10;
  background: #fff;
  padding-top: 10px;
}
.rich >>> .col-33 {
  height: 45px;
  padding-top: 10px;
}
.rich >>> textarea {
  border: solid 1px #eee !important;
  border-radius: 5px;
  width: 94% !important;
  margin-left: 3%;
  height: 70px;
  background: rgba(221, 221, 221, 0.2);
  padding: 2px;
}
.rich >>> .self {
  color: #007aff;
  font-size: 9px;
  margin-right: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-radius: 3px;
  border: solid 1px #007aff;
}
.rich >>> .flex-box-img { 
  flex: 0 0 100px;
  width: 100px;
  height: 100px;
  overflow: hidden;
}
.rich >>> .flex-box-content {
  flex: 1;
  overflow: hidden;
  padding-bottom: 5px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-width: 0;
  margin-right: 3px;
}
.rich >>> .dotdot {
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  display: box;
  -webkit-box-orient: vertical;
  font-size: 16px;
}
.rich >>> .hot {
  color: #ff3b30;
  font-size: 9px;
  margin-right: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-radius: 3px;
  border: solid 1px #ff3b30;
}
.rich >>> .single {
  background: #fff;
  border-bottom: 1px solid rgba(221, 221, 221, 0.6);
  display: flex;
  margin-left: 10px;
  margin-right: 10px;
  padding-bottom: 10px;
  padding-top: 10px;
}
.rich >>> .single span {
  font-size: 12px;
  color: #666;
}
.rich >>> ul {
  margin: 10px;
  padding-left: 10px !important;
}
</style>