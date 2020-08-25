<template>
  <div id="app">
    <keep-alive>
      <router-view v-if="$route.meta.keepAlive"></router-view>
    </keep-alive>

    <router-view v-if="!$route.meta.keepAlive"></router-view>
  </div>
</template>

<script>
export default {
  name: "app",
 
};
</script>
<style lang="stylus">
@import './style/normalize.styl';
@import './style/reset.styl';
@import './style/common.styl';

#app {
  // font-size: 4.266vw;
  color: #000;
  font-family: -apple-system, BlinkMacSystemFont, 'PingFang SC', 'SF UI Text', 'Helvetica Neue', STHeiti, 'Microsoft Yahei', Tahoma, Simsun, sans-serif;
}
body{
   background-color:#eee;
}
</style>
