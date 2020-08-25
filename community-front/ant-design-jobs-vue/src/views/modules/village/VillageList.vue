<template>
<div>
  <a-row :gutter="24">
      <a-col :span="8">
        <a-card :bordered="false" style="width: 100%">
            <!-- 查询区域 -->
            <div class="table-page-search-wrapper">
              <a-form layout="inline">
                <a-row :gutter="24">
                  <a-col :md="12" :sm="24">
                    <a-form-item label="创建人名称">
                      <a-input placeholder="请输入创建人名称" v-model="queryParam.createName"></a-input>
                    </a-form-item>
                  </a-col>
                  <!-- <a-col :md="6" :sm="24">
                    <a-form-item label="更新人名称">
                      <a-input placeholder="请输入更新人名称" v-model="queryParam.updateName"></a-input>
                    </a-form-item>
                  </a-col> -->
                  <a-col :md="6" :sm="24">
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
              <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
              <a-button type="primary" icon="download" @click="handleExportXls('小区')">导出</a-button>
              <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">
                <a-button type="primary" icon="import">导入</a-button>
              </a-upload>
              <a-dropdown v-if="selectedRowKeys.length > 0">
                <a-menu slot="overlay">
                  <a-menu-item key="1" @click="batchDel">
                  <a-icon type="delete"/>删除
                  </a-menu-item>
                </a-menu>
                <a-button style="margin-left: 8px"> 批量操作 
                  <a-icon type="down" />
                </a-button>
              </a-dropdown>
            </div>

            <!-- table区域-begin -->
            <div>
              <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
                <i class="anticon anticon-info-circle ant-alert-icon"></i>
                <span>已选择</span>
                <a style="font-weight: 600">
                  {{ selectedRowKeys.length }}
                </a>
                <span>项</span>
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
                :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange,type:type}"
                @change="handleTableChange"
                :customRow="clickThenCheck"
                >

                <span slot="action" slot-scope="text, record">
                  <a @click="handleEdit(record)">编辑</a>

                  <a-divider type="vertical" />
                  <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.id)">
                    <a>删除</a>
                  </a-popconfirm>
                </span>

              </a-table>
            </div>
            <!-- table区域-end -->
        </a-card>  
      </a-col>
       <a-col :span="16">
        <a-card :bordered="false" style="width:100%">
          <a-tabs defaultActiveKey="1">
            <a-tab-pane tab="楼宇" :key="refKeys[0]" :forceRender="true">
              <building-List ref="BuildingList"></building-List>
            </a-tab-pane>
          </a-tabs>

          <!-- 表单区域 -->
          <village-modal ref="modalForm" @ok="modalFormOk"/>

        </a-card>
       </a-col>
  </a-row>
  </div>
</template>

<script>
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import VillageModal from './modules/VillageModal'
  import {deleteAction} from '@/api/manage'
  import BuildingList from './BuildingList'
  import BuildingModal from './modules/BuildingModal'


  export default {
    name: "VillageList",
    mixins: [JeecgListMixin],
    components: {
      VillageModal,
      BuildingModal,
      BuildingList
    },
    data () {
      return {
        refKeys: ['building', ],
        description: '小区管理页面',
        // 表头
        columns: [
          {
            title: '小区名称',
            align:"center",
            width: 200,
            dataIndex: 'villageName'
          },
          {
            title: '操作',
            dataIndex: 'action',
            align:"center",
            scopedSlots: { customRender: 'action' },
            fixed: 'right',
            width: 130,
          }
        ],
 
        //操作url
        type: "radio",
        url: {
          list: "/village/village/list",
          delete: "/village/village/delete",
          deleteBatch: "/village/village/deleteBatch",
          exportXlsUrl: "village/village/exportXls",
          importExcelUrl: "village/village/importExcel",
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
      console.log("record:"+JSON.stringify(record))
        return {
          on: {
            click: () => {
              this.onSelectChange(record.id.split(","), [record]);
            }
          }
        };
      },
      onSelectChange(selectedRowKeys, selectionRows) {
        console.log(selectionRows);
        this.selectedRowKeys = selectedRowKeys;
        this.selectionRows = selectionRows;
        this.$refs.BuildingList.getMain(this.selectedRowKeys[0]);
      },
      onClearSelected() {
        this.selectedRowKeys = [];
        this.selectionRows = [];
        this.$refs.BuildingList.queryParam.mainId = null;
        this.$refs.BuildingList.loadData();
        this.$refs.BuildingList.selectedRowKeys = [];
        this.$refs.BuildingList.selectionRows = [];
      },

      handleDelete: function (id) {
        var that = this;
        deleteAction(that.url.delete, {id: id}).then((res) => {
          if (res.success) {
            that.$message.success(res.message);
            that.loadData();
            this.$refs.BuildingList.loadData();
          } else {
            that.$message.warning(res.message);
          }
        });
      },
      searchQuery:function(){
        this.selectedRowKeys = [];
        this.selectionRows = [];
        this.$refs.BuildingList.queryParam.mainId = null;
        this.$refs.BuildingList.loadData();
        this.$refs.BuildingList.selectedRowKeys = [];
        this.$refs.BuildingList.selectionRows = [];
        this.loadData();
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
.ant-table{
  table-layout: fixed;
}
</style>