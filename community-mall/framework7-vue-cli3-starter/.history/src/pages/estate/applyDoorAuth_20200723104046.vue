<template>
  <f7-page>
    <div>
      <van-cell-group>
        <div>
        <van-cell title="上传身份证" 
         v-for="(item,index) in idCardList"  :key="index"  
         @click="uploadIDCard"  
        />
         <van-popup>
          <p >选择方式</p>
          <van-cell title="相机" />
          <van-cell title="相册" />
        </van-popup>
        </div>
        <van-cell title="人脸信息"   />
        <van-cell title="居住信息"  />
        <van-cell title="居住证明材料" />
      </van-cell-group>
      <van-button plain hairline type="primary"  class="wuye" color="#ff0000">提交物业审核</van-button>
    </div>
  </f7-page>
</template>

<script>
    import {applyDoorAuth} from "@/api/api_estate.js";
    export default {
        data(){
            return {
             idCardList:[]
            }
        },
        created(){

        },
        methods:{
          uploadIDCard(value){
            let that=this;
            if(value==0){
              wx.uploadIDCard({
                source:"camera",
                success:function(res){
                  that.idCardList.push(res);
                }
              })
            }else if(value==1){
              wx.uploadIDCard({
                success:function ready(value){
                  value=eval(value);
                  value.forEach((el,index)=>{
                    that.idCardList.push(el);
                  })
                }
              })
            }
          }
        }
    }
</script>
<style scoped>
.wuye{
  width: 150px;
  margin-top: 500px;
  margin-left: 110px;
}
</style>