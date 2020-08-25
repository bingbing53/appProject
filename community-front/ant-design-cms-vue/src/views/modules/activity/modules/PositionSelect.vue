<template>
  <a-modal
    :title="title"
    :width="1000"
    :visible="visible"
    :confirmLoading="confirmLoading"
    style="top: 30px;"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭">
    <a-spin :spinning="confirmLoading">
      <baidu-map-position v-model="position"></baidu-map-position>
    </a-spin>
  </a-modal>
</template>

<script>
  import { httpAction } from '@/api/manage'
  import BaiduMapPosition from "@/components/map/BaiduMapPosition";
  export default {
    name: "PositionSelect",
    components: {
      BaiduMapPosition,
    },
    data () {
      return {
        title:"选择活动地址",
        visible: false,
        model: {},
        labelCol: {
          xs: { span: 24 },
          sm: { span: 5 },
        },
        wrapperCol: {
          xs: { span: 24 },
          sm: { span: 16 },
        },
        confirmLoading: false,
        position:{}
      }
    },
    created () {
    },
    methods: {
      show (record) {
        this.visible = true;
      },
      close () {
        this.$emit('close');
        this.visible = false;
      },
      handleOk () {
        this.$emit('ok',this.position);
        this.close()
      },
      handleCancel () {
        this.close()
      },
    }
  }
</script>

<style lang="less" scoped>

</style>