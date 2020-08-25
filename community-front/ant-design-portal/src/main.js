import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import axios from 'axios'; /* 引入axios进行地址访问*/
// import './api/setAxios';
import 'ant-design-vue/dist/antd.css'
import './assets/css/common.css'
import './assets/css/style.css'
import BaiduMap from 'vue-baidu-map'

import Antd from 'ant-design-vue';
import globalVariable from '../src/api/global_variable'
Vue.prototype.GLOBAL = globalVariable;
// import {Menu} from 'ant-design-vue';
// Vue.use(Menu);
Vue.use(Antd);
Vue.prototype.$http = axios;
axios.defaults.baseURL = 'https://api.dev.shequyijia.cn/community-user/portal'
Vue.use(BaiduMap, {
  // ak 是在百度地图开发者平台申请的密钥 详见 http://lbsyun.baidu.com/apiconsole/key */
  ak: 'xQvLe5mdn7hGbodfSEwV3UBzdGBow0g4'
})

Vue.config.productionTip = false;

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount("#app");
