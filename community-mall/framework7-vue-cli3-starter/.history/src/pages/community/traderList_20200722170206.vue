<template>
  <f7-page>
    <van-row>
      <van-col :span="firstWidth" style="height:100vh" class="zhinan">
        <!--<div class="first">
                  <div v-for="item in traderList" v-if="item.pid == '0'" @click="firstSelect(item.id)" :class="[firstSelected == item.id ? 'item1':'item2']">
                      {{item.title}}
                  </div>
        </div>-->
        <van-sidebar v-model="activeKey" style="width: 100%">
          <van-sidebar-item
            v-for="item in traderList"
            v-if="item.pid == '0'"
            @click="firstSelect(item.id)"
            :title="item.title"
          />
        </van-sidebar>
      </van-col>
      <van-col :span="secondWidth" style="height:100vh">
        <div class="second">
          <template v-if="secondSelected == ''">
            <div
              v-for="item in traderList"
              v-if="item.pid == firstSelected"
              class="item1"
              @click="secondSelect(item.id)"
            >
              <span class="f-14">{{item.title}}</span>

            </div>
          </template>
          <template v-else>
            <div
              v-for="item in traderList"
              v-if="item.pid == secondSelected"
              class="item1"
              @click="secondSelect(item.id)"
            >
              <span class="f-14">{{item.title}}</span>

            </div>
          </template>
        </div>
      </van-col>
    </van-row>
  </f7-page>
</template>

<script>
import { traderList, traderContent } from "@/api/api_community.js";
export default {
  data() {
    return {
      activeKey: -1,
      traderList: [],
      firstSelected: "",
      secondSelected: "",
      firstWidth: 24,
      secondWidth: 0,
      thirdWidth: 0
    };
  },
  created() {
    this.loadTraderList();
  },
  methods: {
    firstSelect(id) {
      this.firstSelected = id;
      this.firstWidth = 10;
      this.secondWidth = 14;
      this.secondSelected = "";
    },
    secondSelect(id) {
      for (var i = 0; i < this.traderList.length; i++) {
        if (this.traderList[i].pid == id) {
          this.secondSelected = id;
        }
      }
      if (this.secondSelected != id) {
        this.$f7router.navigate(`/community/traderDetail/${id}/`);
      }
    },
    //获取列表
    loadTraderList() {
      traderList().then(res => {
        this.traderList = res.data;
      });
    }
  }
};
</script>
<style scoped>
.page {
  background: #fafafa;
  height: 100%;
}
.line {
  height: 1px;
  background: #eee;
}
.first {
  font-size: 16px;
}
.first > .item1 {
  background: #fff;
  line-height: 50px;
  vert-align: middle;
  font-size: 16px;
  padding-left: 5px;
  padding-right: 5px;
}
.first > .item2 {
  line-height: 50px;
  font-size: 16px;
  padding-left: 5px;
  padding-right: 5px;
}

.second {
  height: 100%;
  background: #fff;
}
.second > .item1 {
  /* line-height: 25px; */
  padding-left: 5px;
  padding-right: 5px;
  /* height: 40px; */
  padding-top:12px;
  padding-bottom: 12px;
  border-bottom: 1px solid #eee;
  
}
.zhinan .van-sidebar-item{
    font-size: 16px;
    font-weight: bold;
}
</style>