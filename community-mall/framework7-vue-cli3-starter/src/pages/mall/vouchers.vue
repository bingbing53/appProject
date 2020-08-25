<template>
  <f7-page class="vouchers trade">
    <van-nav-bar class="myNavBare" title="代金券" left-arrow @click-left="$commonUtils.onClickLeft" />
    <div class="my_vouchers bgcg mine">
      <van-pull-refresh v-model="myVouchers.isLoading" success-text="刷新成功" @refresh="voucherListRefresh">
        <van-list
           v-model="myVouchers.loading"
          :finished="myVouchers.finished"
          finished-text="没有更多了"
          @load="getMy_vouchers"
        >
          <template v-for="(item,index) in myVouchers.items">
            <van-row v-if="!!item.coupon" class="bgcw pd-10 mg-10 border-radius5" :key="index">
              <van-col span="6">
                <div class="left_price">
                  ￥
                  <span class="mr-10" v-if="item.coupon.amount">{{item.coupon.amount}}</span>
                </div>
              </van-col>
              <van-col span="12" class="center_content_out">
                <div class="center_content">
                  <h4 class="mb-10" v-if="item.coupon.name">{{item.coupon.name}}</h4>
                  <p>
                    <span v-if="item.coupon.startTime">{{substringDate(item.coupon.startTime)}}</span> 至
                    <span v-if="item.coupon.endTime">{{substringDate(item.coupon.endTime)}}</span>
                  </p>
                </div>
              </van-col>
              <van-col span="6">
                <div class="right_button">
                  <van-button
                    round
                    size="normal"
                    class="baco c-fff"
                    @click="touse(item.coupon.sysOrgCode)"
                  >使用</van-button>
                </div>
              </van-col>
            </van-row>
          </template>
        </van-list>
      </van-pull-refresh>
    </div>
    <div class="business_vouchers bgcw" style="display:none">
      <van-search class="c-organ" placeholder="输入商家名、搜优惠" />
      <van-row
        class="bgcw pd-10 mg-10 border-radius5 bussiness_row"
        v-for="(item,index) in businessVouchers"
      >
        <van-col span="6">
          <div class="left_price">
            ￥
            <span class="mr-10">{{item.price}}</span>
          </div>
        </van-col>
        <van-col span="12" class="center_content_out">
          <div class="center_content center_content2">
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
      </van-row>
    </div>
  </f7-page>
</template>

<script>
import { businessVouchers, ownVouchers } from "@/api/api_mall.js";
export default {
  data() {
    return {
      myVouchers: {
        isLoading: false,
        pageNumber: 1,
        totalPage: 0,
        loading: false,
        finished: false,
        items: []
      },
      businessVouchers: [
        {
          price: 100,
          title: "好干净保洁",
          explain: "购买满500元使用",
          limit: "还剩10天过期"
        },
        {
          price: 100,
          title: "好干净保洁",
          explain: "购买满500元使用",
          limit: "还剩10天过期"
        }
      ]
    };
  },
  methods: {
    substringDate(time) {
      return time.substring(0, 10);
    },
    //获取我的卡券
    getMy_vouchers() {
      let _this = this;
      let param = {
        pageNum: this.myVouchers.pageNumber,
        pageSize: 10
      };
      ownVouchers(param)
        .then(res => {
          res.data.data.list.forEach((item, index) => {
            _this.myVouchers.items.push(item);
          });
          this.myVouchers.totalPage = res.data.data.totalPage;
          _this.myVouchers.loading = false;
          if (res.data.data.totalPage <= res.data.data.pageNum) {
            _this.myVouchers.finished = true;
          } else {
            _this.myVouchers.pageNumber++;
          }
        })
        .catch(err => {});
    },
    voucherListRefresh() {
      this.myVouchers.totalPage = 0;
      this.myVouchers.pageNumber = 1;
      this.initVouchers(); //加载数据
    },
    initVouchers() {
      let _this = this;
      let param = {
        pageNum: 1,
        pageSize: 10
      };
      ownVouchers(param)
        .then(res => {
          _this.myVouchers.items = [];
          res.data.data.list.forEach((item, index) => {
            _this.myVouchers.items.push(item);
          });
          _this.myVouchers.totalPage = res.data.data.totalPage;
          _this.myVouchers.isLoading = false; //关闭下拉刷新效果
          _this.myVouchers.finished = false;
          if (res.data.data.totalPage <= res.data.data.pageNum) {
            _this.myVouchers.finished = true;
          } else {
            _this.myVouchers.pageNumber++;
          }
        })
        .catch(err => {});
    },
    //获取商家卡券
    async getBussiness_vouchers() {
      let res = await businessVouchers();
    },
    //点击使用 进入商家店铺
    touse(sysCompanyCode) {
      this.$f7router.navigate(`/enter-store/${sysCompanyCode}/`);
    },
    //点击领取
    receive() {
      alert("领取成功");
    }
  },
  created() {
    // this.getMy_vouchers();
  }
};
</script>

<style>
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
.center_content2:after {
  position: absolute;
  content: "";
  top: -10px;
  right: 0;
  height: 13px;
  width: 26px;
  background: #fafafa;
  border-radius: 0 0 13px 13px;
}
.center_content2::before {
  position: absolute;
  content: "";
  bottom: -13px;
  right: 0;
  height: 13px;
  width: 26px;
  background: #fafafa;
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
.business_vouchers {
  height: 100%;
}
.bussiness_row {
  box-shadow: 1px 1px 5px #f0f0f0;
}
</style>