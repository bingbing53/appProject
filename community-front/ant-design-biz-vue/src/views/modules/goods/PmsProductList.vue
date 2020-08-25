<template>
  <a-row :gutter="12">
    <a-col :span="6" style="max-height: 500px;overflow-y: scroll">
      <a-card :bordered="false">
        <a-divider>选择商品分类</a-divider>
        <a-tree :loadData="onLoadData" :treeData="treeData" @select="selectNode"/>
      </a-card>
    </a-col>
    <a-col :span="18">
      <a-card :bordered="false">
        <!-- 查询区域 -->
        <div class="table-page-search-wrapper">
          <a-form layout="inline">
            <a-row :gutter="24">

              <a-col :md="8" :sm="8">
                <a-form-item label="商品名称">
                  <a-input placeholder="商品名称" v-model="queryParam.name"></a-input>
                </a-form-item>
              </a-col>
              <a-col :md="8" :sm="8">
                <a-form-item label="审核状态">
                  <a-select placeholder="订单类型"  v-model="queryParam.verifyStatus">
                    <a-select-option value="0">待审核</a-select-option>
                    <a-select-option value="1">审核通过</a-select-option>
                    <a-select-option value="2">审核不通过</a-select-option>
                    <a-select-option value="3">已保存</a-select-option>
                  </a-select>
                </a-form-item>
              </a-col>
              <a-col :md="8" :sm="8" >
                <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
                <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
              </a-col>

            </a-row>
          </a-form>
        </div>

        <!-- 操作按钮区域 -->
        <div class="table-operator">
          <a-dropdown v-if="selectedRowKeys.length > 0">
            <a-menu slot="overlay">
              <a-menu-item key="1" @click="batchDel"><a-icon type="delete"/>删除</a-menu-item>
            </a-menu>
            <a-button style="margin-left: 8px"> 批量操作 <a-icon type="down" /></a-button>
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
            size="small"
            bordered
            rowKey="id"
            :columns="columns"
            :dataSource="dataSource"
            :pagination="ipagination"
            :loading="loading"
            :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
            @change="handleTableChange">



        <span slot="productName" slot-scope="text, record">
          <!--<a-tag color="green">{{record.productCategoryName}}</a-tag>--> <a @click="handleEdit(record)">{{record.name}}</a>
        </span>

            <span slot="price" slot-scope="text, record">
          现价：{{record.price}}
          <a-divider type="vertical" />
          原价：{{record.originalPrice}}
        </span>

            <span slot="coinPrice" slot-scope="text, record">
          {{record.coinPrice}}元
          <a-divider type="vertical" />
          {{record.coin}}币
        </span>
            <span slot="status" slot-scope="text, record">
          <a-tag v-if="record.verifyStatus == '0'" color="orange">待审核</a-tag>
          <a-tag v-if="record.verifyStatus == '1'" color="green">审核通过</a-tag>
          <a-tag v-if="record.verifyStatus == '2'" color="red">审核不通过</a-tag>
          <a-tag v-if="record.verifyStatus == '3'" color="red">已保存</a-tag>
          <a-tag v-if="record.publishStatus == '0'">未上架</a-tag>
          <a-tag v-if="record.publishStatus == '1'" color="green">已上架</a-tag>
        </span>

            <span slot="action" slot-scope="text, record">

          <a-divider type="vertical" />
          <a-dropdown>
            <a class="ant-dropdown-link">更多 <a-icon type="down" /></a>
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
        <!--<pmsProduct-modal ref="modalForm" @ok="modalFormOk"></pmsProduct-modal>-->
        <pms-product-advanced ref="modalForm" @ok="modalFormOk"></pms-product-advanced>
      </a-card>
    </a-col>
  </a-row>
</template>

<script>
  import PmsProductModal from './modules/PmsProductModal'
  import PmsProductAdvanced from './modules/PmsProductAdvanced'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import { getAction } from '@/api/manage'

  export default {
    name: "PmsProductList",
    mixins:[JeecgListMixin],
    components: {
      PmsProductModal,
      PmsProductAdvanced
    },
    data () {
      return {
        description: '商品管理页面',
        treeData:[
          {title:'虚拟商品',key:'G01'},
          {title:'实物商品',key:'G02'}
        ],
        //排序
        isorter: {
          column: 'id',
          order: 'desc',
        },
        // 表头
        columns: [
          {
            title: '编号',
            dataIndex: '',
            key:'rowIndex',
            align:"center",
            customRender:function (t,r,index) {
              return t.id;
            }
           },
          // {
          //   title: '商品分类',
          //   align:"center",
          //   dataIndex: 'productCategoryName'
          // },
		   {
            title: '产品名称',
            align:"center",
            dataIndex: 'name',
            scopedSlots: { customRender: 'productName' },
           },
		   {
            title: '价格',
            align:"center",
            dataIndex: 'price',
            scopedSlots: { customRender: 'price' },
           },
          // {
          //   title: '市场价',
          //   align:"center",
          //   dataIndex: 'originalPrice'
          // },
          {
            title: '公益价',
            align:"center",
            dataIndex: 'coinPrice',
            scopedSlots: { customRender: 'coinPrice' },
          },
          // {
          //   title: '公益币数量',
          //   align:"center",
          //   dataIndex: 'coin'
          // },
          {
            title: '状态',
            align:"center",
            dataIndex: 'verifyStatus',
            scopedSlots: { customRender: 'status' },
          },
          // {
          //   title: '上架状态',
          //   align:"center",
          //   dataIndex: 'publishStatus'
          // },
          // {
          //   title: '操作',
          //   dataIndex: 'action',
          //   align:"center",
          //   scopedSlots: { customRender: 'action' },
          // }
        ],
		url: {
          list: "/mall/pmsProduct/list",
          delete: "/mall/pmsProduct/delete",
          deleteBatch: "/mall/pmsProduct/deleteBatch",
          exportXlsUrl: "mall/pmsProduct/exportXls",
          importExcelUrl: "mall/pmsProduct/importExcel",
          categoryTreeRoot:window._CONFIG['ssoPrefixUrl']+"/sys/category/loadTreeRoot",
          url_children:"/sys/category/loadTreeChildren",
       },
    }
  },
  computed: {
    importExcelUrl: function(){
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
    }
  },
    methods: {
      selectNode(item,other){
        let node = other.node;
        console.log(node)
        if(node.isLeaf){
          this.queryParam.productCategoryCode = item[0]
          this.filters = {};
          this.filters['productCategoryCode'] = item[0]
          this.searchQuery(this.filters)
        }
      },
      //加载树
      onLoadData(treeNode){
        return new Promise(resolve => {
          let params = {}
          if (treeNode.dataRef.children) {
            resolve()
            return
          }
          if (treeNode && treeNode.dataRef) {
            resolve()
            params.pcode = treeNode.dataRef.key
            params.async = true
          }
          getAction(this.url.categoryTreeRoot, params).then(res => {
            if (res.success) {
              let result = res.result;
              if(!!result && result.length > 0){
                  for(var i = 0;i<result.length;i++){
                    result[i].isLeaf = result[i].leaf;
                    result[i].key = result[i].code
                  }
              }
              treeNode.dataRef.children = result
              this.treeData = [...this.treeData]
              resolve()
            }
          })
        })
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less'
</style>