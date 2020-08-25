<template>
  <f7-page>
    <div>
      <div class="tit">请点击对应按钮拍摄身份证照片</div>
      <div>
        <div class="photo" @click="uploadIDCards(0)">
           <img :src="images.back" width="210" height="145"  class="images1"/>
           <div >
            <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
            <div class="tip">点击拍照/上传人像面</div>
           </div>
        </div>
      </div>
      <div>   
        <div class="photo"  @click="uploadIDCards(1)" >
            <img :src="images.front"   width="210" height="145" class="images2"/>
           <div>
              <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
              <div class="tip">点击拍照/上传国徽面</div>
           </div>
        </div>
      </div>
    </div>
      <f7-block>
        <van-button type="danger" round @click="goBack">确定</van-button>
      </f7-block>
  </f7-page>
</template>

<script>
import {photo} from "@/api/api_estate.js";
import {uploadBase64Image} from "@/api/api_common.js";
    export default {
        name:"photoIDCard",
        data(){
          return {
            images:{
                front:'',
                back:''
            },
          }
        },
        created(){
           this.$commonUtils.setTitle("身份证照片");
           console.log(this.$f7router);
        },
        methods:{
         goBack(){
             this.$f7router.back({
                 props: {
                     foo: 'bar',
                     bar: true,
                 }
             });
         },
         uploadIDCards(value){
             let _this = this;
            wx.uploadIDCard({
                source: value == 0 ? "faceIdcard":"countryIdcard",
                success: function(res) {
                    if(value == 0){
                        _this.images.back = res;
                    }else{
                        _this.images.front = res;
                    }
                }
            });
          },
        },
      }
      
</script>
<style scoped>
.tit{
  text-align: center;
  margin: 1rem;
}
.tit2{
  text-align: center;
  width: 12rem;
  margin: 1.2rem auto;
  font-size: .7rem;
  margin-left: 23.5%;
  font-size: 16px;
  background: #03a9f4;
  border: none;
}
.photo{
  width: 13rem;
  height: 9rem;
  /*border-radius: .3rem;*/
  background: #dddddd;
  margin: .6rem auto;
  position: relative;
}
.camerabox{
  width: 100%;
  -webkit-border-radius:5px;
  -moz-border-radius:5px;
  border-radius: 5px;
  height: 100%;
  display: none;
}
.fileInpBtn{
  position: absolute;
  left: 2;
  top: 0;
  cursor: pointer;
  width: 100%;
  height: 100%;
  /* filter:alpha(opacity:0); */
  opacity: 0;
  border-color:orange;
  z-index:10;
  border: solid red 1px;

}
.cameraPicture{
  position: absolute;
  color: #03a9f4;
  font-size: 3rem;
  top: 15%;
  left:40%;
}
.tip{
  position: absolute;
  bottom: 15%;
  text-align: center;
  width: 100%;
  /* color: #03a9f4; */
}
.imgs{
  float: right;
}
.images1{
  position: relative;
  z-index:10; 
}
.images2{
  position: relative;
  z-index:10; 
}
</style>


