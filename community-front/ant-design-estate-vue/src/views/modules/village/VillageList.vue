<template>
<div>
  <!-- <a-row :gutter="24"> -->
      <!-- <a-col :span="8"> -->
        <a-card :bordered="false" style="width: 100%">
            <!-- 查询区域 -->
            <div class="table-page-search-wrapper">
              <a-form layout="inline">
                <a-row :gutter="24">
                  <a-col :md="7">
                    <a-form-item >
                      <a-input placeholder="请输入小区名称" v-model="queryParam.villageName"></a-input>
                    </a-form-item>
                  </a-col>
                  <a-col :md="6" :sm="8">
                    <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
                      <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
                      <a-button style="margin-left: 8px" @click="handleAdd" type="primary" icon="plus">新增</a-button>
                    </span>
                  </a-col>
                  <!--<a-col :md="3">-->
                    <!--<span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">-->
                      <!--<a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>-->
                    <!--</span>-->
                  <!--</a-col>-->
                </a-row>
              </a-form>
            </div>
            <!-- 操作按钮区域 -->
            <div class="table-operator">

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
                :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange,type:type}"
                @change="handleTableChange"
                :customRow="clickThenCheck"
                >

                <span slot="action" slot-scope="text, record">
                  <!--<a @click="handleEdit(record)">编辑</a>-->

                  <!--<a-divider type="vertical" />-->
                  <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.id)">
                    <a>删除</a>
                  </a-popconfirm>
                </span>

              </a-table>
            </div>
            <!-- table区域-end -->
        </a-card>  
      <!-- </a-col> -->
       <!-- <a-col :span="16"> -->
        <!-- <a-card :bordered="false" style="width:100%"> -->
          <!-- <building-List ref="BuildingList"></building-List> -->
          <!-- 表单区域 -->
          <village-modal ref="modalForm" @ok="modalFormOk"/>
        <!-- </a-card> -->
       <!-- </a-col> -->
  <!-- </a-row> -->
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
        description: '小区管理页面',
        // 表头
        columns: [
          {
            title: '所属社区',
            align:"center",
            dataIndex: 'areaCode_dictText'
          },
          {
            title: '小区名称',
            align:"center",
            dataIndex: 'villageName'
          },
          {
            title: '操作',
            dataIndex: 'action',
            align:"center",
            scopedSlots: { customRender: 'action' },
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
      modalFormOk() {
        this.loadData();
      },
		  clickThenCheck(record) {
        return {
          on: {
            click: () => {
              this.onSelectChange(record.id.split(","), [record]);
            }
          }
        };
      },
      onSelectChange(selectedRowKeys, selectionRows) {
        // console.log(selectionRows);
        this.selectedRowKeys = selectedRowKeys;
        this.selectionRows = selectionRows;
        this.$refs.BuildingList.getMain(this.selectedRowKeys[0],'village', this.selectionRows);
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
      // searchQuery:function(){
      //   this.selectedRowKeys = [];
      //   this.selectionRows = [];
      //   this.$refs.BuildingList.queryParam.mainId = null;
      //   this.$refs.BuildingList.loadData();
      //   this.$refs.BuildingList.selectedRowKeys = [];
      //   this.$refs.BuildingList.selectionRows = [];
      //   this.loadData();
      // }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
.ant-table{
  table-layout: fixed;
}
</style>