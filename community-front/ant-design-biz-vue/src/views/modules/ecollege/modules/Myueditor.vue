<template>
  <div v-show="showEditor">
    <vue-neditor-wrap v-model="content" :config="myConfig" :destroy="false" @ready="ready"></vue-neditor-wrap>
  </div>
</template>

<script>
import VueNeditorWrap from 'vue-neditor-wrap'
export default {
  name: 'Myueditor',
  components: {
    VueNeditorWrap
  },
  data() {
    return {
      showEditor:false,
      content: '',
      myConfig: {
        // 如果需要上传功能,找后端小伙伴要服务器接口地址
        serverUrl: window._CONFIG['ssoPrefixUrl'] + '/sys/common/uploads',
        // 你的UEditor资源存放的路径,相对于打包后的index.html
        // UEDITOR_HOME_URL: '/'+window._CONFIG['module']+'/NEditor/',
        UEDITOR_HOME_URL: '/NEditor/',
        // 编辑器不自动被内容撑高
        autoHeightEnabled: true,
        // 初始容器高度
        initialFrameHeight: 400,
        // 初始容器宽度
        initialFrameWidth: '100%',
        // 关闭自动保存
        enableAutoSave: false
      }
    }
  },
  methods: {
    ready(editorInstance) {
      console.log(`编辑器实例${editorInstance.key}: `, editorInstance)
      this.showEditor = true;
    }
  }
}
</script>

<style>
.edui-editor {
  z-index: 100px !important;
}
</style>