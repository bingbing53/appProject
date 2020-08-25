<template>
  <f7-page >
      <van-button  @click="uploadIDCard">11111111111</van-button>
  </f7-page>
</template>

<script>

export default {
  data() {
    return {
      idCardList:[]
    }
  },
  created(){
    wx.init(function(){
        that.uploadIDCard();
    })
  },
  methods: {
    uploadIDCard(value){
            let that=this;
            if(value==0){
              wx.uploadIDCard({
                source:"camera",
                success:function(res){
                  that.idCardList.push(res);
                }
              })
            }else if(value==1){
              wx.uploadIDCard({
                success:function ready(value){
                  value=eval(value);
                  value.forEach((el)=>{
                    that.idCardList.push(el);
                  })
                }
              })
            }
    }
  }
};
</script>
<style scoped>

</style>