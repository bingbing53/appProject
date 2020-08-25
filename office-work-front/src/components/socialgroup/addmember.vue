<template>
  <div>
    <div class="bgcw2 pt-20  fixedTop" id="fixedTop2">
      <div v-if="checkedList.length > 0" class="mt-10 pl-10 pr-10 ">
        <div v-for="(item,index) in checkedList" class="mr-5 mb-5 ml-5" style="display:inline-block;">
            <div class="circleImage" v-if="item.portrait">
                <img
                    :src="item.portrait"
                    class="avatar border_radius"
                    width="47.88vw"
                    height="47.88vw"
                  />
            </div>
             <div v-else class="circleImage name_image">
                <span> {{item.name2}}</span>
             </div>
        </div>
      </div>
     
        <input v-model="searchValue" placeholder="请输入姓名搜索"  @keyup="searchName" class="myinput" id="myinput" @focus="myfocus" @blur="myblur" />
    </div>
    <div class="wrapper" id="wrapper">
      <div class="content mt-10">
        <van-index-bar :index-list="indexList" sticky-offset-top="100">
          <div v-for="(item,index) in memberArr" :key="index">
              <van-index-anchor :index="item.letter">{{item.letter}}</van-index-anchor>
                <van-cell v-for="(item2,index2) in item.list">
                  <van-row>
                  <van-col span="4">
                    <div class="circleImage" v-if="item2.portrait">
                      <img
                        :src="item2.portrait"
                        class="avatar border_radius"
                        width="47.88vw"
                        height="47.88vw"
                      />
                    </div>
                    <div v-else class="circleImage name_image">
                        <span> {{item2.name2}}</span>
                    </div>
                  </van-col>
                  <van-col span="17">
                    <div class="name v_middle h_name">{{ item2.realname }}</div>
                  </van-col>
                  <van-col span="3">
                    <div class="h_name">
                      <input
                        type="checkbox"
                        :value="item2.id"
                        v-model="checkedArr"
                        @change="checked_change($event,item2,index2)"
                      />
                    </div>
                  </van-col>
                </van-row>
                </van-cell>
          </div>
        </van-index-bar>
      </div>
    </div>
    <div class="fixedBottom">
      <van-row>
        <van-col span="24">
          <van-button class="right f-b f-blue" type="default" size="large" @click="saveBtn">添&nbsp;加</van-button>
       </van-col>
      </van-row>
    </div>

  </div>
</template>
<script>
import group from "@/api/socialgroup/group";
import vPinyin from "@/api/vue-py";
import { stringify } from "querystring";
import BScroll from "@better-scroll/core";

export default {
  data() {
    return {
      // indexList: ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"],
      indexList: [],
      memberArr: [],//显示在页面上的数组
      newmemberArr:[],//全部数据的数组
      checkedList:[],//被选中的人的数组
      checkedArr: [],
      shortcutList: [],
      code: "",
      currentIndex:0,
      searchValue:"",
    };
  },
  methods: {
    myfocus(){
      document.getElementById("myinput").style.borderBottomColor = '#1989fa'
    },
    myblur(){
      document.getElementById("myinput").style.borderBottomColor = '#ccc'
    },
    //自定义搜索功能
    searchName(){
       if(this.checkedList.length == 0){
        document.getElementById("wrapper").style.marginTop = '70px';
      }
      let n = Number(this.searchValue);
      let index = -1;
          if (!isNaN(n)){
              index = n-1;
          }

        let _this = this;
      if(this.memberArr.length > 0 && this.searchValue){
        this.memberArr = [];
        this.newmemberArr.forEach(function(item,pos){
          item.list.forEach(function(item2,pos2){
            if(item2.realname.indexOf(_this.searchValue) != -1){

              _this.memberArr.push({"list":[item2]});
              _this.indexList = [];
              
            }else{
            }
          })
        })
      }else{
         this.indexList=[];
         this.memberArr =  this.newmemberArr;
         let _this = this;
           this.newmemberArr.forEach(function(item,index){
            _this.indexList.push(item.letter);
          })
      }
    },
    //获取成员
    async getMemberList() {
      let res = await group.addMemberList();
      res = JSON.parse(res);
      let _this = this;
      this.memberArr = res;
      
      this.memberArr.forEach(function(item, index) {
        if(item.realname.length > 2){
            item.name2 = item.realname.substring(1,3);
        }else{
             item.name2 = item.realname;
        }
        
        if(item.portrait){
            item. portrait = _this.common.showPicture(item. portrait);
        }
     
        _this.memberArr[index].pyName = vPinyin.chineseToPinYin(item.realname);
      });

      let resault = data_letter_sort(this.memberArr, "pyName");
      resault.forEach(function(item,index){
        _this.indexList.push(item.letter);
      })
      this.memberArr = resault;
      this.newmemberArr = resault;
      // console.log(JSON.stringify(this.memberArr))
    },
    checked_change(e,item2, index2) {
      let _this = this;
      if(e.target.checked){
        this.checkedList.push(item2);
      }else{
        this.checkedList.forEach(function(item,index){
            if(item.id == item2.id) 
              _this.checkedList.splice(index,1)
        })
      }
       if(this.checkedList.length == 0){
        document.getElementById("wrapper").style.marginTop = '70px';
      }
      else if(this.checkedList.length <= 7 && this.checkedList.length != 0){
        document.getElementById("wrapper").style.marginTop = '120px';
      }
    
      else if(this.checkedList.length > 7 && this.checkedList.length <= 14){
      document.getElementById("wrapper").style.marginTop = '170px';
      }
      else if(this.checkedList.length > 14 && this.checkedList.length <= 21){
      document.getElementById("wrapper").style.marginTop = '210px';
      }else{
        document.getElementById("wrapper").style.marginTop = '250px';
      }
    },
    //点击保存
    async saveBtn() {
      if (this.checkedArr.length > 0) {
        let _this = this;
        let persons = "";
        this.checkedArr.forEach(function(item, index) {
          persons += item + ",";
        });
        // console.log(persons);
        let res = await group.addMember(persons, this.code);
        this.$router.go(-1);
      }else{

      }
    },
    back() {
      this.$router.go(-1);
    }
  },
  mounted() {
    this.code = this.$route.query.code;
    this.getMemberList();
  },
  created() {
 
   
  },


};

function data_letter_sort(data, field) {
  var letter_reg = /^[A-Z]$/;

  var list = new Array();
  var letter;
  var items = new Array();

  for (var i = 0; i < data.length; i++) {
    // 添加 # 分组，用来 存放 首字母不能 转为 大写英文的 数据

    list["#"] = new Array();

    // 首字母 转 大写英文

    letter = data[i][field].substr(0, 1).toUpperCase();

    // 是否 大写 英文 字母

    if (!letter_reg.test(letter)) {
      letter = "#";
    }

    // 创建 字母 分组

    if (!(letter in list)) {
      list[letter] = new Array();
      // items = new Array();
    }

    // 字母 分组 添加 数据

    list[letter].push(data[i]);
    // items.push(data[i]);
  }

  // 转换 格式 进行 排序；

  var resault = new Array();

  for (var key in list) {
    resault.push({
      letter: key,

      list: list[key]
    });
  }

  resault.sort(function(x, y) {
    return x.letter.charCodeAt(0) - y.letter.charCodeAt(0);
  });

  // # 号分组 放最后

  var last_arr = resault[0];

  resault.splice(0, 1);

  resault.push(last_arr);

  return resault;
}

</script>
<style scoped>

.avatar {
  vertical-align: middle;
}
.left_bar {
  position: fixed;
  top: 30vw;
  right: 0vw;
  padding: 1.5vw;
  /* background: #fff; */
  z-index: 2;
  
}
.left_bar li {
  margin-bottom: 1.5vw;
  text-align: center;
}
.h_name {
  height: 10.664vw;
  line-height: 10.664vw;
}
.fixedTop{
  position: fixed;
  top:0px;
  left:0px;
  right: 0px;
  background: #fff;
  z-index: 999
}
.fixedBottom{
  position: fixed;
  bottom:0px;
  left:0px;
  right: 0px;
  background: #fff;
  z-index: 999
}
.name_image{
  background: #1989fa;
  line-height: 10.664vw;
  text-align: center;
  color: #fff;
  font-size: 3.733vw;
}
.wrapper{
  margin-top:120px;
  margin-bottom: 100px;
}
.myinput{
  border:none;
  width: 100%;
  padding:2.66vw;
  border-bottom: 1px solid #ccc;
}

</style>


