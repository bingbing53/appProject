<template>
  <div>
    <van-tabs v-model="tabIndex" @change="clickItem" class="collection">
      <van-tab title="入户调查列表" class="fontSizetitle">
        <van-pull-refresh v-model="peopleInquireList.isLoading" @refresh="ondataRefreshinvest">
            <van-list
               v-model="peopleInquireList.loading"
              :finished="peopleInquireList.finished"
              finished-text="没有更多了"
              @load="getpeopleInquire"
            >
              <div
                v-for="(item,index) in peopleInquireList.rows"
                :key="index"
                @click="gotoHistory(item.uuid)"
                class="mb-10 bgcw2"
                >
                 <div class="bgcy"></div>
                <div class="pd-10">
                  <div v-if="item.type == '1'" class="f-16 text-c mb-20" style="color: #4e6bff">{{item.title}}</div>
                  <div v-if="item.type == '2'" class="f-16 text-c mb-20" style="color: #3396fb">{{item.title}}</div>
                  <div v-if="item.type == '3'" class="f-16 text-c mb-20" style="color: #ffc737">{{item.title}}</div>
                  <div class="text-c pt-20 card f-16 mt-10">
                    <van-row>
                      <van-col span="12">
                        <span class="f-16">{{item.name}}</span>
                        <p class="f-16 c-999 mt-10"> 被调查人 </p>
                      </van-col>
                      <van-col span="12">
                        <span class="f-blue f-15">{{item.create_date}}</span>
                      <p class="f-16 c-999 mt-10"> 调查时间 </p>
                      </van-col>
                    </van-row>
                  </div>
                </div>
                 
              </div>
            </van-list>
        </van-pull-refresh>
      </van-tab>
      <van-tab title="民情民意列表" class="fontSizetitle">
         <van-pull-refresh v-model="peopleDemoList.isLoading" @refresh="ondataRefresh">
            <van-list
               v-model="peopleDemoList.loading"
              :finished="peopleDemoList.finished"
              finished-text="没有更多了"
              @load="getpeopleDemoList"
            >
              <div v-for="(item,index) in peopleDemoList.rows" :key="index" class="bgcw2 mb-10">
                   <div class="bgcy"></div>
                <div class="pl-10 pt-10">
                  {{item.username}}
                  <span class="f-blue">{{item.mobile}}</span>
                  <span class="pl-5 pr-5 ml-5 f-12 list_bage c-fff">{{item.name}}</span>
                  <br />
                  {{item.idcard}}
                  <br />
                  {{item.address}}
                </div>

                <div class="pd-10">
                  <div class="pt-10">{{item.content}}</div>
                </div>
                <div class="pd-10">
                  <ul class="flex_box" id="images">
                    <li v-for="(imgItem,ppp) in item.imageArr" :key="ppp" class="imgarr_content">
                      <van-image width="100px" height="100px" fit="cover" :src="imgItem" @click="previewImg(item.sourceimageArr[ppp],ppp)"  />
                        <van-image-preview
                              v-model="show"
                              :startPosition="ppp"
                              :images="perimageArr"
                              :showIndex="false"
                            ></van-image-preview>
                    </li>
                  </ul>
                </div>
                <div class="pl-10 pb-10 c-999 f-12">{{item.title}} {{item.create_date}}</div>
             
              </div>
            </van-list>
         </van-pull-refresh>
      </van-tab>
    </van-tabs>
  </div>
</template>
<script>
import group from "@/api/socialgroup/group";
export default {
  data() {
    return {
      show:false,
      startIdx:0,
      tabIndex: 0,
      index: 0,
      id: "",
      peopleDemoList: {
        pageNo: 1,
        totalPage: 0,
        loading: false,
        finished: false,
        isLoading: false,
        rows: []
      },
      peopleInquireList: {
        pageNo: 1,
        totalPage: 0,
        loading: false,
        finished: false,
        isLoading: false,
        rows: []
      },
       perimageArr: [],//图片预览单张预览
    };
  },
  methods: {
     //图片预览
    previewImg(img,index){
      this.perimageArr = [];
      this.startIdx = index;
      this.show = true;
      this.perimageArr.push(img);
    },
    //点击tab页
    clickItem(index) {
      this.tabIndex = index;
    },
    // 跳转调查历史
    gotoHistory(uuid) {
      this.$router.push({
        path: `/investhistory${uuid}`
      });
    },
    // ***********************民意**************************************************************************
     async init() {
      let res = await group.getpeopleDemoList(this.id, this.peopleDemoList.pageNo);
      this.peopleDemoList.rows = [];
      res = JSON.parse(res);
      this.handleDataopinion(res);

      this.peopleDemoList.totalPage = res.totalPage;
      this.peopleDemoList.isLoading = false;
      this.peopleDemoList.finished = false;
      if (res.totalPage <= res.currentPage) {
          this.peopleDemoList.finished = true;
      } else {
        this.peopleDemoList.pageNo++;
      }
    },
    //下拉刷新
    ondataRefresh() {
      this.peopleDemoList.totalPage = 0;
      this.peopleDemoList.pageNo = 1;
      this.init(); //加载数据
    },
    //获取民情民意列表
    async getpeopleDemoList() {
      let res = await group.getpeopleDemoList(this.id, this.peopleDemoList.pageNo);
      res = JSON.parse(res);
     this.handleDataopinion(res);
      this.peopleDemoList.totalPage = res.totalPage;
      this.peopleDemoList.isLoading = false;
      this.peopleDemoList.loading = false;

      if (res.totalPage <= res.currentPage) {
        this.peopleDemoList.finished = true;
      } else {
        this.peopleDemoList.pageNo ++;
      }
    },
    // ***********************民意end**************************************************************************
    // ***********************调查*****************************************************************************
     async initinvest() {
      let res = await group.getpeopleInquire(this.id, this.peopleInquireList.pageNo);
      this.peopleInquireList.rows = [];
      res = JSON.parse(res);
      this.handleDatainvest(res);

      this.peopleInquireList.totalPage = res.totalPage;
      this.peopleInquireList.isLoading = false;
      this.peopleInquireList.finished = false;
      if (res.totalPage <= res.currentPage) {
          this.peopleInquireList.finished = true;
      } else {
        this.peopleInquireList.pageNo++;
      }
    },
    //下拉刷新
    ondataRefreshinvest() {
      this.peopleInquireList.totalPage = 0;
      this.peopleInquireList.pageNo = 1;
      this.initinvest(); //加载数据
    },
    //获取入户调查列表
    async getpeopleInquire() {
      let res = await group.getpeopleInquire(this.id, this.peopleInquireList.pageNo);
      res = JSON.parse(res);
      this.handleDatainvest(res);
      
      this.peopleInquireList.totalPage = res.totalPage;
      this.peopleInquireList.isLoading = false;
      this.peopleInquireList.loading = false;

      if (res.totalPage <= res.currentPage) {
        this.peopleInquireList.finished = true;
      } else {
        this.peopleInquireList.pageNo ++;
      }

     
    },
    // ***********************调查end*****************************************************************************

    //公用getData民情民意
    handleDataopinion(res){
      let _this = this;
       res.list.forEach(function(item, index) {
        item.create_date = item.create_date.substring(0, 10);
        item.imageArr = [];
        item.sourceimageArr = [];
        if (!!item.image) {
          item.image = JSON.parse(item.image);
          item.image.forEach(function(img, p) {
            item.imageArr.push(_this.common.showPicture(img));
            item.sourceimageArr.push(_this.common.showPicture(img,"",false));
          });
        }
        _this.peopleDemoList.rows.push(item);
      });
    },
    //公用getData入户调查
    handleDatainvest(res){
      let _this = this;
       res.list.forEach(function(item, index) {
        item.create_date = item.create_date.substring(0, 10);
        item.imageArr = [];
        if (!!item.image) {
          item.image = JSON.parse(item.image);
          item.image.forEach(function(img, p) {
            item.imageArr.push(_this.common.showPicture(img));
          });
        }
        _this.peopleInquireList.rows.push(item);
      });

    }

  },
  mounted() {
    // this.index = this.$route.query.index;
    this.tabIndex = this.$route.query.index;
    this.id = this.$route.query.id;
    //index：1 入户调查   2：收集的民意
    // this.getpeopleInquire();
    // this.getpeopleDemoList();
  }
};

</script>
<style scoped>
.bage {
  border-radius: 15px;
  border: solid 1px #eee;
  padding: 3px 14px 3px 14px;
  margin-bottom: 5px;
  text-align: center;
  font-size: 13px;
}
.bageClick {
  background: #3396fb;
  color: #fff;
  text-align: center;
}
.imgarr_content {
  margin-right: 1.2vw;
  margin-left: 1.2vw;
}
.flex_box {
  display: flex;
  justify-content: flex-start;
  align-items: center;
}
.list_bage{
  border-radius: 1.8vw;
  text-align: center;
  background: #3396fb;
}
</style>


