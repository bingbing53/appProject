<template>
  <a-modal
    title="提现申请"
    :width="modelWidth"
    :visible="visible"
    :bodyStyle="bodyStyle"
    :confirmLoading="confirmLoading"
    style="top: 10px;"
    @ok="handleOk"
    @cancel="handleCancel"
    :footer="null"
    cancelText="关闭">
    
    <a-spin :spinning="confirmLoading">
      <page-layout :title="'店铺名称：'+ (depart.departName || '')" :logo="depart.logo">
        <detail-list slot="headerContent" size="small" :col="2" class="detail-layout">
          <detail-list-item term="店铺地址">{{depart.address}}</detail-list-item>
          <detail-list-item term="联系电话">{{depart.mobile}}</detail-list-item>
          <detail-list-item term="店铺描述">{{depart.memo}}</detail-list-item>
          <detail-list-item term="账户余额"><span v-if="!!account.balance">{{account.balance}}元</span></detail-list-item>
          <detail-list-item term="公益币余额"><span v-if="!!account.coinBalance">{{account.coinBalance}}</span></detail-list-item>
        </detail-list>
        <a-row slot="extra" class="status-list">
          <a-col :xs="12" :sm="12">
          </a-col>
          <a-col :xs="12" :sm="12">
            <div class="text">状态</div>
            <div class="heading" v-if="model.status == '0'">待审核</div>
            <div class="heading" v-if="model.status == '2'" style="color: #108ee9;">审核通过</div>
            <div class="heading" v-if="model.status == '3'" style="color: #f50;">审核驳回</div>
          </a-col>
        </a-row>
        <template slot="action">
          <a-button type="primary" @click="verify">审核</a-button>
        </template>

        <a-card style="margin-top: 10px" :bordered="false" title="提现申请信息">
          <detail-list>
            <detail-list-item term="申请编号">{{model.sn}}</detail-list-item>
            <detail-list-item term="提现金额">￥{{model.amount}}</detail-list-item>
            <detail-list-item term="银行卡号">{{model.bankAccount}}</detail-list-item>
            <detail-list-item term="开户名">{{model.bankAccountName}}</detail-list-item>
            <detail-list-item term="开户行">{{model.bank}}</detail-list-item>
          </detail-list>
        </a-card>
      </page-layout>

      <draw-crash-verify-modal ref="modalForm" @ok="modalFormOk"></draw-crash-verify-modal>

    </a-spin>
  </a-modal>
</template>

<script>
  import { httpAction,getAction } from '@/api/manage'
  import pick from 'lodash.pick'
  import moment from "moment"
  import DetailList from '@/components/tools/DetailList'
  import PageLayout from '@/components/page/PageLayout'
  import DrawCrashVerifyModal from "./DrawCrashVerifyModal";
  const DetailListItem = DetailList.Item

  export default {
    name: "ShopAccountWithdrawCashHistoryModal",
    components: {
      DrawCrashVerifyModal,
      DetailList,
      PageLayout,
      DetailListItem
    },
    data () {
      return {
        title:"操作",
        visible: false,
        bodyStyle:{
          padding: "0",
        },
        modelWidth:window.innerWidth - 200,
        model: {},
        depart:{},
        account:{
          balance:0,
          coinBalance:0
        },
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
        },
        url: {
          detail: "/mall/shopAccountWithdrawCashHistory/",
          imgServer:window._CONFIG['imageViewURL']+'/'
        },
      }
    },
    created () {
    },
    methods: {
      modalFormOk(){
        this.getDetail({id:this.model.id});
        this.$emit('ok')
      },
      verify(){
        this.$refs.modalForm.open(this.model.id);
      },
      add () {
        this.edit({});
      },
      edit (record) {
        this.visible = true;
        this.getDetail(record);
      },
      //获取详情
      getDetail(record){
        getAction(this.url.detail + record.id).then(res => {
            if(res.success){
              this.model = res.result.history;
              this.depart = res.result.sysDepart;
              if(!!this.depart.logo){
                this.depart.logo = this.url.imgServer + this.depart.logo;
              }
              this.account = res.result.account;
            }else{
              this.$message.warning(res.message);
            }
        });
      },
      close () {
        this.$emit('close');
        this.visible = false;
      },
      handleOk () {
        const that = this;
        // 触发表单验证
        this.form.validateFields((err, values) => {
          if (!err) {
            that.confirmLoading = true;
            let httpurl = '';
            let method = '';
            if(!this.model.id){
              httpurl+=this.url.add;
              method = 'post';
            }else{
              httpurl+=this.url.edit;
               method = 'put';
            }
            let formData = Object.assign(this.model, values);
            //时间格式化
            formData.operateTime = formData.operateTime?formData.operateTime.format('YYYY-MM-DD HH:mm:ss'):null;
            
            console.log(formData)
            httpAction(httpurl,formData,method).then((res)=>{
              if(res.success){
                that.$message.success(res.message);
                that.$emit('ok');
              }else{
                that.$message.warning(res.message);
              }
            }).finally(() => {
              that.confirmLoading = false;
              that.close();
            })
          }
        })
      },
      handleCancel () {
        this.close()
      },


    }
  }
</script>

<style lang="less" scoped>

</style>