<template>
  <f7-page>
    <div>
    居住信息  
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


</style>


