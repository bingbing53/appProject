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

    export default {
        data(){
            return {
            }
        },
        created(){

        },
        methods:{
          uploadIDCard(value){
            // alert(123)  
            let that=this; 
            if(value==0){
              wx.uploadIDCard({
            
              })
            }else if(value==1){
              wx.uploadIDCard({
               
              })
            }
    }
        }
    }
</script>
<style scoped>

</style>