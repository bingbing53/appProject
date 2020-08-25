<template>
  <f7-page>
    <div  class="aui-bar aui-bar-nav">
      <a class="aui-pull-left aui-btn"> 
          <span class="aui-iconfont aui-icon-left"></span>
          <!-- <div class="aui-title">身份证拍照验证</div> -->
      </a>
      </div>
    <div>
      <div class="tit">请将身份证置于框内拍摄</div>
      <div v-for="(item,index) in imgList" :key="index"></div>
          <div class="photo"  v-if="imgList.length<6" @click="uploadimg">
              <img class="camerabox" id="newImage1" src="">
              <!-- <input class="fileInpBtn" id="fileInpBtn1" type="file" accept="image/*"> -->
              <div id="camera1">
                <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                <div class="tip">点击拍照/上传人像面</div>
              </div>
          </div>
        <div v-for="(item,index) in imgList" :key="index"></div>
        <div class="photo"  v-if="imgList.length<6" @click="uploadimg" >
          <img class="camerabox" id="newImage2" src="">
          <!-- <input class="fileInpBtn" id="fileInpBtn2" type="file" accept="image/*"> -->
          <div id="camera2">
            <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
            <div class="tip">点击拍照/上传国徽面</div>
          </div>
        </div>
    </div>
       <van-button  type="info"   class="tit2">保存</van-button>
  </f7-page>
</template>

<script>
// import {photoIDCard} from "@/api/api_estate.js";
    export default {
        name:"photoIDCard",
        data(){
          return {
            imgList:[]
          }
        },
        created(){

        },
        methods:{
           uploadimg(value){
              this.$f7router.navigate(`/estate/applyDoorAuth`);  
              
              let that=this;      
              wx.uploadIDCard({
                success:function  ready(value){
                  alert("111") 
                  value = eval(value);
                  value.forEach((el, index) => {
                  that.imagesList.push(el);
                  that.imgList.push(el);
                 });
                }
              })       
          },
           async  tit2(){
             alert("111");
            let resultarr=[];
            let resultJson="";
            if(this.imgList.length>0){
              wx.loading("图片上传中");
            for(var i=0;i<this.imgList.length;i++){
              var result = await uploadBase64Image({
                upfile:this.imagesList[i]
              }).catch(err=>{
                wx.tost("上传失败");
                wx.closeLoading();
              });
              if(result.status==200){
                resultarr.push(result.data["url"]);
              }
            }
               wx.closeLoading();
               resultJson=resultarr.join(",");
            }
            let param={
              pics: resultJson
            }
          }
        }
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
  border-radius: .3rem;
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
/* .preservation{
  width: 150px;
  margin-top: 150px;
  margin-left: 110px;
} */
</style>


