<template>
  <a-modal
    :title="title"
    :width="800"
    :visible="visible"
    :okButtonProps="{ props: {disabled: disableSubmit} }"
    :confirmLoading="confirmLoading"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭">
    <a-spin :spinning="confirmLoading"> 
      <a-form :form="form">

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="楼宇地址"
          hasFeedback>
          <a-input placeholder="请输入楼宇地址" v-decorator="['buildingAddress', {}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="楼院俗称"
          hasFeedback>
          <a-input placeholder="请输入楼院俗称" v-decorator="['buildingName', {}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="房屋类型"
          hasFeedback>
          <a-input placeholder="请输入房屋类型" v-decorator="['roomType', {}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="建筑物用途"
          hasFeedback>
          <a-input placeholder="请输入建筑物用途" v-decorator="['buildingUse', {}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="建造年份"
          hasFeedback>
          <a-date-picker showTime format="YYYY-MM-DD HH:mm:ss" v-decorator="[ 'fixedYear', {}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="建筑层数"
          hasFeedback>
          <a-input-number v-decorator="[ 'upfloorNum', {}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="地下建筑层数"
          hasFeedback>
          <a-input-number v-decorator="[ 'downfloorNum', {}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="建筑结构"
          hasFeedback>
          <a-input placeholder="请输入建筑结构" v-decorator="['buildingStruture', {}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="楼院面积"
          hasFeedback>
          <a-input-number v-decorator="[ 'buildingArea', {}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="每单元每层户数"
          hasFeedback>
          <a-input-number v-decorator="[ 'floorHouesnum', {}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="间数"
          hasFeedback>
          <a-input-number v-decorator="[ 'houseNum', {}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="单元数"
          hasFeedback>
          <a-input-number v-decorator="[ 'unitnum', {}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="经纬度"
          hasFeedback>
          <a-input placeholder="请输入经纬度" v-decorator="['lonlat', {}]" />
        </a-form-item>

        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="备注"
          hasFeedback>
          <a-input placeholder="请输入备注" v-decorator="['remark', {}]" />
        </a-form-item>

      </a-form>
    </a-spin>
  </a-modal>
</template>

<script>
  import {httpAction} from '@/api/manage'
  import pick from 'lodash.pick'
  import moment from 'moment'
  import JDate from '@/components/jeecg/JDate'

  export default {
    components: {
      JDate
    },
    name: 'BuildingModal',
    data() {
      return {
        title: '操作',
        visible: false,
        model: {},
        labelCol: {
          xs: {span: 24},
          sm: {span: 5}
        },
        wrapperCol: {
          xs: {span: 24},
          sm: {span: 16}
        },
        moment,
        format: 'YYYY-MM-DD HH:mm:ss',
        disableSubmit: false,
        tVillageId: '',
        hiding: false,
        confirmLoading: false,
        form: this.$form.createForm(this),
        validatorRules: {
        },
        url: {
          add: '/village/village/addBuilding',
          edit: '/village/village/editBuilding'
        }
      }
    },
    created() {
    },
    methods: {
      add(tVillageId) {
        if (tVillageId) {
          this.edit({tVillageId}, '')
        } else {
          this.$message.warning('请选择一条数据')
        }
      },
      detail(record) {
        this.edit(record, 'd')
      },
      edit(record, v) {
        if (v == 'e') {
          this.hiding = false;
          this.disableSubmit = false;
        } else if (v == 'd') {
          this.hiding = false;
          this.disableSubmit = true;
        } else {
          this.hiding = true;
          this.disableSubmit = false;
        }
        console.log(";;;;;;;;;;;;;;;;;"+JSON.stringify(record))
        this.form.resetFields();
        this.tVillageId = record.tVillageId;
        this.model = Object.assign({}, record);
        console.log(this.model);
        this.visible = true;
        this.$nextTick(() => {
          this.form.setFieldsValue(pick(this.model, 'tVillageId', 'tVillageName', 'buildingAddress', 'buildingName', 'roomType', 'buildingUse', 'fixedYear', 'upfloorNum', 'downfloorNum', 'buildingStruture', 'buildingArea', 'floorHouesnum', 'houseNum', 'unitnum', 'isToilet', 'isWaterDispart', 'isAmmeterDispart', 'lonlat', 'remark', 'createName', 'createDate', 'updateName', 'updateDate', 'sysOrgCode', 'sysOrgName', 'sysCompanyCode', 'sysCompanyName', 'areaCode', 'areaName', ))
          // 时间格式化
          this.form.setFieldsValue({ fixedYear: this.model.fixedYear ? moment(this.model.fixedYear) : null })
          this.form.setFieldsValue({ createDate: this.model.createDate ? moment(this.model.createDate) : null })
          this.form.setFieldsValue({ updateDate: this.model.updateDate ? moment(this.model.updateDate) : null })
        })
      },
      close() {
        this.$emit('close');
        this.visible = false;
      },
      handleOk() {
        const that = this;
        // 触发表单验证
        this.form.validateFields((err, values) => {
          if (!err) {
            that.confirmLoading = true;
            let httpurl = '';
            let method = '';
            if (!this.model.id) {
              httpurl += this.url.add;
              method = 'post';
            } else {
              httpurl += this.url.edit;
              method = 'put';
            }
            let formData = Object.assign(this.model, values);
            //时间格式化
            formData.fixedYear = formData.fixedYear?formData.fixedYear.format('YYYY-MM-DD HH:mm:ss'):null;
            formData.createDate = formData.createDate?formData.createDate.format('YYYY-MM-DD HH:mm:ss'):null;
            formData.updateDate = formData.updateDate?formData.updateDate.format('YYYY-MM-DD HH:mm:ss'):null;
            console.log("formData:"+JSON.stringify(formData))
            // return;
            httpAction(httpurl, formData, method).then((res) => {
              if (res.success) {
                that.$message.success(res.message);
                that.$emit('ok');
              } else {
                that.$message.warning(res.message);
              }
            }).finally(() => {
              that.confirmLoading = false;
              that.close();
            })
          }
        })
      },
      handleCancel() {
        this.close();
      }
    }
  }
</script>

<style scoped>

</style>
