<template>
  <f7-page class="bgcg">
    <div class="bgcw">
      <van-row
        class="f-16 mb-20 mt-20 bgcw pd-10 border-radius8"
        @click="toShowType"
      >
        <van-col :span="16">选择民意分类</van-col>
        <van-col :span="8" class="tr">
          <span v-if="form.willType">{{name}}</span>
          <van-icon v-else name="arrow" color="#666666" />
        </van-col>
      </van-row>

      <van-row class="f-16 mb-20 bgcw pd-10 border-radius8">
        <van-col :span="24">
          <p>反馈标题</p>
          <van-field
            v-model="form.title"
            placeholder="请输入反馈标题"
          />
        </van-col>
        <van-col :span="24">
          <p>反馈描述</p>
          <van-field
            v-model="form.content"
            placeholder="请输入反馈描述"
            rows="3"
            autosize
            type="textarea"
          />
        </van-col>

        <van-col :span="24">
          <p>反馈地址</p>
          <van-field
            v-model="form.address"
            placeholder="请输入反馈地址"
            clearable
          />
          <div class="fr mt-10 mr-10 mb-10">
            <van-button type="danger" size="small" @click="geoLocation">获取定位</van-button>
          </div>
        </van-col>
      </van-row>
    </div>

    <div class="bgcw pd-10  border-radius8">
      <f7-row>
         <f7-col width="100" class="mb-10">添加图片 </f7-col>
        <f7-col v-for="(item,index) in imageArr" width="33" class="fl" style="position:relative">
          <img :src="item" id="img" />
          <div class="iconfont icon-chahao" @click="deleteMulPic(index)"></div>
        </f7-col>
        <f7-col width="33" v-if="imageArr.length <= 2" class="Mainpicture fl">
          <van-icon name="plus" size="20" color="#666" @click="choiseImage" />
        </f7-col>
        <div class="clear"></div>
      </f7-row>
    </div>
    <van-row class="mt-50">
      <van-col :span="18" offset="3">
        <van-button round type="danger" @click="submitWillRecord()">提交反馈</van-button>
      </van-col>
    </van-row>
    <van-popup v-model="showType" closeable position="bottom" :style="{ height: '90%' }" round>
      <div class="pd-10 mt-20">
        <p class="f-18 mb-10 tc f-b">选择分类</p>
        <div v-for="item in categorys" class="mb-10">
          <div class="pb-10" v-if="item.children.length >0">
            <p v-if="item.children.length >0" class="f-16 pt-10 broder_t mb-10">{{item.title}}</p>
            <div v-if="item.children.length >0">
              <span
                class="bgcg pd-5 inlineBlock mg-5 border-radius3 f-14 c-666"
                :class="{redBgc:child.key ==current}"
                v-for="(child,idx) in item.children"
                @click="sureType(child.code,child.key,child.title)"
              >{{child.title}}</span>
            </div>
          </div>
        </div>
      </div>
    </van-popup>
  </f7-page>
</template>

<script>
import { categoryList, uploadBase64Image } from "@/api/api_common";
import { addTakePicture } from "@/api/api_community";
export default {
  data() {
    return {
      showType: false,
      current: 0,
      imageArr: [],
      categorys: [],
      name: "",
      form: {
        willType: "",
        title: "",
        des: "",
        address: "",
        longitude: "",
        latitude: ""
      }
    };
  },
  created() {
    this.getCategory();
    this.$commonUtils.setTitle("随手拍");

    let that = this;
    wx.init(function() {
      that.geoLocation();
    });
  },
  methods: {
    toShowType() {
      this.showType = true;
    },
    sureType(code, index, title) {
      this.current = index;
      this.form.willType = code;
      this.name = title;
    },
    //提交随手拍
    async submitWillRecord() {
      if (!!!this.form.willType) {
        wx.toast("请选择民意分类");
        return;
      }
      if (!!!this.form.title) {
        wx.toast("请填写反馈标题");
        return;
      }
      if (!!!this.form.address) {
        wx.toast("请填写反馈地址");
        return;
      }
      //先上传图片
      let that = this;
      var resultArr = [];
      if (this.imageArr.length > 0) {
        wx.loading("图片上传中");
        for (var i = 0; i < this.imageArr.length; i++) {
          var result = await uploadBase64Image({
            upfile: this.imageArr[i]
          }).catch(err => {
            wx.toast("上传失败");
            wx.closeLoading();
            return;
          });
          if (result.status == 200) {
            resultArr.push(result.data["url"]);
          }
        }
        wx.closeLoading();
        this.form.image = JSON.stringify(resultArr);
      }
      addTakePicture(this.form)
        .then(res => {
          this.form = {
            willType: "",
            title: "",
            des: "",
            address: "",
            longitude: "",
            latitude: ""
          };
          this.imageArr = [];
          wx.toast("提交成功");
           this.$f7router.navigate(`/community/takePictureList`);
        })
        .catch(err => {
          wx.toast("提交失败，请稍后重试");
        });
    },
    //获取分类字典
    getCategory() {
      categoryList("A04")
        .then(res => {
          this.categorys = res.data;
        })
        .catch(err => {
          this.$commonUtils.jumpLogin(err);
        });
    },
    //删除一个图片
    deleteMulPic(index) {
      this.$delete(this.imageArr, index);
      // this.imageArr.slice(this.imageArr.indexOf(index),1);
      // this.$forceUpdate();
    },
    //选择图片
    choiseImage() {
      let that = this;
      wx.choiseImage({
        source: "camera",
        success: function(res) {
          that.imageArr.push(res);
        }
      });
    },
    geoLocation() {
      let that = this;
      wx.geoLocation({
        success: function(result) {
          var json = JSON.parse(result);
          that.form.address = json["address"];
          that.form.latitude = json["latitude"];
          that.form.longitude = json["longitude"];
        },
        error: function(err) {
          wx.toast(err);
        }
      });
    }
  }
};
</script>
<style scoped>
#img {
  width: 100%;
  height: 100px;
  border-radius: 5px;
}
.Mainpicture {
  float: left;
  width: 100px;
  height: 100px;
  line-height: 100px;
  text-align: center;
  background: rgba(255, 255, 255, 1);
  border-radius: 2px;
  border: 1px solid #e5e9f2;
  /* margin-left: -100px; */
}
.icon-chahao {
  cursor: pointer;
  position: absolute;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  text-align: center;
  top: -5px;
  right: -5px;
  color: #fff;
  background: rgba(0, 0, 0, 0.5);
}
.icon-jia1 {
  text-align: center;
  width: 20px;
  height: 20px;
  line-height: 0px;
  color: #bfc5d1;
  padding-top: 50px;
  padding-left: 45px;
  cursor: pointer;
}
.redBgc {
  background:#ee0a24 !important;
  color: #fff!important;
}
</style>