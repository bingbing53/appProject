<template>
  <a-row :gutter="10">
    <a-col :md="leftColMd" :sm="24" style="margin-bottom: 20px">
      <a-card :bordered="false">
        <!-- 查询区域 -->
        <div class="table-page-search-wrapper">
          <a-form layout="inline">
            <a-row :gutter="24">
              <a-col :md="6" :sm="8">
                <a-form-item label="所属设备型号">
                  <!--<a-input placeholder="请输入所属设备型号" v-model="queryParam.manuModelId"></a-input>-->
                  <j-dict-select-tag
                    v-model="queryParam.manuModelId"
                    placeholder="请选择设备型号"
                    dictCode="d_manu_model,name,id"
                  />
                </a-form-item>
              </a-col>
              <a-col :md="6" :sm="8">
                <a-form-item label="设备名称">
                  <a-input placeholder="请输入设备名称" v-model="queryParam.name"></a-input>
                </a-form-item>
              </a-col>
              <template v-if="toggleSearchStatus">
                <a-col :md="6" :sm="8">
                  <a-form-item label="设备编码">
                    <a-input placeholder="请输入设备编码" v-model="queryParam.code"></a-input>
                  </a-form-item>
                </a-col>
                <!--<a-col :md="6" :sm="8">
            <a-form-item label="状态（0离线 1在线）">
              <a-input placeholder="请输入状态（0离线 1在线）" v-model="queryParam.state"></a-input>
            </a-form-item>
                </a-col>-->
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
          <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
          <a-button type="primary" icon="download" @click="handleExportXls('设备列表')">导出</a-button>
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
          <a-dropdown v-if="selectedRowKeys.length > 0">
            <a-menu slot="overlay">
              <a-menu-item key="1" @click="batchDel">
                <a-icon type="delete" />删除
              </a-menu-item>
            </a-menu>
            <a-button style="margin-left: 8px">
              批量操作
              <a-icon type="down" />
            </a-button>
          </a-dropdown>
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
            :dataSource="dataSource"
            :pagination="ipagination"
            :loading="loading"
            :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
            @change="handleTableChange"
          >
            <span slot="action" slot-scope="text, record">
              <a @click="handleEdit(record)">编辑</a>

              <a-divider type="vertical" />
              <a-dropdown>
                <a class="ant-dropdown-link">
                  更多
                  <a-icon type="down" />
                </a>
                <a-menu slot="overlay">
                  <a-menu-item>
                    <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.id)">
                      <a>删除</a>
                    </a-popconfirm>
                  </a-menu-item>
                  <a-menu-item key="2" @click="distributionProperty(record)">分配物业</a-menu-item>
                  <a-menu-item key="3" @click="paramDeploy(record.id)">参数配置</a-menu-item>
                </a-menu>
              </a-dropdown>
            </span>
          </a-table>
        </div>
        <!-- table区域-end -->

        <!-- 表单区域 -->
        <device-modal ref="modalForm" @ok="modalFormOk"></device-modal>
        <device-Config ref="DeviceConfig"></device-Config>
      </a-card>
    </a-col>
    <a-col :md="rightColMd" :sm="24">
      <a-card :bordered="false">
     
        <!-- table区域-begin -->
        <div>
          <a-table
            style="height:500px"
            ref="table2"
            bordered
            size="middle"
            rowKey="id"
            :columns="columns2"
            :dataSource="dataSource2"
            :loading="loading2"
          >
            <span slot="action" slot-scope="text, record">
              <a @click="alloction(record)">分配设备</a>
            </span>
          </a-table>
        </div>
        <!-- 表单区域 -->
        <!-- <role-modal ref="modalForm" @ok="modalFormOk"></role-modal>
        <user-modal ref="modalForm2" @ok="modalFormOk2"></user-modal>
        <Select-User-Modal ref="selectUserModal" @selectFinished="selectOK"></Select-User-Modal>-->
      </a-card>
    </a-col>
  </a-row>
</template>

<script>
import DeviceModal from './modules/DeviceModal'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import DeviceConfig from './modules/DeviceConfigModal'
import { getpropertyList,toalloction} from '@/api/api'

export default {
  name: 'DeviceList',
  mixins: [JeecgListMixin],
  components: {
    DeviceModal,
    DeviceConfig
  },
  data() {
    return {
      description: '设备列表管理页面',
      model1: {},
      model2: {},
      currentRoleId: '',
      queryParam1: {},
      queryParam2: {},
      dataSource1: [],
      dataSource2: [],
    
      isorter1: {
        column: 'createTime',
        order: 'desc'
      },
      isorter2: {
        column: 'createTime',
        order: 'desc'
      },
      filters1: {},
      filters2: {},
      loading1: false,
      loading2: false,
      selectedRowKeys1: [],
      selectedRowKeys2: [],
      selectionRows1: [],
      selectionRows2: [],
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
          title: '设备型号',
          align: 'center',
          dataIndex: 'manuModelName'
        },
        {
          title: '设备名称',
          align: 'center',
          dataIndex: 'name'
        },
        {
          title: '设备编码',
          align: 'center',
          dataIndex: 'code'
        },
        {
          title: '状态',
          align: 'center',
          dataIndex: 'state_dictText'
        },
        {
          title: '所属物业',
          align: 'center',
          dataIndex: 'sysOrgCodeName'
        },
        {
          title: '门禁分配',
          align: 'center',
          dataIndex: 'relateName'
        },
        {
          title: '操作',
          dataIndex: 'action',
          align: 'center',
          scopedSlots: { customRender: 'action' }
        }
      ],
      columns2: [
        {
          title: '物业名称',
          align: 'center',
          dataIndex: 'departName',
          width: 120
        },
        {
          title: '操作',
          dataIndex: 'action',
          scopedSlots: { customRender: 'action' },
          align: 'center',
          width: 120
        }
      ],

      url: {
        list: '/device/device/list',
        delete: '/device/device/delete',
        deleteBatch: '/device/device/deleteBatch',
        exportXlsUrl: 'device/device/exportXls',
        importExcelUrl: 'device/device/importExcel'
      },
      selectId:'',

    }
  },
  computed: {
    importExcelUrl: function() {
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`
    },
    leftColMd() {
      return this.selectedRowKeys1.length === 0 ? 24 : 16
    },
    rightColMd() {
      return this.selectedRowKeys1.length === 0 ? 0 : 8
    }
  },

  methods: {
    paramDeploy(id) {
      this.$refs.DeviceConfig.open()
      this.$refs.DeviceConfig.getMain(id)
    },
    distributionProperty(record) {
      this.selectedRowKeys1 = [record.id]
      this.model1 = Object.assign({}, record)
      this.currentRoleId = record.id
      this.onClearSelected2()
      this.loadData2();
      this.selectId = record.id;
    },
    //分配设备给物业
    alloction(record){
      let param ={id:this.selectId,sysOrgCode:record.orgCode}
      toalloction(param).then(res =>{
        console.log(res);
        if(res.success)
        this.$message.success("操作成功")

      })
    },
    onSelectChange2(selectedRowKeys, selectionRows) {
      this.selectedRowKeys2 = selectedRowKeys
      this.selectionRows2 = selectionRows
    },
    onClearSelected2() {
      this.selectedRowKeys2 = []
      this.selectionRows2 = []
    },
 
    modalFormOk2() {
      // 新增/修改 成功时，重载列表
      this.loadData2()
    },
    loadData2(arg) {
     

      //加载数据 若传入参数1则加载第一页的内容
      if (arg === 1) {
        this.ipagination2.current = 1
      }
      if (this.currentRoleId === '') return

      this.loading2 = true
      let param = { type: 1 }
      getpropertyList(param).then(res => {
        console.log(res)
        if (res.success) {
          this.dataSource2 = res.result
        }
        this.loading2 = false
      })
    },

  
    searchQuery2() {
      this.loadData2(1)
    },
    searchReset2() {
      this.queryParam2 = {}
      this.loadData2(1)
    },
   
  },
 
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>