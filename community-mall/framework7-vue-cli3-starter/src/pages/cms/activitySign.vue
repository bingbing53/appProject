<template>
  <f7-page>
    <van-cell-group>
      <van-cell title="活动标题" :value="activity.title" />
      <van-cell title="活动地点" :value="activity.location" />
      <van-cell title="开始时间" :value="activity.startTime" />
      <van-cell title="主题图片">
        <img :src="activity.posterUrl" width="100%" />
      </van-cell>
      <van-cell title="积分时长">
        <van-tag plain class="mr-10 pl-5 pr-5">积分：{{activity.points}}</van-tag>
        <van-tag plain class="pl-5 pr-5">时长：{{activity.timeLong}}</van-tag>
      </van-cell>
    </van-cell-group>

    <f7-block>
      <van-button type="danger" round class="mt-20" @click="confirmSignUp">确 认 签 到</van-button>
    </f7-block>

    <van-action-sheet v-model="dialogShow">
      <van-cell-group title="签到确认信息">
        <van-field
          v-model="message"
          rows="5"
          autosize
          type="textarea"
          maxlength="500"
          :placeholder="activity.messageTips || '请输入您的留言'"
          show-word-limit
        />
        <van-cell>
          <van-button
            type="info"
            :disabled="message.length <= 0 && activity.leaveMessage == '2'"
            @click="signup"
          >确认签到</van-button>
        </van-cell>
      </van-cell-group>
    </van-action-sheet>
  </f7-page>
</template>

<script>
import Vue from "vue";
import { ActionSheet } from "vant";
Vue.use(ActionSheet);
import { getActivityCode, signActivityByCode } from "@/api/api_cms";
export default {
  name: "activitySign",
  data() {
    return {
      code: "",
      activity: {},
      register: "0",
      dialogShow: false,
      message: ""
    };
  },
  created() {
    this.$commonUtils.setTitle("活动扫码签到");
    this.code = this.$commonUtils.getUrlKey("code");

    this.getActivityByCodes();
  },
  methods: {
    confirmSignUp() {
      if (
        this.register == "0" &&
        !!this.activity.leaveMessage &&
        (this.activity.leaveMessage == "1" || this.activity.leaveMessage == "2")
      ) {
        this.dialogShow = true;
        return;
      }

      this.signup();
    },
    //签到
    signup() {
      signActivityByCode({
        code: encodeURIComponent(this.code),
        message: this.message
      })
        .then(res => {
          wx.toast("签到成功");
          wx.popPage();
        })
        .catch(err => {
          wx.toast(err.data);
          wx.popPage();
        });
    },
    //根据code获取活动
    getActivityByCodes() {
      getActivityCode({ code: encodeURIComponent(this.code) })
        .then(res => {
          this.activity = res.data.activity;
          this.register = res.data.register || "0";
          // this.register = '0';
          this.activity.posterUrl = this.$commonUtils.formatPicture(
            this.activity.posterUrl
          );
        })
        .catch(err => {
          if (err.status == 401) {
            this.$commonUtils.jumpLogin(err);
          } else {
            wx.toast(err.data);
            wx.popPage();
          }
        });
    }
  }
};
</script>

<style scoped>
</style>