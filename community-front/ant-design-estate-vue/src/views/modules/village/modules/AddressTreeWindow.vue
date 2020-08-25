<template>
  <a-modal
    :width="modalWidth"
    :visible="visible"
    title="地址搜索"
    :confirmLoading="confirmLoading"
    @ok="handleSubmit"
    @cancel="handleCancel"
    cancelText="关闭"
    wrapClassName="ant-modal-cust-warp"
  >
    <!--树-->
    <template>
      <a-form :form="form">
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="请选择单元">
          <a-tree
            :multiple="false"
            treeCheckable="tree"
            checkable
            :checkedKeys="checkedKeys"
            allowClear="true"
            :checkStrictly="true"
            @check="onCheck"
            :loadData="onLoadData"
            :dropdownStyle="{maxHeight:'200px',overflow:'auto'}"
            :treeData="treeData"
            placeholder="请选择"
          ></a-tree>
        </a-form-item>
      </a-form>
    </template>
  </a-modal>
</template>

<script>
import pick from 'lodash.pick'
import { getAction } from '@/api/manage'
import { queryIdTree } from '@/api/api'
export default {
  name: 'addressWindow',
  components: {},
  data() {
    return {
      checkedKeys: [],
      modalWidth: 500,
      treeData: [],
      keyValue: '', //存储所选的节点信息
      keyName: '',
      title: '操作',
      visible: false,
      labelCol: {
        xs: { span: 24 },
        sm: { span: 5 }
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 }
      },
      confirmLoading: false,
      headers: {},
      form: this.$form.createForm(this),
      url: {
        villageTree: '/village/village/queryVillageTree'
      }
    }
  },
  methods: {
    add() {
      // this.treeData = [];
      // this.checkedKeys = [];
      // this.keyValue = '';
      // this.keyName = '';
      // this.expandedKeysss = [];
      this.edit({})
    },
    edit(record) {
      if(this.treeData.length <= 0)
        this.queryDepartTree()
      this.form.resetFields()
      this.visible = true
      this.model = Object.assign({}, record)
      let filedsVal = pick(this.model, 'keyName', 'keyValue')
      this.$nextTick(() => {
        this.form.setFieldsValue(filedsVal)
      })
    },
    close() {
      this.visible = false
      this.departList = []
      this.checkedKeys = []
      // this.treeData = []
      // this.keyValue = ''
      // this.keyName = ''
      this.$emit('close')
    }, 
    handleSubmit() {
      const that = this
      // 触发表单验证
      this.form.validateFields(err => {
        if (!err) {
          that.confirmLoading = true
          console.log(this.keyValue,this.keyName)
          if (this.keyValue != null) {
            let formData = {}
              formData.keyValue = this.keyValue;
              formData.keyName = this.keyName;
              console.log(JSON.stringify(formData))
              // return
            that.confirmLoading = false
            that.$emit('ok', formData)
            that.close()
          } else {
            alert('请选择')
          }
        }
      })
    },
    handleCancel() {
      this.close()
    },
    // 选择部门时作用的API
    onCheck(checkedKeys, info) {
      if(checkedKeys.checked.length > 0){
        this.checkedKeys = [checkedKeys.checked[checkedKeys.checked.length - 1]];
      }
      // this.checkedKeys = checkedKeys.checked
      // alert(checkedKeys.checked.length)
      // console.log('onCheck:'+ JSON.stringify(checkedKeys))
      // console.log('onCheck:', info.node.dataRef.title)
      let that = this
      checkedKeys.checked.forEach((item, index) => {
        this.keyValue = item
      })
      console.log(info.node.dataRef);
      this.keyName = info.node.dataRef.title
    },
    queryDepartTree() {
      getAction(this.url.villageTree).then(res => {
        if (res.success) {
          if(!!res.result && res.result.length > 0){
            for(var i = 0;i<res.result.length;i++){
              res.result[i].disabled = true;
            }
          }
          this.treeData = res.result
        }
      })
    },
    onLoadData(treeNode) {
      return new Promise(resolve => {
        console.log(treeNode)
        let params = {}
        if (treeNode.dataRef.children) {
          resolve()
          return
        }
        if (treeNode && treeNode.dataRef) {
          resolve()
          params.id = treeNode.dataRef.key
          params.type = treeNode.dataRef.type
          console.log(JSON.stringify(params))
        }
        getAction(this.url.villageTree, params).then(res => {
          console.log(JSON.stringify(res))
          if (res.success) {
            if(params.type == 'village' && !!res.result && res.result.length > 0){
              for(var i = 0;i<res.result.length;i++){
                res.result[i].disabled = true;
              }
            }
            if(params.type == 'building' && !!res.result && res.result.length > 0){
              for(var i = 0;i<res.result.length;i++){
                res.result[i].isLeaf = true;
              }
            }
            console.log(treeNode)
            treeNode.dataRef.children = res.result
            this.treeData = [...this.treeData]
            resolve()
          }
        })
      })
    },
    modalFormOk() {}
  }
}
</script>

<style scoped>
.ant-table-tbody .ant-table-row td {
  padding-top: 10px;
  padding-bottom: 10px;
}
</style>