<template>
  <a-modal
    title="参数配置"
    :width="modalWidth"
    :visible="visible"
    :confirmLoading="confirmLoading"
    @ok="handleSubmit"
    @cancel="close"
    cancelText="关闭"
  >
    <device-ParamDictList ref="DeviceParamDictList" :deviceName="names" :idValue="ids"></device-ParamDictList>
  </a-modal>
</template>

<script>
import DeviceParamDictList from '../DeviceParamDictList'
export default {
  name: 'DeviceParamDictListWindow',
  components: {
    DeviceParamDictList
  },
  data() {
    return {
      visible: false,
      confirmLoading: false,
      names: '',
      ids: ''
    }
  },
  computed: {
    modalWidth() {
      return 1000
    }
  },
  methods: {
    show() {
      this.visible = true
      this.$nextTick(() => {
        this.$refs.DeviceParamDictList.loadDatas()
      })
    },
    getMain(data) {
      // console.log(data);
      this.names = data.id
      this.ids = data.id
    },
    handleSubmit() {
      this.$emit('ok', this.cron)
      this.close()
      this.visible = false
    },
    close() {
      this.visible = false
    }
  }
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>