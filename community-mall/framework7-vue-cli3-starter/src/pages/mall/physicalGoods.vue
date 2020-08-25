<template>
  <f7-page class="goods2 bgcg">
    <div>
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
      <div class="dropdown_top">
        <van-dropdown-menu>
          <van-dropdown-item v-model="value" :options="option" @change="select_community" />
          <van-dropdown-item v-model="sortVal" :options="sortOption" @change="select_sort"></van-dropdown-item>
        </van-dropdown-menu>
      </div>
      <van-pull-refresh v-model="resultList.isLoading" success-text="刷新成功" @refresh="onRefresh">
        <van-list
          v-model="resultList.loading"
          :finished="resultList.finished"
          finished-text="没有更多了"
          @load="getphysicalGoods"
        >
          <f7-row
            v-for="(detail,pos) in resultList.rows"
            :key="pos"
            class="mg-10 pd-10 bgcw border-radius4"
            @click="toDetail(detail.id,detail.productAttributeCategoryId)"
          >
            <f7-col width="60">
              <h4 class="mb-10">
                <span class="v_middle">{{detail.name}}</span>
              </h4>
              <div class="f-12 c-666">
                <span>已卖出 {{detail.sale}}件</span> |
                <span v-if="detail.goodReviewRatio">好评: {{detail.goodReviewRatio}}%</span>
                <span v-else>好评: 100%</span>
              </div>
              <div v-if="detail.smsCouponValueList.length > 0">
                <van-tag
                  color="#fc7b69"
                  class="mr-5"
                  plain
                  v-for="(icon,sss) in detail.smsCouponValueList"
                  v-if="$commonUtils.timeOVer(icon.smsCouponEndTime) != 0"
                >
                  <template>{{icon.smsCouponName}}</template>
                </van-tag>
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
              <div class="c-14">
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
                  alt
                  width="100%"
                  height="110px"
                  class="border-radius8"
                />
              </div>
            </f7-col>
          </f7-row>
        </van-list>
      </van-pull-refresh>
    </div>
  </f7-page>
</template>
<script>
import quan from "@/assets/quan.png";
import { goodsList, goodsType } from "@/api/api_mall.js";
export default {
  data() {
    return {
      keyword: "",
      categoryCode: "",
      value: 0,
      sortVal: 0,
      distanceVal: 0,
      resultList: {
        pageNumber: 1,
        totalPage: 0,
        loading: false,
        finished: false,
        isLoading: false,
        rows: []
      },
      option: [
        { text: "所在街道", value: 0, label: "street" },
        { text: "本社区", value: 1, label: "community" }
      ],
      sortOption: [
        { text: "好评优先", value: 0, label: "star" },
        { text: "销量最高", value: 1, label: "sales" },
        { text: "价低优先", value: 2, label: "lowPrice" },
        { text: "价高优先", value: 3, label: "highPrice" }
      ]
    };
  },
  methods: {
    //格式化图片路径
    formatImage(url) {
      return this.$commonUtils.formatPicture(url);
    },
    //排序
    select_sort(value) {
      this.resultList.rows = [];
      this.getphysicalGoods();
    },
    //社区
    select_community(value) {
      this.resultList.rows = [];
      this.getphysicalGoods();
    },
    //获取实体商品列表
    getphysicalGoods() {
      let pageIndex = this.resultList.pageNumber;
      let param = {
        categoryCode: this.categoryCode,
        location: this.option[this.value].label,
        sort: this.sortOption[this.sortVal].label,
        pageSize: 5,
        keyword: this.keyword,
        pageNo: pageIndex
      };
      goodsList(param)
        .then(res => {
          this.handleData(res);
          this.resultList.totalPage = res.data.data.totalPage;
          this.resultList.loading = false;

          if (res.data.data.totalPage >= res.data.data.pageNum) {
            this.resultList.finished = true;
          } else {
            this.resultList.pageNumber++;
          }
        })
        .catch(err => {});
    },
    onRefresh() {
      let _this = this;
      _this.resultList.totalPage = 0;
      _this.resultList.pageNumber = 1;
      _this.init(); //加载数据
    },
    async init() {
      let param = {
        categoryCode: this.categoryCode,
        location: this.option[this.value].label,
        sort: this.sortOption[this.sortVal].label,
        pageSize: 5,
        keyword: this.keyword,
        pageNo: this.resultList.pageNumber
      };
      let res = await goodsList(param);
      this.resultList.rows = [];
      this.handleData(res);
      this.resultList.totalPage = res.data.data.totalPage;
      this.resultList.isLoading = false; //关闭下拉刷新效果
      this.resultList.finished = false;
      if (res.data.data.totalPage >= res.data.data.pageNum) {
        this.resultList.finished = true;
      } else {
        // this.resultList[index].pageNumber++;
      }
    },
    // *********************************下拉刷新，上拉加载公用******************************
    handleData(res) {
      let _this = this;
      res.data.data.list.forEach((item, ppp) => {
        _this.resultList.rows.push(item);
      });
    },
    // *********************************下拉刷新，上拉加载公用end***************************
    onSearch() {
      this.resultList.rows = [];
      this.getphysicalGoods();
    },
    toDetail(id, productId) {
      this.$f7router.navigate(`/goodsDetails/${id}/`);
    }
  },
  mounted() {
    let params = this.$f7route.params;
    if (params.code) {
      this.categoryCode = params.code;
      // this.getphysicalGoods();
    }
  }
};
</script>
<style>
</style>