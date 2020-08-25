<template>
  <a-modal
    :title="title"
    :width="1000"
    :visible="visible"
    :confirmLoading="confirmLoading"
    @ok="handleOk"
    @cancel="handleCancel"
  >
    <a-spin :spinning="confirmLoading">
      <!-- 主表单区域 -->
      <a-form :form="form">
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="反馈内容">
          <a-input placeholder="请输入反馈内容" v-decorator="['content', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="反馈图片">
          <a-input placeholder="请输入反馈图片" v-decorator="['image', {}]" />

        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="反馈人编号">
          <a-input placeholder="请输入反馈人编号" v-decorator="['userId', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="反馈时间">
          <a-date-picker showTime format="YYYY-MM-DD HH:mm:ss" v-decorator="[ 'inDate', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="反馈分类">
          <a-input placeholder="请输入反馈分类" v-decorator="['feedType', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="反馈来源">
          <a-input placeholder="请输入反馈来源" v-decorator="['feedOrgin', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属部门">
          <a-input placeholder="请输入所属部门" v-decorator="['sysOrgCode', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属公司">
          <a-input placeholder="请输入所属公司" v-decorator="['sysCompanyCode', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属地区">
          <a-input placeholder="请输入所属地区" v-decorator="['areaCode', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="是否处理">
          <a-input placeholder="请输入是否处理" v-decorator="['isHandle', {}]" />
        </a-form-item>
      </a-form>
    </a-spin>
  </a-modal>
</template>

<script>

import { httpAction } from '@/api/manage'
import JDate from '@/components/jeecg/JDate'
import pick from 'lodash.pick'
import moment from 'moment'

export default {
  name: 'FeedbackModal',
  components: {
    JDate
  },
  data() {
    return {
      title: '操作',
      visible: false,
      model: {},
      labelCol: {
        xs: { span: 24 },
        sm: { span: 5 }
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 }
      },
      confirmLoading: false,
      form: this.$form.createForm(this),
      validatorRules: {},
      url: {
        add: '/serve/feedback/add',
        edit: '/serve/feedback/edit',
        feedHandleList: '/serve/feedback/queryFeedHandleByMainId',
      }
    }
  },
 
 
  methods: {
    add() {
      this.edit({})
    },
    edit(record) {

      this.form.resetFields()
      this.model = Object.assign({}, record)
      //初始化明细表数据
      console.log(this.model.id)
      this.visible = true
      this.$nextTick(() => {
        this.form.setFieldsValue(
          pick(
            this.model,
            'content',
            'image',
            'userId',
            'inDate',
            'feedType',
            'feedOrgin',
            'sysOrgCode',
            'sysCompanyCode',
            'areaCode',
            'isHandle'
          )
        )
        // 时间格式化
        this.form.setFieldsValue({ inDate: this.model.inDate ? moment(this.model.inDate) : null })
      })
    },
    close() {
      this.visible = false
      this.$emit('close')
    },
    handleOk() {
      const that = this
      // 触发表单验证
      this.form.validateFields((err, values) => {
        if (!err) {
          that.confirmLoading = true
          let httpurl = ''
          let method = ''
          if (!this.model.id) {
            httpurl += this.url.add
            method = 'post'
          } else {
            httpurl += this.url.edit
            method = 'put'
          }
          let formData = Object.assign(this.model, values)
          //时间格式化
          formData.inDate = formData.inDate ? formData.inDate.format('YYYY-MM-DD HH:mm:ss') : null

         
          console.log(JSON.stringify(formData))
          console.log(JSON.stringify(this.fileList))
          //  return;
          httpAction(httpurl, formData, method)
            .then(res => {
              if (res.success) {
                that.$message.success(res.message)
                that.$emit('ok')
              } else {
                that.$message.warning(res.message)
              }
            })
            .finally(() => {
              that.confirmLoading = false
              that.close()
            })
        }
      })
    },
    handleCancel() {
      this.close()
    },
  
    
    
  }
}
</script>

<style scoped>
.ant-btn {
  padding: 0 10px;
  margin-left: 3px;
}

.ant-form-item-control {
  line-height: 0px;
}

/** 主表单行间距 */
.ant-form .ant-form-item {
  margin-bottom: 10px;
}

/** Tab页面行间距 */
.ant-tabs-content .ant-form-item {
  margin-bottom: 0px;
}
</style>