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
      
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="模块名">
          <a-input placeholder="请输入模块名" v-decorator="['name', validatorRules.name ]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="访问地址">
          <a-input placeholder="请输入访问地址" v-decorator="['url', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="注册地址">
          <a-input placeholder="请输入注册地址" v-decorator="['registerUrl', {}]" />
        </a-form-item>
        <!-- <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="图标">
          <a-input placeholder="请输入图标" v-decorator="['icon', {}]" /> 
        </a-form-item> -->
         <a-form-item label="图标" :labelCol="labelCol" :wrapperCol="wrapperCol">
          <a-upload
            listType="picture-card"
            class="avatar-uploader"
            :showUploadList="false"
            :action="uploadAction"
            :data="{'isup':1}"
            :headers="headers"
            :beforeUpload="beforeUpload"
            @change="handleChange"
          >
            <img v-if="picUrl" :src="getAvatarView()" alt="头像" style="height:104px;max-width:300px" />
            <div v-else>
              <a-icon :type="uploadLoading ? 'loading' : 'plus'" />
              <div class="ant-upload-text">上传</div>
            </div>
          </a-upload>
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="是否启用">
          <a-input placeholder="请输入是否启用" v-decorator="['state', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="排序">
          <a-input-number v-decorator="[ 'sortNo', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="颜色值">
          <a-input-number v-decorator="[ 'color', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="描述">
          <a-input placeholder="请输入描述" v-decorator="['description', {}]" />
        </a-form-item>
		
      </a-form>
    </a-spin>
    <a-button type="primary" @click="handleOk">确定</a-button>
    <a-button type="primary" @click="handleCancel">取消</a-button>
  </a-drawer>
</template>

<script>
  import { httpAction,postActionimg} from '@/api/manage'
  import pick from 'lodash.pick'
  import moment from "moment"
  import Vue from 'vue'


  import { ACCESS_TOKEN } from '@/store/mutation-types'

  export default {
    name: "SysModulesModal",
    data () {
      return {
        title:"操作",
        visible: false,
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
        name:{rules: [{ required: true, message: '请输入模块名!' }]},
        },
        url: {
          add: "/system/sysModules/add",
          edit: "/system/sysModules/edit",
          fileUpload: window._CONFIG['domianURL'] + '/sys/common/uploads?action=uploadimage',
          imgerver: window._CONFIG['domianURL'] + '/sys/common/view',
        },
        headers: {},
        picUrl: '',
        uploadLoading: false,
        fileName:'',
      }
    },
    computed: {
    uploadAction: function() {
      return this.url.fileUpload
    }
  },
    created () {
      const token = Vue.ls.get(ACCESS_TOKEN)
      this.headers = { 'X-Access-Token': token }
    },
    methods: {
      add () {
        this.picUrl = ''
        this.edit({});
      },
      edit (record) {
        this.form.resetFields();
        this.model = Object.assign({}, record);
        this.visible = true;
        if (record.hasOwnProperty('id')) {
          this.picUrl = this.url.imgerver+'/'+record.icon
        }
        this.$nextTick(() => {
          this.form.setFieldsValue(pick(this.model,'name','url','state','sortNo','description'))
		  //时间格式化
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
            
            // console.log(JSON.stringify(formData))
            // return;
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
    getAvatarView() {
      // return this.url.imgerver + '/' + this.model.icon
      return this.picUrl
    },
    beforeUpload: function(file) {
      this.fileName = file;
      console.log(file)
      var fileType = file.type
      if (fileType.indexOf('image') < 0) {
        this.$message.warning('请上传图片')
        return false
      }
     
      //TODO 验证文件大小
    },
    handleChange(info) {
      this.picUrl = ''
      if (info.file.status === 'uploading') {
        this.uploadLoading = true
        return
      }
      if (info.file.status === 'done') {
        var response = info.file.response
        this.uploadLoading = false
        console.log(response)
        if (response.code == 200) {
          this.model.icon = response.url
          this.picUrl = response.fullUrlPrefix+'/pic/'+response.url
        } else {
          this.$message.warning(response.message)
        }
      }
    },
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