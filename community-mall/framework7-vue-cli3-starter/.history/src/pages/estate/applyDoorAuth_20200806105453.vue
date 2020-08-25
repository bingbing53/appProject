<template>
  <f7-page>
    <div>
       <van-cell-group v-model="num" >
         <img :src="item"  @addimg1="imgList"/>
        <van-cell title="上传身份证" @click="go" />
        <p>{{info}}</p>
        <p>{{num}}</p>
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
              msg:"111",
             info:''
            }
        },
        created(){
          
        },
        components:{
           photoIDCard
        },
        methods:{        
           go(data) {
            this.$f7router.navigate(`/estate/photoIDCard`);
            this.info=data
          },
          imgList(data){
            this.imgList=data;
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