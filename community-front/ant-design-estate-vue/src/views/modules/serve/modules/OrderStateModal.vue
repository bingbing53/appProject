<template>
  <a-modal
    :title="title"
    :width="800"
    :visible="visible"
    :okButtonProps="{ props: {disabled: disableSubmit} }"
    :confirmLoading="confirmLoading"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭">
    <a-spin :spinning="confirmLoading">
      <a-form :form="form">

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="预约服务编号"
          :hidden="hiding"
          hasFeedback>
          <a-input placeholder="请输入预约服务编号" v-decorator="['orderId', {'initialValue':this.mainId}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="服务状态 1待接单 2客服已接单 3已派单 4师傅已接单 5已结束"
          hasFeedback>
          <a-input placeholder="请输入服务状态 1待接单 2客服已接单 3已派单 4师傅已接单 5已结束" v-decorator="['status', {}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="状态时间"
          hasFeedback>
          <a-date-picker showTime format="YYYY-MM-DD HH:mm:ss" v-decorator="[ 'stateDate', {}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="状态描述"
          hasFeedback>
          <a-input placeholder="请输入状态描述" v-decorator="['stateDes', {}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="用户编号"
          hasFeedback>
          <a-input placeholder="请输入用户编号" v-decorator="['sysuserId', {}]" />
        </a-form-item>
      </a-form>
    </a-spin>
  </a-modal>
</template>

<script>
  import {httpAction} from '@/api/manage'
  import pick from 'lodash.pick'
  import moment from 'moment'
  import JDate from '@/components/jeecg/JDate'

  export default {
    components: {
      JDate
    },
    name: 'OrderStateModal',
    data() {
      return {
        title: '操作',
        visible: false,
        model: {},
        labelCol: {
          xs: {span: 24},
          sm: {span: 5}
        },
        wrapperCol: {
          xs: {span: 24},
          sm: {span: 16}
        },
        moment,
        format: 'YYYY-MM-DD HH:mm:ss',
        disableSubmit: false,
        mainId: '',
        hiding: false,
        confirmLoading: false,
        form: this.$form.createForm(this),
        validatorRules: {
        },
        url: {
          add: '/serve/order/addOrderState',
          edit: '/serve/order/editOrderState'
        }
      }
    },
    created() {
    },
    methods: {
      add(mainId) {
        if (mainId) {
          this.edit({mainId}, '')
        } else {
          this.$message.warning('请选择一条数据')
        }
      },
      detail(record) {
        this.edit(record, 'd')
      },
      edit(record, v) {
        if (v == 'e') {
          this.hiding = false;
          this.disableSubmit = false;
        } else if (v == 'd') {
          this.hiding = false;
          this.disableSubmit = true;
        } else {
          this.hiding = true;
          this.disableSubmit = false;
        }
        this.form.resetFields();
        this.mainId = record.mainId;
        this.model = Object.assign({}, record);
        this.visible = true;
        this.$nextTick(() => {
          this.form.setFieldsValue(pick(this.model, 'orderId', 'status', 'stateDate', 'stateDes', 'sysuserId', ))
          // 时间格式化
          this.form.setFieldsValue({ stateDate: this.model.stateDate ? moment(this.model.stateDate) : null })
        })
      },
      close() {
        this.$emit('close');
        this.visible = false;
      },
      handleOk() {
        const that = this;
        // 触发表单验证
        this.form.validateFields((err, values) => {
          if (!err) {
            that.confirmLoading = true;
            let httpurl = '';
            let method = '';
            if (!this.model.id) {
              httpurl += this.url.add;
              method = 'post';
            } else {
              httpurl += this.url.edit;
              method = 'put';
            }
            let formData = Object.assign(this.model, values);
            //时间格式化
            formData.stateDate = formData.stateDate?formData.stateDate.format('YYYY-MM-DD HH:mm:ss'):null;
            httpAction(httpurl, formData, method).then((res) => {
              if (res.success) {
                that.$message.success(res.message);
                that.$emit('ok');
              } else {
                that.$message.warning(res.message);
              }
            }).finally(() => {
              that.confirmLoading = false;
              that.close();
            })
          }
        })
      },
      handleCancel() {
        this.close();
      }
    }
  }
</script>

<style scoped>

</style>
