<template>
  <f7-page>
    <div>
      <div class="tit">上传居住材料</div>
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


