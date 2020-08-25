<template>
  <div class="bgcw2">
    <div class="pd-10 bgcw2">
      <p class="mb-5 f-16">
        <span class="f-red">*</span> 小组名称
      </p>
      <van-cell-group>
        <van-field v-model="form.groupName" size="large" placeholder="请输入小组名称" />
      </van-cell-group>
    </div>
    <div class="pd-10 bgcw2">
      <p class="mb-5 f-16">
        <span class="f-red">*</span> 责任范围
      </p>
      <van-cell-group>
        <van-field
          v-model="form.areaDes"
          type="textarea"
          placeholder=" 请选择责任范围"
         @click-left-icon="select_area"
          autosize
          left-icon="add"
        />
      </van-cell-group>
    </div>
    <div>
      <van-popup v-model="indexShow" position="bottom" :style="{height:'100%',width:'100%'}">
        <div>
          <div class="text-r pd-10 Bline" >
            <van-button plain hairline type="info" size="small" @click="indexShow = false">取消</van-button>
          </div>
          <div v-for="(item,index) in treeData" :key="item.id" @click="showChildren(item)">
            <van-row class="Bline pd-5 bgcw2">
              <van-col span="21">
                <p class="f-16 h_name h_world ellipsis">{{item.label}}</p>
              </van-col>
              <van-col span="3">
                <van-icon class="h_name c-999" name="arrow" />
              </van-col>
            </van-row>
          </div>
          <div v-for="(item,index) in showpop">
            <van-popup v-model="item.show" position="bottom" :style="{height:'70%',width:'100%'}">
              <div class="content_out">
                <div class="pd-10 text-r Bline">
                  <van-button plain hairline type="info" size="small" @click="sureBtn(item)">确定</van-button>
                </div>
                <div class="content_50">
                  <div class="content_50_2">
                    <div class="content_40_1">
                      <div class="bgcy2">
                        <div v-if="item.children.length > 0" v-for="(son,sonIdx) in item.children">
                          <p
                            class="Bline pd-10 text-c"
                            v-bind:class="{ blue:sonIdx==current}"
                            @click="ckickSon(son,sonIdx,index)"
                          >
                            <span>{{son.label}}</span>
                          </p>
                        </div>
                      </div>
                    </div>
                    <div class="content_50_1">
                      <div style="height:auto;padding-bottom:26.6vw">
                        <div
                        class="pd-10 text-c"
                        v-show="clicked"
                        v-for="(grandson,grandsonidx) in  buildings.children"
                      >
                        <b 
                        class="normal c-333"
                          :class="{checked:arr.includes(grandson.id)}"
                          @click="changeActive(buildings.label,grandson)"
                        >
                          <span>{{grandson.label}}</span>
                        </b>
                      </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </van-popup>
          </div>
        </div>
      </van-popup>
    </div>
    <div class="pd-10 fix_bottom">
      <van-button size="large" type="info" class="van_button_my" @click="saveForm">完成</van-button>
    </div>
  </div>
</template>
<script>
import group from "@/api/socialgroup/group";
import { Dialog } from "vant";
import { Toast } from "vant"; 
export default {
  data() {
    return {
      code: "",
      edit: "",
      current: -1,
      form: {
        groupName: "",
        areaDes: "",
        parentCode: "",
        area: ""
      },
      treeData: [],
      showpop: [],
      arr: [], //存放楼宇的id
      arr2: [], //存放楼宇的中文
      indexShow: false,
      selectTree: [],
      villages: [],
      buildings: ""
    };
  },
  methods: {
    //显示子节点小区
    showChildren(item) {
      if(item.children){
         this.showpop = [];
         
          let idxJson = {
            index: item.index,
            show: true,
            id: item.id,
            label: item.label,
            orgCode: item.orgCode,
            children: item.children
          };
          this.showpop.push(idxJson);
          let _this = this;
          this.arr2 = [];
          item.children.forEach(function(i, index) {
            let json = {
              name: i.label,
              index: index,
              items: []
            };
            _this.arr2.push(json);
          });
      }else{
         this.arr2 = [];
           Dialog({ message: "该社区没有小区！" });
      }
     
    },
    //点击小区 / 显示楼宇
    ckickSon(item, index, idx) {
      this.buildings = this.showpop[0].children[index];
      this.current = index;
      this.clicked = true;   
    },
    //点击楼宇
    changeActive(label, item) {
      // console.log(JSON.stringify(item))
      if (this.arr.includes(item.id)) {
        this.arr = this.arr.filter(function(ele) {
          return ele != item.id;
        });
      } else {
        this.arr.push(item.id);
      }
      let _this = this;
          if(_this.arr2[_this.current].items.length > 0){
            let curritem = false;
            for (let i in _this.arr2[_this.current].items) {
              // console.log(JSON.stringify(_this.arr2)+"---------"+JSON.stringify(_this.arr2[_this.current].items));
                 if (_this.arr2[_this.current].items[i].id == item.id) {
                    _this.arr2[_this.current].items = _this.arr2[this.current].items.filter(function(ele) {
                      return ele.id != item.id;
                    });
                    curritem = true;
                    break;
                 }
              }
              if(curritem == false){
                  _this.arr2[this.current].items.push({
                    label: item.label,
                    id: item.id
                  });
              }
          }else{
            _this.arr2[this.current].items.push({
            label: item.label,
            id: item.id
          });
        }
    },
    sureBtn(item) {
      let _this = this;
      _this.form.area = "";
      _this.form.areaDes = "";
      this.arr.forEach(function(item, index) {
        _this.form.area += item + ",";
      });
      // console.log(JSON.stringify(this.arr2));
      this.arr2.forEach(function(item, index) {
        if(item.items.length > 0){
          _this.form.areaDes += item.name+":";
        }
        item.items.forEach(function(i, k) {
          _this.form.areaDes +=  i.label + ",";
        });
     
      });


      item.show = false;
      this.indexShow = false;
    },
    //选择责任范围
    select_area() {
      this.showpop =[];
      this.buildings="";
      this.treeData=[];
        this.getdutyArea();
      this.indexShow = true;
      
    },
    //保存
    saveForm() {
      //判断必填项
      if (!this.form.groupName) {
        Dialog({ message: "请填写小组名称" });
        return;
      }
      if (!this.form.areaDes) {
        Dialog({ message: "请选择责任范围" });
        return;
      }
      this.submitForm();
      //
    },
    async submitForm() {
      // console.log(JSON.stringify(this.form));
      // return;
      if (this.edit == 1) {
        this.form.code = this.code;
        let res = await group.editGroup(this.form);
      } else {
        let res = await group.addGroup(this.form);
      }
      this.form = {
        groupName: "",
        areaDes: "",
        parentCode: "",
        area: ""
      };
        Toast({
                message:"提交成功",
                position:"bottom",
                duration:1000
                })
      if(this.$route.query.code){
        this.$router.go(-1);
      }else{
        this.$router.replace({name:'group'})
      }
      
    },
    //获取责任范围数据
    async getdutyArea() {
      let res = await group.dutyArea();
      res = JSON.parse(res);
      this.treeData = res;
      // console.log(JSON.stringify(res));
    }
  },
  mounted() {
    if (this.$route.query.code) {
      this.form.parentCode = this.$route.query.code;
    }
    if (this.$route.query.groupName) {
      this.form.groupName = this.$route.query.groupName;
    }
    if (this.$route.query.areaDes) {
      this.form.areaDes = this.$route.query.areaDes;
    }
    if (this.$route.query.area) {
      this.form.area = this.$route.query.area;
    }
    if (this.$route.query.groupCode) {
      this.code = this.$route.query.groupCode;
    }
    this.edit = this.$route.query.edit;
  }
};
</script>
<style scoped>

.fix_bottom {
  /* position: fixed;
    bottom:0px;
    left:0px;
    right: 0px; */
  margin-top: 26.6vw;
}
.h_name {
  height: 10.664vw;
  line-height: 10.664vw;
}
.h_world {
  text-indent: 1.5em;
}
.checked span {
  color: #1989fa;
}
.blue {
  color: #1989fa;
}
.content_out{
   height:100%;
   overflow-y: hidden;
}
.content_50{
    height:100%;

}
.content_50_2{
  width:100%;
  height:100%;
  overflow:hidden;
}
.content_40_1{
  width:40%;
  display:inline-block;
  vertical-align:top;
  height:100%;
  /* overflow:scroll; */
 
}
.content_50_1{
  width:50%;
  height:100%;
  display:inline-block;
  vertical-align:top;
  overflow-y: scroll
}

</style>

