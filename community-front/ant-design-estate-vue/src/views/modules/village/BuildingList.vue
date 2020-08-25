<template>
  <a-row :gutter="12">
    <a-col :span="8">
      <a-card :bordered="false">
        <div>
          <a-divider>选择小区</a-divider>
          <!--<a-tree :loadData="onLoadData" checkable @select="onSelect" @check="oncheck" :treeData="treeData" />-->

          <a-menu
            style="width: 100%"
            @select="onSelect"
            :defaultSelectedKeys="villageSelected"
          >
            <a-menu-item :key="item.key" v-for="item in treeData">
              <a-icon type="bank" />{{item.title}}
            </a-menu-item>
          </a-menu>

        </div>
      </a-card>
    </a-col>
    <a-col :span="16">
      <a-card :bordered="false">
        <!-- 查询区域 -->
        <div class="table-page-search-wrapper">
          <a-form layout="inline">
            <a-row :gutter="24">
              <a-col :md="12" :sm="12">
                <a-form-item label="名称">
                  <a-input placeholder="请输入楼宇名称" v-model="queryParam.buildingName"></a-input>
                </a-form-item>
              </a-col>
              <a-col :md="12" :sm="12">
                <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
                  <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
                  <a-button @click="handleAdd" type="primary" icon="plus" style="margin-left: 5px;">新增</a-button>
                </span>
              </a-col>
            </a-row>
          </a-form>
        </div>
        <!-- 操作按钮区域 -->
        <!--<div class="table-operator" :md="24" :sm="24">-->
          <!--<a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>-->
          <!--<a-dropdown v-if="selectedRowKeys.length > 0">-->
            <!--<a-menu slot="overlay">-->
              <!--<a-menu-item key="1" @click="batchDel">-->
                <!--<a-icon type="delete" />删除-->
              <!--</a-menu-item>-->
            <!--</a-menu>-->
            <!--<a-button style="margin-left: 8px">-->
              <!--批量操作-->
              <!--<a-icon type="down" />-->
            <!--</a-button>-->
          <!--</a-dropdown>-->
        <!--</div>-->

        <!-- table区域-begin -->
        <div>
          <!--<div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">-->
            <!--<i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择-->
            <!--<a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项-->
            <!--<a style="margin-left: 24px" @click="onClearSelected">清空</a>-->
          <!--</div>-->
          <template>
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
              <span slot="action" slot-scope="text, record">
                <a @click="buildingHandleEdit(record)">编辑</a>
                <a-divider type="vertical" />
                <a-dropdown>
                  <a class="ant-dropdown-link">
                    更多
                    <a-icon type="down" />
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
          </template>
        </div>
        <!-- table区域-end -->

        <!-- 表单区域 -->
        <Building-modal ref="modalForm" @ok="modalFormOk"></Building-modal>

        <choise-building-modal ref="modalChoiseForm" @ok="modalFormOk"></choise-building-modal>
      </a-card>
    </a-col>
  </a-row>
</template>

<script>
import BuildingModal from './modules/BuildingModal'
import ChoiseBuildingModal from './modules/ChoiseBuildingModal'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import { getAction } from '@/api/manage'

export default {
  name: 'BuildingList',
  mixins: [JeecgListMixin],
  components: {
    BuildingModal,
    ChoiseBuildingModal
  },
  data() {
    return {
      villageSelected:[],
      treeData: [],
      buildingId: '',
      type: 'radio',
      villageId: '',
      options: [],
      description: '信息',
      fromTemp: '',
      // 表头
      columns: [
        {
          title: '所属小区',
          align: 'center',
           width: 80,
          dataIndex: 'villageName'
        },
        {
          title: '楼宇名称',
          align: 'center',
           width: 80,
          dataIndex: 'buildingAddress'
        },
        // {
        //   title: '楼院俗称',
        //   align: 'center',
        //    width: 80,
        //   dataIndex: 'buildingName'
        // },
        // {
        //   title: '房屋类型',
        //   align: 'center',
        //    width: 80,
        //   dataIndex: 'roomType'
        // },
        // {
        //   title: '建筑物用途',
        //   align: 'center',
        //    width: 100,
        //   dataIndex: 'buildingUse'
        // },
        {
          title: '备注',
          align: 'center',
           width: 80,
          dataIndex: 'remark'
        },
        {
          title: '操作',
          key: 'operation',
          align: 'center',
          width: 80,
          scopedSlots: { customRender: 'action' }
        }
      ],
      url: {
        list: '/village/building/list',
        delete: '/village/village/deleteBuilding',
        deleteBatch: '/village/village/deleteBatchBuilding',
        villageList: '/village/village/list',
        villageTree: '/village/village/queryVillageTree'
      },
      my_selectionRows: '' //点击添加楼宇时带过去的小区信息
    }
  },
  methods: {
    onLoadData(treeNode) {
      return;
      return new Promise(resolve => {
        let params = {}
        if (treeNode.dataRef.children) {
          resolve()
          return
        }
        if (treeNode && treeNode.dataRef) {
          resolve()
          params.id = treeNode.dataRef.key
          params.type = treeNode.dataRef.type
          params.leaf = 'unit'
        }
        getAction(this.url.villageTree, params).then(res => {
          if (res.success) {
            treeNode.dataRef.children = res.result
            this.treeData = [...this.treeData]
            resolve()
          }
        })
      })
    },
    //获取树
    getvillageTree() {
      getAction(this.url.villageTree).then(res => {
        if (res.success) {
          this.treeData = res.result;
        }
      })
    },
    // onSelect(selectedNodes, info) {
    onSelect(item) {
      // let keys = info.node.dataRef.type + 'Id'
      // console.log(keys)
      this.queryParam.villageId = item.key
      this.filters = {};
      this.filters['villageId'] = item.key
      this.searchQuery(this.filters)
    },
    // oncheck(checkedKeys){
    //   this.queryParam.villageId='';
    //   if(checkedKeys.length >1){
    //     this.$message.warning("只能选择一条")
    //     return;
    //   }else{
    //     this.queryParam.villageId = checkedKeys[0]
    //   }
    // },
    //编辑
    buildingHandleEdit: function(record) {
      this.$refs.modalForm.edit(record)
      this.$refs.modalForm.title = '编辑'
      this.$refs.modalForm.disableSubmit = false
      // this.$refs.modalForm.getDetailBuildng(record)
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
    },
    villageData(value) {
      this.villageId = value
    },
    loadData(arg) {
      if (arg === 1) {
        this.ipagination.current = 1
      }
      var params = this.getQueryParams()
      params.pageSize = 100
      params.pageNo = 1
      getAction(this.url.list, params).then(res => {
        if (res.success) {
          this.dataSource = res.result.records
        } else {
          this.dataSource = null
        }
      })
    },
    getMain(mainId, fromparam, selectionRows) {
      if (selectionRows) {
        this.my_selectionRows = selectionRows
      }
      this.queryParam.villageId = mainId
      this.loadData(1)
      this.loadVillageList()
    },
    handleAdd: function() {
      this.$refs.modalChoiseForm.add(this.queryParam.villageId, this.my_selectionRows)
      this.$refs.modalChoiseForm.title = '添加楼宇'
    },
    loadVillageList() {
      getAction(this.url.villageList).then(res => {
        if (res.success) {
          // console.log(JSON.stringify(res))
          this.options = res.result.records
        } else {
          this.dataSource = null
        }
      })
    }
  },
  mounted(){
     this.getvillageTree();
  }
}
</script>
<style scoped>
  .ant-menu:not(.ant-menu-horizontal) .ant-menu-item-selected {
    background-color: #e5f0d8 !important;
  }
</style>
