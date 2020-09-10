import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import qs from "qs";
import BScroll from "better-scroll";

import Tap from "v-tap";
import "font-awesome/css/font-awesome.min.css";

import "./assets/styles/common.styl";
import "./style/normalize.styl";
import "./style/reset.styl";
import "./style/common.styl";
import "./style/ui.styl";
import vuePicturePreview from "vue-picture-preview";
import VueWechatTitle from "vue-wechat-title";
import common from "./api/common.js";
Vue.prototype.common = common;
window.token = common.token;

Vue.use(VueWechatTitle);
Vue.use(vuePicturePreview);
Vue.prototype.qs = qs;
Vue.config.productionTip = false;
Vue.use(Tap);
import {
  IndexBar,
  IndexAnchor,
  Search,
  ImagePreview,
  Tag,
  Button,
  Row,
  Col,
  Card,
  Swipe,
  SwipeItem,
  Lazyload,
  List,
  PullRefresh,
  Field,
  Picker,
  NavBar,
  Tab,
  Tabs,
  Tabbar,
  TabbarItem,
  Checkbox,
  CheckboxGroup,
  SubmitBar,
  Toast,
  Image,
  Cell,
  CellGroup,
  NoticeBar,
  Icon,
  Dialog,
  GoodsAction,
  GoodsActionButton,
  uploader,
  Area,
  Popup,
  RadioGroup,
  Radio,
  Collapse,
  CollapseItem,
  DropdownMenu,
  DropdownItem,
  SwitchCell,
  ActionSheet,
  Stepper,
  Grid,
  GridItem,
  Sticky,
  Divider,
  Switch,
  DatetimePicker,
  Pagination,
} from "vant";
Vue.use(Button)
  .use(Row)
  .use(Col)
  .use(Swipe)
  .use(SwipeItem)
  .use(Lazyload)
  .use(List)
  .use(IndexBar)
  .use(IndexAnchor)
  .use(Field)
  .use(Search)
  .use(ImagePreview)
  .use(Tag)
  .use(Picker)
  .use(NavBar)
  .use(Card)
  .use(Tab)
  .use(Tabs)
  .use(Tabbar)
  .use(TabbarItem)
  .use(Checkbox)
  .use(CheckboxGroup)
  .use(SubmitBar)
  .use(Toast)
  .use(NoticeBar)
  .use(Icon)
  .use(Dialog)
  .use(Image)
  .use(Cell)
  .use(CellGroup)
  .use(GoodsAction)
  .use(PullRefresh)
  .use(GoodsActionButton)
  .use(uploader)
  .use(Area)
  .use(Popup)
  .use(RadioGroup)
  .use(Radio)
  .use(Collapse)
  .use(Grid)
  .use(GridItem)
  .use(Sticky)
  .use(Divider)
  .use(Switch)
  .use(DatetimePicker)
  .use(Pagination)
  .use(CollapseItem)
  .use(DropdownMenu)
  .use(DropdownItem)
  .use(SwitchCell)
  .use(ActionSheet)
  .use(Stepper);

router.beforeEach((to, from, next) => {
  /* 路由发生变化修改页面title */
  if (to.meta.title) {
    document.title = to.meta.title;
  }
  // if (store.getters.token) {
  //   next();
  // } else {
  store.dispatch("init").then(() => {
    next();
  });
  // }
});

new Vue({
  router,
  store,
  render: (h) => h(App),
}).$mount("#app");
