<template>
  <div>
    <home-header ref="header" :isdownload="1">
    </home-header>
    <div class="out_center_down" style="position:relative">
      <div class="container">
        <div class="center_text" style="margin-top:10.6rem">
          <p class="f32 tc top_gray">下载APP，玩转掌上社区</p>
          <p class="under_text f14 mt10">居委会，物业，居民APP，社区工作手机移动解决</p>
        </div>
        <div class="center_image tc">
          <a-row class="list_image_down tc" type="flex" :justify="center">
            <a-col :xs="24" :sm="24" :md="24" :lg="24">
              <h4 class="f18 mb20 fb">街乡、居委会办公APP</h4>
              <div class="text_des">
                <p>实时接收居民反馈、线上吹哨报到;</p>
                <p>手机入户、信息入库、工作留痕;</p>
                <p>工作日程、计划安排、考勤打卡</p>
              </div>
            </a-col>
            <a-col :xs="12" :sm="12" :md="12" :lg="12">
              <div class="item_image">
                <div class="svg_image">
                  <img src="@/assets/image/apple-o.svg" alt class="look_iamge" />
                  <img src="@/assets/image/bangongI.png" alt class="down_iamge" width="120" />
                  <p class="mt10">iOS下载</p>
                </div>
              </div>
            </a-col>
            <a-col :xs="12" :sm="12" :md="12" :lg="12">
              <div class="item_image">
                <div class="svg_image">
                  <img src="@/assets/image/android-o.svg" alt  class="look_iamge"/>
                   <img src="@/assets/image/bangongA.png" alt class="down_iamge" width="120" />
                  <p class="mt10">Android下载</p>
                </div>
              </div>
            </a-col>
          </a-row>
          <a-row class="list_image_down tc" type="flex" :justify="center">
            <a-col :xs="24" :sm="24" :md="24" :lg="24">
              <h4 class="f18 mb20 fb">物业办公APP</h4>
              <div class="text_des">
                <p>随时接受居民预约订单、订单处理状态随时监控;</p>
                <p>及时发现小区问题;</p>
                <p>门禁状态移动监控;</p>
              </div>
            </a-col>
            <a-col :xs="12" :sm="12" :md="12" :lg="12">
              <div class="item_image">
                <div class="svg_image">
                  <img src="@/assets/image/apple-o.svg" alt class="look_iamge" />
                  <img src="@/assets/image/wuyeI.png" alt class="down_iamge" width="120" />
                  <p class="mt10">iOS下载</p>
                </div>
              </div>
            </a-col>
            <a-col :xs="12" :sm="12" :md="12" :lg="12">
              <div class="item_image">
                <div class="svg_image">
                  <img src="@/assets/image/android-o.svg" alt class="look_iamge" />
                  <img src="@/assets/image/wuyeA.png" alt class="down_iamge" width="120" />
                  <p class="mt10">Android下载</p>
                </div>
              </div>
            </a-col>
          </a-row>
          <a-row class="list_image_down tc" type="flex" :justify="center">
            <a-col :xs="24" :sm="24" :md="24" :lg="24">
              <h4 class="f18 mb20 fb">社区居民APP</h4>
              <div class="text_des">
                <p>线上办公、反馈问题、及时了解身边事;</p>
                <p>通过线上预约物业服务、手机开门、人脸开门;</p>
                <p>享受商圈服务、公益币享购买优惠;</p>
              </div>
            </a-col>
            <a-col :xs="12" :sm="12" :md="12" :lg="12">
              <div class="item_image">
                <div class="svg_image">
                  <img src="@/assets/image/apple-o.svg" alt class="look_iamge" />
                  <img src="@/assets/image/juminI.png" alt class="down_iamge" width="120" />
                  <p class="mt10">iOS下载</p>
                </div>
              </div>
            </a-col>
            <a-col :xs="12" :sm="12" :md="12" :lg="12">
              <div class="item_image">
                <div class="svg_image">
                  <img src="@/assets/image/android-o.svg" alt class="look_iamge"  />
                  <img src="@/assets/image/juminA.png" alt class="down_iamge" width="120" />
                  <p class="mt10">Android下载</p>
                </div>
              </div>
            </a-col>
          </a-row>
        </div>
      </div>
      <home-footer></home-footer>
    </div>
    
  </div>
</template>

<script>
import homeFooter from "./home/homeFooter";
import homeHeader from "./home/homeHeader";
export default {
  name: "downLoadPage",
  components: {
    homeFooter,
    homeHeader
  },
  data(){
    return{
     

    }
  },

};
</script>

<style>
.under_text {
  color: #666666;
  text-align: center;
}
.center_image {
  margin-top: 60px;
}
.list_image_down {
  padding: 0px 180px;
  margin: 40px auto 60px auto;
}
.list_image_down .item_image {
  margin: 0 auto;
  width: 100%;
  margin-top: 20px;
}
.list_image_down .item_image .svg_image {
  border: 1px solid #eee;
  width: 280px;
  height: 220px;
  display: inline-block;
  padding: 40px 0px;
  background: #ffffff;
}
.list_image_down .item_image .svg_image:hover {
  box-shadow: 1px 5px 10px #cccccc;
}
.list_image_down .item_image .svg_image:hover .look_iamge {
  display: none;
}
.list_image_down .item_image .svg_image .down_iamge {
  display: none;
}
.list_image_down .item_image .svg_image:hover .down_iamge {
  display: inline-block;
}
.des {
  margin: 0 auto;
  padding-left: 32px;
}
.text_des p{
    line-height: 30px;
}
</style>