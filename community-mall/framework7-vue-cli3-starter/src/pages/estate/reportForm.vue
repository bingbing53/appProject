<template>
  <f7-page class="bgcg">
    <div>
      <div class="bgcw pd-10 border-radius8 mt-20 mb-20">
        <div class="mb-10 f-b">请选择问题种类</div>
        <div>
          <p
            class="item_problemType"
            :class="current ==index?'active':''"
            v-for="(item,index) in problemtypeList"
            :key="index"
            @click="select_problemType(item.value,index)"
          >{{item.text}}</p>
        </div>
      </div>
      <div class="bgcw pd-10 border-radius8 mb-20">
        <div class="f-b">小区的不文明行为，如乱停车，环境问题等，请及时反馈</div>
        <div>
          <f7-list inline-labels no-hairlines-md>
            <f7-list-input
              type="textarea"
              :value="form.content"
              @input="form.content = $event.target.value"
              placeholder="请详细描述"
            ></f7-list-input>
          </f7-list>
        </div>
      </div>
      <div class="bgcw pd-10 border-radius8 mb-20">
        <f7-row>
          <f7-col width="100" class="mb-10 f-b">添加现场图片</f7-col>
          <f7-col
            v-for="(item,index) in imagesList"
            width="33"
            class="fl"
            style="position:relative"
          >
            <img :src="item" id="img" />
            <div class="iconfont icon-chahao" @click="deleteMulPic(index)"></div>
          </f7-col>
          <f7-col width="33" v-if="imagesList.length <= 2" class="Mainpicture fl">
            <van-icon name="plus" size="20" color="#666" @click="showPicture" />
          </f7-col>
          <div class="clear"></div>
        </f7-row>
      </div>

      <div class="mt-50 pb-10">
        <van-row>
          <van-col :span="18" offset="3">
            <van-button
              round
              class="my_bottom"
              type="danger"
              no-fast-click="false"
              @click="submit"
            >提交</van-button>
          </van-col>
        </van-row>
      </div>
    </div>
    <van-popup v-model="showPictureType" position="bottom" :style="{ height: '24%' }">
      <p class="pd-10 mb-10">选择方式</p>
      <van-cell title="相机" @click="choiseImage(0)" />
      <van-cell title="相册" @click="choiseImage(1)" />
    </van-popup>
  </f7-page>
</template>

<script>
import { reportType, addReport } from "@/api/api_estate";
import { uploadBase64Image } from "@/api/api_common";
export default {
  data() {
    return {
      current: -1,
      problemtypeList: [],
      imagesList: [],
      showPictureType: false,
      form: {
        content: "",
        feedType: ""
      }
    };
  },
  methods: {
    select_problemType(code, index) {
      this.current = index;
      this.form.feedType = code;
    },
    async getreportTypeList() {
      let res = await reportType("feedbackType");
      this.problemtypeList = res.data.result;
    },
    //删除一个图片
    deleteMulPic(index) {
      this.$delete(this.imagesList, index);
    },
    showPicture() {
      this.showPictureType = true;
    },
    //上传图片
    choiseImage(value) {
      let that = this;
      if (value == 0) {
        wx.choiseImage({
          source: "camera",
          success: function(res) {
            that.imagesList.push(res);
          }
        });
      } else if (value == 1) {
        wx.choiseMultiImage({
          maxSelected: 3,
          success: function ready(value) {
            value = eval(value);
            value.forEach((el, index) => {
              that.imagesList.push(el);
            });
            // }
          }
        });
      }
      this.showPictureType = false;
    },
    async submit() {
      if (!this.form.feedType) {
        wx.toast("请选择问题种类");
        return;
      }
      if (!this.form.content) {
        wx.toast("请描述问题详情");
        return;
      }
      let that = this;
      let resultArr = [];

      if (this.imagesList.length > 0) {
        wx.loading("图片上传中");
        for (var i = 0; i < this.imagesList.length; i++) {
          var result = await uploadBase64Image({
            upfile: this.imagesList[i]
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
        this.form.image = resultArr.join(",");
      }
      addReport(this.form)
        .then(res => {
          this.form = {
            feedType: "",
            content: ""
          };
          this.imagesList = [];
          (this.current = -1), wx.toast("提交成功");
          this.$f7router.navigate(`/estate/Report`, {
            clearPreviousHistory: true
          });
        })
        .catch(err => {
          wx.toast("提交失败，请稍后重试");
        });
    }
  },
  mounted() {
    this.getreportTypeList();
  },
  created() {
    this.$commonUtils.setTitle("报事");
  }
};
</script>
<style scoped>
.item_problemType {
  border: 1px solid #eee;
  border-radius: 4px;
  padding: 3px 20px;
  margin: 5px;
  display: inline-block;
}
.active {
  background-color: #ee0a24;
  color: #fff;
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
#img {
  width: 100%;
  height: 100px;
  border-radius: 5px;
}
</style>