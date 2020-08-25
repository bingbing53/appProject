<template>
  <f7-page class="bgcg">
    <!-- <van-nav-bar class="myNavBar" title="志愿者搜索" left-arrow @click-left="$commonUtils.onClickLeft" /> -->
    <van-row class="c-bgr">
      <van-col :span="2">
        <div class="c-bgr c-fff my_left tc" @click="$commonUtils.onClickLeft">
          <van-icon name="arrow-left" />
        </div>
      </van-col>
      <van-col :span="18">
        <van-search v-model="value" shape="round" background="#fd4346" placeholder="请输入身份证或者手机号" />
      </van-col>
      <van-col :span="4" style="background:#fd4346;color:#fff;height:54px;line-height:54px">
        <div class="tc" @click="onSearch">搜索</div>
      </van-col>
    </van-row>
    <div class="pd-10">
      <van-row class="my_card pd-5">
        <van-col :span="18" class="pd-5">
          <p>
            姓名：
            <b
              v-if="peopleInfo && flage == 2"
              class="f-20"
              style="letter-spacing:2px"
            >{{peopleInfo.baseuser.realname}}</b>
            <b v-else-if=" flage == 1" class="f-20" style="letter-spacing:2px">没有志愿者信息</b>
            <b v-else class="f-20" style="letter-spacing:2px"></b>
          </p>
          <p class="mt-5">
            <span v-if="peopleInfo">
              <van-rate
                v-model="peopleInfo.welfareuser.level"
                :size="16"
                color="#fd4346"
                void-icon="star"
                void-color="#eee"
                readonly 
              />
            </span>
          </p>
        </van-col>
        <van-col :span="6">
          <!--<img v-if="!!peopleInfo.baseuser && !!peopleInfo.baseuser.headImage" :src="peopleInfo.baseuser.headImage" width="85px" height="119px" alt />
          <img v-else src="@/assets/man.png" width="85px" height="119px" alt />-->
          <van-image
                  v-if="!!peopleInfo.baseuser && !!peopleInfo.baseuser.headImage"
                  width="85"
                  height="119"
                  fit="cover"
                  :src="peopleInfo.baseuser.headImage"
          />
          <img v-else src="@/assets/man.png" width="85px" height="100px" alt />
        </van-col>
      </van-row>
    </div>
    <div class="pd-10">
      <van-row class="my_card pd-5 pb-20">
        <van-col :span="24" class="pd-5 tc c-000 borderScale pb-10 pt-10">
          <b>志愿者公益信息</b>
        </van-col>
        <van-col :span="24" class="pd-10">
          <p>
            居住社区:
            <span v-if="peopleInfo" class="fr">{{peopleInfo.depart}}</span>
          </p>
        </van-col>
        <!-- <van-col :span="24" class="pd-10">
          <span>是否为志愿者:</span>
        </van-col>-->
        <van-col :span="24" class="pd-10">
          <p>
            志愿者公益币数量:
            <span v-if="peopleInfo" class="fr">{{peopleInfo.welfareuser.points}}</span>
          </p>
        </van-col>
        <van-col :span="24" class="pd-10">
          <p>
            参加活动次数:
            <span v-if="peopleInfo" class="fr">{{peopleInfo.activityCount}}</span>
          </p>
        </van-col>
        <van-col :span="24" class="pd-10">
          <p>
            志愿者活动时长:
            <span v-if="peopleInfo" class="fr">{{peopleInfo.welfareuser.duration}}</span>
          </p>
        </van-col>
      </van-row>
    </div>
    <div class="mt-50 tc pd-10">
      <van-button round color="#fd4346" @click="getActivityList">确定服务</van-button>
    </div>
    <van-popup
      v-model="showActivityList"
      position="bottom"
      closeable
      close-icon="close"
      :style="{ height: '80%' }"
    >
      <div class="mt-20 pd-10">
        <span class="f-12 v_middle c-waring ml-10">
          <van-icon name="warning-o" class="v_middle mr-5" size="12" color="#ff976a" />选择您参加的活动，点击进行签到
        </span>
        <div class="pt-10 pb-10 borderScale mt-10">
          <van-row
            v-for="(item,index) in activityList"
            :key="index"
            @click="signIn(item.id,item.title)"
            class="mb-10 mt-20"
          >
            <van-col :span="6">
              <div class="pl-10 pr-10 border-radius8 my_picture">
                <img
                  :src="item.posterUrl"
                  width="70px"
                  height="70px"
                  alt
                  style="border:1px solid #eee"
                />
              </div>
            </van-col>
            <van-col :span="18">
              <p class="c-blue mb-10">{{item.title}}</p>
              <p
                class="c-666 f-12"
              >时间:{{substringDate(item.startTime)}} 至 {{substringDate(item.endTime)}}</p>
              <p class="c-666 f-12 mt-5">地址:{{item.location}}</p>
            </van-col>
          </van-row>
        </div>
      </div>
    </van-popup>
  </f7-page>
</template>

<script>
import { Toast, Dialog } from "vant";
import {
  volunteerInfo,
  scanActivityList,
  MystoreActivityList,
  signInActivity
} from "@/api/api_mall.js";
export default {
  data() {
    return {
      value: "",
      peopleInfo: "",
      flage: 0,
      activityList: [],
      showActivityList: false,
      storeId: ""
    };
  },
  methods: {
    substringDate(time) {
      return time.substring(0, 16);
    },
    onSearch() {
      let param;
      if (this.value.length <= 0) {
        Toast("请输入正确的身份证或手机号");
      } else if (this.value.length > 11) {
        param = {
          idcard: this.value
        };
      } else if (this.value.length <= 11) {
        param = {
          mobile: this.value
        };
      }
      volunteerInfo(param)
        .then(res => {
          console.log(res.status);
          if (res.status == 200) {
            this.peopleInfo = res.data;
            this.flage = 2;
            if(!!this.peopleInfo.baseuser && !!this.peopleInfo.baseuser.headImage){
                this.peopleInfo.baseuser.headImage = this.$commonUtils.formatPicture(
                    this.peopleInfo.baseuser.headImage
                );
            }
          } else {
            this.peopleInfo = {};
            this.flage = 1;
          }
        })
        .catch(err => {
          this.peopleInfo = "";
          if (err.status == 400) {
            Toast(err.data);
          }
        });
    },
    getActivityList() {
      if (!this.peopleInfo) {
        Toast("请先搜索志愿者信息");
        return;
      }
      let _this = this;
      let param = {
        pageNo: 1,
        pageSize: 10,
        departType: 2,
        isEnd: 0,
        sysCompanyCode: this.storeId
        // sysCompanyCode: ""
      };
      _this.activityList = [];
      MystoreActivityList(param)
        .then(res => {
          if (res.data.records.length > 0) {
            res.data.records.forEach((item, index) => {
              if (item.posterUrl) {
                item.posterUrl = _this.$commonUtils.formatPicture(
                  item.posterUrl
                );
              }
              _this.activityList.push(item);
              _this.showActivityList = true;
            });
          } else {
            Toast("没有活动~")
          }
        })
        .catch(err => {});
    },
    //活动签到
    signIn(id, title) {
      let param = {
        activityId: id,
        baseuserId: this.peopleInfo.baseuser.id
      };
      Dialog.confirm({
        title: "是否签到?",
        message: title
      })
        .then(() => {
          signInActivity(param)
            .then(res => {
              Toast("签到成功");
            })
            .catch(err => {
              console.log(err);
              if (err.status == 400) {
                Toast(err.data);
              }
            });
        })
        .catch(() => {
          // on cancel
        });
    }
  },
  mounted() {
    var params = this.$f7route.params;
    if (params.storeId) {
      console.log(this.storeId);
      this.storeId = params.storeId;
    }
  }
};
</script>

<style>
.my_left {
  height: 54px;
  line-height: 54px;
}
</style>