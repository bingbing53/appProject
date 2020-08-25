<template>
  <div>
    
    这个是测试页面<br><br>
    <!-- <router-link to="/invest"> 跳转居民调查页面</router-link> <br> <br> -->
    <router-link :to="{ path:'/invest', query: {type:1}}">跳转居民调查页面</router-link>
    <br> <br> 
    <router-link :to="{path:'/publicopinion',query: {type:0}}">跳转民情民意页面</router-link> 
    <br> <br>
     <router-link to="/license">隐私政策</router-link> 
    <br> <br>
    <router-link :to="{ path:'/articleDetail', query: {id:'b184c49f677d1a6101677d4035c90015'}}">文章详情 </router-link>
    <!-- <router-link :to="{ path:'/articleDetail', query: {id:'ff8080816c4cfe62016c4d3f28520011'}}">文章视频详情 </router-link> -->
    <br> <br>
    <router-link to="/workhistory">工作记录 </router-link>
    <br> <br>
    <router-link to="/group">社工小组</router-link>
    <br> <br>
    <router-link to="/mycollect">我的收藏</router-link>
    <br> <br>
        <router-link to="/download">下载APP</router-link> 

<van-list
  v-model="loading"
  :finished="finished"
  finished-text="没有更多了"
  @load="onLoad"
>
  <van-cell
    v-for="item in list"
    :key="item"
    :title="item"
  />
</van-list>

 </div>
</template>
<script>

export default {
  data(){
    return{
         list: [],
      loading: false,
      finished: false

    }
  },
  methods:{
      onLoad() {
      // 异步更新数据
      setTimeout(() => {
        for (let i = 0; i < 10; i++) {
          this.list.push(this.list.length + 1);
        }
        // 加载状态结束
        this.loading = false;

        // 数据全部加载完成
        if (this.list.length >= 40) {
          this.finished = true;
        }
      }, 500);
    }

  }
  
}
</script>

<style lang="stylus" scoped>

</style>

