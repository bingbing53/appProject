<template>
  <div>
    <van-pull-refresh v-model="resultList.isLoading" @refresh="onRefresh">
      <van-list :finished="resultList.finished" finished-text="没有更多了" @load="getWorkHostoryList">
        
        <div v-for="(detail,pos) in resultList.rows" :key="pos" class="bgcw2 mb-10">
          <div class="bgcy pt-5"></div>
          <div class="pd-10">
            <div v-if="code === 0" v-wechat-title="'个人工作记录'"></div>
            <div v-if="code === 1" v-wechat-title="'社区工作记录'"></div>
            <van-row>
              <van-col span="5">
                <img :src="detail.portrait" class="circleImage" />
              </van-col>
              <van-col span="19" class="f-16">
                {{detail.realname}}
                <van-tag plain type="primary" class="v_top">{{detail.typename}}</van-tag>
                <!-- <span @click="showOrgListHis(detail.sys_org_code,detail.departname)" class="f-blue f-14"> {{detail.sys_org_code}}</span>  -->
                <span class="f-14 ml-5 v_top">{{detail.departname}}</span>
                <!-- <div v-if="index == 0" class="c-333 f-16 f-r mr-10">
                  <van-icon name="edit" custom-style="font-size:16px;" />
                </div>-->
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
                  <van-image v-if="imgItem" width="30.5vw" height="24vw" fit="cover" :src="imgItem" />
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
              <van-col span="8" class="text-c pt-5 pb-5 f-14">
                <img :src="linkerImg[2].liuyan" width="16vw" height="16vw" class="praise"  @click="showHisDetail(detail.id)" />
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
import { setTimeout } from 'timers';
export default {
  data() {
    return {
      code: -1,
      id: "",
      type: "",
      dictionary: {},
      commList:[],
      resultList: {
        rows: [],
        totalPage: 0,
        pageNumber: 1,
        loading: false, //控制上拉加载的加载动画
        finished: false, //控制在页面往下移动到底部时是否调用接口获取数据
        isLoading: false //控制下拉刷新的加载动画
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
    async init() {
      let pageNumber = this.resultList.pageNumber;
      let _this = this;
      let res = await work.getWorkRecordList(this.type, pageNumber, this.id);
      _this.resultList.rows = [];
      res = JSON.parse(res);
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
        if(item.portrait)
         item.portrait = _this.common.showPicture(item.portrait);
        _this.dictionary.workHisType.forEach(function(iii, ddd) {
          if (item.work_type === iii.typecode) {
            item.typename = iii.typename;
          }
        });
            if(_this.commList != null && _this.commList.length > 0){
            _this.commList.forEach(function(ooo,qqq){
                if(item.sys_org_code === ooo.org_code){
                  item.departname = ooo.departname;
                }
            });
          }
      });
      _this.resultList.rows = res.list;
      _this.resultList.totalPage = res.totalPage;
      _this.resultList.isLoading = false; //关闭下拉刷新效果
    },
    //下拉刷新
    onRefresh() {
      let _this = this;
      setTimeout(() => {
        _this.resultList.totalPage = 0;
        _this.resultList.pageNumber = 1;
        _this.init(); //加载数据
      }, 500);
    },
    //获取列表内容
    async getWorkHostoryList() {
      let pageNumber = this.resultList.pageNumber;
      if (this.resultList.loading) {
        return;
      }
      this.resultList.loading = true;

      let res = await work.getWorkRecordList(this.type, pageNumber, this.id);
      res = JSON.parse(res);
      // console.log(JSON.stringify("渲染列表：" + JSON.stringify(res)));
      let _this = this;
      setTimeout(function(){
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
        if(item.portrait)
         item.portrait = _this.common.showPicture(item.portrait);
        _this.dictionary.workHisType.forEach(function(iii, ddd) {
          if (item.work_type === iii.typecode) {
            item.typename = iii.typename;
          }
        });
          if(_this.commList != null && _this.commList.length > 0){
            _this.commList.forEach(function(ooo,qqq){
                if(item.sys_org_code === ooo.org_code){
                  item.departname = ooo.departname;
                }
            });
          }

        _this.resultList.rows.push(item);
      });
      _this.totalPage = res.totalPage;
      _this.resultList.loading = false;

      if (res.totalPage <= res.currentPage) {
        _this.resultList.finished = true;
      } else {
        _this.resultList.pageNumber++;
      }
      },300)
    },
    showHisDetail(id) {
      this.$router.push({
        path: `/hisDetail`,
        query: {
          id: id
        }
      });
    },
    //点赞
    async praiseSyns(pos) {
      this.resultList.rows[pos].praised = "1";
      let id = this.resultList.rows[pos].id;
      let resPraise = await work.praiseSyns(id);
      this.resultList.rows[pos].praise += 1;
    },
    //收藏
    async collectSyns(pos) {
      this.resultList.rows[pos].collected = "1";
      let id = this.resultList.rows[pos].id;
      let resPraise = await work.collectSyns(id);
      this.resultList.rows[pos].collect += 1;
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
    },
   async getCommList(){
      var _this = this;
      let res = await work.getCommList();
      res = JSON.parse(res);
        _this.commList = res;
     
    }
  },
  created() {
    this.getDictionary("workHisType");
    this.getCommList();
  
  },
  mounted() {
    //获取上个页面传来的参数
    this.id = this.$route.query.id;
    this.type = this.$route.query.type;
    this.code = this.$route.query.code;
    // console.log(this.id, this.type, this.title);
      
    
  },

};

</script>
<style scoped>
.flex_box {
  display: flex;
  justify-content: flex-start;
  align-items: center;
   flex-wrap:wrap;
}
.imgarr_content {
  margin-right: 0.53vw;
  margin-left: 0.53vw;
  margin-top: 0.53vw;
}
.bottom_comm img {
  vertical-align: inherit;
}
</style>


