<template>
    <f7-page>
        <div>
            <img :src="vote.banner" width="100%">
        </div>
        <div class="b-gray pt-10 pb-10 row" v-bind:style="{'color':vote.color}">
            <div class="col-60 pl-10" v-if="over == 0">
                <i class="zmdi zmdi-notifications-active" style="font-size:25px;vertical-align: middle;"></i> {{countTime}}
            </div>
            <div class="col-60 pl-10" v-if="over == 1" v-bind:style="{'color':vote.color}">
                <i class="zmdi zmdi-notifications-active" style="font-size: 25px;vertical-align: middle;"></i> 已结束
            </div>
            <div v-if="vote.daily && vote.daily > 0" class="col-40">
                <i class="zmdi zmdi-info" style="font-size: 25px;vertical-align: middle"></i> 每天可投{{vote.daily}}票
            </div>
            <div v-if="vote.totally && vote.totally > 0" class="col-40">
                <i class="zmdi zmdi-info" style="font-size: 25px;vertical-align: middle"></i> 一共可投{{vote.totally}}票
            </div>
        </div>

        <div class="background pt-10">
            <p class="count-info"> <strong v-bind:style="{'color':vote.color,'font-size': '20px' }" class="joinCount c-16">{{total}}</strong><br><span style="font-size: 12px;">参赛数</span></p>
            <p class="count-info"> <strong v-bind:style="{'color':vote.color,'font-size': '20px' }" class="viewCount c-16">{{vote.hits}}</strong><br><span style="font-size: 12px;">访问量</span></p>
            <p class="count-info1">
                <strong v-bind:style="{'color':vote.color,'font-size': '20px' }" class="participantCount c-16">
                    {{vote.participantCount}}
                </strong>
                <br><span style="font-size: 12px;">投票数</span></p>
            <div style="clear: both"></div>
        </div>
        <div v-show="showIndex == 0">
            <div style="color:#fff" class="f-14 row mt-10 mb-10">
                <div class="orange pl-10 ml-10 col-40 c-fff pt-10 pb-10" v-bind:style="{'background':vote.color}">
                    <!--<i class="zmdi zmdi-local-activity f-20"></i>-->  投票介绍
                </div>
            </div>
            <div class="pd-10" style="background-color: #fff">
                <p v-html="vote.voteRule" class="pd-10 ueditor16 rich" style="box-shadow: 2px 2px 5px 5px #f1f1e3 inset;border-radius: 5px"></p>
            </div>
            <div  v-if="over == 1 && result != ''" style="color:#fff" class="f-14 row pt-10 pb-10">
                <p class="orange pl-10 ml-10 col-40 c-fff" v-bind:style="{'background':vote.color}">
                    <!--<i class="zmdi zmdi-favorite f-20"></i>--> 投票结果公示
                </p>
            </div>
            <div  v-if="over == 0 || result ==''" style="color:#fff" class="f-14 row pt-10 pb-10">
                <p class="orange pl-10 ml-10 col-40 c-fff" v-bind:style="{'background':vote.color}">
                    <!--<i class="zmdi zmdi-favorite f-20"></i>--> 投票区
                </p>
            </div>
            <div style="height: 60px;width: 98%;padding-left: 2%;background: white;position: relative;" class="pb-10">
                <input type="text" id="search" class="input" maxlength="10" v-model="searchParam" placeholder="请输入编号或名称搜索">
                <input type="button" v-bind:style="{'background':vote.color}" class="startSearch" value="搜索" @click="search">
            </div>
            <div v-if="over == 0 || result ==''">
                <div v-for="subject in voteSubject">
                    <div class="competitor" v-for="(item,index) in subject.field_options.options">
                        <span class="user-number" v-bind:style="{'background':vote.color,'opacity':0.7}">{{item.index}}号</span>
                        <div style="overflow: hidden;height: 230px;" @click="showDetail(item)">
                            <img :src="item.picture" style="display: inline-block;" width="auto" height="230px">
                        </div>
                        <div v-bind:style="{'border': 'solid 1px '+ vote.color,'border-radius':'5px','width':'100%','margin-bottom':'0px'}">
                            <div class="fl text-c" style="width:65%;">{{forMatterLabel(item.label)}}</div>
                            <div class="fl text-c"  v-bind:style="{'width':'35%','background':vote.color}" @click="praise(item.index)">
                                <i class="f-14 c-fff" style="font-style: normal">投票</i>
                            </div>
                            <div style="clear: both"></div>
                        </div>
                    </div>
                </div>
                <div style="clear: both;"></div>
            </div>
        </div>

        <div v-show="showIndex == 1" class="mb-30">
            <div class="b-gray pt-10"></div>
            <span class="user-number" v-bind:style="{'background':vote.color,'opacity':0.7}">{{detailShow.index}}号</span>
            <div style="margin-top: 2rem" class="text-c ">
                <div class="f-16 mb-10">{{detailShow.label}}</div>
                <img :src="detailShow.picture" width="70%">
            </div>
            <div v-html="detailShow.contentShow" class="pd-10" style="background-color: #fff;"></div>
            <div class="b-gray pt-10"></div>
            <div class="row text-c pt-10">
                <div class="col-50"><input type="button" v-bind:style="{'background':vote.color}" class="bottomBtn" value="返回列表" @click="showIndex = 0"></div>
                <div class="col-50"><input type="button" v-bind:style="{'background':vote.color}" class="bottomBtn" value="投票" @click="praise(detailShow.index)"></div>
            </div>

        </div>
        <div v-if="over == 1 && result != ''">
            <div v-if="result != ''">
                <div class="row pl-10 pr-10 mt-10">
                    <span class="col-100 text-c pt-5 pb-5" v-bind:style="{'background':vote.color}" style="color:#fff;">投票结果公示榜</span>
                </div>
                <div class="row pl-10 pr-10 pb-5 pt-5" v-for="(item,index) in result" style="border-bottom: 1px solid #eee;" :id="index">
                    <div class="col-30" style="width:60px; height: 60px;overflow: hidden;position: relative; vertical-align: top;text-align: center">
                        <img class="headimage" :src="item.picture" alt="">
                    </div>
                    <div class="col-40 lineh">
                        <span :id="item.label" class="overflowY"> <b class="f-17">NO.{{index+1}}</b> &nbsp;&nbsp;&nbsp;{{item.label}}</span>
                    </div>
                    <div class="col-30 lineh">
                        <span class="f-18">{{item.count}} </span> 票
                    </div>
                </div>
            </div>
        </div>
    </f7-page>
</template>
<script>
    import {surveyDetail,voteSubmit} from "@/api/api_cms";
    export default {
        data(){
            return {
                voteId:'',
                //结果公示
                result:{},
                //明细
                vote:{},
                //答题历史
                over:0,
                //全部
                totalSubject:[],
                //题目
                voteSubject:[],
                //当前所处的题目位置
                searchParam:'',
                total:0,
                showIndex:0,
                countTime:'',
                detailShow:{},
            }
        },
        created(){
            this.$commonUtils.setTitle('投票调查');
            this.voteId = this.$commonUtils.getUrlKey("id");

            this.loadVoteDetail();
        },
        methods:{
            //获取vote详情
            loadVoteDetail(){
                var _this = this;
                surveyDetail(this.voteId).then(res => {
                    var result = res.data;
                    var vote = result.vote;

                    if(vote.color == null || vote.color == ''){
                        vote.color = '#c40a14';
                    }
                    if(vote.banners){
                        vote.banner = this.$commonUtils.formatPicture(vote.banners);
                    }
                    _this.vote = vote;

                    _this.history = result.data;
                    _this.over = result.over;
                    _this.result = result.result;
                    console.log(_this.result);

                    if(!!_this.vote.detail) {
                        var fields = JSON.parse(_this.vote.detail);
                        fields.fields.forEach(function(item,index){

                            if(item.field_type === 'checkboxes'){
                                item.value = [];
                                item.typename  = '多选';
                            }else if(item.field_type === 'radio'){
                                item.typename = '单选';
                                item.value = -1;
                            }
                            if(item.field_options.options != null && item.field_options.options.length > 0){
                                item.field_options.options.forEach(function(f,p){
                                    f.index = p+1;
                                });
                            }

                            if(_this.history.length > 0){
                                for(var i = 0;i < _this.history.length; i++){
                                    if(_this.history[i].name === item.field_name){
                                        if(item.field_type === 'checkboxes'){
                                            var code = _this.history[i].code;
                                            var codeArr = [];
                                            if(!!code){
                                                var arr = code.split(',');
                                                if(!!arr && arr.length > 0){
                                                    arr.forEach(function (code) {
                                                        codeArr.push(code);
                                                    });
                                                }
                                            }
                                            item.value = codeArr;
                                        }else if(item.field_type === 'radio'){
                                            item.value = _this.history[i].code;
                                        }else{
                                            item.value = _this.history[i].value;
                                        }
                                        break;
                                    }
                                }
                            }
                            _this.voteSubject.push(item);
                        });
                        _this.totalSubject = JSON.parse(JSON.stringify(_this.voteSubject));
                        _this.total = _this.totalSubject[0].field_options.options.length;
                    }
                    _this.countDown();
                }).catch(err => {
                    this.$commonUtils.jumpLogin(err);
                });
            },
            maodian(){
                // var inputvalue = document.getElementById('search1').value;
                // jQuery("#alink").attr("href",inputvalue);
            },
            showDetail(item){
                if(!!item.content){
                    item.contentShow = base64.decode(item.content);
                    this.detailShow = item;

                    this.showIndex = 1;
                }else{
                    if(!!item.picture){

                        var picture = item.realPicture || item.picture;

                        var showPicture = picture.replace('.png','Zoom720.png').replace('.jpeg','Zoom720.jpeg').replace('.jpg','Zoom720.jpg');
                        var myPhotoBrowserPopup = app.photoBrowser.create({
                            photos: [showPicture],
                            type: 'popup',
                            theme: 'dark',
                            navbarOfText: '-',
                            backLinkText: '关闭',
                            routableModals: false,
                            toolbar: false,
                            swiper: {
                                lazy: {
                                    enabled: true,
                                },
                            },
                        });
                        myPhotoBrowserPopup.open();
                    }else {
                        this.showToast('没有详情');
                    }
                }
            },
            countDown(){
                var _this = this;
                var time = this.vote.endTime;
                var times = (new Date(time.replace(/-/g, "/")).getTime() - new Date().getTime()) / 1000;
                var day=0,
                    hour=0,
                    minute=0,
                    second=0;//时间默认值
                if(times > 0){
                    day = Math.floor(times / (60 * 60 * 24));
                    hour = Math.floor(times / (60 * 60)) - (day * 24);
                    minute = Math.floor(times / 60) - (day * 24 * 60) - (hour * 60);
                    second = Math.floor(times) - (day * 24 * 60 * 60) - (hour * 60 * 60) - (minute * 60);
                }
                if (day <= 9) day = '0' + day;
                if (hour <= 9) hour = '0' + hour;
                if (minute <= 9) minute = '0' + minute;
                if (second <= 9) second = '0' + second;
                this.countTime = day+"天"+hour+"小时"+minute+"分钟"+second+"秒";
                times--;
                if(times<=0){

                }else{
                    setTimeout(function(){
                        _this.countDown();
                    },1000);
                }
            },
            search(){
                var _this = this;
                var n = Number(this.searchParam);
                var index = -1;
                if (!isNaN(n)){
                    index = n-1;
                }

                if(_this.over == 1 && _this.result != ''){
                    //找到index
                    var ppp =-1;
                    _this.result.forEach(function(item,pos) {
                        if(item.label.indexOf(_this.searchParam) != -1){
                            ppp = pos;
                        }
                    })
                    if(ppp == -1)
                        _this.showToast('未搜索到结果');
                    else
                        document.getElementById(ppp).scrollIntoView();

                }else{
                    if(this.totalSubject.length > 0){
                        _this.voteSubject[0].field_options.options = [];
                        this.totalSubject[0].field_options.options.forEach(function(item,pos){
                            if(pos == index){
                                _this.voteSubject[0].field_options.options.push(item);
                            }else{
                                if(item.label.indexOf(_this.searchParam) != -1){
                                    _this.voteSubject[0].field_options.options.push(item);
                                }
                            }
                        });
                    }
                }
            },
            praise(pos){
                var _this = this;
                pos = pos -1;
                voteSubmit(this.voteId,pos).then(res => {
                    wx.toast('投票成功');
                    _this.vote.participantCount ++;
                }).catch(err => {
                    wx.toast(err.data);
                });
                // httpData(this.url.praise+id+'/'+pos,function s(result){
                //     _this.showToast('投票成功');
                //     _this.vote.participantCount = result;
                // },function e(e){
                //     alert(e);
                // },'POST');
            },
            forMatterLabel(label){
                if(label.length > 5)
                    return label.substring(0,5)+'...';
                return label;
            }
        }
    }
</script>

<style scoped>
    p img{
        display:block;
        /*width:100%;*/
        max-width: 100%;
        height:auto !important;
    }
    .competitor {
        width: 45.5%;
        padding: 5px;
        margin-bottom: .5rem;
        border-radius: 2px;
        overflow: hidden;
        box-shadow: 0 0.2rem 0.2rem rgba(0,0,0,.2);
        float: left;
        margin-left: 1.333%;
        background: white;
    }
    .user-number {
        font-size: 1.3rem;
        background: rgba(157,51,57,.6);
        border-bottom-right-radius: 2px;
        min-width: 4rem;
        height: 2.5rem;
        line-height: 2.5rem;
        position: absolute;
        /*top: 0;*/
        /*left: 0;*/
        color: #fff;
        display: block;
        text-align: center;
        float: left;
    }

    .competitor .info {
        width: 100%;
        z-index: 1;
        text-align: center;
        color: #fff;
    }
    .background {
        background: #fff;
        border: none;
    }
    .competitor .info p {
        padding: .1rem;
    }
    .competitor .info button {
        width: 80%;
        border: 0;
        background: #fff;
    }
    .input{
        border: solid 1px #7d7d7d !important;
        border-bottom-left-radius: 4px !important;
        border-top-left-radius: 4px !important;
        background:white !important;
        width:60% !important;
        height:60% !important;
        font-size: 14px !important;
        margin-top: 15px !important;
        padding-left: 10px !important;
        padding: 5px !important;
        display: inline !important;
        margin-right: 0 !important;
        margin-left: 1%;
    }
    .startSearch{
        height: 60% !important;
        margin-top: 15px !important;
        padding: 5px !important;
        border:0px !important;
        border-bottom-right-radius: 4px !important;
        border-top-right-radius: 4px !important;
        /*background:#c40a14;*/
        width:38% !important;
        font-size: 16px !important;
        color: white !important;
        display: inline !important;
        margin-left: 0px !important;
    }

    .bottomBtn{
        height: 40px !important;
        padding: 5px !important;
        border:0px !important;
        /*background:#c40a14;*/
        width:50% !important;
        font-size: 16px !important;
        color: white !important;
        display: inline !important;
        margin-left: 0px !important;
        border-radius: 5px;
    }

    .count-info{
        width: 32%;
        float: left;
        text-align: center;
        flex: 1;
        font-size: 16px;
        border-right: solid 1px #F0F0EE;
    }
    .count-info1{
        width: 32%;
        float: left;
        text-align: center;
        flex: 1;
        font-size: 16px;
    }
    .detail{
        background: white;
    }
    .centerText{
        font-family: 'STXingkai';
        color: red;
        text-align: center;
        padding-left: 10%;
        padding-right: 10%;
        font-weight: bold;
        text-shadow: 0 0 5px #fff, 0 0 10px #fff, 0 0 15px #fff, 0 0 40px #fff, 0 0 70px #fff;
        left: 0px;
        right: 0px;
        width: 80%;
    }
    .orange{
        /*background-color: orange;*/
        border-radius: 30px;
        padding-bottom: 2px;
        padding-top: 2px;
        margin-bottom: 0px;
    }
    .headimage{
        position: absolute;
        margin: auto;
        top: 0px;
        right: 0px;
        bottom: 0px;
        left: 0px;
        max-width:100%;
        max-height:100%;
        border-radius: 8px;
    }
    .lineh{
        height: 50px;
        /*overflow-y: hidden;*/
        padding-top: 10px;
    }
    .overflowY{
        width:100%;
        height: 100%;
        text-overflow: -o-ellipsis-lastline;
        overflow: hidden;
        text-overflow: ellipsis;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        line-clamp: 2;
        -webkit-box-orient: vertical;
    }

    .rich>>> p{
        font-size: 17px !important;
        line-height: 32px !important;
        text-indent: 0px !important;
        letter-spacing: 2px !important;
        overflow-y: hidden;
    }

    .rich>>> img{
        max-width: 100%;
        display: block;
    }
    .rich>>> section,p{
        max-width: 100% !important;
        text-indent: 0px !important;
    }
    .rich>>> p img{
        /*display:block;*/
        /*width:100%;*/
        max-width: 100% !important;
        height:auto !important;
        margin-left: 0px !important;
        margin-right: 0px !important;
        padding-left: 0px !important;
        padding-right: 0px !important;
    }
    .rich>>> .rich_media_title {
        margin-bottom: 10px;
        line-height: 1.4;
        font-weight: 400;
        font-size: 24px;
    }
    .rich>>> .judgeFix{
        position: fixed !important; bottom: 0px;width: 100%;height: 45px;z-index: 10;background: #fff;border-top: solid 1px #eee;
    }
    .rich>>> .judge{
        border-top: solid 1px #eee;
        position: fixed;bottom: 45px;width: 100%;height: 120px;z-index: 10;background: #fff;padding-top: 10px;
    }
    .rich>>> .col-33{
        height: 45px;
        padding-top: 10px;
    }
    .rich>>> textarea{
        border: solid 1px #eee !important;
        border-radius: 5px;
        width: 94% !important;
        margin-left: 3%;
        height: 70px;
        background: rgba(221, 221, 221, 0.2);
        padding: 2px;
    }
    .rich>>> .self{
        color: #007aff;
        font-size:9px;
        margin-right: 5px;
        padding-left: 5px;
        padding-right: 5px;
        border-radius: 3px;
        border:solid 1px #007aff;
    }
    .rich>>> .flex-box-img{flex: 0 0 100px;width:100px;height:100px;overflow: hidden;}
    .rich>>> .flex-box-content {flex: 1;overflow: hidden;padding-bottom:5px;display: flex;flex-direction: column;justify-content: space-between;min-width: 0;margin-right: 3px;}
    .rich>>> .dotdot {
        overflow: hidden;
        text-overflow: ellipsis;
        display: -webkit-box;
        display: box;
        -webkit-box-orient: vertical;
        font-size: 16px;
    }
    .rich>>> .hot{
        color: #ff3b30;
        font-size:9px;
        margin-right: 5px;
        padding-left: 5px;
        padding-right: 5px;
        border-radius: 3px;
        border:solid 1px #ff3b30;
    }
    .rich>>> .single{background: #fff;border-bottom: 1px solid rgba(221, 221, 221, 0.6);display: flex;margin-left:10px;margin-right: 10px;padding-bottom: 10px;padding-top:10px}
    .rich>>> .single span{font-size: 12px;color: #666;}
    .rich>>> ul{
        margin: 10px;
        padding-left: 10px !important;
    }

</style>