<template>
  <div class="container">

    <!-- 列表搜索区域开始 -->
    <div class="list_search">
      <div>
        <span class="mr-10 f-14 c-999">状态</span>
        <a-radio-group :defaultValue="statusType.type_1" buttonStyle="solid" @change="statusChange">
          <!--<a-radio-button :value="statusType.type_0">已保存</a-radio-button>-->
          <a-radio-button :value="statusType.type_1">待审核</a-radio-button>
          <a-radio-button :value="statusType.type_2">审核通过</a-radio-button>
          <a-radio-button :value="statusType.type_3">审核不通过</a-radio-button>
          <a-radio-button :value="statusType.type_4">禁用</a-radio-button>
        </a-radio-group>
      </div>
      <div class="search_title mt-20">
        <span class="mr-10 f-14 c-999">活动标题</span>
        <a-input placeholder="请输入活动标题" v-model="search_title" @pressEnter="getActivityList" />
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
      <a-list-item slot="renderItem" slot-scope="item, index" key="item.title">
        <a-row class="left_col" v-if="item.posterUrl">
          <a-col :span="5">
            <div class="scale_container">
              <img
                :src="getImageView(item.posterUrl)"
                width="140"
                height="86.5"
                alt="logo"
              />
            </div>
          </a-col>
          <a-col :span="19">
            <h3>{{item.title}}</h3>
            <div class="statis">
              点击数 :
              <span>{{item.hits}}</span> · 评论数 :
              <span>{{item.comment}}</span> · 点赞数 :
              <span>{{item.praise}}</span> · 收藏数 :
              <span>{{item.collect}}</span>
            </div>
            <a-tag color="green">{{item.sysOrgCode_dictText}}</a-tag>
            <a-tag color="blue" v-if="item.departType == 0">社区活动</a-tag>
            <a-tag color="blue" v-if="item.departType == 1">物业活动</a-tag>
            <a-tag color="blue" v-if="item.departType == 2">商家活动</a-tag>
            <a-tag>{{item.activityState_dictText}}</a-tag>
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
            <a-tag color="green">{{item.sysOrgCode_dictText}}</a-tag>
            <a-tag color="blue" v-if="item.departType == 0">社区活动</a-tag>
            <a-tag color="blue" v-if="item.departType == 1">物业活动</a-tag>
            <a-tag color="blue" v-if="item.departType == 2">商家活动</a-tag>
            <a-tag>{{item.activityState_dictText}}</a-tag>
            <p class="mt-10">{{item.createDate}}</p>
          </a-col>
        </a-row>
        <template slot="extra">
          <div class="handle_area">
            <span @click="toAudit(item.id,item)" v-show="item.verifyState == '1'">
              <a-icon type="file-search" /> 审核
            </span>
            <br />
            <span @click="forbid(item.id)" v-show="item.verifyState == '2'" style="color: red">
              <a-icon type="stop" /> 禁用
            </span>
          </div>
        </template>
        <!--<template slot="extra">-->
          <!--<div class="handle_area">-->
            <!--<span @click="handleEdit(item.id)">-->
              <!--<a-icon type="edit" />修改-->
            <!--</span>-->
            <!--<br />-->
            <!--<span @click="handleDelete(item.id)" style="color:red">-->
              <!--<a-icon type="delete" />删除-->
            <!--</span>-->
          <!--</div>-->
        <!--</template>-->
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
  // import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import { likeAll } from '@/utils/util' // base filter
  import { httpAction, postAction, getAction, deleteAction } from '@/api/manage'
  import openAudit from './modules/AuditActivityModal'

  export default {
    name: "AuditActivityList",
    components: {
      openAudit
    },
    data () {
      return {
        description: '活动管理页面',
        dataSource: [],
        pagination: {
          pageSize: 10,
          pageNo: 1,
          onChange: page => {
            this.pagination.pageNo = page
            this.getActivityList()
          }
        },
        loading: false,
        // 表头
        url: {
          list: "/cms/activity/verifyList",
          delete: "/cms/activity/delete",
          deleteBatch: "/cms/activity/deleteBatch",
          imgerver: window._CONFIG['imageViewURL'],
          audit: '/cms/activity/verify'
        },
        statusType: {
          type_0: 0,
          type_1: 1,
          type_2: 2,
          type_3: 3,
          type_4: 4
        },
        search_title:'',
        status: 1,
        ids: '',
        visible_forbid: false,
        confirmLoading2: false,
        forbid_content: ''
      }
    },
    mounted() {
      this.getActivityList()
    },
    methods: {
      //去审核页面
      toAudit(id, item) {
        this.$refs.openAudit.showModal()
        this.$refs.openAudit.getAuditData(item)
      },
      getImageView: function(image) {
        return this.url.imgerver + '/' + image
      },
      statusChange(e) {
        this.status = e.target.value
        this.getActivityList()
      },
      loadStautsList(status) {
        this.getActivityList()
      },
      getActivityList(){
        this.loading = true
        let param = {
          // articleType: 0,
          verifyState: this.status,
          pageNo: this.pagination.pageNo,
          pageSize: this.pagination.pageSize,
          title: likeAll(this.search_title),
        }
        getAction(this.url.list, param).then(res => {
          if (res.success) {
            res.result.records.forEach((item, index) => {
              if (item.posterUrl) item.posterUrl = item.posterUrl.split(',')[0]
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
          title: '确认删除这个活动吗?',
          okText: '确认',
          okType: 'danger',
          cancelText: '取消',
          onOk() {
            deleteAction(that.url.delete, { id: id }).then(res => {
              if (res.success) {
                if (that.dataSource.length > 0) {
                  for (let i = 0; i < that.dataSource.length; i++) {
                    if (that.dataSource[i] == id) {
                      that.dataSource.splice(i, 1)
                      break
                    }
                  }
                }
                that.getActivityList()
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
          path: '/modules/activity/activityPost',
          name: 'modules-activity-activityPost',
          query: { id: id }
        })
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
          verifyState: 2,
          content: this.forbid_content
        }
        postAction(this.url.audit, param).then(res => {
          if (res.success) {
            this.$message.success('操作成功')
            this.getActivityList()
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