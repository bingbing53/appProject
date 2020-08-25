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
    <div>
      <a-form class="ant-advanced-search-form" :form="form"  @submit="handleSearch">
        <a-row :gutter="24" v-show="dataForm.length >0">
          <a-col v-for="(item,index) in dataForm" :key="index" :span="12">
            {{item.paramName}}
            <a-form-item>
              <a-select  v-if="!!item.selectList" v-model="dataForm[index].value">
                <a-select-option v-for="(opt,index2) in item.select" :value="opt.value" :key="index2">
                  {{opt.label}}
                </a-select-option>
              </a-select>
              <a-input v-else
                v-model="dataForm[index].value"
                :placeholder="`${item.paramName}`"
                :type="`${item.paramType}`"
              />
            </a-form-item>
          </a-col>
        </a-row>
      </a-form>
    </div>
  </a-modal>
</template>

<script>
import { getAction,httpAction } from '@/api/manage'

export default {
  name: 'DeviceConfig',
  data() {
    return {
      title: '参数配置',
      visible: false,
      confirmLoading: false,
      url: {
        device: '/device/deviceParam/queryParamDataById',
        submitDevice:'device/deviceParam/saveParamDataById'
      },
      model: {},
      deviceId: '',
      dataForm:[],
      form: this.$form.createForm(this, { name: 'advanced_search' })
    }
  },
  methods: {
    open() {
      this.visible = true
    },
    handleCancel() {
      this.close()
    },
    close() {
      this.$emit('close')
      this.visible = false
    },
    handleOk() {
      this.visible = true;
      this.handleSearch();
    },
    getMain(id) {
      this.deviceId = id
      this.$nextTick(() => {
        this.getFormParam()
      })
    },
    getFormParam() {
      let that = this
      that.dataForm = [];
      getAction(this.url.device, { id: this.deviceId }).then(res => {
        if (res.success) {
          //console.log(JSON.stringify(res.result))

          res.result.forEach(function(item){
            if(!!item.selectList)
              item.select = JSON.parse(item.selectList)  

            that.dataForm.push(item);
          })

        }
        console.log(res)
      })
    },
    handleSearch() {
        let that = this;
      this.form.validateFields((error, values) => {
          console.log(JSON.stringify(this.dataForm))
          let formData = {
              id:"",
              deviceParams:[]
          };
          
          formData.id = this.deviceId;
          this.dataForm.forEach((item,index) => {
              formData.deviceParams.push({"value":item.value,"paramCode":item.paramCode});
          });
            that.confirmLoading = true;
            let httpurl = '';
            let method = '';
            console.log(JSON.stringify(formData))
            // return;
           httpAction(this.url.submitDevice, formData, 'post')
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

      });
    },
  },
  created() {}

}
</script>

<style>
</style>