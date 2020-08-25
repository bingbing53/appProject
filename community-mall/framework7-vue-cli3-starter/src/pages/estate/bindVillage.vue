<template>
  <f7-page>

    <van-search
            v-model="search"
            placeholder="请输入小区名称搜索"
            show-action
            shape="round"
            @search="onSearch"
    >
      <div slot="action" @click="onSearch">搜索</div>
    </van-search>

    <f7-block>
        <van-cell :title="item.villageName" is-link v-for="item in villageList" @click="submitBind(item)"/>
        <van-cell :title="item.villageName" is-link v-for="item in nearVillageList" @click="submitBind(item)"/>
    </f7-block>

  </f7-page>
</template>

<script>
    import {bindVillage,getVillage} from "@/api/api_estate.js";
    import Vue from 'vue';
    import { Search,Button,Cell, CellGroup,Row, Col} from 'vant'
    Vue.use(Search).use(Button).use(Cell).use(CellGroup).use(Row).use(Col);
    export default {
        data(){
            return {
                search:'',
                villageList:[],
                nearVillageList:[],
            }
        },
        created(){
          this.$commonUtils.setTitle('绑定小区');
        },
        mounted(){
            let that = this;
            wx.geoLocation({
                success:function(location){
                    var json = JSON.parse(location);
                    getVillage({'longitude':json['longitude'],'latitude':json['latitude']}).then(res => {
                        var result = res.data;
                        that.nearVillageList = result;
                    }).catch(err => {
                        that.$commonUtils.jumpLogin(err);
                    });
                },error:function(err){
                    wx.toast(err);
                }
            });
        },
        methods:{
            //提交绑定信息
            submitBind(item){
                wx.loading('提交中');
                let that = this;
                var param = {
                    villageId:item.id,
                };

                bindVillage(param).then(res => {
                    wx.closeLoading();
                    wx.toast('绑定成功');
                    setTimeout(function(){
                        console.log('关闭页面');
                        wx.popPage();
                    },1500);
                }).catch(err => {
                    wx.closeLoading();
                    wx.toast('提交失败，请稍后重试');
                });
            },
            //搜索
            onSearch(){
                getVillage({'villageName':this.search}).then(res => {
                    var result = res.data;
                    this.villageList = result;
                    this.nearVillageList = [];
                }).catch(err => {
                    this.$commonUtils.jumpLogin(err);
                });
            }
        }
    }
</script>
<style scoped>

</style>