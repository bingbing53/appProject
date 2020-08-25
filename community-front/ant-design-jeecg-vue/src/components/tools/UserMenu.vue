<template>
  <div class="user-wrapper" :class="theme">
    <!--<span class="action">
      <a class="logout_title" target="_blank" href="http://jeecg-boot.mydoc.io">
        <a-icon type="question-circle-o"></a-icon>
      </a>
    </span>-->
    <span class="action" @click="showClick">
      <a-icon type="search"></a-icon>
    </span>
    <span v-show="shows" class="borders">
      <a-select
        class="search-input"
        showSearch
        :showArrow="false"
        placeholder="搜索菜单"
        optionFilterProp="children"
        :filterOption="filterOption"
        @change="searchMethods"
        @blur="hiddenClick"
      >
        <a-select-option v-for="site in search " :value="site.id">{{site.meta.title}}</a-select-option>
      </a-select>
    </span>
    <header-notice class="action"/>
    <a-dropdown :trigger="['click']">
      <a class="ant-dropdown-link link_system action" href="#">
         <a-icon type="appstore" />
      </a>
      <a-menu slot="overlay">
         <a-menu-item :key="item.id" class="mymenu_style" v-for="(item,index) in sysstem_menu">
          <a :href="item.url">
            <img :src="item.icon" class="menu_img">
            <span>{{item.name}}</span>
          </a>
        </a-menu-item>
      </a-menu>
    </a-dropdown>
    <a-dropdown>
      <span class="action action-full ant-dropdown-link user-dropdown-menu">
        <a-avatar class="avatar" size="small" :src="getAvatar()"/>
        <span v-if="isDesktop()">欢迎您，{{ nickname() }}</span>
      </span>
      <a-menu slot="overlay" class="user-dropdown-menu-wrapper">
        <!--<a-menu-item key="0">
          <router-link :to="{ name: 'account-center' }">
            <a-icon type="user"/>
            <span>个人中心</span>
          </router-link>
        </a-menu-item>
        <a-menu-item key="1">
          <router-link :to="{ name: 'account-settings-base' }">
            <a-icon type="setting"/>
            <span>账户设置</span>
          </router-link>
        </a-menu-item>
        <a-menu-item key="3"  @click="systemSetting">
           <a-icon type="tool"/>
           <span>系统设置</span>
        </a-menu-item>-->
        <a-menu-item key="4" @click="updatePassword">
          <a-icon type="setting"/>
          <span>密码修改</span>
        </a-menu-item>
        <a-menu-item key="5" @click="updateCurrentDepart">
          <a-icon type="cluster"/>
          <span>切换部门</span>
        </a-menu-item>
       <!-- <a-menu-item key="2" disabled>
          <a-icon type="setting"/>
          <span>测试</span>
        </a-menu-item>
        <a-menu-divider/>
        <a-menu-item key="3">
          <a href="javascript:;" @click="handleLogout">
            <a-icon type="logout"/>
            <span>退出登录</span>
          </a>
        </a-menu-item>-->
      </a-menu>
    </a-dropdown>
    <span class="action">
      <a class="logout_title" href="javascript:;" @click="handleLogout">
        <a-icon type="logout"/>
        <span v-if="isDesktop()">&nbsp;退出登录</span>
      </a>
    </span>
    <user-password ref="userPassword"></user-password>
    <depart-select ref="departSelect" :closable="true" title="部门切换"></depart-select>
    <setting-drawer ref="settingDrawer" :closable="true" title="系统设置"></setting-drawer>
  </div>
</template>

<script>
  import HeaderNotice from './HeaderNotice'
  import UserPassword from './UserPassword'
  import SettingDrawer from "@/components/setting/SettingDrawer";
  import DepartSelect from './DepartSelect'
  import { mapActions, mapGetters,mapState } from 'vuex'
  import { mixinDevice } from '@/utils/mixin.js'
  import {permissionmenu} from '@/api/api'

  import Vue from 'vue'
  import { ACCESS_TOKEN } from '@/store/mutation-types'
  export default {
    name: "UserMenu",
    mixins: [mixinDevice],
    components: {
      HeaderNotice,
      UserPassword,
      DepartSelect,
      SettingDrawer
    },
    props: {
      theme: {
        type: String,
        required: false,
        default: 'dark'
      }
    },
    data(){
      return{
        //菜单搜索
        search:[],
        shows:false,
        token:'',
        sysstem_menu:[]
        }
      },
    computed: {
      ...mapState({
        // 后台菜单
        permissionMenuList: state => state.user.permissionList

      })
    },
    methods: {
      /* update_begin author:zhaoxin date:20191129 for: 做头部菜单栏导航*/
      showClick(){
        this.shows = !this.shows
      },
      hiddenClick(){
        this.shows = false
      },
      /* update_end author:zhaoxin date:20191129 for: 做头部菜单栏导航*/
      ...mapActions(["Logout"]),
      ...mapGetters(["nickname", "avatar","userInfo"]),
      getAvatar(){
        console.log(window._CONFIG['domianURL'] + "/sys/common/view/"+this.avatar());
        return window._CONFIG['domianURL'] + "/sys/common/view/"+this.avatar()
      },
      handleLogout() {
        const that = this

        this.$confirm({
          title: '提示',
          content: '真的要注销登录吗 ?',
          onOk() {
            return that.Logout({}).then(() => {
                window.location.href="/";
              //window.location.reload()
            }).catch(err => {
              that.$message.error({
                title: '错误',
                description: err.message
              })
            })
          },
          onCancel() {
          },
        });
      },
      updatePassword(){
        let username = this.userInfo().username
        this.$refs.userPassword.show(username)
      },
      updateCurrentDepart(){
        this.$refs.departSelect.show()
      },
      systemSetting(){
        this.$refs.settingDrawer.showDrawer()
      },
      getperssionmenu(){
        var params = {
        token: this.token
      }
        permissionmenu(params).then(res => {
        console.log(JSON.stringify(res));
        if(res.success){
          res.result.forEach((item,index) => {
            item.icon = window._CONFIG['imgDomainURL'] +"/" +item.icon;
          });
            this.sysstem_menu = res.result;
        }
      })
      },
      /* update_begin author:zhaoxin date:20191129 for: 做头部菜单栏导航*/
      searchMenus(arr,menus){
        for(let i of menus){
          if(!i.hidden && "layouts/RouteView"!==i.component){
            arr.push(i)
          }
          if(i.children&& i.children.length>0){
            this.searchMenus(arr,i.children)
          }
        }
      },
      filterOption(input, option) {
        return option.componentOptions.children[0].text.toLowerCase().indexOf(input.toLowerCase()) >= 0
      },
      searchMethods(value){
        let jump = this.search.filter(item=>item.id==value)
        this.$router.push({ path:jump[0].path})
      }
      /*update_end author:zhaoxin date:20191129 for: 做头部菜单栏导航*/
    },
    mounted(){
      let depart = this.userInfo().orgCode;
      if(!depart){
        this.updateCurrentDepart();
      }
      this.getperssionmenu();
    },
    created(){
      const token = Vue.ls.get(ACCESS_TOKEN)
      this.token = token;

    let lists = []
    console.log("permissionMenuList: ",this.permissionMenuList)
    this.searchMenus(lists,this.permissionMenuList)
    this.search=[...lists]
    console.log(this.search)

    }
  }
</script>

<style lang="scss" scoped>
  /* update_begin author:zhaoxin date:20191129 for: 让搜索框颜色能随主题颜色变换*/
  /* update-begin author:sunjianlei date:20191220 for: 解决全局样式冲突问题 */
  .user-wrapper .search-input {
    width: 180px;
    color: white;

    /deep/ {
      .ant-select-selection {
        background-color: inherit;
        border: 0;
        border-bottom: 1px solid white;
      }

      .ant-select-selection__placeholder,
      .ant-select-search__field__placeholder {
        color: inherit;
      }
    }
  }
  /* update-end author:sunjianlei date:20191220 for: 解决全局样式冲突问题 */
  /* update_end author:zhaoxin date:20191129 for: 让搜索框颜色能随主题颜色变换*/
</style>

<style scoped>
  .logout_title {
    color: inherit;
    text-decoration: none;
  }
  .link_system{
    color: #ffffff;
  }
  .menu_img{
    width: 50px;
    height: 50px;
    display: block;
    margin:0 auto;
  }
  .mymenu_style{
    display: inline-block;
  }
</style>