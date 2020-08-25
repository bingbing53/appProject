<template>
  <div>
    <div class="pd-10">
      <input
        class="border_style"
        style="font-size:16px;height:100%;text-indent:2em;"
        @click="showPopupShequ"
        v-model="faddress.shequ"
        placeholder="点击选择社区"
        readonly
      />
      <br />
      <van-popup v-model="showPickerS" position="right" :style="{ height: '100%' }">
        <div class="popOut">
          <div class="popInner">
            <div v-for="(itemShequ,indexShequ) in address[0].range">
              <span class="select_item" @click="pickShequ(itemShequ,0,indexShequ)">{{itemShequ}}</span>
            </div>
          </div>
        </div>
      </van-popup>
      <br />
      <input
        class="border_style"
        v-model="faddress.xiaoqu"
        style="font-size:16px;height:100%;text-indent:2em;"
        @click="showPopupXiaoqu"
        placeholder="点击选择小区"
        readonly
      />
      <br />
      <van-popup
        v-model="showPickerX"
        position="right"
        lazy-render="true"
        :style="{ height: '100%' }"
      >
        <div class="popOut">
          <div class="popInner">
            <div v-for="(itemXiaoqu,indexXiaoqu) in address[1].range">
              <span class="select_item" @click="pickXiaoqu(itemXiaoqu,1,indexXiaoqu)">{{itemXiaoqu}}</span>
            </div>
          </div>
        </div>
      </van-popup>
      <br />
      <input
        class="border_style"
        v-model="faddress.louyu"
        style="font-size:16px;height:100%;text-indent:2em;"
        @click="showPopupLouyu"
        placeholder="点击选择楼宇"
        readonly
      />
      <br />
      <van-popup
        v-model="showPickerL"
        position="right"
        lazy-render="true"
        :style="{ height: '100%' }"
      >
        <div class="popOut">
          <div class="popInner">
            <div v-for="(itemLouyu,indexLouyu) in address[2].range">
              <span class="select_item" @click="pickLouyu(itemLouyu,1,indexLouyu)">{{itemLouyu}}</span>
            </div>
          </div>
        </div>
      </van-popup>

      <br />

      <div class="pt-10 pb-10 mb-50">
        <van-row gutter="10">
          <van-col span="9">
            <input
              class="border_style"
              style="font-size:16px; border:none;height:100%"
              v-model="address[3].value"
              placeholder="请输入单元号"
            />
          </van-col>
          <van-col sapn="3" class="pt-10" custom-class="pt-10 f-16">单元</van-col>
          <van-col span="9">
            <input
              class="border_style"
              style="font-size:16px; border:none;height:100%"
              v-model="address[4].value"
              placeholder="请输入房间号"
            />
          </van-col>
          <van-col sapn="3" class="pt-10" custom-class="pt-10 f-16">房间</van-col>
        </van-row>
      </div>
      <div class="f-14" style="color:red;margin-bottom:10px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;找不到地址请手动填写</div>
      <div>
        <input
          class="border_style"
          style="font-size:16px;height:100%"
          v-model="address[5].value"
          placeholder="请输入详细地址"
        />
      </div>
     <van-button type="info" plain hairline  class="right mt-10" @click="saveClick">保存</van-button>
    </div>
  </div>
</template>
<script>
import addressList from "@/api/invest/investDetail";
export default {
  data() {
    return {
      columns: ["男", "女"],
      showIndex: 0,
      addressPersonalIndex: -1,
      communityindex: 0,
      villageindex: 0,
      buildingindex: 0,

      address: [
        { range: [], list: [] },
        { range: [], list: [] },
        { range: [], list: [] },
        { value: "" },
        { value: "" },
        { value: "" },
        { value: "" }
      ],

      index: 0,
      pos: 0,

      showPicker: false,
      showPickerS: false,
      showPickerX: false,
      showPickerL: false,
      showPropertyInfo: false,
      faddress: {
        shequ: "",
        xiaoqu: "",
        louyu: ""
      },
      newIndex: 1,
      houseIndex: 1
    };
  },
  methods: {
    showPopupShequ() {
      this.showPickerS = true;
    },
    showPopupXiaoqu() {
      this.showPickerX = true;
    },
    showPopupLouyu() {
      this.showPickerL = true;
    },
    showPopup(index) {
      this.showPicker = true;
      this.newIndex = index;
    },
    showPopupProperty(index) {
      this.showPropertyInfo = true;
      this.houseIndex = index;
    },
    pickShequ(value, index, itemIndex) {
      alert(22)
      this.faddress.shequ = value;
      this.address[index].value = itemIndex;
      if (index < 2) this.getAddressList(index);
      this.showPickerS = false;
    },
    pickXiaoqu(value, index, itemIndex) {
      this.faddress.xiaoqu = value;
      this.address[1].value = itemIndex;
      this.getAddressList(index);
      this.showPickerX = false;
    },
    pickLouyu(value, index, itemIndex) {
      this.faddress.louyu = value;
      this.address[2].value = itemIndex;
      this.getAddressList(index);
      this.showPickerL = false;
    },
    pickPropertyInfo(label, code, index, itemIndex) {
      // alert(value);
      // alert(index);
      // alert(itemIndex);
      this.houseInfo[index].value = label;
      this.houseInfo[index].code = code;
      this.showPropertyInfo = false;
    },


    onCancel() {
      this.show = false;
    },
    onConfirm(picker, value, index) {
      this.show = false;
      let _this = this;
    },
    ShowPUP() {
      this.show = true;
    },
    //选地址获取
    async getAddressList(type) {
      // console.log(type+"====="+JSON.stringify(this.address[0].list[this.address[0].value].org_code));
      var _this = this;
      var paramId = "";
      if (type === 0 && this.address[0].list.length > 0) {
        type += 1;
        paramId = this.address[0].list[this.address[0].value].org_code;
        if (paramId === "") return;
      } else if (type === 1 && this.address[1].list.length > 0) {
        type += 1;
        paramId = this.address[1].list[this.address[1].value].id;
        if (paramId === "") return;
      }
      let d = await addressList.getAddressList(type, paramId);
      d = JSON.parse(d);
      console.log(d);
      // return;

      _this.address[type].list = d;
      _this.address[type].range = [];
      _this.address[type].list.forEach(function(item, index) {
        if (type === 0) {
          _this.address[type].range.push(item.departname);
        } else if (type === 1) {
          _this.address[type].range.push(item.village_name);
        } else if (type === 2) {
          _this.address[type].range.push(item.building_name);
        }
      });
    },
    saveClick() {
      var _this = this;
      let addressArr = [];
   
      for (var i = 0; i < 6; i++) {
      
        // alert(_this.address[i].value);
        addressArr.push(_this.address[i].value)
      } 
      console.log(JSON.stringify(addressArr));
        window.localStorage.setItem("address_arrdata", addressArr);
         this.$router.go(-1)
    }
  },
  mounted() {
    this.index = this.$route.query.index;
    this.pos = this.$route.query.fieldsIndex;
    this.address = [
      { range: [], list: [] },
      { range: [], list: [] },
      { range: [], list: [] },
      { value: "" },
      { value: "" },
      { value: "" },
      { value: "" }
    ];
    this.getAddressList(0);
  }
};
</script>
<style scoped>
.popOut {
  width: 100%;
  overflow: hidden;
}
.popInner {
  overflow: scroll;
}
.popInner > div {
  display: block;
  /* width: 300px; */
  /* height: 50px; */
  padding: 1.33vw;
  margin: 2.66vw;
  border: 1px solid #ccc;
  border-radius: 1.33vw;
}
.select_item {
  display: inline-block;
  width: 100%;
  /* padding-bottom:1.33vw; */
}

.van-popup {
  width: 65%;
}
</style>


