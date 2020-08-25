<template>
    <div class="login">
        <di class="loginForm">
            <a-spin :spinning="spinning">
                <div class="spin-content">
                    <iframe id="cas_serverFrame" class="iframe" :src="ssoUrl"
                            frameborder="no" border="0" marginwidth="0"
                            marginheight="0" scrolling="no" allowtransparency="yes">
                    </iframe>
                    <div v-if="!!registerUrl" style="text-align: center;color: grey;cursor: pointer" @click="register">
                        还没有帐号？点我注册
                    </div>
                </div>
            </a-spin>
        </di>
        <community-login v-if="service == 'community'" :isdownload="1">
        </community-login>
    </div>
</template>
<script>
import communityLogin from './communityLogin'
import SSOCLIENT from '../../components/cas/client'
export default {
    name: "login",
    components: {
        communityLogin
    },
    data() {
        return {
            spinning:true,
            service:"loading",
            registerUrl:"",
            ssoUrl:this.GLOBAL.casPrefixUrl+'/cas/login',
            services:[
                {
                    "name":"community",
                    "pattern":"^(https|http)(://||%3A%2F%2F).*(qicaidonghu||shequyijia||wjjdzhsq).cn/server.*",
                    "description":"社区系统",
                    "register":"https://portal.dev.shequyijia.cn/#/register"
                },
                {
                    "name":"community",
                    "pattern":"^(https|http)(://||%3A%2F%2F)estate.*shequyijia.cn.*",
                    "description":"物业系统",
                    "register":"https://portal.dev.shequyijia.cn/#/registerEstates"
                },
                {
                    "name":"community",
                    "pattern":"^(https|http)(://||%3A%2F%2F)mall.*shequyijia.cn.*",
                    "description":"商家系统",
                    "register":"https://portal.dev.shequyijia.cn/#/registerBusiness"
                },
                {
                    "name":"community",
                    "pattern":"^(https|http)(://||%3A%2F%2F)cms.*shequyijia.cn.*",
                    "description":"社会组织",
                    "register":"https://portal.dev.shequyijia.cn/#/RegisterSociety"
                }
            ]
        };
    },
    mounted() {
        let that = this;
        var iframe = document.getElementById("cas_serverFrame");
        iframe.onload = function(){
            that.spinning = false;
            that.loadLoginService();
        };

        const h = this.$createElement;
        window.showMessage = function (msg) {
            that.$info({
                title: '提示信息',
                okText:'确定',
                content: h('div', {}, [
                    h('p', msg),
                ]),
                onOk() {},
            });
        }
    },
    methods:{
        register(){
            window.location.href = this.registerUrl;
        },
        loadLoginService(){
            let service = this.$route.query.service;
            let that = this;
            this.services.forEach(function(item){
                var pattern = new RegExp(item.pattern,"gim");
                if(pattern.test(service)){
                    that.service = item.name;
                    that.registerUrl = item.register;
                }
            });
            if(this.service == 'loading')
                this.service = 'community';
        }
    }
}
</script>
<style scoped>
    .iframe{
        height: 240px;
        width:300px;
    }
    .loginForm{
        width: 300px;
        height: 350px;
        background: #fff;
        -webkit-box-shadow: #666 0 0 0.2rem;
        -moz-box-shadow: #666 0 0 0.2rem;
        box-shadow: #666 0 0.1rem 0.2rem;
        float: right;
        margin-right: 15%;
        margin-top: 8%;
    }
</style>