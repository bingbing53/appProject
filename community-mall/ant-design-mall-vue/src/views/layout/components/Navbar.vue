<template>
  <el-menu class="navbar" mode="horizontal">
    <hamburger class="hamburger-container" :toggleClick="toggleSideBar" :isActive="sidebar.opened"></hamburger>
    <!--<breadcrumb></breadcrumb>-->
    <span>商户管理子系统</span>

    <el-dropdown class="avatar-container" trigger="click">

      <div class="avatar-wrapper" style="font-size: 15px; line-height: 16px;">
        <div class="avatar-wrapper">
          <span style="line-height: 30px;vertical-align: middle;margin-right: 6px;">{{departName}} </span>
          <img class="user-avatar" :src="avatar">
          <span style="line-height: 30px;vertical-align: middle;margin-left: 6px;"> 欢迎您，{{userInfo.realname}}</span>
          <!--<i class="el-icon-caret-bottom"></i>-->
        </div>
      </div>
      <el-dropdown-menu class="user-dropdown" slot="dropdown">
        <router-link class="inlineBlock" to="/">
          <el-dropdown-item>
            首页
          </el-dropdown-item>
        </router-link>
        <el-dropdown-item divided>
          <span @click="changePwd" style="display:block;">修改密码</span>
        </el-dropdown-item>
        <el-dropdown-item divided>
          <span @click="onClickLogout" style="display:block;">退出</span>
        </el-dropdown-item>
      </el-dropdown-menu>
    </el-dropdown>

    <el-dropdown class="store-container" trigger="click">
      <el-button type="text"><i class="el-icon-menu" style="font-size: 16px;color: black"></i></el-button>
      <el-dropdown-menu class="menu-dropdown" slot="dropdown" style="width:370px">
        <el-dropdown-item v-for="item in sysstem_menu" class="mymenu_style">
          <a :href="item.url">
            <img :src="item.icon" class="menu_img" />
            <span>{{item.name}}</span>
          </a>
        </el-dropdown-item>
      </el-dropdown-menu>
    </el-dropdown>

   <header-notice></header-notice>

   <change-pwd v-model="visible" @ok="changePwdOk"></change-pwd>

  </el-menu>
</template>

<script>
import Vue from 'vue'
import { mapGetters } from 'vuex'
import Breadcrumb from '@/components/Breadcrumb'
import Hamburger from '@/components/Hamburger'
import { logout,permissionmenu } from '@/api/sso_login'
import { ACCESS_TOKEN, USER_NAME, DEPART_NAME, USER_INFO, USER_AUTH, SYS_BUTTON_AUTH } from '@/store/mutation-types'
import HeaderNotice from "./HeaderNotice";
import ChangePwd from "./ChangePwd";

export default {
  components: {
    ChangePwd,
    HeaderNotice,
    Breadcrumb,
    Hamburger
  },
  computed: {
    ...mapGetters([
      'sidebar',
      'avatar'
    ]),
    username:function(){
      // alert('修改后username');
    }
  },
  methods: {
    toggleSideBar() {
      this.$store.dispatch('ToggleSideBar')
    },
    changePwd(){
      this.visible = true;
    },
    changePwdOk(){
      this.visible = false;
    },
    onClickLogout() {
      const self = this;
      logout().then(function() {
        var sevice = "https://" + window.location.host;
        var serviceUrl = encodeURIComponent(sevice);
        window.location.href = process.env.CAS_PREFIXURL + "/cas/logout?service=" + serviceUrl;
      });
    },
    getAvatar(){
      return process.env.IMAGE_SERVER + this.userInfo.avatar;
    },
    getperssionmenu() {
      var params = {
        token: this.token
      }
      permissionmenu(params).then(res => {
        if (res.success) {
          res.result.forEach((item, index) => {
            item.icon = process.env.IMAGE_SERVER + item.icon
          })
          this.sysstem_menu = res.result
        }
      })
    },
  },
  created(){
    let that = this;
    const token = Vue.ls.get(ACCESS_TOKEN)
    this.token = token
    this.getperssionmenu()
    setTimeout(function(){
      that.showMessage();
    },60000);
  },
  data() {
    return {
      userInfo: Vue.ls.get(USER_INFO),
      avatar:process.env.IMAGE_SERVER + Vue.ls.get(USER_INFO).avatar,
      departName: Vue.ls.get(DEPART_NAME),
      token:'',
      sysstem_menu:[],
      visible:false
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
.navbar {
  height: 50px;
  line-height: 50px;
  border-radius: 0px !important;
  .hamburger-container {
    line-height: 58px;
    height: 50px;
    float: left;
    padding: 0 10px;
  }
  .screenfull {
    position: absolute;
    right: 90px;
    top: 16px;
    color: red;
  }
  .store-container{
    float: right;
    margin-right: 20px;
  }
  .el-dropdown{
    position: inherit !important;
  }
  .avatar-container {
    height: 50px;
    display: inline-block;
    /*position: absolute;*/
    margin-right: 35px;
    float: right;
    .avatar-wrapper {
      cursor: pointer;
      margin-top: 10px;
      position: relative;
      .user-avatar {
        vertical-align: middle;
        width: 25px;
        height: 25px;
        border-radius: 12.5px;
      }
      .el-icon-caret-bottom {
        position: absolute;
        right: -20px;
        top: 25px;
        font-size: 12px;
      }
    }
  }
}

.menu_img{
  width: 60px;
  height: 60px;
  display: block;
  margin:0 auto;
}
.mymenu_style{
  display: inline-block;
}
.menu-dropdown .el-dropdown-menu__item{
  padding: 0px 10px !important;
}

</style>

