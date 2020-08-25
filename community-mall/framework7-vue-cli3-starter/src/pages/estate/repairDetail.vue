<template>
  <f7-page class="repairDetail bgcw">
    <f7-block class="bgcw pb-10 pt-10" style="margin-top:0px!important">
      <div>
        <h3 class="mb-10">
          <strong>预约内容</strong>
        </h3>
      </div>
      <f7-row class="mb-10">
        <f7-col width="100">
          <p class="pd-5">
            <span class="c-666 mr-10">订单状态:</span>
            <span>{{detailData.rows.status_dictText}}</span>
            <span
              @click="contact"
              class="c-blue pl-10"
              v-if="detailData.rows.status == '2' || detailData.rows.status == '3' || detailData.rows.status == '4'"
            >联系客服</span>
          </p>
        </f7-col>
        <f7-col width="100">
          <p class="pd-5">
            <span class="c-666 mr-10">预约种类:</span>
            <span>{{detailData.rows.orderType_dictText}}</span>
          </p>
        </f7-col>
        <f7-col width="100">
          <p class="pd-5">
            <span class="c-666 mr-10">预约时间:</span>
            <span>{{detailData.rows.orderServiceDate}}</span>
          </p>
        </f7-col>
        <template v-if="detailData.rows.status == 4 || detailData.rows.status == 5">
          <f7-col width="100">
            <p class="pd-5">
              <span class="c-666 mr-5">预约内容:</span>
              {{detailData.rows.content}}
            </p>
          </f7-col>
        </template>
        <template v-else>
          <f7-col width="100">
            <p class="pd-5">
              <span class="c-666 mr-5">预约内容:</span>
              {{detailData.rows.content}}
            </p>
          </f7-col>
        </template>
      </f7-row>
      <div class="flexImagebox mt-10 mb-10" v-if="detailData.rows.image">
        <div class="items" v-for="(item,index) in detailData.rows.image">
          <img :src="item" alt @click="show_imageModal(index)" />
        </div>
        <van-image-preview
          v-model="show_image"
          :images="detailData.rows.image"
          :startPosition="current"
        ></van-image-preview>
      </div>
      <template v-if="detailData.rows.status == '1'">
        <van-button round type="danger" @click="cancelRepair()">取消预约</van-button>
      </template>
      <template v-if="detailData.rows.status == '5'">
        <template v-if="detailData.rows.judge">
          <f7-col width="100">
            <van-button type="default" round>已评价</van-button>
          </f7-col>
        </template>
        <template v-else>
          <f7-col width="100">
            <van-button @click="access" round type="danger">评价</van-button>
          </f7-col>
        </template>
      </template>
    </f7-block>
    <div class="pd-5 bgcg"></div>
    <f7-block class="bgcw pt-10 pb-10" style="z-index:0">
      <div>
        <div>
          <h3 class="mb-10">
            <strong>预约进度</strong>
          </h3>
        </div>
        <div v-if="detailData.statesList.length > 0" class="pl-20 pr-20">
          <div class="line"></div>
          <div class="timeline" style="margin-top:10px">
            <div class="timeline-item" v-for="item in detailData.statesList" style="padding:0px">
              <div class="timeline-item-date orange">
                {{item.date}}
                <small>{{item.month}}月</small>
              </div>
              <div class="timeline-item-divider"></div>
              <div class="timeline-item-content">
                <div class="timeline-item-inner">
                  <div class="timeline-item-time">{{item.time}}</div>
                  <div class="timeline-item-title"></div>
                  <div class="timeline-item-subtitle orange">{{item.state}}</div>
                  <div class="timeline-item-text c-666">{{item.stateDes}}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div v-else>
          <p class="mt-10 c-666 pt-20 f-14">尚未处理，请耐心等待......</p>
        </div>
      </div>
    </f7-block>
    <van-popup v-model="show_access" round position="bottom" :style="{ height: '60%' }">
      <div class="f-12 bgcw text">
        <p class="f-20 c-000">服务评价</p>
      </div>
      <van-row>
        <van-col span="24">
          <div class="pd-10">
            <p class="mb-10">服务评价:</p>
            <van-rate v-model="rate.judge" color="#ee0a24" size="22px" />
          </div>
          <div class="pd-10">
            <p class="mb-10">评价内容:</p>
            <van-field
              class="border"
              v-model="rate.judgeContent"
              rows="5"
              autosize
              type="textarea"
              placeholder="请输入您想说的"
            />
          </div>
        </van-col>
        <van-col span="24" class="pd-10">
          <van-button :disabled="isjudge" type="danger" round @click="submit_rate">提交</van-button>
        </van-col>
      </van-row>
    </van-popup>
  </f7-page>
</template>

<script>
import {
  repairDetail,
  repairRate,
  repairContact,
  cancelRepair
} from "@/api/api_estate.js";
import { Toast,Dialog } from 'vant';
export default {
  data() {
    return {
      current: 0,
      id: "",
      detailData: {
        rows: {},
        statesList: []
      },
      show_access: false,
      show_image: false,
      isjudge: false,
      rate: {
        judge: 0,
        judgeContent: ""
      }
    };
  },
  methods: {
    contact() {
      repairContact(this.id).then(res => {
        wx.contact({
          username: res.data.mobile,
          app: "estate"
        });
      });
    },
    show_imageModal(index) {
      this.current = index;
      this.show_image = true;
    },
    getRepairDetail() {
      let _this = this;
      repairDetail(this.id)
        .then(res => {
          if (res.status == 200) {
            // console.log(res.data);
            if (res.data) {
              res.data.order.orderServiceDate = res.data.order.orderServiceDate.substring(
                0,
                res.data.order.orderServiceDate.length - 3
              );
              if (res.data.order.image) {
                res.data.order.image = res.data.order.image.split(",");
                for (let i in res.data.order.image) {
                  res.data.order.image[i] = _this.$commonUtils.formatPicture(
                    res.data.order.image[i]
                  );
                }
              }
              _this.detailData.rows = res.data.order;
            }
            if (res.data.orderStates.length > 0) {
              let list = res.data.orderStates;
              list.forEach((item, index) => {
                item.month = item.stateDate.substring(5, 7);
                item.time = item.stateDate.substring(10, 16);
                item.date = item.stateDate.substring(8, 10);
                if (item.state == "1") {
                  item.state = "待接单";
                }
                if (item.state == "2") {
                  item.state = "客服已接单";
                }
                if (item.state == "3") {
                  item.state = "已派单";
                }
                if (item.state == "4") {
                  item.state = "师傅已接单";
                }
                if (item.state == "5") {
                  item.state = "已结束";
                }
              });
              _this.detailData.statesList = list;
            }
          } else {
          }
        })
        .finally(() => {});
    },
    //取消预约
    cancelRepair() {
      Dialog.confirm({
        title: "确认取消预约吗?",
      })
        .then(() => {
          // on confirm
          cancelRepair(this.id)
            .then(res => {
              if (res.status == 200) {
                Toast("取消成功")
                this.$f7router.navigate(`/estate/repair`);
              }
            })
            .catch(err => {});
        })
        .catch(() => {
          // on cancel
        });
    },
    //评价
    access() {
      this.show_access = true;
    },
    submit_rate() {
      this.isjudge = true;
      repairRate(this.id, this.rate)
        .then(res => {
          wx.toast("提交成功");
          this.isjudge = false;
          this.show_access = false;
          this.detailData.rows.judge = this.rate;
        })
        .finally(() => {});
    }
  },
  created() {
    this.$commonUtils.setTitle("报修详情");
  },
  mounted() {
    var params = this.$f7route.params;
    if (params.id != null && params.id.length > 0) {
      this.id = params.id;
      this.getRepairDetail();
    }
  }
};
</script>
<style scoped>
.flexImagebox {
  height: 120px;
}
.flexImagebox .items {
  overflow: hidden;
  /* position: relative; */
  display: inline-block;
  width: 31.5% !important;
  height: 100px;
  padding-bottom: 26.5%;
  margin-right: 1.3%;
}
.flexImagebox .items img {
  /* transform: translate(-50%, -50%);
  position: absolute;
  top: 50%;
  left: 50%; */
  width: 100%;
  height: 100%;
}

.orange {
  color: orange;
  font-weight: bold;
}
</style>