<template>
  <div class="container">

    <!-- 列表搜索区域开始 -->
    <div class="list_search">
      <div>
        <span class="mr-10 f-14 c-999">状态</span>
        <a-radio-group defaultValue="statusType.type_2" buttonStyle="solid" v-model="status" @change="statusChange">
          <a-radio-button :value="statusType.type_0">已保存</a-radio-button>
          <a-radio-button :value="statusType.type_1">审核中</a-radio-button>
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
            <a-tag color="blue">{{item.sysOrgCode_dictText}}</a-tag>
            <a-tag color="green">{{item.verifyState_dictText}}</a-tag>
            <a-tag>{{item.activityState_dictText}}</a-tag>
            <a-tag @click="verifyInfo(item.id)"><a-icon type="info-circle" /> 审核信息</a-tag>
            <a-tag v-if="item.verifyState != 4" @click="generateSignCode(item)">
              <a-icon type="qrcode"/> 生成签到码
            </a-tag>
            <a-tag v-if="item.verifyState != 4" @click="registerList(item)">
              <a-icon type="unordered-list" /> 已报名列表
            </a-tag>
            <!--<a-tag>{{item.activityType_dictText}}</a-tag>-->
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
            <a-tag color="blue">{{item.sysOrgCode_dictText}}</a-tag>
            <a-tag color="green">{{item.verifyState_dictText}}</a-tag>
            <a-tag>{{item.activityState_dictText}}</a-tag>
            <a-tag @click="verifyInfo(item.id)"><a-icon type="info-circle" /> 审核信息</a-tag>
            <a-tag v-if="item.verifyState != 4" @click="generateSignCode(item)">
              <a-icon type="qrcode"/> 生成签到码
            </a-tag>
            <a-tag v-if="item.verifyState != 4" @click="registerList(item)">
              <a-icon type="unordered-list" /> 已报名列表
            </a-tag>
            <p class="mt-10">{{item.createDate}}</p>
          </a-col>
        </a-row>
        <template slot="extra" v-if="item.verifyState != 4">
          <div class="handle_area">
            <span @click="handleEdit(item.id)">
              <a-icon type="edit" /> 修改
            </span>
            <br />
            <span @click="handleDelete(item.id)" style="color:red">
              <a-icon type="delete" /> 删除
            </span>
          </div>
        </template>
      </a-list-item>
    </a-list>

    <!-- 表单区域 -->
    <!--<activity-modal ref="modalForm" @ok="modalFormOk"></activity-modal>-->
    <activity-code-modal :codeId="signCode" :trainName="activityName" ref="codeModal"></activity-code-modal>

    <activity-register ref="activityRegisterList"></activity-register>
  </div>
</template>

<script>
  import ActivityModal from './modules/ActivityModal'
  import { likeAll } from '@/utils/util' // base filter
  import { httpAction, postAction, getAction, deleteAction } from '@/api/manage'
  import ActivityCodeModal from "./modules/ActivityCodeModal";
  import ActivityRegister from "./modules/ActivityRegisterList";

  export default {
    name: "ActivityList",
    // mixins:[JeecgListMixin],
    components: {
      ActivityRegister,
      ActivityCodeModal,
      ActivityModal
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
          list: "/cms/activity/list",
          delete: "/cms/activity/delete",
          deleteBatch: "/cms/activity/deleteBatch",
          imgerver: window._CONFIG['imageViewURL'],
          verifyInfo:'/cms/activity/verifyInfo',
          generateSignCode:'/cms/activity/generateCodeById'
        },
        statusType: {
          type_0: 0,
          type_1: 1,
          type_2: 2,
          type_3: 3,
          type_4: 4
        },
        status:2,
        search_title:'',
        activityName:'',
        signCode:''
    }
  },
  mounted() {
    this.getActivityList()
  },
  methods: {
    //获取报名人列表
    registerList(item){
      this.$refs.activityRegisterList.show(item.id);
    },
    //生成签到码
    generateSignCode(item){
      let param = {
        id:item.id,
        type:'1'
      }
      getAction(this.url.generateSignCode, param).then(res => {
        if (res.success) {
          this.$refs.codeModal.show(res.result,item.title);
        }
      })
    },
    getImageView: function(image) {
      return this.url.imgerver + '/' + image
    },
    statusChange(e) {
      this.status = e.target.value
      this.getActivityList()
    },
    //审核信息
    verifyInfo(id){

      let param = {
        id:id
      }
      getAction(this.url.verifyInfo, param).then(res => {
        if (res.success) {
          this.$info({
            title: '审核信息',
            content:  res.result.verifyDes,
            onOk() {},
          });
        }
      })
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