<template>
  <a-row :gutter="10">
    <a-col :md="8" :sm="24">
      <a-card :bordered="false">
        <div style="background: #fff;padding-left:16px;height: 100%; margin-top: 5px">
          <a-input-search
            @search="searchQuery"
            style="width:100%;margin-top: 10px"
            placeholder="请输入机构名称"
          />
          <!-- 树-->
          <template>
            <!--组织机构-->
            <a-directory-tree
              selectable
              :selectedKeys="selectedKeys"
              :checkStrictly="true"
              @select="onSelect"
              :dropdownStyle="{maxHeight:'200px',overflow:'auto'}"
              :treeData="sysPostTree"
            />
          </template>
        </div>
      </a-card>
    </a-col>
    <a-col :md="16" :sm="24">
      <a-card :bordered="false">
        <a-tabs defaultActiveKey="2" @change="callback">
          
            <a-tab-pane tab="用户列表" key="1">
              <SysPost-User-Info ref="SysPostUserInfo"></SysPost-User-Info>
            </a-tab-pane>
        </a-tabs>

        <!-- 表单区域    //-->
        <sysPost-modal ref="modalForm" @ok="modalFormOk"></sysPost-modal>
      </a-card>
    </a-col>
  </a-row> 

</template>

<script>
import SysPostModal from './modules/SysPostModal'
import SysPostUserInfo from './modules/SysPostUserInfo'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import {querySysPostTreeList} from '@/api/api'

export default {
  name: 'SysPostList',
  mixins: [JeecgListMixin],
  components: {
    SysPostModal,
    SysPostUserInfo
  },
  data() {
    return {
      iExpandedKeys: [],
      treeData:[],
      selectedKeys: [],
      sysPostTree: [],
      checkedKeys:[],
      description: '职能管理管理页面',
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
          title: '父编号',
          align: 'center',
          dataIndex: 'parentId'
        },
        {
          title: '名称',
          align: 'center',
          dataIndex: 'postName'
        },
        {
          title: '英文名',
          align: 'center',
          dataIndex: 'postNameEn'
        },
        {
          title: '缩写',
          align: 'center',
          dataIndex: 'postNameAbbr'
        },
        {
          title: '排序',
          align: 'center',
          dataIndex: 'postOrder'
        },
        // {
        //      title: '描述',
        //      align:"center",
        //      dataIndex: 'description'
        //     },
        {
          title: '类型',
          align: 'center',
          dataIndex: 'postType'
        },
        {
          title: '编码',
          align: 'center',
          dataIndex: 'postCode'
        },
        {
          title: '备注',
          align: 'center',
          dataIndex: 'memo'
        },
        {
          title: '是否删除（0正常 1删除）',
          align: 'center',
          dataIndex: 'delFlag'
        },
        {
          title: '状态（1启用 0禁用）',
          align: 'center',
          dataIndex: 'status'
        },
        {
          title: '创建人名称',
          align: 'center',
          dataIndex: 'createName'
        },
        {
          title: '修改人名称',
          align: 'center',
          dataIndex: 'updateName'
        },
        {
          title: '操作',
          dataIndex: 'action',
          align: 'center',
          scopedSlots: { customRender: 'action' }
        }
      ],
      url: {
        list: '/system/sysPost/list',
        delete: '/system/sysPost/delete',
        deleteBatch: '/system/sysPost/deleteBatch',
        exportXlsUrl: 'system/sysPost/exportXls',
        importExcelUrl: 'system/sysPost/importExcel'
      }
    }
  },
  computed: {
    importExcelUrl: function() {
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`
    }
  },
  methods: {
    callback(key) {
        console.log(key)
    },
    onSelect(selectedKeys, e) {
      console.log(e)
      if (this.selectedKeys[0] !== selectedKeys[0]) {
        this.selectedKeys = [selectedKeys[0]]
      }
      let record = e.node.dataRef;
      this.checkedKeys.push(record.id);
      // this.$refs.SysPostUserInfo.onClearSelected();
      this.$refs.SysPostUserInfo.open(record);
    },
    loadTree(){
        var that = this;
        that.treeData = []
        that.sysPostTree = []
        querySysPostTreeList().then((res) => {
          console.log(res);
            for (let i = 0; i < res.result.length; i++) {
              let temp = res.result[i]
              that.treeData.push(temp)
              that.sysPostTree.push(temp)
              that.setThisExpandedKeys(temp)
              // console.log(temp.id)
            }
        })
    },
    setThisExpandedKeys(node) {
      if (node.children && node.children.length > 0) {
        this.iExpandedKeys.push(node.key)
        for (let a = 0; a < node.children.length; a++) {
          this.setThisExpandedKeys(node.children[a])
        }
      }
    },

  },
  mounted(){
    this.loadTree()
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>