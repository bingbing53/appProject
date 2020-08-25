<template>
  <f7-page>
    <div>
      <div class="tit">请将准确填写以下居住信息</div>
    </div>
   
  </f7-page>
</template>

<script>
import {proofOfResidence} from "@/api/api_estate.js";
    export default {
        name:"proofOfResidence",
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


