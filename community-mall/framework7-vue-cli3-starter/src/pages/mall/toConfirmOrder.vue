<template>
  <f7-page class="bgcg mypages">
    <van-nav-bar class="myNavBare" title="订单详情" left-arrow @click-left="$commonUtils.onClickLeft" />
    <div class="pt-10 bgcg mine">
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
      <template v-if="timeValue != '0'">
        <van-row class="mt-10">
          <!-- <van-col :span="24" @click="show_data = true"> -->
          <van-col :span="24">
            <!-- <van-cell title="服务时间" icon="clock-o" :value="timeValue" is-link style="padding-left:13px" /> -->
            <van-cell
              title="服务时间"
              icon="clock-o"
              :value="this.GLOBAL.orderJson.serve_date"
              style="padding-left:13px"
            />
          </van-col>
        </van-row>
      </template>
      <van-row class="pd-10 mt-10 bgcw">
        <van-col :span="24">
          <p class="pb-10">
            <van-icon name="shop-o" class="v_middle f-18" />
            <span class="ml-10 v_middle">{{this.GLOBAL.orderJson.sysCompanyName}}</span>
          </p>
          <div v-if="this.GLOBAL.orderJson.pic">
            <van-row>
              <van-col :span="4">
                <van-image
                  class="border"
                  width="60px"
                  height="60px"
                  fit="cover"
                  :src="formatImage(this.GLOBAL.orderJson.pic)"
                ></van-image>
              </van-col>
              <van-col :span="20">
                <div class="pd-10 pl-20">
                  <span class="pl-10">{{this.GLOBAL.orderJson.name}}</span>
                  <span class="f-14 c-999">({{this.GLOBAL.orderJson.s1}})</span>
                  <span>x {{this.GLOBAL.orderJson.selectedNum}}</span>
                </div>
              </van-col>
            </van-row>
          </div>
          <div v-else>
            <van-row>
              <van-col :span="24">
                <div class="pd-10 pl-20">
                  <span class="pl-10">{{this.GLOBAL.orderJson.name}}</span>
                  <span class="f-14 c-999">({{this.GLOBAL.orderJson.s1}})</span>
                  <span>x {{this.GLOBAL.orderJson.selectedNum}}</span>
                </div>
              </van-col>
            </van-row>
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
          <van-cell title="代金券" :value="selectedVouchers_name" is-link />
        </van-col>
        <van-col :span="24">
          <van-cell center title="是否使用公益币">
            <span class="mr-20 f-11">可用公益币余额{{coinNum}}</span>
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
      <van-row class="mt-10 bgcw pd-10 mb-20">
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
                  {{totalPriceXianjin}}
                  <!-- <i class="f-11">.00</i> -->
                </span>
              </p>
              <p class="mt-5 c-666 f-14 inlineBlock">
                公益币：
                <span class="c-000 f-16">{{totalCoins}}</span>
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
        v-model="show_data"
        position="bottom"
        :style="{ height: '80%' }"
        round
        style="background:#eee"
      >
        <span class="text">选择时间</span>
        <van-tabs v-model="activeTab" @click="tabclick">
          <van-tab v-for="(item,index) in data_array2" :title="formatDate(item.sp1)">
            <div class="pt-10">
              <span
                class="time_item"
                v-for="(time,pos) in data_array3"
                v-if="item.sp1 == time.timeData && activeTab == index"
                @click="selectTime(pos)"
                :class="{timeItem:pos === current}"
              >{{time.sp2}}</span>
            </div>
            <van-button class="fixedBottom" color="#f00" size="large" @click="sureTime">确定选择</van-button>
          </van-tab>
        </van-tabs>
      </van-popup>
      <van-popup v-model="show_address" position="bottom" :style="{ height: '60%' }" round>
          <div class="pd-10 text-c">
          <p class="c-999">——请选择收货地址——</p>
        </div>
        <div>
          <van-address-list
            v-model="chosenAddressId"
            :list="list"
            :default-tag-text="defaultTagText"
            @edit="onEdit"
            @add="onAdd"
            @select="select"
          />
        </div>
      </van-popup>
      <van-popup
        v-model="show_vouchers"
        position="bottom"
        round
        :style="{ height: '60%' }"
        class="bgcg"
      >
        <div>
          <div v-if="vouchersList == undefined  || vouchersList.length <= 0" class="pd-10 text-c">
            <p class="c-999 tc">——暂无可使用的代金券——</p>
          </div>
          <div v-else class="pd-10 tc">
            <p class="pd-10 c-999 tc">——可使用的优惠券——</p>
            <div class>
              <van-row v-for="(item,index) in vouchersList" class="bgcw pd-10 border-radius5 mt-10">
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
                      @click="tabVouchers(item.id,item.coupon.name,item)"
                    >使用</van-button>
                    <!-- <van-button round size="normal" v-show="item.useStatus == 1" class="c-999">已使用</van-button> -->
                  </div>
                </van-col>
              </van-row>
            </div>
          </div>
        </div>
      </van-popup>
    </div>
    <van-submit-bar
      :price="priceDuc(totalPrice)"
      button-text="提交订单"
      @submit="submitOrder"
      v-show="isAddress"
      style="position:static"
    />
  </f7-page>
</template>
<script>
import { Toast } from "vant";
import {
  goodsDetailSku,
  goodsDetail,
  cAmount,
  userCoin,
  useVouchers,
  myuseVouchers,
  receiveVouchers,
  gotVouchers,
  sumitMyorder,
  addressList
} from "@/api/api_mall.js";
export default {
  data() {
    return {
      defaultTagText:"默认",
      current: -1,
      activeTab: 0,
      id: "",
      number: null,
      title: "",
      textTitle: "",
      timeValue: "",
      date_id: "",
      areaCode: "",
      checkedCoin: false,
      disabledCoin: false,
      show_data: false,
      show_address: false,
      show_payStyle: false,
      show_vouchers: false,
      my_radio: 0,
      data_array2: [], //日期数组
      data_array3: [], //时间数组

      totalPrice: 0,
      totalPrice2: 0,
      totalPriceXianjin: 0,
      totalPriceShichang: 0,
      totalCoins: 0, //公益价所需公益币
      coinNum: null, // 我的公益币余额
      rescoin: "", //提交到支付页面的公益币数量

      isorder: false,
      selectedVouchers_id: "",
      selectedVouchers_name: "",
      personParam: {
        receiverName: "",
        receiverPhone: "",
        receiverPostCode: "",
        receiverProvince: "",
        receiverCity: "",
        receiverRegion: "",
        receiverDetailAddress: "",
        buyerNote: "",
        useCoin: ""
      },
      chosenAddressId: "1",
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
    substringDate(time) {
      return time.substring(0, 10);
    },
    //格式化图片路径
    formatImage(url) {
      return this.$commonUtils.formatPicture(url);
    },
    //获取商品详情
    async getGoodsDetail() {
      let res = await goodsDetail({ productId: this.id });
      this.title = res.data.data.name;
      this.textTitle = res.data.data.name + " x " + this.number;
    },
    //获取商品sku
    async getGoodsSku() {
      let res = await goodsDetailSku({ productId: this.id });
      let _this = this;
      res.data.data.forEach((item, index) => {
        item.sp1 = item.sp1.replace(/^(\d{4})(\d{2})(\d{2})$/, "$1-$2-$3");
        _this.data_array2.push(item);
        item.timeData = item.sp1;
      });
      _this.data_array2 = _this.distinct(_this.data_array2);
      _this.data_array3 = res.data.data;
    },
    selectTime(index) {
      this.current = index;
      this.date_id = this.data_array3[index].skuCode;
    },
    tabclick() {
      this.current = -1;
    },
    sureTime() {
      let current = this.current;
      if (this.current == -1) {
        Toast("请选择服务时间");
        return;
      }
      // console.log(this.data_array3[this.current].sp1 ,this.data_array3[this.current].sp2)
      this.serve_date =
        this.data_array3[this.current].sp1 + this.data_array3[this.current].sp2;
      this.show_data = false;
      this.toCAmount();
    },
    //获取公益按钮的状态
    getchecked() {
      if (this.checkedCoin) {
        this.toCAmount(1, "second");
        this.personParam.useCoin = 1;
      } else {
        this.toCAmount(0, "second");
        this.personParam.useCoin = 0;
      }
    },
    clickchecked() {
      if (this.coinNum && this.coinNum >= Number(this.totalCoins)) {
        this.disabledCoin = false;
      } else if (
        this.coinNum == 0 ||
        this.coinNum == null ||
        this.coinNum == "null"
      ) {
        Toast("您的公益币不足");
        this.coinNum = 0;
        this.disabledCoin = true;
      } else {
        this.disabledCoin = true;
        Toast("您的公益币不足");
      }
    },
    //计算金额
    toCAmount(isUse, time) {
      let _this = this;
      // if (this.checkedCoin) this.checkedCoin = 1;
      // else this.checkedCoin = 0;
      let param = {
        productSkuCode: this.date_id,
        quantity: this.number,
        couponId: "",
        couponHistoryId: this.selectedVouchers_id,
        useCoin: isUse,
        appointTime: this.GLOBAL.orderJson.serve_date
      };
      cAmount(param)
        .then(res => {
          if (res.data.message == "库存不足，无法下单") {
            _this.isorder = true;
          }
          if (isUse == 1 && time == "first") {
            //公益币总计
            _this.totalPriceXianjin = res.data.data.payAmount;
            _this.totalCoins = res.data.data.coin;
            _this.rescoin = res.data.data.coin;
          } else if (isUse == 0 && time == "first") {
            //现金总计
            _this.totalPriceShichang = res.data.data.payAmount;
            _this.totalPrice = res.data.data.payAmount;
            _this.rescoin = 0;
          } else if (isUse == 1 && time == "second") {
            //点击使用公益币 使用
            _this.totalPrice = res.data.data.payAmount;
            _this.totalCoins = res.data.data.coin;
            _this.rescoin = res.data.data.coin;
          } else if (isUse == 0 && time == "second") {
            //点击使用公益币 不使用
            // _this.totalPrice = _this.totalPriceShichang;
            _this.totalPrice = res.data.data.payAmount;
            _this.rescoin = 0;
          } else if (isUse == 0 && time == "third") {
            //点击使用优惠券 不使用公益币
            _this.totalPrice = res.data.data.payAmount;
            _this.rescoin = 0;
          } else if (isUse == 1 && time == "third") {
            //点击使用优惠券 使用公益币
            _this.totalPrice = res.data.data.payAmount;
            _this.totalCoins = res.data.data.coin;
            _this.rescoin = res.data.data.coin;
          }
        })
        .catch(err => {});
    },
    priceDuc(price) {
      return price * 100;
    },
    //提交订单
    submitOrder() {
      let _this = this;
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
      let param2 = {
        productSkuCode: this.date_id,
        quantity: this.number,
        couponId: "",
        couponHistoryId: this.selectedVouchers_id,
        appointTime: this.GLOBAL.orderJson.serve_date
      };
      let param = JSON.parse(
        (JSON.stringify(param2) + JSON.stringify(this.personParam)).replace(
          /}{/,
          ","
        )
      );
      // console.log(param);
      // console.log(this.totalPrice, this.rescoin);
      // return;
      sumitMyorder(param)
        .then(res => {
          let usecoin = 0;
          let orderSn = res.data.data.order.orderSn;
          if (_this.checkedCoin) {
            //选择使用公益币
            usecoin = _this.rescoin;
          } else {
            //未选择使用公益币
            usecoin = 0;
          }
          this.$f7router.navigate(
            `/payStyle/forceClose/${_this.totalPrice}/${orderSn}/${usecoin}/`
          );
        })
        .catch(err => {
          this.$commonUtils.jumpLogin(err);
        });
    },
    //是否使用代金券
    isVouchers() {
      this.show_vouchers = true;
    },
    //获取可用的代金券
    getVouchers() {
      let param = {
        productSkuCode: this.date_id,
        quantity: this.number
      };
      myuseVouchers(param)
        .then(res => {
          this.vouchersList = res.data.data;
        })
        .catch(err => {});
    },
    tabVouchers(id, name, item) {
      this.selectedVouchers_id = id;
      this.selectedVouchers_name = name;
      // console.log(this.checkedCoin);
      if (this.checkedCoin) {
        this.toCAmount(1, "third");
      } else {
        this.toCAmount(0, "third");
      }

      this.show_vouchers = false;
      // console.log(id, this.selectedVouchers_id);
      if (id == this.selectedVouchers_id) {
        item.useStatus = 1;
      } else {
        item.useStatus = 0;
      }
    },

    //获取我的公益币余额
    getMyCoin() {
      userCoin({ areaCode: this.areaCode })
        .then(res => {
          // res.data.data = null
          this.coinNum = res.data.data;
          // console.log(res.data.data, Number(this.totalCoins));
          if (res.data.data && res.data.data >= Number(this.totalCoins)) {
            this.disabledCoin = true;
          } else if (
            res.data.data == 0 ||
            res.data.data == null ||
            res.data.data == "null"
          ) {
            this.disabledCoin = true;
            this.coinNum = 0;
          } else {
            this.disabledCoin = true;
          }
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
    },
    // 格式化日期
    formatDate(date) {
      let dates = date.replace(/^(\d{2})(\d{2})$/, "$1-$2");
      let dates2 = this.weekDay(dates);
      dates = dates.slice(5);
      return dates + "(" + dates2 + ")";
    },
    weekDay(date) {
      var dt = new Date(
        date.split("-")[0],
        date.split("-")[1] - 1,
        (date = date.split("-")[2])
      );
      var weekDay = [
        "星期天",
        "星期一",
        "星期二",
        "星期三",
        "星期四",
        "星期五",
        "星期六"
      ];
      return weekDay[dt.getDay()];
    }
  },
  mounted() {
    console.log(this.GLOBAL.orderJson);
    var params = this.$f7route.params;
    let _this = this;
    // console.log(params);
    if (params.id != null && params.id.length > 0) {
      this.id = params.id;
      this.number = params.num;
      this.timeValue = params.serve_date;
      this.date_id = params.date_id;
      this.areaCode = params.areaCode;
      this.totalCoins = params.coinNum;
      this.getGoodsSku();
      this.getGoodsDetail();
      this.toCAmount(0, "first");
      this.toCAmount(1, "first");
      setTimeout(function() {
        _this.getMyCoin();
      }, 200);
      this.getAddress("first");
      window.reload = function() {
        _this.getAddress("first");
      };
      this.getVouchers();
    }
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
.van-cell__left-icon {
  margin-right: 10px;
}
.payStyle_icon {
  position: absolute;
  top: 0px;
  left: 0px;
}
.mypages .page-content {
  display: flex;
  flex-direction: column;
  height: 100%;
}
</style>