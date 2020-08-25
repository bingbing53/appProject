/**
 * 资产管理对应的右侧弹出表格
 * 新增修改完成调用 modalFormOk方法 编辑弹框组件ref定义为modalForm
 * 高级查询按钮调用 superQuery方法  高级查询组件ref定义为superQueryModal
 * data中url定义 list为查询列表  delete为删除单条记录  deleteBatch为批量删除
 */
import Vue from 'vue'
import { ACCESS_TOKEN } from "@/store/mutation-types"

export const propertyListMixin = {
    data(){
        return{
            tokenHeader: {'X-Access-Token': Vue.ls.get(ACCESS_TOKEN)},

        }
    },
    methods:{
        handleEdit: function (record) {
            this.$refs.modalForm.edit(record);
            this.$refs.modalForm.title = "编辑";
            this.$refs.modalForm.disableSubmit = false;
          },
    }
}