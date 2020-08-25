<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline">
        <a-row :gutter="24">
          <a-col :md="6" :sm="24">
            <a-form-item label="反馈内容">
              <a-input placeholder="请输入反馈内容" v-model="queryParam.content"></a-input>
            </a-form-item>
          </a-col>
          <!--<a-col :md="6" :sm="24">-->
            <!--<a-form-item label="反馈图片">-->
              <!--<a-input placeholder="请输入反馈图片" v-model="queryParam.image"></a-input>-->
            <!--</a-form-item>-->
          <!--</a-col>-->
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

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <!-- <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button> -->
      <!--<a-button type="primary" icon="download" @click="handleExportXls('问题反馈')">导出</a-button>-->
      <!--<a-upload-->
        <!--name="file"-->
        <!--:showUploadList="false"-->
        <!--:multiple="false"-->
        <!--:headers="tokenHeader"-->
        <!--:action="importExcelUrl"-->
        <!--@change="handleImportExcel"-->
      <!--&gt;-->
        <!--<a-button type="primary" icon="import">导入</a-button>-->
      <!--</a-upload>-->
      <!--<a-dropdown v-if="selectedRowKeys.length > 0">
        <a-menu slot="overlay">
          <a-menu-item key="1" @click="batchDel">
            <a-icon type="delete" />删除
          </a-menu-item>
        </a-menu>
        <a-button style="margin-left: 8px">
          批量操作
          <a-icon type="down" />
        </a-button>
      </a-dropdown>-->
    </div>

    <!-- table区域-begin -->
    <div>
      <!--<div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">-->
        <!--<i class="anticon anticon-info-circle ant-alert-icon"></i>-->
        <!--<span>已选择</span>-->
        <!--<a style="font-weight: 600">{{ selectedRowKeys.length }}</a>-->
        <!--<span>项</span>-->
        <!--<a style="margin-left: 24px" @click="onClearSelected">清空</a>-->
      <!--</div>-->

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
        <p slot="expandedRowRender" slot-scope="record" style="margin: 0">
          反馈内容：{{record.content}}
        </p>
        <span slot="isHandle" slot-scope="text, record">
          <a-tag color="cyan" v-if="record.isHandle == '1'">已处理</a-tag>
          <a-tag color="red" v-if="record.isHandle == '0'">未处理</a-tag>
        </span>
        <!-- <span slot="action" slot-scope="text, record">
          <a @click="handleEdit(record)">编辑</a>
          <a-divider type="vertical" />
          <a @click="dealDetail(record)">处理详情</a>

          <a-divider type="vertical" />
          <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.id)">
            <a>删除</a>
          </a-popconfirm>
        </span> -->
      </a-table>
    </div>
    <!-- table区域-end -->

    <feedHandle-List ref="FeedHandleList" @ok="modalFormOk"></feedHandle-List>

    <!-- 表单区域 -->
    <feedback-modal ref="modalForm" @ok="modalFormOk" />
  </a-card>
</template>

<script>
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import FeedbackModal from './modules/FeedbackModal'
import { deleteAction } from '@/api/manage'
import FeedHandleList from './FeedHandleList'

import FeedHandleModal from './modules/FeedHandleModal'

export default {
  name: 'FeedbackList',
  mixins: [JeecgListMixin],
  components: {
    FeedbackModal,
    FeedHandleModal,
    FeedHandleList
  },
  data() {
    return {
      refKeys: ['feedHandle'],
      description: '问题反馈管理页面',
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
          title: '反馈人',
          align: 'center',
          dataIndex: 'userName'
        },
        {
          title: '反馈人手机号',
          align: 'center',
          dataIndex: 'userMobile'
        },
        // {
        //   title: '反馈人地址',
        //   align: 'center',
        //   dataIndex: 'userMobile'
        // },
        {
          title: '反馈分类',
          align: 'center',
          dataIndex: 'feedType_dictText'
        },
        {
          title: '反馈时间',
          align: 'center',
          dataIndex: 'inDate'
        },
        {
          title: '是否处理',
          align: 'center',
          dataIndex: 'isHandle',
          scopedSlots: { customRender: 'isHandle' }
        },
        // {
        //   title: '操作',
        //   dataIndex: 'action',
        //   align: 'center',
        //   scopedSlots: { customRender: 'action' }
        // }
      ],

      //操作url
      type: 'radio',
      url: {
        list: '/serve/feedback/list',
        delete: '/serve/feedback/delete',
        deleteBatch: '/serve/feedback/deleteBatch',
        exportXlsUrl: 'serve/feedback/exportXls',
        importExcelUrl: 'serve/feedback/importExcel'
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
      this.$refs.FeedHandleList.getMain(this.selectedRowKeys[0])
      this.$refs.FeedHandleList.showDrawer()
    },
    onClearSelected() {
      this.selectedRowKeys = []
      this.selectionRows = []
      this.$refs.FeedHandleList.queryParam.mainId = null
      this.$refs.FeedHandleList.loadData()
      this.$refs.FeedHandleList.selectedRowKeys = []
      this.$refs.FeedHandleList.selectionRows = []
    },

    handleDelete: function(id) {
      var that = this
      deleteAction(that.url.delete, { id: id }).then(res => {
        if (res.success) {
          that.$message.success(res.message)
          that.loadData()
          this.$refs.FeedHandleList.loadData()
        } else {
          that.$message.warning(res.message)
        }
      })
    },
    searchQuery: function() {
      this.selectedRowKeys = []
      this.selectionRows = []
      this.$refs.FeedHandleList.queryParam.mainId = null
      this.$refs.FeedHandleList.loadData()
      this.$refs.FeedHandleList.selectedRowKeys = []
      this.$refs.FeedHandleList.selectionRows = []
      this.loadData()
    },
    modalFormOk(){
      this.loadData()
    }
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>