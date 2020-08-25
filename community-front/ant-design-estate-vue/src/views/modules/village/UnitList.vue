<template>
  <div>
    <a-row :gutter="12">
      <a-col :span="8">
        <a-card :bordered="false">
          <div>
            <a-divider>选择楼宇</a-divider>
            <!--<a-tree-->
              <!--:loadData="onLoadData"-->
              <!--checkable-->
              <!--@select="onSelect"-->
              <!--:treeData="treeData"-->
              <!--:checkStrictly="true"-->
            <!--/>-->

            <a-menu
              mode="inline"
              style="width: 100%"
            >
              <a-sub-menu :key="item.key" v-for="(item,index) in treeData" @titleClick="getBuildingTree(item,index)">
                <span slot="title"><a-icon type="bank" /><span>{{item.title}}</span></span>
                <a-menu-item v-if="!!item.children && item.children.length > 0" v-for="item2 in item.children" :key="item2.key" @click="onSelect">{{item2.title}}</a-menu-item>
              </a-sub-menu>
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
                <!-- <a-col :md="6" :sm="8">
                  <a-form-item label="所属楼宇">
                    <a-input placeholder="请输入所属楼宇" v-model="queryParam.tBuildingId"></a-input>
                  </a-form-item>
                </a-col>-->

                <a-col :md="8" :sm="8">
                  <a-form-item label="单元号">
                    <a-input placeholder="请输入单元号" v-model="queryParam.unitNo"></a-input>
                  </a-form-item>
                </a-col>
                <a-col :md="8" :sm="8">
                  <a-form-item label="单元名称">
                    <a-input placeholder="请输入单元名称" v-model="queryParam.unitName"></a-input>
                  </a-form-item>
                </a-col>
                <a-col :md="8" :sm="8">
                  <span
                    style="float: left;overflow: hidden;"
                    class="table-page-search-submitButtons"
                  >
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
          <unit-modal ref="modalForm" @ok="modalFormOk"></unit-modal>
        </a-card>
      </a-col>
    </a-row>
  </div>
</template>

<script>
import UnitModal from './modules/UnitModal'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import { getAction } from '@/api/manage'
import BuildingList from './BuildingList'

export default {
  name: 'UnitList',
  mixins: [JeecgListMixin],
  components: {
    UnitModal,
    BuildingList
  },
  data() {
    return {
      treeData: [],
      dataType: '',
      description: '单元管理页面',
      // 表头
      columns: [
        {
          title: '所属小区',
          align: 'center',
          width: 60,
          dataIndex: 'villageName'
        },
        {
          title: '所属楼宇',
          align: 'center',
          width: 60,
          dataIndex: 'buildingName'
        },
        {
          title: '单元号',
          align: 'center',
          width: 60,
          dataIndex: 'unitNo'
        },
        {
          title: '单元名称',
          align: 'center',
          width: 60,
          dataIndex: 'unitName'
        },
        {
          title: '操作',
          dataIndex: 'action',
          align: 'center',
          width: 130,
          scopedSlots: { customRender: 'action' }
        }
      ],
      url: {
        list: '/village/unit/list',
        delete: '/village/unit/delete',
        deleteBatch: '/village/unit/deleteBatch',
        exportXlsUrl: 'village/unit/exportXls',
        importExcelUrl: 'village/unit/importExcel',
        villageTree: '/village/village/queryVillageTree'
      }
    }
  },
  computed: {
    importExcelUrl: function() {
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`
    }
  },
  methods: {
    onLoadData(treeNode) {
      this.dataType = ''
      // return
      return new Promise(resolve => {
        let params = {}
        if (treeNode.dataRef.children) {
          resolve()
          return
        }
        if (treeNode && treeNode.dataRef) {
          resolve()
          if (treeNode.dataRef.type == 'building') {
            this.dataType = treeNode.dataRef.type
            return
          }
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
    getBuildingTree(item,index){
      if(!!this.treeData[index].children && this.treeData[index].children.length > 0)
        return;
      let params = {}
      params.id = item.key
      params.type = 'village'
      params.leaf = 'unit'
      getAction(this.url.villageTree, params).then(res => {
        if (res.success) {
          // node.children = res.result
          this.treeData[index].children = res.result;// = [...this.treeData]
          // resolve()
          this.$forceUpdate()
        }
      })
    },
    //获取树
    getvillageTree() {
      getAction(this.url.villageTree).then(res => {
        if (res.success) {
          this.treeData = res.result
        }
      })
    },
    // onSelect(selectedNodes, info) {
    onSelect(item) {
      // let keys = info.node.dataRef.type + 'Id'
      // console.log(keys)
      this.filters = {}
      this.filters['buildingId'] = item.key
      this.searchQuery(this.filters)
    },
    handleAdd: function() {
      this.$refs.modalForm.add(this.filters['buildingId'])
      this.$refs.modalForm.title = '添加单元'
    },
    unitId(buildingId) {
      this.$refs.modalForm.unitBuildingId(buildingId)
    }
  },
  mounted() {
    this.getvillageTree()
    // this.$refs.BuildingList.getMain('', 'unit')
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>