<template>
  <a-modal
    :width="modalWidth"
    :visible="addvisible"
    title="添加人员"
    :confirmLoading="confirmLoading"
    @ok="handleSubmit"
    @cancel="handleCancel"
    cancelText="关闭"
    wrapClassName="ant-modal-cust-warp"
  >
    <personInfo-List ref="PersonInfoList" :length='onesLength' :ids="selectId"></personInfo-List>
  </a-modal>
</template>
<script>
//引入居民基本信息组件
import PersonInfoList from './PersonInfoList'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
export default {
  name: 'addPerson',
  mixins: [JeecgListMixin],
  components: {
    PersonInfoList
  },
  data() {
    return {
      selectId:'',
      onesLength:'',
      title: '添加人员',
      addvisible: false,
      confirmLoading: false,
      modalWidth: 1200,
      listtable:false,
    }
  },
  methods: {
    add(param) {
          this.addvisible = true;
      if(param == 1){
        this.onesLength = 1; 
      }else{
        this.onesLength ='any'
      }
    },
    close() {
      this.addvisible = false
    },
    handleCancel() {
      this.close()
    },
    handleSubmit() {
     console.log(this.$refs.PersonInfoList.selectedRowKeys)
     console.log(JSON.stringify(this.$refs.PersonInfoList.selectionRows))
     if(this.onesLength == 1)
     this.$emit('rowDataown',this.$refs.PersonInfoList.selectionRows,this.$refs.PersonInfoList.selectedRowKeys)
      else
     this.$emit('rowData',this.$refs.PersonInfoList.selectionRows,this.$refs.PersonInfoList.selectedRowKeys)
     this.selectId = this.$refs.PersonInfoList.selectedRowKeys.join(',');
     this.close();
     this.$refs.PersonInfoList.selectedRowKeys =[];
     this.$refs.PersonInfoList.selectionRows=[];
    }
  },
  mounted() {
    
  }
}
</script>
<style scoped>
</style>