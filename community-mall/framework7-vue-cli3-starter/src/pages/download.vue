<template>
  <f7-page>
    <div>
      <section class="download_c">
        <img :src="background" alt width="100%" />
        <!-- 安卓 -->
        <div class="tk" v-show="device == 1">
          <!-- 不是微信浏览器 -->
          <div v-show="weixin == 2">
            <a
              href="https://image.shequyijia.cn/pic/app/jmapp.apk"
              style="display:inline-block"
              class="external"
            >
              <img :src="Android" alt width="100%" />
            </a>
          </div>
          <!-- 微信浏览器 -->
          <div @click="showpop" v-show="weixin == 1">
            <img :src="Android" alt width="100%" />
          </div>
        </div>
        <!-- 苹果 -->
        <div class="tk" v-show="device == 2">
          <div v-show="weixin == 2">
            <a
              href="https://apps.apple.com/cn/app/%E7%A4%BE%E5%8C%BAe%E5%AE%B6-%E5%B1%85%E6%B0%91/id1514570392"
              style="display:inline-block"
              class="external"
            >
              <img :src="ipnone" alt v-show="weixin == 2" width="100%" />
            </a>
          </div>
          <div @click="showpop" v-show="weixin == 1">
            <img :src="ipnone" alt width="100%" />
          </div>
        </div>
      </section>
      <van-popup v-model="pop" class="mypopDown" position="top">
        <div class="pd-10 pt-30">
          <div class="fr pr-20">
            <img :src="toload" alt width="42.56vw" height="42.56vw" />
          </div>
          <div class="clear"></div>
          <div class="mt-10 pt-10">
            <p class="c-fff tc">请点击右上角按钮，使用浏览器打开</p>
          </div>
        </div>
      </van-popup>
    </div>
  </f7-page>
</template>
<script>
export default {
  data() {
    return {
      background: require("@/assets/img/tpage.jpg"),
      Android: require("@/assets/img/tdownload.png"),
      ipnone: require("@/assets/img/tdownload.png"),
      toload: require("@/assets/img/toload.png"),
      device: 0,
      weixin: 0,
      pop: false
    };
  },
  methods: {
    showpop() {
      this.pop = true;
    },
    getdeviceInfo() {
      let u = navigator.userAgent;
      let isAndroid = u.indexOf("Android") > -1 || u.indexOf("Adr") > -1; //android终端
      let isiOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/); //ios终端
      if (isAndroid) {
        setTimeout(function() {
          window.location.href = "shequyijia://trust-tech/open";
        }, 500);
        this.device = 1;
      }
      if (isiOS) {
        this.device = 2;
      }
    },
    getWeixin() {
      let ua = navigator.userAgent.toLowerCase();
      let isWeixin = ua.indexOf("micromessenger") != -1; //是否是微信浏览器打开
      if (isWeixin) {
        this.weixin = 1; //微信
      } else {
        this.weixin = 2;
      }
    }
  },
  mounted() {
    this.getdeviceInfo();
    this.getWeixin();
  },
  created() {}
};
</script>
<style scoped>
.download_c {
  position: relative;
}
.tk {
  position: absolute;
  top: 74%;
  left: 20%;
  width: 60%;
}
.van-popup {
  background: transparent;
}
.mypopDown {
  z-index: 999999 !important;
}
</style>


