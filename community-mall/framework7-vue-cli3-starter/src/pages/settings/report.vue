<template>
  <f7-page>
    <div class="bgcg pt-10 pb-10 pl-10 c-666">问题类型</div>
    <van-radio-group v-model="form.type">
      <van-cell-group>
        <van-cell
          :title="item.title"
          clickable
          @click="form.type = item.value"
          v-for="item in questionDict"
        >
          <van-radio slot="right-icon" :name="item.value" checked-color="#ee0a24" />
        </van-cell>
      </van-cell-group>
    </van-radio-group>

    <div class="bgcg pt-10 pb-10 pl-10 c-666">问题和意见（必填）</div>
    <van-field
      v-model="form.content"
      rows="5"
      autosize
      type="textarea"
      maxlength="150"
      placeholder="请简要描述您的问题和意见"
      show-word-limit
    />
    <div class="bgcg pt-10 pb-10 pl-10 c-666">上传图片（最多四张）</div>
    <div class="imageArea" v-if="imageArr.length > 0" v-for="(item,index) in imageArr">
      <img :src="item" alt width="100%" height="100%" />
    </div>
    <div class="uploadArea" @click="choiseImage" v-if="imageArr.length <= 3">+</div>

    <van-button type="danger" round class="mt-20 mb-20 pl-10 pr-10" @click="submitForm">提 交 反 馈</van-button>
  </f7-page>
</template>

<script>
import {
  dictCodeList,
  reportQuestion,
  uploadBase64Image
} from "@/api/api_common.js";
export default {
  data() {
    return {
      form: {
        type: -1,
        content: "",
        images: ""
      },
      imageArr: [],
      questionDict: []
    };
  },
  created() {
    this.$commonUtils.setTitle("问题反馈");
    this.getDictCode();
  },
  methods: {
    //提交反馈
    async submitForm() {
      if (!!!this.form.type) {
        wx.toast("请选择反馈分类");
        return;
      }
      if (!!!this.form.content) {
        wx.toast("请填写反馈内容");
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
        this.form.images = JSON.stringify(resultArr);
      }
      //上报app问题
      reportQuestion(this.form)
        .then(res => {
          wx.toast("反馈成功");

          this.form = {
            type: -1,
            content: "",
            images: ""
          };
          this.imageArr = [];
        })
        .catch(err => {
          wx.toast("反馈失败");
        });
    },
    //删除一个图片
    deleteMulPic(index) {
      this.$delete(this.imageArr, index);
    },
    //上传图片
    choiseImage() {
      let that = this;
      wx.choiseImage({
        success: function(value) {
          that.imageArr.push(value);
        }
      });
    },
    getDictCode() {
      dictCodeList("jmapp_question")
        .then(res => {
          this.questionDict = res.data;
        })
        .catch(err => {});
    }
  }
};
</script>
<style scoped>
.uploadArea {
  width: 22%;
  height: 80px;
  line-height: 80px;
  text-align: center;
  border: 1px solid #eee;
  border-radius: 4px;
  font-size: 30px;
  display: inline-block;
  vertical-align: middle;
  margin-left: 2.4%;
  margin-top: 10px;
}
.imageArea {
  width: 22%;
  height: 80px;
  margin-left: 2.4%;
  display: inline-block;
  vertical-align: middle;
  margin-top: 10px;
}
</style>