<template>
  <a-modal :visible="visible" :closable="false" width="800px" style="top: 20px;">
    <template slot="footer">
      <a-button key="back" @click="handleCancel">关闭</a-button>
    </template>
    <div>
      <video :src="videoUrl" controls="controls" width="100%" id="my_video"></video>
    </div>
  </a-modal>
</template>

<script>
export default {
  name: 'openVideo',
  data() {
    return {
      visible: false,
      videoUrl: ''
    }
  },
  mounted: {},
  methods: {
    handleCancel() {
      let video = document.getElementById('my_video')
      video.pause()
      this.visible = false
    },
    getVideoUrl(video) {
      console.log(video)
      this.videoUrl = video
    }
    // handleOk(e) {
    //   this.confirmLoading = true
    //   setTimeout(() => {
    //     this.visible = false
    //     this.confirmLoading = false
    //   }, 2000)
    // }
  }
}
</script>

<style>
</style>