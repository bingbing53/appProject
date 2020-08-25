<template>
  <a-modal
    :title="title"
    :width="800"
    :visible="visible"
    :okButtonProps="{ props: {disabled: disableSubmit} }"
    :confirmLoading="confirmLoading"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭"
  >
    <a-spin :spinning="confirmLoading">
      <a-form :form="form">
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="反馈编号"
          :hidden="hiding"
          hasFeedback
        >
          <a-input placeholder="请输入反馈编号" v-decorator="['feedId', {'initialValue':this.mainId}]" />
        </a-form-item>

        <!-- <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="处理人编号" hasFeedback>
          <a-input placeholder="请输入处理人编号" v-decorator="['sysuserId', validatorRules.sysuserId ]" />
        </a-form-item> -->

        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="处理描述" hasFeedback>
           <a-textarea placeholder="请输入处理描述" :rows="4" v-decorator="['handleDes', {}]" />
        </a-form-item>

        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="处理图片" hasFeedback>
          <!-- <a-input placeholder="请输入处理图片" v-decorator="['image', {}]" /> -->
          <a-upload
            :action="uploadAction"
            listType="picture-card"
            :fileList="fileList"
            :headers="headers"
            :beforeUpload="beforeUpload"
            @change="handleChange"
            @preview="handlePreview"
          >
            <div>
              <a-icon type="plus" />
              <div class="ant-upload-text">上传</div>
            </div>
          </a-upload>
          <a-modal :visible="previewVisible" :footer="null" @cancel="handleCancel2">
            <img alt="example" style="width: 100%" :src="previewImage" />
          </a-modal>
        </a-form-item>
      </a-form>
    </a-spin>
  </a-modal>
</template>

<script>
import { httpAction } from '@/api/manage'
import pick from 'lodash.pick'
import moment from 'moment'
import JDate from '@/components/jeecg/JDate'
import Vue from 'vue'
import { ACCESS_TOKEN } from '@/store/mutation-types'
export default {
  components: {
    JDate
  },
  name: 'FeedHandleModal',
  data() {
    return {
      previewVisible: false,
      previewImage: '',
      fileList: [],
      unfileList: [], //没有前缀的图片url
      headers: {},
      picUrl: '',
      uploadLoading: false,
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
      moment,
      format: 'YYYY-MM-DD HH:mm:ss',
      disableSubmit: false,
      mainId: '',
      hiding: false,
      confirmLoading: false,
      form: this.$form.createForm(this),
      validatorRules: {
        sysuserId: { rules: [{ required: true, message: '请输入处理人编号!' }] }
      },
      url: {
        add: '/serve/feedback/addFeedHandle',
        edit: '/serve/feedback/editFeedHandle',
        fileUpload: window._CONFIG['ssoPrefixUrl'] + '/sys/common/upload',
        imgerver: window._CONFIG['ssoPrefixUrl'] + '/sys/common/view'
      }
    }
  },
  created() {
    const token = Vue.ls.get(ACCESS_TOKEN)
    this.headers = { 'X-Access-Token': token }
  },
  computed: {
    uploadAction: function() {
      console.log(this.url.fileUpload)
      return this.url.fileUpload
    }
  },
  methods: {
    handleCancel2() {
      this.previewVisible = false
    },
    handlePreview(file) {
      this.previewImage = file.url || file.thumbUrl
      this.previewVisible = true
    },
    handleChange(fileList) {
      this.fileList = fileList.fileList
    },
    beforeUpload: function(file) {
      var fileType = file.type
      if (fileType.indexOf('image') < 0) {
        this.$message.warning('请上传图片')
        return false
      }
      //TODO 验证文件大小
    },
    add(mainId) {
      if (mainId) {
        this.edit({ mainId }, '')
      } else {
        this.$message.warning('请选择一条数据')
      }
    },
    detail(record) {
      this.edit(record, 'd')
    },
    edit(record, v) {
      this.fileList = []
      if (JSON.stringify(record) != '{}') {
        console.log(record.image)
        if (typeof record.image == 'string' && record.image != null) {
          record.image = JSON.parse(record.image)
        }

        if (record.image != null) {
          let that = this
          console.log(that.url.imgerver)
          let url = that.url.imgerver
          record.image.forEach(function(item, index) {
            let imageArr = {}
            imageArr.url = url + '/' + item
            imageArr.status = 'done'
            imageArr.uid = index
            imageArr.name = ''
            imageArr.myurl = item
            that.fileList.push(imageArr)
          })
        }
      }
      if (v == 'e') {
        this.hiding = false
        this.disableSubmit = false
      } else if (v == 'd') {
        this.hiding = false
        this.disableSubmit = true
      } else {
        this.hiding = true
        this.disableSubmit = false
      }
      this.form.resetFields()
      this.mainId = record.mainId
      this.model = Object.assign({}, record)
      this.visible = true
      this.$nextTick(() => {
        this.form.setFieldsValue(pick(this.model, 'feedId', 'sysuserId', 'handleDes', 'image'))
        // 时间格式化
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
          let imageArr = []
          this.fileList.forEach((item, index) => {
            if (item.response && item.response.message) {
              imageArr.push(item.response.message)
            } else if (item.myurl) {
              imageArr.push(item.myurl)
            }
          })
          formData.image = JSON.stringify(imageArr)
          // console.log(JSON.stringify(this.fileList))
          console.log(JSON.stringify(formData))
          // return
          //时间格式化
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
    }
  }
}
</script>

<style scoped>
</style>
