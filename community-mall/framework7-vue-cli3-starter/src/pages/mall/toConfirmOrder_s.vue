<template>
  <f7-page class="bgcg mypages">
    <van-nav-bar class="myNavBare" title="订单详情" left-arrow @click-left="$commonUtils.onClickLeft" />
    <div class="mine pt-5 bgcg" style="padding-bottom:70px">
      <van-row class="pl-10 pr-10 pt-10 pb-5 bgcw">
        <van-col :span="24">
          <p class="mb-10">
            <van-icon name="location-o" class="v_middle f-18" />
            <span class="v_middle ml-10">收货地址</span>
          </p>
        </van-col>
        <van-col :span="24" class="pb-10" @click="selectAddress">
          <div class="addressItem pb-10">
            <h4>{{personParam.receiverDetailAddress}}</h4>
            <div class="mt-10">
              <span class="mr-10">{{personParam.receiverName}}</span>
              <span class="f-14">{{personParam.receiverPhone}}</span>
            </div>
          </div>
          <div class="icons">
            <van-icon name="arrow" color="#969799" />
          </div>
        </van-col>
      </van-row>
      <van-row class="pd-10 mt-10 bgcw">
        <van-col :span="18">
          <p class="pb-10">
            <van-icon name="shop-o" class="v_middle f-18" />
            <span class="ml-10 v_middle">{{this.GLOBAL.carJsonList[0].sysCompanyName}}</span>
          </p>
          <div class="smal-list">
            <div
              class="large-list"
              v-bind:style="{'width':this.GLOBAL.carJsonList.length * 80+'px'}"
            >
              <div
                v-for="(order,number) in this.GLOBAL.carJsonList"
                :key="number"
                class="inlineBlock mr-10"
              >
                <van-image
                  class="border"
                  width="60px"
                  height="60px"
                  fit="cover"
                  :src="formatImage(order.productPic)"
                ></van-image>
              </div>
            </div>
          </div>
        </van-col>
        <van-col :span="6">
          <div class="totalOrderLength pl-5 pr-5 tr">
            <span>共{{this.GLOBAL.carJsonList.length}}件</span>
            <span class="ml-10">
              <!-- <van-icon name="arrow" color="#969799" class="mr-10 v_middle" /> -->
            </span>
          </div>
        </van-col>
        <van-col :span="24" class="borderScale_top mt-10">
          <van-field
            v-model="personParam.buyerNote"
            rows="2"
            autosize
            type="textarea"
            maxlength="50"
            placeholder="如有特殊需要，请给商家留言，建议留言前先与商家沟通确认"
            show-word-limit
          />
        </van-col>
      </van-row>
      <van-row class="mt-10">
        <van-col :span="24" @click="isVouchers">
          <van-cell title="代金券" is-link>
            <span>{{quanName}}</span>
          </van-cell>
        </van-col>
        <van-col :span="24">
          <van-cell center title="是否使用公益币">
            <span class="mr-20 f-11">可用公益币余额{{rescoin}}</span>
            <van-switch
              v-model="checkedCoin"
              slot="right-icon"
              size="24"
              :disabled="disabledCoin"
              @change="getchecked"
              @click="clickchecked"
            />
          </van-cell>
        </van-col>
      </van-row>
      <van-row class="mt-10 bgcw pd-10">
        <van-col :span="24">
          <div>
            <p class="mb-10">
              <van-icon name="balance-o" class="v_middle f-20" />
              <span class="v_middle ml-10">共计消费</span>
            </p>
            <div class="mt-10 ml-5">
              <span class="mr-10 f-14">公益价消费:</span>
              <p class="mt-5 c-666 f-14 inlineBlock mr-10">
                现金：
                <span class="c-000 f-16">
                  <i class="f-12 c-red">￥</i>
                  {{totalPriceGongyi}}
                  <!-- <i class="f-11">.00</i> -->
                </span>
              </p>
              <p class="mt-5 c-666 f-14 inlineBlock">
                公益币：
                <span class="c-000 f-16">{{totalCoinsGongyi}}</span>
              </p>
            </div>
            <div class="mt-10 ml-5 broder_t">
              <span class="mr-10 f-14">市场价消费:</span>
              <p class="mt-5 c-666 f-14 inlineBlock mr-10">
                现金：
                <span class="c-000 f-16">
                  <i class="f-12 c-red">￥</i>
                  {{totalPriceShichang}}
                  <!-- <i class="f-11">.00</i> -->
                </span>
              </p>
            </div>
          </div>
        </van-col>
      </van-row>
      <van-popup
        v-model="show_address"
        position="bottom"
        :style="{ height: '60%' }"
        round
      >
       <div class="pd-10 text-c">
          <p class="c-999">——请选择收货地址——</p>
        </div>
        <div>
          <van-address-list
            v-model="chosenAddressId"
            default-tag-text="默认"
            :list="list"
            @edit="onEdit"
            @add="onAdd"
            @select="select"
          />
        </div>
      </van-popup>
      <van-popup
        v-model="show_vouchers"
        position="bottom"
        :style="{ height: '60%' }"
        class="bgcg"
        round=""
      >
        <div v-if="vouchersList == undefined  || vouchersList.length <= 0" class="pd-10 text-c">
          <p class="c-999">——暂无可使用的代金券——</p>
        </div>
        <div v-else>
          <div class="pd-10 text-c">
            <p class="c-999">——可使用的代金券——</p>
          </div>
          <van-row class="bgcw pd-10 mg-10 border-radius5" v-for="(item,index) in vouchersList">
            <van-col span="6">
              <div class="left_price">
                ￥
                <span class="mr-10">{{item.coupon.amount}}</span>
              </div>
            </van-col>
            <van-col span="12" class="center_content_out">
              <div class="center_content">
                <h4 class="mb-10">{{item.coupon.name}}</h4>
                <p>{{item.coupon.note}}</p>
                <p>{{substringDate(item.coupon.startTime)}} 至 {{substringDate(item.coupon.endTime)}}</p>
              </div>
            </van-col>
            <van-col span="6">
              <div class="right_button">
                <van-button
                  round
                  size="small"
                  class="baco c-fff"
                  @click="useQuan(item.id,item.coupon.name)"
                >使用</van-button>
              </div>
            </van-col>
          </van-row>
        </div>
      </van-popup>
      <van-popup v-model="show_details" position="bottom" :style="{ height: '60%' }" class="bgcg"></van-popup>
    </div>
    <van-submit-bar
      :price="priceDuc(totalPrice2)"
      button-text="提交订单"
      @submit="submitOrder"
      v-show="isAddress"
      style="position:static;"
    />
  </f7-page>
</template>
<script>
import { Toast } from "vant";
import {
  goodsDetailSku,
  goodsDetail,
  cAmountCar,
  userCoin,
  sumitMyorderCar,
  useQuanCar,
  addressList
} from "@/api/api_mall.js";
export default {
  data() {
    return {
      sysCompanyCode: "",
      skucodes: "",
      id: "",
      number: null,
      show_address: false,
      show_vouchers: false,
      show_details: false,

      //公益币 ,金额
      rescoin: "",
      checkedCoin: false,
      disabledCoin: false,
      totalPrice: 0,
      totalPriceGongyi: 0,
      totalPrice2: 0,
      totalPriceShichang: 0,
      totalCoins: 0,
      totalCoinsGongyi: 0,

      quanID: "",
      quanName: "",
      isorder: false,
      personParam: {
        receiverName: "",
        receiverPhone: "",
        receiverPostCode: "",
        receiverProvince: "",
        receiverCity: "",
        receiverRegion: "",
        receiverDetailAddress: "",
        buyerNote: ""
      },
      chosenAddressId: "",
      list: [],
      vouchersList: [],
      isAddress: true
    };
  },
   watch: {
    show_address(newName, oldName) {
      if (newName) {
        this.isAddress = false;
      } else {
        this.isAddress = true;
      }
    },
    show_vouchers(newName, oldName) {
      if (newName) {
        this.isAddress = false;
      } else {
        this.isAddress = true;
      }
    }
  },
  methods: {
    //格式化图片路径
    formatImage(url) {
      return this.$commonUtils.formatPicture(url);
    },
    substringDate(time) {
      return time.substring(0, 10);
    },
    //获取我的公益币余额
    getMyCoin() {
      userCoin({ areaCode: this.GLOBAL.carJsonList[0].areaCode })
        .then(res => {
          // res.data.data = null;
          this.rescoin = res.data.data;
          console.log(res.data.data, Number(this.totalCoins));
          if (res.data.data && res.data.data >= Number(this.totalCoins)) {
            this.disabledCoin = false;
          } else if (
            res.data.data == 0 ||
            res.data.data == null ||
            res.data.data == "null"
          ) {
            // Toast("您的公益币不足");
            this.rescoin = 0;
            this.disabledCoin = true;
          } else {
            this.disabledCoin = true;
          }
          // if (this.totalPriceGongyi == "0") {
          //   Toast("无法使用公益币");
          //   this.disabledCoin = true;
          // }
        })
        .catch(err => {});
    },
    //获取公益按钮的状态
    getchecked() {
      if (this.checkedCoin) {
        this.toCAmount(1);
      } else {
        this.toCAmount(0);
      }
    },
    clickchecked() {
      // if (this.totalPriceGongyi == "0") {
      //   Toast("无法使用公益币");
      //   this.disabledCoin = true;
      //   return;
      // }
      if (this.rescoin && this.rescoin >= Number(this.totalCoins)) {
        this.disabledCoin = false;
      } else if (
        this.rescoin == 0 ||
        this.rescoin == null ||
        this.rescoin == "null"
      ) {
        Toast("您的公益币不足");
        this.rescoin = 0;
        this.disabledCoin = true;
        return;
      } else {
        this.disabledCoin = true;
        Toast("您的公益币不足");
        return;
      }
    },
    useQuan(id, name) {
      this.quanID = id;
      this.quanName = name;
      if (this.checkedCoin) {
        //使用了公益币
        this.toCAmount(1);
      } else {
        //未使用公益币
        this.toCAmount(0);
      }

      this.show_vouchers = false;
    },
    //计算金额
    toCAmount(isUse, time) {
      let _this = this;
      let coinSkucodes = "";
      console.log(isUse);
      if (isUse == 1) {
        coinSkucodes = this.skucodes;
      } else {
        coinSkucodes = "";
      }
      let param = {
        productSkuCodeList: this.skucodes,
        couponHistoryId: this.quanID,
        sysCompanyCode: this.sysCompanyCode,
        useCoinProductSkuCodeList: coinSkucodes
      };
      cAmountCar(param)
        .then(res => {
          if (res.data.message == "库存不足，无法下单") {
            _this.isorder = true;
          }
          _this.totalPrice = res.data.data.payAmount;
          if (isUse == 1 && time == "first") {
            // _this.totalPrice2 = res.data.data.payAmount;
          } else {
            _this.totalPrice2 = res.data.data.payAmount;
          }
          _this.totalCoins = res.data.data.coin;
        })
        .catch(err => {});
      // if (this.totalPriceGongyi == "0") {
      //   this.disabledCoin = true;
      // }
    },
    priceDuc(price) {
      return price * 100;
    },

    //提交订单
    submitOrder() {
      if (
        this.personParam.receiverProvince == "" ||
        this.personParam.receiverPhone == ""
      ) {
        Toast("请填写地址");
        return;
      }
      if (this.isorder == true) {
        Toast("库存不足，无法下单");
        return;
      }
      let coinSkucodes = "";
      if (this.totalCoins != 0 && this.checkedCoin) {
        coinSkucodes = this.skucodes;
      } else {
        coinSkucodes = "";
      }
      let param2 = {
        couponId: "",
        useCoinProductSkuCodeList: coinSkucodes,
        productSkuCodeList: this.skucodes,
        sysCompanyCode: this.sysCompanyCode,
        sysOrgCode: this.GLOBAL.carJsonList[0].sysOrgCode,
        couponHistoryId: this.quanID
      };
      let param = JSON.parse(
        (JSON.stringify(param2) + JSON.stringify(this.personParam)).replace(
          /}{/,
          ","
        )
      );

      if (!this.checkedCoin) {
        this.totalPrice = this.totalPriceShichang;
        this.totalCoins = 0;
      }
      //  console.log(param);
      // console.log(this.totalPrice2, this.totalCoins);
      // return;
      sumitMyorderCar(param)
        .then(res => {
          if (res.data.code == 200) {
            let orderSn = res.data.data.order.orderSn;
            this.$f7router.navigate(
              `/payStyle/forceClose/${this.totalPrice2}/${orderSn}/${this.totalCoins}/`
            );
          } else {
            Toast("无法下单");
          }
        })
        .catch(err => {});
    },
    //是否使用代金券
    isVouchers() {
      if (this.totalPriceGongyi == "0") {
        this.disabledCoin = true;
        Toast("无法使用优惠券");
        return;
      }
      this.show_vouchers = true;
      this.getVouchers();
    },
    //获取可用的代金券
    getVouchers() {
      let param = {
        productSkuCodeList: this.skucodes,
        sysCompanyCode: this.sysCompanyCode
      };
      // console.log("参数:" + JSON.stringify(param));
      useQuanCar(param)
        .then(res => {
          console.log(JSON.stringify(res));
          this.vouchersList = res.data.data;
        })
        .catch(err => {});
    },

    //获取收货地址
    getAddress(time) {
      addressList()
        .then(res => {
          let personParamIdx;
          res.data.data.forEach((item, index) => {
            item.tel = item.phoneNumber;
            item.address = item.detailAddress;
             if(item.defaultStatus == 1){
              personParamIdx = index;
             item.isDefault = true;
             }else if(item.defaultStatus == 0){
              item.isDefault = false;
             }
          });
          this.list = res.data.data;
          if (time == "first" && personParamIdx) {
            this.personParam.receiverName = res.data.data[personParamIdx].name;
            this.personParam.receiverPhone = res.data.data[personParamIdx].phoneNumber;
            this.personParam.receiverPostCode = res.data.data[personParamIdx].postCode;
            this.personParam.receiverProvince = res.data.data[personParamIdx].province;
            this.personParam.receiverCity = res.data.data[personParamIdx].city;
            this.personParam.receiverRegion = res.data.data[personParamIdx].region;
            this.personParam.receiverDetailAddress =
              res.data.data[personParamIdx].detailAddress;
          }else if(time == "first" && personParamIdx == null){
             this.personParam.receiverName = res.data.data[0].name;
            this.personParam.receiverPhone = res.data.data[0].phoneNumber;
            this.personParam.receiverPostCode = res.data.data[0].postCode;
            this.personParam.receiverProvince = res.data.data[0].province;
            this.personParam.receiverCity = res.data.data[0].city;
            this.personParam.receiverRegion = res.data.data[0].region;
            this.personParam.receiverDetailAddress =
              res.data.data[0].detailAddress;
          }
        })
        .catch(err => {});
    },
    selectAddress() {
      //  this.$f7router.navigate(`/addressList/`);
      this.show_address = true;
      this.getAddress();
    },
    //新增地址
    onAdd() {
      let id = 0;
      this.$f7router.navigate(`/addAddress/${id}/`);
      this.show_address = false;
    },
    onEdit(item, index) {
      this.$f7router.navigate(`/addAddress/${item.id}/`);
      this.show_address = false;
    },
    select(item, index) {
      // console.log(item);
      this.personParam.receiverName = item.name;
      this.personParam.receiverPhone = item.phoneNumber;
      this.personParam.receiverPostCode = item.postCode;
      this.personParam.receiverProvince = item.province;
      this.personParam.receiverCity = item.city;
      this.personParam.receiverRegion = item.region;
      this.personParam.receiverDetailAddress = item.detailAddress;
      this.show_address = false;
    },
    // 去掉相同的日期
    distinct(arr) {
      for (let i = 0; i < arr.length; i++) {
        for (let j = i + 1; j < arr.length; j++) {
          if (arr[i].sp1 === arr[j].sp1) {
            arr.splice(j, 1);
            j--;
          }
        }
      }
      return arr;
    }
  },
  mounted() {
    let _this = this;
    let params = this.$f7route.params;
    // console.log(params);
    console.log(this.GLOBAL.carJsonList);
    this.sysCompanyCode = this.GLOBAL.carJsonList[0].sysCompanyCode;
    let skucodes = "";
    this.GLOBAL.carJsonList.forEach((item, index) => {
      skucodes += item.productSkuCode + ",";
      _this.totalPriceShichang += item.quantity * item.price;
      _this.totalPriceGongyi += item.quantity * item.coinPrice;
      _this.totalCoinsGongyi += item.quantity * item.coin;
    });

    this.skucodes = skucodes.substring(0, skucodes.length - 1);
    // console.log(this.skucodes);
    this.getAddress("first");
    window.reload = function() {
      _this.getAddress("first");
    };
    this.toCAmount(1, "first");
    setTimeout(function() {
      _this.getMyCoin();
      _this.totalPrice2 = _this.totalPriceShichang;
    }, 200);
  },
  created() {
    this.isAddress = true;
    this.$commonUtils.setTitle("订单详情");
  }
};
</script>
<style>
.icons {
  display: inline-block;
  width: 11%;
  font-weight: bold;
  text-align: right;
  vertical-align: top;
  padding-top: 3px;
  font-size: 16px;
}
.addressItem {
  display: inline-block;
  margin-left: 10px;
  vertical-align: middle;
  width: 85%;
}

.payStyle_icon {
  position: absolute;
  top: 0px;
  left: 0px;
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
  width: 100%;
  line-height: 66px;
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
.mypages .page-content {
  background-color: #eeeeee;
  display: flex;
  flex-direction: column;
  height: 100%;
}

</style>