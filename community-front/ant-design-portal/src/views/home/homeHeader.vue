<template>
  <div>
    <div class="out_container">
      <div class="header_bar p20 header navBarWrap" :class="isScroll? 'b_bottom':''">
        <a-row>
          <a-col :span="2"></a-col>
          <a-col :span="8">
            <div>
              <div class="left_logo inline_block mr15">
                <img src="@/assets/image/logo.png" alt width="92" height="24" />
              </div>
              <div class="left_text inline_block f16 fb fitalic">
                <i>基层治理与服务平台</i>
              </div>
            </div>
          </a-col>
          <a-col :span="8" class="top_help">
            <div class="top_right">
              <div class="f14 top_text">
                <p>
                  <span class="top_gray" @click="toDownLoad">下载APP</span>
                </p>

                <!-- <p>
                  <a class="top_gray" href>帮助</a>
                </p>
                <p>
                  <a class="top_gray" href>问题与讨论</a>
                </p>-->
                <!-- <p>
                  <a class="top_gray" href>联系我们</a>
                </p>-->
              </div>
            </div>
          </a-col>
        </a-row>
        <div v-show="isdownload == 1" style="float:right;margin-top:-34px">
          <span class="backButton">
            <a-button type="primary" @click="goback2">返回首页</a-button>
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "homeHeader",
  props: ["isdownload"],
  data() {
    return {};
  },
  methods: {
    toDownLoad() {
      this.$router.push({ path: "/downLoad" });
    },
    goback2() {
      this.$router.push({ path: "/" });
    }
  }
};
</script>

<style>
.top_text p .top_gray:hover {
  color: #d0121b !important;
  cursor: pointer;
}
.top_text {
  display: flex;
  /* justify-content: space-between; */
  justify-content: flex-end;
}
.backButton .ant-btn-primary{
  background-color:#d0121b !important;
  border-color: #d0121b!important;
}
</style>