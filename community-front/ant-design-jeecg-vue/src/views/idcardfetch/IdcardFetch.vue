<template>
  <div>
    <a-form :layout="formLayout" style="padding:20px;"> 
      
      <a-form-item
        label="姓名"
        :label-col="{span: 4, offset: 0}"
        :wrapper-col="{span: 14, offset: 0}"
      >
        <a-input :value="idcardData.Certificate.Name" />
      </a-form-item>
      <a-form-item
        label="性别"
        :label-col="{span: 4, offset: 0}"
        :wrapper-col="{span: 10, offset: 0}"
      >
        <a-input :value="idcardData.Certificate.Sex" />
      </a-form-item>
      <a-form-item
        label="民族"
        :label-col="{span: 4, offset: 0}"
        :wrapper-col="{span: 14, offset: 0}"
      >
        <a-input :value="idcardData.Certificate.Nation" />
      </a-form-item>
      <a-form-item
        label="住址"
        :label-col="{span: 4, offset: 0}"
        :wrapper-col="{span: 20, offset: 0}"
      >
        <a-input :value="idcardData.Certificate.Address" />
      </a-form-item>
      <a-form-item
        label="有效期限"
       :label-col="{span: 6, offset: 0}"
        :wrapper-col="{span: 14, offset: 0}"
      >
        <a-input :value="idcardData.Certificate.ValidDate" />
      </a-form-item>
      <a-form-item
        label="出生日期"
       :label-col="{span: 6, offset: 0}"
        :wrapper-col="{span: 14, offset: 0}"
      >
        <a-input :value="idcardData.Certificate.Birthday"  />
      </a-form-item>
      <a-form-item
        label="证件号码"
       :label-col="{span: 6, offset: 0}"
        :wrapper-col="{span: 16, offset: 0}"
      >
        <a-input :value="idcardData.Certificate.IDNumber"  />
      </a-form-item>
      <a-form-item
        label="签发机关"
        :label-col="{span: 6, offset: 0}"
        :wrapper-col="{span: 18, offset: 0}"
      >
        <a-input :value="idcardData.Certificate.IDIssued" />
      </a-form-item>
      <a-form-item
        label="头像"
        :label-col="{span: 6, offset: 0}"
        :wrapper-col="{span: 18, offset: 0}"
      >
      <img :src="idcardData.Certificate.Base64Photo" alt="">
      </a-form-item>
      <a-form-item :wrapper-col="buttonItemLayout.wrapperCol">
        <br>
        <a-button type="primary" @click="toreadIDcard()">读取身份证信息</a-button> 
        <!-- <a-button type="primary" @click="toVoice()">语音播放</a-button> -->
      </a-form-item>
    </a-form>
  </div>
</template>

<script>
  import { getAction,getActionID,putAction } from '@/api/manage'
export default {
  data() {
    return {
      formLayout: 'inline',
      url:{
        readID:'/ZKIDROnline/ScanReadIdCardInfo?OP-DEV=1&CMD-URL=4&REPEAT=1',
        voiceID:'/ZKIDROnline/ScanReadIdCardInfo?OP-DEV=1&CMD-URL=16&VoiceType=0'
      },
      
      idcardData:{
        "Certificate":{
          "Name":"",
          "Sex":"",
          "Nation":'',
          "Birthday":'',
          "Address":'',
          "IDNumber":'',
          "IDIssued":'',
          "IssuedData":'',
          "ValidDate":'',
          "Base64Photo":''
        }
      }

    }
  },
  computed: {
    formItemLayout() {
      const { formLayout } = this
      return formLayout === 'horizontal'
        ? {
            labelCol: { span: 4 },
            wrapperCol: { span: 14 }
          }
        : {}
    },
    buttonItemLayout() {
      const { formLayout } = this
      return formLayout === 'horizontal'
        ? {
            wrapperCol: { span: 14, offset: 4 }
          }
        : {}
    }
  },
  methods: {
    toreadIDcard(){
      let _this = this;
      try{
         getActionID(this.url.readID).then((res) => {
            res = res.replace(/\\/g,'\\\\');
            res = JSON.parse(res);
              res.Certificate.Base64Photo = "data:image/jpg;base64," + res.Certificate.Base64Photo;
             _this.idcardData.Certificate = res.Certificate;


          }).catch(error => {
            console.log("读取身份证错误提示：",error);
          });
      }catch(err){
          console.log(err);
      }
    },
    toVoice(){
       try{
         getActionID(this.url.voiceID).then((res) => {
           console.log(res);
            if (res.success) {
              
             
            }
          }).catch(error => {
            console.log("读取身份证错误提示：",error);
          });
      }catch(err){
          console.log(err);
      }
    }
  
  }
}
</script>