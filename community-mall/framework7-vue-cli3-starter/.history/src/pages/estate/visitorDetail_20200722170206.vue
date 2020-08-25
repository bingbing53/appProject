<template>
  <f7-page>
    <f7-block>
      <div v-for="item in detail">
        <van-row>
          <van-col span="16">
            <div>{{item.devName}}</div>
            <div class="f-14 c-999 mt-20">开门时间：{{item.createTime}}</div>
          </van-col>
          <van-col span="8"><img :src="item.imagePath" width="100%"></van-col>
        </van-row>

        <div class="line mt-10 mb-10"></div>
      </div>
    </f7-block>
  </f7-page>
</template>

<script>
    import {visitorDetail} from "@/api/api_estate.js";
    export default {
        data(){
            return {
                detail:[]
            }
        },
        created(){
          this.$commonUtils.setTitle('开门记录');
        },
        mounted(){
            var params = this.$f7route.params;
            if(params.visitorId != null && params.visitorId.length > 0){
                this.getVisitorDetail(params.visitorId);
            }
        },
        methods:{
            //获取访客密码使用详情
            getVisitorDetail(id){
                visitorDetail(id).then(res => {
                    this.detail = res.data;
                    if(this.detail.length <= 0){
                        wx.toast('暂无数据');
                    }else{
                        for(var i = 0;i<this.detail.length;i++){
                            this.detail[i].imagePath = this.$commonUtils.formatPicture(this.detail[i].imagePath);
                        }
                    }
                }).catch(err => {

                });
            }
        }
    }
</script>
<style scoped>

</style>