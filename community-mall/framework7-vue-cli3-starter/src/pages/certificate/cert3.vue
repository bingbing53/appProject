<template>
  <f7-page>
    <div class="mb-20 pd-10">
      <span class="c-waring">
        <van-icon name="warning-o" color="#ff976a" class="v_middle mr-5" />请填写个人真实信息
      </span>
    </div>

    <van-cell-group>
      <van-field
        v-model="info.realnameHidden"
        required
        clearable
        label="真实姓名"
        placeholder="请输入真实姓名"
      />

      <van-field v-model="info.idcardHidden" required label="身份证号" clearable placeholder="请输入身份证号" />

      <van-field
        readonly
        clickable
        required
        label="家庭关系"
        :value="hostRelat"
        placeholder="选择家庭关系"
        @click="showHostRelatPicker = true"
      />
      <van-popup v-model="showHostRelatPicker" position="bottom">
        <van-picker
          show-toolbar
          :columns="dictList['host_relat']"
          @cancel="showHostRelatPicker = false"
          @confirm="onHostRelatConfirm"
        />
      </van-popup>

      <van-field
        readonly
        clickable
        required
        label="教育程度"
        :value="eduLevel"
        placeholder="选择教育程度"
        @click="showEduLevelPicker = true"
      />
      <van-popup v-model="showEduLevelPicker" position="bottom">
        <van-picker
          show-toolbar
          :columns="dictList['edu_level']"
          @cancel="showEduLevelPicker = false"
          @confirm="onHostEduLevelConfirm"
        />
      </van-popup>

      <van-field
        readonly
        clickable
        required
        label="政治面貌"
        :value="polity"
        placeholder="选择政治面貌"
        @click="showPolityPicker = true"
      />
      <van-popup v-model="showPolityPicker" position="bottom">
        <van-picker
          show-toolbar
          :columns="dictList['polity']"
          @cancel="showPolityPicker = false"
          @confirm="onHostPolityConfirm"
        />
      </van-popup>

      <van-field
        readonly
        clickable
        required
        label="职业类型"
        :value="position"
        placeholder="选择职业类型"
        @click="showPositionPicker = true"
      />
      <van-popup v-model="showPositionPicker" position="bottom">
        <van-picker
          show-toolbar
          :columns="dictList['position']"
          @cancel="showPositionPicker = false"
          @confirm="onHostPositionConfirm"
        />
      </van-popup>
    </van-cell-group>

    <f7-block class="mt-20">
      <van-button type="danger" round @click="postMineInfo">保存信息</van-button>
    </f7-block>
  </f7-page>
</template>

<script>
import {
  certificate1,
  getMineInfo,
  getMineDetailInfo,
  postMineDetailInfo
} from "@/api/api_community.js";
import { dictCodeList } from "@/api/api_common.js";
import Vue from "vue";
import { Picker } from "vant";
Vue.use(Picker);

export default {
  data() {
    return {
      info: {
        realname: "",
        realnameHidden: "",
        idcard: "",
        idcardHidden: "",
        eduLevel: "",
        polityStatus: "",
        positionType: "",
        hostRelation: ""
      },
      dictList: {
        host_relat: [],
        edu_level: [],
        polity: [],
        position: []
      },
      hostRelat: "",
      showHostRelatPicker: false,
      eduLevel: "",
      showEduLevelPicker: false,
      polity: "",
      showPolityPicker: false,
      position: "",
      showPositionPicker: false
    };
  },
  created() {
    this.$commonUtils.setTitle("三级认证");

    this.getMineInfo();

    this.getDictCode("host_relat");
    this.getDictCode("edu_level");
    this.getDictCode("polity");
    this.getDictCode("position");
  },
  methods: {
    onHostRelatConfirm(value) {
      this.hostRelat = value.text;
      this.showHostRelatPicker = false;
      this.info.hostRelation = value.value;
    },
    onHostEduLevelConfirm(value) {
      this.eduLevel = value.text;
      this.showEduLevelPicker = false;
      this.info.eduLevel = value.value;
    },
    onHostPolityConfirm(value) {
      this.polity = value.text;
      this.showPolityPicker = false;
      this.info.polityStatus = value.value;
    },
    onHostPositionConfirm(value) {
      this.position = value.text;
      this.showPositionPicker = false;
      this.info.positionType = value.value;
    },
    getDictCode(code) {
      dictCodeList(code).then(res => {
        this.dictList[code] = res.data;
      });
    },
    //获取我的信息
    getMineInfo() {
      getMineDetailInfo().then(res => {
        var result = res.data;
        this.info.realname = result.realname;
        if (!!result.idcard && result.idcard.length > 0) {
          this.info.idcard = result.idcard;
          this.info.idcardHidden = this.$commonUtils.plusXing(
            result.idcard,
            3,
            4
          );
        }
        this.info.realnameHidden = this.$commonUtils.plusXing(
          result.realname,
          1,
          0
        );
      });
    },
    //提交我的信息
    postMineInfo() {
      if (this.info.realnameHidden.trim() == "") {
        wx.toast("请填写真实姓名");
        return;
      }
      if (this.info.realnameHidden.trim().indexOf("*") == -1) {
        this.info.realname = this.info.realnameHidden.trim();
      }
      if (this.info.hostRelation.trim().length <= 0) {
        wx.toast("请选择家庭关系");
        return;
      }
      if (this.info.eduLevel.trim().length <= 0) {
        wx.toast("请选择教育程度");
        return;
      }
      if (this.info.polityStatus.trim().length <= 0) {
        wx.toast("请选择政治面貌");
        return;
      }
      if (this.info.positionType.trim().length <= 0) {
        wx.toast("请选择职业类型");
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
      postMineDetailInfo(this.info)
        .then(res => {
          wx.closeLoading();
          wx.toast("修改成功");
          setTimeout(function() {
            wx.popPage(1);
          }, 1500);
        })
        .catch(err => {
          wx.closeLoading();
        });
    }
  }
};
</script>

<style scoped>
</style>