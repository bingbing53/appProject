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
      <a-list-item slot="renderItem" slot-scope="item, index" key="item.articleTitle">
        <a-row class="left_col" v-if="item.images">
          <a-col :span="5">
            <div class="scale_container">
              <img
                :src="getImageView(item.images)"
                width="140"
                height="86.5"
                alt="logo"
              />
            </div>
          </a-col>
          <a-col :span="19">
            <h3>{{item.articleTitle}}</h3>
            <div class="statis">
              点击数 :
              <span>{{item.hits}}</span> · 评论数 :
              <span>{{item.comment}}</span> · 点赞数 :
              <span>{{item.praise}}</span> · 收藏数 :
              <span>{{item.collect}}</span>
            </div>
            <a-tag color="blue">{{item.toPosition_dictText}}</a-tag>
            <a-tag>{{item.status_dictText}}</a-tag>
            <p class="mt-10">{{item.createDate}}</p>
          </a-col>
        </a-row>
        <a-row class="left_col" v-else>
          <a-col :span="24">
            <h3>{{item.articleTitle}}</h3>
            <div class="statis">
              点击数 :
              <span>{{item.hits}}</span> · 评论数 :
              <span>{{item.comment}}</span> · 点赞数 :
              <span>{{item.praise}}</span> · 收藏数 :
              <span>{{item.collect}}</span>
            </div>
            <a-tag color="blue">{{item.toPosition_dictText}}</a-tag>
            <a-tag>{{item.status_dictText}}</a-tag>
            <p class="mt-10">{{item.createDate}}</p>
          </a-col>
        </a-row>
        <template slot="extra">
          <div class="handle_area">
            <span @click="handleEdit(item.id)">
              <a-icon type="edit" />修改
            </span>
            <br />
            <span @click="handleDelete(item.id)" style="color:red">
              <a-icon type="delete" />删除
            </span>
          </div>
        </template>
      </a-list-item>
    </a-list>
  </div>
</template>

<script>
import { filterObj } from '@/utils/util'
import ArticleModal from './modules/ArticleModal'
import { likeAll } from '@/utils/util' // base filter
import { httpAction, postAction, getAction, deleteAction } from '@/api/manage'
// import { JeecgListMixin } from '@/mixins/JeecgListMixin'

export default {
  name: 'ArticleList',
  // mixins: [JeecgListMixin],
  components: {
    ArticleModal
  },
  data() {
    return {
      description: '文章信息管理页面',
      dataSource: [],
      pagination: {
        pageSize: 10,
        pageNo: 1,
        onChange: page => {
          console.log(page)
          this.pagination.pageNo = page
          this.getarticleList()
        }
      },
      loading: false,
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
    statusChange(e) {
      console.log(e)
      this.status = e.target.value
      this.getarticleList()
    },
    getarticleList() {
      this.loading = true
      let param = {
        articleType: 0,
        status: this.status,
        pageNo: this.pagination.pageNo,
        pageSize: this.pagination.pageSize,
        articleTitle: likeAll(this.search_title),
      }
      console.log(JSON.stringify(param))
      getAction(this.url.list, param).then(res => {
        if (res.success) {
          res.result.records.forEach((item, index) => {
            if (item.images) item.images = item.images.split(',')[0]
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
        title: '确认删除这条文章吗?',
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
      console.log(this.$router)
      this.$router.replace({
        path: '/modules/article/articlePost',
        name: 'modules-article-articlePost',
        query: { id: id } 
      })
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