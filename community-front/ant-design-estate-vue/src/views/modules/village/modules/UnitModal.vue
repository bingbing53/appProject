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
      <a-form :form="form">
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属楼宇" style="display:none">
          <a-input placeholder="请输入所属楼宇" v-decorator="['buildingId', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属小区"  style="display:none">
          <a-input placeholder="请输入所属小区" v-decorator="['villageId', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属楼宇名称" style="display: none;">
          <a-input placeholder="请输入所属楼宇名称" v-decorator="['buildingName', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="单元编号">
          <a-input-number placeholder="请输入单元编号" v-decorator="['unitNo', {}]" :min="0"/>
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="单元俗称">
          <a-input placeholder="请输入单元俗称" v-decorator="['unitName', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="创建人名称"  style="display:none">
          <a-input placeholder="请输入创建人名称" v-decorator="['createName', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="创建日期"  style="display:none">
          <a-date-picker showTime format="YYYY-MM-DD HH:mm:ss" v-decorator="[ 'createDate', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="更新人名称"  style="display:none">
          <a-input placeholder="请输入更新人名称" v-decorator="['updateName', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="更新日期"  style="display:none">
          <a-date-picker showTime format="YYYY-MM-DD HH:mm:ss" v-decorator="[ 'updateDate', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属部门"  style="display:none">
          <a-input placeholder="请输入所属部门" v-decorator="['sysOrgCode', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属部门名称"  style="display:none">
          <a-input placeholder="请输入所属部门名称" v-decorator="['sysOrgName', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属公司"  style="display:none">
          <a-input placeholder="请输入所属公司" v-decorator="['sysCompanyCode', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属公司名称"  style="display:none">
          <a-input placeholder="请输入所属公司名称" v-decorator="['sysCompanyName', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属区域"  style="display:none">
          <a-input placeholder="请输入所属区域" v-decorator="['areaCode', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属区域名称"  style="display:none">
          <a-input placeholder="请输入所属区域名称" v-decorator="['areaName', {}]" />
        </a-form-item>
      </a-form>
    </a-spin>
    <a-button type="primary" @click="handleOk">确定</a-button>
    <a-button type="primary" @click="handleCancel">取消</a-button>
  </a-drawer>
</template>

<script>
import { httpAction } from '@/api/manage'
import pick from 'lodash.pick'
import moment from 'moment'

export default {
  name: 'UnitModal',
  data() {
    return {
      buildingId:'',
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
        add: '/village/unit/add',
        edit: '/village/unit/edit'
      }
    }
  },
  created() {},
  methods: {
    add(buildingId) {
      if (buildingId) {
        this.buildingId = buildingId;
        this.edit({ 'buildingId':buildingId })
      } else {
        this.$message.warning('请选择左边的楼后添加')
      }
    },
    edit(record) {
      this.form.resetFields()
      this.model = Object.assign({}, record)
      this.visible = true
      this.$nextTick(() => {
        this.form.setFieldsValue(
          pick(
            this.model,
            'buildingId',
            'villageId',
            'buildingName',
            'unitNo',
            'unitName',
            'createName',
            'updateName',
            'sysOrgCode',
            'sysOrgName',
            'sysCompanyCode',
            'sysCompanyName',
            'areaCode',
            'areaName'
          )
        )
        //时间格式化
      })
    },
    close() {
      this.$emit('close')
      this.visible = false
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
          if(!!this.buildingId)
            formData.buildingId = this.buildingId;
          console.log(formData)
          // return
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
    unitBuildingId(buildingId){
      this.buildingId = buildingId;

    }
  }
}
</script>

<style lang="less" scoped>
/** Button按钮间距 */
.ant-btn {
  margin-left: 30px;
  margin-bottom: 30px;
  float: right;
}
</style>