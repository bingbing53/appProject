<template>
  <div class="app-container">
    <div class="total-layout">
      <p>{{username}}，您好。如有特殊运营需求，欢迎致电垂询！</p>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import { ACCESS_TOKEN, USER_NAME,USER_INFO,USER_AUTH,SYS_BUTTON_AUTH } from '@/store/mutation-types'

export default {
  data() {
    return {
      username: Vue.ls.get(USER_NAME)
    }
  }
}
</script>

<style scoped>
  .app-container {
    margin-top: 40px;
    margin-left: 120px;
    margin-right: 120px;
  }
</style>
