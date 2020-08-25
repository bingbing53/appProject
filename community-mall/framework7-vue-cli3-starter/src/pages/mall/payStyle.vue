<template>
  <f7-page class="myStylePage">
    <van-nav-bar class="myNavBare" title="支付" left-arrow @click-left="onClickLeft_my" />
    <div class="pd-10 mt-50">
      <div class="pd-10 tc">选择支付方式</div>
      <div class="pd-10">
        <p class="f-16 text-indent05">
          支付金额：
          <span class="c-red f-20">
            <i class="f-12">￥</i>
            {{totalPrice}}
          </span>
          <span class="c-red f-20 ml-5">
            <i class="f-12">+</i>
            {{userCoin}}
            <i class="f-12">公益币</i>
          </span>
        </p>
      </div>
      <van-radio-group v-model="my_radio" class="mt-50">
        <van-cell-group>
          <van-cell clickable @click="my_radio = '1'">
            <van-radio slot="right-icon" name="1" />
            <!-- <van-icon class="payStyle_icon" name="alipay" /> -->
            <template #title>
              <img src="@/assets/alipay.png" width="28px" height="28px" class="v_middle mr-10" />
              <span class="custom-title v_middle f-16">支付宝</span>
            </template>
          </van-cell>
          <van-cell clickable @click="my_radio = '2'">
            <van-radio slot="right-icon" name="2" />
            <template #title>
              <img src="@/assets/wechat.png" width="28px" height="28px" class="v_middle mr-10" />
              <span class="custom-title v_middle f-16">微信</span>
            </template>
          </van-cell>
        </van-cell-group>
      </van-radio-group>
      <van-button class="mt-40" color="#f00" size="large" @click="topay">去支付</van-button>
    </div>
  </f7-page>
</template>
<script>
import { Toast, Dialog } from "vant";
export default {
  data() {
    return {
      my_radio: 0,
      totalPrice: "",
      date_id: "",
      userCoin: ""
    };
  },
  methods: {
    onClickLeft_my() {
      let _this = this;
      Dialog.confirm({
        title: "确认离开支付?",
        message: "订单过期系统自动取消，请及时付款."
      })
        .then(() => {
          // on confirm
          _this.GLOBAL.activeTab = 0;
          _this.$f7router.navigate(`/orderList/`, {
            clearPreviousHistory: true
          });
        })
        .catch(() => {
          // on cancel
        });
    },
    reducePrice(price) {
      return price / 100;
    },
    topay() {
      let _this = this;
      if (this.my_radio == 0) {
        Toast("请选择支付方式");
        return;
      } else if (this.my_radio == 2) {
        //微信
        Dialog.confirm({
          confirmButtonText: "已完成",
          cancelButtonText: "未完成",
          title: "是否支付完成?"
        })
          .then(() => {
            // on confirm
            _this.GLOBAL.activeTab = 1;
            this.$f7router.navigate(`/orderList/`, {
              clearPreviousHistory: true
            });
          })
          .catch(() => {
            // on cancel
            _this.GLOBAL.activeTab = 0;
            this.$f7router.navigate(`/orderList/`, {
              clearPreviousHistory: true
            });
          });
        wx.pay({
          payment: "wxpay",
          orderId: this.date_id,
          orderType: 1
        });
      } else if (this.my_radio == 1) {
        //支付宝
        Dialog.confirm({
          confirmButtonText: "已完成",
          cancelButtonText: "未完成",
          title: "是否支付完成?"
        })
          .then(() => {
            // on confirm
            _this.GLOBAL.activeTab = 1;
            this.$f7router.navigate(`/orderList/`, {
              clearPreviousHistory: true
            });
          })
          .catch(() => {
            // on cancel
            _this.GLOBAL.activeTab = 0;
            this.$f7router.navigate(`/orderList/`, {
              clearPreviousHistory: true
            });
          });
        wx.pay({
          payment: "alipay",
          orderId: this.date_id,
          orderType: 1
        });
      }
    }
  },
  mounted() {
    var params = this.$f7route.params;
    console.log(params);
    if (params.price || params.orderSn) {
      this.date_id = params.orderSn;
      this.totalPrice = params.price;
      this.userCoin = params.coin;
    }
  }
};
</script>

<style>
.myStylePage,
.page {
  overflow: hidden !important;
}
</style>