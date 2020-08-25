<template>
  <f7-page>
    <div @click="uploadIDCard(0)">
       请将身份证至于框内拍摄
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