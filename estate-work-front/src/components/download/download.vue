<template>
    <div>
        <section class="download_c">
                <img :src=background alt="">
                <!-- 安卓 -->
                <div class="tk" v-show="device == 1">
                    <!-- 不是微信浏览器 -->
                    <div v-show="weixin == 2">
                        <a href="https://image.shequyijia.cn/pic/estate.apk"  style="display:inline-block">
                            <img :src=Android alt=""  >
                        </a>
                    </div>
                    <!-- 微信浏览器 -->
                    <div  @click="showpop" v-show="weixin == 1">
                        <img :src=Android alt="">
                    </div>
                </div>
                <!-- 苹果 -->
                <div class="tk" v-show="device == 2">
                    <div v-show="weixin == 2">
                        <a href="https://apps.apple.com/cn/app/%E6%8E%8C%E4%B8%8A%E7%A4%BE%E5%8C%BA-%E5%8A%9E%E5%85%AC/id1478238125" style="display:inline-block">
                            <img :src=ipnone alt=""  v-show="weixin == 2">
                        </a>
                    </div>
                    <div @click="showpop"  v-show="weixin == 1">
                        <img :src=ipnone alt="">
                    </div>
                </div>
        </section>
        <van-popup v-model="pop" overlay-class="mypop" position="top">
            <div class="pd-10 pt-30">
                <div class="right pr-20"> 
                    <img :src=toload alt="" width="42.56vw" height="42.56vw">
                </div>
                <div class="clear"></div>
                <div class="mt-10 pt-10">
                    <p class="c-fff text-c">请点击右上角按钮，使用浏览器打开</p>
                </div>
            </div>
        </van-popup>
    </div>
</template>
<script>
export default {
    data(){
        return{
            background:require("@/assets/img/tpage.jpg"),
            Android:require("@/assets/img/tandroid.png"),
            ipnone:require("@/assets/img/tiphone.png"),
            toload:require("@/assets/img/toload.png"),
            device:0,
            weixin:0,
            pop:false,

        }
    },
    methods:{
        showpop(){
            this.pop = true;
        },
        getdeviceInfo(){
            let u = navigator.userAgent;
            let isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1; //android终端
            let isiOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/); //ios终端
            if(isAndroid){
               this.device = 1
            }
            if(isiOS){
               this.device = 2
            }
        },
        getWeixin(){
            let ua = navigator.userAgent.toLowerCase();
            let isWeixin = ua.indexOf('micromessenger') != -1;//是否是微信浏览器打开
        　　if (isWeixin) {
        　　this.weixin = 1;//微信
        　　}else{
            this.weixin = 2;
        　　}
        }

    },
    mounted(){
        this.getdeviceInfo();
        this.getWeixin();

    }
}
</script>
<style scoped>
.download_c{
    position: relative;
}
.tk{
    position: absolute;
    top: 74%;
    left: 26%;
    width: 46%;
}
.van-popup{
    background: transparent;
}

</style>


