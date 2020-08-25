<template>
  <f7-page>
    <van-tabs v-model="active" animated sticky swipeable>
      <van-tab title="活动详情">
        <f7-block class="pageContent">
          <div class="rich_media_title">{{detail.activity.title }}</div>
          <div class="pd-10">
            <van-image width="100%" v-if="detail.activity.posterUrl" :src="formatImage(detail.activity.posterUrl)"></van-image>
          </div>
          <div v-html="detail.activity.content" class="rich"></div>
          <div class="fr pt-10 mr-10" @click="toShare()">
            <img src="@/assets/fenxiang.png" width="20" alt />
          </div>
          <div
            class="fl f-14 c-999 pt-10 ml-10"
            v-if="!!detail.activity.title"
          >阅读数 {{detail.activity.hits || 1}}</div>

          <div class="clear"></div>
        </f7-block>
        <div class="line pt-5"></div>
        <van-cell-group title="活动规则">
          <van-cell icon="clock-o" title="活动开始时间" :value="detail.activity.startTime" />
          <van-cell icon="clock-o" title="活动截止时间" :value="detail.activity.endTime" />
          <van-cell icon="friends-o" title="招募人数" :value="detail.activity.limitNum" />
          <van-cell icon="location-o" title="活动地点" :value="detail.activity.location" />
          <van-cell icon="user-o" title="联系人" :value="detail.activity.contact" />
          <van-cell
            icon="phone-o"
            title="联系电话"
            :value="detail.activity.contactMobile"
            @click="dialogMobile(detail.activity.contactMobile)"
          />
          <van-cell v-if="detail.activity.activityState == '1' && detail.doSignUp == '0'">
            <van-button type="danger" round @click="signActivity">我 要 报 名</van-button>
          </van-cell>
          <van-cell v-if="detail.doSignUp == '1'">
            <van-button disabled type="default" round>已 报 名</van-button>
          </van-cell>
          <van-cell v-if="detail.doSignup == '2'">
            <van-button disabled type="info" round>名 额 已 满</van-button>
          </van-cell>
        </van-cell-group>
        <div class="line pt-5"></div>
        <van-cell-group
          title="报名领取代金券"
          v-if="!!detail.smsCoupon && detail.smsCoupon.length > 0"
          style="padding:10px 0px;background:#eee"
        >
          <van-row
            class="bgcw pd-10 mg-10 border-radius5 bussiness_row"
            v-for="(item,index) in detail.smsCoupon"
          >
            <van-col span="6">
              <div class="left_price">
                ￥
                <span class="mr-10">{{item.amount}}</span>
              </div>
            </van-col>
            <van-col span="12" class="center_content_out">
              <div class="center_content center_content2">
                <h4 class="mb-10">{{item.name}}</h4>
                <p>{{item.note}}</p>
                <!--<p>{{item.limit}}</p>-->
              </div>
            </van-col>
            <van-col span="6">
              <div class="right_button">
                <van-button
                  round
                  size="normal"
                  v-show="item.getable == 1"
                  class="c-999"
                  v-if="$commonUtils.timeStampOVer(item.endTime)"
                >
                  <template>已过期</template>
                </van-button>
                <van-button
                  v-else
                  round
                  size="normal"
                  v-show="item.getable == 1"
                  class="baco c-fff"
                  :disabled="detail.doSignUp != '1'"
                  @click="tabVouchers(item.id,index)"
                >领取</van-button>
                <van-button round size="normal" v-show="item.getable == 0" class="c-999">已领取</van-button>
              </div>
            </van-col>
          </van-row>
        </van-cell-group>
        <div class="line pt-5" v-if="!!detail.smsCoupon && detail.smsCoupon.length > 0"></div>
        <van-cell-group title="已报名志愿者">
          <van-cell v-for="item in registerList">
            <div class="fl mr-10">
              <van-image round width="2.5rem" height="2.5rem" :src="item.image" />
            </div>
            <div>
              <p>{{item.nickName || '志愿者'}}</p>
              <p class="f-12 c-666">报名时间：{{item.registerTime}}</p>
            </div>

            <div class="clear"></div>
          </van-cell>
        </van-cell-group>
      </van-tab>
      <van-tab title="活动总结">
        <f7-block>
          <div class="rich_media_title">{{detail.summary.title }}</div>
          <div v-html="detail.summary.content" class="rich"></div>
        </f7-block>
      </van-tab>
      <van-tab title="积分公示">
        <div v-if="detail.isSign == '1'">
          <form action="/">
            <van-search
              v-model="searchValue"
              placeholder="请输入搜索关键词"
              show-action
              shape="round"
              @search="searchChange"
            >
              <div slot="action" @click="searchChange">搜索</div>
            </van-search>
          </form>
        </div>
        <div v-if="searchRegisterList.length <= 0" class="tc mt-20 c-999">没有数据</div>
        <div v-else>
          <van-cell-group>
            <van-cell v-for="item in searchRegisterList" @click="registerVolunteer(item)">
              <div class="fl mr-10">
                <van-image round width="2.5rem" height="2.5rem" :src="item.image" />
              </div>
              <div>
                <p>
                  <span v-if="detail.isSign == '1'" class="pr-10">
                    {{item.realName || ''}}
                    <span class="c-999 pl-5">{{item.nickName || '志愿者'}}</span>
                  </span>
                  <span v-else class="pr-10">{{item.nickName || '志愿者'}}</span>

                  <van-tag class="f-10" plain v-if="item.register == '2'">未签</van-tag>
                  <van-tag class="f-10" plain type="success" v-if="item.register == '1'">已签</van-tag>
                  <van-tag class="f-10" plain type="default" v-if="item.register == '0'">缺勤</van-tag>
                </p>
                <p class="f-12 c-666">
                  <van-tag class="pl-10 pr-10" round type="primary">时长 | {{item.timeLong || 0}}</van-tag>
                  <van-tag class="ml-10 pl-10 pr-10" round type="primary">积分 | {{item.points || 0}}</van-tag>
                </p>
              </div>
              <div class="clear"></div>
            </van-cell>
          </van-cell-group>
        </div>
      </van-tab>
    </van-tabs>

    <van-action-sheet v-model="dialogShow">
      <van-cell-group title="报名确认信息">
        <van-field
          v-model="message"
          rows="5"
          autosize
          type="textarea"
          maxlength="500"
          :placeholder="detail.activity.messageTips || '请输入您的留言'"
          show-word-limit
        />
        <van-cell>
          <van-button
            type="danger"
            :disabled="message.length <= 0 && detail.activity.leaveMessage == '2'"
            @click="condirm"
          >确认报名</van-button>
        </van-cell>
      </van-cell-group>
    </van-action-sheet>

    <van-action-sheet
      v-model="volunteerShow"
      :title="volunteer.realName+' 签到'"
      class="pb-10 mysign"
    >
      <van-cell-group>
        <van-cell title="积分">
          <f7-stepper
            :value="detail.activity.points"
            :min="0"
            :max="100"
            :step="1"
            fill
            @stepper:change="setPoints"
          ></f7-stepper>
        </van-cell>
        <van-cell title="时长">
          <van-picker
            :columns="timeColumns"
            @change="timePickerChange"
            :visible-item-count="3"
            :default-index="times"
          />
        </van-cell>
      </van-cell-group>

      <van-row gutter="20" class="pd-10">
        <van-col span="12">
          <van-button type="default" size="small" round @click="signup(0)">缺勤</van-button>
        </van-col>
        <van-col span="12">
          <van-button type="primary" size="small" round @click="signup(1)">到岗</van-button>
        </van-col>
      </van-row>
    </van-action-sheet>
  </f7-page>
</template>
<script>
import Vue from "vue";

import {
  activityDetail,
  activityRegisterList,
  activitySign,
  activityRegister,
  checkActivitySign
} from "@/api/api_cms";
import {
  getComment,
  getCommentSecond,
  addBrowse,
  addPraise,
  delPraise,
  isPraised,
  isFocused,
  addFocus,
  delFocus,
  addComment
} from "@/api/api_common";
import { receiveVouchers } from "@/api/api_mall.js";
import { ActionSheet, Picker, Slider, Toast } from "vant";
Vue.use(ActionSheet)
  .use(Picker)
  .use(Slider);
export default {
  data() {
    return {
      active: 0,
      detail: {
        doSignup: "0",
        activity: {},
        isSign: "0",
        summary: {},
        smsCoupon: []
      },
      registerList: [],
      searchRegisterList: [],
      activityId: "",
      dialogShow: false,
      message: "",

      //志愿者签到
      volunteerShow: false,
      volunteer: {},
      timeColumns: [
        "选择时长",
        "1小时",
        "2小时",
        "3小时",
        "4小时",
        "5小时",
        "6小时",
        "7小时",
        "8小时",
        "9小时",
        "10小时",
        "11小时",
        "12小时",
        "13小时",
        "14小时",
        "15小时",
        "16小时",
        "17小时",
        "18小时",
        "19小时",
        "20小时",
        "21小时",
        "22小时",
        "23小时",
        "24小时"
      ],
      points: 0,
      times: 0,
      searchValue: ""
    };
  },
  created() {
    this.$commonUtils.setTitle("活动详情");
    var id = this.$commonUtils.getUrlKey("id");

    if (!!!id) {
      // id = this.$f7route.query.id;
      id = this.$f7route.params.id;
    }

    this.activityId = id;
    this.getDetail();
    this.getVolunteerList();

    this.loadBrowse(this.activityId);

  },
  methods: {
    loadBrowse(activityId) {
        addBrowse("2", activityId);
    },
    //格式化图片路径
    formatImage(url) {
      return this.$commonUtils.formatPicture(url);
    },
    toShare() {
      let content = this.detail.activity.content;
      let posterUrl = this.formatImage(this.detail.activity.posterUrl);
      let title = this.detail.activity.title;
      content = content.replace(/<[^>]*>|/g, "");
      content = content.replace(/&nbsp;/g, "");
      content = content.substring(0, 1000);
      wx.share({
        picture: posterUrl,
        title: title,
        des: content
      });
    },
    //领取代金券
    tabVouchers(id, index) {
      let param = {
        couponId: id
      };
      receiveVouchers(param)
        .then(res => {
          if (res.data.code == 200) {
            this.detail.smsCoupon[index].getable = 0;
            Toast("领取代金券成功");
          }
        })
        .catch(err => {});
    },
    //搜索改变监听
    searchChange() {
      let that = this;
      if (this.searchValue == "") {
        this.searchRegisterList = this.registerList;
        return;
      }
      this.searchRegisterList = [];
      this.registerList.forEach(function(item) {
        if (item.realName.indexOf(that.searchValue) != -1) {
          that.searchRegisterList.push(item);
        }
      });
    },
    //为志愿者签到
    signup(type) {
      if (this.detail.isSign == "1") {
        activityRegister(this.detail.activity.id, this.volunteer.id, {
          register: type,
          points: this.points,
          timeLong: this.times
        })
          .then(res => {
            wx.toast("签到成功");
            this.volunteerShow = false;
            this.volunteer = {};
            this.getVolunteerList();
          })
          .catch(err => {
            wx.toast("签到失败");
          });
      }
    },
    timePickerChange(picker, value, index) {
      this.times = index;
    },
    setPoints(value) {
      this.points = value;
    },
    //志愿者签到
    registerVolunteer(item) {
      if (this.detail.isSign == "1") {
        this.detail.activity.points = this.detail.activity.points || 0;
        this.points = this.detail.activity.points;
        this.detail.activity.timeLong = this.detail.activity.timeLong || 0;
        this.times = this.detail.activity.timeLong;
        this.volunteerShow = true;
        this.volunteer = item;
        if (!!this.volunteer.points) {
          this.points = this.volunteer.points;
        }
        if (!!this.volunteer.timeLong) {
          this.times = this.volunteer.timeLong;
        }
      }
    },
    dialogMobile(mobile) {
      wx.diaMobile(mobile);
      // window.location.href="tel:"+mobile;
    },
    getDetail() {
      activityDetail(this.activityId).then(res => {
        this.detail = res.data;
      });
    },
    //获取志愿者列表
    getVolunteerList() {
      let that = this;
      activityRegisterList(this.activityId)
        .then(res => {
          that.registerList = [];
          var result = res.data;
          result.forEach(function(item) {
            if (!!item.headImage) {
              item.image = that.$commonUtils.formatPicture(item.headImage);
            }
            that.registerList.push(item);
          });
          that.searchRegisterList = that.registerList;
        })
        .catch(err => {});
    },
    condirm() {
      if (
        !!this.detail.activity.leaveMessage &&
        this.detail.activity.leaveMessage == "2" &&
        this.message.trim().length <= 0
      ) {
        this.dialogShow = true;
        wx.toast("请填写报名信息");
        return;
      }
      this.activitySign();
    },
    //我要报名
    signActivity() {
      checkActivitySign(this.activityId, {
        id: this.activityId
      })
        .then(resCheck => {
          if (
            !!this.detail.activity.leaveMessage &&
            (this.detail.activity.leaveMessage == "1" ||
              this.detail.activity.leaveMessage == "2")
          ) {
            this.dialogShow = true;
            return;
          }
          this.$dialog.confirm({ message: "确认报名次活动吗？" }).then(() => {
            this.activitySign();
          });
        })
        .catch(err => {
          this.$commonUtils.jumpLogin(err);
        });
    },
    activitySign() {
      activitySign(this.activityId, {
        id: this.activityId,
        leaveMessage: this.message
      })
        .then(res => {
          this.getVolunteerList();
          this.dialogShow = false;
          wx.toast("报名成功");
          this.detail.doSignUp = "1";
        })
        .catch(err => {
          this.dialogShow = false;
          this.$commonUtils.jumpLogin(err);
        });
    }
  }
};
</script>

<style scoped>
.rich_media_title {
  /*padding-top: 20px;*/
  padding-bottom: 20px;
  font-size: 22px;
  text-indent: 0px !important;
  line-height: 32px !important;
}

.rich_des {
  font-size: 17px !important;
  line-height: 32px !important;
  text-indent: 0px !important;
  letter-spacing: 2px !important;
  overflow-y: hidden;
}

.rich >>> p {
  font-size: 17px !important;
  line-height: 32px !important;
  text-indent: 0px !important;
  letter-spacing: 2px !important;
  overflow-y: hidden;
}

.rich >>> img {
  max-width: 100%;
  display: block;
}
.rich >>> section,
p {
  max-width: 100% !important;
  text-indent: 0px !important;
}
.rich >>> p img {
  /*display:block;*/
  /*width:100%;*/
  max-width: 100% !important;
  height: auto !important;
  margin-left: 0px !important;
  margin-right: 0px !important;
  padding-left: 0px !important;
  padding-right: 0px !important;
}
.rich >>> .rich_media_title {
  margin-bottom: 10px;
  line-height: 1.4;
  font-weight: 400;
  font-size: 24px;
}
.rich >>> .judgeFix {
  position: fixed !important;
  bottom: 0px;
  width: 100%;
  height: 45px;
  z-index: 10;
  background: #fff;
  border-top: solid 1px #eee;
}
.rich >>> .judge {
  border-top: solid 1px #eee;
  position: fixed;
  bottom: 45px;
  width: 100%;
  height: 120px;
  z-index: 10;
  background: #fff;
  padding-top: 10px;
}
.rich >>> .col-33 {
  height: 45px;
  padding-top: 10px;
}
.rich >>> textarea {
  border: solid 1px #eee !important;
  border-radius: 5px;
  width: 94% !important;
  margin-left: 3%;
  height: 70px;
  background: rgba(221, 221, 221, 0.2);
  padding: 2px;
}
.rich >>> .self {
  color: #007aff;
  font-size: 9px;
  margin-right: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-radius: 3px;
  border: solid 1px #007aff;
}
.mysign .van-action-sheet__header {
  font-size: 20px;
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
  background: #eee;
  border-radius: 0 0 13px 13px;
}
.center_content2::before {
  position: absolute;
  content: "";
  bottom: -34px;
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
</style>