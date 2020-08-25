<template>
  <a-card :bordered="false">

    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline">
        <a-row :gutter="24">

          <a-col :md="8" :sm="8">
            <a-form-item label="提现申请编号">
              <a-input placeholder="申请编号" v-model="queryParam.sn"></a-input>
            </a-form-item>
          </a-col>
          <a-col :md="8" :sm="8">
            <a-form-item label="审核状态">
              <a-select placeholder="请选择审核状态"  v-model="queryParam.status">
                <a-select-option value="0">待审核</a-select-option>
                <a-select-option value="2">已通过</a-select-option>
                <a-select-option value="3">已驳回</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :md="8" :sm="8" >
            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-dropdown v-if="selectedRowKeys.length > 0">
        <a-menu slot="overlay">
          <a-menu-item key="1" @click="batchDel"><a-icon type="delete"/>删除</a-menu-item>
        </a-menu>
        <a-button style="margin-left: 8px"> 批量操作 <a-icon type="down" /></a-button>
      </a-dropdown>
    </div>

    <!-- table区域-begin -->
    <div>
      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项
        <a style="margin-left: 24px" @click="onClearSelected">清空</a>
      </div>

      <a-table
        ref="table"
        size="middle"
        bordered
        rowKey="id"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
        @change="handleTableChange">

        <span slot="status" slot-scope="text, record">
          <a-tag v-if="record.status == '0'" color="orange">待审核</a-tag>
          <a-tag v-if="record.status == '3'" color="red">已驳回</a-tag>
          <a-tag v-if="record.status == '2'" color="green">已通过</a-tag>
        </span>

        <span slot="action" slot-scope="text, record">
          <a @click="handleEdit(record)">审核</a>
        </span>
      </a-table>
    </div>
    <!-- table区域-end -->

    <!-- 表单区域 -->
    <shopAccountWithdrawCashHistory-modal ref="modalForm" @ok="modalFormOk"></shopAccountWithdrawCashHistory-modal>
  </a-card>
</template>

<script>
  import ShopAccountWithdrawCashHistoryModal from './modules/ShopAccountWithdrawCashHistoryModal'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'

  export default {
    name: "ShopAccountWithdrawCashHistoryList",
    mixins:[JeecgListMixin],
    components: {
      ShopAccountWithdrawCashHistoryModal
    },
    data () {
      return {
        description: '商家提现申请管理页面',
        // 表头
        columns: [
          // {
          //   title: '#',
          //   dataIndex: '',
          //   key:'rowIndex',
          //   width:60,
          //   align:"center",
          //   customRender:function (t,r,index) {
          //     return parseInt(index)+1;
          //   }
          //  },
		   {
            title: '编号',
            align:"center",
            dataIndex: 'sn'
           },
		   {
            title: '提现金额',
            align:"center",
            dataIndex: 'amount'
           },
		   {
            title: '账户号码',
            align:"center",
            dataIndex: 'bankAccount'
           },
		   {
            title: '账户名',
            align:"center",
            dataIndex: 'bankAccountName'
           },
		   {
            title: '开户行',
            align:"center",
            dataIndex: 'bank'
           },
		   // {
       //      title: '操作人员',
       //      align:"center",
       //      dataIndex: 'operateMan'
       //     },
		   // {
       //      title: '备注',
       //      align:"center",
       //      dataIndex: 'operateNote'
       //     },
		   {
            title: '状态',
            align:"center",
            dataIndex: 'status',
            scopedSlots: { customRender: 'status' },
           },
		   {
            title: '驳回原因',
            align:"center",
            dataIndex: 'rejectReason'
           },
		   // {
       //      title: '所属公司',
       //      align:"center",
       //      dataIndex: 'sysCompanyCode'
       //     },
		   {
            title: '操作时间',
            align:"center",
            dataIndex: 'operateTime'
           },
          {
            title: '操作',
            dataIndex: 'action',
            align:"center",
            scopedSlots: { customRender: 'action' },
          }
        ],
		url: {
          list: "/mall/shopAccountWithdrawCashHistory/list",
          delete: "/mall/shopAccountWithdrawCashHistory/delete",
          deleteBatch: "/mall/shopAccountWithdrawCashHistory/deleteBatch",
          exportXlsUrl: "mall/shopAccountWithdrawCashHistory/exportXls",
          importExcelUrl: "mall/shopAccountWithdrawCashHistory/importExcel",
       },
    }
  },
  computed: {
    importExcelUrl: function(){
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
    }
  },
    methods: {
     
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less'
</style>