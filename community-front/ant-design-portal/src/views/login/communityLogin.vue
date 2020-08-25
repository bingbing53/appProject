<template>
  <div class="community">
    <div class="main">
      <div class="out_container">
        <div class="header_bar p10 header navBarWrap">
          <a-row>
            <a-col :span="1"></a-col>
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
          </a-row>
          <div style="float:right;margin-top:-18px;margin-right:20px">
            <span class="backButton">
              <a-button type="primary" @click="goback" style="font-size:12px!important">返回首页</a-button>
            </span>
          </div>
        </div>
      </div>
    </div>
    <div class="bottom_help">
      <div class="bottom_record bottom_gary">
        <p class="f16">© 2012-2020 信驿科技 - 基层治理与服务平台</p>
        <p class="f16" @click="jumpUrl">京ICP备15030023号</p>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: "CommunityLogin",
  components: {},
  data() {
    return {};
  },
  methods:{
    goback() {
       this.$router.push({ path: "/" });
    }
  }
};
</script>
<style>
.header_bar {
  height: 60px;
}
.main {
  width: 100%;
  height: 600px;
  background: url("../../assets/image/bgc.jpg") 50% no-repeat;
  background-size: cover;
}
.bottom_help {
  text-align: center;
}
.backButton .ant-btn-primary{
  background-color:#d0121b !important;
  border-color: #d0121b!important;
}
</style>