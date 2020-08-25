<template>
  <a-modal
    :title="title"
    :width="width"
    :visible="visible"
    :confirmLoading="confirmLoading"
    @ok="handleOk"
    @cancel="handleCancel"
    :destroyOnClose="true"
    cancelText="关闭">
    <a-spin :spinning="confirmLoading">
      <a-form :form="form">

        <a-form-item label="父级节点" :labelCol="labelCol" :wrapperCol="wrapperCol">
          <j-tree-select
            ref="treeSelect"
            placeholder="请选择父级节点"
            v-decorator="['pid', validatorRules.pid]"
            dict="sys_category,name,id"
            pidField="pid">
          </j-tree-select>
        </a-form-item>
          
        <a-form-item label="类型名称" :labelCol="labelCol" :wrapperCol="wrapperCol">
          <a-input v-decorator="[ 'name', validatorRules.name]" placeholder="请输入类型名称"></a-input>
        </a-form-item>
          
        <a-form-item label="类型编码" :labelCol="labelCol" :wrapperCol="wrapperCol">
          <a-input v-decorator="[ 'code', validatorRules.code]" placeholder="请输入类型编码"></a-input>
        </a-form-item>

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
            <img v-if="picUrl" :src="getAvatarView()" alt="图标" style="height:104px;max-width:300px" />
            <div v-else>
              <a-icon :type="uploadLoading ? 'loading' : 'plus'" />
              <div class="ant-upload-text">上传</div>
            </div>
          </a-upload>
        </a-form-item>

      </a-form>
    </a-spin>
  </a-modal>
</template>

<script>
  import Vue from 'vue'
  import { httpAction } from '@/api/manage'
  import { ACCESS_TOKEN } from '@/store/mutation-types'
  import pick from 'lodash.pick'
  import JTreeSelect from '@/components/jeecg/JTreeSelect'
  
  export default {
    name: "SysCategoryModal",
    components: { 
      JTreeSelect
    },
    data () {
      return {
        form: this.$form.createForm(this),
        title:"操作",
        width:800,
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
        validatorRules:{
        pid:{},
        name:{},
        code:{},
        },
        url: {
          add: "/sys/category/add",
          edit: "/sys/category/edit",
          fileUpload: window._CONFIG['domianURL'] + '/sys/common/uploads?action=uploadimage',
          imgerver: window._CONFIG['domianURL'] + '/sys/common/view',
        },
        expandedRowKeys:[],
        pidField:"pid",
        headers:{},
        picUrl: '',
        uploadLoading: false,
      }
    },
    created () {
      const token = Vue.ls.get(ACCESS_TOKEN)
      this.headers = { 'X-Access-Token': token }
    },
    computed: {
      uploadAction: function() {
        return this.url.fileUpload
      }
    },
    methods: {
      handleChange(info) {
        this.picUrl = ''
        if (info.file.status === 'uploading') {
          this.uploadLoading = true
          return
        }
        if (info.file.status === 'done') {
          var response = info.file.response
          this.uploadLoading = false
          console.log(response);
          if (response.code == 200) {
            this.model.icon = response.url
            this.picUrl = response.fullUrlPrefix+'/pic/'+response.url
          } else {
            this.$message.warning(response.message)
          }
        }
      },
      getAvatarView() {
        return this.url.imgerver + '/' + this.model.icon
      },
      beforeUpload: function(file) {
        var fileType = file.type
        if (fileType.indexOf('image') < 0) {
          this.$message.warning('请上传图片')
          return false
        }
      },
      add () {
        this.edit({});
      },
      edit (record) {
        this.form.resetFields();
        this.model = Object.assign({}, record);
        this.visible = true;
        this.$nextTick(() => {
          this.form.setFieldsValue(pick(this.model,'pid','name','code','icon'))
        })
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
            console.log("表单提交数据",formData)
            httpAction(httpurl,formData,method).then((res)=>{
              if(res.success){
                that.$message.success(res.message);
                that.submitSuccess(formData)
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
      popupCallback(row){
        this.form.setFieldsValue(pick(row,'pid','name','code'))
      },
      submitSuccess(formData){
        if(!formData.id){
          let treeData = this.$refs.treeSelect.getCurrTreeData()
          this.expandedRowKeys=[]
          this.getExpandKeysByPid(formData[this.pidField],treeData,treeData)
          this.$emit('ok',formData,this.expandedRowKeys.reverse());
        }else{
          this.$emit('ok',formData);
        }
      },
      getExpandKeysByPid(pid,arr,all){
        if(pid && arr && arr.length>0){
          for(let i=0;i<arr.length;i++){
            if(arr[i].key==pid){
              this.expandedRowKeys.push(arr[i].key)
              this.getExpandKeysByPid(arr[i]['parentId'],all,all)
            }else{
              this.getExpandKeysByPid(pid,arr[i].children,all)
            }
          }
        }
      }
      
      
    }
  }
</script>