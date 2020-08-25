<template>
  <div>
    <div class="pd-10 bgcw2">
      <van-row>
        <van-col span="4">
          <img :src="detail.portrait" class="circleImage" />
        </van-col>
        <van-col span="20">
          {{detail.realname}}
          <van-tag plain type="primary">{{detail.typename}}</van-tag>
          <br />
          <span class="c-666 f-12">{{detail.create_date}}</span>
        </van-col>
      </van-row>
    </div>
    <div class="pd-10 f-14 bgcw2">{{detail.content}}</div>
    <div class="pd-10 bgcw2">
      <ul class="flex_box" id="images">
        <van-image-preview v-model="show" :startPosition="startIdx" :images="detail.sourceimageArr"></van-image-preview>
        <li v-for="(imgItem,ppp) in detail.imageArr" :key="ppp" class="imgarr_content">
          <van-image
            :src="imgItem"
            width="30.5vw"
            height="24vw"
            fit="cover"
            @click="previewImg(ppp)"
          />
        </li>
      </ul>
    </div>
    <div class="c-999 f-12 pl-10 pr-10 pb-5 bgcw2">主题：{{detail.topic}}</div>
    <div class="pt-5 bgcy"></div>

    <!-- 评论列表 -->
    <div class="bgcw2">
      <h4 class="pd-10 f-b">
        <span class="blueLeftline mr-5">I</span>
        <span>评论</span>
      </h4>
    </div>
    <div class="Bline"></div>
    <div class="bgcw2">
      <!-- <van-pull-refresh v-model="judgeList.isLoading"> -->
      <van-list
        v-model="judgeList.loading"
        :finished="judgeList.finished"
        finished-text="没有更多了"
        @load="getJudgeList"
      >
        <van-row class="pd-10" v-for="(item,index) in judgeList.rows" :key="index">
          <van-col span="4" class="text-c">
            <img :src="item.portrait" class="circleImage" />
          </van-col>
          <van-col span="19">
            {{item.realname}}
            <br />
            <div class="c-333 pb-5 pt-5 f-14">{{item.content}}</div>
            <br />
            <span class="c-999 f-12">{{item.create_date}}</span>

            <div class="Bline mt-5 pb-5"></div>
          </van-col>
        </van-row>
      </van-list>
      <!-- </van-pull-refresh> -->
    </div>

    <div class="judge">
      <van-field
        maxlength="100"
        cursor-spacing="20"
        class="judgeInput"
        placeholder="请输入您的评论"
        v-model="judge"
      />
      <span @click="submitJudge" class="comm">提交</span>
    </div>
  </div>
</template>
<script>
import work from "@/api/work/workhistory";
import { setTimeout } from 'timers';
// import Viewer from 'viewerjs'
// import 'viewerjs/dist/viewer.css';
export default {
  data() {
    return {
      dictionary: {},
      id: "",
      show: false,
      index: 0,
      startIdx: 0,
      detail: "",
      judge: "",
      judgeList: {
        rows: [],
        isLoading: false,
        loading: false,
        finished: false,
        totalPage: 0,
        pageNumber: 1
      }
    };
  },
  methods: {
    //图片预览
    previewImg(index) {
      this.startIdx = index;
      this.show = true;
    },
    //获取详情
    async getworkDetail() {
      let res = await work.workIDdetail(this.id);
      res = JSON.parse(res);
      res.imageArr = [];
      res.sourceimageArr = [];
      if (!!res.image) {
        res.image = JSON.parse(res.image);
        let _this = this;
        res.image.forEach(function(img, p) {
          if (img.url) {
            res.imageArr.push(_this.common.showPicture(img.url));
            res.sourceimageArr.push(_this.common.showPicture(img.url,"",false))
          } else {
            res.imageArr.push(_this.common.showPicture(img));
            res.sourceimageArr.push(_this.common.showPicture(img,"",false))
          }
        });
      }
      if( res.portrait)
      res.portrait = this.common.showPicture(res.portrait);
      this.dictionary.workHisType.forEach(function(iii, ddd) {
        if (res.work_type === iii.typecode) {
          res.typename = iii.typename;
        }
      });
      this.detail = res;
    },
    //获取评论记录
    async getJudgeList() {
      let _this = this;
      let res = await work.workhistoryComment(
        this.id,
        this.judgeList.pageNumber
      );
      res = JSON.parse(res);
      res.list.forEach(function(item, index) {
        if(item.portrait)
        item.portrait = _this.common.showPicture(item.portrait);
        _this.judgeList.rows.push(item);
      });
      this.judgeList.totalPage = res.totalPage;
      this.judgeList.loading = false;
      if (res.totalPage <= res.currentPage) {
        this.judgeList.finished = true;
      } else {
        this.judgeList.pageNumber++;
      }
    },
    //提交评论
    async submitJudge() {
      let _this = this;
      let resjudge = await work.submitJudge(this.id, this.judge);
      _this.judge = "";

      _this.judgeList.pageNo = 1;
      _this.judgeList.rows = [];
      _this.judgeList.hasMore = true;
      _this.getJudgeList();
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
     this.getDictionary("workHisType");
    this.id = this.$route.query.id;
    let _this = this;
    setTimeout(function(){
      _this.getworkDetail();
    },500)
  },
 
};
</script>
<style scoped>
.flex_box {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  flex-wrap: wrap;
  width: 100%;
}
.imgarr_content {
  display: inline-block;
  margin-right: 0.53vw;
  margin-left: 0.53vw;
  margin-bottom: 0.53vw;
}
.judge {
  position: fixed;
  /*bottom: 245px;*/
  bottom: 0px;
  left: 0px;
  right: 0px;
  background: #fff;
  height: 90px;
  padding-top: 10px;
  padding-bottom: 10px;
  padding-left:10px
}
.judgeInput {
  border: none;
  outline: none;
  border: solid 1px #ddd;
  border-radius: 10px;
  padding: 5px;
  float: left;
  width: 79%;
  height: 70px;
  line-height: 70px;
}

.comm {
  display: inline-block;
  background-color: dodgerblue;
  color: #fff;
  width: 19%;
  height: 70px;
  line-height: 70px;
  text-align: center;
  float: right;
  border-radius: 3px;
  margin-right: 10px;
  margin-bottom: 20px;
}
</style>


