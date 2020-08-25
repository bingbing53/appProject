<template>
  <f7-page class="bgcg detailGoods">
    <div class="mine">
      <van-tabs v-model="active" scrollspy sticky class="my_detail">
        <van-tab title="商品">
          <van-icon name="arrow-left" class="my_coin2 bgcw" @click="$commonUtils.onClickLeft" />
          <div class="pg-10 bgcw">
            <f7-swiper class="my_swiper" pagination>
              <f7-swiper-slide v-for="(item,index) in swiperList">
                <div style="width:100%">
                  <img :src="formatImage(item)" alt style="width:100%;transform:scale(1)" />
                </div>
              </f7-swiper-slide>
            </f7-swiper>
          </div>
          <div class="pl-10 pr-10 pt-10 border-radius8 bgcw">
            <van-row>
              <van-col :span="20">
                <b class="f-16 pt-10">{{goodsDes.name}}</b>
              </van-col>
              <van-col :span="4">
                <div class="tagShare" @click="toShare">
                  <img src="@/assets/share.png" alt width="14px" class="v_middle" />
                  <span class="f-13 c-666 ml-5">分享</span>
                </div>
              </van-col>
            </van-row>
            <p class="pt-10 pb-10 c-666 f-14">{{goodsDes.description}}</p>
            <div class="pr-10 pb-10">
              <p class="f-14 c-999 mb-10">
                市场价:
                <i class="f-12 c-red">￥</i>
                <span class="c-red f-18">{{goodsDes.price}}</span>
              </p>
              <p class="f-14 c-999">
                公益价:
                <i class="f-12 c-red">￥</i>
                <span class="c-red f-18">{{goodsDes.coinPrice}} + {{goodsDes.coin}}公益币</span>
                <span class="collected" @click="ungoodsCollect()" v-if="toCollect == 1">已收藏</span>
                <span class="collect f-14 c-000" @click="goodsCollect()" v-if="toCollect == 0">收藏</span>
              </p>
            </div>
          </div>
          <div class="pd-10 mt-10 mb-10 bgcw border-radius8">
            <p class="f-14" @click="isShowDate">
              <span>服务时间</span>
              <span v-if="serve_date != ''" class="fr f-14 c-999 mr-15">{{serve_date}}</span>
              <span v-else class="fr f-14 c-999 mr-15">
                <van-icon name="arrow" color="#969799" />
              </span>
            </p>
          </div>
        </van-tab>
        <van-tab title="优惠">
          <div class="pd-10 mt-10 mb-10 bgcw border-radius8">
            <p class="f-14 pb-10 borderScale" @click="isvolunters()">
              <span>代金券</span>
              <span v-if="useVouchersNum != 0" class="fr f-14 c-999 mr-15">
                {{useVouchersNum}} /
                <i class="c-333">{{usedVouchersNum}}</i>
              </span>
              <span v-else class="fr f-14 c-999 mr-15">
                <van-icon name="arrow" color="#969799" />
              </span>
            </p>
            <div class="f-14 pt-10">
              <span>服务保证</span>
              <div class="pt-10">
                <template v-for="Ids in goodsDes.serviceIds">
                  <span class="baozheng" v-if="Ids == '1'">无忧退货</span>
                  <span class="baozheng" v-else-if="Ids == '2'">快速退款</span>
                  <span class="baozheng" v-else-if="Ids == '3'">免费包邮</span>
                  <span class="baozheng" v-else-if="Ids == '4'">爽约、未服务全额退款</span>
                  <span class="baozheng" v-else-if="Ids == '5'">不满意免费再服务</span>
                </template>
              </div>
            </div>
          </div>
        </van-tab>
        <van-tab title="评论">
          <div class="mb-10 pb-20 bgcw border-radius8">
            <p class="f-16 pl-10 pt-10">
              <span>用户评论:</span>
            </p>
            <p
              v-if="commentList.length == 0"
              class="tc c-999"
              style="padding-bottom:80px;padding-top:20px"
            >暂无评论...</p>
            <div v-else>
              <van-image-preview
                v-model="showImage"
                :startPosition="startIndex"
                :loop="false"
                :images="perimageArrmy"
                :showIndex="true"
              ></van-image-preview>
              <f7-list media-list style="z-index:0;font-size:14px!important;margin-top:10px">
                <f7-list-item
                  class="my_item"
                  :title="item.name"
                  :subtitle="substringDate(item.date)"
                  v-for="(item,index) in commentList"
                >
                  <div>
                    <p class="mb-5">
                      <van-rate
                        color="#ee0a24"
                        :size="16"
                        void-icon="star"
                        void-color="#eee"
                        v-model="item.comment"
                        readonly
                      />
                    </p>
                    <p v-if="item.content">{{item.content}}</p>
                    <p v-else>该买家没有评价文字.....</p>
                    <div class="commitImage mt-10">
                      <template v-if="item.pics && item.pics.length >0">
                        <div>
                          <van-image
                            :src="formatImage(image)"
                            alt
                            width="80px"
                            height="80px"
                            fit="cover"
                            v-for="(image,ppp) in item.pics"
                            class="mr-5"
                            @click="previewImgmy(item.pics,ppp)"
                          />
                        </div>
                      </template>
                    </div>
                  </div>
                  <img
                    v-if="item.url"
                    :src="formatImage(item.url)"
                    style="width: 40px; height: 40px; border-radius: 50%;border:1px solid #eee"
                    slot="media"
                  />
                  <img
                    v-else
                    src="@/assets/people.png"
                    style="width: 40px; height: 40px; border-radius: 50%;border:1px solid #eee"
                    slot="media"
                  />
                </f7-list-item>
              </f7-list>
              <van-row>
                <van-col span="9" offset="8">
                  <van-button
                    round
                    plain
                    hairlin
                    size="normal"
                    type="default"
                    @click="allComments"
                  >查看全部评论</van-button>
                </van-col>
              </van-row>
            </div>
          </div>
        </van-tab>
        <van-tab title="详情">
          <div class="pd-20 tc c-666 mb-20">—— 商品详情 ——</div>
          <div class="bgcw border-radius8">
            <van-image-preview
              v-model="showImageDetail"
              startPosition="0"
              :images="perimageArrDetail"
              :showIndex="false"
            ></van-image-preview>
            <p
              class="detailHtml"
              style="letter-spacing:2px;line-height:24px;padding-bottom:80px;"
              v-html="goodsDes.detailMobileHtml"
              @click="getInner($event)"
            ></p>
          </div>
        </van-tab>
      </van-tabs>
      <van-sku
        class="mySkuButton"
        v-model="showSku"
        :sku="sku"
        :goods="goods"
        :goods-id="goodsId"
        :quota-used="quota_used"
        :properties="sku.properties"
        :custom-stepper-config="customStepperConfig"
        :start-sale-num="start_num"
        @buy-clicked="onBuyClicked"
      />
      <van-popup
        v-model="show_data"
        position="bottom"
        :style="{ height: '80%',width:'100%' }"
        round
        style="background:#eee"
        class="bgcg"
      >
        <div class="f-12 bgcw text">
          <p class="f-20 c-000">
            <span>选择时间</span>
          </p>
        </div>
        <van-tabs v-model="activeTab" @click="tabclick">
          <van-tab v-for="(item,index) in data_array2" :title="formatDate(item)">
            <div class="pt-10 pd-10">
              <span v-for="(time,pos) in data_array3" @click="selectTime(pos)">
                <!-- {{currentTime}}===={{ time.compareMins}} -->
                <template v-if="time.hours <= 9">
                  <i v-if="index == 0 && time.compareMins <= currentTime" style="display:none">
                    <template v-if="time.mins == 0">0{{time.hours}}:00</template>
                    <template v-else>{{time.hours}}:{{time.mins}}</template>
                  </i>
                  <!-- 显示 -->
                  <i class="time_item" :class="{timeItem:pos === current}" v-else>
                    <template v-if="time.mins == 0">0{{time.hours}}:00</template>
                    <template v-else>0{{time.hours}}:{{time.mins}}</template>
                  </i>
                </template>
                <template v-else>
                  <!-- 隐藏 -->
                  <i v-if="index == 0 && time.compareMins <= currentTime" style="display:none">
                    <template v-if="time.mins == 0">{{time.hours}}:00</template>
                    <template v-else>{{time.hours}}:{{time.mins}}</template>
                  </i>
                  <!-- 显示 -->
                  <i class="time_item" :class="{timeItem:pos === current}" v-else>
                    <template v-if="time.mins == 0">{{time.hours}}:00</template>
                    <template v-else>{{time.hours}}:{{time.mins}}</template>
                  </i>
                </template>
              </span>
            </div>
            <div class="c-waring f-13 pl-20 pr-20 fixedBottomButton">
              <van-icon name="warning-o v_middle mr-5" />
              <span>由于交通等原因，服务人员实际上门时间可能存在30分钟以内偏差</span>
              <van-button class="mt-10" color="#f00" size="large" @click="sureTime(item,index)">确定选择</van-button>
            </div>
          </van-tab>
        </van-tabs>
      </van-popup>
      <van-popup
        v-model="show_volunters"
        position="bottom"
        :style="{ height: '70%' }"
        round
        class="bgcg"
      >
        <div v-if="myVouchers == undefined  || myVouchers.length <= 0" class="pd-10 text-c">
          <span class="c-999">——暂无可领取的代金券——</span>
        </div>
        <div v-else>
          <div class="pd-10 text-c">
            <span class="c-999">——可领取的代金券——</span>
          </div>
          <van-row class="bgcw pd-10 mg-10 border-radius5" v-for="(item,index) in myVouchers">
            <van-col span="6">
              <div class="left_price">
                ￥
                <span class="mr-10">{{item.amount}}</span>
              </div>
            </van-col>
            <van-col span="12" class="center_content_out">
              <div class="center_content">
                <h4 class="mb-10">{{item.name}}</h4>
                <p>{{item.note}}</p>
                <p>{{substringDate(item.startTime)}} 至 {{substringDate(item.endTime)}}</p>
              </div>
            </van-col>
            <van-col span="6">
              <div class="right_button">
                <van-button
                  round
                  size="normal"
                  v-show="item.getable == 1"
                  class="baco c-fff"
                  @click="tabVouchers(item.id)"
                >领取</van-button>
                <van-button round size="normal" v-show="item.getable == 0" class="c-999">已领取</van-button>
              </div>
            </van-col>
          </van-row>
        </div>
      </van-popup>
    </div>
    <van-goods-action style="position:static" v-show="showBottom">
      <!-- <van-goods-action-icon icon="phone-o" text="电话" /> -->
      <van-goods-action-icon icon="service-o" text="客服" @click="service" />
      <van-goods-action-icon icon="shop-o" text="店铺" @click="enterStore" />
      <van-goods-action-button type="danger" @click="tuBuy" text="立即购买" />
    </van-goods-action>
  </f7-page>
</template>
<script>
import { Toast } from "vant";
import https from "@/api/https.js";
import { isFocused, addFocus, delFocus } from "@/api/api_common.js";
import {
  goodsDetail,
  goodsDetailSku,
  useVouchers,
  receiveVouchers,
  genOrder,
  goodsTypes,
  productCommuntList,
  goodsUseDate,
  toService
} from "@/api/api_mall.js";
export default {
  data() {
    return {
      showBottom: true,
      //图片预览
      showImage: false,
      perimageArrmy: [],
      startIndex: 0,

      //详情图片预览
      showImageDetail: false,
      perimageArrDetail: [],
      active: 0,
      current: -1,
      activeTab: 0,
      id: "",
      title: "",
      my_stock: 0,
      // min_stock: 0,
      // vaule: 1,
      usedVouchersNum: 0,
      useVouchersNum: 0,
      commentList: [],
      swiperList: [],
      swiperDes: "",
      goodsDes: {},
      goodsTypeList: [],
      showSku: false,
      goodsId: "946755",
      // quota: 15, //限购数量
      quota_used: 0, //已经购买过的数量
      currentTime: 0,
      start_num: 1,
      sku: {
        tree: [],
        // 所有 sku 的组合列表，比如红色、M 码为一个 sku 组合，红色、S 码为另一个组合
        list: [],
        price: "", // 默认价格（单位元）
        stock_num: 0, // 商品总库存
        collection_id: "", // 无规格商品 skuId 取 collection_id，否则取所选 sku 组合对应的 id
        none_sku: false, // 是否无规格商品
        hide_stock: false // 是否隐藏剩余库存
      },
      goods: {
        title: "",
        picture: "",
        price: ""
      },
      serve_date: "",
      isBottom: true,
      show_data: false,
      show_volunters: false,
      data_array2: [], //日期数组
      data_array3: [], //时间数组
      data_id: "",
      areaCode: "",
      coinNum: "",
      toCollect: null,
      myVouchers: [],
      customStepperConfig: {
        quotaText: "",
        stockFormatter: stock => `剩余${stock}件`,
        handleOverLimit: data => {
          const { action, limitType, quota, startSaleNum = 1 } = data;
          if (action === "minus") {
            this.$toast(
              startSaleNum > 1 ? `${startSaleNum}件起售` : "至少选择一件商品"
            );
          } else if (action === "plus") {
            if (limitType === LIMIT_TYPE.QUOTA_LIMIT) {
              this.$toast(`限购${quota}件`);
            } else {
              this.$toast("库存不够了");
            }
          }
        }
      }
    };
  },
  watch: {
    showImageDetail(newName, oldName) {
      if (newName) {
        this.showBottom = false;
      } else {
        this.showBottom = true;
      }
    },
    showImage(newName, oldName) {
      if (newName) {
        this.showBottom = false;
      } else {
        this.showBottom = true;
      }
    },
    showSku(newName, oldName) {
      if (newName) {
        this.showBottom = false;
      } else {
        this.showBottom = true;
      }
    },
    show_data(newName, oldName) {
      if (newName) {
        this.showBottom = false;
      } else {
        this.showBottom = true;
      }
    },
    show_volunters(newName, oldName) {
      if (newName) {
        this.showBottom = false;
      } else {
        this.showBottom = true;
      }
    },
  },
  methods: {
    substringDate(time) {
      return time.substring(0, 10);
    },
    //格式化图片路径
    formatImage(url) {
      return this.$commonUtils.formatPicture(url);
    },
    //分享
    toShare() {
      let title = this.goodsDes.name;
      let posterUrl = this.formatImage(this.goodsDes.pic);
      let content = this.goodsDes.description;
      wx.share({
        picture: posterUrl,
        title: title,
        des: content
      });
    },
    //图片预览
    previewImgmy(img, index) {
      this.perimageArrmy = [];
      let _this = this;
      this.showImage = true;
      this.startIndex = index;
      img.forEach((item, index2) => {
        item = _this.formatImage(item, 1);
        _this.perimageArrmy.push(item);
      });
      // console.log(this.perimageArrmy);
    },
    //获取点击的dom内容
    getInner(e) {
      this.perimageArrDetail = [];
      if (e.target.nodeName == "IMG") {
        this.showImageDetail = true;
        this.perimageArrDetail.push(e.target.currentSrc);
      }
    },
    selectTime(index) {
      this.current = index;
      // console.log(this.data_array3[index]);
    },
    tabclick() {
      this.my_stock = null;
      // console.log("----" + this.my_stock);
      this.current = -1;
    },
    sureTime(item, index) {
      if (!this.data_array3[this.current]) {
        Toast("请选择服务时间");
      } else {
        if (this.data_array3[this.current].mins == 0) {
          this.serve_date =
            item + " " + this.data_array3[this.current].hours + ":00";
        } else {
          this.serve_date =
            item +
            " " +
            this.data_array3[this.current].hours +
            ":" +
            this.data_array3[this.current].mins;
        }
        this.show_data = false;
        this.showBottom = true;
      }
    },
    //点击代金券
    isvolunters() {
      this.show_volunters = true;
      this.showBottom = false;
      this.getVouchers();
    },

    //获取可用的代金券
    getVouchers() {
      useVouchers({ productId: this.id })
        .then(res => {
          this.myVouchers = res.data.data;
          let myVouchersNum = 0;
          if (res.data.data.length != 0) {
            res.data.data.forEach((item, index) => {
              if (item.getable == 0) {
                myVouchersNum++;
              }
            });
            this.useVouchersNum = myVouchersNum;
            this.usedVouchersNum = res.data.data.length;
          } else {
          }
        })
        .catch(err => {});
    },
    //领取代金券
    tabVouchers(id) {
      let param = {
        couponId: id,
        productId: this.id
      };
      receiveVouchers(param)
        .then(res => {
          if (res.data.code == 200) {
            this.show_volunters = false;
            this.showBottom = true;
          }
        })
        .catch(err => {});
    },
    //收藏商品
    isCollect() {
      let _this = this;
      let res = isFocused("31", this.id)
        .then(res => {
          _this.toCollect = res.data.collect;
        })
        .catch(err => {});
    },
    goodsCollect() {
      let res = addFocus("31", this.id);
      this.toCollect = 1;
    },
    ungoodsCollect() {
      let res = delFocus("31", this.id);
      this.toCollect = 0;
    },
    //联系客服
    service() {
      toService({ companyCode: this.goodsDes.sysOrgCode })
        .then(res => {
          // if (res.data.data) {
          wx.contact({
            username: res.data.data
          });
          // }
        })
        .then(err => {});
    },
    //进入店铺
    enterStore() {
      this.$f7router.navigate(`/enter-store/${this.goodsDes.sysOrgCode}/`);
    },
    // 获取服务商品的可预约时间
    getServerDates() {
      goodsUseDate({ productId: this.id })
        .then(res => {
          res.data.data.forEach((item, index) => {
            item.mins = (Number(item.value) * 30) % 60;
            item.hours = parseInt((Number(item.value) * 30) / 60);
            item.compareMins = Number(item.value) * 30;
          });
          this.data_array3 = res.data.data;
        })
        .catch(err => {});
    },
    //获取商品详情
    async getGoodsDetail() {
      let res = await goodsDetail({ productId: this.id });
      if (res.data.data.serviceIds) {
        res.data.data.serviceIds = res.data.data.serviceIds.split(",");
      }
      this.goodsDes = res.data.data;
      this.title = res.data.data.name;
      this.areaCode = res.data.data.areaCode;
      this.coinNum = res.data.data.coin;
      res.data.data.albumPics =
        res.data.data.pic + "," + res.data.data.albumPics;
      this.swiperList = res.data.data.albumPics.split(",");
      //赋值默认sku
      this.sku.price = res.data.data.price;
      // this.sku.stock_num =
      //   Number(res.data.data.stock) - Number(res.data.data.lowStock);
      this.collection_id = res.data.data.id;
      this.goods.title = res.data.data.name;
      this.goods.picture = this.formatImage(res.data.data.pic);
      this.goods.price = res.data.data.price;
      if (
        res.data.data.minBuyQuantity &&
        res.data.data.minBuyQuantity != 0 &&
        res.data.data.minBuyQuantity != null
      ) {
        this.start_num = res.data.data.minBuyQuantity;
      } else {
        this.start_num = 1;
      }
      this.getGoodsType();
    },
    //获取商品sku分类
    getGoodsType() {
      let params = {
        productAttributeCategoryId: this.goodsDes.productAttributeCategoryId
      };
      let _this = this;
      goodsTypes(params)
        .then(res => {
          res.data.data.forEach((item, index) => {
            _this.goodsTypeList.push({ name: item.name });
          });
          _this.getGoodsSku();
        })
        .catch(err => {});
    },
    //获取商品sku
    async getGoodsSku() {
      let res = await goodsDetailSku({ productId: this.id });
      res.data.data.forEach((item, index) => {
        this.sku.stock_num += parseInt(item.stock);
        item.s1 = item.sp1;
        item.s2 = item.sp2;
        item.s3 = item.sp3;
        item.goods_id = item.productId;
        item.stock_num = item.stock - item.lockStock;
        item.imgUrl = this.formatImage(item.pic);
        item.previewImgUrl = this.formatImage(item.pic);
        item.price = item.price * 100;
      });
      // console.log(this.goodsTypeList);
      this.sku.list = res.data.data;
      let sp1_arr = [];
      let sp2_arr = [];
      let sp3_arr = [];
      this.sku.list.forEach((item, index) => {
        sp1_arr.push({
          s1: item.s1,
          imgUrl: item.pic,
          previewImgUrl: item.pic
        });
        sp2_arr.push(item.s2);
        sp3_arr.push(item.s3);
      });
      this.formatArr(sp1_arr, sp2_arr, sp3_arr);
    },
    formatArr(arr1, arr2, arr3) {
      let _this = this;
      let arr_1 = [];
      let arr_2 = [];
      let arr_3 = [];
      if (!arr1.includes(null)) {
        arr1 = this.$commonUtils.uniqueArray(arr1, "s1");
        arr1.forEach((item, index) => {
          let json = {};
          json.id = item.s1;
          // json.id = item;
          // json.name = item;
          json.name = item.s1;
          json.imgUrl = _this.formatImage(item.imgUrl);
          json.previewImgUrl = _this.formatImage(item.previewImgUrl);
          arr_1.push(json);
        });
      }
      if (!arr2.includes(null)) {
        arr2 = Array.from(new Set(arr2));
        arr2.forEach((item, index) => {
          let json = {};
          json.id = item;
          json.name = item;
          json.imgUrl = "";
          arr_2.push(json);
        });
      }
      if (!arr3.includes(null)) {
        arr3 = Array.from(new Set(arr3));
        arr3.forEach((item, index) => {
          let json = {};
          json.id = item;
          json.name = item;
          json.imgUrl = "";
          arr_3.push(json);
        });
      }
      if (this.goodsTypeList.length > 0 && this.goodsTypeList.length == 1) {
        _this.sku.tree.push({
          k: this.goodsTypeList[0].name,
          v: arr_1,
          k_s: "s1"
        });
      } else if (
        this.goodsTypeList.length > 0 &&
        this.goodsTypeList.length == 2
      ) {
        _this.sku.tree.push(
          { k: this.goodsTypeList[0].name, v: arr_1, k_s: "s1" },
          { k: this.goodsTypeList[1].name, v: arr_2, k_s: "s2" }
        );
      } else if (
        this.goodsTypeList.length > 0 &&
        this.goodsTypeList.length == 3
      ) {
        this.sku.tree.push(
          { k: this.goodsTypeList[0].name, v: arr_1, k_s: "s1" },
          { k: this.goodsTypeList[1].name, v: arr_2, k_s: "s2" },
          { k: this.goodsTypeList[2].name, v: arr_3, k_s: "s3" }
        );
      } else {
      }
      // console.log(JSON.stringify(this.sku.tree));
    },
    //点击立即购买弹出sku选择框
    tuBuy() {
      if (this.serve_date == "") {
        Toast("请选择服务时间");
        return;
      } else {
        this.showSku = true;
        this.showBottom = false;
        this.$forceUpdate();
      }
    },
    //点击购买
    onBuyClicked(sku) {
      // console.log(sku)
      // return
      let buyNumber = sku.selectedNum;
      let skuCode = sku.selectedSkuComb.skuCode;
      let serve_date = 0;
      // console.log(
      //   this.id,
      //   buyNumber,
      //   serve_date,
      //   skuCode,
      //   this.areaCode,
      //   this.coinNum
      // );
      this.GLOBAL.orderJson = {
        selectedNum: sku.selectedNum,
        skuCode: sku.selectedSkuComb.skuCode,
        price: sku.selectedSkuComb.price,
        pic: sku.selectedSkuComb.pic,
        coin: sku.selectedSkuComb.coin,
        s1: sku.selectedSkuComb.s1,
        areaCode: this.areaCode,
        name: this.title,
        serve_date: this.serve_date,
        sysCompanyName: this.goodsDes.sysCompanyName
      };
      this.showSku = false;
      this.showBottom = true;
      // console.log(
      //   `/toConfirmOrder/forceClose/${this.id}/${buyNumber}/${serve_date}/${skuCode}/${this.areaCode}/${this.coinNum}/`
      // );
      // return
      this.$f7router.navigate(
        `/toConfirmOrder/forceClose/${this.id}/${buyNumber}/${serve_date}/${skuCode}/${this.areaCode}/${this.coinNum}/`
      );
    },
    //获取商品评论数据
    getCommitList() {
      this.commentList = [];
      let param = {
        productId: this.id,
        pageSize: 10,
        pageNum: 1,
        star: "all"
      };
      let _this = this;
      productCommuntList(param)
        .then(res => {
          //  console.log(res);
          res.data.data.list.forEach((item, index) => {
            if (index < 3) {
              item.url = item.userHeadimage;
              item.comment = item.star;
              item.name = item.userName;
              item.date = item.createTime;
              if (item.pics && item.pics != "" && item.pics != null) {
                item.pics = item.pics.split(",");
                item.pics2 = item.pics;
              }
              _this.commentList.push(item);
            }
          });
        })
        .catch(err => {});
    },

    //查看全部评论
    allComments() {
      this.$f7router.navigate(`/commentList/${this.id}/`);
    },
    //弹出日期选择
    isShowDate() {
      this.show_data = true;
      this.showBottom = false;
      this.getCurrentDate();
    },
    //获取当前日期年月日和未来一周日期
    getCurrentDate() {
      //今天
      let day0 = this.getDay(0);
      //后七天
      let day1 = this.getDay(1);
      let day2 = this.getDay(2);
      let day3 = this.getDay(3);
      let day4 = this.getDay(4);
      let day5 = this.getDay(5);
      let day6 = this.getDay(6);
      this.data_array2 = [day0, day1, day2, day3, day4, day5, day6];
    },
    // 格式化日期
    formatDate(date) {
      // let dates = date.replace(/^(\d{2})(\d{2})$/, "$1-$2");
      let dates = date;
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
    },
    doHandleMonth(month) {
      var m = month;
      if (month.toString().length == 1) {
        m = "0" + month;
      }
      return m;
    },
    getDay(day) {
      var today = new Date();
      var targetday_milliseconds = today.getTime() + 1000 * 60 * 60 * 24 * day;
      today.setTime(targetday_milliseconds); //注意，这行是关键代码
      var tYear = today.getFullYear();
      var tMonth = today.getMonth();
      var tDate = today.getDate();
      tMonth = this.doHandleMonth(tMonth + 1);
      tDate = this.doHandleMonth(tDate);
      return tYear + "-" + tMonth + "-" + tDate;
    }
  },
  mounted() {
    let _this = this;
    var params = this.$f7route.params;
    if (params.id != null && params.id.length > 0) {
      this.id = params.id;
      setTimeout(function() {
        // _this.getMyCoin();
      }, 500);
      this.getGoodsDetail();

      this.isCollect();
      this.getCommitList();
      this.getServerDates();
      this.getVouchers();
    }
  },
  created() {
    //获取当前时间
    let getMinutes = new Date().getMinutes();
    let gethours = new Date().getHours();
    this.currentTime = gethours * 60 + getMinutes;

    this.$commonUtils.setTitle("服务详情");
  }
};
</script>

<style>
.my_swiper {
  height: 260px;
  background: #fff;
}
.collect {
  display: inline-block;
  border: 1px solid #666;
  border-radius: 5px;
  float: right;
  font-weight: normal;
  font-size: 14px;
  padding: 3px 6px;
}
.collected {
  display: inline-block;
  border: 1px solid #f00;
  border-radius: 5px;
  float: right;
  font-weight: normal;
  font-size: 14px;
  padding: 3px 6px;
  background: #f00;
  color: #fff;
}
.addcar {
  padding: 0px 18px !important;
  background-color: #f00;
  color: #fff !important;
}
.ios .toolbar-inner {
  padding-right: 0px !important;
}
.goods_stepper {
  display: inline-block;
}
.goods_stepper button {
  display: inline-block;
}
.time_item {
  display: inline-block;
  padding: 3px 8px;
  border-radius: 4px;
  border: 1px solid #eee;
  margin: 5px;
  background: #fff;
}
.timeItem {
  background: #f38383;
  color: #fff;
  border: 1px solid #f40;
}
.fixedBottomButton {
  position: fixed;
  bottom: 0px;
  left: 0px;
  right: 0px;
  z-index: 9999;
}
.text {
  width: 100%;
  display: inline-block;
  text-align: center;
  font-size: 18px;
  padding-bottom: 10px !important;
  padding-top: 10px !important;
  border-bottom: 1px solid #eee;
  background-color: #fff;
}
.my_coin {
  font-size: 18px;
  font-weight: bold;
  color: #333;
  position: absolute;
  top: 0px;
  left: 0px;
}
.toolbar {
}
.center_content_out {
  position: relative;
}
.center_content {
  display: inline-block;
  padding-left: 10px;
  vertical-align: middle;
}
.center_content:after {
  position: absolute;
  content: "";
  top: -10px;
  right: 0;
  height: 13px;
  width: 26px;
  background: #eee;
  border-radius: 0 0 13px 13px;
}
.center_content::before {
  position: absolute;
  content: "";
  bottom: -13px;
  right: 0;
  height: 13px;
  width: 26px;
  background: #eee;
  border-radius: 13px 13px 0 0;
}

.center_content p {
  font-size: 13px;
  color: #aaa;
}
.my_slide {
  position: relative;
  height: 160px;
}
.my_imgDiv {
  height: 100%;
  position: relative;
  width: 100%;
}
.my_imgDiv img {
  vertical-align: top;
  position: absolute;
  /* left:50%;
  top:50%; */
  left: 0;
  top: 0;
  max-width: 100%;
  /* max-height: 100%; */
  line-height: 100%;
}
.my_item .item-subtitle {
  color: #999 !important;
  font-size: 14px !important;
  margin-top: 5px;
}
.detailHtml {
  padding: 10px;
  overflow: hidden;
}
.detailHtml p {
  padding: 0px;
  margin: 0px;
}
.detailHtml img {
  max-width: 100% !important;
}
.van-tab {
  flex-basis: 28% !important;
}
.mySkuButton .van-sku-actions .van-button--warning {
  display: none;
}
.mySkuButton .van-sku-actions .van-button:last-of-type {
  border-radius: 20px;
}

.my_detail .van-sticky {
  padding-left: 50px;
  background: #fff;
}
.tagShare {
  background-color: #eee;
  margin-right: -10px;
  padding-left: 8px;
  padding-top: 2px;
  padding-bottom: 2px;
  border-top-left-radius: 2em;
  border-bottom-left-radius: 2em;
}
.detailGoods .page-content {
  display: flex;
  flex-direction: column;
  height: 100%;
}

</style>