<template>
  <f7-page>
    <f7-block>
      <div class="rich_media_title">{{content.title }}</div>
      <div v-html="content.content" class="rich"></div>
    </f7-block>
    <f7-toolbar position="bottom" style="height: 45px;background-color: #fff;">
      <f7-row style="width: 100%;" class="text-c">
        <f7-col width="50">
          <div
            :class="[!!traderContents.mobile ? 'f-14':'f-14 c-999']"
            @click="mobileAppoint()"
          >电话预约</div>
        </f7-col>
        <f7-col width="50">
          <div
            :class="[traderContents.isAppoint == '1' ? 'f-14' : 'f-14 c-999']"
            @click="iAppoint()"
          >我要预约</div>
        </f7-col>
      </f7-row>
    </f7-toolbar>
  </f7-page>
</template>

<script>
import { traderContent } from "@/api/api_community.js";
export default {
  data() {
    return {
      traderId: "",
      content: {},
      traderContents: {}
    };
  },
  created() {},
  mounted() {
    var params = this.$f7route.params;
    if (params.traderId != null && params.traderId.length > 0) {
      this.traderId = params.traderId;
      this.getDetail(params.traderId);
    }
  },
  methods: {
    mobileAppoint() { 
      if (!!this.traderContents.mobile) {
         wx.diaMobile(this.traderContents.mobile);
      }
    },
    iAppoint() {
      if (this.traderContents.isAppoint == "1") {
        this.$f7router.navigate(`/community/traderOrder/${this.traderId}/`);
      }
    },
    getDetail(id) {
      traderContent(id).then(res => {
        var result = res.data;
        this.content = result.traderList;
        if (result.traderContents != null) {
          this.content.content = result.traderContents.content;
          this.traderContents = result.traderContents;
        }
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
.rich >>> .flex-box-img {
  flex: 0 0 100px;
  width: 100px;
  height: 100px;
  overflow: hidden;
}
.rich >>> .flex-box-content {
  flex: 1;
  overflow: hidden;
  padding-bottom: 5px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-width: 0;
  margin-right: 3px;
}
.rich >>> .dotdot {
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  display: box;
  -webkit-box-orient: vertical;
  font-size: 16px;
}
.rich >>> .hot {
  color: #ff3b30;
  font-size: 9px;
  margin-right: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-radius: 3px;
  border: solid 1px #ff3b30;
}
.rich >>> .single {
  background: #fff;
  border-bottom: 1px solid rgba(221, 221, 221, 0.6);
  display: flex;
  margin-left: 10px;
  margin-right: 10px;
  padding-bottom: 10px;
  padding-top: 10px;
}
.rich >>> .single span {
  font-size: 12px;
  color: #666;
}
.rich >>> ul {
  margin: 10px;
  padding-left: 10px !important;
}
</style>