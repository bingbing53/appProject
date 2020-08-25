<template>
  <div class="createUser">
    <div class="fl" @click="gotoHome">
      <img :src="depart.logo" class="logo" />
    </div>
    <div class="fl" @click="gotoHome">
      <p class="departName f-14">{{depart.departName}}</p>
      <p class="c-999 f-12">{{article.createDate}}</p>
    </div>
    <div class="fr mr-10">
      <!-- <van-button type="primary" size="small" v-if="collect == 0" @click="focused(1)">关注</van-button> -->
      <span
        class="f-12 c-fff border-radius5 pd-5 c-bgr"
        @click="focused(1)"
        v-if="collect == 0"
        style="border:1px solid #fd4346"
      >
        <img src="@/assets/guanzhu2.png" width="24px" alt class="v_middle" />
        <i class="v_middle">关注</i>
      </span>
      <span
        class="f-12 c-fff border-radius5 pd-5"
        @click="focused(0)"
        v-if="collect == 1"
        style="background:#ccc"
      >
        <i class="v_middle">已关注</i>
      </span>

      <!-- <van-button type="info" size="small" v-if="collect == 1" @click="focused(0)">已关注</van-button> -->
    </div>
    <div class="clear"></div>
  </div>
</template>

<script>
import { articleCreater } from "@/api/api_cms";
import { isFocused, addFocus, delFocus } from "@/api/api_common";
export default {
  name: "articleUser",
  props: {
    article: {
      type: Object,
      default() {
        return {};
      }
    }
  },
  watch: {
    article(val) {
      this.getUserDetail();
    }
  },
  data() {
    return {
      depart: {},
      collect: 0
    };
  },
  methods: {
    gotoHome() {
      // this.$f7router.navigate('/cms/articleUserHome?code='+this.article.sysOrgCode);
      // window.location.href="/#/cms/articleUserHome?code="+this.article.sysOrgCode;
      // wx.toast('你好');
      wx.jumpPage({
        page: "articleHome",
        sysOrgCode: this.article.sysOrgCode
      });
    },
    //关注或取消关注
    focused(type) {
      if (type == 1) {
        //关注
        addFocus("3", this.article.sysOrgCode).then(res => {
          this.collect = 1;
          wx.toast("关注成功");
        });
      } else {
        //取消关注
        delFocus("3", this.article.sysOrgCode).then(res => {
          this.collect = 0;
          wx.toast("取消关注成功");
        });
      }
    },
    //是否关注
    getFocused() {
      isFocused("3", this.article.sysOrgCode).then(res => {
        this.collect = res.data.collect;
      });
    },
    //获取发布者信息
    getUserDetail() {
      articleCreater(this.article.id)
        .then(res => {
          this.depart = res.data;
          this.depart.logo = this.$commonUtils.formatPicture(this.depart.logo);
          this.getFocused();
        })
        .catch(err => {});
    }
  }
};
</script>
<style scoped>
.createUser {
  margin-top: 10px;
  margin-bottom: 10px;
}
.logo {
  margin-right: 10px;
  width: 30px;
  height: 30px;
  vertical-align: top;
  /*display: flex;*/
  border-radius: 50%;
  /*align-items: center;*/
  /*justify-content: center;*/
  /*overflow: hidden;*/
}
</style>