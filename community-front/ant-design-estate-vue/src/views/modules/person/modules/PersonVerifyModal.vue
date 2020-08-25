<template>
  <a-drawer
      :title="title"
      :width="800"
      placement="right"
      :closable="false"
      @close="close"
      :visible="visible"
  >
    <a-spin :spinning="confirmLoading">

      <a-descriptions title="" layout="vertical" bordered size="small">
        <a-descriptions-item label="姓名">
          {{model.realname}}
        </a-descriptions-item>
        <a-descriptions-item label="手机号">
          {{model.mobile}}
        </a-descriptions-item>
        <a-descriptions-item label="身份证号">
          {{model.idcardStr}}
        </a-descriptions-item>
        <a-descriptions-item label="性别">
          {{model.idcardInfo.gender}}
        </a-descriptions-item>
        <a-descriptions-item label="民族">
          {{model.idcardInfo.race}}
        </a-descriptions-item>
        <a-descriptions-item label="户籍地址">
          {{model.idcardInfo.address}}
        </a-descriptions-item>
        <a-descriptions-item label="居住地址" :span="3">
          {{model.address}}
        </a-descriptions-item>
        <a-descriptions-item label="房屋面积">
          {{model.space}}㎡
        </a-descriptions-item>
        <a-descriptions-item label="房屋户型">
          {{model.houseType_dictText}}
        </a-descriptions-item>
        <a-descriptions-item label="居住类型">
          <a-tag color="green" v-if="model.liveType == '0'">自住</a-tag>
          <a-tag color="green" v-if="model.liveType == '1'">租住</a-tag>
        </a-descriptions-item>
        <a-descriptions-item label="申请时间">
          {{model.createTime}}
        </a-descriptions-item>
        <a-descriptions-item label="申请状态" :span="2">
          <a-badge v-if="model.state == '0'" status="processing" text="待审核" />
          <a-badge v-if="model.state == '1'" status="success" text="审核通过" />
          <a-badge v-if="model.state == '2'" status="error" text="审核未通过" />
        </a-descriptions-item>
        <a-descriptions-item v-if="model.state == '2'" label="未通过原因" :span="3">
          {{model.verifyDes}}
        </a-descriptions-item>
        <a-descriptions-item label="身份证照片" :span="3">
          <viewer>
            <img v-for="(item,index) in model.idcardImage" :src="item" width="100px" style="margin-right: 10px;" :alt="'身份照片-'+(index+1)"/>
          </viewer>
        </a-descriptions-item>
        <a-descriptions-item label="自拍照片" :span="3">
          <viewer>
            <img :src="model.image" width="100px"/>
          </viewer>
        </a-descriptions-item>
        <a-descriptions-item label="房产证或租房合同照片" :span="3">
          <viewer>
            <img v-for="(item,index) in model.liveImages" :src="item" width="100px" style="margin-right: 10px;"  :alt="'房产证或租房合同照片-'+(index+1)"/>
          </viewer>
        </a-descriptions-item>
      </a-descriptions>
    </a-spin>

    <a-popconfirm v-if="model.state == '0'" title="请核对信息是否审核通过？" @confirm="handleOk(1,'')" @cancel="visibleView = true" okText="审核通过" cancelText="不通过">
      <a-button type="primary" style="margin-right: .8rem">审核</a-button>
    </a-popconfirm>
    <a-button type="info" @click="handleCancel">取消</a-button>

    <a-modal title="审核不通过的原因" v-model="visibleView" @ok="viewHandleOk">
      <a-textarea :rows="4" placeholder="请输入不通过的原因" v-model="yourReason"></a-textarea>
    </a-modal>

  </a-drawer>
</template>

<script>
  import { httpAction,postAction } from '@/api/manage'
  import pick from 'lodash.pick'
  import moment from "moment"
  import Vue from 'vue';
  import Viewer from 'v-viewer'
  import 'viewerjs/dist/viewer.css'
  Vue.use(Viewer)

  export default {
    name: "PersonVerifyModal",
    data () {
      return {
        title:"操作",
        visible: false,
        visibleView: false,
        yourReason:'',
        model: {},
        labelCol: {
          xs: { span: 24 },
          sm: { span: 5 },
        },
        wrapperCol: {
          xs: { span: 24 },
          sm: { span: 16 },
        },

        confirmLoading: false,
        form: this.$form.createForm(this),
        validatorRules:{
        userId:{rules: [{ required: true, message: '请输入用户编号!' }]},
        },
        url: {
          add: "/person/personVerify/add",
          edit: "/person/personVerify/edit",
          verify:"person/personVerify/verify",
          imgerver: window._CONFIG['imageViewURL'],
        },
      }
    },
    created () {
    },
    methods: {
      imageView(url) {
        return window._CONFIG['imageViewURL'] + '/' + url
      },
      add () {
        this.edit({});
      },
      edit (record) {
        let _this = this;
        this.form.resetFields();
        this.model = Object.assign({}, record);

        if(!!this.model.image) {
          this.model.image = this.imageView(this.model.image);
        }
        if(!!this.model.idcard){
          _this.model.idcardImage = [];
          var idcardImages = this.model.idcard.split(',');
          console.log(idcardImages);
          idcardImages.forEach(function (item) {
            _this.model.idcardImage.push(_this.imageView(item));
          });
          console.log(_this.model.idcardImage);
        }
        if(!!this.model.liveImage){
          var liveImages = this.model.liveImage.split(',');
          _this.model.liveImages = [];
          liveImages.forEach(function (item) {
            _this.model.liveImages.push(_this.imageView(item));
          });
        }
        if(!!this.model.idcardInfo){
          try {
            this.model.idcardInfo = JSON.parse(this.model.idcardInfo);
            console.log(this.model.idcardInfo);
          }catch (e) {
            this.model.idcardInfo = null;
          }
        }

        this.visible = true;
      //   this.$nextTick(() => {
      //     this.form.setFieldsValue(pick(this.model,'userId','image','idcard','space','houseType','liveType','liveImage','state','verifyDes','sysOrgCode'))
		  // //时间格式化
      //   });



      },
      close () {
        this.$emit('close');
        this.visible = false;
      },
      viewHandleOk(){
        this.visibleView = false;
        this.handleOk(2,this.yourReason);
      },
      handleOk (state,verifyDes) {
        const that = this;
        that.confirmLoading = true;

        postAction(this.url.verify,{id:this.model.id,state:state,verifyDes:verifyDes}).then(res => {
          if(res.success) {
            that.$message.success(res.message);
            that.$emit('ok');
          }else{
            that.$message.warning(res.message);
          }
          that.confirmLoading = false;
          that.close();
        }).finally(() => {
          that.confirmLoading = false
          that.yourReason =  '';
        })
      },
      handleCancel () {
        this.close()
      },
    }
  }
</script>

<style lang="less" scoped>
/** Button按钮间距 */
  .ant-btn {
    margin-left: 30px;
    margin-bottom: 30px;
    margin-top: 30px;
    float: right;
  }
</style>