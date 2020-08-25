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
          label="设备型号">

          <j-dict-select-tag v-decorator="['manuModelId', validatorRules.manuModelId]" :triggerChange="true" placeholder="请选择设备型号"
                             dictCode="d_manu_model,name,id"/>


        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="设备名称">
          <a-input placeholder="请输入设备名称" v-decorator="['name', validatorRules.name]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="设备编码">
          <a-input placeholder="请输入设备编码" v-decorator="['code', validatorRules.code]" />
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
  import moment from "moment"

  import JSelectDepart from '@/components/jeecgbiz/JSelectDepart'

  export default {
    name: "DeviceModal",
    components:{
      JSelectDepart
    },
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
          manuModelId:{rules: [{ required: true, message: '请选择所属型号!' }]},
          name:{rules: [{ required: true, message: '请输入设备名称!' }]},
          code:{rules: [{ required: true, message: '请输入设备编码!' }]},
        },
        url: {
          add: "/device/device/add",
          edit: "/device/device/edit",
        },
      }
    },
    created () {
    },
     watch:{
      "value":{
        immediate:true,
        handler(val){
          if(!val){
            this.selectedValue=[]
            this.selectedAsyncValue=[]
          }else{
            this.initSelectValue()
          }
        }
      },
      "dict":{
        handler(){
          this.initDictData()
        }
      }
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
          this.form.setFieldsValue(pick(this.model,'manuModelId','name','code'))
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
      },
      handleCancel () {
        this.close()
      },


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