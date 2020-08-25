<template>
  <a-modal
    :width="1200"
    :visible="visible"
    style="top:0px;"
    :bodyStyle="bodyStyle"
    title="选择房屋"
    :confirmLoading="confirmLoading"
    :maskClosable="false"
    @ok="handleSubmit"
    @cancel="handleCancel"
    cancelText="关闭"
    wrapClassName="ant-modal-cust-warp"
  >
    <choise-house-list ref="choiseHouseList"></choise-house-list>
  </a-modal>
</template>
<script>
//引入房屋管理组件
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import ChoiseHouseList from "../ChoiseHouseList";
export default {
  name: 'personAddress',
  mixins: [JeecgListMixin],
  data() {
    return {
      bodyStyle:{
        padding: "0",
        maxHeight:(window.innerHeight-100)+"px"
      },
      visible: false,
      confirmLoading: false,
    }
  },
  components: {
    ChoiseHouseList,
  },
  methods: {
    add(param) {
      this.visible = true
    },
    close() {
      this.visible = false
    },
    handleCancel() {
      this.close()
    },
    handleSubmit() {
      console.log(this.$refs.choiseHouseList.selectedRowKeys)
      console.log(JSON.stringify(this.$refs.choiseHouseList.selectionRows))
      this.$emit('rowData', this.$refs.choiseHouseList.selectionRows, this.$refs.choiseHouseList.selectedRowKeys)
      this.close();
      this.$refs.choiseHouseList.selectedRowKeys = [];
      this.$refs.choiseHouseList.selectionRows = [];
    }
  },
  mounted() {}
}
</script>
<style scoped>
</style>