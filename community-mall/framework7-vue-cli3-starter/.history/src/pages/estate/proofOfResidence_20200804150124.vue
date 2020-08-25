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
            <div class="photo" @click="uploadIDCards(0)">
                <img class="camerabox" id="newImage1" src="">
                <!-- <input class="fileInpBtn" id="fileInpBtn1" type="file" accept="image/*"> -->
                <div id="camera1">
                    <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                    <div class="tip"></div>
            </div>
        </div>
        <span>合同首页</span>
        
        <div class="photo" @click="uploadIDCards(0)">
            <img class="camerabox" id="newImage1" src="">
            <!-- <input class="fileInpBtn" id="fileInpBtn1" type="file" accept="image/*"> -->
            <div id="camera1">
                <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                <div class="tip"></div>
            </div>
        </div>
        
        <span>签章页</span>
        </div>
        <div class="selfLivings">
            <div class="photo" @click="uploadIDCards(0)">
              <div v-for="(item,index) in imgList" :key="index">
                <img class="camerabox" id="newImage1" :src="item">
              </div>
              <div>
                <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
              </div>
            </div>
            <span>信息页(包含租赁<br>房屋的地址及期限)</span>
        </div>
        <div class="contract">
            <span class="house">房产证照片(原件或扫描件照片)</span>
            <div class="photo" @click="uploadIDCards(0)">
                <img class="camerabox" id="newImage1" src="">
                <!-- <input class="fileInpBtn" id="fileInpBtn1" type="file" accept="image/*"> -->
                <div id="camera1">
                    <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                    <div class="tip"></div>
                </div>
            </div>
            <span class="house">房屋登记主要内容页</span>
            <div class="Examples">
                <div class="photo" @click="uploadIDCards(0)">
                <img class="camerabox" id="newImage1" src="">
                <!-- <input class="fileInpBtn" id="fileInpBtn1" type="file" accept="image/*"> -->
                <div id="camera1">
                    <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                    <div class="tip"></div>
                </div>
                </div>
            <span class="house">房屋登记表页</span>
            </div>
        </div>
        
        </van-grid>  
        <div>
            <van-divider  dashed hairline :style="{ color: '#1989fa', borderColor: '#1989fa', padding: '0 16px' }"/>
            <van-button class="left" color="#03a9f4" plain >点击查看内容页示例</van-button>
            <van-button class="right" color="#03a9f4" plain>点击查看登记表页示例</van-button>
        </div>
        <div>
            <van-button  type="info"   class="tit2">保存</van-button>
        </div>
        </div>
    </f7-page>
</template>

<script>
import {proofOfResidence} from "@/api/api_estate.js";
import Vue from 'vue';
import { Grid, GridItem ,Divider} from 'vant';

Vue.use(Grid);
Vue.use(GridItem);
Vue.use(Divider);
    export default {
        name:"proofOfResidence",
        data(){
            return {
              imgList:[]
            }
        },
        created(){

        },
        methods:{
          uploadIDCards(value){
              //this.$f7router.navigate(`/estate/applyDoorAuth`);  
              // alert("111") 
            let that=this;
           
              wx.uploadIDCard({
                source:"camera",
                success:function(res){
                  that.imgList.push(res);
                }
              })
          },
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
    margin-left: 80px;
    margin-top: 20px;
}
.contract{
    margin-top: 15px;
    text-align: left;
    /* margin-left: -3px; */
}
.contract .photo{
    margin-left: 40px;
}
.house{
    margin-left: 40px; 
}
.Examples{
    float: right;
    margin-top:-120px;
}
.left{
    margin-left: 10px;
    width: 160px;
}
.right{
    float: right;
    width: 180px;
    margin-right: 10px;
}
.ress{
   padding-left: 0px; 
}

</style>


