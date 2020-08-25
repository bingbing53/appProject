<template>
  <div>
    <van-cell title="个人信息查询" is-link to="personaldetail" />
    <van-cell title="房屋同住人查询" is-link to="CensusHouse" />
  </div>
</template>
<script>
export default {
  data() {
    return {};
  },
  mounted() {
    localStorage.setItem("idcard", "");
    localStorage.setItem("isback", false);
  },
  beforeRouteLeave(to, from, next) {
    console.log(to.name);
    console.log(from.name);
    console.log(next.name);
    to.meta.keepAlive = false;
    // debugger;
    // if (to.name == "personaldetail") {
    //   window.localStorage.setItem("isback", false);
    // }
    next();
  },
  methods: {},
};
</script>