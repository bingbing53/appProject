<template>
  <div>
    <van-pull-refresh v-model="collectList.isLoading" @refresh="onRefresh">
      <van-list v-model="collectList.loading" :finished="collectList.finished" finished-text="没有更多了" @load="getMyCollect">
        <div v-for="(detail,pos) in collectList.rows" :key="pos" class="bgcw2 mb-10">
          <div class="bgcy pt-5"></div>
          <div class="pd-10">
            <van-row>
              <van-col span="5">
                <img v-if="detail.portrait" :src="detail.portrait" class="circleImage" />
              </van-col>
              <van-col span="19" class="f-16">
                {{detail.realname}}
                <van-tag plain type="primary" class="v_top">{{detail.typename}}</van-tag>
                <span class="f-14 ml-5 v_top">{{detail.departname}}</span>
                <br />
                <p class="c-666 f-12 mt-10">{{detail.create_date}}</p>
              </van-col>
            </van-row>
          </div>
          <div @click="showHisDetail(detail.id)">
            <div class="pd-10 f-14">{{detail.content}}</div>
            <div class="pd-10">
              <ul class="flex_box">
                <li v-for="(imgItem,ppp) in detail.imageArr" :key="ppp" class="imgarr_content">
                  <van-image
                    v-if="imgItem"
                    width="30.5vw"
                    height="24vw"
                    fit="cover"
                    :src="imgItem"
                  />
                </li>
              </ul>
            </div>
            <div class="c-999 f-12 pl-10 pr-10 pb-10 Bline">主题：{{detail.topic}}</div>
          </div>
          <div class="bottom_comm mt-5">
            <van-row>
              <van-col span="8" class="text-c pt-5 pb-5 f-14">
                <img
                  v-if="detail.praised === '1'"
                  :src="linkerImg[0].dianzan"
                  width="16vw"
                  height="16vw"
                  class="praise"
                />
                <img
                  v-else
                  :src="linkerImg[1].nodianzan"
                  width="16vw"
                  height="16vw"
                  class="praise"
                  @click="praiseSyns(pos)"
                />
                <span class="v_top ml-5">{{detail.praise}}</span>
              </van-col>
              <van-col span="8" class="text-c pt-5 pb-5 f-14">
                <img
                  v-if="detail.collected === '1'"
                  :src="linkerImg[4].shoucang"
                  width="16vw"
                  height="16vw"
                  class="collect"
                 @click="nocollectSyns(pos)"
                />
                <img
                  v-else
                  :src="linkerImg[3].noshoucang"
                  width="16vw"
                  height="16vw"
                  class="collect"
                  @click="collectSyns(pos)"
                />
                <span class="v_top ml-5">{{detail.collect}}</span>
              </van-col>
              <van-col span="8" class="text-c pt-5 pb-5 f-14" @click="showHisDetail(detail.id)">
                <img :src="linkerImg[2].liuyan" width="16vw" height="16vw" class="praise" />
                <span class="v_top ml-5">{{detail.comment}}</span>
              </van-col>
            </van-row>
          </div>
        </div>
      </van-list>
    </van-pull-refresh>
  </div>
</template>
<script>
import work from "@/api/work/workhistory";
export default {
  data() {
    return {
      dictionary: {},
      commList: [],
      collectList: {
        rows: [],
        isLoading: false,
        loading: false,
        finished: false,
        totalPage: 0,
        pageNumber: 1
      },
      linkerImg: [
        { dianzan: require("@/assets/img/dianzan.png") },
        { nodianzan: require("@/assets/img/nodianzan.png") },
        { liuyan: require("@/assets/img/liuyan.png") },
        { noshoucang: require("@/assets/img/noshoucang.png") },
        { shoucang: require("@/assets/img/shoucang.png") }
      ]
    };
  },
  methods: {
    onRefresh() {
      this.collectList.totalPage = 0;
      this.collectList.pageNumber = 1;
      this.init(); //加载数据
    },
    async init() {
      let res = await work.getCollect(this.collectList.pageNumber);
      this.collectList.rows = [];
      res = JSON.parse(res);
      this.handleData(res);
      this.collectList.totalPage = res.totalPage;
      this.collectList.isLoading = false; //关闭下拉刷新效果
      this.collectList.finished = false;
      if (res.totalPage <= res.currentPage) {
        this.collectList.finished = true;
      } else {
        this.collectList.pageNumber++;
      }
    },
    async getMyCollect() {
      let pageNumber = this.collectList.pageNumber;
      let res = await work.getCollect(pageNumber);
      res = JSON.parse(res);
      this.handleData(res);

      this.collectList.totalPage = res.totalPage;
      this.collectList.loading = false;
      if (res.totalPage <= res.currentPage) {
        this.collectList.finished = true;
      } else {
        this.collectList.pageNumber++;
      }
    },
    handleData(res) {
      let _this = this;
      res.list.forEach(function(item, ppp) {
        if (!!item.content)
          item.newContent = item.content.replace(/\n/g, "<br/>");
        item.imageArr = [];
        if (!!item.image) {
          item.image = JSON.parse(item.image);
          item.image.forEach(function(img, p) {
            if (img.url) {
              item.imageArr.push(_this.common.showPicture(img.url));
            } else {
              item.imageArr.push(_this.common.showPicture(img));
            }
          });
        }
        if (item.portrait) {
          item.portrait = _this.common.showPicture(item.portrait);
        }
        _this.dictionary.workHisType.forEach(function(iii, ddd) {
          if (item.work_type === iii.typecode) {
            item.typename = iii.typename;
          }
        });
        if (_this.commList != null && _this.commList.length > 0) {
          _this.commList.forEach(function(ooo, qqq) {
            if (item.sys_org_code === ooo.org_code) {
              item.departname = ooo.departname;
            }
          });
        }
        _this.collectList.rows.push(item);
      });
    },
        //点赞
    async praiseSyns(pos) {
      this.collectList.rows[pos].praised = "1";
      let id = this.collectList.rows[pos].id;
      let resPraise = await work.praiseSyns(id);
      this.collectList.rows[pos].praise += 1;
    },
    //收藏
    async collectSyns(pos) {
      this.collectList.rows[pos].collected = "1";
      let id = this.collectList.rows[pos].id;
      let resPraise = await work.collectSyns(id);
      this.collectList.rows[pos].collect += 1;
    },
    //取消收藏
     async nocollectSyns(pos) {
      this.collectList.rows[pos].collected = "0";
      let id = this.collectList.rows[pos].id;
      let resPraise = await work.collectSyns(id);
      this.collectList.rows[pos].collect -= 1;
       this.collectList.rows.splice(pos,1);
    },
     //跳转记录详情页面
    showHisDetail(id) {
      this.$router.push({
        path: `/hisDetail`,
        query: {
          id: id
        }
      });
    },
    //获取字典表的内容
    async getDictionary(name) {
      var _this = this;
      let res = await work.getDictionary(name);
      res = JSON.parse(res);
      this.dictionary.workHisType = [];
      res.workHisType.forEach(function(item, index) {
        _this.dictionary.workHisType.push(item);
      });
    }
  },
  mounted() {
    // this.getMyCollect();
  },
  created() {
    this.getDictionary("workHisType");
  }
};
</script>
<style scoped>
.flex_box {
  display: flex;
  justify-content: flex-start;
  align-items: center;
}
.imgarr_content {
  margin-right: 0.53vw;
  margin-left: 0.53vw;
}
.bottom_comm img {
  vertical-align: inherit;
}
</style>

