<template>
  <a-spin :spinning="confirmLoading">
    <a-form :form="form">
      <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="正常订单超过：">
        <a-input v-decorator="['normalOrderOvertime', validatorRules.normalOrderOvertime]" suffix="分钟未付款，自动取消"/>
      </a-form-item>
      <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="发货超过：">
        <a-input v-decorator="['confirmOvertime', validatorRules.confirmOvertime]" suffix="天未收货，订单自动完成"/>
      </a-form-item>
      <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="订单完成超过：">
        <a-input v-decorator="['finishOvertime', validatorRules.finishOvertime]" suffix="天自动结束交易，不能申请售后"/>
      </a-form-item>
      <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="订单完成超过：">
        <a-input v-decorator="['commentOvertime', validatorRules.commentOvertime]" suffix="天自动五星好评"/>
      </a-form-item>
      <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="一公益币价值：">
        <a-input v-decorator="['coinMoney', validatorRules.coinMoney]" suffix="元"/>
      </a-form-item>
      <a-form-item :wrapperCol="wrapperCol" class="mg-auto tc">
        <a-button type="primary" html-type="submit" class="mg-10" @click="update()" :disabled="confirmLoading">提交修改</a-button>
      </a-form-item>
    </a-form>
  </a-spin>

</template>

<script>
  import { httpAction, postAction, getAction, deleteAction,putAction } from '@/api/manage'
  import pick from 'lodash.pick'
  export default {
      name: "OmsOrderSetting",
    data(){
      return {
        form: this.$form.createForm(this),
        model:{},
        labelCol: {
          xs: { span: 24 },
          sm: { span: 5 }
        },
        wrapperCol: {
          xs: { span: 12 },
          sm: { span: 12 }
        },
        confirmLoading:false,
        validatorRules: {
          normalOrderOvertime: { rules: [{ required: true, message: '请输入超时时间' },{ validator: this.changeKey }] },
          confirmOvertime: { rules: [{ required: true, message: '确认收货超时时间' },{ validator: this.changeKey }] },
          finishOvertime: { rules: [{ required: true, message: '超时申请售后时间' },{ validator: this.changeKey }] },
          commentOvertime: { rules: [{ required: true, message: '超时自动好评时间' },{ validator: this.changeKey }] },
          coinMoney: { rules: [{ required: true, message: '一个公益币价值' },{ validator: this.changeKey }] },
        },
        url: {
          list: "/mall/omsOrderSetting/query",
          update: "/mall/omsOrderSetting/edit",
        },
      }
    },
    created() {
      this.query();
    },
    methods: {
      changeKey(rule, value, callback){
        let rgx = /^[1-9]{1}[0-9]*$/
        if(rgx.test(value)){
          callback()
        }else{
          callback(new Error('请填写正确的数字'))
        }
      },
      query(){
        getAction(this.url.list).then(res => {
          if (res.success) {
            this.model = res.result;
            this.form.setFieldsValue(
              pick(
                this.model,
                'normalOrderOvertime',
                'confirmOvertime',
                'finishOvertime',
                'commentOvertime',
                'coinMoney'
              )
            )
          }
        })
      },
      update(){
        let that = this;
        this.form.validateFields((err, values) => {
          if (!err) {
            that.confirmLoading = true
            let formData = Object.assign(this.model, values)
            putAction(this.url.update,formData).then(res => {
              if (res.success) {
                that.$message.success('修改成功');
              }
            }).finally(() => {
              that.confirmLoading = false
            })
          }
        })
      },
    }
  }
</script>

<style scoped>
  .tc{
    text-align: center;
  }
  .ant-form{
    background: #fff;
    padding: 20px 10px 20px 10px;
  }
</style>