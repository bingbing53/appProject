<template>
  <f7-page class="order_List">
    <van-nav-bar class="myNavBare" title="我的关注" left-arrow @click-left="$commonUtils.onClickLeft" />
    <div class="mine">
      <div class="pd-10 bgcg c-666 f-14">关注的店铺</div>
      <van-pull-refresh v-model="store.isLoading" @refresh="focusStoreList(1)">
        <van-list
          v-model="store.isUpLoading"
          :finished="store.finished"
          finished-text="没有更多了"
          @load="focusStoreList(0)"
        >
          <div class="pd-10">
            <div
              v-for="item in store.records"
              class="borderScale pd-5"
              @click="enterStore(item.orgCode)"
            >
              <van-row>
                <van-col :span="4">
                  <van-image
                    round
                    width="36px"
                    height="36px"
                    fit="cover"
                    :src="formatImage(item.logo)"
                  />
                </van-col>
                <van-col :span="20">
                  <p class="mt-8">
                    <span>{{item.departName}}</span>
                    <span class="c-666 fr">
                      <van-icon name="arrow" />
                    </span>
                  </p>
                </van-col>
              </van-row>
            </div>
          </div>
        </van-list>
      </van-pull-refresh>
    </div>
  </f7-page>
</template>
<script>
import { focusStore } from "@/api/api_cms";
export default {
  data() {
    return {
      store: {
        isLoading: false,
        isUpLoading: false,
        finished: false,
        total: -1,
        pages: 1,
        current: 0,
        records: []
      }
    };
  },
  methods: {
    formatImage(url) {
      return this.$commonUtils.formatPicture(url);
    },
    enterStore(sysCompanyCode) {
      this.$f7router.navigate(`/enter-store/${sysCompanyCode}/`);
    },
    focusStoreList(type) {
      let _this = this;
      if (type == 1) {
        this.store.total = 0;
        this.store.pages = 1;
        this.store.current = 0;
        this.store.records = [];
      }
      focusStore({ pageNo: this.store.current + 1 })
        .then(res => {
          let result = res.data;
          console.log(result);
          result.records.forEach(function(item) {
            _this.store.records.push(item);
          });

          this.store.total = result.total;
          this.store.pages = result.pages;
          this.store.current = result.current;

          this.store.isLoading = false;
          this.store.isUpLoading = false;
          this.store.finished = false;

          if (this.store.current >= this.store.pages) {
            this.store.finished = true;
          }
        })
        .catch(err => {
          this.store.isLoading = false;
          this.store.isUpLoading = false;
          this.store.isUpLoading = false;
        });
    }
  },
  mounted() {
    //   this.focusStoreList(0)
  }
};
</script>

<style>

</style>