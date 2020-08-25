import Vue from 'vue';
import 'core-js/modules/es.object.assign';
import App from './App';
import axios from 'axios';

// import store from './store';

import common from '@/api/common.js';
Vue.prototype.$commonUtils = common;

// import Framework7 from 'framework7/framework7.esm.bundle.js';
import Framework7 from 'framework7/framework7-lite.esm.bundle.js'
import Framework7Vue from 'framework7-vue/framework7-vue.esm.bundle.js';

// import 'framework7/css/framework7.bundle.min.css';
import 'framework7-icons'
import './css/icons.css';
import './css/app.css';
import './assets/iconfont/iconfont.css'

import globalVariable from '../src/api/global'
Vue.prototype.GLOBAL = globalVariable;

import '@babel/polyfill';
import Es6Promise from 'es6-promise'
Es6Promise.polyfill()

import {CountDown, NavBar,PullRefresh, List, Dialog,Card,DatetimePicker,Popup,Loading,Step, Steps,Sku,Rate,Row, Col,Field,ImagePreview, Tab, Tabs, GoodsAction,GoodsActionIcon,GoodsActionButton,DropdownMenu, DropdownItem,Button,Sidebar,SidebarItem,TreeSelect,Image,Search,Grid, GridItem,RadioGroup,Radio, Cell, CellGroup,Tag ,AddressList,AddressEdit,Area,Icon, Swipe, SwipeItem,Lazyload,Toast,Stepper,Divider,SubmitBar,Switch,Checkbox, CheckboxGroup  } from 'vant';
Vue.use(PullRefresh).use(CountDown).use(NavBar).use(List).use(Card).use(Dialog).use(DatetimePicker).use(Popup).use(Step).use(Steps).use(Sku).use(Rate).use(Row).use(Col).use(Field).use(ImagePreview).use(Tab).use(Tabs).use(GoodsAction).use(Button).use(Sidebar).use(SidebarItem).use(TreeSelect).use(Image).use(Search).use(Grid).use(GridItem).use(RadioGroup).use(Radio).use(Cell).use(CellGroup).use(Tag).use(AddressList).use(AddressEdit).use(Area).use(Icon).use(Checkbox).use(CheckboxGroup).use(Swipe).use(SwipeItem).use(Lazyload).use(Toast).use(Stepper).use(Divider).use(SubmitBar).use(Switch)
.use(GoodsActionIcon).use(GoodsActionButton).use(DropdownMenu).use(DropdownItem).use(Loading);

Vue.prototype.$axios = axios;
Framework7.use(Framework7Vue)
// require('./api/mock')
new Vue({
  el: '#app',
  template: '<app/>', 
  components: {
    // store,
    app: App,
  }
});
