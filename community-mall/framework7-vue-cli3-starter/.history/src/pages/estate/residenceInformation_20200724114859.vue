<template>
  <f7-page>
    <div>
      <div class="tit">请将准确填写以下居住信息</div>
    </div>
     <van-cell-group class="myGroup">
            <van-field
                    required
                    clearable
                    label="居住户型"
                    placeholder="请输入居住户型"
            />

            <van-field  required label="住房面积" clearable placeholder="请输入住房面积（平方米）" />
        </van-cell-group>
  </f7-page>
</template>

<script>
import {residenceInformation} from "@/api/api_estate.js";
    export default {
        name:"residenceInformation",
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


</style>


