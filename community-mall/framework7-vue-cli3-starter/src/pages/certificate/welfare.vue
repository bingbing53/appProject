<template>
    <f7-page>

        <f7-block>
            <span class="c-666">您是否加入本街道成为志愿者</span>
        </f7-block>

        <f7-block class="mt-20">
            <van-button type="info" @click="joinWelfare">确认加入</van-button>
        </f7-block>
    </f7-page>
</template>

<script>
    import {certificate1,getMineInfo,welfareUser} from "@/api/api_community.js";
    export default {
        data(){
            return {
                sysOrgCode:''
            };
        },
        created(){
            this.$commonUtils.setTitle('成为志愿者');
            this.sysOrgCode = this.$commonUtils.getUrlKey("code");
        },
        methods: {
            joinWelfare(){
                this.$dialog.confirm({message:'是否确认加入志愿者'}).then(() =>{
                    wx.loading('提交中...');
                    welfareUser({sysOrgCode:this.sysOrgCode}).then(res => {
                        wx.closeLoading();
                        wx.toast('加入成功');
                        setTimeout(function(){
                            wx.popPage(1);
                        },1500);
                    }).catch(err => {
                        wx.closeLoading();
                    });
                })
            }
        }
    }
</script>

<style scoped>

</style>