<template>
  <f7-page class="enter_Store bgcg">
    <van-nav-bar
      left-arrow
      class="myNavBar2"
      title="店铺信息"
      @click-left="$commonUtils.onClickLeft"
      style="background:#fff"
    />
    <div class="mine bgcg">
      <div class="pd-5 bgcw">
        <van-row class="pl-10 pr-10">
          <van-col :span="4">
            <van-image width="60px" height="60px" round :src="formatImage(storeDetail.logo)" />
          </van-col>
          <van-col :span="14">
            <div class="pl-10 c-333"> 
              <h3 class="mb-5">{{storeDetail.departName}}</h3>
              <van-rate
                v-if="storeDetail.ratio"
                v-model="storeDetail.ratio"
                allow-half
                void-icon="star"
                size="18"
                void-color="#eee"
                readonly
              />
            </div>
          </van-col>
          <van-col :span="6" class="tr pr-10">
            <!-- <div class="pl-5 pr-5 inlineBlock tr"> -->
            <span
              class="f-12 c-fff border-radius5 pd-5 c-bgr"
              @click="goodsFocus()"
              v-if="toFocus == 0 "
              style="border:1px solid #fd4346"
            >
              <img src="@/assets/guanzhu2.png" width="24px" alt class="v_middle" />
              <i class="v_middle">关注</i>
            </span>
            <span
              class="f-12 c-fff border-radius5 pd-5"
              @click="ungoodsFocus()"
              v-if="toFocus == 1"
              style="background:#ccc"
            >
              <i class="v_middle">已关注</i>
            </span>
            <!-- </div> -->
          </van-col>
        </van-row>
        <van-row class="pl-10 pr-10">
          <van-col :span="17">
            <div class="pd-5 f-14">
              <p class="rapP">
                <van-icon name="underway-o" class="v_middle" />
                <span
                  class="v_middle ml-5"
                >营业时间: {{storeDetail.startTime}} 至 {{storeDetail.endTime}}</span>
              </p>
              <p class="rapP">
                <van-icon name="location-o" class="v_middle" />
                <span class="v_middle ml-5">地址:{{storeDetail.address}}</span>
              </p>
            </div>
          </van-col>
          <van-col :span="7" class="tr pr-10">
            <!-- <div class="pd-5"> -->
            <span class="pl-10 inlineBlock pr-10" style="border-right:1px solid #eee">
              <van-icon name="phone-circle-o" color="#f40" size="20" @click="showPhone = true" />
            </span>
            <span class="pl-10 inlineBlock">
              <van-icon name="chat-o" color="#f40" size="20" @click="service" />
            </span>
            <!-- </div> -->
          </van-col>
        </van-row>
      </div>
      <div class="bgcg pb-10"></div>
      <div class="bgcg">
        <van-tabs v-model="activeName">
          <van-tab title="商品" name="0">
            <van-pull-refresh
              v-model="goodsList.isLoading"
              success-text="刷新成功"
              @refresh="onRefresh"
            >
              <van-list
                v-model="goodsList.loading"
                :finished="goodsList.finished"
                finished-text="没有更多了"
                @load="getGoodsList"
              >
                <div v-for="(item,index) in goodsList.items">
                  <van-row
                    class="pd-10 bgcw mg-10 border-radius4"
                    @click="toDetail(item.id,item.productCategoryCode)"
                  >
                    <van-col span="14">
                      <div>
                        <h4 class="pr-10">{{item.name}}</h4>
                        <div class="f-12 mt-10 mb-10">
                          已卖出
                          <span>{{item.sale}}</span>件 |
                          <span v-if="item.goodReviewRatio">好评: {{item.goodReviewRatio}}%</span>
                          <span v-else>好评:100%</span>
                        </div>
                        <div v-if="item.smsCouponValueList.length > 0">
                          <van-tag
                            color="#fc7b69"
                            class="mr-5"
                            plain
                            v-for="(icon,sss) in item.smsCouponValueList"
                            v-if="$commonUtils.timeOVer(icon.smsCouponEndTime) != 0"
                          >
                            <template>{{icon.smsCouponName}}</template>
                          </van-tag>
                        </div>
                        <div>
                          <p class="f-12 c-333">
                            <span class="c-red">
                              ￥
                              <b class="f-20 mr-5">{{item.price}}</b>
                            </span>市场价
                          </p>
                          <p class="f-12 c-333">
                            <span class="mr-5 c-red">
                              ￥
                              <i>{{item.coinPrice}}</i>
                              +{{item.coin}}公益币
                            </span>公益价
                          </p>
                        </div>
                      </div>
                    </van-col>
                    <van-col span="8" offset="2">
                      <van-image
                        :src="formatImage(item.pic)"
                        alt
                        width="100%"
                        height="110px"
                        class="border-radius8"
                      />
                    </van-col>
                  </van-row>
                </div>
              </van-list>
            </van-pull-refresh>
          </van-tab>
          <van-tab title="活动" name="1">
            <van-pull-refresh
              v-model="myActivityList.isLoading"
              success-text="刷新成功"
              @refresh="onRefreshActivity"
            >
              <van-list
                v-model="myActivityList.loading"
                :finished="myActivityList.finished"
                finished-text="没有更多了"
                @load="getActivityList"
              >
                <div
                  v-for="(item,index) in myActivityList.items"
                  @click="toActivityDetail(item.id)"
                >
                  <van-row class="pd-10 bgcw">
                    <van-col :span="8" class="myImage" style="height:100px;line-height:100px">
                      <van-image
                        :src="formatImage(item.posterUrl)"
                        width="100%"
                        height="100px"
                        fit="cover"
                      ></van-image>
                    </van-col>
                    <van-col :span="16">
                      <div class="pb-10 pl-10 f-14">{{item.title}}</div>
                      <div class="pb-5 ml-10">
                        <span class="v_middle c-666 f-12">
                          <van-icon name="location-o" class="v_middle" color="#ee0a24" />
                          {{item.location}}
                        </span>
                      </div>
                      <div class="ml-10">
                        <span v-if="item.isEnd == '0'">
                          <van-tag type="success">进行中</van-tag>
                        </span>
                        <span>
                          <van-tag class="ml-10">{{item.activityType_dictText}}</van-tag>
                        </span>
                        <van-icon name="fire" class="ml-10" color="#f00" v-if="item.isHot == '1'" />
                      </div>
                    </van-col>
                  </van-row>
                  <!-- <van-row class="bgcw pd-10 mg-10 border-radius5" v-for="(item,index) in myActivityList">
              <van-col span="6">
                <div class="left_price">
                  ￥
                  <span class="mr-10">{{item.price}}</span>
                </div>
              </van-col>
              <van-col span="12" class="center_content_out">
                <div class="center_content">
                  <h4 class="mb-10">{{item.title}}</h4>
                  <p>{{item.explain}}</p>
                  <p>{{item.limit}}</p>
                </div>
              </van-col>
              <van-col span="6">
                <div class="right_button">
                  <van-button round size="normal" class="baco c-fff" @click="receive()">领取</van-button>
                </div>
              </van-col>
                  </van-row>-->
                </div>
              </van-list>
            </van-pull-refresh>
          </van-tab>
          <van-tab title="人气" name="2">
            <van-pull-refresh
              v-model="goodsListPOP.isLoading"
              success-text="刷新成功"
              @refresh="onRefreshPOP"
            >
              <van-list
                v-model="goodsListPOP.loading"
                :finished="goodsListPOP.finished"
                finished-text="没有更多了"
                @load="getGoodsListPOP"
              >
                <div v-for="(item,index) in goodsListPOP.items">
                  <van-row
                    class="pd-10 bgcw mg-10 border-radius4"
                    @click="toDetail(item.id,item.productCategoryCode)"
                  >
                    <van-col span="14">
                      <div>
                        <h4 class="pr-10">{{item.name}}</h4>
                        <div class="f-12 mt-10 mb-10">
                          已卖出
                          <span>{{item.sale}}</span>件 |
                          <span v-if="item.goodReviewRatio">好评:{{item.goodReviewRatio}}%</span>
                          <span v-else>好评:100%</span>
                        </div>
                        <div v-if="item.smsCouponValueList.length > 0">
                          <van-tag
                            color="#fc7b69"
                            class="mr-5"
                            plain
                            v-for="(icon,sss) in item.smsCouponValueList"
                            v-if="$commonUtils.timeOVer(icon.smsCouponEndTime) != 0"
                          >
                            <template>{{icon.smsCouponName}}</template>
                          </van-tag>
                        </div>
                        <div>
                          <p class="f-12 c-333">
                            <span class="c-red">
                              ￥
                              <b class="f-20 mr-5">{{item.price}}</b>
                            </span>市场价
                          </p>
                          <p class="f-12 c-333">
                            <span class="mr-5 c-red">
                              ￥
                              <i>{{item.coinPrice}}</i>
                              +{{item.coin}}公益币
                            </span>公益价
                          </p>
                        </div>
                      </div>
                    </van-col>
                    <van-col span="8" offset="2">
                      <van-image
                        :src="formatImage(item.pic)"
                        alt
                        width="100%"
                        height="110px"
                        class="border-radius8"
                      />
                    </van-col>
                  </van-row>
                </div>
              </van-list>
            </van-pull-refresh>
          </van-tab>
        </van-tabs>
        <van-popup v-model="showPhone" class="my_phone border-radius8" style="width:300px">
          <p class="f-14 c-666 tc mt-10">点击拨打电话</p>
          <div class="pd-10 bgcw">
            <p v-for="(phone,number) in phoneList" class="pd-20 f-20" @click="toPhone(phone)">
              <van-icon name="phone-circle-o" color="#fd4346" class="v_middle" />
              <span class="ml-10">{{phone}}</span>
            </p>
          </div>
        </van-popup>
      </div>
    </div>
  </f7-page>
</template>

<script>
import { Toast } from "vant";
import {
  storeGoodsList,
  queryStoreDetail,
  MystoreActivityList,
  toService
} from "@/api/api_mall.js";
import { isFocused, addFocus, delFocus } from "@/api/api_common.js";
export default {
  data() {
    return {
      starValue: 0,
      toFocus: null,
      storeID: "A01",
      activeName: 0,
      storeDetail: {},
      phoneList: [],
      showPhone: false,
      myActivityList: {
        pageNumber: 1,
        totalPage: 0,
        loading: false,
        finished: false,
        isLoading: false,
        items: []
      },
      goodsList: {
        pageNumber: 1,
        totalPage: 0,
        loading: false,
        finished: false,
        isLoading: false,
        items: []
      },
      goodsListPOP: {
        pageNumber: 1,
        totalPage: 0,
        loading: false,
        finished: false,
        isLoading: false,
        items: []
      }
    };
  },
  methods: {
    //格式化图片路径
    formatImage(url) {
      return this.$commonUtils.formatPicture(url);
    },
    //联系客服
    service() {
      toService({ companyCode: this.storeID })
        .then(res => {
          // Toast(res.data.data);
          // if (res.data.data) {
          wx.contact({
            username: res.data.data
          });
          // }
        })
        .then(err => {});
    },
    //拨打电话
    toPhone(phone) {
      wx.diaMobile(phone);
      this.showPhone = false;
    },
    //关注商家
    isFocus() {
      let _this = this;
      let res = isFocused("30", this.storeID)
        .then(res => {
          _this.toFocus = res.data.collect;
        })
        .catch(err => {});
    },
    goodsFocus() {
      let res = addFocus("30", this.storeID);
      this.toFocus = 1;
    },
    ungoodsFocus() {
      let res = delFocus("30", this.storeID);
      this.toFocus = 0;
    },
    //根据店铺查询商品列表************************************************
    getGoodsList() {
      let param = {
        companyCode: this.storeID,
        pageSize: "",
        pageNum: this.goodsList.pageNumber
      };
      let _this = this;
      storeGoodsList(param)
        .then(res => {
          _this.handleData(res.data, 0);
          _this.goodsList.totalPage = res.data.data.totalPage;
          _this.goodsList.loading = false;
          if (res.data.data.totalPage <= res.data.data.pageNum) {
            _this.goodsList.finished = true;
          } else {
            _this.goodsList.pageNumber++;
          }
        })
        .catch(err => {});
    },
    onRefresh() {
      this.goodsList.totalPage = 0;
      this.goodsList.pageNumber = 1;
      this.init(); //加载数据
    },
    init() {
      let _this = this;
      let param = {
        companyCode: this.storeID,
        pageSize: "",
        pageNum: this.goodsList.pageNumber
      };
      let res = storeGoodsList(param)
        .then(res => {
          _this.goodsList.items = [];
          _this.handleData(res.data, 0);
          _this.goodsList.totalPage = res.data.data.totalPage;
          _this.goodsList.isLoading = false; //关闭下拉刷新效果
          _this.goodsList.finished = false;
          if (res.data.data.totalPage <= res.data.data.pageNum) {
            _this.goodsList.finished = true;
          } else {
            _this.goodsList.pageNumber++;
          }
        })
        .catch(err => {});
    },
    //人气商品***********************************************************
    getGoodsListPOP() {
      let param = {
        companyCode: this.storeID,
        pageSize: "",
        recommandStatus: 1,
        pageNum: this.goodsListPOP.pageNumber
      };
      let _this = this;
      storeGoodsList(param)
        .then(res => {
          _this.handleData(res.data, 1);
          _this.goodsListPOP.totalPage = res.data.data.totalPage;
          _this.goodsListPOP.loading = false;
          if (res.data.data.totalPage <= res.data.data.pageNum) {
            _this.goodsListPOP.finished = true;
          } else {
            _this.goodsListPOP.pageNumber++;
          }
        })
        .catch(err => {});
    },
    onRefreshPOP() {
      this.goodsListPOP.totalPage = 0;
      this.goodsListPOP.pageNumber = 1;
      this.initPOP(); //加载数据
    },
    initPOP() {
      let _this = this;
      let param = {
        companyCode: this.storeID,
        pageSize: "",
        recommandStatus: 1,
        pageNum: this.goodsListPOP.pageNumber
      };
      let res = storeGoodsList(param)
        .then(res => {
          _this.goodsListPOP.items = [];
          _this.handleData(res.data, 1);
          _this.goodsListPOP.totalPage = res.data.data.totalPage;
          _this.goodsListPOP.isLoading = false; //关闭下拉刷新效果
          _this.goodsListPOP.finished = false;
          if (res.data.data.totalPage <= res.data.data.pageNum) {
            _this.goodsListPOP.finished = true;
          } else {
            _this.goodsListPOP.pageNumber++;
          }
        })
        .catch(err => {});
    },
    handleData(res, value) {
      let _this = this;
      res.data.list.forEach((item, index) => {
        if (item.image) {
          item.image = item.image.split(",");
          for (let i in item.image) {
            // item.image[i] = _this.$commonUtils.formatPicture(item.image[i]);
          }
        }
        if (value == 0) _this.goodsList.items.push(item);
        if (value == 1) _this.goodsListPOP.items.push(item);
      });
    },
    toDetail(id, productCategoryCode) {
      productCategoryCode = productCategoryCode.substring(0, 3);
      if (productCategoryCode == "G02") {
        this.$f7router.navigate(`/goodsDetails/${id}/`);
      } else if (productCategoryCode == "G01") {
        this.$f7router.navigate(`/goodsDetail/${id}/`);
      }
    },
    searchMystore() {
      queryStoreDetail({ companyCode: this.storeID })
        .then(res => {
          // console.log(JSON.stringify(res));
          if (res.data.data.mobile) {
            this.phoneList = res.data.data.mobile.split("\\");
          }
          if (res.data.data.ratio)
            res.data.data.ratio = Number(res.data.data.ratio) / 20;
          this.storeDetail = res.data.data;
        })
        .catch(err => {});
    },
    //*********************************获取活动列表********************************** */
    getActivityList() {
      let _this = this;
      let param = {
        pageNo: this.myActivityList.pageNumber,
        pageSize: 10,
        departType: 2,
        sysCompanyCode: this.storeID
      };
      MystoreActivityList(param)
        .then(res => {
          _this.handleDataActivity(res.data);
          _this.myActivityList.totalPage = res.data.pages;
          _this.myActivityList.loading = false;
          if (res.data.total <= res.data.current) {
            _this.myActivityList.finished = true;
          } else {
            _this.myActivityList.pageNumber++;
          }
        })
        .catch(err => {});
    },
    onRefreshActivity() {
      this.myActivityList.totalPage = 0;
      this.myActivityList.pageNumber = 1;
      this.initActivity(); //加载数据
    },
    initActivity() {
      let _this = this;
      let param = {
        sysCompanyCode: this.storeID,
        pageSize: 10,
        pageNo: 1,
        departType: 2
      };
      let res = MystoreActivityList(param)
        .then(res => {
          _this.myActivityList.items = [];
          _this.handleDataActivity(res.data);
          _this.myActivityList.totalPage = res.data.pages;
          _this.myActivityList.isLoading = false; //关闭下拉刷新效果
          _this.myActivityList.finished = false;
          if (res.data.total <= res.data.current) {
            _this.myActivityList.finished = true;
          } else {
            _this.myActivityList.pageNumber++;
          }
        })
        .catch(err => {});
    },
    handleDataActivity(res) {
      let _this = this;
      res.records.forEach((item, index) => {
        if (item.posterUrl) {
          // item.posterUrl = _this.$commonUtils.formatPicture(item.posterUrl);
        }
        _this.myActivityList.items.push(item);
      });
    },
    //*********************************获取活动列表end********************************** */
    //去活动详情页面
    toActivityDetail(id) {
      console.log(id);
      this.$f7router.navigate(`/cms/activityDetail/${id}/`);
    }
  },
  mounted() {
    //获取参数
    let params = this.$f7route.params;
    if (params.storeID) {
      this.storeID = params.storeID;
      this.searchMystore();
      this.isFocus();
    }
  }
};
</script>

<style>
.safeCheck,
.doorClear {
  background-color: #eee;
}

.red {
  background-color: #f40;
  color: #fff;
}
.left_price {
  color: #333;
  border-right: 1px solid #ddd;
  display: inline-block;
  min-height: 68px;
  line-height: 68px;
}
.left_price span {
  font-weight: bold;
  font-size: 24px;
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
.right_button {
  min-height: 68px;
  line-height: 68px;
}
.check_bottom {
  position: fixed;
  bottom: 0px;
  left: 0px;
  right: 0px;
}
.clearItem {
  padding: 5px 20px;
  background-color: #eee;
  margin-right: 5px;
  margin-left: 5px;
  border-radius: 5px;
  color: #666;
}
.myImage img {
  border-radius: 3px !important;
}
.my_phone {
  z-index: 99999 !important;
}
.enter_Store .page-content {
  display: flex;
  flex-direction: column;
  height: 100%;
}
</style>