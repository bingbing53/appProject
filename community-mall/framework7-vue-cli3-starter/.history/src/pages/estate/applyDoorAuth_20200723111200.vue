<template>
  <f7-page>
    <div>
      <van-cell-group>
        <van-cell title="上传身份证"   @click="uploadIDCard"  />
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
      <van-button plain hairline type="primary"  class="wuye" color="#ff0000">提交物业审核</van-button>
    </div>
  </f7-page>
</template>

<script>
    import {applyDoorAuth} from "@/api/api_estate.js";
    export default {
        data(){
            return {
           
            }
        },
        created(){

        },
        methods:{
         
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