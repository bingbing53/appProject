<template>
  <a-modal title="查看二维码"
           :visible="visible"
           :centered="true"
           :maskClosable="false"
           :width="500"
           destroyOnClose
           @cancel="handleCancel">
    <a-row :gutter="24"
           id="printContainer" style="text-align: center">
      <h3 style="margin: 12px 36px;">活动名称：{{ name }}</h3>
      <div id="qrcode" ref="qrcode" style="margin-left: 100px;"></div>

    </a-row>
    <template slot="footer">
      <a-button type="primary"
                @click="hanleDown">下载</a-button>
      <a-button key="back"
                @click="handleCancel">关闭</a-button>
    </template>
  </a-modal>
</template>

<script>
    import QRCode from 'qrcodejs2'
    export default {
      name: "ActivityCodeModal",
      data () {
        return {
          qrcode: '',
          visible:false,
          code:'',
          name:''
        }
      },
      created () {

      },
      methods: {
        show(code,name){
          this.code = code;
          this.name = name;
          this.visible = true;
          this.$nextTick(function () {
            this.init()
          })
        },
        // 生成二维码
        init () {
          // 为了防止重复生成二维码，使用置空进行控制
          document.getElementById('qrcode').innerHTML = ''
          // 设置二维码内容  显示内容(text所指向内容)必须是UTF-8编码格式。
          const content = this.code
          this.qrcode = new QRCode('qrcode', {
            width: 300,
            height: 300,
            colorDark: '#000',
            colorLight: '#fff',
            correctLevel: QRCode.CorrectLevel.L, // 容错率，L/M/H
            text: content
          })
        },
        handleCancel () {
          this.visible = false;
        },
        // 下载二维码
        hanleDown () {
          const imgs = document.getElementById('qrcode').getElementsByTagName('img')
          const a = document.createElement('a')
          a.download = this.trainName + new Date().getTime() || '一期一档二维码'
          a.href = imgs[0].src
          document.body.appendChild(a)
          a.click()
          document.body.removeChild(a)
        }
      }
    }
</script>

<style scoped>

</style>