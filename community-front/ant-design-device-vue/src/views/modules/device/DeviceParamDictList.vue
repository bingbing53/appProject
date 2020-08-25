<template>
  <a-card :bordered="false">
    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>

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
            </a-menu>
          </a-dropdown>
        </span>
      </a-table>
    </div>
    <!-- table区域-end -->

    <!-- 表单区域 -->
    <deviceParamDict-modal ref="modalForm" :deviceName="deviceName" @ok="modalFormOk"></deviceParamDict-modal>
  </a-card>
</template>

<script>
import DeviceParamDictModal from './modules/DeviceParamDictModal'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import { deleteAction, getAction, downFile } from '@/api/manage'
export default {
  name: 'DeviceParamDictList',
  mixins: [JeecgListMixin],
  props: ['deviceName', 'idValue'],
  components: {
    DeviceParamDictModal
  },
  data() {
    return {
      description: '设备参数字典表管理页面',
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
          title: '参数名称',
          align: 'center',
          dataIndex: 'paramName'
        },
        {
          title: '参数编码',
          align: 'center',
          dataIndex: 'paramCode'
        },
        {
          title: '参数类型',
          align: 'center',
          dataIndex: 'paramType'
        },
         {
          title: '设备名称',
          align: 'center',
          dataIndex: 'equipmentName'
        },
             {
          title: '设备型号',
          align: 'center',
          dataIndex: 'equipmentModel'
        },
        {
          title: '操作',
          dataIndex: 'action',
          align: 'center',
          scopedSlots: { customRender: 'action' }
        }
      ],
      url: {
        list: '/device/deviceParamDict/list',
        delete: '/device/deviceParamDict/delete',
        deleteBatch: '/device/deviceParamDict/deleteBatch',
        exportXlsUrl: 'device/deviceParamDict/exportXls',
        importExcelUrl: 'device/deviceParamDict/importExcel'
      }
    }
  },
  methods: {
    loadDatas() {
      console.log(this.idValue, this.deviceName)
      this.loading = true
      getAction(this.url.list, { manuModelId: this.idValue }).then(res => {
        if (res.success) {
          this.dataSource = res.result.records
          this.ipagination.total = res.result.total
        }
        if (res.code === 510) {
          this.$message.warning(res.message)
        }
        this.loading = false
      })
    }
  },
  mounted() {}
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>