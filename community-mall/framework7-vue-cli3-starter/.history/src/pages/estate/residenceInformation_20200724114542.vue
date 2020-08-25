<template>
  <f7-page>
    <div>
      <div class="tit">请将准确填写以下居住信息</div>
    </div>
     <van-cell-group class="myGroup">
            <van-field
                    required
                    clearable
                    label="真实姓名"
                    placeholder="请输入真实姓名"
            />

            <van-field label="身份证号" clearable placeholder="请输入身份证号" />
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


