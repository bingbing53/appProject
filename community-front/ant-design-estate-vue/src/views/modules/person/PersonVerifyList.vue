<template>
  <a-card :bordered="false">

    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline">
        <a-row :gutter="24">

          <a-col :md="6" :sm="8">
            <a-form-item label="审核状态">
              <a-select placeholder="审核状态" v-model="queryParam.state">
                <a-select-option value="0">待审核</a-select-option>
                <a-select-option value="1">审核通过</a-select-option>
                <a-select-option value="2">不通过</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :md="6" :sm="8">
            <a-form-item label="居住类型">
              <a-select placeholder="居住类型" v-model="queryParam.liveType">
                <a-select-option value="0">租住</a-select-option>
                <a-select-option value="1">自住</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :md="6" :sm="8" >
            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>

    <!-- 操作按钮区域 -->
    <!--<div class="table-operator">-->
      <!--<a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>-->
      <!--<a-button type="primary" icon="download" @click="handleExportXls('居民审核')">导出</a-button>-->
      <!--<a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">-->
        <!--<a-button type="primary" icon="import">导入</a-button>-->
      <!--</a-upload>-->
      <!--<a-dropdown v-if="selectedRowKeys.length > 0">-->
        <!--<a-menu slot="overlay">-->
          <!--<a-menu-item key="1" @click="batchDel"><a-icon type="delete"/>删除</a-menu-item>-->
        <!--</a-menu>-->
        <!--<a-button style="margin-left: 8px"> 批量操作 <a-icon type="down" /></a-button>-->
      <!--</a-dropdown>-->
    <!--</div>-->

    <!-- table区域-begin -->
    <div>
      <!--<div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">-->
        <!--<i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项-->
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
        :customRow="clickThenCheck"
        @change="handleTableChange">

        <span slot="state" slot-scope="text, record">
          <a-tag color="green" v-if="record.state == '1'">审核通过</a-tag>
          <a-tag color="gray" v-if="record.state == '0'">待审核</a-tag>
          <a-tag color="red" v-if="record.state == '2'">未通过</a-tag>
        </span>
        <span slot="liveType" slot-scope="text, record">
          <a-tag color="green" v-if="record.liveType == '0'">自住</a-tag>
          <a-tag color="green" v-if="record.liveType == '1'">租住</a-tag>
        </span>

        <span slot="action" slot-scope="text, record">
          <!--<a @click="handleEdit(record)">编辑</a>-->
          <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.id)">
                  <a>删除</a>
          </a-popconfirm>
        </span>
      </a-table>
    </div>
    <!-- table区域-end -->

    <!-- 表单区域 -->
    <personVerify-modal ref="modalForm" @ok="modalFormOk"></personVerify-modal>
  </a-card>
</template>

<script>
  import PersonVerifyModal from './modules/PersonVerifyModal'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'

  export default {
    name: "PersonVerifyList",
    mixins:[JeecgListMixin],
    components: {
      PersonVerifyModal
    },
    data () {
      return {
        description: '居民审核管理页面',
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
            title: '姓名',
            align:"center",
            dataIndex: 'realname'
           },
          {
            title: '手机号',
            align:"center",
            dataIndex: 'mobile'
          },
          {
            title: '居住地址',
            align:"center",
            dataIndex: 'address'
          },
		      {
            title: '居住户型',
            align:"center",
            dataIndex: 'houseType_dictText'
           },
          {
            title: '住房面积',
            align:"center",
            dataIndex: 'space'
          },
          {
            title: '居住类型',
            align: "center",
            dataIndex: 'liveType',
            scopedSlots: { customRender: 'liveType' },
          },
          {
            title: '申请状态',
            align:"center",
            dataIndex: 'state',
            scopedSlots: { customRender: 'state' },
          },
          {
            title: '申请时间',
            align:"center",
            dataIndex: 'createTime'
          },
          // {
          //   title: '操作',
          //   dataIndex: 'action',
          //   align:"center",
          //   scopedSlots: { customRender: 'action' },
          // }
        ],
		url: {
          list: "/person/personVerify/list",
          delete: "/person/personVerify/delete",
          deleteBatch: "/person/personVerify/deleteBatch",
          exportXlsUrl: "person/personVerify/exportXls",
          importExcelUrl: "person/personVerify/importExcel",
       },
    }
  },
  computed: {
    importExcelUrl: function(){
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
    }
  },
    methods: {
      clickThenCheck(record) {
        return {
          on: {
            click: () => {
              this.onSelectChange([record.id], [record])
            }
          }
        }
      },
      onSelectChange(selectedRowKeys, selectionRows) {
        this.selectedRowKeys = selectedRowKeys
        this.selectionRows = selectionRows
        this.$refs.modalForm.edit(this.selectionRows[0])
        this.$refs.modalForm.visible = true;
        this.$refs.modalForm.title = '门禁权限审核';
      },
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less'
</style>