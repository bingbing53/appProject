<template>
    <a-card :bordered="false">

      <!-- 操作按钮区域 -->
      <div class="table-operator" :md="24" :sm="24" style="margin: 0px 0px 20px 0px">
        <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>

        <a-dropdown v-if="selectedRowKeys.length > 0"> 
          <a-menu slot="overlay">
            <a-menu-item key="1" @click="batchDel">
              <a-icon type="delete"/>删除
            </a-menu-item>
          </a-menu>
          <a-button style="margin-left: 8px"> 批量操作
            <a-icon type="down"/>
          </a-button>
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
          @change="handleTableChange"
          :scroll="{ x: 1500, y: 300 }"
          >

          <span slot="action" slot-scope="text, record">
            <a @click="handleEdit(record)">编辑</a>
            <a-divider type="vertical"/>
            <a-dropdown>
              <a class="ant-dropdown-link">
                更多 <a-icon type="down"/>
              </a>
              <a-menu slot="overlay">
                <a-menu-item>
                  <a href="javascript:;" @click="handleDetail(record)">详情</a>
                </a-menu-item>
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
      <Building-modal ref="modalForm" @ok="modalFormOk"/>
    </a-card>
</template>

<script>
  import BuildingModal from './modules/BuildingModal'
  import {JeecgListMixin} from '@/mixins/JeecgListMixin'
  import {getAction} from '@/api/manage'

  export default {
    name: "BuildingList",
    mixins: [JeecgListMixin],
    components: {
      BuildingModal,
    },
    data() {
      return {
        description: '信息',
        // 表头
        columns: [
          {
            title: '所属小区',
            align:"center",
             width: 60,
            dataIndex: 'tVillageName'
            
          },
          {
            title: '楼宇地址',
            align:"center",
             width: 60,
            dataIndex: 'buildingAddress'
          },
          {
            title: '楼院俗称',
            align:"center",
             width: 60,
            dataIndex: 'buildingName'
          },
          {
            title: '房屋类型',
            align:"center",
             width: 60,
            dataIndex: 'roomType'
          },
          {
            title: '建筑物用途',
            align:"center",
             width: 60,
            dataIndex: 'buildingUse'
          },
          {
            title: '备注',
            align:"center",
             width: 60,
            dataIndex: 'remark'
          },
          {
            title: '创建人名称',
            align:"center",
             width: 60,
            dataIndex: 'createName'
          },
          {
            title: '创建日期',
            align:"center",
             width: 60,
            dataIndex: 'createDate'
          },
          {
            title: '更新人名称',
            align:"center",
             width: 60,
            dataIndex: 'updateName'
          },
          {
            title: '更新日期',
            align:"center",
             width: 60,
            dataIndex: 'updateDate'
          },
          {
            title: '所属部门',
            align:"center",
             width: 60,
            dataIndex: 'sysOrgCode'
          },
          {
            title: '所属部门名称',
            align:"center",
             width: 60,
            dataIndex: 'sysOrgName'
          },
          {
            title: '所属公司',
            align:"center",
             width: 60,
            dataIndex: 'sysCompanyCode'
          },
          {
            title: '所属公司名称',
            align:"center",
             width: 60,
            dataIndex: 'sysCompanyName'
          },
          {
            title: '所属区域',
            align:"center",
             width: 60,
            dataIndex: 'areaCode'
          },
          {
            title: '所属区域名称',
            align:"center",
             width: 60,
            dataIndex: 'areaName'
          },
         {
          title: '操作',
          key: 'operation',
          align: "center",
          width: 130,
          fixed: 'right',
          scopedSlots: {customRender: 'action'},
        }],
        url: {
          list: "/village/village/listBuildingByMainId",
          delete: "/village/village/deleteBuilding",
          deleteBatch: "/village/village/deleteBatchBuilding",
        }
      }
    },
    methods: {
      
      loadData(arg) {
        if (arg === 1) {
          this.ipagination.current = 1;
        }
        var params = this.getQueryParams();
        getAction(this.url.list, {mainId: params.mainId}).then((res) => {
          if (res.success) {
            this.dataSource = res.result;
          } else {
            this.dataSource = null;
          }
        })
      },
      getMain(mainId) {
        this.queryParam.mainId = mainId;
        this.loadData(1);
      },
      handleAdd: function () {
        this.$refs.modalForm.add(this.queryParam.mainId);
        this.$refs.modalForm.title = "添加楼宇";
      },
    }
  }
</script>
<style scoped>
  /* .ant-card {
    margin-left: -30px;
    margin-right: -30px;
  } */
</style>
