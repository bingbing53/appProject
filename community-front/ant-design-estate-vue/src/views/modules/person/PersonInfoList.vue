<template>
  <a-row :gutter="24">
    <!--<a-col :span="8">-->
      <!--<a-card :bordered="false">-->
        <!--<div>-->
          <!--&lt;!&ndash; <a-input-search style="width:100%;margin-top: 10px" placeholder="请输小区名称" /> &ndash;&gt;-->
          <!--<a-tree :loadData="onLoadData" checkable @select="onSelect" :treeData="treeData" />-->
        <!--</div>-->
      <!--</a-card>-->
    <!--</a-col>-->
    <a-col :span="24">
      <a-card :bordered="false">
        <!-- 查询区域 -->
        <div class="table-page-search-wrapper">
          <a-form layout="inline">
            <a-row :gutter="24">
              <a-col :md="6" :sm="8">
                <a-form-item label="姓名">
                  <a-input placeholder="请输入姓名" v-model="queryParam.personName"></a-input>
                </a-form-item>
              </a-col>
              <a-col :md="6" :sm="8">
                <a-form-item label="手机号">
                  <a-input placeholder="请输入手机号" v-model="queryParam.mobilePhone"></a-input>
                </a-form-item>
              </a-col>
              <template v-if="toggleSearchStatus">
                <a-col :md="6" :sm="8">
                  <a-form-item label="卡号">
                    <a-input placeholder="请输入卡号" v-model="queryParam.cardNo"></a-input>
                  </a-form-item>
                </a-col>
                <a-col :md="6" :sm="8">
                  <a-form-item label="证件号码">
                    <a-input placeholder="请输入证件号码" v-model="queryParam.idcard"></a-input>
                  </a-form-item>
                </a-col>
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
          <!--<a-button type="primary" icon="download" @click="handleExportXls('居民管理')">导出</a-button>-->
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
        <template>
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
            <span slot="idcard" slot-scope="text, record">
              {{hideIDCard(record.idcard)}}
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
        </template>
       
        <!-- table区域-end -->
        <!-- 表单区域 -->
        <personInfo-modal ref="modalForm" @ok="modalFormOk"></personInfo-modal>
      </a-card>
    </a-col>
  </a-row>
</template>

<script>
import PersonInfoModal from './modules/PersonInfoModal'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import { getAction } from '@/api/manage'

export default {
  name: 'PersonInfoList',
  mixins: [JeecgListMixin], 
  components: {
    PersonInfoModal
  },
  props:['length','ids'],
  data() {
    return {
      treeData: [],
      description: '居民管理页面',
      // 表头
      columns: [
        {
          title: '姓名',
          align: 'center',
          width: 80,
          dataIndex: 'personName'
        },
        {
          title: '性别',
          align: 'center',
          width: 80,
          dataIndex: 'sex_dictText'
        },
        {
          title: '手机号',
          align: 'center',
          width: 100,
          dataIndex: 'mobilePhone'
        },
        {
          title: '证件号码',
          align: 'center',
          width: 160,
          dataIndex: 'idcard',
          scopedSlots: { customRender: 'idcard' }
        },
        // {
        //   title: '籍贯',
        //   align: 'center',
        //   width: 80,
        //   dataIndex: 'nativePlace'
        // },
        // {
        //   title: '民族',
        //   align: 'center',
        //   width: 80,
        //   dataIndex: 'nationality'
        // },
        // {
        //   title: '政治面貌',
        //   align: 'center',
        //   width: 80,
        //   dataIndex: 'polity'
        // },
        // {
        //   title: '文化程度',
        //   align: 'center',
        //   width: 80,
        //   dataIndex: 'eduLevel'
        // },
        // {
        //   title: '家庭地址',
        //   align: 'center',
        //   width: 160,
        //   dataIndex: 'familyAddress'
        // },
        {
          title: '操作',
          dataIndex: 'action',
          align: 'center',
          // fixed: 'right',
          width: 100,
          scopedSlots: { customRender: 'action' }
        }
      ],
      url: {
        list: '/person/personInfo/list',
        delete: '/person/personInfo/delete',
        deleteBatch: '/person/personInfo/deleteBatch',
        exportXlsUrl: 'person/personInfo/exportXls',
        importExcelUrl: 'person/personInfo/importExcel',
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
      hideIDCard (str) {
        if(!str || str.trim().length <= 10)
          return str||'';
        let frontLen = 6,endLen = 4;
        var len = str.length - frontLen - endLen;
        var xing = '';
        for (var i = 0; i < len; i++) {
          xing += '*';
        }
        return str.substring(0, frontLen) + xing + str.substring(str.length - endLen);
      },
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
    //获取树
    getvillageTree() {
      getAction(this.url.villageTree).then(res => {
        if (res.success) {
          this.treeData = res.result
        }
      })
    },
    onSelect(selectedNodes, info) {
    
      // console.log('onCheck:'+ JSON.stringify(selectedNodes))
      console.log(info.node.dataRef.key)
      console.log(info.node.dataRef)
      let keys = info.node.dataRef.type + 'Id'
      console.log(keys)
      this.filters[keys] = info.node.dataRef.key

      console.log(JSON.stringify(this.filters))
      this.searchQuery(this.filters)
    },
  
  },
  mounted() {
    this.getvillageTree()
   
  },

}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>