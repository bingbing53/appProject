<template>
  <a-modal
    :title="title"
    :width="800"
    :visible="visible"
    :confirmLoading="confirmLoading"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭"
  >
    <a-spin :spinning="confirmLoading">
      <a-form :form="form">
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="设备型号" style="display:none">
          <a-input placeholder="请输入设备型号" v-decorator="['manuModelId', {}]" disabled />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="参数名称" style="height:40px;">
          <a-input placeholder="请输入参数名称" v-decorator="['paramName', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="参数编码" style="height:40px;">
          <a-input placeholder="请输入参数编码" v-decorator="['paramCode', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="参数类型" style="height:40px;">
          <a-input placeholder="请输入参数类型" v-decorator="['paramType', {}]" />
        </a-form-item>
      </a-form>
    </a-spin>
    
     <div id="divs">
       <a-form layout="inline" id="forms">
           <a-row :gutter="24" v-for="(item,index) in selectList" :key="index" id="rows">
            <a-col :md="6" :sm="8">
              <a-form-item label="描述">
                <a-input v-model="selectList[index].label" style="display:inline-block;"  class="inputs"></a-input>
              </a-form-item>
            </a-col>
            <a-col :md="6" :sm="8">
              <a-form-item label="值">
                <a-input  v-model="selectList[index].value" style="display:inline-block;" class="inputs"></a-input>
              </a-form-item>
            </a-col>
            <a-col  :md="6" :sm="8">           
               <a-button @click="del(index)"  class="btn" >删除</a-button>           
            </a-col>
          </a-row> 
        </a-form>
    </div>
        <a-button @click="newlyAdded" type="primary">
            新增
        </a-button>
  
  </a-modal>
</template>

<script>
import { httpAction } from '@/api/manage'
import pick from 'lodash.pick'
import moment from 'moment'

export default {
  name: 'DeviceParamDictModal',
  props: ['deviceName'],
  data() {
    return {
      title: '操作',
      visible: false,
      items:[],
      queryParamsModel:[{}],
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
      validatorRules: {
        equipmentName:{rules:[{required:true,message:"111"}]}
      },
      url: {
        add: '/device/deviceParamDict/add',
        edit: '/device/deviceParamDict/edit'
      },

      selectList:[]
     
    }
  },
  created() {},
  methods: {
    add() {
      this.edit({})
      console.log(this.deviceName)
      this.$nextTick(() => {
        this.form.setFieldsValue({
          manuModelId: this.deviceName
        })
      })
    },

    //新增input框
    newlyAdded(){
      this.selectList.push({"label":"","value":""})
    },
    del(index){
        this.selectList.splice(index, 1);
    },
    show(){
    if(!this.queryParamsModel||this.queryParamsModel.length==0){
      this.queryParamsModel=[{}]
    }
    this.visible=true;
    },
    
    edit(record) {
      this.form.resetFields()
      this.model = Object.assign({}, record)
      this.visible = true
      this.$nextTick(() => {
        this.form.setFieldsValue(pick(this.model, 'manuModelId', 'paramName', 'paramCode', 'paramType'))
        //时间格式化
      })

      if(!!this.model.selectList)
        this.selectList = JSON.parse(this.model.selectList);
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
          //时间格式化

          formData.selectList = JSON.stringify(this.selectList);
          console.log(formData)
          //return;
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
        if(!this.isNullArray()){
          this.$emit(this.callback, this.queryParamsModel)
        }else{
          this.$emit(this.callback)
        }


      })
    },
 
    handleCancel() {
      this.close()
    }
  }
}
</script>

<style lang="less" scoped>
/** Button按钮间距 */
  .ant-btn {
    margin-left: 569px;
    margin-bottom: 30px;
    margin-top: 20px;
  }
  .selectList{
    width: 200px;
    margin-left:120px ;
  }
  .a-select{
    margin-left: 120px;
    bottom: 10px;
  }
  #divs{
    margin-top: 5px;
  }
  #forms{
    margin-left: 100px;
  }
  #rows{
    display: flex;
  }
  .btn{
    margin-left: 130px;
    margin-top:45px;
  }
  .ant-row{
    height: 95px;
  }
</style>