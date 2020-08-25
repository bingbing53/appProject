<template>
  <div>
    <div style="position:fixed;bottom:10px;right:10px;z-index:99999">
      <div class="to_top" v-if="btnFlag" @click="backTop">
        <van-icon name="arrow-up" />
      </div>
    </div>

    <van-tabs @change="clickItem" sticky v-model="active" style="z-index:99" color='#4374f2'>
      <van-tab v-for="(item,index) in dictionary.workHisType" :title="item.typename" :key="index">
        <div v-if="index == 0" class="text-c mt-10 mb-10" style="position:relative;z-index:2">
          <van-button @click="iCheck" type="info">我要记录</van-button>
        </div>
      </van-tab>
    </van-tabs>
    <div v-for="(item,index) in dictionary.workHisType" :title="item.typename" :key="index" style="z-index:0">
      <van-pull-refresh
        v-if="index ==active"
        v-model="resultList[index].isLoading"
        @refresh="onRefresh(index)"
      >
        <van-list
          :finished="resultList[index].finished"
          finished-text="没有更多了"
          :immediate-check="false"
          @load="getWorkHostoryList(index,item.typecode,false)"
        >
          <div v-for="(detail,pos) in resultList[index].rows" :key="pos" class="bgcw2 mb-10">
            <div class="bgcy"></div>
            <div class="pd-10">
              <van-row>
                <van-col span="5">
                  <div @click="showUserMineHis(detail.create_by,detail.realname)">
                    <img :src="detail.portrait" class="circleImage" />
                  </div>
                </van-col>
                <van-col span="19" class="f-16">
                  <span>{{detail.realname}}</span>&nbsp;
                  <van-tag class="v_top" plain medium type="primary">{{detail.typename}}</van-tag>&nbsp;
                  <!-- <span @click="showOrgListHis(detail.sys_org_code,detail.departname)" class="f-blue f-14"> {{detail.sys_org_code}}</span>  -->
                  <span
                    @click="showOrgListHis(detail.sys_org_code,detail.departname)"
                    class="f-blue f-14 v_top"
                  >{{detail.departname}}</span>
                  <div
                    v-if="index == 0"
                    @click="delMineWork(detail,pos,index)"
                    class="c-333 f-16 right mr-10 pr-10 f-blue"
                  >
                    <van-icon name="delete" color="#f44" custom-style="font-size:16px;" />
                  </div>
                  <div
                    v-if="index == 0"
                    @click="editMineWork(index,pos)"
                    class="c-333 f-16 right mr-10 pr-10 f-blue"
                  >
                    <van-icon name="edit" custom-style="font-size:16px;" />
                  </div>

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
                    @click="praiseSyns(index,pos)"
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
                    @click="nocollectSyns(index,pos)"
                  />
                  <img
                    v-if="detail.collected === '0'"
                    :src="linkerImg[3].noshoucang"
                    width="16vw"
                    height="16vw"
                    class="collect"
                    @click="collectSyns(index,pos)"
                  />
                  <span class="v_top ml-5">{{detail.collect}}</span>
                </van-col>
                <van-col span="8" class="text-c pt-5 pb-5 f-14">
                  <img
                    :src="linkerImg[2].liuyan"
                    width="16vw"
                    height="16vw"
                    class="praise"
                    @click="showHisDetail(detail.id)"
                  />
                  <span class="v_top ml-5">{{detail.comment}}</span>
                </van-col>
              </van-row>
            </div>
          </div>
        </van-list>
      </van-pull-refresh>
    </div>
  </div>
</template>
<script>
import work from "@/api/work/workhistory";
import { Dialog } from "vant";
import { setTimeout } from "timers";
import eventBus from "@/api/eventBus.js";

export default {
  data() {
    return {
      btnFlag: false,
      active: 0,
      dictionary: { workHisType: [] },
      resultList: [],
      showContent: 0,
      linkerImg: [
        { dianzan: require("@/assets/img/dianzan.png") },
        { nodianzan: require("@/assets/img/nodianzan.png") },
        { liuyan: require("@/assets/img/liuyan.png") },
        { noshoucang: require("@/assets/img/noshoucang.png") },
        { shoucang: require("@/assets/img/shoucang.png") }
      ],
      listType: -1 //记录点击的typecode
    };
  },
  methods: {
    //获取工作记录字典表数据
    async getDictionaryList(name) {
      let res = await work.getDictionary(name);
      res = JSON.parse(res);
      let _this = this;
      res.workHisType.forEach(function(item, index) {
        _this.dictionary.workHisType.push(item);
      });
      this.dictionary.workHisType.unshift({
        typename: "全部",
        typecode: "-999"
      });
      this.dictionary.workHisType.unshift({
        typename: "我的",
        typecode: "-998"
      });
      this.dictionary.workHisType.forEach(function(item, index) {
        _this.resultList.push({
          pageNumber: 1,
          totalPage: 0,
          loading: false,
          finished: false,
          isLoading: false,
          rows: []
        });
      });
    },
    //点击tab页
    clickItem(index, title) {
      this.resultList[index].pageNumber = 1;
      this.resultList[index].finished = false;
      this.getWorkHostoryList(
        index,
        this.dictionary.workHisType[index].typecode
      );
    },
    async init(index) {
      let res = await work.getWorkRecordList(
        this.dictionary.workHisType[index].typecode,
        1
      );
      res = JSON.parse(res);
      this.resultList[index].rows = [];
      this.handleData(res, index);
      this.resultList[index].totalPage = res.totalPage;
      this.resultList[index].isLoading = false; //关闭下拉刷新效果
      this.resultList[index].finished = false;
      if (res.totalPage <= res.currentPage) {
        this.resultList[index].finished = true;
      } else {
        this.resultList[index].pageNumber++;
      }
    },
    //下拉刷新
    onRefresh(index) {
      let _this = this;
      _this.resultList[index].totalPage = 0;
      _this.resultList[index].pageNumber = 1;
      _this.init(index); //加载数据
    },

    //获取工作记录详情列表
    async getWorkHostoryList(index, type) {
      let pageNumber = this.resultList[index].pageNumber;
      if (this.resultList[index].loading) {
        return;
      }
      this.resultList[index].loading = true;
      if (this.resultList[index].pageNumber == 1) {
        this.resultList[index].rows = [];
      }
      let res = await work.getWorkRecordList(type, pageNumber);
      res = JSON.parse(res);
      this.handleData(res, index);

      this.resultList[index].totalPage = res.totalPage;
      this.resultList[index].loading = false;

      if (res.totalPage <= res.currentPage) {
        this.resultList[index].finished = true;
      } else {
        this.resultList[index].pageNumber++;
      }
    },
    // *********************************下拉刷新，上拉加载公用******************************
    handleData(res, index) {
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
        _this.resultList[index].rows.push(item);
      });
    },
    // *********************************下拉刷新，上拉加载公用end***************************
    //点赞
    async praiseSyns(index, pos) {
      this.resultList[index].rows[pos].praised = "1";
      let id = this.resultList[index].rows[pos].id;
      let resPraise = await work.praiseSyns(id);
      this.resultList[index].rows[pos].praise += 1;
    },
    //收藏
    async collectSyns(index, pos) {
      this.resultList[index].rows[pos].collected = "1";
      let id = this.resultList[index].rows[pos].id;
      let resPraise = await work.collectSyns(id);
      this.resultList[index].rows[pos].collect += 1;
    },
    //取消收藏
    async nocollectSyns(index, pos) {
      this.resultList[index].rows[pos].collected = "0";
      let id = this.resultList[index].rows[pos].id;
      let resPraise = await work.collectSyns(id);
      this.resultList[index].rows[pos].collect -= 1;
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
    //我要记录
    iCheck() {
      this.$router.push({
        path: `/torecord`
      });
    },
    //查看我发的记录
    showUserMineHis(id, title) {
      this.$router.push({
        path: `/worksort`,
        query: {
          id: id,
          type: -997,
          code: 0
        }
      });
    },
    //查看部门发的记录
    showOrgListHis(id, title) {
      this.$router.push({
        path: `/worksort`,
        query: {
          id: id,
          type: -996,
          title: title,
          code: 1
        }
      });
    },
    //编辑我的工作
    editMineWork(index, pos) {
      let detail = this.resultList[index].rows[pos];
      detail = JSON.parse(JSON.stringify(detail));
      if (detail.image == null) {
        detail.image = [];
      }
      // console.log(JSON.stringify(detail))
      this.$router.push({
        path: `/torecord`,
        query: {
          data: detail
        }
      });
    },
    //删除我的工作记录

    delMineWork(detail, pos, index) {
      let _this = this;
      Dialog.confirm({
        message: "确认删除这条记录吗？"
      })
        .then(() => {
          _this.sureDel(detail.id, pos, index);
        })
        .catch(() => {});
    },
    async sureDel(id, pos, index) {
      let res = await work.delWorkHistory(id);
      // Dialog({ message: "删除成功" });
      this.resultList[index].rows.splice(pos, 1);
    },
    scrollToTop() {
      let that = this;
      let scrollTop =
        window.pageYOffset ||
        document.documentElement.scrollTop ||
        document.body.scrollTop;
      that.scrollTop = scrollTop;
      if (that.scrollTop > 60) {
        that.btnFlag = true;
      } else {
        that.btnFlag = false;
      }
    },
    backTop() {
      let scrolltop =
        document.documentElement.scrollTop || document.body.scrollTop;
      document.documentElement.scrollTop = document.body.scrollTop = 0;
    },
    async getCommList() {
      var _this = this;
      let res = await work.getCommList();
      res = JSON.parse(res);
      _this.commList = res;
    }
  },
  mounted() {
    this.getDictionaryList("workHisType");
    this.getCommList();

    let _this = this;
    setTimeout(function() {
      _this.getWorkHostoryList(0, "-998");
      window.addEventListener("scroll", _this.scrollToTop);
    }, 800);

    eventBus.$on(
      "choiceHospital",
      function(data) {
        // console.log(data);
        if (data == "success") {
          this.onRefresh(0);
        }
      }.bind(this)
    );
  },
  created() {
    if (this.$route.query.name) {
      //  alert(this.$route.query.name)
    }
  },
  activated() {
    //根据key名获取传递回来的参数，data就是map
    // console.log(123)
  },
  destroyed() {
    window.removeEventListener("scroll", this.scrollToTop);
  }
};
</script>
<style scoped>
.flex_box {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  flex-wrap: wrap;
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


