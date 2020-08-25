<template>
  <div>
    <!-- 面包屑导航 -->
    <div class="bread_out ellipsis bgcw2 mb-10 pl-10 pr-10">
      <div class="bread_inner">
        <span
          class="f-blue f-16"
          v-for="(item,index) in breadcrumb"
          @click="breadcrumbClick(index,item)"
        >
          {{item.groupName}}
          <van-icon color="#aaaaaa" size="1em" name="arrow" />
        </span>
      </div>
    </div>
    <div class="my_group" @click="editGroup(groupName,areaDes)">
      <van-row class="Bline bgcw2">
        <van-col span="6" class="h_world">
          <span class="c-666">小组名称:</span>
        </van-col>
        <van-col span="16">
          <p class="f-16 h_nameT pl-10 ml-10 ellipsis">
            <input type="text" readonly v-model="groupName" class="border_none_input" />
          </p>
          <input
            type="text"
            v-if="myGroupList.length > 0"
            readonly
            v-model="groupCode"
            class="border_none_input hide"
          />
        </van-col>
        <van-col span="2">
          <van-icon class="h_name c-999" name="arrow" />
        </van-col>
      </van-row>
    </div>
    <div class="mt-10 pt-10 pb-10 height_new bgcw2">
      <van-row class>
        <van-col span="6" class="h_world h_nameF">
          <span class="c-666">责任范围:</span>
        </van-col>
        <van-col span="16">
          <p class="f-16 pl-10 ml-10 height_p">{{areaDes}}</p>
        </van-col>
        <van-col span="2">
          <!-- <van-icon class="h_name c-666 h_nameF" name="arrow" /> -->
        </van-col>
      </van-row>
    </div>

    <!-- 展示下一子节点 -->
    <div class="mt-10">
      <div
        v-for="(item,index) in myGroupList"
        class="my_group"
        @click="showMyGroupCount(item.code)"
      >
        <van-row class="Bline bgcw2">
          <van-col span="6" class="h_world">
            <span class="c-666">下级名称:</span>
          </van-col>
          <van-col span="16">
            <p class="f-16 h_nameT h_world ellipsis">
              <input type="text" readonly v-model="item.groupName" class="border_none_input pl-20" />
            </p>
          </van-col>
          <van-col span="2">
            <van-icon class="h_name c-999" name="arrow" />
          </van-col>
        </van-row>
      </div>
    </div>

    <div class="f-14 text-c c-666 mt-10 mb-10 line_text" v-show="memberList.length > 0">
      <span>小组成员</span>
    </div>
    <div class="mb-50">
      <div
        v-if="memberList.length > 0"
        class="mg-10 pt-10 pb-10"
        style="background:#ffffff;border-radius:2vw;"
        v-for="(item,index) in memberList"
      >
        <van-row class="pd-5 Bline">
          <van-col span="3">
            <img :src="item.portrait" alt class="circleImage mt-10" />
          </van-col>
          <van-col span="18">
            <div class="pd-10">
              <p class="mb-10">
                <span class="f-15 mr-10">{{item.realname}}</span>
                <span class="f-14 c-666">{{item.group_name}}</span>
              </p>
              <p class="f-12 c-666 mt-5 mb-5">
                <span>联系电话:</span>
                <span class="f-blue">{{item.mobilePhone}}</span>
              </p>
              <p class="f-12 c-666 mt-5">
                <span>责任范围:</span>
                <!-- {{areaDes}} -->
              </p>
            </div>
          </van-col>
          <van-col span="3">
            <span class="f-red f-16" @click="delMember(item.id,item.code,index)"  v-show="member == 1">
              <van-icon name="delete" />
            </span>
          </van-col>
        </van-row>
        <van-row class="pt-5">
          <van-col span="24">
            <div class="pl-10 pt-5 pb-5" @click="isDetail(item.id,1,item.code)">
              <van-row>
                <van-col span="3">
                  <van-icon size="7.46vw" color="#999" name="sign" />
                </van-col>
                <van-col span="18">
                  <span class="f-16 h_name">收集民情民意</span>
                </van-col>
                <van-col span="3" class>
                  <span class="c-999 f-14 h_name">
                    {{item.willCount}}
                    <van-icon name="arrow" />
                  </span>
                </van-col>
              </van-row>
            </div>
          </van-col>
          <van-col span="24">
            <div class="pl-10 pt-5 pb-5" @click="isDetail(item.id,0,item.code)">
              <van-row>
                <van-col span="3">
                  <van-icon size="7.46vw" color="#999" name="sign" />
                </van-col>
                <van-col span="18">
                  <span class="f-16 h_name">入户调查数</span>
                </van-col>
                <van-col span="3">
                  <span class="c-999 f-14 h_name">
                    {{item.investCount}}
                    <van-icon name="arrow" />
                  </span>
                </van-col>
              </van-row>
            </div>
          </van-col>
        </van-row>
      </div>
      <div v-if="memberList.length == 0" class="text-c pt-10 mt-30 c-666">暂无小组成员</div>
    </div>
    <div class="bottom_menu pt-16 pr-10 pb-16 pl-10" v-show="member == 1">
      <van-row>
        <van-col span="8">
          <div class="text-c" @click="addMember">添加成员</div>
        </van-col>
        <van-col span="8">
          <div class="text-c" @click="addGroup">添加下级</div>
        </van-col>
        <van-col span="8">
          <div class="text-c f-red" @click="delGroup">删除小组</div>
        </van-col>
      </van-row>
    </div>
  </div>
</template>
<script>
import group from "@/api/socialgroup/group";
import { Dialog } from "vant";
export default {
  data() {
    return {
      code: "",
      myGroupList: [],
      memberList: [],
      pointName: "",
      groupName: "", //父节点的名称
      groupCode: "", //父节点的名称
      areaDes: "", //对应节点的责任范围
      area:"",//对应节点的责任范围code
      breadcrumb: [], //面包屑导航回到上一级
      member: "" //0：不是该小组的成员，1：是该小组的成员
    };
  },
  methods: {
    //点击添加成员页面
    async addMember() {
      // let res = await group.addMember();
      this.$router.push({
        path: `/addmember`,
        query: {
          code: this.groupCode
        }
      });
    },
    //点击添加下级页面
    addGroup() {
      this.$router.push({
        path: `/addgroup`,
        query: {
          code: this.groupCode
        }
      });
    },
    //点击删除小组
    delGroup() {
      let _this = this;
      Dialog.confirm({
        message: "确认删除该小组吗？"
      })
        .then(() => {
          _this.sureDelGroup(_this.groupCode);

        })
        .catch(() => {});
    },
    async sureDelGroup(code) {
      let res = await group.delGroup(code);
      //删除小组页面显示到父节点的位置
      this.$router.go(0);
    },
    breadcrumbClick(index, item) {
      this.breadcrumb.splice(index, this.breadcrumb.length - index);
      this.showMyGroupCount(item.code);
    },
    //详情
    async showMyGroupCount(code) {
      let res = await group.showMyGroupCount(code);
      // console.log(res);
      if (res) {
        res = JSON.parse(res);
        this.breadcrumb.push(res.groupDetail);
        this.myGroupList = res.groupList;
        let _this = this;
        if(res.memberList){
            res.memberList.forEach(function(item,index){
              if(item.portrait) 
              item.portrait = _this.common.showPicture(item.portrait)
            });
        }
        this.memberList = res.memberList;
        this.groupName = this.breadcrumb[this.breadcrumb.length - 1].groupName;
        this.groupCode = this.breadcrumb[this.breadcrumb.length - 1].code;
        this.areaDes = this.breadcrumb[this.breadcrumb.length - 1].dutyAreaDes;
        this.area = this.breadcrumb[this.breadcrumb.length - 1].dutyArea;
        this.member = res.member;
      } else {
      }
    },
    //点击小组名称  修改小组信息
    editGroup(groupName,areaDes) {
      // console.log(groupName,areaDes);
      this.$router.push({
        path: `/addgroup`,
        query: {
          groupName: groupName,
          areaDes:areaDes,
          area:this.area,
          groupCode:this.groupCode,
          edit:1
        }
      });
    },
    async isDetail(id, index, code) {
      let res = await group.isDetail(code);
      // res = JSON.parse(res);
      if (res == "yes") {
        this.$router.push({
          path: `/collection`,
          query: {
            index: index,
            id: id
          }
        });
      }
      if (res == "no") {
        Dialog({ message: "暂无被调查数据" });
      }
    },
    //删除小组成员
    async delMember(id, code, index) {
      let _this = this;
      Dialog.confirm({
        message: "确认删除该成员吗？"
      })
        .then(() => {
          _this.sureDel(id, code, index);
        })
        .catch(() => {});
    },
    async sureDel(id, code, index) {
      let res = await group.delMember(id, code);
      this.memberList.splice(index, 1);
    }
  },
  mounted() {
    this.code = this.$route.query.code;
    this.groupName = this.$route.query.name;

    this.showMyGroupCount(this.code);
  },
  created() {}
};
</script>
<style scoped>
.bread_out {
  width: 100%;
  overflow: hidden;
  height: 13.3vw;
  line-height: 13.3vw;
}
.bread_inner {
  overflow-x: scroll;
}
.my_group {
  height: 13.33vw;
}
.my_group div {
  height: 100%;
  line-height: 13.33vw;
}
.area_span {
  height: 100%;
}
.area {
  display: inline-block;
  height: 100%;
  margin-top: 3.66vw;
  text-indent: 1.5em;
}
.height_new {
  height: 26.6vw;
  overflow: hidden;
}
.height_p {
  height: 20vw;
  overflow: scroll;
  padding-top: 1.33vw;
  line-height: 6vw;
  min-height: 20vw;
}
.h_nameT {
  height: 13.33vw;
  line-height: 13.33vw;
}
.h_nameF {
  padding-top: 1.33vw;
  line-height: 8vw;
  min-height: 26.6vw;
}
.h_name {
  height: 7.46vw;
  line-height: 7.46vw;
}
.h_world {
  text-indent: 0.5em;
}
.bottom_menu {
  position: fixed;
  bottom: 0px;
  left: 0px;
  right: 0px;
  background: #1989fa;
  color: #fff;
}
</style>


