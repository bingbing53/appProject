<template>
  <f7-page>
    <div>
      <div class="tit">请将准确填写以下居住信息</div>
       <div class="mb-20 pd-10">
            <span class="c-waring"><van-icon name="warning-o" color="#ff976a" class="v_middle mr-5" />请填写个人真实信息</span>
        </div>
        <van-cell-group class="myGroup">
            <van-field
                    v-model="info.realnameHidden"
                    required
                    clearable
                    label="真实姓名"
                    placeholder="请输入真实姓名"
            />

            <van-field v-model="info.idcardHidden" label="身份证号" clearable placeholder="请输入身份证号" />
        </van-cell-group>

        <div class="mt-50 pd-30">
            <van-button type="danger" round @click="postMineInfo">保存信息</van-button>
        </div>
    </div>
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


