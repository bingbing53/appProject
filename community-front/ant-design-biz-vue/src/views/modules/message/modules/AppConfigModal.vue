<template>
  <a-modal
    :title="title"
    :width="800"
    :visible="visible"
    :confirmLoading="confirmLoading"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭">
    
    <a-spin :spinning="confirmLoading">
      <a-form :form="form">
      
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="名称">
          <a-input placeholder="请输入名称" v-decorator="['name', validatorRules.name ]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="所属应用">
          <!--<a-input placeholder="请输入编码" v-decorator="['code', validatorRules.code ]" />-->
          <a-select placeholder="所属应用" v-decorator="['code', validatorRules.code ]">
            <a-select-option value="office">掌上办公</a-select-option>
            <a-select-option value="estate">掌上物业</a-select-option>
            <a-select-option value="shequyijia">社区e家</a-select-option>
            <a-select-option value="chat">网页聊天室</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="所属平台">
          <!--<a-input placeholder="请输入平台" v-decorator="['platform', {}]" />-->
          <a-select placeholder="所属平台" v-decorator="['platform', validatorRules.platform]">
            <a-select-option value="jiguang">极光推送</a-select-option>
            <a-select-option value="HuaweiPush">华为推送</a-select-option>
            <a-select-option value="MIPush">小米推送</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="钥匙">
          <a-input placeholder="请输入钥匙" v-decorator="['appkey', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="密匙">
          <a-input placeholder="请输入密匙" v-decorator="['appsecret', {}]" />
        </a-form-item>
		
      </a-form>
    </a-spin>
  </a-modal>
</template>

<script>
  import { httpAction } from '@/api/manage'
  import pick from 'lodash.pick'
  import moment from "moment"

  export default {
    name: "AppConfigModal",
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
        name:{rules: [{ required: true, message: '请输入名称!' }]},
        code:{rules: [{ required: true, message: '请选择应用!' }]},
        platform:{rules: [{ required: true, message: '请选择平台!' }]},
        },
        url: {
          add: "/message/appConfig/add",
          edit: "/message/appConfig/edit",
        },
      }
    },
    created () {
    },
    methods: {
      add () {
        this.edit({});
      },
      edit (record) {
        this.form.resetFields();
        this.model = Object.assign({}, record);
        this.visible = true;
        this.$nextTick(() => {
          this.form.setFieldsValue(pick(this.model,'name','code','platform','appkey','appsecret'))
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