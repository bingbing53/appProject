<template>
  <f7-page class="address"> 
    <van-nav-bar class="myNavBare" title="地址" left-arrow @click-left="onClickLeft" />
    <div class="pd-10">
      <van-address-edit
        show-delete
        show-set-default
        :is-saving="saveLoading"
        :is-deleting="delLoading"
        :address-info="myaddress"
        :area-list="addressList"
        :search-result="searchResult"
        :area-columns-placeholder="['请选择', '请选择', '请选择']"
        @save="onSave"
        @delete="delAddress"
        @change-detail="onChangeDetail"
      />

      <!-- <van-button @click="">删除</van-button> -->
    </div>
  </f7-page>
</template>

<script>
import { Toast } from "vant";
import {
  editAddress,
  addAddress,
  detailAddress,
  delAddress
} from "@/api/api_mall.js";
import addressList from "@/assets/js/area.js";
export default {
  data() {
    return {
      saveLoading:false,
      delLoading:false,
      addressId: "",
      addressList,
      searchResult: [],
      myaddress: {
        name: "",
        tel: "",
        country: "",
        province: "",
        city: "",
        county: "",
        areaCode: "",
        postalCode: "",
        isDefault: "",
        addressDetail: ""
      }
    };
  },
  methods: {
    onClickLeft(){
      wx.goBack();
    },
    onSave(content) {
      this.saveLoading = true
      let isdefault;
      content.isDefault ? (isdefault = 1) : (isdefault = 0);
      let param = {
        defaultStatus: isdefault,
        phoneNumber: content.tel,
        province: content.province,
        city: content.city,
        region: content.county,
        name: content.name,
        detailAddress: content.addressDetail,
        areaCode: content.areaCode
      };
      if (this.addressId) {
        //编辑保存
        this.editSave(param);
      } else {
        //新增保存
        addAddress(param)
          .then(res => {
            if (res.data.code == 200) {
              this.saveLoading = false
              this.myaddress = {};
              this.$f7router.back();
            }
          })
          .catch(err => {});
      }
    },
    //修改地址
    editSave(param) {
      param.addressId = this.addressId;
      editAddress(param)
        .then(res => {
            this.saveLoading = false;
             this.$f7router.back();
        })
        .catch(err => {});
    },
    //删除地址
    delAddress() {
      this.delLoading = true
      delAddress({ addressId: this.addressId })
        .then(res => {
          this.delLoading = false
          this.$f7router.back();
          console.log(res);
        })
        .then(err => {});
    },
    onChangeDetail(val) {
      if (val) {
        this.searchResult = [
          //   {
          //     name: "黄龙万科中心",
          //     address: "杭州市西湖区"
          //   }
        ];
      } else {
        this.searchResult = [];
      }
    },
    //获取地址详情信息
    getAddressDetail() {
      detailAddress({ addressId: this.addressId })
        .then(res => {
          // console.log(res);
          this.myaddress.name = res.data.data.name;
          this.myaddress.tel = res.data.data.phoneNumber;
          this.myaddress.county = res.data.data.region;
          this.myaddress.country = "";
          this.myaddress.postalCode = "";
          this.myaddress.province = res.data.data.province;
          this.myaddress.city = res.data.data.city;
          if (res.data.data.defaultStatus == 0) {
            res.data.data.defaultStatus = false;
          } else if (res.data.data.defaultStatus == 1) {
            res.data.data.defaultStatus = true;
          }
          this.myaddress.isDefault = res.data.data.defaultStatus;
          this.myaddress.addressDetail = res.data.data.detailAddress;
          this.myaddress.areaCode = res.data.data.areaCode;
          console.log(JSON.stringify(this.myaddress));
        })
        .catch(err => {});
    }
  },
  mounted() {
    var params = this.$f7route.params;
    if (params.id && params.id != 0) {
      this.addressId = params.id;
      this.getAddressDetail();
    }
  }
};
</script>

<style>
</style>