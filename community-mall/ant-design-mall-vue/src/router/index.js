import Vue from 'vue'
import Router from 'vue-router'
import { constantRouterMap } from '@/config/router.config'
Vue.use(Router)

export default new Router({
  // mode: 'history', //后端支持可开
  scrollBehavior: () => ({y: 0}),
  routes: constantRouterMap
})

