<template>
  <div>
    1111
    <!--<div class="fl">
      <img :src="depart.logo" class="logo"/>
    </div>
    <div class="fl">
      <p class="departName f-14">{{depart.departName}}</p>
      <p class="c-999 f-12">{{article.createDate}}</p>
    </div>
    <div class="fr mr-10">
      <van-button type="primary" size="small" v-if="collect == 0" @click="focused(1)">关注</van-button>
      <van-button type="info" size="small" v-if="collect == 1" @click="focused(0)">已关注</van-button>
    </div>
    <div class="clear"></div>-->
  </div>
</template>

<script>
    import {articleCreater} from "@/api/api_cms";
    import {isFocused,addFocus,delFocus} from "@/api/api_common";
    export default {
        data(){
          return {
            depart:{},
            collect:0,
            sysOrgCode:''
          }
        },
        created(){
            this.sysOrgCode = this.$commonUtils.getUrlKey('code');
        },
        methods:{
            //关注或取消关注
            focused(type){
                if(type == 1){
                    //关注
                    addFocus('3',this.sysOrgCode).then(res => {
                        this.collect = 1;
                        wx.toast('关注成功');
                    });
                }else{
                    //取消关注
                    delFocus('3',this.sysOrgCode).then(res => {
                        this.collect = 0;
                        wx.toast('取消关注成功');
                    });
                }
            },
            //是否关注
            getFocused(){
                isFocused('3',this.article.sysOrgCode).then(res => {
                    this.collect = res.data.collect;
                });
            },
            //获取发布者信息
            getUserDetail(){
                articleCreater(this.article.id).then(res => {
                    this.depart = res.data;
                    this.depart.logo = this.$commonUtils.formatPicture(this.depart.logo);
                    this.getFocused();
                }).catch(err => {
                })
            }
        }
    }
</script>
<style scoped>
  .createUser{
    margin-top: 10px;
    margin-bottom: 10px;
  }
  .logo{
    margin-right: 10px;
    width: 30px;
    height: 30px;
    vertical-align:top;
    /*display: flex;*/
    border-radius: 50%;
    /*align-items: center;*/
    /*justify-content: center;*/
    /*overflow: hidden;*/
  }
  
</style>