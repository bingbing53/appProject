<template>
  <f7-page>
    <div>
       <div class="tit">上传居住材料</div>
    </div>
    <div>
      <div>
        <span class="Renting" style="text-align: center;" v-on:click="qh(true)"  >租房</span>
        <span class="selfLiving" v-on:click="qh(false)" >自住</span>
      </div>
    <van-grid>
      <div  v-if="temp">
          <div class="Rentings">
            <div class="left1">
            租房合同信息
              <div class="photo" @click="uploadIDCards1(0)" >
                <div v-for="(item,index) in imgList1" :key="index">
                  <img  :src="item" width="95" height="95" class="images1">
                </div> 
                <div>
                  <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                </div>
            </div>
            <span>合同首页</span>
            </div>
            <div class="right1">
              <div class="photo" @click="uploadIDCards2(0)">
                <div v-for="(item,index) in imgList2" :key="index">
                  <img  :src="item" width="95" height="95" class="images2">
                </div>
                  <div>
                      <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                  </div>
              </div>
              <span>签章页</span>
            </div>
          </div>
          <div class="selfLivings " id="center">
              <div class="photo information" @click="uploadIDCards3(0)">
                <div v-for="(item,index) in imgList3" :key="index">
                  <img  :src="item" width="95" height="95" class="images3">
                </div>
                <div>
                  <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                </div>
              </div>
              <span class="selfLivingsinformation">信息页(包含租赁房屋的地址及期限)</span>
          </div>
          <div class="contract"   v-if="!temp">
            <span class="house">房产证照片(原件或扫描件照片)</span>
            <div class="photo" @click="uploadIDCards4(0)">
                <div v-for="(item,index) in imgList4" :key="index">
                   <img :src="item" width="95" height="95" class="images4">
                </div>  
                <div>
                    <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                </div>
            </div>
            <span class="house">房屋登记主要内容页</span>
            <div class="Examples">
                <div class="photo" @click="uploadIDCards5(0)">
                  <div v-for="(item,index) in imgList5" :key="index">
                    <img  :src="item" width="95" height="95" class="images5">
                  </div>  
                <div>
                    <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                </div>
              </div>
              <span class="house">房屋登记表页</span>
            </div>
              <div>
            <van-divider  dashed hairline :style="{ color: '#1989fa', borderColor: '#1989fa', padding: '0 16px' }"/>
            <van-button class="left" color="#03a9f4" plain >点击查看内容页示例</van-button>
            <van-button class="right" color="#03a9f4" plain>点击查看登记表页示例</van-button>
          </div>
        </div>
      </div>
       
         <div class="contract"   v-if="!temp">
            <span class="house">房产证照片(原件或扫描件照片)</span>
            <div class="photo" @click="uploadIDCards4(0)">
                <div v-for="(item,index) in imgList4" :key="index">
                   <img :src="item" width="95" height="95" class="images4">
                </div>  
                <div>
                    <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                </div>
            </div>
            <span class="house">房屋登记主要内容页</span>
            <div class="Examples">
                <div class="photo" @click="uploadIDCards5(0)">
                  <div v-for="(item,index) in imgList5" :key="index">
                    <img  :src="item" width="95" height="95" class="images5">
                  </div>  
                <div>
                    <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                </div>
              </div>
              <span class="house">房屋登记表页</span>
            </div>
              <div>
            <van-divider  dashed hairline :style="{ color: '#1989fa', borderColor: '#1989fa', padding: '0 16px' }"/>
            <van-button class="left" color="#03a9f4" plain >点击查看内容页示例</van-button>
            <van-button class="right" color="#03a9f4" plain>点击查看登记表页示例</van-button>
          </div>
        </div>
        </van-grid>  
      
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
              actiove:0,
              temp:true,
              imgList1:[],
               imgList2:[],
                imgList3:[],
                 imgList4:[],
                  imgList5:[],
            }
        },
        created(){

        },
        methods:{
          qh:function(t){
            this.temp=t
          },
          uploadIDCards1(value){
              //this.$f7router.navigate(`/estate/applyDoorAuth`);  
              let that=this;   
              if(that.imgList1.length==0){ 
                 wx.uploadIDCard({
                source:"camera",
                success:function(res){
                   //alert("111") 
                  that.imgList1.push(res);
                }
              })    
              }
          },
           uploadIDCards2(value){
              //this.$f7router.navigate(`/estate/applyDoorAuth`);  
              let that=this;   
              if(that.imgList2.length==0){  
                 wx.uploadIDCard({
                source:"camera",
                success:function(res){
                   //alert("111") 
                  that.imgList2.push(res);
                }
              })   
              }
          },
           uploadIDCards3(value){
              //this.$f7router.navigate(`/estate/applyDoorAuth`);  
            let that=this;        
             if(that.imgList3.length==0){
                wx.uploadIDCard({
                source:"camera",
                success:function(res){
                   //alert("111") 
                  that.imgList3.push(res);
                }
              })
             }
          },
           uploadIDCards4(value){
              //this.$f7router.navigate(`/estate/applyDoorAuth`);  
            let that=this;        
             if(that.imgList4.length==0){
                wx.uploadIDCard({
                source:"camera",
                success:function(res){
                   //alert("111") 
                  that.imgList4.push(res);
                }
              })
             }
          },
           uploadIDCards5(value){
              //this.$f7router.navigate(`/estate/applyDoorAuth`);  
            let that=this;        
             if(that.imgList5.length==0){
                wx.uploadIDCard({
                source:"camera",
                success:function(res){
                   //alert("111") 
                  that.imgList5.push(res);
                }
              })
             }
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
  list-style: none
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
    margin-left: 42%;
}
.selfLivings{
    float: right;
    margin-left: 60px;
    margin-top: 20px;
}
.information{
  margin-left: -10px;
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
    margin-right: 30px;
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
.images1{
  position: relative;
  z-index: 10;
}
.images2{
  position: relative;
  z-index: 10;
}
.images3{
  position: relative;
  z-index: 10;
}
.images4{
  position: relative;
  z-index: 10;
}
.images5{
  position: relative;
  z-index: 10;
}
.information{
  margin-left: 70px;
}
.left1{
  float: left;
}
.right1{
  float: right;
  margin-top: 20px;
  margin-left: 90px;
}
#center{
  float: left;
  margin-left:-30px;
}
.selfLivingsinformation{
  margin-left: 70px;
}

</style>


