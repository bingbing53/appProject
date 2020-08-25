<template>
  <f7-page>
    <div>
      <van-cell-group>
        <van-cell title="单元格" value="内容" />
        <van-cell title="单元格" value="内容"  border="{{ false }}" />
      </van-cell-group>
    </div>
  </f7-page>
</template>

<script>
    import https from "@/api/api_estate.js";
    export default {
        data(){
            return {
              uploadVerifyInfo:{
                
              }
            }
        },
        created(){

        },
        methods:{

        }
    }
</script>
<style scoped>

</style>