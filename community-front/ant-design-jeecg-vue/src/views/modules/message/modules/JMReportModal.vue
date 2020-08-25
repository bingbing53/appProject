<template>
  <a-drawer
      title="反馈详情"
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
          label="反馈类型">
          <j-dict-select-tag  v-decorator="['type', {}]" :triggerChange="true" placeholder="请选择问题分类"
                              dictCode="jmapp_question"/>

        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="反馈内容">
          <a-textarea placeholder="请输入问题描述" :rows="4" v-decorator="['content', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="反馈图片">
          <!--<a-input placeholder="请输入反馈图片" v-decorator="['images', {}]" />-->

          <img :src="item" width="45%" style="margin-left: 3.3%" v-if="!!model.imageArr" v-for="item in model.imageArr"/>

        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="反馈人姓名">
          <a-input placeholder="请输入反馈人姓名" v-decorator="['username', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="反馈人手机号">
          <a-input placeholder="请输入反馈人手机号" v-decorator="['mobile', {}]" />
        </a-form-item>
		
      </a-form>
    </a-spin>
  </a-drawer>
</template>

<script>
  import { httpAction } from '@/api/manage'
  import pick from 'lodash.pick'
  import moment from "moment"
  import ImagPreview from "../../../../../../ant-design-cms-vue/src/views/jeecg/ImagPreview";

  export default {
    name: "JMReportModal",
    components: {ImagPreview},
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
        },
        url: {
          add: "/report/jMReport/add",
          edit: "/report/jMReport/edit",
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
        let that = this;
        this.form.resetFields();
        this.model = Object.assign({}, record);

        if(!!this.model.images){
          var imageArr = JSON.parse(this.model.images);
          this.model.imageArr = [];
          imageArr.forEach(function(item){
            that.model.imageArr.push(window._CONFIG['imageViewURL']+item);
          });
        }

        this.visible = true;
        this.$nextTick(() => {
          this.form.setFieldsValue(pick(this.model,'type','content','images','username','mobile'))

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
/** Button按钮间距 */
  .ant-btn {
    margin-left: 30px;
    margin-bottom: 30px;
    float: right;
  }
</style>