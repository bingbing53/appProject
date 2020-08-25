<template>
  <f7-page>
    <div>
      <div class="tit">请将面部置于方框内拍摄</div>
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


