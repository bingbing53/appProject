<template >
  <div style="background-color:#f5f5f5;">
    <van-row>
      <van-col :span="24">
        <van-search
          v-model="keyword"
          :clearable="false"
          placeholder="输入姓名或身份证号"
          left-icon
          right-icon="search"
          show-action
        >
          <template #action>
            <div @click="onSearch">搜索</div>
          </template>
        </van-search>
      </van-col>
    </van-row>
    <div v-if="userData.idcard!=undefined">
      <div id="myCard">
        <van-row>
          <van-col :span="8">
            <van-image
              height="120"
              id="myAvatar"
              fit="contain"
              :src="userData.headImage!=null?common.showPicture(userData.headImage,'',false):require(userData.sex==1?'../../assets/img/avatar.png':'../../assets/img/avatar_male.png')"
              radius="20"
            ></van-image>
          </van-col>
          <van-col :span="16">
            <van-field
              v-model="userData.personName"
              label="姓名"
              placeholder="请输入姓名"
              autosize
              center
              input-align="right"
              required
            />
            <van-cell
              title="性别"
              :value="showData.sex"
              clickable
              v-on:click="showNormalPicker('sex')"
            />
            <van-field
              v-model="userData.idcard"
              label="身份证号"
              placeholder="请输入身份证号"
              autosize
              center
              input-align="right"
              required
            />
          </van-col>
        </van-row>
        <div id="line" block />
        <van-cell
          title="出生日期"
          :value="userData.birthdate==null?'点击选择出生日期':userData.birthdate"
          clickable
          v-on:click="showDatePicker = true"
        />
        <van-cell
          title="民族"
          :value="showData.nationality"
          clickable
          v-on:click="showNormalPicker('national')"
        />
        <van-field
          v-model="userData.mobilePhone"
          label="联系方式"
          placeholder="请输入联系方式"
          autosize
          center
          input-align="right"
        />
        <van-cell
          title="家庭关系"
          :value="showData.hostRelation"
          clickable
          v-on:click="showNormalPicker('host_relat')"
        />
        <van-cell
          title="居住地址"
          :value="userData.presentDetailAddr1"
          clickable
          v-on:click="clickToSelectAddress"
        />
        <!-- <van-field
          v-model="userData.presentDetailAddr1"
          label="居住地址"
          placeholder="请输入居住地址"
          autosize
          center
          input-align="right"
          required
        />-->
        <van-field
          v-model="userData.rprDetailAddr"
          label="户籍地址"
          placeholder="请输入户籍地址"
          autosize
          center
          input-align="right"
        ></van-field>
        <van-cell
          title="文化程度"
          :value="showData.eduLevel"
          clickable
          v-on:click="showNormalPicker('edu_level')"
        />
        <van-cell
          title="政治面貌"
          :value="showData.polity"
          clickable
          v-on:click="showNormalPicker('polity')"
        />
      </div>
      <van-row>
        <van-col :span="12" offset="2">
          <van-button
            round
            color="linear-gradient(to right, #55a5f9, #4b6bfa)"
            block
            v-on:click="saveInfo"
          >保存</van-button>
        </van-col>
        <van-col :span="6" offset="2">
          <van-button round plain block v-on:click="deletePerson">删除</van-button>
        </van-col>
      </van-row>
      <van-action-sheet v-model="showDatePicker" title>
        <van-datetime-picker
          v-model="currentDate"
          type="date"
          title="选择生日日期"
          :min-date="minDate"
          :max-date="maxDate"
          v-on:confirm="confirmDataPicker"
          @cancel="showDatePicker = false"
        />
      </van-action-sheet>
      <van-action-sheet
        v-model="showSexPicker"
        title="选择性别"
        @select="onSelectSex"
        :actions="actions"
      ></van-action-sheet>
      <van-action-sheet v-model="showPicker" title>
        <van-picker
          show-toolbar
          :columns="columns"
          value-key="typename"
          v-on:confirm="onNormalPickerConfirm"
          @cancel="showPicker=false"
        />
      </van-action-sheet>
    </div>
  </div>
</template>
<script>
import { Button, DatetimePicker, Dialog } from "vant";
import getDataList from "@/api/census/census";
import work from "@/api/work/workhistory";

export default {
  data() {
    return {
      keyword: "",
      userData: {},
      minDate: new Date(1900, 0, 1),
      maxDate: new Date(),
      currentDate: new Date(),
      showSexPicker: false,
      showDatePicker: false,
      showPicker: false,
      actions: [{ name: "男" }, { name: "女" }],
      tagArray: ["sex", "national", "host_relat", "edu_level", "polity"],
      dictionary: {},
      columns: [],
      currentPickerName: "",
      showData: {
        sex: "",
        nationality: "",
        hostRelation: "",
        eduLevel: "",
        polity: ""
      }
      // value: ""
    };
  },
  mounted() {
    console.log("mounted!");
    console.log(this.keyword,"mounted!");
    // debugger
    this.getDictionarys();
    if (this.$route.query.idcard != undefined) {
      this.keyword = this.$route.query.idcard;
      if (this.keyword != "") this.getPersonData(this.keyword);
    }
  },
  activated() {
    console.log("activated");
    if (
      window.localStorage.getItem("address_str") != null &&
      window.localStorage.getItem("address_str") != ""
    ) {
      this.userData.presentDetailAddr1 = window.localStorage.getItem(
        "address_str"
      );
      this.userData.address = window.localStorage.getItem("address"); //其实是找不到部分的详细地址
      this.userData.detailAddress = this.userData.presentDetailAddr1;
      var itemArray = window.localStorage.getItem("address_arrdata"); //其实是个string
      this.userData.buildingId = itemArray.split(",")[2];
      this.userData.unitNo = itemArray.split(",")[3];
      this.userData.houseNumber = itemArray.split(",")[4];

      window.localStorage.setItem("address_str", "");
      window.localStorage.setItem("address", "");
      window.localStorage.setItem("address_arrdata", "");
    }
  },
  beforeRouteLeave(to, from, next) {
    // console.log(to.name);
    // console.log(from.name);
    // console.log(next.name);
    if (to.name === "censusAddress") {
      from.meta.keepAlive = true; //当我们进入到C时开启B的缓存
      next();
    } else {
      // from.meta.keepAlive = false;
      this.$destroy();
      next(); //当我们前进的不是C时我们让B页面刷新
    }
  },
  methods: {
    async getPersonData(keywords) {
        // debugger
      let data = await getDataList.getPersonData(keywords);
      console.log(data,'111')
      this.userData = JSON.parse(data)[0];
      if (this.userData.birthdate != undefined)
        this.currentDate = new Date(this.userData.birthdate.replace(/-/, "/"));
      console.log(this.userData);
      // console.log("local", window.localStorage.getItem("address_arrdata"));
      // console.log("local", window.localStorage.getItem("address_str"));

      // if(window.localStorage.getItem('address_arrdata'))
      this.getDictionarys();
    },
    onSearch() {
        //  debugger
      this.getPersonData(this.keyword);
    },
    confirmDataPicker() {
      var monthInt = this.currentDate.getMonth() + 1;
      this.userData.birthdate = `${this.currentDate.getFullYear()}-${
        monthInt >= 10 ? monthInt : "0" + monthInt
      }-${this.currentDate.getDate()}`;
      this.showDatePicker = false;
    },
    onSelectSex(item) {
      this.userData.sex = item.name;
      this.showSexPicker = false;
    },
    saveInfo() {
      var data = {
        personId: this.userData.id,
        name: this.userData.personName,
        sex: this.userData.sex,
        nationality: this.userData.nationality,
        mobilePhone: this.userData.mobilePhone,
        hostRelation: this.userData.hostRelation,
        rprDetailAddr: this.userData.rprDetailAddr,
        eduLevel: this.userData.eduLevel,
        polity: this.userData.polity,
        buildingId : this.userData.buildingId,
        unitNo : this.userData.unitNo,
        houseNumber:this.userData.houseNumber,
        address :this.userData.address,
        detailAddress: this.userData.detailAddress
      };
      // console.log(data);
      this.doSave(data);
    },
    async doSave(data) {
      let mydata = await getDataList.postUpdatePersonInfo(data);
      // console.log(mydata);
    },
    deletePerson() {
      Dialog.confirm({
        title: `确认`,
        message: `确认删除${this.userData.personName}么`
      })
        .then(() => {
          // on confirm
          console.log("确认删除");
          this.deletePersonData();
        })
        .catch(() => {
          // on cancel
          console.log("取消删除");
        });
    },
    async deletePersonData() {
      let data = await getDataList.deletePersonDataByPersonId(this.userData.id);
      // console.log(data);
      this.userData = {};
    },
    async getDictionarys() {
        // debugger
      for (var item in this.tagArray) {
        var tag = this.tagArray[item];
        // console.log(tag);
        let res = await work.getDictionary(tag);
        res = JSON.parse(res);
        var array = res[tag];
        array.splice(0, 0, { typecode: "-1", typename: "请选择" });
        this.dictionary[tag] = array;
      }
      this.dealUserData();
    },
    showNormalPicker(name) {
      this.currentPickerName = name;
      var dataArray = this.dictionary[name];
      this.columns = dataArray;
      this.showPicker = true;
    },
    onNormalPickerConfirm(value) {
      // console.log(value);
      this.showPicker = false;
      switch (this.currentPickerName) {
        case "sex":
          this.userData.sex = value.typecode;
          this.showData.sex = value.typename;
          break;
        case "national":
          this.userData.nationality = value.typecode;
          this.showData.nationality = value.typename;
          break;
        case "host_relat":
          this.userData.hostRelation = value.typecode;
          this.showData.hostRelation = value.typename;
          break;
        case "edu_level":
          this.userData.eduLevel = value.typecode;
          this.showData.eduLevel = value.typename;
          break;
        case "polity":
          this.userData.polity = value.typecode;
          this.showData.polity = value.typename;
          break;
        default:
          break;
      }
    },
    dealUserData() {
      if (this.userData != null) {
        for (var tagItem in this.tagArray) {
          var tagStr = this.tagArray[tagItem];
          var dataArray = this.dictionary[tagStr];
          for (var item in dataArray) {
            switch (tagStr) {
              case "sex":
                if (
                  Number(dataArray[item].typecode) == Number(this.userData.sex)
                )
                  this.showData.sex = dataArray[item].typename;
                break;
              case "national":
                if (
                  Number(dataArray[item].typecode) ==
                  Number(this.userData.nationality)
                ) {
                  this.showData.nationality = dataArray[item].typename;
                }
                break;
              case "host_relat":
                if (
                  Number(dataArray[item].typecode) ==
                  Number(this.userData.hostRelation)
                ) {
                  this.showData.hostRelation = dataArray[item].typename;
                }
                break;
              case "edu_level":
                if (
                  Number(dataArray[item].typecode) ==
                  Number(this.userData.eduLevel)
                )
                  this.showData.eduLevel = dataArray[item].typename;
                break;
              case "polity":
                if (
                  Number(dataArray[item].typecode) ==
                  Number(this.userData.polity)
                )
                  this.showData.polity = dataArray[item].typename;
                break;
              default:
                break;
            }
          }
        }
      }
    },
    clickToSelectAddress() {
        // debugger
      console.log("clickToSelectAddress");
      this.$router.push({
        path: `/censusAddress`,
        query: {}
      });
    }
  }
};
</script>
<style>
#myCard {
  background-color: white;
  border-radius: 10px;
  margin: 3%;
  box-shadow: 0 0 20px #eeeeee;
  padding: 10px 0 10px 0;
}
#myAvatar {
  margin: 10px;
  align-content: center;
}
#line {
  color: #aaa;
  height: 1px;
}
</style>