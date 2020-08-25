<template>
  <f7-page class="bgcg trade">
    <van-nav-bar class="myNavBare" title="订单详情" left-arrow @click-left="$commonUtils.onClickLeft" />
    <div class="mine bgcg pt-10">
      <div class="pl-20 pr-20 my_steppp bgcw border-radius8">
        <div>
          <van-steps :active="3" v-if="buy_detailData.status == 4">
            <van-step>等待支付</van-step>
            <van-step>商家接单</van-step>
            <van-step>已收货</van-step>
            <van-step>交易完成</van-step>
          </van-steps>
          <van-steps :active="1" v-else-if="buy_detailData.status == 7">
            <van-step>等待支付</van-step>
            <van-step>交易已取消</van-step>
          </van-steps>
          <van-steps :active="0" v-else-if="buy_detailData.status ==0">
            <van-step>等待支付</van-step>
            <van-step>商家接单</van-step>
            <van-step>已收货</van-step>
            <van-step>交易完成</van-step>
          </van-steps>
          <van-steps :active="1" v-else-if="buy_detailData.status ==1 || buy_detailData.status ==2">
            <van-step>等待支付</van-step>
            <van-step>商家接单</van-step>
            <van-step>已收货</van-step>
            <van-step>交易完成</van-step>
          </van-steps>
          <van-steps :active="2" v-else-if="buy_detailData.status ==3">
            <van-step>等待支付</van-step>
            <van-step>商家接单</van-step>
            <van-step>已收货</van-step>
            <van-step>交易完成</van-step>
          </van-steps>
          <van-steps :active="3" v-else-if="buy_detailData.status ==4">
            <van-step>等待支付</van-step>
            <van-step>商家接单</van-step>
            <van-step>已收货</van-step>
            <van-step>交易完成</van-step>
          </van-steps>
          <van-steps :active="0" v-else-if="buy_detailData.status == 5">
            <van-step>商家受理中</van-step>
            <!-- <van-step>商家同意退款</van-step> -->
            <van-step>退款成功</van-step>
          </van-steps>
          <van-steps :active="1" v-else-if="buy_detailData.status == 6">
            <van-step>商家受理中</van-step>
            <!-- <van-step>商家同意退款</van-step> -->
            <van-step>退款成功</van-step>
          </van-steps>
        </div>
        <div class="pd-10 bgcw" v-if="buy_detailData.status == 0">
          <p class="tc mb-20">
            <span class="f-14 mr-5">剩余:</span>
            <van-count-down :time="timeValue" class="inlineBlock f-20 f-b" />
            <span class="f-14 ml-5"></span>
          </p>
          <p class="tc f-14 c-333">
            请在
            <span v-if="timeValue2 != 0"></span>
            {{timeValue2}}小时内支付，过期订单自动取消
          </p>
        </div>
      </div>
      <div class="bgcw pt-10 mt-20 border-radius8">
        <van-row class="pd-10">
          <van-col :span="2">
            <van-icon name="location-o" />
          </van-col>
          <van-col :span="22">
            <div class>
              <b class="mr-10">{{buy_detailData.receiverName}}</b>
              <b
                v-if="buy_detailData.receiverPhone"
              >{{$commonUtils.plusXing(buy_detailData.receiverPhone, 3, 4)}}</b>
            </div>
            <p class="f-12 c-999 mt-10">地址: {{buy_detailData.receiverDetailAddress}}</p>
          </van-col>
        </van-row>
      </div>
      <div class="pd-10 bgcw mt-20 border-radius8">
        <p class="storeItem mb-10 mt-10">
          <b class="f-16 c-000" @click="enterStore(buy_detailData.sysOrgCode)">
            <van-icon name="shop-o" size="18" class="v_middle mr-5" color="#000000" />
            <span class="v_middle mr-5">{{buy_detailData.sysCompanyName}}</span>
            <van-icon name="arrow" class="v_middle" size="12" color="#000000" />
          </b>
        </p>
        <van-row v-for="(item,index) in goods_detailData" class="pt-10 pb-10 broder_b2">
          <van-col :span="6">
            <van-image :src="formatImage(item.productPic)" alt width="90" height="90" fit="cover" />
          </van-col>
          <van-col :span="18" @click="toGoodsDetail(item.productId,item.productCategoryCode)">
            <div class="pl-20">
              <span class="f-16">{{item.productName}}</span>
              <div class="f-12 c-666 mt-5">
                <span class="mr-10">数量: {{item.productQuantity}}</span>
                <span class="mr-5" v-for="(kkk,ppp) in item.productAttr" :key="ppp">{{kkk.key}}: {{kkk.value}}</span>
              </div>
              <p class="mt-15 f-b">￥{{item.productPrice}}</p>
            </div>
          </van-col>
          <van-col :span="24" class="pd-10 tr" v-if="buy_detailData.status == 3">
            <van-button
              round
              color="#eee"
              size="small"
              style="width:40px"
              v-if="item.isComment == 1"
            >评价</van-button>
            <van-button
              round
              color="#f00"
              size="small"
              style="width:40px"
              @click="toPraise(item.orderSn,item.id,item.productId,index)"
              v-else
            >评价</van-button>
          </van-col>
        </van-row>
      </div>
      <div
        class="bgcw mt-20 border-radius8 mb-20"
        v-if="goodsType == 'G02' && buy_detailData.status == 2"
      >
        <van-row class="pd-10 f-14">
          <van-col :span="6" class="pb-10 pt-10 c-666">物流公司:</van-col>
          <van-col :span="18" class="pb-10 pt-10 broder_b2">{{buy_detailData.deliveryCompany}}</van-col>
          <van-col :span="6" class="pb-10 pt-10 c-666">快递单号:</van-col>
          <van-col :span="18" class="pb-10 pt-10 broder_b2">{{buy_detailData.deliverySn}}</van-col>
        </van-row>
      </div>
      <div class="bgcw pt-10 mt-20 border-radius8 mb-80">
        <van-row class="pd-10 f-14">
          <van-col :span="6" class="pb-10 pt-10 c-666">订单编号:</van-col>
          <van-col :span="18" class="pb-10 pt-10 broder_b2">{{buy_detailData.orderSn}}</van-col>
          <van-col :span="6" class="pb-10 pt-10 c-666">订单备注:</van-col>
          <van-col
            :span="18"
            class="pb-10 pt-10 broder_b2"
            v-if="buy_detailData.buyerNote != ''"
          >{{buy_detailData.buyerNote}}</van-col>
          <van-col :span="18" class="pb-10 pt-10 broder_b2" v-else>无</van-col>
          <van-col :span="6" class="pb-10 pt-10 c-666">下单时间:</van-col>
          <van-col :span="18" class="pb-10 pt-10 broder_b2">{{buy_detailData.createTime}}</van-col>
          <van-col :span="6" class="pb-10 pt-10 c-666">商品总额:</van-col>
          <van-col :span="18" class="pb-10 pt-10 tr">
            <span class="c-000 f-16">
              <i class="f-12">￥</i>
              {{buy_detailData.totalAmount}}
            </span>
          </van-col>
          <van-col :span="6" class="pb-10 pt-10 c-666">公益币:</van-col>
          <van-col :span="18" class="pb-10 pt-10 tr">- {{buy_detailData.coin}}</van-col>
          <van-col :span="6" class="pb-10 pt-10 c-666">优惠券:</van-col>
          <van-col :span="18" class="pb-10 pt-10 tr">
            <i class="f-12">￥</i>
            {{buy_detailData.couponAmount}}
          </van-col>
          <van-col :span="24" class="pb-10 pt-10 tr">
            订单金额:
            <span class="c-red f-18 f-b">
              <i class="f-12 c-red">￥</i>
              {{buy_detailData.payAmount}}
            </span>
          </van-col>
        </van-row>
      </div>
      <van-popup v-model="show_prise" position="bottom" :style="{ height: '70%' }" round>
        <div class="f-12 bgcw text">
          <p class="f-20 c-000">商品评价</p>
        </div>
        <div class="pd-10 pb-50 mb-20">
          <span class="c-666 mr-10">请对本次购买商品评价:</span>
          <div class="mt-10 mb-10">
            <van-rate
              v-model="RateValue"
              :size="22"
              color="#ee0a24"
              void-icon="star"
              void-color="#eee"
            />
          </div>
          <div class="border bgcg mt-20 mb-10">
            <van-field
              rows="4"
              autosize
              type="textarea"
              v-model="rateComment"
              placeholder="如有补充请输入"
            />
          </div>
          <div class="c-666">
            <p class="mb-10">晒图:</p>
            <div>
              <f7-row>
                <f7-col
                  v-for="(item,index) in imagesList" :key="index"
                  width="33"
                  class="fl"
                  style="position:relative"
                >
                  <img :src="item" id="img" />
                  <div class="iconfont icon-chahao" @click="deleteMulPic(index)"></div>
                </f7-col>
                <f7-col width="33" v-if="imagesList.length < 6" class="Mainpicture fl">
                  <van-icon name="plus" size="20" color="#666" @click="choiseImage" />
                </f7-col>
                <div class="clear"></div>
              </f7-row>
            </div>
          </div>
          <div class="check_bottom">
            <van-button color="#fc3d42" size="large" @click="submitPrise">提交评价</van-button>
          </div>
        </div>
      </van-popup>
    </div>
    <div class="fixedBottom">
      <van-row class="pd-10" v-if="buy_detailData.status == 0">
        <van-col :span="5" offset="11">
          <van-button @click="unOrder(buy_detailData.orderSn)" round size="small">取消订单</van-button>
        </van-col>
        <van-col :span="5" offset="2">
          <van-button
            @click="topay"
            round
            size="small"
            type="danger"
            v-if="buy_detailData.status == 0"
          >立即支付</van-button>
        </van-col>
      </van-row>
    </div>
  </f7-page>
</template>

<script>
import { Toast, Dialog } from "vant";
import { queryOrderDetail, evalOrder, cancelOrder } from "@/api/api_mall.js";
import { uploadBase64Image } from "@/api/api_common";
export default {
  data() {
    return {
      timeValue: null,
      timeValue2: null,
      activeStep: 0,
      serveData: "",
      id: "",
      buy_detailData: {},
      goods_detailData: [],
      show_prise: false,
      RateValue: 5,
      productId: "",
      itemId: "",
      rateComment: "",
      imagesList: [],
      idx: 0,
      goodsType: ""
    };
  },
  methods: {
    //格式化图片路径
    formatImage(url) {
      return this.$commonUtils.formatPicture(url);
    },
    enterStore(sysCompanyCode) {
      this.$f7router.navigate(`/enter-store/${sysCompanyCode}/`);
    },
    //删除一个图片
    deleteMulPic(index) {
      this.$delete(this.imagesList, index);
    },
    //上传图片
    choiseImage() {
      let choiseLength = 6 - this.imagesList.length;
      //  console.log(choiseLength)
      let that = this;
      wx.choiseMultiImage({
        maxSelected: choiseLength,
        success: function ready(value) {
          value = eval(value);
          value.forEach((el, index) => {
            that.imagesList.push(el);
          });
        }
      });
    },
    getDetail() {
      queryOrderDetail({ orderSn: this.id })
        .then(res => {
          // console.log(res);
          if (res.data.data && res.data.data.orderItemList.length > 0) {
            this.goodsType = res.data.data.orderItemList[0].productCategoryCode.substring(
              0,
              3
            );
          }
          this.buy_detailData = res.data.data;
          //计算倒计时
          let mycreateTime = new Date(
            res.data.data.createTime.replace(/-/g, "/")
          );
          let currentDate = new Date();
          let createDate = mycreateTime;
          let disDate = (currentDate - createDate) / 1000 / 60; //分钟
          this.timeValue2 = res.data.data.normalOrderOvertime / 60;
          this.timeValue =
            ((res.data.data.normalOrderOvertime - disDate) / 60) *
            60 *
            60 *
            1000;

          if (res.data.data.orderItemList.length > 0) {
            res.data.data.orderItemList.forEach((item, index) => {
              item.productAttr = JSON.parse(item.productAttr);
            });
          }
          this.goods_detailData = res.data.data.orderItemList;
          this.activeStep = res.data.data.status;
          this.serveData =
            res.data.data.orderItemList[0].sp1 +
            res.data.data.orderItemList[0].sp2;
        })
        .then(err => {});
    },
    //去支付
    topay() {
      // console.log(this.buy_detailData.payAmount,this.buy_detailData.orderSn,this.buy_detailData.coin)
      this.$f7router.navigate(
        `/payStyle/forceClose/${this.buy_detailData.payAmount}/${this.buy_detailData.orderSn}/${this.buy_detailData.coin}/`
      );
    },
    toPraise(orderSn, id, productId, index) {
      this.show_prise = true;
      this.itemId = id;
      this.productId = productId;
      this.idx = index;
    },
    //提交评价
    async submitPrise() {
      let resultArr = [];
      let resultJson = "";
      if (this.imagesList.length > 0) {
        wx.loading("图片上传中");
        for (var i = 0; i < this.imagesList.length; i++) {
          var result = await uploadBase64Image({
            upfile: this.imagesList[i]
          }).catch(err => {
            wx.toast("上传失败");
            wx.closeLoading();
            return;
          });
          if (result.status == 200) {
            resultArr.push(result.data["url"]);
          }
        }
        wx.closeLoading();
        resultJson = resultArr.join(",");
      }
      let param = {
        productId: this.productId,
        star: this.RateValue,
        content: this.rateComment,
        pics: resultJson,
        orderId: this.buy_detailData.id,
        orderItemId: this.itemId
      };
      Toast(param);
      // return
      evalOrder(param)
        .then(res => {
          Toast("评价成功");
          this.show_prise = false;
          this.goods_detailData[this.idx].isComment = 1;
        })
        .then(err => {});
    },
    //取消订单
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
            })
            .catch(err => {});
        })
        .catch(() => {
          // on cancel
        });
    },
    formatDate(data) {
      let s = data.substring(0, data.length - 5);
      let r = s.replace(/^(\d{4})(\d{2})(\d{2})$/, "$1-$2-$3");
      let t = data.substring(data.length - 5, data.length);
      return r + t;
    },
    //去商品详情页面
    toGoodsDetail(id, productCategoryCode) {
      productCategoryCode = productCategoryCode.substring(0, 3);
      if (productCategoryCode == "G02") {
        this.$f7router.navigate(`/goodsDetails/${id}/`);
      } else if (productCategoryCode == "G01") {
        this.$f7router.navigate(`/goodsDetail/${id}/`);
      }
    }
  },
  mounted() {
    let params = this.$f7route.params;
    if (params.id) {
      this.id = params.id;
      this.getDetail();
    }
  }
};
</script>

<style>
.leftItem,
.rightItem {
  display: inline-block;
  width: 78%;
  vertical-align: middle;
}
.leftItem img {
  margin-right: 10px;
  vertical-align: middle;
}
.rightItem {
  width: 20%;
  text-align: right;
  color: #f00;
}
.fixedBottom {
  /* position: fixed;
  bottom: 0px;
  left: 0px;
  right: 0px; */
  border-top: 1px solid #eee;
  padding-top: 5px;
  background: #fff;
}
.fixedBottom .itemBottom {
  text-align: right;
}
.fixedBottom .itemBottom span {
  display: inline-block;
  padding: 10px 20px;
  background-color: #f00;
  color: #ffffff;
  margin-bottom: 5px;
  margin-right: 5px;
  border-radius: 4px;
}
.icon-chahao {
  cursor: pointer;
  position: absolute;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  text-align: center;
  top: -5px;
  right: -5px;
  color: #fff;
  background: rgba(0, 0, 0, 0.5);
}
.Mainpicture {
  float: left;
  width: 100px;
  height: 100px;
  line-height: 100px;
  text-align: center;
  background: rgba(255, 255, 255, 1);
  border-radius: 2px;
  border: 1px solid #e5e9f2;
  /* margin-left: -100px; */
}
#img {
  width: 100%;
  height: 100px;
  border-radius: 5px;
}
.my_steppp .van-step__icon--active,
.van-step__title--active {
  /* margin-left: 23px; */
  color: #000;
  font-size: 15px !important;
  font-weight: bold;
}
.my_steppp .van-step--finish .van-step__circle,
.van-step--finish .van-step__line {
  background-color: #ebedf0;
}
.storeItem {
  height: 20px;
  line-height: 20px;
  padding-bottom: 10px;
}
</style>