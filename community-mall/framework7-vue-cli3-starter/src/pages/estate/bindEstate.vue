<template>
  <f7-page class="bgcg">
    <div>
      <div class="pl-20 pr-20 my_steppp bgcw border-radius8 mt-10">
        <van-steps :active="active">
          <van-step>个人信息</van-step>
          <van-step>小区</van-step>
          <van-step>楼宇</van-step>
          <van-step>房号</van-step>
          <van-step>确认</van-step>
        </van-steps>
      </div>

      <div class="mt-20 border-radius8">
        <div class="mt-20 border-radius8">
          <van-search
            v-show="active == 1"
            v-model="search"
            placeholder="请输入小区名称搜索"
            show-action
            shape="round"
            @search="onSearch"
          >
            <div slot="action" @click="onSearch">搜索</div>
          </van-search>
        </div>
        <div v-show="active == 0">
          <van-cell-group>
            <van-field
              v-model="info.realnameHidden"
              required
              clearable
              label="真实姓名"
              placeholder="请输入真实姓名"
            />

            <van-field
              v-model="info.idcardHidden"
              required
              label="身份证号"
              clearable
              placeholder="请输入身份证号"
            />
          </van-cell-group>
          <f7-block class="button_top">
            <van-button type="danger" round @click="postMineInfo">保存信息</van-button>
          </f7-block>
        </div>
        <div v-show="active == 1">
          <van-cell
            :title="item.villageName"
            is-link
            v-for="item in villageList"
            @click="selectVillage(item)"
          />
          <van-cell
            :title="item.villageName"
            is-link
            v-for="item in nearVillageList"
            @click="selectVillage(item)"
          />
        </div>
        <div v-show="active == 2">
          <van-cell
            :title="item.buildingName"
            is-link
            v-for="item in buildingList"
            @click="selectBuilding(item)"
          />
        </div>

        <div v-show="active == 3">
          <van-cell-group>
            <van-field v-model="selectedInfo.unitno" clearable label="单元号" placeholder="请输入单元号" />

            <van-field
              v-model="selectedInfo.house"
              clearable
              label="房间号"
              placeholder="请输入房间号"
              required
            />
          </van-cell-group>
        </div>

        <div v-show="active == 4">
          <van-cell-group>
            <van-cell title="所属小区" :value="selectedInfo.village.villageName" />
            <van-cell title="所属楼宇" :value="selectedInfo.building.buildingName" />
            <van-cell title="单元号" :value="selectedInfo.unitno" />
            <van-cell title="房间号" :value="selectedInfo.house" />
          </van-cell-group>
        </div>
        <div class="fixedBottom" v-show="active > 0">
          <van-row gutter="20" class="pd-10">
            <van-col span="12">
              <van-button
                size="small"
                plain
                round
                hairline
                type="default"
                v-show="active > 0"
                @click="active--"
              >上一步</van-button>
            </van-col>
            <van-col span="12">
              <van-button
                size="small"
                plain
                round
                hairline
                type="default"
                v-show="active < 4 && active > 2 "
                @click="stepPlus()"
              >下一步</van-button>
            </van-col>
            <van-col span="12">
              <van-button
                size="small"
                hairline
                round
                type="danger"
                v-show="active == 4"
                @click="submitBind"
              >确认提交</van-button>
            </van-col>
          </van-row>
        </div>
      </div>
    </div>
  </f7-page>
</template>

<script>
import { getVillage, bindEstate, getBuilding } from "@/api/api_estate.js";
import { certificate1, getMineInfo } from "@/api/api_community.js";
import Vue from "vue";
import { Search, Button, Cell, CellGroup, Row, Col } from "vant";
Vue.use(Search)
  .use(Button)
  .use(Cell)
  .use(CellGroup)
  .use(Row)
  .use(Col);
export default {
  data() {
    return {
      search: "",
      villageList: [],
      nearVillageList: [],
      active: 0,
      buildingList: [],

      selectedInfo: {
        village: {},
        building: {},
        unitno: "",
        house: ""
      },
      type: "",
      info: {
        realname: "",
        realnameHidden: "",
        idcard: "",
        idcardHidden: ""
      }
    };
  },
  created() {
    this.$commonUtils.setTitle("二级认证");
    this.type = this.$commonUtils.getUrlKey("type");

    this.getMineInfo();
  },
  mounted() {
    let that = this;
    wx.geoLocation({
      success: function(location) {
        var json = JSON.parse(location);
        getVillage({ longitude: json["longitude"], latitude: json["latitude"] })
          .then(res => {
            var result = res.data;
            that.nearVillageList = result;
          })
          .catch(err => {
            that.$commonUtils.jumpLogin(err);
          });
      },
      error: function(err) {
        wx.toast(err);
      }
    });
  },
  methods: {
    //获取我的信息
    getMineInfo() {
      getMineInfo().then(res => {
        var result = res.data;
        this.info.realname = result.realname;
        this.info.idcard = result.idcard;
        this.info.idcardHidden = this.$commonUtils.plusXing(
          result.idcard,
          3,
          4
        );
        this.info.realnameHidden = this.$commonUtils.plusXing(
          result.realname,
          1,
          0
        );
      });
    },
    //提交我的信息
    postMineInfo() {
      let _this = this;
      if (this.info.realnameHidden.trim() == "") {
        wx.toast("请填写真实姓名");
        return;
      }
      if (this.info.realnameHidden.trim().indexOf("*") == -1) {
        this.info.realname = this.info.realnameHidden.trim();
      }
      if (this.info.idcardHidden.trim() == "") {
        wx.toast("请填写身份证号");
        return;
      }
      if (
        this.info.idcardHidden.trim() != "" &&
        this.info.idcardHidden.indexOf("*") == -1
      ) {
        if (!this.$commonUtils.checkIdCard(this.info.idcardHidden)) {
          wx.toast("请填写正确的身份证号");
          return;
        }
        this.info.idcard = this.info.idcardHidden.trim();
      }
      wx.loading("提交中...");
      certificate1(this.info)
        .then(res => {
          wx.closeLoading();
          wx.toast("提交成功");
          setTimeout(function() {
            _this.active = 1;
          }, 1000);
        })
        .catch(err => {
          wx.closeLoading();
        });
    },
    //提交绑定信息
    submitBind() {
      wx.loading("绑定中...");
      let that = this;
      var param = {
        villageId: this.selectedInfo.village.id,
        buildingId: this.selectedInfo.building.id,
        house: this.selectedInfo.house,
        unit: this.selectedInfo.unitno
      };

      bindEstate(param)
        .then(res => {
          wx.closeLoading();
          wx.toast("绑定成功");
          setTimeout(function() {
            if (!!that.type && that.type == "cert3") {
              that.$f7router.navigate(`/certificate/cert3`);
            } else {
              wx.popPage(1);
            }
          }, 1500);
        })
        .catch(err => {
          wx.closeLoading();
          wx.toast("提交失败，请稍后重试");
        });
    },
    stepPlus() {
      if (this.active == 3 && this.selectedInfo.house.trim() == "") {
        wx.toast("请填写房间号");
        return;
      }
      this.active++;
    },
    //选择小区
    selectVillage(item) {
      getBuilding(item.id).then(res => {
        this.buildingList = res.data;
      });
      this.active = 2;
      this.selectedInfo.village = item;

      this.buildingList = [];
    },
    //选择楼宇
    selectBuilding(item) {
      this.active = 3;
      this.selectedInfo.building = item;
    },
    //搜索
    onSearch() {
      getVillage({ villageName: this.search })
        .then(res => {
          var result = res.data;
          this.villageList = result;
          this.nearVillageList = [];
        })
        .catch(err => {
          this.$commonUtils.jumpLogin(err);
        });
    }
  }
};
</script>
<style scoped>
.my_steppp .van-step__icon--active,
.van-step__title--active {
  /* margin-left: 23px; */
  color: #000;
  font-size: 15px !important;
  font-weight: bold;
}
.my_steppp .van-step--finish .van-step__circle,
.van-step--finish .van-step__line {
  background-color: #ebedf0;
}
.fixedBottom {
  position: fixed;
  bottom: 0px;
  left: 0px;
  right: 0px;
  border-top: 1px solid #eee;
  padding-top: 5px;
  background: #fff;
}
.button_top{
    margin-top: 50px!important;
}
</style>