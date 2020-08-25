<template>
  <f7-page>
    <div>
       <van-cell-group >
        <van-cell title="上传身份证" @click="uploadIDCard(0)"  />
     </van-cell-group>
       
    </div>
  </f7-page>
</template>

<script>
import {photoIDCard} from "@/api/api_estate.js";
    export default {
        name:"photoIDCard",
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