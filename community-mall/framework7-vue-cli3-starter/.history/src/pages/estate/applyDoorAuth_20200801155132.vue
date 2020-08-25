<template>
  <f7-page>
    <div>
       <van-cell-group >
        <van-cell title="上传身份证"  @click="go" />
     </van-cell-group>
       <van-cell-group>
        <van-cell title="人脸信息"   @click="face"/>
      </van-cell-group>
       <van-cell-group>
        <van-cell title="居住信息"   @click="residence"/>
      </van-cell-group>
       <van-cell-group>
        <van-cell title="居住证明材料"  @click="certificate"/>
      </van-cell-group>
      <van-button plain hairline type="primary"  class="propertyAudit" color="#ff0000">提交物业审核</van-button>
    </div>
  </f7-page>
</template>

<script>
    import {applyDoorAuth} from "@/api/api_estate.js";
    import{photoIDCard} from "@/api/api_estate.js";
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
           go() {
            this.$f7router.navigate(`/estate/photoIDCard`);
          },
          face(){
            this.$f7router.navigate(`/estate/faceInformation`);
          },
          residence(){
             this.$f7router.navigate(`/estate/residenceInformation`);
          },
          certificate(){
            this.$f7router.navigate(`/estate/proofOfResidence`);
          },
        //  childByValue: function (childValue) {
        //   // childValue就是子组件传过来的值
        //   this.name = imgList
        //   }
          addAddress () {  
            alert("067")
            this.$emit('imgList', this.imgList)
            // this.$f7router.navigate(`/estate/applyDoorAuth`);  
          },
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