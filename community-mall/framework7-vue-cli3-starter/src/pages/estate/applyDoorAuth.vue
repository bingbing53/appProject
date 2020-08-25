<template>
  <f7-page>
    <div v-if="modules.main">
       <van-cell-group>
         <div>
             <van-cell title="上传身份证" @click="takeIdcard" v-if="idCardImages.back != '' && idCardImages.front != ''" value="已完成"></van-cell>
             <van-cell title="上传身份证" @click="takeIdcard" v-else value="未完成"></van-cell>
         </div>
      </van-cell-group>
       <van-cell-group>
        <van-cell title="人脸信息" @click="face" v-if="faceImage != ''" value="已完成"/>
        <van-cell title="人脸信息" @click="face" v-else value="未完成"/>
      </van-cell-group>
       <van-cell-group>
        <van-cell title="居住信息" @click="residence" v-if="submitForm.houseType != '' && submitForm.space != 0" value="已完成"/>
        <van-cell title="居住信息" @click="residence" v-else value="未完成"/>
      </van-cell-group>
       <van-cell-group>
        <van-cell title="居住证明材料"  @click="certificate" v-if="(submitForm.liveType == '0' && houseRentImage[5] != '' && houseRentImage[6] != '') || (submitForm.liveType == '1' && houseRentImage[0] != '' && houseRentImage[1] != '' && houseRentImage[2] != '')" value="已完成"/>
        <van-cell title="居住证明材料"  @click="certificate" v-else value="未完成"/>
      </van-cell-group>
      <van-button plain hairline type="primary"  class="propertyAudit" color="#ff0000" @click="submitAll">提交物业审核</van-button>
    </div>

    <div v-if="modules.idcardShow">
        <div>
            <div class="tit">请点击对应按钮拍摄身份证照片</div>
            <div>
                <div class="photo" @click="chioseIdCard(0)">
                    <img v-if="idCardImages.back != ''" :src="idCardImages.back" width="210" height="145"  class="images1"/>
                    <div >
                        <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                        <div class="tip">点击拍照/上传人像面</div>
                    </div>
                </div>
            </div>
            <div>
                <div class="photo"  @click="chioseIdCard(1)" >
                    <img v-if="idCardImages.front != ''" :src="idCardImages.front"   width="210" height="145" class="images2"/>
                    <div>
                        <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                        <div class="tip">点击拍照/上传国徽面</div>
                    </div>
                </div>
            </div>
        </div>
        <f7-block>
            <van-button type="danger" round @click="toMain">确定</van-button>
        </f7-block>
    </div>
    <div v-if="modules.liveShow">
        <div>
            <div class="tit">请将准确填写以下居住信息</div>
        </div>
        <van-cell-group class="myGroup">
            <van-cell-group title="请选择户型">
                <van-radio-group v-model="submitForm.houseType" style="margin-left: 10px;">
                    <van-radio  v-for="item in dictionary" :name="item.value" style="margin-top:8px;">{{item.title}}</van-radio>
                </van-radio-group>
            </van-cell-group>
            <van-field  required label="住房面积" v-model="submitForm.space" clearable placeholder="请输入住房面积（平方米）" type="number"/>
        </van-cell-group>
        <div>
            <van-button  type="info" class="tit2" @click="toMain">保存</van-button>
        </div>
    </div>
    <div v-if="modules.certShow">
        <div>
            <van-tabs v-model="submitForm.liveType">
                <van-tab title="自住" name="0">
                    <span class="house5">房产证照片(原件或扫描件照片)</span>
                    <div class="photo house5" @click="choiseCertificateImage(5)">
                        <img v-if="houseRentImage[5] != ''" :src="houseRentImage[5]" width="210" height="145" class="images6">
                        <div v-if="houseRentImage[5] == ''">
                            <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                        </div>
                    </div>
                    <span class="house5">房屋登记主要内容页</span>
                    <div class="Examples">
                        <div class="photo floatright" @click="choiseCertificateImage(6)">
                            <img v-if="houseRentImage[6] != ''" :src="houseRentImage[6]" width="210" height="145" class="images7">
                            <div v-if="houseRentImage[6] == ''">
                                <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                            </div>
                        </div>
                        <span class="house6">房屋登记表页</span>
                    </div>
                    <div>
                        <van-divider  dashed hairline :style="{ color: '#1989fa', borderColor: '#1989fa', padding: '0 16px' }"/>
                        <van-button class="left" color="#03a9f4" plain >点击查看内容页示例</van-button>
                        <van-button class="right" color="#03a9f4" plain>点击查看登记表页示例</van-button>
                    </div>
                </van-tab>
                <van-tab title="租房" name="1">
                    <div class="Rentings">
                        <div class="left1">
                            租房合同信息
                            <div class="photo" @click="choiseCertificateImage(0)" >
                                <img v-if="houseRentImage[0] != ''" :src="houseRentImage[0]" width="210" height="145" class="images1">
                                <div v-if="houseRentImage[0] == ''">
                                    <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                                </div>
                            </div>
                            <span>合同首页</span>
                        </div>
                        <div class="right1">
                            <div class="photo" @click="choiseCertificateImage(1)">
                                <img v-if="houseRentImage[1] != ''" :src="houseRentImage[1]" width="210" height="145" class="images2">
                                <div v-if="houseRentImage[1] == ''">
                                    <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                                </div>
                            </div>
                            <span>信息页(包含租赁<br>房屋的地址及期限)</span>
                        </div>
                        <div class="right1">
                            <div class="photo" @click="choiseCertificateImage(2)">
                                <img v-if="houseRentImage[2] != ''" :src="houseRentImage[2]" width="210" height="145" class="images2">
                                <div v-if="houseRentImage[2] == ''">
                                    <i class="aui-iconfont aui-icon-camera cameraPicture">+</i>
                                </div>
                            </div>
                            <span>签章页</span>
                        </div>
                    </div>

                    <div class="contract1">
                        <div>
                            <van-divider  dashed hairline :style="{ color: '#1989fa', borderColor: '#1989fa', padding: '0 16px' }"/>
                            <van-button class="left" color="#03a9f4" plain >点击查看内容页示例</van-button>
                            <van-button class="right" color="#03a9f4" plain>点击查看登记表页示例</van-button>
                        </div>
                    </div>
                </van-tab>
            </van-tabs>

            <div>
                <van-button  type="info" class="tit2" @click="toMain">保存</van-button>
            </div>
        </div>
    </div>
  </f7-page>
</template>
<script>
    import Vue from 'vue';
    import {applyDoorAuth,photo,repairList} from "@/api/api_estate.js";
    import {dictCodeList,uploadBase64Image,uploadBase64OCRImage} from "@/api/api_common.js";
    import { getMineDetailInfo } from "@/api/api_community.js";
    import { ImagePreview, Grid, GridItem ,Divider,Picker,Dialog } from "vant";
    import{photoIDCard} from "@/api/api_estate.js";
    Vue.use(Grid);
    Vue.use(GridItem);
    Vue.use(Divider);
    Vue.use(Picker);
    Vue.use(Dialog);
    export default {
      name:"applyDoorAuth",
        data(){
            return {
              modules:{
                  main:true,
                  idcardShow:false,
                  liveShow:false,
                  certShow:false
              },
              idCardImages:{
                front:'',
                back:''
              },
              faceImage:'',
              houseRentImage:['','','','','','',''],
              dictionary:{},
              submitForm:{
                  houseType:'',
                  space:0,
                  image:'',
                  liveType:'0'
              }
            }
        },
        created(){
            this.getDictList();
            this.checkCertificate();
        },
        mounted(){

        },
        methods:{
            checkCertificate(){
                repairList({ pageNo: 1}).then(res => {
                    this.getDetailInfo();
                }).catch(err => {
                    this.$commonUtils.jumpLogin(err);
                });
            },
            getDetailInfo(){
                getMineDetailInfo().then(res => {
                    var data = res.data;
                    let resultArr = [];
                    resultArr.push("真实姓名："+data.realname);
                    resultArr.push("手 机 号："+data.mobile);
                    resultArr.push("身份证号："+data.idcard);
                    resultArr.push("详细地址："+(data.villageName || '') +'-'+(data.buildingName || '') + '-' + (data.unitNo || '') +'-'+ (data.houseNo || ''));
                    Dialog.confirm({
                        title: '开门权限申请信息确认',
                        message: resultArr.join('<br>'),
                        confirmButtonText:'重新认证',
                        cancelButtonText:'信息正确'
                    }).then(() => {
                        wx.login('login21');
                    }).catch(() => {

                    });
                });
            },
            async submitAll(){
                if(this.idCardImages.front == ''){
                    wx.toast('请拍摄身份证国徽面');
                    return;
                }
                if(this.idCardImages.back == ''){
                    wx.toast('请拍摄身份证人像面');
                    return;
                }
                if(this.faceImage == ''){
                    wx.toast('请拍摄人脸照片');
                    return;
                }
                if(this.submitForm.houseType == ''){
                    wx.toast('请选择户型');
                    return;
                }
                if(this.submitForm.space == 0){
                    wx.toast('请填写房屋居住面积');
                    return;
                }
                if(this.submitForm.liveType == '1' && (this.houseRentImage[0] == '' || this.houseRentImage[1] == '' || this.houseRentImage[2] == '')){
                    wx.toast('请补全租房证明材料');
                    return;
                }
                if(this.submitForm.liveType == '0' && (this.houseRentImage[5] == '' || this.houseRentImage[6] == '')){
                    wx.toast('请补全房产证明材料');
                    return;
                }

                wx.loading("图片上传中");

                var result = await uploadBase64Image({
                    upfile: this.faceImage
                }).catch(err => {
                    wx.toast("上传失败");
                    wx.closeLoading();
                    return;
                });
                if (result.status == 200) {
                    this.submitForm.image = result.data["url"];
                }
                result = await uploadBase64Image({
                    upfile: this.idCardImages.front
                }).catch(err => {
                    wx.toast("上传失败");
                    wx.closeLoading();
                    return;
                });
                if (result.status == 200) {
                    this.submitForm.idcard = result.data["url"];
                }

                result = await uploadBase64OCRImage({
                    upfile: this.idCardImages.back
                }).catch(err => {
                    wx.toast("上传失败");
                    wx.closeLoading();
                    return;
                });
                if (result.status == 200) {
                    this.submitForm.idcard += ','+result.data["url"];
                    try {
                        this.submitForm.idcardInfo = JSON.stringify(result.data["cards"]);
                    }catch (e) {

                    }
                }

                let resultArr = [];
                for(var i = 0;i<this.houseRentImage.length;i++){
                    if(this.houseRentImage[i] != '' && ((this.submitForm.liveType == '1' && i < 3) || (this.submitForm.liveType == '0' && i > 4))) {
                        result = await uploadBase64Image({
                            upfile: this.houseRentImage[i]
                        }).catch(err => {
                            wx.toast("上传失败");
                            wx.closeLoading();
                            return;
                        });
                        if (result.status == 200) {
                            resultArr.push(result.data["url"]);
                        }
                    }
                }
                wx.closeLoading();
                this.submitForm.liveImage = resultArr.join(",");
                applyDoorAuth(this.submitForm).then(res => {
                    wx.toast("提交成功，请等待物业审核");
                    setTimeout(function() {
                        wx.popPage();
                    }, 1000);
                }).catch(err => {
                    that.$commonUtils.jumpLogin(err);
                });
            },
            getDictList(){
                dictCodeList('house_type').then(res => {
                    this.dictionary = res.data;
                });
            },
            toMain(){
                this.modules = {
                    main:true,
                    idcardShow:false,
                    liveShow:false,
                    certShow:false
                };
            },
            chioseIdCard(value){
                let _this = this;
                wx.uploadIDCard({
                    source: value == 0 ? "faceIdcard":"countryIdcard",
                    success: function(res) {
                        if(value == 0){
                            _this.idCardImages.back = res;
                        }else{
                            _this.idCardImages.front = res;
                        }
                    }
                });
            },
            takeIdcard(){
                this.modules = {
                    main:false,
                    idcardShow:true,
                    liveShow:false,
                    certShow:false
                };
            },
            face(){
                let that = this;
                wx.uploadIDCard({
                    source: "face",
                    success: function(res) {
                        that.faceImage = res;
                    }
                });
            },
            residence(){
                this.modules = {
                    main:false,
                    idcardShow:false,
                    liveShow:true,
                    certShow:false
                };
            },
            certificate() {
                this.modules = {
                    main:false,
                    idcardShow:false,
                    liveShow:false,
                    certShow:true
                };
            },
            choiseCertificateImage(index){
                let _this = this;
                wx.uploadIDCard({
                    source: "camera",
                    success: function(res) {
                        _this.houseRentImage[index] = res;
                        _this.$forceUpdate();
                    }
                });
            }
      }
    }
</script>
<style scoped>
.propertyAudit{
  width: 150px;
  margin-top: 150px;
  margin-left: 110px;
}
.tit{
    text-align: center;
    margin: 1rem;
}
.tit2{
    text-align: center;
    width: 12rem;
    margin: 1.2rem auto;
    font-size: .7rem;
    margin-left: 23.5%;
    font-size: 16px;
    background: #03a9f4;
    border: none;
}
.photo{
    width: 13rem;
    height: 9rem;
    /*border-radius: .3rem;*/
    background: #dddddd;
    margin: .6rem auto;
    position: relative;
}
.camerabox{
    width: 100%;
    -webkit-border-radius:5px;
    -moz-border-radius:5px;
    border-radius: 5px;
    height: 100%;
    display: none;
}
.fileInpBtn{
    position: absolute;
    left: 2;
    top: 0;
    cursor: pointer;
    width: 100%;
    height: 100%;
    /* filter:alpha(opacity:0); */
    opacity: 0;
    border-color:orange;
    z-index:10;
    border: solid red 1px;

}
.cameraPicture{
    position: absolute;
    color: #03a9f4;
    font-size: 3rem;
    top: 15%;
    left:40%;
}
.tip{
    position: absolute;
    bottom: 15%;
    text-align: center;
    width: 100%;
    /* color: #03a9f4; */
}
.imgs{
    float: right;
}
.images1{
    position: relative;
    z-index:10;
}
.images2{
    position: relative;
    z-index:10;
}

.Renting{
    margin-left: 20%;
}
.Rentings{
    margin-left: 40px;
    text-align: center;
}
</style>