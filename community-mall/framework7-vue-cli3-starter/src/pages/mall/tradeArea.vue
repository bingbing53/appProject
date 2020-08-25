<template>
  <f7-page class="trade">
    <van-nav-bar class="myNavBare" title="分类" left-arrow @click-left="$commonUtils.onClickLeft" />
    <div class="mine">
      <van-tree-select
        height="55vw"
        :items="items"
        :main-active-index.sync="activeIndex"
        @click-item="selectItem"
        @click-nav="navItem"
      >
        <template slot="content">
          <div>
            <van-grid :border="false" :column-num="3">
              <van-grid-item
                :text="item.title"
                v-for="(item,index) in subgoodsList"
                @click="toDetailList(item.code)"
              >
                <van-image v-if="item.icon" :src="formatImage(item.icon)" />
                <van-image v-else src="https://img.yzcdn.cn/vant/apple-1.jpg" />
                <p class="mt-10">{{item.title}}</p>
              </van-grid-item>
            </van-grid>
          </div>
          <!-- <div v-if="activeIndex === 1"></div> -->
        </template>
      </van-tree-select>
    </div>
    <div class="fixedMy"></div>
  </f7-page>
</template>
<script>
import { goodsList, goodsType } from "@/api/api_mall.js";
export default {
  data() {
    return {
      activeIndex: 0,
      items: [],
      subgoodsList: []
    };
  },
  methods: {
    //格式化图片路径
    formatImage(url) {
      return this.$commonUtils.formatPicture(url, 1);
    },
    async getTradeData() {
      let res = await goodsType({ code: "G02" });
      console.log(res);
      res.data.data.forEach((item, index) => {
        item.text = item.title;
        item.id = item.code;
      });
      this.items = res.data.data;
      this.getSubgoods(this.items[0].code);
    },
    //获取二级商品
    getSubgoods(code) {
      this.subgoodsList = [];
      goodsType({ code: code })
        .then(res => {
          console.log(res);
          this.subgoodsList = res.data.data;
        })
        .catch(() => {});
    },
    selectItem(data) {
      console.log(data);
    },
    navItem(index) {
      console.log(index);
      this.activeIndex = index;
      console.log(this.items[index]);
      this.getSubgoods(this.items[index].code);
    },
    toDetailList(code) {
      console.log(code);
      this.$f7router.navigate(`/physicalGoods/${code}/`);
    }
  },
  mounted() {
    this.getTradeData();
  }
};
</script>

<style>
.trade .page-content {
  display: flex;
  flex-direction: column;
  height: 100%;
}


</style>