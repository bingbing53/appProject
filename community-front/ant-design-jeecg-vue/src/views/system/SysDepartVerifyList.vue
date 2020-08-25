<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline">
        <a-row :gutter="24">
          <a-col :md="6" :sm="8">
            <a-form-item label="部门类型">
              <a-input placeholder="请输入部门类型" v-model="queryParam.departType"></a-input>
            </a-form-item>
          </a-col>
          <a-col :md="6" :sm="8">
            <a-form-item label="真实姓名">
              <a-input placeholder="请输入真实姓名" v-model="queryParam.realname"></a-input>
            </a-form-item>
          </a-col>
          <template v-if="toggleSearchStatus">
            <a-col :md="6" :sm="8">
              <a-form-item label="手机号">
                <a-input placeholder="请输入手机号" v-model="queryParam.mobile"></a-input>
              </a-form-item>
            </a-col>
          </template>
          <a-col :md="6" :sm="8">
            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button
                type="primary"
                @click="searchReset"
                icon="reload"
                style="margin-left: 8px"
              >重置</a-button>
              <a @click="handleToggleSearch" style="margin-left: 8px">
                {{ toggleSearchStatus ? '收起' : '展开' }}
                <a-icon :type="toggleSearchStatus ? 'up' : 'down'" />
              </a>
            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-button type="primary" icon="download" @click="handleExportXls('注册审核列表')">导出</a-button>
      <a-upload
        name="file"
        :showUploadList="false"
        :multiple="false"
        :headers="tokenHeader"
        :action="importExcelUrl"
        @change="handleImportExcel"
      >
        <a-button type="primary" icon="import">导入</a-button>
      </a-upload>
    </div>

    <!-- table区域-begin -->
    <div>
      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择
        <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项
        <a style="margin-left: 24px" @click="onClearSelected">清空</a>
      </div>

      <a-table
        ref="table"
        size="middle"
        bordered
        rowKey="id"
        :columns="columns"
        :dataSource="formatData()"
        :pagination="ipagination"
        :loading="loading"
        :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
        @change="handleTableChange"
      >
        <span slot="action" slot-scope="text, record">
          <a @click="handleEdit(record)">详情</a>
        </span>
      </a-table>
    </div>
    <!-- table区域-end -->

    <!-- 表单区域 -->
    <sysDepartVerify-modal ref="modalForm" @ok="modalFormOk" @load="searchQuery"></sysDepartVerify-modal>
  </a-card>
</template>

<script>
import SysDepartVerifyModal from './modules/SysDepartVerifyModal'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'

export default {
  name: 'SysDepartVerifyList',
  mixins: [JeecgListMixin],
  components: {
    SysDepartVerifyModal
  },
  data() {
    return {
      description: '注册审核列表管理页面',
      // 表头
      columns: [
        {
          title: '#',
          dataIndex: '',
          key: 'rowIndex',
          width: 60,
          align: 'center',
          customRender: function(t, r, index) {
            return parseInt(index) + 1
          }
        },
        {
          title: '部门类型',
          align: 'center',
          dataIndex: 'departType'
        },
        {
          title: '部门名称',
          align: 'center',
          dataIndex: 'departName'
        },
        {
          title: '姓名',
          align: 'center',
          dataIndex: 'realname'
        },
        {
          title: '手机号',
          align: 'center',
          dataIndex: 'mobile'
        },
        {
          title: '状态',
          align: 'center',
          dataIndex: 'status'
        },
        {
          title: '申请时间',
          align: 'center',
          dataIndex: 'createTime'
        },
        // {
        //   title: '审核结论',
        //   align: 'center',
        //   dataIndex: 'reason'
        // },
        {
          title: '操作',
          dataIndex: 'action',
          align: 'center',
          scopedSlots: { customRender: 'action' }
        }
      ],
      url: {
        list: '/system/sysDepartVerify/list',
        delete: '/system/sysDepartVerify/delete',
        deleteBatch: '/system/sysDepartVerify/deleteBatch',
        exportXlsUrl: 'system/sysDepartVerify/exportXls',
        importExcelUrl: 'system/sysDepartVerify/importExcel'
      }
    }
  },
  computed: {
    importExcelUrl: function() {
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`
    }
  },
  methods: {
    formatData: function() {
      console.log(this.dataSource)
      this.dataSource.forEach((item, index) => {
        if (item.departType == '0') item.departType = '街乡居委会'
        if (item.departType == '1') item.departType = '物业'
        if (item.departType == '2') item.departType = '商户'
        if (item.departType == '4') item.departType = '社会组织'
        if (item.status == '0') item.status = '待审核'
        if (item.status == '1') item.status = '审核通过'
        if (item.status == '2') item.status = '未过审'
      })
      return this.dataSource
    }
  },

}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>