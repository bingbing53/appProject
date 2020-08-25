<template>
  <f7-page>
    <div>
       <van-cell-group >
        <van-cell title="上传身份证"  @click="go" />
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
      name:"applyDoorAuth",
        data(){
            return {
              msg:"111"
            }
        },
        created(){

        },
        methods:{
          go(){
            alert("111")
            this.$router.push({name:'/photoIDCard',params:{id:'1'}});
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
</style>