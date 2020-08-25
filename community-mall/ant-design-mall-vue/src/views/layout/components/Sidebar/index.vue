<template>
  <scroll-bar>
    <div class="logo">
      <img src="~@/assets/logo.svg" alt="logo">
    </div>
    <el-menu
      mode="vertical"
      :show-timeout="200"
      :default-active="$route.path"
      :collapse="isCollapse"
      background-color="#304156"
      text-color="#bfcbd9"
      active-text-color="#409EFF"
      :unique-opened="true"
    >
      <sidebar-item :routes="routes"></sidebar-item>
    </el-menu>
  </scroll-bar>
</template>

<script>
import { mapGetters } from 'vuex'
import SidebarItem from './SidebarItem'
import ScrollBar from '@/components/ScrollBar'
import store from '@/store'

export default {
  components: { SidebarItem, ScrollBar },
  computed: {
    ...mapGetters([
      'sidebar'
    ]),
    routes() {
      // return store.getters.addRouters;
      return this.$router.options.routes
    },
    isCollapse() {
      return !this.sidebar.opened
    }
  }
}
</script>
<style lang="scss" scoped>
  /*缩小首页布 局顶部的高度*/
  $height: 59px;

  .logo {
    padding-left: 24px;
    height: $height !important;
    line-height: $height !important;
    box-shadow: none !important;
    transition: background 300ms;
  }
  .logo > img{
    height: 32px;
    display: inline-block;
    vertical-align: middle;
  }

</style>
