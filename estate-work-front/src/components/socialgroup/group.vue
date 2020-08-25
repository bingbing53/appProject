<template>
  <div>
    <!-- <van-button type="info" @click="toaddGroup">添加社工小组</van-button> -->
    <div v-for="(item,index) in myRootList">
      <div @click="toDetail(item.code,index,item.group_name)">
        <van-row class="Bline pd-5 bgcw2">
          <van-col span="21">
            <p class="f-16 h_name h_world ellipsis">{{item.group_name}}</p>
          </van-col>
          <van-col span="3">
            <van-icon class="h_name c-999" name="arrow" />
          </van-col>
        </van-row>
      </div>
    </div>
  </div>
</template>
<script>
import group from "@/api/socialgroup/group";
export default {
  data() {
    return {
      code: "",
      rootList: [],
      myRootList: []
    };
  },
  methods: {
    //添加社工小组
    toaddGroup(){
        this.$router.push({
        path: `/addgroup`,
       
      });
    },
    //去小组详情页面
    toDetail(code,idx,name) {
    //   console.log(item+"======="+idx);
      this.$router.push({
        path: `/groupDetail`,
        query:{
            code:code,
            name:name
        }
      });
    },
    //获取全部的社工小组
    async getWillCategrolyList() {
      let _this = this;
      let res = await group.getWillCategrolyList(this.code);

      this.rootList = res;
      this.myRootList = [];
      res = JSON.parse(res);
      res.forEach(function(item, index) {
        _this.myRootList.push(item);
      });
    }
  },
  mounted() {
    this.getWillCategrolyList();

  }
};
</script>
<style scoped>
.h_name {
  height: 10.664vw;
  line-height: 10.664vw;
}
.h_world {
  text-indent: 1.5em;
}
</style>



