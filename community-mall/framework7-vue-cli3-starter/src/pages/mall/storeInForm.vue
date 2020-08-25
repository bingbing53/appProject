<template>
  <f7-page>
    <div>
      <div class="pl-40 pr-40 f-18">
        <van-steps :active="active">
          <van-step>添加门店</van-step>
          <van-step>资质认证</van-step>
        </van-steps>
      </div>
      <div class="pd-10">
        <span class="pl-10">门店名称(必填)</span>
         <van-field  placeholder="请输入用户名" class="border mt-10" />
      </div>
        <div class="pd-10">
        <span class="pl-10">营业类型(必填)</span>
         <van-field  placeholder="请选择营业类型" class="border mt-10" />
      </div>
        <div class="pd-10">
        <span class="pl-10">门店地址(必填)</span>
         <van-field  placeholder="请输入门店地址" class="border mt-10" />
      </div>
      <div class="fixedItem">
        <van-button round type="info">下一步</van-button>
      </div>
    </div>
  </f7-page>
</template>
<script>
export default {
  data() {
    return {
      active: 0
    };
  },
  methods: {},
  mounted() {}
};
</script>

<style>
.fixedItem{
  position:absolute;
  bottom: 0px;
  left: 0px;
  right: 0px;
  padding:10px 20px;
  background: #fff;
}
</style>