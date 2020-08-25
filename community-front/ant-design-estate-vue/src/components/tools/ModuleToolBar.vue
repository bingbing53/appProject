<template>
  <a-popover
    trigger="click"
    placement="bottomLeft"
    :autoAdjustOverflow="true"
    :arrowPointAtCenter="true"
    overlayClassName="header-notice-wrapper"
    @visibleChange="handleHoverChange"
    :overlayStyle="{ width: '400px', top: '50px' }">
    <template slot="content">
      <a-row type="flex" justify="space-around" align="middle">
        <a-col :span="8">

          <img src="~@/assets/module/用户管理.png" alt="logo" width="50%">
          <br>
          用户权限管理

        </a-col>
        <a-col :span="8">
          <a href="http://www.baidu.com">
          <img src="~@/assets/module/物业报修.png" alt="logo" width="50%">
          <br>
          物业管理
          </a>
        </a-col>
      </a-row>
    </template>
    <span class="header-notice">
      <a-badge>
        <a-icon style="font-size: 16px; padding: 4px" type="appstore" />
      </a-badge>
    </span>
  </a-popover>
</template>
<script>
  export default {
    name: "ModuleToolBar",
    data () {
      return {
        hovered: false,
      }
    },
    computed:{

    },
    created() {

    },
    methods: {
      handleHoverChange (visible) {
        this.hovered = visible;
      },

    }
  }
</script>

<style lang="scss" scoped>
  .a-row{
    text-align: center;
  }
</style>