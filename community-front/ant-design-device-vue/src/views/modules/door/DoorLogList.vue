<template>
  <a-card :bordered="false">

    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline">
        <a-row :gutter="24">

          <a-col :md="6" :sm="8">
            <a-form-item label="app账户">
              <a-input placeholder="请输入app账户" v-model="queryParam.appAccount"></a-input>
            </a-form-item>
          </a-col>
          <a-col :md="6" :sm="8">
            <a-form-item label="设备序列号">
              <a-input placeholder="请输入设备序列号" v-model="queryParam.devSn"></a-input>
            </a-form-item>
          </a-col>
        <template v-if="toggleSearchStatus">
        <a-col :md="6" :sm="8">
            <a-form-item label="设备名称">
              <a-input placeholder="请输入设备名称" v-model="queryParam.devName"></a-input>
            </a-form-item>
          </a-col>
          <a-col :md="6" :sm="8">
            <a-form-item label="事件类型">
              <a-input placeholder="请输入事件类型" v-model="queryParam.eventType"></a-input>
            </a-form-item>
          </a-col>
          </template>
          <a-col :md="6" :sm="8" >
            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
              <a @click="handleToggleSearch" style="margin-left: 8px">
                {{ toggleSearchStatus ? '收起' : '展开' }}
                <a-icon :type="toggleSearchStatus ? 'up' : 'down'"/>
              </a>
            </span>
          </a-col>

        </a-row>
      </a-form>
    </div>

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <!--<a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>-->
      <!--<a-button type="primary" icon="download" @click="handleExportXls('开门记录')">导出</a-button>-->
      <!--<a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">
        <a-button type="primary" icon="import">导入</a-button>
      </a-upload>-->
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

        <span slot="imagePath" slot-scope="text, record">
          <img :src="formatPicture(record.imagePath)" width="50"/>
        </span>

        <span slot="action" slot-scope="text, record">
          <a @click="handleEdit(record)">编辑</a>

          <a-divider type="vertical" />
          <a-dropdown>
            <a class="ant-dropdown-link">更多 <a-icon type="down" /></a>
            <a-menu slot="overlay">
              <a-menu-item>
                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.id)">
                  <a>删除</a>
                </a-popconfirm>
              </a-menu-item>
            </a-menu>
          </a-dropdown>
        </span>

      </a-table>
    </div>
    <!-- table区域-end -->

    <!-- 表单区域 -->
    <doorLog-modal ref="modalForm" @ok="modalFormOk"></doorLog-modal>
  </a-card>
</template>

<script>
  import DoorLogModal from './modules/DoorLogModal'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'

  export default {
    name: "DoorLogList",
    mixins:[JeecgListMixin],
    components: {
      DoorLogModal
    },
    data () {
      return {
        description: '开门记录管理页面',
        // 表头
        columns: [
          {
            title: '#',
            dataIndex: '',
            key:'rowIndex',
            width:60,
            align:"center",
            customRender:function (t,r,index) {
              return parseInt(index)+1;
            }
           },
		   // {
       //      title: 'app账户',
       //      align:"center",
       //      dataIndex: 'appAccount'
       //     },
          {
            title: '姓名',
            align:"center",
            dataIndex: 'personName'
          },
		   // {
       //      title: '设备序列号',
       //      align:"center",
       //      dataIndex: 'devSn'
       //     },
		   {
            title: '设备名称',
            align:"center",
            dataIndex: 'devName'
           },
		   {
            title: '开门类型',
            align:"center",
            dataIndex: 'eventType_dictText'
           },
		   {
            title: '抓拍图片',
            align:"center",
            dataIndex: 'imagePath',
            scopedSlots: { customRender: 'imagePath' },
           },
		   // {
       //      title: '所属部门',
       //      align:"center",
       //      dataIndex: 'sysOrgCode'
       //     },
		   // {
       //      title: '所属地区',
       //      align:"center",
       //      dataIndex: 'areaCode'
       //     },
          {
            title: '识别年龄',
            align:"center",
            dataIndex: 'faceAge'
          },
          {
            title: '体温（℃）',
            align:"center",
            dataIndex: 'bodyTemperature'
          },
          {
            title:'开门时间',
            align:"center",
            dataIndex:'createTime'
          },
          {
            title: '操作',
            dataIndex: 'action',
            align:"center",
            scopedSlots: { customRender: 'action' },
          }
        ],
		url: {
          list: "/door/doorLog/list",
          delete: "/door/doorLog/delete",
          deleteBatch: "/door/doorLog/deleteBatch",
          exportXlsUrl: "door/doorLog/exportXls",
          importExcelUrl: "door/doorLog/importExcel",
       },
    }
  },
  computed: {
    importExcelUrl: function(){
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
    }
  },
    methods: {
      formatPicture(pic){
        return window._CONFIG['imageViewURL']+'/'+pic;
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less'
</style>