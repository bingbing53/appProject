import Vue from 'vue'
import router from './router'
import store from './store'
import NProgress from 'nprogress' // Progress 进度条
import 'nprogress/nprogress.css'// Progress 进度条样式
import { Message } from 'element-ui'
import { getToken } from '@/utils/auth' // 验权
import { ACCESS_TOKEN } from '@/store/mutation-types'
import { generateIndexRouter } from "@/utils/util"

const whiteList = [] // 不重定向白名单
router.beforeEach((to, from, next) => {
  NProgress.start()
  if (Vue.ls.get(ACCESS_TOKEN)) {
    if (store.getters.permissionList == undefined || store.getters.permissionList.length === 0) {
      store.dispatch('GetPermissionList').then(res => { 
        const menuData = res.result.menu;
        if (menuData === null || menuData === "" || menuData === undefined) {
          return;
        }
        let constRoutes = [];
        constRoutes = generateIndexRouter(menuData);
        // 添加主界面路由
        store.dispatch('UpdateAppRouter',  { constRoutes }).then(() => {
          router.options.routes = store.getters.addRouters;
          router.addRoutes(store.getters.addRouters)
          const redirect = decodeURIComponent(from.query.redirect || to.path)
          if (to.path === redirect) {
            next({ ...to, replace: true })
          } else {
            // 跳转到目的路由
            next({ path: redirect })
          }
        })
      }).catch((err) => {
        console.log(err);
        // store.dispatch('Logout').then(() => {
        //   next({ path: '/user/login', query: { redirect: to.fullPath } })
        // })
      });
    } else {
      next();
    }
  } else {
    if (whiteList.indexOf(to.path) !== -1) {
      next()
    } else {
      next('/login')
      NProgress.done()
    }
  }
})

router.afterEach(() => {
  NProgress.done() // 结束Progress
})
