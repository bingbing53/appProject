<template>
  <f7-page class="bgcg detailGoods">
    <div class="mine">
      <van-tabs v-model="active" scrollspy sticky class="my_detail">
        <van-icon name="arrow-left" class="my_coin2" @click="$commonUtils.onClickLeft" />
        <van-tab title="商品">
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
                <span class="c-red f-18">{{goodsDes.coinPrice}} + {{goodsDes.coin}} 公益币</span>
                <span class="collected" @click="ungoodsCollect()" v-if="toCollect == 1">已收藏</span>
                <span class="collect f-14 c-000" @click="goodsCollect()" v-if="toCollect == 0">收藏</span>
              </p>
            </div>
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
            <!-- <van-cell title="是否使用公益币" class="myCell pb-10">
              <span class="mr-20 f-11">可用公益币余额{{rescoin}}</span>
              <van-switch
                v-model="checkedCoin"
                slot="right-icon"
                size="20"
                active-color="#ee0a24"
                :disabled="disabledCoin"
                @change="getchecked"
              />
            </van-cell>-->
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
              v-if="commentList.length ==0"
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
                      <template v-if="item.pics">
                        <div>
                          <van-image
                            :src="formatImage(image)"
                            alt
                            width="80px"
                            height="80px"
                            fit="cover"
                            v-for="(image,ppp) in item.pics"
                            class="mr-5"
                            @click="previewImgmy(item.pics2,ppp)"
                          />
                        </div>
                      </template>
                    </div>
                  </div>
                  <img
                    v-if="item.url"
                    :src="formatImage(item.url)"
                    class="myimage"
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
        class="mySkuButton2"
        v-model="show"
        :sku="sku"
        :goods="goods"
        :goods-id="goodsId"
        :quota-used="quota_used"
        :properties="sku.properties"
        :start-sale-num="start_num"
        @add-cart="onAddCartClicked"
      />
      <van-popup
        v-model="show_volunters"
        position="bottom"
        :style="{ height: '50%' }"
        class="bgcg"
        round
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
      <van-goods-action-icon icon="service-o" text="客服" @click="service" />
      <van-goods-action-icon icon="shop-o" text="店铺" @click="enterStore" />
      <van-goods-action-icon icon="cart-o" text="购物车" :info="GLOBAL.carNumber" @click="toShopCar" />
      <van-goods-action-button type="warning" text="加入购物车" @click="showSku" />
      <!-- <van-goods-action-button type="danger" text="立即购买" @click="showSku" /> -->
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
  productCommuntList,
  goodsTypes,
  addToCart,
  userCoin,
  getCartList,
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
      activeTab: 1,
      navList: [{ title: "商品" }, { title: "评价" }, { title: "详情" }],
      id: "",
      areaCode: "",
      checkedCoin: false,
      disabledCoin: false,
      coinNum: "",
      // rescoin: "",
      useCoin: 0,
      show_volunters: false,
      myVouchers: [],
      usedVouchersNum: 0,
      useVouchersNum: 0,
      // productAttributeCategoryId: "",
      sysCompanyCode: "",
      commentList: [],
      swiperList: [],
      swiperDes: "",
      goodsDes: {},
      loading: false,
      effect: null,
      goodsTypeList: [],
      show: false,
      carInfo: 0,
      toCollect: null,
      goodsId: "946755",
      // quota: 15, //限购数量
      quota_used: 0, //已经购买过的数量
      start_num: 1,
      sku: {
        tree: [],
        // 所有 sku 的组合列表，比如红色、M 码为一个 sku 组合，红色、S 码为另一个组合
        list: [],
        price: "", // 默认价格（单位元）
        stock_num: "", // 商品总库存
        collection_id: "", // 无规格商品 skuId 取 collection_id，否则取所选 sku 组合对应的 id
        none_sku: false, // 是否无规格商品
        hide_stock: false // 是否隐藏剩余库存
      },
      goods: {
        title: "",
        picture: "",
        price: ""
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
    show_volunters(newName, oldName) {
      if (newName) {
        this.showBottom = false;
      } else {
        this.showBottom = true;
      }
    },
    show(newName, oldName) {
      if (newName) {
        this.showBottom = false;
      } else {
        this.showBottom = true;
      }
    }
  },
  methods: {
    substringDate(time) {
      return time.substring(0, 10);
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
    //获取点击的dom内容
    getInner(e) {
      this.perimageArrDetail = [];
      if (e.target.nodeName == "IMG") {
        this.showImageDetail = true;
        this.perimageArrDetail.push(e.target.currentSrc);
      }
    },
    //获取公益按钮的状态
    getchecked() {
      console.log(this.checkedCoin);
      if (this.checkedCoin) {
        this.isuseCoin = 1;
      } else {
        this.isuseCoin = 0;
      }
    },
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
    onBuyClicked(sku) {
      console.log(JSON.stringify(sku));
      // return
      let num = sku.selectedNum;
      let serve_date = 0;
      let skuCode = sku.selectedSkuComb.skuCode;
      let coinNum = 0;
      // return
      this.$f7router.navigate(
        `/toConfirmOrder/${this.id}/${num}/${serve_date}/${skuCode}/${this.areaCode}/${coinNum}/`
      );
    },
    toShopCar() {
      this.$f7router.navigate(`/ShoppingCar/`);
    },
    onAddCartClicked(sku) {
      let _this = this;
      let params = {
        productSkuCode: sku.selectedSkuComb.skuCode,
        quantity: sku.selectedNum,
        sysCompanyCode: this.sysCompanyCode
        // useCoin: this.isuseCoin
      };
      // console.log(params)
      // return
      addToCart(params)
        .then(res => {
          if (res.data.code == 200) {
            Toast("添加成功");
            _this.getCarLength();
            _this.show = false;
            _this.showBottom = true;
          }
        })
        .catch(err => {
          this.$commonUtils.jumpLogin(err);
        });
    },
    //格式化图片路径
    formatImage(url, size) {
      return this.$commonUtils.formatPicture(url, size);
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
            console.log(res.data);
            // this.show_volunters = false;
            this.getVouchers();
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
    showSku() {
      this.show = true;
      this.showBottom = false;
    },
    load: function(effect) {
      var self = this;
      if (self.loading) return;
      self.effect = effect;
      self.loading = true;
      setTimeout(() => {
        self.loading = false;
      }, 3000);
    },
    //获取商品分类
    getGoodsType() {
      let params = {
        productAttributeCategoryId: this.goodsDes.productAttributeCategoryId
      };
      let _this = this;
      goodsTypes(params)
        .then(res => {
          console.log(res);
          res.data.data.forEach((item, index) => {
            _this.goodsTypeList.push({ name: item.name });
          });
          _this.getGoodsSku();
        })
        .catch(err => {});
    },
    //获取商品详情
    getGoodsDetail() {
      goodsDetail({ productId: this.id })
        .then(res => {
          if (res.data.data.serviceIds) {
            res.data.data.serviceIds = res.data.data.serviceIds.split(",");
          }
          this.goodsDes = res.data.data;
          this.title = res.data.data.name;
          this.areaCode = res.data.data.areaCode;
          this.coinNum = res.data.data.coin;
          this.sysCompanyCode = res.data.data.sysCompanyCode;
          res.data.data.albumPics =
            res.data.data.pic + "," + res.data.data.albumPics;
          this.swiperList = res.data.data.albumPics.split(",");
          //赋值默认sku
          this.sku.price = res.data.data.price;
          this.sku.stock_num =
            Number(res.data.data.stock) - Number(res.data.data.lowStock);
          this.collection_id = res.data.data.id;
          this.goods.title = res.data.data.name;
          this.goods.picture = this.formatImage(res.data.data.pic);
          this.goods.price = res.data.data.price;
          this.getGoodsType();
        })
        .catch(err => {});
    },
    getCommentList() {},
    //获取购物车商品长度，显示购物车上方数字
    getCarLength() {
      let carLen = 0;
      getCartList()
        .then(res => {
          res.data.data.forEach((item, index) => {
            carLen += item.cartItemList.length;
          });
          this.GLOBAL.carNumber = carLen;
          this.carInfo = carLen;
          this.$forceUpdate();
        })
        .catch(err => {});
    },
    //获取商品sku
    async getGoodsSku() {
      let res = await goodsDetailSku({ productId: this.id });
      res.data.data.forEach((item, index) => {
        item.s1 = item.sp1;
        item.s2 = item.sp2;
        item.s3 = item.sp3;
        item.goods_id = item.productId;
        item.stock_num = item.stock - item.lockStock;
        item.imgUrl = this.formatImage(item.pic);
        item.previewImgUrl = this.formatImage(item.pic);

        // item.stock_num = 123;
        item.price = item.price * 100;
      });
      console.log(this.goodsTypeList);
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
        // sp1_arr.push(item.s1);
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
    }
  },
  mounted() {
    let _this = this;
    var params = this.$f7route.params;
    // console.log(params);
    if (params.id != null && params.id.length > 0) {
      this.id = params.id;
      this.GLOBAL.detailGoodsId = params.id;
      this.getGoodsDetail();
      this.isCollect();
      this.getCommitList();
      this.getVouchers();
      _this.getCarLength();
      window.reload = function() {
        _this.getCarLength();
      };
    }
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
.myCell {
  padding-left: 0px !important;
}
.baozheng {
  display: inline-block;
  border-radius: 8px;
  border: 1px solid transparent;
  background-color: #eee;
  font-size: 12px;
  padding: 3px 10px;
  margin: 5px;
  color: #666;
}
.baozhengActive {
  border: 1px solid #ee0a24;
  background-color: #e65454;
  color: #ee0a24;
}
.detailGoods .page-content {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.my_coin2 {
  font-size: 18px;
  font-weight: bold;
  color: #333;
  margin-left: 15px;
  margin-top: 15px;
  position: fixed;
  z-index: 999;
  top: 0px;
  left: 0px;
}
.mySkuButton2 .van-sku-actions .van-button:last-of-type {
  display: none;
}
.mySkuButton2 .van-sku-actions .van-button:first-of-type {
  border-radius: 20px;
}
.my_detail .van-sticky {
  padding-left: 50px;
  background: #fff;
}
.myimage img {
  border-radius: 50%;
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
</style>