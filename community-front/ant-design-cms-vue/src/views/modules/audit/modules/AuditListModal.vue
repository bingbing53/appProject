<template>
  <a-modal title="审核" v-model="visible" width="800px">
    <template slot="footer">
      <a-button @click="handleCancel">取消</a-button>
      <a-button @click="handleOk(0)">未通过</a-button>
      <a-button type="primary" @click="handleOk(1)">通过</a-button>
    </template>
    <div>
      <h3 class="auditTitle">{{auditData.title}}</h3>
      <div class="creat">
        <span>发布时间 : {{auditData.createTime}}</span> |
        <span>作者 : {{auditData.createName}}</span>
      </div>
      <a-divider dashed />
      <div v-if="auditData.articleType == '1'">
        <p class="audit_des">{{auditData.des}}</p>
        <video :src="getImageView(auditData.images.video)" controls="controls" width="100%" id="my_video"></video>
      </div>
      <div v-else-if="auditData.articleType == '0'">
        <p class="audit_des" v-html="auditData.content"></p>
      </div>
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
      confirmLoading: false,
      auditData: '',
      content: '',
      url: {
        imgerver: window._CONFIG['imageViewURL'],
        audit: '/article/article/verify',
        detail: '/article/article/queryById'
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
        status: 0,
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
    showModal(item) {
      this.visible = true
    },
    getAuditData(item) {
      console.log(JSON.stringify(item))
      if (item.articleType == '1') {
        this.auditData = item
      } else if (item.articleType == '0') {
        this.getDetailByID(item.id)
      }
    },
    handleOk(status) {
      let param
      if (status == 0) {
        this.visible_comment = true
      } else if (status == 1) {
        param = {
          id: this.auditData.id,
          status: status
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
    handleCancel() {
       let video = document.getElementById('my_video')
     if(video) video.pause()
      this.visible = false
    },
    getImageView: function(image) {
      return this.url.imgerver + '/' + image
    },
    //根据ID获取详情数据
    getDetailByID(id) {
      getAction(this.url.detail, { id: id }).then(res => {
        if (res.success) {
          this.auditData = res.result
        }
      })
    }
  },
  mounted() {}
}
</script>

<style>
.auditTitle,
.creat {
  text-align: center;
}
.audit_des {
  line-height: 28px;
  text-indent: 2em;
  width: 100%;
  padding:10px;
  margin:10px;
  overflow: hidden;
}
</style>