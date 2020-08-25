<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline">
        <a-row :gutter="24">
          <a-col :md="6" :sm="24">
            <a-form-item label="用户名">
              <a-input placeholder="请输入用户名" v-model="queryParam.userName"></a-input>
            </a-form-item>
          </a-col>
          <a-col :md="6" :sm="24">
            <a-form-item label="预约类型">
              <j-dict-select-tag
                v-model="queryParam.orderType"
                :triggerChange="true"
                placeholder="请选择预约类型"
                dictCode="worker_type"
              />
            </a-form-item>
          </a-col>
          <a-col :md="6" :sm="24">
            <a-form-item label="预约状态">
              <j-dict-select-tag
                v-model="queryParam.status"
                :triggerChange="true"
                placeholder="请选择预约状态"
                dictCode="esSerState"
              />
            </a-form-item>
          </a-col>
          <a-col :md="6" :sm="24">
            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button
                type="primary"
                @click="searchReset"
                icon="reload"
                style="margin-left: 8px"
              >重置</a-button>
            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>

    <!-- table区域-begin -->
    <div>
      <a-table
        ref="table"
        size="middle"
        bordered
        rowKey="id"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        @change="handleTableChange"
        :customRow="clickThenCheck"
      >
      </a-table>
    </div>
    <!-- table区域-end -->

    <!--<a-tabs defaultActiveKey="1">
      <a-tab-pane tab="服务处理流程" :key="refKeys[0]" :forceRender="true">
        <orderState-List ref="OrderStateList"></orderState-List>
      </a-tab-pane>
    </a-tabs>-->


    <order-modal ref="modalForm" @ok="modalFormOk" />
  </a-card>
</template>

<script>
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import OrderModal from './modules/OrderModal'
import { deleteAction } from '@/api/manage'
import OrderStateList from './OrderStateList'
import OrderStateModal from './modules/OrderStateModal'

export default {
  name: 'OrderList',
  mixins: [JeecgListMixin],
  components: {
    OrderModal,
    OrderStateModal,
    OrderStateList
  },
  data() {
    return {
      refKeys: ['orderState'],
      description: '服务预约管理页面',
      // 表头
      columns: [
        // {
        //   title: '#',
        //   dataIndex: '',
        //   key: 'rowIndex',
        //   width: 60,
        //   align: "center",
        //   customRender:function (t, r, index) {
        //     return parseInt(index)+1;
        //   }
        // },
        {
          title: '预约类型',
          align: 'center',
          dataIndex: 'orderType_dictText'
        },

        {
          title: '用户名',
          align: 'center',
          dataIndex: 'userName'
        },
        {
          title: '手机号',
          align: 'center',
          dataIndex: 'userMobile'
        },

        {
          title: '评分',
          align: 'center',
          dataIndex: 'judge'
        },
        {
          title: '评价',
          align: 'center',
          dataIndex: 'judgeContent'
        },
        {
          title: '服务状态',
          align: 'center',
          dataIndex: 'status_dictText'
        },

        {
          title: '预约服务时间',
          align: 'center',
          dataIndex: 'orderServiceDate'
        }
      ],

      //操作url
      type: 'radio',
      url: {
        list: '/serve/order/list',
        delete: '/serve/order/delete',
        deleteBatch: '/serve/order/deleteBatch',
        exportXlsUrl: 'serve/order/exportXls',
        importExcelUrl: 'serve/order/importExcel',
      }
    }
  },
  computed: {
    importExcelUrl: function() {
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`
    }
  },
  methods: {
    clickThenCheck(record) {
      return {
        on: {
          click: () => {
            this.onSelectChange(record.id.split(','), [record])
          }
        }
      }
    },
    onSelectChange(selectedRowKeys, selectionRows) {
      this.selectedRowKeys = selectedRowKeys
      this.selectionRows = selectionRows
      // this.$refs.OrderStateList.getMain(this.selectedRowKeys[0]);
      console.log(this.selectionRows[0])
       this.$refs.modalForm.edit(this.selectionRows[0])
       this.$refs.modalForm.getserveStep();
      this.$refs.modalForm.visible = true;
    },
    onClearSelected() {
      this.selectedRowKeys = []
      this.selectionRows = []
      this.$refs.OrderStateList.queryParam.mainId = null
      this.$refs.OrderStateList.loadData()
      this.$refs.OrderStateList.selectedRowKeys = []
      this.$refs.OrderStateList.selectionRows = []
    },

    handleDelete: function(id) {
      var that = this
      deleteAction(that.url.delete, { id: id }).then(res => {
        if (res.success) {
          that.$message.success(res.message)
          that.loadData()
          this.$refs.OrderStateList.loadData()
        } else {
          that.$message.warning(res.message)
        }
      })
    },
    searchQuery: function() {
      this.selectedRowKeys = []
      this.selectionRows = []
      this.$refs.OrderStateList.queryParam.mainId = null
      this.$refs.OrderStateList.loadData()
      this.$refs.OrderStateList.selectedRowKeys = []
      this.$refs.OrderStateList.selectionRows = []
      this.loadData()
    }
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>