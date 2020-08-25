<template>
  <a-modal title="活动审核" v-model="visible" width="800px">
    <template slot="footer">
      <a-button @click="handleCancel">取消</a-button>
      <a-button @click="handleOk(0)">未通过</a-button>
      <a-button type="primary" @click="handleOk(1)">通过</a-button>
    </template>
    <div>
      <h3 class="auditTitle">{{auditData.title}} <a-tag color="green" v-if="!!auditData.summaryArr && auditData.summaryArr.length > 0" v-for="item in auditData.summaryArr">{{item}}</a-tag></h3>
      <div class="creat1">
        <!--<span>发布时间 : {{auditData.createDate}}</span> |-->
        <!--<span>作者 : {{auditData.createName}}</span>-->

        <div>
          活动时间：{{auditData.startTime}} ~ {{auditData.endTime}}</div>
        <div>
          活动地点：{{auditData.location}}
        </div>
        <div>
          活动联系人：{{auditData.contact}}   {{auditData.contactMobile}}
        </div>
        <div>
          限制报名人数：{{auditData.limitNum}}
        </div>
      </div>
      <a-divider dashed />
      <p class="audit_des" v-html="auditData.content"></p>
    </div>
    <a-modal title="提示" v-model="visible_comment" :maskClosable="false">
      <template slot="footer">
        <a-button @click="handleCancel_comment">取消</a-button>
        <a-button type="primary" :confirmLoading="confirmLoading" @click="handleOk_comment">确定</a-button>
      </template>
      <a-textarea placeholder="请输入不通过的原因" :rows="4" v-model="content" />
    </a-modal>
  </a-modal>
</template>

<script>
  import { httpAction, postAction, postActionvideo, getAction, postActionimg } from '@/api/manage'
export default {
  data() {
    return {
      visible: false,
      visible_comment: false,
      auditData:{},
      confirmLoading: false,
      content: '',
      url: {
        imgerver: window._CONFIG['imageViewURL'],
        audit: '/cms/activity/verify',
        detail: '/cms/activity/queryById'
      }
    }
  },
  methods: {
    handleCancel_comment() {
      this.visible_comment = false
      this.content = ''
    },
    handleOk_comment() {
      this.confirmLoading = true
      let params = {
        id: this.auditData.id,
        verifyState: 0,
        content: this.content
      }
      console.log(JSON.stringify(params))
      // return
      postAction(this.url.audit, params).then(res => {
        console.log(res)
        if (res.code == 200) {
          this.$message.info('操作成功!')
          this.confirmLoading = false
          this.visible_comment = false
          this.visible = false
          this.$emit('loadList', 1)
        }
      })
    },
    showModal() {
      this.visible = true
    },
    getAuditData(item) {
      console.log(JSON.stringify(item))
      this.getDetailByID(item.id)
    },
    //根据ID获取详情数据
    getDetailByID(id) {
      getAction(this.url.detail, { id: id }).then(res => {
        if (res.success) {
          if(!!res.result.summary){
            res.result.summaryArr = [];
            res.result.summaryArr = res.result.summary.split(',');
          }
          this.auditData = res.result
        }
      })
    },
    handleCancel() {
      this.visible = false
    },
    handleOk(status) {
      let param
      if (status == 0) {
        this.visible_comment = true
      } else if (status == 1) {
        param = {
          id: this.auditData.id,
          verifyState: status
        }
        console.log(JSON.stringify(param))
        // return
        postAction(this.url.audit, param).then(res => {
          console.log(res)
          if (res.code == 200) {
            this.$message.info('操作成功!')
            this.visible = false
            this.$emit('loadList', 1)
          }
        })

        this.visible = false
      }
    },
  },
  mounted() {}
}
</script>

<style>
</style>