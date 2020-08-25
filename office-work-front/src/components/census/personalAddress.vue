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
      <div
        class="f-14"
        style="color:red;margin-bottom:10px"
      >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;找不到地址请手动填写</div>
      <div>
        <input
          class="border_style"
          style="font-size:16px;height:100%"
          v-model="address[5].value"
          placeholder="请输入详细地址"
        />
      </div>

      <van-button type="info" plain hairline class="right mt-10" @click="saveClick">保存</van-button>
      <van-button type="info" plain hairline class="right mt-10" @click="backClick">取消</van-button>
    </div>
    <van-row>
      <van-action-sheet v-model="showPickerS" title>
        <van-picker
          show-toolbar
          :columns="address[0].range"
          value-key="itemShequ"
          v-on:confirm="confirmPickerS"
          @cancel="showPickerS=false"
        />
      </van-action-sheet>
      <van-action-sheet v-model="showPickerL" title>
        <van-picker
          show-toolbar
          :columns="address[2].range"
          value-key="itemLouyu"
          v-on:confirm="confirmPickerL"
          @cancel="showPickerL=false"
        />
      </van-action-sheet>
      <van-action-sheet v-model="showPickerX" title>
        <van-picker
          show-toolbar
          :columns="address[1].range"
          value-key="itemXiaoqu"
          v-on:confirm="confirmPickerX"
          @cancel="showPickerX=false"
        />
      </van-action-sheet>
    </van-row>
  </div>
</template>
<script>
import addressList from "@/api/invest/investDetail";
import getDataList from "@/api/census/census";

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
        { value: "" },
      ],
      buildIdArray: [],
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
        louyu: "",
      },
      newIndex: 1,
      houseIndex: 1,
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
      console.log(value);
      console.log(index);
      console.log(itemIndex);
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
      this.showPickerL = false;
    },
    pickPropertyInfo(label, code, index, itemIndex) {
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
      _this.address[type].list.forEach(function (item, index) {
        if (type === 0) {
          _this.address[type].range.push(item.departname);
        } else if (type === 1) {
          _this.address[type].range.push(item.village_name);
        } else if (type === 2) {
          _this.address[type].range.push(item.building_name);
          console.log("item", item);
          _this.buildIdArray.push(item.id);
        }
      });
      console.log("finish!!!!", _this.address[2].range);
    },
    saveClick() {
      var _this = this;
      let addressArr = [];
      let addressStr = "";
      for (var i = 0; i < 6; i++) {
        // alert(_this.address[i].value);
        addressArr.push(_this.address[i].value);
        // console.log(_this.address[i]);
        if (i < 3) {
          if (_this.address[i].value != null)
            addressStr =
              addressStr + _this.address[i].range[_this.address[i].value];
        } else {
          // console.log(`------------`);
          if (_this.address[i].value != null && _this.address[i].value != "") {
            switch (i) {
              case 3:
                addressStr = addressStr + _this.address[i].value + "单元";
                break;
              case 4:
                addressStr = addressStr + _this.address[i].value + "房间";
                break;
              case 5:
                addressStr = addressStr + _this.address[i].value;
                window.localStorage.setItem("address", _this.address[i].value);
                break;
            }
          }
        }
      }

      addressArr[2] = this.buildIdArray[2];
      console.log(this.buildIdArray, "this.buildArray");
      //   console.log(
      //     this.faddress.shequ +
      //       this.faddress.xiaoqu +
      //       this.faddress.louyu +
      //       this.address[3].value +
      //       "单元" +
      //       this.address[4].value,
      //     "66666666"
      //   );
      console.log(this.address, "this.address");
      console.log(addressStr, "address_str");
      console.log(addressArr, "address_arrdatas");
      window.localStorage.setItem(
        "address_arrdatas",
        JSON.stringify(addressArr)
      );
      window.localStorage.setItem("address_strs", addressStr);
      window.localStorage.setItem("isback", true);

      //   localStorage
      // this.$router.go(-1);
      this.$router.push({
        path: "personaldetail",
        query: {
          idcard: this.$route.query.idcard,
        },
      });
    },
    backClick() {
      this.$router.go(-1);
    },
    confirmPickerS(val) {
      var indexShequ = 0;
      for (var index in this.address[0].range) {
        if (this.address[0].range[index] == val) {
          indexShequ = index;
          break;
        }
      }
      var itemShequ = val;
      this.pickShequ(itemShequ, 0, indexShequ);
    },
    confirmPickerX(val) {
      var myIndex = 0;
      for (var index in this.address[1].range) {
        if (this.address[1].range[index] == val) {
          myIndex = index;
          break;
        }
      }
      this.pickXiaoqu(val, 1, myIndex);
    },
    confirmPickerL(val) {
      var myIndex = 0;
      for (var index in this.address[2].range) {
        if (this.address[2].range[index] == val) {
          myIndex = index;
          break;
        }
      }
      this.pickLouyu(val, 2, myIndex);
    },
  },
  mounted() {
    console.log(this.$route.query.idcard, "mountedthis.$route.query.idcard");
    this.index = this.$route.query.index;
    this.pos = this.$route.query.fieldsIndex;
    this.address = [
      { range: [], list: [] },
      { range: [], list: [] },
      { range: [], list: [] },
      { value: "" },
      { value: "" },
      { value: "" },
      { value: "" },
    ];
    this.getAddressList(0);
  },
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
  /* width: 65%; */
}
</style>


