<template>
  <div class="container">
    <!-- 列表搜索区域开始 -->
    <div class="list_search">
      <div>
        <span class="mr-10 f-14 c-999">状态</span>
        <a-radio-group defaultValue="statusType.type_0" buttonStyle="solid" @change="statusChange">
          <a-radio-button :value="statusType.type_0">已保存</a-radio-button>
          <a-radio-button :value="statusType.type_1">发布待审核</a-radio-button>
          <a-radio-button :value="statusType.type_2">审核通过</a-radio-button>
          <a-radio-button :value="statusType.type_3">审核不通过</a-radio-button>
          <a-radio-button :value="statusType.type_4">禁用</a-radio-button>
        </a-radio-group>
      </div>
      <div class="search_title mt-20">
        <span class="mr-10 f-14 c-999">视频标题</span>
        <a-input placeholder="请输入视频标题" v-model="search_title" @pressEnter="getarticleList" />
      </div>
    </div>
    <!-- 列表搜索区域结束 -->
    <a-list
      itemLayout="vertical"
      size="large"
      :pagination="pagination"
      :dataSource="dataSource"
      :loading="loading"
    >
      <a-list-item slot="renderItem" slot-scope="item, index" :key="item.articleTitle">
        <a-row class="left_col">
          <a-col :span="5">
            <div class="scale_container">
              <div
                class="video_duration"
                v-if="item.images.duration"
                @click="toTheVideo(item.images.video)"
              >
                <a-icon type="caret-right" />
                <span>{{formatDuring(item.images.duration)}}</span>
              </div>
              <img
                v-if="item.images && item.images.img"
                :src="getImageView(item.images.img)"
                alt="logo"
              />
              <img
                v-else
                width="140"
                alt="logo"
                src="https://gw.alipayobjects.com/zos/rmsportal/mqaQswcyDLcXyDKnZfES.png"
              />
            </div>
          </a-col>
          <a-col :span="19">
            <h3>{{item.articleTitle}}</h3>
            <div class="statis">点击数 :<span>{{item.hits}}</span> · 评论数 :<span>{{item.comment}}</span> · 点赞数 :<span>{{item.praise}}</span>  · 收藏数 :<span>{{item.collect}}</span></div>
            <a-tag color="blue">{{item.toPosition_dictText}}</a-tag><a-tag>{{item.status_dictText}}</a-tag>
            <p class="mt-10">{{item.createDate}}</p>
          </a-col>
        </a-row>

        <template slot="extra">
          <div class="handle_area">
            <span @click="handleEdit(item.id)">
              <a-icon type="edit" />修改
            </span>
            <br />
            <span @click="handleDelete(item.id)" style="color: red">
              <a-icon type="delete" />删除
            </span>
          </div>
        </template>
      </a-list-item>
    </a-list>
    <open-Video ref="openVideo"></open-Video>
  </div>
</template>

<script>
import { httpAction, postAction, getAction, deleteAction } from '@/api/manage'
import { likeAll } from '@/utils/util' // base filter
// import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import openVideo from './modules/videoOpenModal'

export default {
  name: 'ArticleList',
  // mixins: [JeecgListMixin],
  components: {
    openVideo
  },
  data() {
    return {
      description: '文章信息管理页面',
      dataSource: [],
      loading: false,
      // 表头
      pagination: {
        pageSize: 10,
        pageNo: 1,
        onChange: page => {
          console.log(page)
          this.pagination.pageNo = page
          this.getarticleList()
        }
      },
      url: {
        list: '/article/article/list',
        delete: '/article/article/delete',
        deleteBatch: '/article/article/deleteBatch',
        exportXlsUrl: 'article/article/exportXls',
        importExcelUrl: 'article/article/importExcel',
        imgerver: window._CONFIG['imageViewURL']
      },
      statusType: {
        type_0: 0,
        type_1: 1,
        type_2: 2,
        type_3: 3,
        type_4: 4
      },
      search_title: '',
      status: ''
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
    getarticleList() {
      this.loading = true
      let param = {
        articleType: 1,
        status: this.status,
        articleTitle: likeAll(this.search_title),
        pageNo: this.pagination.pageNo,
        pageSize: this.pagination.pageSize
      }
      console.log(param)
      getAction(this.url.list, param).then(res => {
        console.log(res)
        if (res.success) {
          res.result.records.forEach((item, index) => {
            if (item.images) item.images = JSON.parse(item.images)
          })
          this.dataSource = res.result.records
          this.pagination.total = res.result.total
          this.loading = false
        }
      })
    },
    //删除
    handleDelete(id) {
      if (!this.url.delete) {
        this.$message.error('请设置url.delete属性!')
        return
      }
      var that = this
      this.$confirm({
        title: '确认删除这条视频吗?',
        okText: '确认',
        okType: 'danger',
        cancelText: '取消',
        onOk() {
          deleteAction(that.url.delete, { id: id }).then(res => {
            if (res.success) {
              // that.$message.success(res.message);
              if (that.dataSource.length > 0) {
                for (let i = 0; i < that.dataSource.length; i++) {
                  if (that.dataSource[i] == id) {
                    that.dataSource.splice(i, 1)
                    break
                  }
                }
              }
              that.getarticleList()
            } else {
              // that.$message.warning(res.message);
            }
          })
        },
        onCancel() {
          console.log('Cancel')
        }
      })
    },
    //修改
    handleEdit(id) {
      this.$router.replace({
        path: '/modules/video/videoPost',
        name: 'modules-video-videoPost',
        query: { id: id }
      })
    },
    statusChange(e) {
      console.log(e)
      this.status = e.target.value
      this.getarticleList()
    },
    formatDuring(ms) {
      let min = Math.floor((ms / 1000000/60) )//分钟

      let sec = Math.floor((ms / 1000000))//秒

      return min +':'+ sec
    },
    toTheVideo(video) {
      video = this.getImageView(video)
      this.$refs.openVideo.getVideoUrl(video)
      this.$refs.openVideo.visible = true
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

  .search_title input {
    width: 200px;
  }

</style>