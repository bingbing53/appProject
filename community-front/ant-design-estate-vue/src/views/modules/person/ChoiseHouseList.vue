<template>
  <a-row :gutter="12">
    <a-col :span="8">
      <a-card :bordered="false">
        <div>
          <a-divider>选择单元</a-divider>
          <a-menu
            mode="inline"
            style="width: 100%"
          >
            <a-sub-menu :key="item.key" v-for="(item,index) in treeData" @titleClick="getBuildingTree(item,index)">
              <span slot="title"><a-icon type="bank" /><span>{{item.title}}</span></span>
              <a-sub-menu v-if="!!item.children && item.children.length > 0" v-for="(item2,index2) in item.children" :key="item2.key" @titleClick="getUnitTree(item2,index,index2)">
                <span slot="title">{{item2.title}}</span>
                <a-menu-item v-if="!!item2.children && item2.children.length > 0" v-for="item3 in item2.children" :key="item3.key" @click="onSelect">{{item3.title}}</a-menu-item>
              </a-sub-menu>
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
              <a-col :md="12" :sm="12">
                <a-form-item label="房间号">
                  <a-input placeholder="请输入房间号" v-model="queryParam.houseNumber"></a-input>
                </a-form-item>
              </a-col>
              <a-col :md="12" :sm="12">
                <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
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
          <!--<a-button type="primary" icon="download" @click="handleExportXls('房屋')">导出</a-button>-->
          <!--<a-upload-->
            <!--name="file"-->
            <!--:showUploadList="false"-->
            <!--:multiple="false"-->
            <!--:headers="tokenHeader"-->
            <!--:action="importExcelUrl"-->
            <!--@change="handleImportExcel"-->
          <!--&gt;-->
            <!--<a-button type="primary" icon="import">导入</a-button>-->
          <!--</a-upload>-->
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
            <span slot="area" slot-scope="text, record">
              {{record.villageName}} / {{record.buildingName}} / {{record.unitName}}
            </span>
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
        <choise-house-modal ref="modalForm" @ok="modalFormOk"></choise-house-modal>
      </a-card>
    </a-col>
  </a-row>
</template>

<script>
import ChoiseHouseModal from './modules/ChoiseHouseModal'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import { getAction } from '@/api/manage'

export default {
  name: 'choiseHouseList',
  mixins: [JeecgListMixin],
  components: {
    ChoiseHouseModal
  },
  data() {
    return {
      treeData: [],
      description: '房屋管理页面',
      // 表头
      columns: [
        {
          title: '地址',
          align: 'center',
          width: 100,
          dataIndex: 'area',
          scopedSlots: { customRender: 'area' }
        },
        {
          title: '房号',
          align: 'center',
          width: 80,
          dataIndex: 'houseNumber'
        },
        {
          title: '操作',
          dataIndex: 'action',
          align: 'center',
          width: 100,
          scopedSlots: { customRender: 'action' }
        }
      ],
      url: {
        list: '/village/house/list',
        delete: '/village/house/delete',
        deleteBatch: '/village/house/deleteBatch',
        exportXlsUrl: 'village/house/exportXls',
        importExcelUrl: 'village/house/importExcel',
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
      return new Promise(resolve => {
        console.log(treeNode)
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
          console.log(JSON.stringify(params))
        }
        getAction(this.url.villageTree, params).then(res => {
          console.log(JSON.stringify(res))
          if (res.success) {
            console.log(treeNode)
            treeNode.dataRef.children = res.result
            this.treeData = [...this.treeData]
            resolve()
          }
        })
      })
    },
    getUnitTree(item,index,index2){
      if(!!this.treeData[index].children[index2].children && this.treeData[index].children[index2].children.length > 0)
        return;
      let params = {}
      params.id = item.key
      params.type = 'building'
      params.leaf = 'unit'
      getAction(this.url.villageTree, params).then(res => {
        if (res.success) {
          // node.children = res.result
          this.treeData[index].children[index2].children = res.result;// = [...this.treeData]
          // resolve()
          this.$forceUpdate()
        }
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
      this.filters = {};
      this.filters['unitId'] = item.key
      this.searchQuery(this.filters)
    }
  },
  mounted() {
    this.getvillageTree();
    console.log("人口表格")
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>