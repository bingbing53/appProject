<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline">
        <a-row :gutter="24">
          <a-col :md="12" :sm="12">
                <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
                  <!--<a-button type="primary" @click="searchQuery" icon="search">查询</a-button>-->
                  <a-button
                    type="primary"
                    @click="searchReset"
                    icon="reload"
                    style="margin-left: 8px"
                  >刷新</a-button>
                </span>
          </a-col>
        </a-row>
      </a-form>
    </div>

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <!-- <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button> -->
      <!--<a-button type="primary" icon="download" @click="handleExportXls('问题反馈')">导出</a-button>-->
      <a-upload
        name="file"
        :showUploadList="false"
        :multiple="false"
        :headers="tokenHeader"
        :action="importExcelUrl"
        @change="handleImportExcel"
      >
        <!--<a-button type="primary" icon="import">导入</a-button>-->
      </a-upload>
      <!-- <a-dropdown v-if="selectedRowKeys.length > 0">
        <a-menu slot="overlay">
          <a-menu-item key="1" @click="batchDel">
            <a-icon type="delete" />删除
          </a-menu-item>
        </a-menu>
        <a-button style="margin-left: 8px">
          批量操作
          <a-icon type="down" />
        </a-button>
      </a-dropdown> -->
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
        <span slot="relateName" slot-scope="text, record">
          <span  v-if="!!record.uuid">{{record.relateName}}</span>
          <a-tag color="green" v-else>待分配</a-tag>
        </span>
        <span slot="state" slot-scope="text, record">
          <a-tag color="green" v-if="record.state == '1'">在线</a-tag>
          <a-tag color="red" v-if="record.state == '0'">离线</a-tag>
        </span>
        <span slot="action" slot-scope="text, record">
          <a style="margin-right: 8px" @click="doorAuth(record)">门禁权限</a>
          <a @click="deviceTreeShow(record)">分配</a>
        </span>
      </a-table>
    </div>
    <!-- table区域-end -->

    <device-tree-window ref="deviceTreeWindow" @ok="modalFormOk"></device-tree-window>

  </a-card>
</template>

<script>
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import { deleteAction,postAction } from '@/api/manage'
import DeviceTreeWindow from "./modules/DeviceTreeWindow";


export default {
  name: 'FeedbackList',
  mixins: [JeecgListMixin],
  components: {
    DeviceTreeWindow
  },
  data() {
    return {
      refKeys: ['DeviceHandle'],
      description: '设备管理页面',
      selectedRow:{},
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
          title: '安装位置',
          align: 'center',
          dataIndex: 'relateName',
          scopedSlots: { customRender: 'relateName' }
        },
        {
          title: '设备名称',
          align: 'center',
          dataIndex: 'name'
        },
        {
          title: '设备状态',
          align: 'center',
          dataIndex: 'state',
          scopedSlots: { customRender: 'state' }
        },
        {
          title: '操作',
          dataIndex: 'action',
          align: 'center',
          scopedSlots: { customRender: 'action' }
        }
      ],
      //操作url
      type: 'radio',
      url: {
        list: '/device/queryMineOrgDevice',
        delete: '/serve/feedback/delete',
        deleteBatch: '/serve/feedback/deleteBatch',
        exportXlsUrl: 'serve/feedback/exportXls',
        importExcelUrl: 'serve/feedback/importExcel',
        divideDeviceUrl:'/device/divideDevice/'
      }
    }
  },

  computed: {
    importExcelUrl: function() {
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`
    }
  },
  methods: {
    doorAuth(record){

    },
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
      // this.$refs.FeedHandleList.getMain(this.selectedRowKeys[0])
      // this.$refs.FeedHandleList.showDrawer()
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
    deviceTreeShow(record){
      this.selectedRow = record;
      this.$refs.deviceTreeWindow.add()
    },
    modalFormOk(formData) {
      this.buindDevice(formData,'0');
    },
    buindDevice(formData,confirm){
      let that = this;
      let param = {
        deviceCode:this.selectedRow.id,
        deviceType:formData.keyName == 'unit'?'1':'0',
        uuid:formData.keyValue
      };
      postAction(this.url.divideDeviceUrl+confirm,param).then(res=>{
          if(res.success){
              this.$message.success('分配成功');
              this.searchReset();
          }else if(res.code == 400){
            this.$confirm({
              title: '覆盖设备绑定操作提醒?',
              content: res.message,
              okText: '确定覆盖',
              okType: 'danger',
              cancelText: '取消操作',
              onOk() {
                that.buindDevice(formData,'1');
              },
              onCancel() {

              },
            });
          }else{
            this.$message.warning(res.message);
          }
      });
    }
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>