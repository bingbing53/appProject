<template>
  <f7-page>
   <div>
      <div class="tit">请将面部置于方框内拍摄</div>       
       <div>
          <div class="photo" @click="IdentifyFaces(0)" >
            <div v-for="(item,index) in List" :key="index"> 
              <img :src="item"  @click="imgs(index)"   width="210" height="145"  class="images"/>
            </div> 
            <div>        
              <i class="aui-iconfont aui-icon-camera cameraPicture" >+</i>
              <div class="tip">点击拍照/上传人脸信息</div>
            </div>
          </div>
        </div>
       <div>
         <van-button  type="info"   class="tit2"  @click="IdentifyFacess(0)">重拍</van-button>
       </div>
       <div>
         <van-button  type="info"   class="tit2">保存</van-button>
       </div>
    </div>
  </f7-page>
</template>

<script>
import {faceInformation} from "@/api/api_estate.js";
    export default {
        name:"faceInformation",
        data(){
            return {
             List:[]
            }
        },
        created(){

        },
        methods:{
          IdentifyFaces(value){ 
              //this.$f7router.navigate(`/estate/applyDoorAuth`);  
              let that = this;
            if(that.List.length==0){
              wx.uploadIDCard({
                source: "camera",
                success: function(res) {
                that.List.push(res);
                }
             }); 
            }        
          },
          IdentifyFacess(value){
              let that = this;
              wx.uploadIDCard({
                source: "camera",
                success: function(res) {
                that.List.push(res);
                }
             }); 
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
.images{
  position: relative;
  z-index: 10;
}
</style>


