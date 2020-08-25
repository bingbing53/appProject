<template>
  <f7-page class="trader bgcg">
    <van-tabs v-model="active" sticky>
      <van-tab title="我要预约">
        <van-cell-group class="mt-10">
          <van-cell title="预约项目" :value="content.title" />

          <van-cell title="选择预约时间" @click="showTimePicker">
            <span v-if="form.appointTime">{{form.appointTime}}</span>
            <van-icon name="arrow" class="fr" v-else />
          </van-cell>

          <van-field
            class="fielddddd"
            v-model="form.appointDes"
            rows="4"
            autosize
            label="备注信息"
            type="textarea"
            maxlength="200"
            placeholder="请输入预约备注信息，不超过200个字"
            show-word-limit
          />
        </van-cell-group>
        <van-row class="mt-50">
          <van-col :span="18" offset="3">
            <van-button type="danger" round @click="submitOrder">提 交 预 约</van-button>
          </van-col>
        </van-row>
      </van-tab>
      <van-tab title="预约历史">
        <van-pull-refresh v-model="orderHisotryList.refreshLoading" @refresh="getOrderList(1)">
          <van-list
            v-model="orderHisotryList.pullDownLoading"
            :finished="orderHisotryList.finished"
            finished-text="没有更多了"
            @load="getOrderList(0)"
          >
            <div v-for="item in orderHisotryList.records" class="mt-10 border-radius8">
              <van-cell-group>
                <van-cell title="预约项目" :label="item.title">
                  <span
                    :style="{'color': item.color}"
                    v-if="(item.confirm === '1' || item.confirm === '2') && (item.state != '0' && item.state != '1')"
                    @click="cancelOrder(item)"
                  >{{item.confirmStr}}</span>
                  <span v-else :style="{'color': item.color}">{{item.confirmStr}}</span>
                </van-cell>
                <van-cell
                  title="您的预约码为"
                  v-if="item.confirm === '1' && item.appointCode"
                  label="请凭预约码到社区办事"
                >
                  <span class="c-blue">{{item.appointCode}}</span>
                </van-cell>
                <van-cell title="预约时间" :value="item.appointTime"></van-cell>
                <van-cell title="备注信息" v-if="!!item.appointDes" :label="item.appointDes"></van-cell>
                <van-cell
                  title="拒绝原因"
                  v-if="item.confirm === '0' && item.rejectReason"
                >{{item.rejectReason}}</van-cell>
              </van-cell-group>
            </div>
          </van-list>
        </van-pull-refresh>
      </van-tab>
    </van-tabs>

    <van-popup v-model="timePickerShow" label="有效日期" position="bottom" :overlay="true">
      <van-datetime-picker
        v-model="currentDate"
        type="datetime"
        :min-date="minDate"
        @confirm="confirm"
        @cancel="close"
      />

      <div
        v-if="!!traderContents.timeRange"
        class="tc pd-10 c-organ mt-20"
      >预约提示：{{traderContents.timeRange}}</div>
    </van-popup>
  </f7-page>
</template>

<script>
import {
  traderContent,
  traderOrderList,
  traderOrderSubmit,
  cancelTraderOrder,
  holiday
} from "@/api/api_community.js";
export default {
  data() {
    return {
      active: 0,
      timePickerShow: false,
      minDate: new Date(2020, 1, 1),
      // maxDate: new Date(2022, 10, 1),
      currentDate: null,
      traderCode:"",
      form: {
        appointDes: "",
        appointTime: "",
        traderCode: ""
      },

      orderHisotryList: {
        refreshLoading: false,
        pullDownLoading: false,
        finished: false,
        total: -1,
        pages: 1,
        current: 0,
        records: []
      },
      content: {},
      traderContents: {}
    };
  },
  created() {
    this.$commonUtils.setTitle("我要预约");

    var params = this.$f7route.params;
    if (params.traderId != null && params.traderId.length > 0) {
      this.traderCode = params.traderId;
      this.form.traderCode = params.traderId;
      this.getTraderDetail();
    }
    // this.getOrderList();
  },
  methods: {
    //取消预约
    cancelOrder(item) {
      this.$dialog
        .confirm({
          title: "取消确认",
          message: "您是否确认取消预约，取消后不可恢复"
        })
        .then(() => {
          cancelTraderOrder(item.id)
            .then(res => {
              wx.toast("取消成功");
              this.getOrderList(1);
            })
            .catch(err => {});
        })
        .catch(() => {
          // on cancel
        });
    },
    close() {
      this.timePickerShow = false;
    },
    async confirm(value) {
      var canNext = true;

      let _this = this;
      var d = new Date(value);
      var time = `${d.getFullYear()}-${d.getMonth() + 1}-${d.getDate()}`;
      var result = await holiday({ time: time })
        .then(res => {
          //节假日
          var d = new Date(value);
          var hour = d.getHours();
          var minute = d.getMinutes();

          var start = 9 * 60,
            end = 18 * 60;
          var checked = hour * 60 + minute;
          if (checked < start || checked > end) {
            _this.form.time = "";
            _this.$dialog.alert({
              message: "非预约时段，非工作日早9:00至晚18:00"
            });
            canNext = false;
          }
        })
        .catch(err => {
          //工作日
          var d = new Date(value);
          var hour = d.getHours();
          var minute = d.getMinutes();

          var start = 8 * 60 + 30,
            end = 20 * 60;
          var checked = hour * 60 + minute;
          if (checked < start || checked > end) {
            _this.form.time = "";
            _this.$dialog.alert({
              message: "非预约时段，工作日早8:30至晚20:00"
            });
            canNext = false;
          }
        });

      if (!canNext) {
        return;
      }
      this.timePickerShow = false;

      var youWant =
        d.getFullYear() +
        "-" +
        (d.getMonth() + 1) +
        "-" +
        d.getDate() +
        " " +
        d.getHours() +
        ":" +
        d.getMinutes() +
        ":00";
      this.form.appointTime = youWant;
    },
    showTimePicker() {
      this.minDate = new Date();
      this.timePickerShow = true;
    },
    //获取预约的详情
    getTraderDetail() {
      traderContent(this.form.traderCode).then(res => {
        var result = res.data;
        this.content = result.traderList;
        if (result.traderContents != null) {
          this.content.content = result.traderContents.content;
          this.traderContents = result.traderContents;
        }
      });
    },
    //获取预约历史
    getOrderList(type) {
      if (type == 1) {
        this.orderHisotryList.total = 0;
        this.orderHisotryList.pages = 1;
        this.orderHisotryList.current = 0;
        this.orderHisotryList.records = [];
      }

      if (this.orderHisotryList.pages <= this.orderHisotryList.current) {
        this.orderHisotryList.finished = true;
        return;
      }

      let _this = this;
      //   return
      traderOrderList({ pageNo: this.orderHisotryList.current + 1 })
        .then(res => {
          //   return
          this.orderHisotryList.refreshLoading = false;
          this.orderHisotryList.pullDownLoading = false;
          let result = res.data;

          this.orderHisotryList.total = result.total;
          this.orderHisotryList.pages = result.pages;
          this.orderHisotryList.current = result.current;

          result.records.forEach(function(item, index) {
            if (item.state === "0") {
              item.color = "#909399";
              item.confirmStr = "已取消";
              item.confirm = "-1";
            } else if (item.state === "1") {
              item.color = "#73b930";
              item.confirmStr = "已使用";
            } else {
              var startTime = new Date(item.appointTime.replace(/-/g, "/"));
              var endTime = new Date();

              var startDay = new Date(
                `${startTime.getFullYear()}-${startTime.getMonth() +
                  1}-${startTime.getDate()}`
              );
              var today = new Date(
                `${endTime.getFullYear()}-${endTime.getMonth() +
                  1}-${endTime.getDate()}`
              );

              var gap = (today - startDay) / 1000 / 3600 / 24;

              if (gap >= 1) {
                item.color = "#909399";
                item.confirmStr = "已过期";
                item.confirm = "-1";
              } else {
                if (item.confirm === "0") {
                  item.color = "#f56c6c";
                  item.confirmStr = "未处理";
                } else if (item.confirm === "1") {
                  item.color = "#73b930";
                  item.confirmStr = "审核通过";
                } else {
                  item.color = "#3f88bf";
                  item.confirmStr = "待接受";
                }
              }
            }
            _this.orderHisotryList.records.push(item);
          });
        })
        .catch(err => {
          this.orderHisotryList.refreshLoading = false;
          this.orderHisotryList.pullDownLoading = false;
        });
    },
    //提交新的预约
    submitOrder() {
      if (this.form.appointTime == "") {
        wx.toast("请选择预约时间");
        return;
      }
      if (this.form.appointDes == "") {
        wx.toast("请输入预约描述");
        return;
      }
      this.form.traderCode = this.traderCode
      traderOrderSubmit(this.form.traderCode, this.form)
        .then(res => {
          wx.toast("预约成功");

          this.form = {
            appointDes: "",
            appointTime: "",
            traderCode: ""
          };

          this.getOrderList(1);
          this.active = 1;
        })
        .catch(err => {
          // this.$dialog.alert({
          //     message: err.data
          // });
          this.$commonUtils.jumpLogin(err);
        });
    }
  }
};
</script>
<style scoped>
.lanren {
  min-height: 92px;
  background: white;
  /*-webkit-box-shadow: 0px 0px 8px rgba(0, 0, 0, 0.3);*/
  /*-moz-box-shadow: 0px 0px 8px rgba(0, 0, 0, 0.3);*/
  /*box-shadow: 0px 0px 8px rgba(0, 0, 0, 0.3);*/
  position: relative;
}
.lanren .ribbon-lanren-green {
  width: 80px;
  height: 88px;
  overflow: hidden;
  position: absolute;
  top: -3px;
  right: 0px;
  z-index: 1000;
}
.lanren .ribbon-green {
  font: 15px Sans-Serif;
  color: #fff !important;
  text-align: center;
  text-shadow: rgba(255, 255, 255, 0.5) 0px 1px 0px;
  -webkit-transform: rotate(45deg);
  -moz-transform: rotate(45deg);
  -ms-transform: rotate(45deg);
  -o-transform: rotate(45deg);
  position: relative;
  padding: 5px 0;
  left: 5px;
  top: 15px;
  width: 98px;
  font-size: 12px;
  /*background-color: #BFDC7A;*/
  /*background-image: -webkit-gradient(linear, left top, left bottom, from(#BFDC7A), to(#8EBF45));*/
  /*background-image: -webkit-linear-gradient(top, #BFDC7A, #8EBF45);*/
  /*background-image: -moz-linear-gradient(top, #BFDC7A, #8EBF45);*/
  /*background-image: -ms-linear-gradient(top, #BFDC7A, #8EBF45);*/
  /*background-image: -o-linear-gradient(top, #BFDC7A, #8EBF45);*/
  color: #6a6340;
  -webkit-box-shadow: 0px 0px 3px rgba(0, 0, 0, 0.3);
  -moz-box-shadow: 0px 0px 3px rgba(0, 0, 0, 0.3);
  box-shadow: 0px 0px 3px rgba(0, 0, 0, 0.3);
  z-index: 1000;
}
.lanren .ribbon-green:before,
.ribbon-green:after {
  content: "";
  border-top: 3px solid #6e8900;
  border-left: 3px solid transparent;
  border-right: 3px solid transparent;
  position: absolute;
  bottom: -3px;
  z-index: 1000;
}
.lanren .ribbon-green:before {
  left: 0;
  z-index: 1000;
}
.lanren .ribbon-green:after {
  right: 0;
  z-index: 1000;
}
.trader [class*="van-hairline"]::after {
  border-color: transparent;
}
.trader .van-cell__title,
.van-cell__value {
  text-indent: 0.5em;
  font-size: 16px;
}
.fielddddd {
  text-indent: 0.6em !important;
  font-size: 16px !important;
}
.fielddddd .van-field__label {
  text-indent: 0.7em !important;
  font-size: 16px !important;
}
.fielddddd .van-field__body {
  font-size: 14px !important;
}
</style>