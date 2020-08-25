<template>
  <f7-page class="bgcg">
    <div>
      <div class="bgcw pd-10 border-radius8 mt-20 mb-20">
        <div class="mb-10">请选择需要服务的种类</div>
        <div>
          <p
            class="item_serveType f-14 c-666"
            :class="current ==index?'active':''"
            v-for="(item,index) in servetypeList"
            :key="index"
            @click="select_serveType(item.value,index)"
          >{{item.text}}</p>
        </div>
      </div>
      <div class="bgcw pd-10 border-radius8 mt-20 mb-20 pb-20">
        <div class="mb-10">请选择服务时间</div>
        <div>
          <input
            class="f-14 text-indent1 border_none"
            v-model="repairForm.orderServiceDate"
            label="有效日期"
            placeholder="点击选择时间"
            readonly
            @click="TimePop"
          />
          <van-popup v-model="startTimePop" label="有效日期" position="bottom" :overlay="true">
            <van-datetime-picker
              v-model="currentDate"
              type="datetime"
              :min-date="minDate"
              :max-date="maxDate"
              @confirm="confirm"
              @cancel="close"
            />
          </van-popup>
        </div>
      </div>
      <div class="bgcw pd-10 border-radius8 mt-20 mb-20">
        <div>请您尽量详细的描述需要提供的服务</div>
        <f7-list inline-labels no-hairlines-md>
          <f7-list-input
            class="f-14"
            type="textarea"
            placeholder="请详细描述"
            :value="repairForm.content"
            @input="repairForm.content = $event.target.value"
          >
            <!-- <f7-icon icon="demo-list-icon" slot="media"></f7-icon> -->
          </f7-list-input>
        </f7-list>
      </div>
      <div class="bgcw pd-10 border-radius8 mt-20 mb-20">
        <div class="mb-10">添加现场图片</div>
        <div>
          <f7-row>
            <f7-col
              v-for="(item,index) in imagesList" :key="index"
              width="33"
              class="fl"
              style="position:relative"
            >
              <img :src="item" id="img" />
              <div class="iconfont icon-chahao" @click="deleteMulPic(index)"></div>
            </f7-col>
            <f7-col width="33" v-if="imagesList.length <= 2" class="Mainpicture fl">
              <van-icon name="plus" size="20" color="#666" @click="showPicture" />
            </f7-col>
            <div class="clear"></div>
          </f7-row>
        </div>
      </div>
      <div class="bgcw pd-10 border-radius8 mt-20 mb-20 pb-20">
        <div class="mb-10">预约电话：</div>
        <div>
          <span
            class="mr-10 c-blue"
            v-for="(item,index) in phoneList" :key="index"
            @click="showPhone = true"
          >{{item}}</span>
        </div>
      </div>
      <div class="mt-50 pb-10">
        <f7-row>
          <f7-col width="10"></f7-col>
          <f7-col width="80">
            <van-button round type="danger" @click="submit" no-fast-click="false">提 交</van-button>
          </f7-col>
          <f7-col width="10"></f7-col>
        </f7-row>
      </div>
      <van-popup v-model="showPhone" class="my_phone border-radius8" style="width:300px">
        <p class="f-14 c-666 tc mt-10">点击拨打电话</p>
        <div class="pd-10 bgcw">
          <p v-for="(phone,number) in phoneList" :key="number" class="pd-20 f-20" @click="toPhone(phone)">
            <van-icon name="phone-circle-o" color="#fd4346" class="v_middle" />
            <span class="ml-10">{{phone}}</span>
          </p>
        </div>
      </van-popup>
      <van-popup v-model="showPictureType" position="bottom" :style="{ height: '24%' }">
        <p class="pd-10 mb-10">选择方式</p>
        <van-cell title="相机" @click="choiseImage(0)" />
        <van-cell title="相册" @click="choiseImage(1)" />
      </van-popup>
    </div>
  </f7-page>
</template>

<script>
import { reportType, addRepair, myEstateDetail } from "@/api/api_estate.js";
import { uploadBase64Image } from "@/api/api_common";
export default {
  data() {
    return {
      showPhone: false,
      current: -1,
      imagesList: [],
      servetypeList: [],
      minHour: 10,
      maxHour: 20,
      minDate: new Date(),
      maxDate: "",
      currentDate: new Date(),
      startTimePop: false,
      repairForm: {
        orderServiceDate: "",
        orderType: "",
        content: ""
      },
      imageData: "",
      phoneList: [],
      showPictureType: false
    };
  },
  methods: {
    //拨打电话
    toPhone(phone) {
      wx.diaMobile(phone);
      this.showPhone = false;
    },
    AddDays() {
      var nd = new Date();
      nd = nd.valueOf();
      nd = nd + 7 * 24 * 60 * 60 * 1000;
      nd = new Date(nd);
      this.maxDate = nd;
    },
    TimePop() {
      this.AddDays();
      this.startTimePop = true;
    },
    select_serveType(code, index) {
      this.current = index;
      this.repairForm.orderType = code;
    },
    close() {
      this.startTimePop = false;
    },
    confirm(value) {
      this.startTimePop = false;
      var d = new Date(value);
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
        ":" +
        d.getSeconds();
      this.repairForm.orderServiceDate = youWant;
    },
    async getreportTypeList() {
      let res = await reportType("worker_type");
      this.servetypeList = res.data.result;
    },
    //删除一个图片
    deleteMulPic(index) {
      this.$delete(this.imagesList, index);
    },
    showPicture() {
      this.showPictureType = true;
    },
    //上传图片
    choiseImage(value) {
      let that = this;
      if (value == 0) {
        wx.choiseImage({
          source: "camera",
          success: function(res) {
            that.imagesList.push(res);
          }
        });
      } else if (value == 1) {
        wx.choiseMultiImage({
          maxSelected: 3,
          success: function ready(value) {
            value = eval(value);
            value.forEach((el, index) => {
              that.imagesList.push(el);
            });
            // }
          }
        });
      }
      this.showPictureType = false;
    },
    //获取电话
    async getPhones() {
      let res = await myEstateDetail();
      // console.log(res);
      if (res.data.depart.mobile) {
        res.data.depart.mobile = res.data.depart.mobile.split("/");
        res.data.depart.mobile.forEach((el, index) => {
          this.phoneList.push(el);
        });
      }
    },
    async submit() {
      if (!this.repairForm.orderType) {
        wx.toast("请选择服务种类");
        return;
      }
      if (!this.repairForm.orderServiceDate) {
        wx.toast("请选择服务时间");
        return;
      }
      if (!this.repairForm.content) {
        wx.toast("请填写需要提供的服务详情");
        return;
      }
      let that = this;
      let resultArr = [];

      if (this.imagesList.length > 0) {
        wx.loading("图片上传中");
        for (var i = 0; i < this.imagesList.length; i++) {
          var result = await uploadBase64Image({
            upfile: this.imagesList[i]
          }).catch(err => {
            wx.toast("上传失败");
            wx.closeLoading();
            return;
          });
          if (result.status == 200) {
            resultArr.push(result.data["url"]);
          }
        }
        wx.closeLoading();
        this.repairForm.image = resultArr.join(",");
      }
      addRepair(this.repairForm)
        .then(res => {
          this.repairForm = {
            orderServiceDate: "",
            orderType: "",
            content: ""
          };
          this.imagesList = [];
          (this.current = -1), wx.toast("提交成功");
          this.$f7router.navigate(`/estate/repair`);
        })
        .catch(err => {
          wx.toast("提交失败，请稍后重试");
        });
    }
  },
  mounted() {
    this.$commonUtils.setTitle("新增报修");
    this.getreportTypeList();
    this.getPhones();
  }
};
</script>
<style scoped>
.item_serveType {
  border: 1px solid #eee;
  border-radius: 4px;
  padding: 3px 20px;
  margin: 5px;
  display: inline-block;
}
.active {
  background-color: #ee0a24;
  color: #fff !important;
}
.icon-chahao {
  cursor: pointer;
  position: absolute;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  text-align: center;
  top: -5px;
  right: -5px;
  color: #fff;
  background: rgba(0, 0, 0, 0.5);
}
.Mainpicture {
  float: left;
  width: 100px;
  height: 100px;
  line-height: 100px;
  text-align: center;
  background: rgba(255, 255, 255, 1);
  border-radius: 2px;
  border: 1px solid #e5e9f2;
  /* margin-left: -100px; */
}
#img {
  width: 100%;
  height: 100px;
  border-radius: 5px;
}
.my_phone {
  z-index: 99999 !important;
}
</style>