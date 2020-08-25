<template>
  <f7-page>
    <div>
       <van-button  type="info"   class="tit2">保存</van-button>
  </f7-page>
</template>

<script>
import {faceInformation} from "@/api/api_estate.js";
    export default {
        name:"faceInformation",
        data(){
            return {

            }
        },
        created(){

        },
        methods:{
          uploadIDCard(){     
              this.$f7router.navigate(`/estate/applyDoorAuth`);               
          }
        }
    }
</script>
<style scoped>


</style>


