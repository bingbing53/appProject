<template>
  <f7-page>
    <div @click="uploadIDCard(0)">请将身份证至于框内拍摄</div>
    <div class="photo">
      <img class="camerabox" id="newImage1" src="">
      <input class="fileInpBtn" id="fileInpBtn1" type="file" accept="image/*">
      <div id="camera1">
        <i class="aui-iconfont aui-icon-camera cameraPicture"></i>
        <div class="tip">点击拍照/上传人像面</div>
      </div>
    </div>
     <div class="photo">
      <img class="camerabox" id="newImage2" src="">
      <input class="fileInpBtn" id="fileInpBtn2" type="file" accept="image/*">
      <div id="camera2">
        <i class="aui-iconfont aui-icon-camera cameraPicture"></i>
        <div class="tip">点击拍照/上传人像面</div>
      </div>
    </div>
  </f7-page>
</template>

<script>
import {photoIDCard} from "@/api/api_estate.js";
    export default {
        name:"photoIDCard",
        data(){
            return {

            }
        },
        created(){

        },
        methods:{
          uploadIDCard(){     
              this.$f7router.navigate(`/estate/applyDoorAuth`);               
          }
        }
    }
</script>
<style scoped>

</style>