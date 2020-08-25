<template>
  <a-drawer
    title="反馈处理"
    :width="720"
    @close="onClose"
    :visible="visible"
    :wrapStyle="{height: 'calc(100% - 108px)',overflow: 'auto',paddingBottom: '108px'}"
  >
    <a-card :bordered="false">
      <!-- 操作按钮区域 -->
      <div class="table-operator" :md="24" :sm="24" style="margin: 0px 0px 20px 0px">
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
      <template>
        <a-timeline :reverse="true">
          <a-timeline-item v-for="(item,index) in dataSource" :key="index">
            <div>
              <a-icon type="delete" class="del_icon" @click="my_handleDelete(item.id)" />
            </div>
            <div id="imgTooles">
              <ul>
                <li v-for="(img,idx) in item.image" :key="idx" class="img_div">
                  <img :src="url.imgerver+'/'+img" alt  class="my_img" />
                </li>
              </ul>
            </div>
            <p>处理描述：{{item.handleDes}}</p>
            <p>处理时间：{{item.createTime}}</p>
          </a-timeline-item>
        </a-timeline>
      </template>

      <!-- 表单区域 -->
      <FeedHandle-modal ref="modalForm" @ok="modalFormOk" />
    </a-card>
  </a-drawer>
</template>

<script>
import FeedHandleModal from './modules/FeedHandleModal'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import { getAction, deleteAction } from '@/api/manage'
//引入图片预览组件
import Viewer from 'viewerjs'
import 'viewerjs/dist/viewer.css'

export default {
  name: 'FeedHandleList',
  mixins: [JeecgListMixin],
  components: {
    FeedHandleModal
  },
  data() {
    return {
      delvisible: false,
      previewVisible: false,
      previewImage: '',
      visible: false,
      description: '信息',
      // 表头
      columns: [
        {
          title: '处理人编号',
          align: 'center',
          dataIndex: 'sysuserId'
        },
        {
          title: '处理描述',
          align: 'center',
          dataIndex: 'handleDes'
        },
        // {
        //   title: '处理图片',
        //   align: 'center',
        //   dataIndex: 'image'
        // },
        {
          title: '操作',
          key: 'operation',
          align: 'center',
          width: 130,
          scopedSlots: { customRender: 'action' }
        }
      ],
      url: {
        list: '/serve/feedback/listFeedHandleByMainId',
        delete: '/serve/feedback/deleteFeedHandle',
        deleteBatch: '/serve/feedback/deleteBatchFeedHandle',
        imgerver: window._CONFIG['ssoPrefixUrl'] + '/sys/common/view'
      }
    }
  },
  methods: {
    my_handleDelete(id) {
      this.$confirm({
        title: '确认删除这条回复吗?',
        okText: '确认',
        cancelText: '取消',
        onOk() {
          deleteAction(that.url.delete, { id: id }).then(res => {
            if (res.success) {
              that.$message.success(res.message)
              that.loadData()
            } else {
              that.$message.warning(res.message)
            }
          })
        }
      })
      var that = this

      this.delvisible = false
    },
    handleCancelImg() {
      this.previewVisible = false
    },
    handlePreview(img) {
      this.previewImage = img
      this.previewVisible = true
    },
    loadData(arg) {
      if (arg === 1) {
        this.ipagination.current = 1
      }
      var params = this.getQueryParams()
      getAction(this.url.list, { mainId: params.mainId }).then(res => {
        if (res.success) {
          res.result.forEach((item, index) => {
            item.image && (item.image = JSON.parse(item.image))
          })
          this.dataSource = res.result
          console.log(this.dataSource)
            this.$nextTick(() => {
                this.initImageTools();
            });

        } else {
          this.dataSource = null
        }
      })
    },
    initImageTools() {
      //初始化 viewerjs
      const ViewerDom = document.getElementById('imgTooles')
      const viewer = new Viewer(ViewerDom, {
        url: 'data-original'
      })
    },
    getMain(mainId) {
      this.queryParam.mainId = mainId
      this.loadData(1)
    },
    handleAdd: function() {
      this.$refs.modalForm.add(this.queryParam.mainId)
      this.$refs.modalForm.title = '添加反馈处理'
    },
    showDrawer() {
      this.visible = true
    },
    onClose() {
      this.visible = false
      this.$emit('ok');
    }
  }
}
</script>
<style scoped>
.ant-card {
  /* margin-left: -30px;
  margin-right: -30px; */
}
.img_div {
  width: 100px;
  height: 100px;
  border-radius: 5px;
  display: inline-block;
  margin:10px;
  
}
.my_img {
  width: 100%;
  height: 100%;
}
.del_icon {
  color: #f00;
  cursor: pointer;
  font-weight: bold;
  transition: all 0.6s ease-in;
  -webkit-transition: all 0.6s ease-in;
}
.del_icon :hover {
  transform: scale(1.2);
}
</style>
