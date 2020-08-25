<template>
  <el-dialog
    :title="title"
    :visible.sync="visible"
    width="50%"
    :before-close="handleCancel"
  >
    <div>
      <h3 class="auditTitle">{{record.titile}}</h3>
      <div class="creat">
        <span>发布时间 : {{record.sendTime}}</span>
      </div>
    </div>

    <hr style="height:0px; border-top:1px solid #ccc; border-right:0px; border-bottom:0px; border-left:0px; ">

    <span v-html="record.msgContent" class="article-content"></span>
  </el-dialog>
</template>

<script>
  export default {
    name: "SysAnnouncementModal",
    components: {
    },
    data () {
      return {
        title:"通知消息",
        record: {},
        labelCol: {
          xs: { span: 24 },
          sm: { span: 5 },
        },
        wrapperCol: {
          xs: { span: 24 },
          sm: { span: 16 },
        },
        visible: false,
        loading: false,
        bodyStyle:{
          padding: "0",
          height:(window.innerHeight*0.8)+"px",
          "overflow-y":"auto",

        },
        modelStyle:{
          width: '60%',
          style: { top: '20px' },
          fullScreen: false
        }
      }
    },
    created () {
    },
    methods: {
      detail (record) {
        this.visible = true;
        this.record = record;
      },
      handleCancel () {
        this.visible = false;
      },
      /** 切换全屏显示 */
      handleClickToggleFullScreen() {
        let mode = !this.modelStyle.fullScreen
        if (mode) {
          this.modelStyle.width = '100%'
          this.modelStyle.style.top = '20px'
        } else {
          this.modelStyle.width = '60%'
          this.modelStyle.style.top = '50px'
        }
        this.modelStyle.fullScreen = mode
      }
    }
  }
</script>
