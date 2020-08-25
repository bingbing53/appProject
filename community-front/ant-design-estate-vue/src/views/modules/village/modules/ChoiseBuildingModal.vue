<template>
  <a-modal
    :title="title"
    :width="1000"
    :visible="visible"
    :okButtonProps="{ props: {disabled: disableSubmit} }"
    :confirmLoading="confirmLoading"
    :maskClosable="false"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭"
  >

    <a-transfer
      :dataSource="buildingList"
      showSearch
      @change="handleChange"
      :listStyle="{
      width: '40%',
      height: '350px',
    }"
      :operations="['添加楼宇', '移除楼宇']"
      :titles="['待选择楼宇','已选择楼宇']"
      :targetKeys="targetKeys"
      :render="item=>`${item.title}`"
    >
      <span slot="notFoundContent">
      没有数据
    </span>
    </a-transfer>

  </a-modal>
</template>

<script>
import { httpAction, getAction } from '@/api/manage'
import pick from 'lodash.pick'
import moment from 'moment'
import JDate from '@/components/jeecg/JDate'
export default {
  components: {
    JDate
  },
  name: 'ChoiseBuildingModal',
  data() {
    return {
      keyword: '',
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
      villageId: '',
      hiding: false,
      confirmLoading: false,
      form: this.$form.createForm(this),
      validatorRules: {},
      url: {
        add: '/village/building/addBuildingByIds',
        edit: '/village/village/editBuilding',
        buildingData: '/village/building/queryBuildingByVillageId/',
      },
      buildingList:[],
      targetKeys:[]
    }
  },
  created() {},
  methods: {
    handleChange(nextTargetKeys, direction, moveKeys) {
      this.targetKeys = nextTargetKeys;
    },
    add(villageId, my_selectionRows) {
      if (villageId) {
        this.getDetailBuildng(villageId);
        this.visible = true;
      } else {
        this.$message.warning('请选择一个小区')
      }
    },
    detail(record) {
      this.edit(record, 'd')
    },
    close() {
      this.$emit('close')
      this.visible = false
    },
    handleOk() {
      if(this.targetKeys.length <= 0){
        this.$message.warning('请选择要添加的楼宇')
        return;
      }
      const that = this
      // 触发表单验证
      that.confirmLoading = true
      let method = ''
      let formData = {'id':this.targetKeys.join(',')};
      httpAction(this.url.add, formData, 'post').then(res => {
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
    },
    handleCancel() {
      this.close()
    },
    //获取详情数据
    getDetailBuildng(villageId) {
      this.buildingList = [];
      this.targetKeys = [];
      getAction(this.url.buildingData+villageId).then(res => {
        if(res.success){
          let building = res.result;
          this.buildingList = [];
          if(building != null && building.length > 0){
            for(var i = 0;i<building.length;i++){
              this.buildingList.push({
                key:building[i].id,
                title:building[i].buildingName,
                description:building[i].buildingName
              });
            }
          }
        }
      })
    }
  }
}
</script>

<style scoped>
.map {
  height: 500px;
  width: 100%;
}
.steps-content {
  margin-top: 16px;
  border: 1px dashed #e9e9e9;
  border-radius: 6px;
  background-color: #fafafa;
  min-height: 200px;
  text-align: center;
}

.steps-action {
  margin-top: 24px;
}
.ant-btn {
  padding: 0 10px;
  margin-left: 3px;
}
.ant-form-item-control {
  line-height: 0px;
}
/** 主表单行间距 */
.ant-form .ant-form-item {
  margin-bottom: 10px;
}
/** Tab页面行间距 */
.ant-tabs-content .ant-form-item {
  margin-bottom: 0px;
}
.step_last {
  margin-bottom: 20px;
}
</style>
