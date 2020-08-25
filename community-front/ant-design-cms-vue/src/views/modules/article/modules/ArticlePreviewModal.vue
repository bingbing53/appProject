<template>
  <div>
    <a-modal
      class="preview"
      title
      width="400px"
      style="top: -50px;"
      :visible="visible"
      :closable="false"
      @ok="handleOk"
      :confirmLoading="confirmLoading"
      @cancel="handleCancel"
    >
      <div class="container">
        <div class="bg_phone">
          <div class="bg_phone2">
            <div class="html_scroll">
              <h3>{{html_title}}</h3>
              <p class="html_container" v-html="html_content"></p>
            </div>
          </div>
        </div>
      </div>
    </a-modal>
  </div>
</template>

<script>
export default {
  name: 'articlePreview',
  data() {
    return {
      ModalText: 'Content of the modal',
      visible: false,
      confirmLoading: false,
      html_content: '',
      html_title: ''
    }
  },
  methods: {
    showModal() {
      this.visible = true
    },
    handleOk(e) {
      this.ModalText = 'The modal will be closed after two seconds'
      this.confirmLoading = true
      setTimeout(() => {
        this.visible = false
        this.confirmLoading = false
      }, 2000)
    },
    handleCancel(e) {
      console.log('Clicked cancel button')
      this.visible = false
    },
    getContent(content, title) {
      console.log(title)
      this.html_content = content
      this.html_title = title
    }
  }
}
</script>

<style>
.preview .ant-modal-header {
  background: transparent;
}
.preview .ant-modal-body {
  background: transparent;
}
.preview .ant-modal-content {
  background: transparent;
  box-shadow: none;
}
.preview .ant-modal-footer {
  border-top: 1px solid transparent;
  visibility: hidden;
}
.preview .ant-modal-mask {
  z-index: 9999;
}
.preview .ant-modal-wrap {
  z-index: 10000;
}
.container {
  /* height: 500px; */
  background: transparent;
  padding-top:30px;
}
.bg_phone {
  width: 320px;
  min-height: 620px;
  margin: 0 auto;
  background: url(../../../../assets/phone.png) no-repeat;
  background-size: contain;
  overflow-y: hidden;
  padding-top:80px;
  font-size: 14px !important;
}
.bg_phone2{
 height: 270px;
 overflow:auto;
 width: 257px;
 min-height:444px;
 margin:0 auto;
 background-color: #fff;
}
.bg_phone2::-webkit-scrollbar {
  display: none;
}
.html_scroll {
  background: #fff;
  /* margin: 89px 35px 50px 37px; */
}
.html_scroll::-webkit-scrollbar {
  display: none;
}
.html_scroll h3 {
  padding-top: 20px;
  padding-left: 10px;
  padding-right: 10px;
}
.html_container {
  padding: 10px;
  background: #fff;
  width: 100%;
  /* overflow: hidden; */
}
.html_container img {
  max-width: 100%!important;
  height: auto!important;
}
</style>