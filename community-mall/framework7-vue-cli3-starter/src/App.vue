<template>
  <f7-app :params="f7params">
    <f7-view id="main-view" url="/" main :pushState="true"></f7-view>
  </f7-app>
</template>

<script>
// Import Routes
import routesMall from "./router/routes_mall.js";
import routesEstate from "./router/routes_estate.js";
import routesCms from "./router/routes_cms.js";
const baseRoutes = [
];
export default {
  data() {
    return {
      // Framework7 parameters here
      f7params: {
        id: "io.framework7.testapp", // App bundle ID
        name: "Framework7", // App name
        theme: "ios", // Automatic theme detection
        // App routes
        routes: baseRoutes.concat(routesMall,routesEstate,routesCms), 
        touch: {
          disableContextMenu: false // 是否开启上下文联动
        },
        view: {
          stackPages: true,
          pushState: true,//开启页面路由的hash变化
          pushStateRoot: "", //根URL分隔符也可以使用       document.location.pathname.split('index.html')[0]
          pushStateSeparator: '#'     //pushStateRoot为空字符才能使用，网址 分隔符号 # !
        }
      }
    };
  },
  mounted(){
  }
};
</script>
<style scoped>
.framework7-root::-webkit-scrollbar {
    display: none!important;
}
</style>
