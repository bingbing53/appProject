<template>
  <div class="container">
    <!-- 列表搜索区域开始 -->
    <div class="list_search">
      <div>
        <span class="mr-10 c-999 f-14">状态</span>
        <a-radio-group :defaultValue="statusType.type_1" buttonStyle="solid" @change="statusChange">
          <a-radio-button :value="statusType.type_1">发布待审核</a-radio-button>
          <a-radio-button :value="statusType.type_2">审核通过</a-radio-button>
          <a-radio-button :value="statusType.type_3">审核不通过</a-radio-button>
          <a-radio-button :value="statusType.type_4">禁用</a-radio-button>
        </a-radio-group>
      </div>
      <div class="search_title mt-20">
        <span class="mr-10 c-999 f-14">视频标题</span>
        <a-input placeholder="请输入视频标题" v-model="search_title" @pressEnter="getarticleList" />
      </div>
    </div>
    <!-- 列表搜索区域结束 -->
    <a-list itemLayout="vertical" size="large" :pagination="pagination" :dataSource="dataSource" :loading="loading">
      <a-list-item slot="renderItem" slot-scope="item, index" key="item.articleTitle">
        <a-row v-if="item.images" class="left_col">
          <a-col :span="5">
            <div class="scale_container">
              <img
                v-if="item.images && item.images.img && item.articleType == '1'"
                :src="getImageView(item.images.img)"
                alt="logo"
              />
              <img
                v-else-if="item.images && item.articleType == '0'"
                :src="getImageView(item.images)"
                width="140"
                height="86.5"
                alt="logo"
              />
            </div>
          </a-col>
          <a-col :span="19">
            <h3>{{item.articleTitle}}</h3>
            <div class="statis">点击数 :<span>{{item.hits}}</span> · 评论数 :<span>{{item.comment}}</span> · 点赞数 :<span>{{item.praise}}</span>  · 收藏数 :<span>{{item.collect}}</span></div>
            <a-tag color="green">{{item.sysOrgCode_dictText}}</a-tag>
            <a-tag>{{item.status_dictText}}</a-tag>
            <p class="mt-10">{{item.createDate}}</p>
          </a-col>
        </a-row>
        <a-row v-else class="left_col">
          <a-col :span="24">
            <h3>{{item.articleTitle}}</h3>
            <div class="statis">点击数 :<span>{{item.hits}}</span> · 评论数 :<span>{{item.comment}}</span> · 点赞数 :<span>{{item.praise}}</span>  · 收藏数 :<span>{{item.collect}}</span></div>
            <a-tag color="blue">{{item.sysOrgCode_dictText}}</a-tag>
            <a-tag>{{item.status_dictText}}</a-tag>
            <p class="mt-10">{{item.createDate}}</p>
          </a-col>
        </a-row>

        <template slot="extra">
          <div class="handle_area">
            <span @click="toAudit(item.id,item)" v-show="item.status == '1'">
              <a-icon type="file-search" /> 审核
            </span>
            <br />
            <span @click="forbid(item.id)" v-show="item.status == '2'" style="color: red">
              <a-icon type="stop" /> 禁用
            </span>
          </div>
        </template>
      </a-list-item>
    </a-list>
    <open-Audit @loadList="loadStautsList" ref="openAudit"></open-Audit>

    <a-modal title="提示" v-model="visible_forbid" :maskClosable="false">
      <template slot="footer">
        <a-button @click="handleCancel_forbid">取消</a-button>
        <a-button type="primary" :confirmLoading="confirmLoading2" @click="handleOk_forbid">确定</a-button>
      </template>
      <a-textarea placeholder="请输入禁用的原因" :rows="4" v-model="forbid_content" />
    </a-modal>
  </div>
</template>

<script>
import { httpAction, postAction, getAction, deleteAction } from '@/api/manage'
import { likeAll } from '@/utils/util' // base filter
// import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import openAudit from './modules/AuditListModal'

export default {
  name: 'ArticleList',
  // mixins: [JeecgListMixin],
  components: {
    openAudit
  },
  data() {
    return {
      description: '文章信息管理页面',
      dataSource: [],
      // 表头
      pagination: {
        pageSize: 10,
        pageNo: 1,
        onChange: page => {
          console.log(page)
          this.pagination.pageNo = page
          this.getarticleList()
        },
      },
      url: {
        list: '/article/article/verifyList',
        delete: '/article/article/delete',
        deleteBatch: '/article/article/deleteBatch',
        exportXlsUrl: 'article/article/exportXls',
        importExcelUrl: 'article/article/importExcel',
        imgerver: window._CONFIG['imageViewURL'],
        audit: '/article/article/verify'
      },
      statusType: {
        type_0: 0,
        type_1: 1,
        type_2: 2,
        type_3: 3,
        type_4: 4
      },
      loading: false,
      search_title: '',
      status: 1,
      visible_forbid: false,
      confirmLoading2: false,
      ids: '',
      forbid_content: ''
    }
  },
  computed: {
    importExcelUrl: function() {
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`
    }
  },
  methods: {
    getImageView: function(image) {
      return this.url.imgerver + '/' + image
    },
    loadStautsList(status) {
      console.log(status)
      this.getarticleList(status)
    },
    getarticleList(status) {
         this.loading = true
      let param = {
        articleType: '',
        status: this.status,
        pageNo: this.pagination.pageNo,
        pageSize: this.pagination.pageSize,
        articleTitle: likeAll(this.search_title),
      }
      console.log(param)
      getAction(this.url.list, param).then(res => {
        if (res.success) {
          res.result.records.forEach((item, index) => {
            if (item.images && item.articleType == '1') item.images = JSON.parse(item.images)
            else if (item.images && item.articleType == '0') item.images = item.images.split(',')[0]
            else ''
          })
          this.loading = false
          this.dataSource = res.result.records
          this.pagination.total = res.result.total
        }
      })
    },
    statusChange(e) {
      console.log(e)
      this.status = e.target.value
      this.getarticleList()
    },
    formatDuring(ms) {
      let min = Math.floor((ms / 1000 / 60) << 0)
      let sec = Math.floor((ms / 1000) % 60)
      return min + ':' + sec
    },
    //去审核页面
    toAudit(id, item) {
      this.$refs.openAudit.showModal()
      this.$refs.openAudit.getAuditData(item)
    },
    //禁用
    forbid(id) {
      let that = this
      this.$confirm({
        title: '确认禁用吗?',
        okText: '确认',
        okType: 'danger',
        cancelText: '取消',
        onOk() {
          that.visible_forbid = true
          that.ids = id
        },
        onCancel() {
          console.log('Cancel')
        }
      })
    },
    sureForbid() {
      let param = {
        id: this.ids,
        status: 2,
        content: this.forbid_content
      }
      postAction(this.url.audit, param).then(res => {
        if (res.success) {
          this.$message.success('操作成功')
          this.getarticleList()
        } else {
          this.$message.warning('操作失败')
        }
      })
      this.visible_forbid = false
    },
    handleOk_forbid() {
      this.sureForbid()
    },
    handleCancel_forbid() {
      this.visible_forbid = false
    }
  },
  mounted() {
    this.getarticleList()
  }
}
</script>
<style scoped lang="less">
@import '~@assets/less/common.less';
@import '~@assets/less/common_cms.less';

.left_col {
  line-height: 1;
  margin-bottom: -20px;
}
.left_col img {
  vertical-align: middle;
  height: 108px;
}
.statis {
  color: #666;
  font-size: 13px;
  margin-bottom: 16px;
  margin-top: 16px;
}
.search_title input {
  width: 200px;
}
</style>