<template>
  <div>
      <vue-neditor-wrap v-model="content" :config="myConfig" :destroy="false" @ready="ready"></vue-neditor-wrap>
  </div>
</template>

<script>
import VueNeditorWrap from 'vue-neditor-wrap'
export default {
    components: {
        VueNeditorWrap
    },
    data(){
        return{
            content:'',
            myConfig: { 
            // 如果需要上传功能,找后端小伙伴要服务器接口地址
            serverUrl: window._CONFIG['domianURL']+'/sys/common/upload',
            // 你的UEditor资源存放的路径,相对于打包后的index.html
            UEDITOR_HOME_URL: '/NEditor/',
            // 编辑器不自动被内容撑高
            autoHeightEnabled: false,
            // 初始容器高度
            initialFrameHeight: 240,
            // 初始容器宽度
            initialFrameWidth: '100%',
            // 关闭自动保存
            enableAutoSave: false
        },
        }
    },
    methods:{
        ready (editorInstance) {
                console.log(`编辑器实例${editorInstance.key}: `, editorInstance)
        }
    }
}
</script>

<style>

</style>