<template>
  <f7-page class="address">
    <div>
      <van-address-list
        v-model="chosenAddressId"
        :list="list"
        default-tag-text="默认"
        @add="onAdd"
        @edit="onEdit"
      />
    </div>
  </f7-page>
</template>

<script>
import {
  addressList,
  addAddress,
  editAddress,
  delAddress
} from "@/api/api_mall.js";
export default {
  data() {
    return {
      chosenAddressId: "1",
      list: [
        // {
        //   id: "1",
        //   name: "张三",
        //   tel: "13000000000",
        //   address: "浙江省杭州市西湖区文三路 138 号东方通信大厦 7 楼 501 室",
        //   isDefault: true
        // },
        // {
        //   id: "2",
        //   name: "李四",
        //   tel: "1310000000",
        //   address: "浙江省杭州市拱墅区莫干山路 50 号"
        // }
      ]
    };
  },
  methods: {
    onAdd() {
      //   alert("新增地址");
      let id =0;
      this.$f7router.navigate(`/addAddress/${id}/`);
    },

    onEdit(item, index) {
      this.$f7router.navigate(`/addAddress/${item.id}/`);
    },
    //获取地址列表
    getAddressList() {
      addressList()
        .then(res => {
           res.data.data.forEach((item,index)=>{
             item.tel = item.phoneNumber;
             item.address = item.detailAddress;
             if(item.defaultStatus == 1){
             item.isDefault = true;
             }else if(item.defaultStatus == 0){
              item.isDefault = false;
             }
           })
           console.log(res.data.data)
          this.list = res.data.data
        })
        .catch(err => {});
    }
  },
  mounted() {
    this.getAddressList();
  }
};
</script>

<style>
</style>