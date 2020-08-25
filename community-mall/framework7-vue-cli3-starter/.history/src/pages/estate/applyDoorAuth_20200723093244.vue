<template>
  <f7-page>
    <div>
      <van-cell-group>
        <van-cell title="上传身份证" />
        <van-cell title="人脸信息"   />
        <van-cell title="居住信息"  />
        <van-cell title="居住证明材料" />
      </van-cell-group>
      <van-button plain hairline type="primary"  class="wuye" color="#ccc">提交物业审核</van-button>
    </div>
  </f7-page>
</template>

<script>
    import {applyDoorAuth} from "@/api/api_estate.js";
    export default {
        data(){
            return {
              uploadVerifyInfo:{
                
              }
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
  width: 120px;
  margin-top: 500px;
  margin-left: 120px;
  color: red
  
}
</style>