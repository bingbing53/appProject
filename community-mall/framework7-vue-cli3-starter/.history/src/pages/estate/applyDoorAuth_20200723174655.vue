<template>
  <f7-page>
    <div>
      <van-cell-group>
        <van-cell title="上传身份证" @click="uploadIDCard" />
      </van-cell-group>
       <van-cell-group>
        <van-cell title="人脸信息"   />
      </van-cell-group>
       <van-cell-group>
        <van-cell title="居住信息"  />
      </van-cell-group>
       <van-cell-group>
        <van-cell title="居住证明材料" />
      </van-cell-group>
      <van-button plain hairline type="primary"  class="propertyAudit" color="#ff0000">提交物业审核</van-button>
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
                  value.forEach((el)=>{
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
.propertyAudit{
  width: 150px;
  margin-top: 150px;
  margin-left: 110px;
}
.f7-page{
  font-size: 20px;
}
</style>