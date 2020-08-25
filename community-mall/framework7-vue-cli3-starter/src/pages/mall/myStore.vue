<template>
  <f7-page class="store bgcg order_List">
    <template v-if="!hasShop">
      <div>
        <van-nav-bar
          class="myNavBarStore"
          title="店铺信息"
          left-arrow
          @click-left="$commonUtils.onClickLeft"
        ></van-nav-bar>
      </div>
      <div style="height:100%">
        <div class="tc c-e6 bgcw" style="height:100%">
          <div class="pt-150">
            <van-icon name="shop-o" size="100" />
          </div>
          <p
            class="f-16 c-999"
            style="line-height:24px"
          >您还未创建店铺，请登录电脑域名为：https://mall.shequyijia.cn/ 创建店铺。</p>
        </div>
      </div>
    </template>
    <template v-else>
      <div>
        <van-nav-bar
          class="myNavBarStore"
          title="店铺信息"
          left-arrow
          right-text="+"
          @click-left="$commonUtils.onClickLeft"
          @click-right="onClickRight"
        ></van-nav-bar>
      </div>
      <div class="mine bgcg">
        <div class="pl-5 pr-5 bgcw border-radius8 pt-5 pb-5">
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
          </van-row>
          <van-row class="pl-10 pr-10">
            <van-col :span="24">
              <div class="pd-5 f-14">
                <p class="rapP">
                  <van-icon name="underway-o" class="v_middle" />
                  <span
                    class="v_middle ml-5"
                  >营业时间: {{storeDetail.startTime}}至 {{storeDetail.endTime}}</span>
                </p>
                <p class="rapP">
                  <van-icon name="location-o" class="v_middle" />
                  <span class="v_middle ml-5">地址: {{storeDetail.address}}</span>
                </p>
              </div>
            </van-col>
          </van-row>
        </div>
        <div class="mt-10 border-radius8">
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
                          <h4 class="pr-20">{{item.name}}</h4>
                          <div class="f-12 mt-10 mb-10">
                            已卖出
                            <span>{{item.sale}}</span>件 |
                            <span v-if="item.goodReviewRatio">好评:{{item.goodReviewRatio}}%</span>
                            <span v-else>好评:100%</span>
                          </div>
                          <div v-if="item.smsCouponValueList.length > 0">
                            <van-tag
                              color="#fc7b69"
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
                                <i>{{item.coinPrice}}</i>+2公益币
                              </span>公益价
                            </p>
                          </div>
                        </div>
                      </van-col>
                      <van-col span="8" offset="2">
                        <img
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
                    <van-row class="pd-10 bgcw border-radius4">
                      <van-col :span="8" class="myImage" style="height:100px;line-height:100px">
                        <van-image :src="item.posterUrl" width="100%" height="100px" fit="cover"></van-image>
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
                          <van-icon
                            name="fire"
                            class="ml-10"
                            color="#f00"
                            v-if="item.isHot == '1'"
                          />
                        </div>
                      </van-col>
                    </van-row>
                    <!-- <van-row class="bgcw pd-10 mg-10 border-radius5" v-for="(item,index) in myVouchers">
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
                    <!-- <div class="bgcg pb-10"></div> -->
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
                          <h4 class="pr-20">{{item.name}}</h4>
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
                                <i>{{item.coinPrice}}</i>+2公益币
                              </span>公益价
                            </p>
                          </div>
                        </div>
                      </van-col>
                      <van-col span="8" offset="2">
                        <img
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
        </div>
        <van-popup v-model="subMenuShow" position="right" class="myppp">
          <div class="border-radius5 subNav pt-10 pb-10">
            <van-row class="pt-10 pb-10" @click="scan">
              <van-col :span="8" class="tr">
                <van-icon name="scan" size="22" class="v_middle" />
              </van-col>
              <van-col :span="16" class="pb-10 pl-10">
                <span class="f-14">扫一扫</span>
              </van-col>
            </van-row>
            <van-row class="pb-10" @click="searchVolunteers()">
              <van-col :span="8" class="tr">
                <van-icon name="search" size="22" class="v_middle" />
              </van-col>
              <van-col :span="16" class="pl-10">
                <span class="f-14">志愿者</span>
              </van-col>
            </van-row>
          </div>
        </van-popup>
      </div>
      <div class="pt-10 pb-10 bgcw" style="display:none">
        <van-row gutter="20" type="flex" justify="center">
          <van-col :span="10">
            <van-button
              round
              class="safeCheck"
              @click="safe_check()"
              :class="{'red': activeIndex1 === 1}"
            >安全检查</van-button>
          </van-col>
          <van-col :span="10">
            <van-button
              round
              class="doorClear"
              @click="door_clear()"
              :class="{'red': activeIndex2 === 1}"
            >门前三清</van-button>
          </van-col>
        </van-row>
      </div>
      <van-popup v-model="showCheck_bottom" position="bottom" :style="{ height: '60%' }">
        <div class="pd-10">
          <van-row class="pb-10 broder_b">
            <van-col :span="14">
              <span class="c-red">安全检查</span>
            </van-col>
            <van-col :span="10">
              <span
                class="mr-5 ml-5"
                v-for="(check,checkIdx) in checkItem"
                @click="check_time(checkIdx)"
                :class="{ischeck:checkIdx === current}"
              >{{check.title}}</span>
            </van-col>
          </van-row>
          <div class="border bgcg">
            <van-field rows="5" autosize type="textarea" v-model="checkInner" placeholder="请输入描述" />
          </div>
          <div class="check_bottom">
            <van-button color="#fc3d42" size="large" @click="checkOk">检查完毕</van-button>
          </div>
        </div>
      </van-popup>
      <van-popup v-model="showClear_bottom" position="bottom" :style="{ height: '60%' }">
        <div class="pd-10">
          <van-row class="pb-10 broder_b mb-10">
            <van-col :span="24">
              <div class="c-red">门前三清</div>
            </van-col>
          </van-row>
          <van-row class="pb-20 broder_b mb-10">
            <van-col :span="24" class="mt-10">
              <span
                class="clearItem"
                v-for="(clear,clearIdx) in clearItem"
                @click="clear_time(clearIdx)"
                :class="{isclear:clearIdx === current2}"
              >{{clear.title}}</span>
            </van-col>
          </van-row>
          <div class="border bgcg mt-10">
            <van-field rows="5" autosize type="textarea" v-model="clearInner" placeholder="请输入描述" />
          </div>
          <div class="check_bottom">
            <van-button color="#fc3d42" size="large" @click="clearOk">检查完毕</van-button>
          </div>
        </div>
      </van-popup>
      <van-popup
        v-model="showActivityList"
        position="bottom"
        closeable
        close-icon="close"
        :style="{ height: '80%' }"
        class="listttttttttttt"
      >
        <div class="mt-20 pd-10">
          <span class="f-12 v_middle c-waring ml-10">
            <van-icon name="warning-o" class="v_middle mr-5" size="12" color="#ff976a" />选择您参加的活动，点击进行签到
          </span>
          <div class="pt-10 pb-10 borderScale mt-10">
            <van-row v-for="(item,index) in activityList" :key="index" @click="signIn(item.id)">
              <van-col :span="6">
                <div class="pl-10 pr-10 border-radius8 my_picture">
                  <img
                    :src="formatImage(item.posterUrl)"
                    width="70px"
                    height="70px"
                    alt
                    style="border:1px solid #eee"
                  />
                </div>
              </van-col>
              <van-col :span="18">
                <p class="c-blue mb-10">{{item.title}}</p>
                <p
                  class="c-666 f-12"
                >时间:{{substringDate(item.startTime)}} 至 {{substringDate(item.endTime)}}</p>
                <p class="c-666 f-12 mt-5">地址:{{item.location}}</p>
              </van-col>
            </van-row>
          </div>
        </div>
      </van-popup>
    </template>
  </f7-page>
</template>

<script>
import { Toast } from "vant";
import {
  storeGoodsList,
  queryMystore,
  scanActivityList,
  signInActivity,
  publicHealthReport,
  secureReport,
  MystoreActivityList
} from "@/api/api_mall.js";
export default {
  data() {
    return {
      hasShop: false,
      subMenuShow: false,
      rate: 5,
      current: -1,
      current2: -1,
      activeName: 0,
      activeIndex1: 0,
      activeIndex2: 0,
      showCheck_bottom: false,
      showClear_bottom: false,
      storeDetail: {},
      showActivityList: false,
      activityList: [],
      // scanCode: "8a80808f719cd5530171a035ad1f0002",
      scanCode: "",
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
      },
      checkItem: [
        { title: "日检", text: "day" },
        { title: "周检", text: "week" },
        { title: "月检", text: "month" }
      ],
      clearItem: [
        { title: "垃圾清", text: "garbage" },
        { title: "墙面清", text: "wall" },
        { title: "杂物清", text: "sundry" }
      ],
      selectCheck: "",
      selectClear: "",
      checkInner: "",
      clearInner: ""
    };
  },
  methods: {
    onClickRight() {
      this.subMenuShow = true;
    },
    scan() {
      let _this = this;
      wx.scanQRCode({
        success: function(result) {
          // Toast("----" + result + "----");
          _this.scanCode = result;
          _this.getAcitvityList();
        },
        error: function(err) {}
      });

      this.subMenuShow = false;
    },
    getAcitvityList() {
      let _this = this;
      let param = {
        code: this.scanCode
      };
      scanActivityList(param)
        .then(res => {
          // console.log(res.data.activities);
          // if (res.data.activities.lenght > 0) {
          _this.activityList = res.data.activities;
          _this.showActivityList = true;
          // }
        })
        .catch(err => {});
    },
    //活动签到
    signIn(id) {
      let param = {
        activityId: id,
        code: this.scanCode
      };
      signInActivity(param)
        .then(res => {
          Toast("签到成功");
        })
        .catch(err => {
          if (err.status == 400) {
            Toast(err.data);
          }
        });
    },
    //搜索志愿者
    searchVolunteers() {
      this.$f7router.navigate(`/Volunteers/${this.storeDetail.orgCode}/`);
      this.subMenuShow = false;
    },
    //格式化图片路径
    formatImage(url) {
      return this.$commonUtils.formatPicture(url);
    },
    substringDate(time) {
      return time.substring(0, 10);
    },
    check_time(index) {
      this.selectCheck = this.checkItem[index].text;
      this.current = index;
    },
    clear_time(index) {
      this.selectClear = this.clearItem[index].text;
      this.current2 = index;
    },
    safe_check() {
      this.activeIndex1 = 1;
      this.activeIndex2 = 0;
      this.showCheck_bottom = true;
    },
    door_clear() {
      this.activeIndex1 = 0;
      this.activeIndex2 = 1;
      this.showClear_bottom = true;
    },
    //安全检查，检查完毕
    checkOk() {
      let params = {
        comment: this.checkInner,
        type: this.selectCheck,
        sysCompanyCode: "A01",
        pictures: ""
      };
      secureReport(params)
        .then(res => {
          console.log(res);
          this.showCheck_bottom = false;
        })
        .catch(err => {});
    },
    //门前三清，检查完毕
    clearOk() {
      let params = {
        comment: this.clearInner,
        type: this.selectClear,
        sysCompanyCode: "A01",
        pictures: ""
      };
      publicHealthReport(params)
        .then(res => {
          console.log(res);
          this.showClear_bottom = false;
        })
        .catch(err => {});
    },
    //根据店铺查询商品列表************************************************
    getGoodsList() {
      let _this = this;
      setTimeout(function() {
        if (_this.storeDetail.orgCode) {
          let param = {
            companyCode: _this.storeDetail.orgCode,
            pageSize: "",
            pageNum: _this.goodsList.pageNumber
          };

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
        }
      }, 1000);
    },
    onRefresh() {
      this.goodsList.totalPage = 0;
      this.goodsList.pageNumber = 1;
      this.init(); //加载数据
    },
    init() {
      let _this = this;
      let param = {
        companyCode: this.storeDetail.orgCode,
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
        companyCode: this.storeDetail.orgCode,
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
        companyCode: this.storeDetail.orgCode,
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
            item.image[i] = _this.$commonUtils.formatPicture(item.image[i]);
          }
        }
        if (value == 0) _this.goodsList.items.push(item);
        if (value == 1) _this.goodsListPOP.items.push(item);
      });
    },
    //*********************************获取活动列表********************************** */
    getActivityList() {
      let _this = this;
      let param = {
        pageNo: this.myActivityList.pageNumber,
        pageSize: 10,
        departType: 2,
        sysCompanyCode: this.storeDetail.orgCode
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
        sysCompanyCode: this.storeDetail.orgCode,
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
          item.posterUrl = _this.$commonUtils.formatPicture(item.posterUrl);
        }
        _this.myActivityList.items.push(item);
      });
    },
    //*********************************获取活动列表end********************************** */
    toDetail(id, productCategoryCode) {
      console.log(id, productCategoryCode);
      productCategoryCode = productCategoryCode.substring(0, 3);
      if (productCategoryCode == "G02") {
        this.$f7router.navigate(`/goodsDetails/${id}/`);
      } else if (productCategoryCode == "G01") {
        this.$f7router.navigate(`/goodsDetail/${id}/`);
      }
    },
    //去活动详情页面
    toActivityDetail(id) {
      console.log(id);
      this.$f7router.navigate(`/cms/activityDetail/${id}/`);
    },
    searchMystore() {
      this.hasShop = false;
      queryMystore()
        .then(res => {
          // res.data.code = 300
          if (res.data.code == 200 && res.data.data != null) {
            this.hasShop = true;
            if (res.data.data.ratio)
              res.data.data.ratio = Number(res.data.data.ratio) / 20;
            this.storeDetail = res.data.data;
          } else {
            this.hasShop = false;
          }
        })
        .catch(err => {});
    }
  },
  created() {
    this.hasShop = false;
    this.searchMystore();
  },
  mounted() {}
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
.ischeck {
  color: #f40;
}
.isclear {
  color: #fff !important;
  background-color: #fb4c2d !important;
}
.subNav {
  width: 120px;
  background: #444444;
  color: #fff;
  font-size: 18px;
  margin-top:30px;
}
.my_picture {
  width: 70px;
  height: 70px;
}
.my_picture img {
  border-radius: 8px;
}
.store .van-overlay {
  z-index: 2001 !important;
}
.page-content > div:first-child {
  background-color: transparent;
}
.store .van-popup--top {
  width: 120px;
}
.store .van-popup {
  background-color: transparent;
}
.store .van-popup--right {
  top: 100px;
}
.listttttttttttt {
  background-color: #ffffff !important;
}
.listttttttttttt + .van-overlay {
  background-color: rgba(0, 0, 0, 0.7);
}
</style>