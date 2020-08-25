<template>
  <f7-page class="bgcg order_List">
    <van-nav-bar class="myNavBare" title="订单" left-arrow @click-left="myLfet" />
    <div class="mine bgcg">
      <van-tabs v-model="active" sticky @change="clickItem" class="tabOrderList">
        <van-tab :title="item.title" v-for="(item,index) in classifyList" :key="index">
          <van-pull-refresh v-model="stateList[index].isLoading" @refresh="orderRefresh(index)">
            <van-list
              :finished="stateList[index].finished"
              finished-text="没有更多了"
              :immediate-check="false"
              @load="getOrderList(index,item.statusList)"
            >
              <van-row
                v-for="(detail,pos) in stateList[index].rows"
                :key="pos"
                class="mg-10 pd-10 bgcw border-radius4"
              >
                <van-col :span="24" class="pb-10 mb-10">
                  <p class="storeItem mb-10">
                    <b class="f-16 c-000" @click="enterStore(detail.sysOrgCode)">
                      <van-icon name="shop-o" size="18" class="v_bottom mr-5" color="#000000" />
                      <span class="v_middle mr-5">{{detail.sysCompanyName}}</span>
                      <van-icon name="arrow" class="v_middle" size="12" color="#000000" />
                    </b>
                    <span class="fr c-red f-14" v-if="detail.status == 0">待付款</span>
                  </p>
                  <van-row @click="toDetail(detail.orderSn)">
                    <van-col :span="20">
                      <div class="smal-list">
                        <div
                          class="large-list"
                          v-bind:style="{'width':detail.orderItemList.length * 92+'px'}"
                        >
                          <div>
                            <div
                              v-for="(nape, pos) in detail.orderItemList"
                              class="pt-5 pb-5 inlineBlock"
                            >
                              <img
                                v-if="nape.productPic"
                                :src="formatImage(nape.productPic)"
                                alt
                                width="80"
                                height="80"
                                class="v_top mr-5 ml-5 border border-radius5"
                              />
                              <img v-else src alt width="90" height="90" />
                            </div>
                          </div>
                        </div>
                      </div>
                    </van-col>
                    <van-col :span="4">
                      <div
                        class="totalOrderLength pl-5 pr-5 tr f-14"
                      >共{{detail.orderItemList.length}}件</div>
                    </van-col>
                  </van-row>
                </van-col>
                <van-col :span="24" class="broder_b pb-10 mb-10">
                  <div>
                    <p class="fr">
                      <span>总价:</span>
                      <span class="c-red">
                        <i class="f-12">￥</i>
                        {{detail.payAmount}}
                        <i>+ {{detail.coin}} 公益币</i>
                      </span>
                    </p>
                  </div>
                </van-col>
                <van-col :span="24" v-if="detail.status == 0">
                  <div>
                    <van-button
                      round
                      size="small"
                      class="bottom_button"
                      @click="unOrder(detail.orderSn)"
                    >取消订单</van-button>
                    <van-button
                      round
                      size="small"
                      class="bottom_button fr"
                      @click="toDetail(detail.orderSn)"
                    >立即支付</van-button>
                  </div>
                </van-col>
                <van-col :span="24">
                  <div v-if="detail.status == 3">
                    <!-- <span class="fr f-14 c-666 mt-5 inlineBlock">到货时间: {{detail.receiveTime}}</span> -->
                    <van-button
                      round
                      @click="toDetail(detail.orderSn)"
                      size="small"
                      class="fr"
                      style="width:100px"
                    >去评价</van-button>
                  </div>
                </van-col>
                <van-col :span="24" v-if="detail.status == 2 || detail.status == 1">
                  <van-button
                    round
                    size="small"
                    class="fr order_button"
                    @click="sureOrder(detail.orderSn,index,item.statusList)"
                  >到货确认</van-button>
                  <van-button
                    round
                    size="small"
                    class="c-red order_button"
                    @click="refunds(detail.orderSn,detail.status)"
                  >申请退款</van-button>
                </van-col>
                <van-col :span="24" v-if="detail.status == 5 || detail.status == 6">
                  <div>
                    <span class="fr f-14 c-666 mt-5 inlineBlock" v-if="detail.status == 5">退款中</span>
                    <span class="fr f-14 c-666 mt-5 inlineBlock" v-else-if="detail.status == 6">已退款</span>
                    <span class="fr f-14 c-666 mt-5 inlineBlock" v-else>{{detail.status}}</span>
                  </div>
                </van-col>
              </van-row>
            </van-list>
          </van-pull-refresh>
        </van-tab>
      </van-tabs>
    </div>
  </f7-page>
</template>

<script>
import { queryOrder, cancelOrder, sureOrder } from "@/api/api_mall.js";
import { Dialog, Toast } from "vant";
export default {
  data() {
    return {
      active: 0,
      classifyList: [
        { title: "待付款", statusList: "0" },
        { title: "已付款", statusList: "1,2" },
        { title: "待评价", statusList: "3" },
        { title: "已取消", statusList: "7,8" },
        { title: "已结束", statusList: "4" },
        { title: "退款", statusList: "5,6" }
      ],
      stateList: [
        {
          isLoading: false,
          pageNumber: 1,
          totalPage: 0,
          loading: false,
          finished: false,
          rows: []
        },
        {
          isLoading: false,
          pageNumber: 1,
          totalPage: 0,
          loading: false,
          finished: false,
          rows: []
        },
        {
          isLoading: false,
          pageNumber: 1,
          totalPage: 0,
          loading: false,
          finished: false,
          rows: []
        },
        {
          isLoading: false,
          pageNumber: 1,
          totalPage: 0,
          loading: false,
          finished: false,
          rows: []
        },
        {
          isLoading: false,
          pageNumber: 1,
          totalPage: 0,
          loading: false,
          finished: false,
          rows: []
        },
        {
          isLoading: false,
          pageNumber: 1,
          totalPage: 0,
          loading: false,
          finished: false,
          rows: []
        }
      ],

      //已付款
      paid: {},
      //待评价
      toAppraise: {},
      //已结束
      end: {},
      //退购
      repurchase: {}
    };
  },
  methods: {
    myLfet() {
      wx.popPage();
    },
    //格式化图片路径
    formatImage(url) {
      return this.$commonUtils.formatPicture(url);
    },
    enterStore(sysCompanyCode) {
      this.$f7router.navigate(`/enter-store/${sysCompanyCode}/`);
    },
    // 取消订单
    unOrder(orderSn) {
      let _this = this;
      Dialog.confirm({
        title: "标题",
        message: "确认取消订单吗？"
      })
        .then(() => {
          cancelOrder({ orderSn: orderSn })
            .then(res => {
              Toast("取消成功，正在为您处理");
              _this.getOrderList(0, 0);
            })
            .catch(err => {});
        })
        .catch(() => {
          // on cancel
        });
    },
    //到货确认
    sureOrder(orderSn, idx, statusList) {
      let _this = this;
      Dialog.confirm({
        title: "标题",
        message: "确认收货？"
      })
        .then(() => {
          sureOrder({ orderSn: orderSn })
            .then(res => {
              _this.getOrderList(idx, statusList);
            })
            .catch(err => {});
        })
        .catch(() => {
          // on cancel
        });
    },
    //申请退款
    refunds(orderSn, status) {
      let _this = this;
      // status = 2;
      if (status == 2) {
        Dialog.alert({
          message: "该订单已发货，无法线上退款，请联系商家"
        }).then(() => {});
      }
      if (status == 1) {
        Dialog.confirm({
          message: "确认申请退款吗？"
        })
          .then(() => {
            cancelOrder({ orderSn: orderSn })
              .then(res => {
                console.log(res);
                _this.active = 5;
              })
              .catch(err => {});
          })
          .catch(() => {
            // on cancel
          });
      }
    },

    //去详情页面
    toDetail(id) {
      // alert(id);
      this.$f7router.navigate(`/orderDetail/${id}`);
    },

    //点击tab
    clickItem(index, title) {
      this.stateList[index].pageNumber = 1;
      this.stateList[index].finished = false;
      this.getOrderList(index, this.classifyList[index].statusList);
    },

    init(index) {
      queryOrder({
        statusList: this.classifyList[index].statusList,
        pageNum: 1
      })
        .then(res => {
          this.stateList[index].rows = [];
          this.handleData(res.data, index);
          this.stateList[index].totalPage = res.data.data.totalPage;
          this.stateList[index].isLoading = false; //关闭下拉刷新效果
          this.stateList[index].finished = false;
          if (res.data.data.totalPage <= res.data.data.pageNum) {
            this.stateList[index].finished = true;
          } else {
            this.stateList[index].pageNumber++;
          }
        })
        .catch(err => {});
    },
    //待付款下拉刷新
    orderRefresh(index) {
      this.stateList[index].totalPage = 0;
      this.stateList[index].pageNumber = 1;
      this.init(index); //加载数据
    },
    //获取待付款的列表数据
    getOrderList(index, type) {
      let pageNumber = this.stateList[index].pageNumber;
      if (this.stateList[index].loading) {
        return;
      }
      this.stateList[index].loading = true;
      if (this.stateList[index].pageNumber == 1) {
        this.stateList[index].rows = [];
      }
      queryOrder({ statusList: type, pageNum: pageNumber })
        .then(res => {
          this.handleData(res.data, index);
          this.stateList[index].totalPage = res.data.data.totalPage;
          this.stateList[index].loading = false;

          if (res.data.data.totalPage <= res.data.data.pageNum) {
            this.stateList[index].finished = true;
          } else {
            this.stateList[index].pageNumber++;
          }
        })
        .then(err => {
          // console.log(err);
          // this.$commonUtils.jumpLogin(err)
        });
    },
    // *********************************下拉刷新，上拉加载公用******************************
    handleData(res, index) {
      let _this = this;
      res.data.list.forEach(function(item, ppp) {
        _this.stateList[index].rows.push(item);
      });
    }
    // *********************************下拉刷新，上拉加载公用end***************************
  },
  mounted() {
    this.getOrderList(0, 0);
  },
  created() {
    this.$commonUtils.setTitle("全部订单");
    // console.log(this.GLOBAL.activeTab)
    // this.GLOBAL.activeTab = 1
    if (this.GLOBAL.activeTab == 0) {
      this.active = 0;
    } else if (this.GLOBAL.activeTab == 1) {
      this.active = 1;
      this.getOrderList(1, "1,2");
    }
  }
};
</script>

<style>
.ios .navbar ~ .page-with-subnavbar:not(.no-navbar) .page-content {
  padding-top: 10px !important;
}
.check_bottom {
  position: fixed;
  bottom: 0px;
  left: 0px;
  right: 0px;
}
.storeItem {
  height: 20px;
  line-height: 20px;
  /* border-bottom: 1px solid #eee; */
  padding-bottom: 10px;
}
.bottom_button {
  width: 100px;
  margin: 0 10px;
}
.order_List .page-content {
  display: flex;
  flex-direction: column;
  height: 100%;
}
.order_List .van-sticky--fixed {
  top: 45px;
}
.order_button {
  width: 80px;
}
.smal-list {
  width: 100%;
  height: 100%;
  overflow-x: scroll;
}
.large-list {
  /* width: 1000px; */
}
.totalOrderLength {
  /* width: 100%; */
  line-height: 90px;
  background: #ffffff;
  filter: Alpha(opacity=20);
}
.smal-list ::-webkit-scrollbar {
  display: none; /* Chrome Safari */
}

.smal-list {
  scrollbar-width: none; /* firefox */
  -ms-overflow-style: none; /* IE 10+ */
  overflow-x: auto;
  overflow-y: hidden;
}
.tabOrderList .van-tab {
  -ms-flex-preferred-size: 20% !important;
  flex-basis: 20% !important;
}
</style>