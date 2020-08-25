<template>
  <div id="back">
    <van-sticky>
      <van-row>
        <van-col :span="20">
          <van-dropdown-menu :overlay="false" z-index="99" active-color="#1989fa" class="search-box">
            <van-dropdown-item ref="item2" id="dropdown" v-on:change="onLeftDropChange">
              <template #title>
                <div id="search">
                  <span>{{searchText}}</span>
                </div>
              </template>
              <van-row>
                <van-col :span="12">
                  <van-picker #default title :columns="columns" v-on:change="onPickerChange" />
                </van-col>
                <van-col :span="12">
                  <van-picker
                    #default
                    title
                    :columns="columnsRight"
                    v-on:change="onPickerRightChange"
                  />
                </van-col>
              </van-row>
              <div style="padding: 5px 16px;">
                <van-button type="info" block round v-on:click="onPickerConfirm">确认</van-button>
              </div>
            </van-dropdown-item>
          </van-dropdown-menu>
        </van-col>
        <van-col :span="4">
          <van-dropdown-menu :overlay="false" z-index="99" active-color="#1989fa">
            <van-dropdown-item ref="item" id="dropdown">
              <template #title>
                <van-image
                  :src="require('../../assets/img/more.png')"
                  fit="scale-down"
                  height="20"
                  width="20"
                ></van-image>
              </template>
              <van-cell center title="疑似群租房" v-on:click="test(1)"></van-cell>
              <van-cell center title="出租房" v-on:click="test(2)"></van-cell>
              <van-cell center title="自用房" v-on:click="test(3)"></van-cell>
            </van-dropdown-item>
          </van-dropdown-menu>
        </van-col>
      </van-row>
      <van-row v-if="isShowTab">
        <van-col :span="tabSpan">
          <van-tabs line-height="0">
            <van-tab v-for="index in tabbarList" :key="index">
              <template #title>
                <div
                  v-if="index === currentTab"
                  id="tabChoose"
                  v-on:click="changeTab(index)"
                >{{index}}</div>
                <div v-else id="tabNotChoose" v-on:click="changeTab(index)">{{index}}</div>
              </template>
            </van-tab>
          </van-tabs>
        </van-col>
        <van-col
          v-if="tabSpan!=24"
          :span="24-tabSpan"
          style="background-color: #ffffff;height:30px;"
        >
          <van-cell title value />
        </van-col>
      </van-row>
    </van-sticky>

    <van-row style="margin-top:20px;margin-bottom:20px;">
      <span id="subtitle">房屋{{houseList.length}}间</span>
    </van-row>
    <van-row style="margin-top:10px;display:flex">
      <van-image
        class="roomType"
        :src="require('../../assets/img/rect_green.png')"
        fit="scale-down"
        height="20"
        width="20"
      ></van-image>
      <span class="roomTextType">自住间</span>
      <van-image
        class="roomType"
        :src="require('../../assets/img/rect_yellow.png')"
        fit="scale-down"
        height="20"
        width="20"
      ></van-image>
      <span class="roomTextType">出租房</span>
      <van-image
        class="roomType"
        :src="require('../../assets/img/rect_white.png')"
        fit="scale-down"
        height="20"
        width="20"
      ></van-image>
      <span class="roomTextType">无人居住/未明确</span>
    </van-row>
    <van-grid :column-num="4">
      <van-grid-item
        v-for="value in houseList"
        clickable
        :key="value['id']"
        v-on:click="clikcRoomItem(value)"
      >
        <div
          v-if="value['isRent']!=null&&(value['isRent']==='0'||value['isRent']===0)"
          class="roomBackGreen"
        >
          <span class="roomNumGreen">{{value['houseNumber']}}</span>
          <div style="margin-top:3px">
            <span style="font-size: 15px;">{{value['value1']}}</span>
            <span style="font-size: 10px;">人</span>
          </div>
        </div>
        <div
          v-else-if="value['isRent']!=null&&(value['isRent']==='1'||value['isRent']===1)"
          class="roomBackYellow"
        >
          <span class="roomNumYellow">{{value['houseNumber']}}</span>
          <div style="margin-top:3px">
            <span style="font-size: 15px;">{{value['value1']}}</span>
            <span style="font-size: 10px;">人</span>
          </div>
        </div>
        <div v-else class="roomBackWhite">
          <span class="roomNumWhite">{{value['houseNumber']}}</span>
          <div style="margin-top:3px">
            <span style="font-size: 15px;">{{value['value1']}}</span>
            <span style="font-size: 10px;">人</span>
          </div>
        </div>
      </van-grid-item>
    </van-grid>
    <van-dialog v-model="showDialog" title="筛选" show-cancel-button v-on:confirm="dialogConfirm">
      <van-field
        v-model="dialogNumber"
        type="digit"
        input-align="center"
        placeholder="请输入筛选数值 例如：1"
      />
    </van-dialog>
  </div>
</template>
<script>
import getDataList from "@/api/census/census";

export default {
  data() {
    return {
      keyword: "",
      searchText: "点击查询",
      currentTab: "",
      isShowTab: true,
      leftPickerData: {},
      rightPickerData: {}, //这个值的id是buildingID
      columns: [],
      columnsRight: [],
    //   tabbarList: [],
     tabbarList: [111,222,333],
      tabSpan: 24,
      houseList: [],
      partList: [],
      allHouseList: [],
      showDialog: false,
      dialogNumber: null
    };
  },
  mounted() {
    this.getVilliageData();
  },
  activated() {},
  beforeRouteLeave(to, from, next) {
    console.log(to.name);
    console.log(from.name);
    console.log(next.name);
    if (to.name === "censusHouseDetail") {
      from.meta.keepAlive = true; //当我们进入到C时开启B的缓存
      next();
    } else {
      from.meta.keepAlive = false;
      this.$destroy();
      next(); //当我们前进的不是C时我们让B页面刷新
    }
  },
  methods: {
    onConfirm() {
      this.$refs.item.toggle();
    },
    test(val) {
      this.$refs.item.toggle();
      var isRent = 0;
      switch (val) {
        case 1: //疑似
          isRent = -1;
          this.showDialog = true;
          break;
        case 2: //出租房
          isRent = 1;
          break;
        case 3: //自住房
          isRent = 0;
          break;
      }
      if (this.allHouseList.length != 0 && isRent >= 0) {
        this.partList = [];
        for (var item in this.allHouseList) {
          if (this.allHouseList[item]["isRent"] == isRent) {
            this.partList.push(this.allHouseList[item]);
          }
        }
        this.houseList = this.partList;
      } else {
        this.houseList = this.partList;
      }
    },
    onPickerConfirm(value, index) {
      this.$refs.item2.toggle();
      this.searchText =
        this.leftPickerData.text + "/" + this.rightPickerData.text;
      this.getHousePerson();
    },
    onPickerChange(picker, values, index) {
      this.leftPickerData = values;
      this.getBuildingData(values);
    },
    onPickerRightChange(picker, values, index) {
      this.rightPickerData = values;
    },
    onLeftDropChange(value) {
      console.log(value);
    },
    changeTab(val) {
      if (val === this.currentTab) {
        this.currentTab = "";
        this.houseList = this.allHouseList;
      } else {
        this.currentTab = val;
        this.partList = [];
        for (var item in this.allHouseList) {
          if (val === "0单元" && this.allHouseList[item]["unitName"] == null) {
            this.partList.push(this.allHouseList[item]);
          } else if (val === this.allHouseList[item]["unitName"]) {
            this.partList.push(this.allHouseList[item]);
          }
        }
        this.houseList = this.partList;
      }
    },
    async getVilliageData() {
      let data = await getDataList.getVilliageList();
      this.dealVilliagetData(JSON.parse(data));
    },
    dealVilliagetData(data) {
      var myColumn = [];
      data.forEach(item => {
        myColumn.push({
          text: item.villageName,
          id: item.id
          // children: [{ text: "加载中" }]
        });
      });
      this.columns = myColumn;
      this.leftPickerData = this.columns[0];
      if (this.columnsRight.length == 0) {
        this.getBuildingData(this.leftPickerData);
      }
    },
    async getBuildingData(values) {
      var buildingId = 0;
      var itemCount = -1;
      let data = await getDataList.getBuildingList(values.id);
      this.dealBuildData(JSON.parse(data));
    },
    dealBuildData(data) {
      var newColumn = [];
      data.forEach(item => {
        newColumn.push({
          text: item.buildingName,
          id: item.id
        });
      });
      this.columnsRight = newColumn;
      this.rightPickerData = this.columnsRight[0];
      if (this.houseList.length == 0) {
        this.getHousePerson();
        this.searchText =
          this.leftPickerData.text + "/" + this.rightPickerData.text;
      }
    },
    async getHousePerson() {
      let data = await getDataList.getHousePersonList(this.rightPickerData.id);
      let dataList = JSON.parse(data);
      console.log(dataList);
      
      let tabTagList = [];
      let tabTagNumList = [];
      let errNum = 999;
      //排序房间
      for (var i = 1; i < dataList.length; i++) {
        var key = dataList[i];
        var j = i - 1;
        while (j >= 0 && Number(dataList[j].houseNumber) > Number(key.houseNumber)) {
          dataList[j + 1] = dataList[j];
          j--;
        }
        dataList[j + 1] = key;
      }
      this.houseList = dataList;
      this.allHouseList = dataList;
      //处理重复tag
      for (var item in dataList) {
        let isExist = false;
        console.log(dataList[item]["unitName"]);
        if (tabTagList.length != 0)
          for (var tag in tabTagList) {
            if (tabTagList[tag] === "0单元" || tabTagList[tag] === "单元") {
              if (dataList[item]["unitName"] === null) {
                isExist = true;
                break;
              }
            }
            if (tabTagList[tag] === dataList[item]["unitName"]) {
              isExist = true;
              break;
            }
          }
        if (isExist) {
          continue;
        } else {
          if (
            dataList[item]["unitName"] === null ||
            dataList[item]["unitNo"] == ""
          ) {
            tabTagList.push("0单元");
            tabTagNumList.push(0);
          } else {
            if (
              Number(
                dataList[item]["unitNo"] != NaN &&
                  dataList[item]["unitNo"] != ""
              )
            ) {
              tabTagList.push(dataList[item]["unitName"]);
              tabTagNumList.push(Number(dataList[item]["unitNo"]));
            }
          }
        }
      }
      //排序tag
      for (var i = 1; i < tabTagNumList.length; i++) {
        var key = tabTagNumList[i];
        var tagKey = tabTagList[i];
        var j = i - 1;
        while (j >= 0 && tabTagNumList[j] > key) {
          tabTagNumList[j + 1] = tabTagNumList[j];
          tabTagList[j + 1] = tabTagList[j];
          j--;
        }
        tabTagNumList[j + 1] = key;
        tabTagList[j + 1] = tagKey;
      }
      this.tabbarList = tabTagList;
      if (tabTagList.length < 5) {
        var spanNum = 5 - tabTagList.length;
        this.tabSpan = 24 - 4 * spanNum;
      } else {
        this.tabSpan = 24;
      }
    },
    dialogConfirm() {
      console.log(this.dialogNumber);
      if (this.dialogNumber === 0) {
        this.houseList = this.allHouseList;
      } else {
        this.partList = [];

        for (var item in this.allHouseList) {
          var num = Number(this.allHouseList[item]["value1"]);
          if (num >= this.dialogNumber) {
            this.partList.push(this.allHouseList[item]);
          }
        }
        this.houseList = this.partList;
      }
      this.dialogNumber = null;
    },
    clikcRoomItem(value) {
      console.log(value);
      this.$router.push({
        path: `/censusHouseDetail`,
        query: {
          id: value.id
        }
      });
    }
  }
};
</script>
<style scoped>
#more {
  text-align: center;
}
#dropdown {
  color: #fff;
  box-shadow: #fff;
}
#search {
  width: 550px;
  background-size:100% auto;
  padding-left: 20px;
  border-radius: 20px;
  background-color: #eeeeee;
}
#trans {
  background-color: transparent;
}
#tabChoose {
  border-radius: 40px;
  padding-left: 25px;
  padding-right: 25px;
  padding-top: 10px;
  padding-bottom: 10px;
  background-color: #4b6bfa;
  color: #ffffff;
  font-size: 25px;
}
#tabNotChoose {
  border-radius: 40px;
  padding-left: 25px;
  padding-top: 10px;
  padding-bottom: 10px;
  padding-right: 25px;
  background-color: #eeeeee;
  color: #aaaaaa;
  font-size: 25px;
}
#back {
  background-color: #fff;
  height: 1000px;
}
#subtitle {
  margin-left: 30px;
  font-size: 30px;
}
.roomType {
  margin-left: 20px;
  font-weight: 600;
}
.roomTextType {
  margin-left: 10px;
  font-size: 25px;
  align-self: center;
}
.roomBackGreen {
  background: url("../../assets/img/roomtype_green.png") no-repeat;
  width: 120px;
  height: 120px;
  background-size: contain;
  text-align: center;
  padding-top: 15px;
}
.roomBackYellow {
  background: url("../../assets/img/roomtype_yellow.png") no-repeat;
  width: 120px;
  height: 120px;
  background-size: contain;
  text-align: center;
  padding-top: 15px;
}
.roomBackWhite {
  background: url("../../assets/img/roomtype_white.png") no-repeat;
  width: 120px;
  height: 120px;
  background-size: contain;
  text-align: center;
  padding-top: 15px;
}
.roomNumGreen {
  font-weight: 500;
  color: white;
}
.roomNumYellow {
  font-weight: 500;
  color: white;
}
.roomNumWhite {
  font-weight: 500;
  color: black;
}
</style>