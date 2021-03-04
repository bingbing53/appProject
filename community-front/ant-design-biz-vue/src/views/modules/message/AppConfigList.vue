<template>
  <a-card :bordered="false">

    <!-- 查询区域 -->
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline">
        <a-row :gutter="24">

          <a-col :md="8" :sm="8">
            <a-form-item label="所属应用">
              <a-select placeholder="所属应用" v-model="queryParam.code">
                <a-select-option value="office">掌上办公</a-select-option>
                <a-select-option value="estate">掌上物业</a-select-option>
                <a-select-option value="shequyijia">社区e家</a-select-option>
                <a-select-option value="chat">网页聊天室</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <!--<a-col :md="6" :sm="8">-->
          <!--<a-form-item label="显示昵称">-->
          <!--<a-input placeholder="请输入显示昵称" v-model="queryParam.nickname"></a-input>-->
          <!--</a-form-item>-->
          <!--</a-col>-->
          <!--<template v-if="toggleSearchStatus">-->
          <!--<a-col :md="6" :sm="8">-->
          <!--<a-form-item label="登录名">-->
          <!--<a-input placeholder="请输入登录名" v-model="queryParam.username"></a-input>-->
          <!--</a-form-item>-->
          <!--</a-col>-->
          <!--<a-col :md="6" :sm="8">-->
          <!--<a-form-item label="显示头像">-->
          <!--<a-input placeholder="请输入显示头像" v-model="queryParam.portrait"></a-input>-->
          <!--</a-form-item>-->
          <!--</a-col>-->
          <!--</template>-->
          <a-col :md="16" :sm="16" >
            <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
              <a-button @click="handleAdd" type="primary" icon="plus" style="margin-left: 8px">新增</a-button>
            </span>
          </a-col>

        </a-row>
      </a-form>
    </div>

    <!-- 操作按钮区域 -->
    <!--<div class="table-operator">-->
      <!--<a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>-->
      <!--&lt;!&ndash;<a-button type="primary" icon="download" @click="handleExportXls('账户配置')">导出</a-button>&ndash;&gt;-->
      <!--&lt;!&ndash;<a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">&ndash;&gt;-->
        <!--&lt;!&ndash;<a-button type="primary" icon="import">导入</a-button>&ndash;&gt;-->
      <!--&lt;!&ndash;</a-upload>&ndash;&gt;-->
      <!--&lt;!&ndash;<a-dropdown v-if="selectedRowKeys.length > 0">&ndash;&gt;-->
        <!--&lt;!&ndash;<a-menu slot="overlay">&ndash;&gt;-->
          <!--&lt;!&ndash;<a-menu-item key="1" @click="batchDel"><a-icon type="delete"/>删除</a-menu-item>&ndash;&gt;-->
        <!--&lt;!&ndash;</a-menu>&ndash;&gt;-->
        <!--&lt;!&ndash;<a-button style="margin-left: 8px"> 批量操作 <a-icon type="down" /></a-button>&ndash;&gt;-->
      <!--&lt;!&ndash;</a-dropdown>&ndash;&gt;-->
    <!--</div>-->

    <!-- table区域-begin -->
    <div>
      <!--<div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">-->
        <!--<i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项-->
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
        :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
        @change="handleTableChange">

        <span slot="action" slot-scope="text, record">
          <a @click="handleEdit(record)">编辑</a>

          <!--<a-divider type="vertical" />-->
          <!--<a-dropdown>-->
            <!--<a class="ant-dropdown-link">更多 <a-icon type="down" /></a>-->
            <!--<a-menu slot="overlay">-->
              <!--<a-menu-item>-->
                <!--<a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.id)">-->
                  <!--<a>删除</a>-->
                <!--</a-popconfirm>-->
              <!--</a-menu-item>-->
            <!--</a-menu>-->
          <!--</a-dropdown>-->
        </span>

      </a-table>
    </div>
    <!-- table区域-end -->

    <!-- 表单区域 -->
    <appConfig-modal ref="modalForm" @ok="modalFormOk"></appConfig-modal>
  </a-card>
</template>

<script>
  import AppConfigModal from './modules/AppConfigModal'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'

  export default {
    name: "AppConfigList",
    mixins:[JeecgListMixin],
    components: {
      AppConfigModal
    },
    data () {
      return {
        description: '账户配置管理页面',
        isorter: {
          column: 'id',
          order: 'desc',
        },
        // 表头
        columns: [
          {
            title: '#',
            dataIndex: '',
            key:'rowIndex',
            width:60,
            align:"center",
            customRender:function (t,r,index) {
              return parseInt(index)+1;
            }
           },
		   {
            title: '名称',
            align:"center",
            dataIndex: 'name'
           },
		   {
            title: '所属应用',
            align:"center",
            dataIndex: 'code',
             customRender:function (t,r,index) {
              if(r.code == 'office'){
                return '掌上办公';
              }else if(r.code == 'estate'){
                return '掌上物业';
              }else if(r.code == 'shequyijia'){
                return '社区e家';
              }else if(r.code == 'chat'){
                return '网页聊天室';
              }
              return '';
             }
           },
		   {
            title: '推送平台',
            align:"center",
            dataIndex: 'platform',
           customRender:function (t,r,index) {
             if(r.platform == 'jiguang'){
               return '极光推送';
             }else if(r.platform == 'HuaweiPush'){
               return '华为推送';
             }else if(r.platform == 'MIPush'){
               return '小米推送';
             }
             return '';
           }
           },
		   // {
       //      title: '钥匙',
       //      align:"center",
       //      dataIndex: 'appkey'
       //     },
		   // {
       //      title: '密匙',
       //      align:"center",
       //      dataIndex: 'appsecret'
       //     },
          {
            title: '操作',
            dataIndex: 'action',
            align:"center",
            scopedSlots: { customRender: 'action' },
          }
        ],
		url: {
          list: "/message/appConfig/list",
          delete: "/message/appConfig/delete",
          deleteBatch: "/message/appConfig/deleteBatch",
          exportXlsUrl: "message/appConfig/exportXls",
          importExcelUrl: "message/appConfig/importExcel",
       },
    }
  },
  computed: {
    importExcelUrl: function(){
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
    }
  },
    methods: {
     
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less'
</style>