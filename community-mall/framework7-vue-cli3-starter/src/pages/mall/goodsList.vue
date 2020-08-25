<template>
  <f7-page class="goods">
    <van-row class="c-bgr">
      <van-col :span="2">
        <div class="c-bgr c-fff my_left tc" @click="$commonUtils.onClickLeft">
          <van-icon name="arrow-left" />
        </div>
      </van-col>
      <van-col :span="18">
        <van-search v-model="keyword" shape="round" background="#fd4346" placeholder="搜索商品" />
      </van-col>
      <van-col :span="4" style="background:#fd4346;color:#fff;height:54px;line-height:54px">
        <div class="tc" @click="onSearch">搜索</div>
      </van-col>
    </van-row>
    <div class="mine">
      <van-tabs v-model="active" @change="clickItem">
        <div class="dropdown_top">
          <van-dropdown-menu>
            <van-dropdown-item v-model="value" :options="option" @change="select_community" />
            <van-dropdown-item v-model="sortVal" :options="sortOption" @change="select_sort"></van-dropdown-item>
            <van-dropdown-item
              v-model="distanceVal"
              :options="distanceOption"
              @change="select_distance"
            ></van-dropdown-item>
          </van-dropdown-menu>
        </div>
        <van-tab :title="item.title" v-for="(item,index) in classifyList" :key="index">
          <van-pull-refresh
            v-model="resultList[index].isLoading"
            success-text="刷新成功"
            @refresh="onRefresh(index)"
          >
            <van-list
              :finished="resultList[index].finished"
              finished-text="没有更多了"
              :immediate-check="false"
              @load="getGoodsList(index)"
            >
              <f7-row
                v-for="(detail,pos) in resultList[index].rows"
                :key="pos"
                class="mg-10 pd-10 bgcw border-radius4"
                @click="toDetail(detail.id,detail.productAttributeCategoryId)"
              >
                <f7-col width="60">
                  <h4 class="mb-10">{{detail.name}}</h4>
                  <div class="f-12 c-666">
                    <span>已卖出 {{detail.sale}}件</span> |
                    <span v-if="detail.goodReviewRatio">好评: {{detail.goodReviewRatio}}%</span>
                    <span v-else>好评:100%</span>
                  </div>
                  <div v-if="detail.smsCouponValueList.length > 0">
                    <template v-for="(icon,sss) in detail.smsCouponValueList">
                      <van-tag
                        color="#fc7b69"
                        class="mr-5"
                        plain
                        v-if="$commonUtils.timeOVer(icon.smsCouponEndTime) != 0 "
                      >{{icon.smsCouponName}}</van-tag>
                    </template>
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
                  <div class="distanceDiv">
                    <van-image
                      :src="formatImage(detail.pic)"
                      alt
                      width="100%"
                      height="110px"
                      class="border-radius8"
                    />

                    <div
                      class="distanceInner"
                      v-if="$commonUtils.formatDistance(detail.distance) != '0米'"
                    >距您:{{$commonUtils.formatDistance(detail.distance)}}</div>
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
import { Toast } from "vant";
import { goodsList, goodsType } from "@/api/api_mall.js";
export default {
  data() {
    return {
      keyword: "",
      code: "",
      active: 0,
      classifyList: [],
      resultList: [],
      value: 0,
      sortVal: 0,
      distanceVal: 0,
      latitude: "",
      longitude: "",
      option: [
        { text: "所在街道", value: 0, label: "street" },
        { text: "本社区", value: 1, label: "community" }
      ],
      sortOption: [
        { text: "好评优先", value: 0, label: "star" },
        { text: "销量最高", value: 1, label: "sales" },
        { text: "价低优先", value: 2, label: "lowPrice" },
        { text: "价高优先", value: 3, label: "highPrice" }
      ],
      distanceOption: [
        { text: "距离", value: 0, label: "" },
        { text: "500m", value: 1, label: "0.5" },
        { text: "1km", value: 2, label: "1" },
        { text: "3km", value: 3, label: "3" },
        { text: "5km", value: 4, label: "5" },
        { text: "8km", value: 5, label: "8" },
        { text: "10km", value: 6, label: "10" }
      ],
      currentIdx: -1,
      categoryCode: ""
    };
  },
  methods: {
    //格式化图片路径
    formatImage(url) {
      return this.$commonUtils.formatPicture(url);
    },
    //距离
    select_distance(value) {
      this.geoLocation();
    },
    geoLocation() {
      let that = this;
      wx.geoLocation({
        success: function(result) {
          // Toast(result);
          let json = JSON.parse(result);
          that.latitude = json["latitude"];
          that.longitude = json["longitude"];
          that.getGoodsList(this.active);
        },
        error: function(err) {
          wx.toast(err);
        }
      });
    },
    //排序
    select_sort(value) {
      console.log(value);
      console.log(this.sortOption[value].label);
      this.getGoodsList(this.active);
    },
    //社区
    select_community(value) {
      this.getGoodsList(this.active);
    },
    // 获取商品导航菜单
    async goodsTypeList() {
      let _this = this;
      let res = await goodsType({ code: this.code });
      this.classifyList = res.data.data;
      this.categoryCode = this.classifyList[0].code;
      this.classifyList.forEach((item, index) => {
        _this.resultList.push({
          pageNumber: 1,
          totalPage: 0,
          loading: false,
          finished: false,
          isLoading: false,
          rows: []
        });
      });
      this.getGoodsList(0);
    },
    //点击tab页
    clickItem(index, title) {
      this.resultList[index].pageNumber = 1;
      this.resultList[index].finished = false;
      this.categoryCode = this.classifyList[index].code;
      this.getGoodsList(index);
    },
    async init(index) {
      let param = {
        keyword: this.keyword,
        categoryCode: this.classifyList[index].code,
        location: this.option[this.value].label,
        // location: this.option[1].label,
        distance: this.distanceOption[this.distanceVal].label,
        sort: this.sortOption[this.sortVal].label,
        latitude: this.latitude,
        longitude: this.longitude,
        pageNo: 1,
        pageSize: 5
      };
      // console.log(JSON.stringify(param))
      let res = await goodsList(param);
      this.resultList[index].rows = [];
      this.handleData(res, index);
      this.resultList[index].totalPage = res.data.totalPage;
      this.resultList[index].isLoading = false; //关闭下拉刷新效果
      this.resultList[index].finished = false;
      if (res.data.totalPage >= res.data.currentPage) {
        this.resultList[index].finished = true;
      } else {
        // this.resultList[index].pageNumber++;
      }
    },
    onRefresh(index) {
      let _this = this;
      _this.resultList[index].totalPage = 0;
      _this.resultList[index].pageNumber = 1;
      _this.init(index); //加载数据
    },
    //获取商品列表数据
    async getGoodsList(index) {
      console.log(this.resultList[index]);
      let pageNumber = this.resultList[index].pageNumber;
      if (this.resultList[index].loading) {
        return;
      }
      this.resultList[index].loading = true;
      if (this.resultList[index].pageNumber == 1) {
        this.resultList[index].rows = [];
      }
      let param = {
        keyword: this.keyword,
        categoryCode: this.classifyList[index].code,
        location: this.option[this.value].label,
        // location: this.option[1].label,
        distance: this.distanceOption[this.distanceVal].label,
        sort: this.sortOption[this.sortVal].label,
        latitude: this.latitude,
        longitude: this.longitude,
        pageNo: this.resultList[index].pageNumber,
        pageSize: 5
      };
      let res = await goodsList(param);
      // console.log(JSON.stringify(res));
      this.handleData(res, index);

      this.resultList[index].totalPage = res.data.data.totalPage;
      this.resultList[index].loading = false;

      if (res.data.data.totalPage >= res.data.data.pageNum) {
        this.resultList[index].finished = true;
      } else {
        this.resultList[index].pageNumber++;
      }
    },
    // *********************************下拉刷新，上拉加载公用******************************
    handleData(res, index) {
      let _this = this;
      res.data.data.list.forEach(function(item, ppp) {
        _this.resultList[index].rows.push(item);
      });
    },
    // *********************************下拉刷新，上拉加载公用end***************************
    onSearch() {
      this.getGoodsList(this.active);
    },
    toDetail(id) {
      this.$f7router.navigate(`/goodsDetail/${id}/`);
    },
    getUrlParam(name) {
      var reg = new RegExp("(^|\\?|&)" + name + "=([^&]*)(\\s|&|$)", "i");
      var r = window.location.href.substr(1).match(reg);
      var strValue = "";
      if (r != null) {
        strValue = unescape(r[2]);
      }
      this.code = strValue;
      // this.code = "G01A01";
      // this.code = "G01A03";
    }
  },
  mounted() {
    this.getUrlParam("code");
    this.goodsTypeList();
    this.geoLocation();
  }
};
</script>
<style scoped>
</style>
     