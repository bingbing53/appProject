<template>
  <a-drawer
    title="选择社区"
    width="500px"
    placement="right"
    :closable="false"
    @close="onClose"
    :visible="visible"
  >
    <div class="selectItem">
      <a-select placeholder="选择省" @change="provinceHandleChange" style="width: 100%">
        <a-select-option
          v-for="item in provinceItems"
          :key="item.id"
          :value="item.id"
        >{{item.departName}}</a-select-option>
      </a-select>
    </div>
    <div class="selectItem">
      <a-select placeholder="选择市" @change="cityHandleChange" style="width: 100%">
        <a-select-option
          v-for="item in cityItems"
          :key="item.id"
          :value="item.id"
        >{{item.departName}}</a-select-option>
      </a-select>
    </div>
    <div class="selectItem">
      <a-select placeholder="选择街道" @change="streetHandleChange" style="width: 100%">
        <a-select-option
          v-for="item in streetItems"
          :key="item.id"
          :value="item.id"
        >{{item.departName}}</a-select-option>
      </a-select>
    </div>
    <div class="selectItem">
      <a-select placeholder="选择社区" @change="areaHandleChange"  @select="getCode" style="width: 100%">
        <a-select-option
       
          v-for="item in areaItems"
          :key="item.orgCode"
          :value="item.departName"
        >{{item.departName}}</a-select-option>
      </a-select>
    </div>
    <a-button type="primary" @click="sureArea">确定</a-button>
  </a-drawer>
</template>

<script>
export default {
  name: "addressModal",
  data() {
    return {
      visible: false,
      provinceItems: [],
      cityItems: [],
      streetItems: [],
      areaItems: [],
      code:"",
      name:""
    };
  },
  methods: {
    //选择省
    provinceHandleChange(value) {
      this.getAddressTree(value, 1);
    },
    //选择市
    cityHandleChange(value) {
      this.getAddressTree(value, 2);
    },
    //选择街道
    streetHandleChange(value) {
      this.getAddressTree(value, 3);
    },
    //选择社区
    areaHandleChange(value) {
      // this.getAddressTree(value, 4);
    },
    //获取社区
    getAddressTree(parentId, num) {
      this.$http.get("/getArea?parentId=" + parentId).then(res => {
        if (num == 0) this.provinceItems = res.data.result;
        else if (num == 1) this.cityItems = res.data.result;
        else if (num == 2) this.streetItems = res.data.result;
        else if (num == 3) this.areaItems = res.data.result;
      });
    },
    getCode(name,code){
      this.code = code.data.key;
      this.name = name;
    },
    sureArea() {
      this.$emit("getoption",this.name,this.code);
      this.onClose()
    },
    onClose() {
      this.visible = false;
    }
  },
  mounted() {
  }
};
</script>

<style>
.selectItem {
  margin: 20px;
}
</style>