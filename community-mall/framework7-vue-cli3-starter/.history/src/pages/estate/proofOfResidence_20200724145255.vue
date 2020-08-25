<template>
  <f7-page>
    <div>
       <div class="tit">上传居住材料</div>
    </div>
    <div>
        <span class="Renting" style="text-align: center;">租房</span>
        <span class="selfLiving">自住</span>
      <van-grid>
         <div class="Rentings">
             租房合同信息
            <div class="photo">
                <img class="camerabox" id="newImage1" src="">
                <input class="fileInpBtn" id="fileInpBtn1" type="file" accept="image/*">
                <div id="camera1">
                    <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                    <div class="tip"></div>
                 </div>
            </div>
            <span>合同首页</span>
            <div class="photo">
                <img class="camerabox" id="newImage1" src="">
                <input class="fileInpBtn" id="fileInpBtn1" type="file" accept="image/*">
                <div id="camera1">
                    <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                    <div class="tip"></div>
                 </div>
            </div>
            <span>签章页</span>
           
          </div>
            <div class="selfLivings">
                <div class="photo">
                    <img class="camerabox" id="newImage1" src="">
                    <input class="fileInpBtn" id="fileInpBtn1" type="file" accept="image/*">
                    <div id="camera1">
                        <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                        <div class="tip"></div>
                    </div>
                </div>
            </div>
            <div class="contract">
                <span>合同首页</span>
                <div class="photo">
                    <img class="camerabox" id="newImage1" src="">
                    <input class="fileInpBtn" id="fileInpBtn1" type="file" accept="image/*">
                    <div id="camera1">
                        <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                        <div class="tip"></div>
                    </div>
                </div>
                <span>房屋登记主要内容页</span>
            </div>
      </van-grid>  
    </div>
  </f7-page>
</template>

<script>
import {proofOfResidence} from "@/api/api_estate.js";
import Vue from 'vue';
import { Grid, GridItem } from 'vant';

Vue.use(Grid);
Vue.use(GridItem);
    export default {
        name:"proofOfResidence",
        data(){
            return {

            }
        },
        created(){

        },
        methods:{
          uploadIDCard(){     
              this.$f7router.navigate(`/estate/applyDoorAuth/`);               
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
  width: 6rem;
  height: 6rem;
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
.Renting{
    margin-left: 20%;
}
.Rentings{
    margin-left: 40px;
    text-align: center;
}
.selfLiving{
    margin-left: 45%;
}
.selfLivings{
    float: right;
    margin-left: 90px;
    margin-top: 20px;
}
.contract{
    margin-top: 15px;
    text-align: center;
    margin-left: 25px;
}
</style>


