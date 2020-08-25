<template>
  <f7-page>
    <div v-show="showPosition == 1" class="pd-10 mb-30">
      <h3 class="text-c pb-10 mb-10">{{vote.title}}</h3>
      <div class="rich" v-html="vote.voteRule"></div>

      <div class="text-c mt-20">
        <van-button type="danger" round v-if="history.length > 0" @click="showPosition = 3">查看答题结果</van-button>
        <van-button
          type="danger"
          round
          v-if="history.length <= 0 && over == 0"
          @click="startAnswer"
        >开始答题</van-button> 
        <van-button
          type="default"
          round
          v-if="history.length <= 0 && over == 1"
        >已结束</van-button>
      </div>

      <div v-if="history.length > 0" class="pt-10 text-c">
        <span class="c-999">答题时间：{{history[0].createDate}}</span>
      </div>
    </div>

    <div v-show="showPosition == 2">
      <div v-for="(page,index) in voteSubject" v-show="voteSubjectPos == index">
        <div class="pb-100">
          <div v-for="(item,sub) in page" v-if="item.field_type != 'section_break'">
            <h4 class="pt-5 pl-10">
              {{item.label}}
              <span v-if="item.typename" class="c-333">({{item.typename}}题)</span>
              <span v-if="item.required" class="c-red">*</span>
            </h4>
            <div v-if="item.field_type == 'text'" class="pl-10 pr-10 mt-5 pb-10">
              <!--<input :maxlength="item.field_options.maxlength" :placeholder="item.field_options.description" :name="item.field_name" class="input-text" v-model="item.value" style="padding:21px 4px;">-->
              <van-field
                border
                v-model="item.value"
                :maxlength="item.field_options.maxlength"
                :placeholder="item.field_options.description"
                style="border: solid 1px #eee !important;border-radius: 5px;"
              />
            </div>
            <div v-if="item.field_type == 'paragraph'" class="pl-10 pr-10 mt-5 pb-10">
              <!--<textarea :maxlength="item.field_options.maxlength" :placeholder="item.field_options.description" name="item.field_name" class="textarea" v-model="item.value"></textarea>-->
              <van-field
                v-model="item.value"
                border
                rows="3"
                autosize
                type="textarea"
                :maxlength="item.field_options.maxlength"
                :placeholder="item.field_options.description"
                style="border: solid 1px #eee !important;border-radius: 5px;"
              />
            </div>
            <div class="pl-10 pr-10 pb-10" v-if="item.field_type == 'radio'">
              <!--<div v-for="(option,pos) in item.field_options.options" class="pt-5 changebox">
                            <div v-if="option.picture" class="pb-5" style="margin-left: 15px;">
                                <img :src="option.picture" width="50%">
                            </div>
                            <label class="radios" style="width: 100%;height: 100%; display: inline-block"><input no-fast-click="true" class="radios radio single" type="radio" :name="item.field_name" :value="pos" v-model="item.value"> {{option.label}}</label>
              </div>-->
              <van-radio-group v-model="item.value">
                <van-radio
                  :name="pos"
                  v-for="(option,pos) in item.field_options.options"
                  class="changebox"
                >
                  <div v-if="option.picture" class="pb-5">
                    <img :src="option.picture" width="50%" />
                  </div>
                  {{option.label}}
                </van-radio>
              </van-radio-group>
            </div>
            <div class="pl-10 pr-10 pb-10" v-if="item.field_type == 'checkboxes'">
              <div v-for="(option,pos) in item.field_options.options" class="pt-5 changebox">
                <label class="checkboxs" style="width: 100%;height: 100%; display: inline-block">
                  <input
                    no-fast-click="false"
                    class="checkboxs checkbox"
                    type="checkbox"
                    checked
                    :name="item.field_name"
                    :value="pos"
                    v-model="item.value"
                  />
                  {{option.label}}
                </label>
              </div>
            </div>
            <div v-if="sub < page.length - 1" class="line mt-10"></div>
          </div>
        </div>
        <div class="text-c fixedBottomButton">
          <!--<van-button type="primary" v-if="index > 0" @click="voteSubjectPos = voteSubjectPos - 1" style="padding:4px 20px">上一页</van-button>
                    <van-button type="primary" v-if="index < voteSubject.length -1" @click="nextSubject" style="padding:4px 20px">下一页</van-button>
          <van-button type="primary" v-if="index == voteSubject.length -1" @click="formSubmit" style="padding:4px 20px">提 交</van-button>-->

          <van-grid :border="false" :column-num="2" style="justify-content:flex-end">
            <van-grid-item v-if="index > 0">
              <van-button
                type="default"
                size="small"
                round
                @click="voteSubjectPos = voteSubjectPos - 1"
              >上一页</van-button>
            </van-grid-item>
            <van-grid-item v-if="index < voteSubject.length -1">
              <van-button type="default" round size="small" @click="nextSubject">下一页</van-button>
            </van-grid-item>
            <van-grid-item v-if="index == voteSubject.length -1">
              <van-button type="danger" round size="small" @click="formSubmit">提 交</van-button>
            </van-grid-item>
          </van-grid>
        </div>
      </div>
    </div>

    <div v-show="showPosition == 3" disabled="true">
      <div v-for="(page,index) in voteSubject">
        <div v-for="(item,sub) in page" v-if="item.field_type != 'section_break'">
          <h4 class="pt-5 pl-10">
            {{item.label}}
            <span v-if="item.typename" class="c-333">({{item.typename}}题)</span>
            <span v-if="item.required" class="c-red">*</span>
          </h4>
          <div v-if="item.field_type == 'text'" class="pl-10 pr-10 mt-5 pb-10">
            <!--<input :maxlength="item.field_options.maxlength" :placeholder="item.field_options.description" :name="item.field_name" class="input-text" v-model="item.value" disabled>-->
            <van-field
              v-model="item.value"
              :maxlength="item.field_options.maxlength"
              :placeholder="item.field_options.description"
              style="border: solid 1px #eee !important;border-radius: 5px;"
            />
          </div>
          <div v-if="item.field_type == 'paragraph'" class="pl-10 pr-10 mt-5 pb-10">
            <!--<textarea :maxlength="item.field_options.maxlength" :placeholder="item.field_options.description" name="item.field_name" class="textarea" v-model="item.value" disabled></textarea>-->
            <van-field
              v-model="item.value"
              rows="3"
              autosize
              type="textarea"
              :maxlength="item.field_options.maxlength"
              :placeholder="item.field_options.description"
              style="border: solid 1px #eee !important;border-radius: 5px;"
            />
          </div>
          <div class="pl-10 pr-10 pb-10" v-if="item.field_type == 'radio'">
            <div v-for="(option,pos) in item.field_options.options" class="pt-5 changebox">
              <div v-if="option.picture" class="pb-5" style="margin-left: 15px;">
                <img :src="option.picture" width="50%" />
              </div>
              <label class="radios" style="width: 100%;height: 100%; display: inline-block">
                <input
                  class="radio radios"
                  type="radio"
                  :name="item.field_name"
                  :value="pos"
                  v-model="item.value"
                  disabled
                />
                {{option.label}}
              </label>
            </div>
          </div>
          <div class="pl-10 pr-10 pb-10" v-if="item.field_type == 'checkboxes'">
            <div v-for="(option,pos) in item.field_options.options" class="pt-5 changebox">
              <label class="checkboxs" style="width: 100%;height: 100%; display: inline-block">
                <input
                  class="checkbox checkboxs"
                  type="checkbox"
                  checked
                  :name="item.field_name"
                  :value="pos"
                  v-model="item.value"
                  disabled
                />
                {{option.label}}
              </label>
            </div>
          </div>
          <div class="line mt-10"></div>
        </div>
      </div>
    </div>
  </f7-page>
</template>

<script>
import { surveyDetail, surveySubmit } from "@/api/api_cms";
import Vue from "vue";
import { Toast } from "vant";
Vue.use(Toast);

export default {
  data() {
    return {
      surveyId: "",
      //明细
      vote: {},
      //答题历史
      history: [],
      over: 0,
      //题目
      voteSubject: [],
      //当前所处的题目位置
      voteSubjectPos: 0,
      showPosition: 1
    };
  },
  created() {
    this.$commonUtils.setTitle("问卷调查");
    this.surveyId = this.$commonUtils.getUrlKey("id");
    this.loadVoteDetail();
  },
  methods: {
    //获取vote详情
    loadVoteDetail() {
      var _this = this;
      surveyDetail(this.surveyId)
        .then(res => {
          var result = res.data;
          _this.vote = result.vote;

          _this.history = result.data;
          _this.over = result.over;

          console.log(_this.vote.detail);
          if (!!_this.vote.detail) {
            var fields = JSON.parse(_this.vote.detail);
            console.log(fields);

            var newPage = [],
              pos = 0;

            fields.fields.forEach(function(item, index) {
              if (item.field_type == "section_break" && newPage.length > 0) {
                _this.voteSubject.push(newPage);
                newPage = [];
              } else {
                pos++;
                item.label = pos + "." + item.label;
              }

              if (item.field_type == "checkboxes") {
                item.value = [];
                item.typename = "多选";
              } else if (item.field_type == "radio") {
                item.typename = "单选";
                item.value = -1;
              } else if (item.field_type == "text") {
                item.typename = "简答";
                item.value = "";
              } else if (item.field_type == "paragraph") {
                item.typename = "问答";
                item.value = "";
              } else {
                item.valtypenameue = "";
                item.value = "";
              }

              if (_this.history.length > 0) {
                for (var i = 0; i < _this.history.length; i++) {
                  if (_this.history[i].name == item.field_name) {
                    if (item.field_type == "checkboxes") {
                      var code = _this.history[i].code;
                      var codeArr = [];
                      if (!!code) {
                        var arr = code.split(",");
                        if (!!arr && arr.length > 0) {
                          arr.forEach(function(code) {
                            codeArr.push(code);
                          });
                        }
                      }
                      item.value = codeArr;
                    } else if (item.field_type == "radio") {
                      item.value = _this.history[i].code;
                    } else {
                      item.value = _this.history[i].value;
                    }
                    break;
                  }
                }
              }
              newPage.push(item);
            });
            if (newPage.length > 0) _this.voteSubject.push(newPage);
          }
        })
        .catch(err => {
          this.$commonUtils.jumpLogin(err);
        });
    },
    nextSubject() {
      if (
        this.voteSubject[this.voteSubjectPos].required &&
        this.voteSubject[this.voteSubjectPos].value.length <= 0
      ) {
        Toast("必答题不能跳过");

        return;
      }

      this.voteSubjectPos += 1;
    },
    //开始答题
    startAnswer() {
      if (!!this.vote.isOut && this.vote.isOut == "1" && !!this.vote.outLink) {
        window.location.replace(this.vote.outLink);
        return;
      } else {
        this.showPosition = 2;
      }
    },
    //提交表单
    formSubmit() {
      var _this = this;
      this.$dialog.confirm({ message: "您确认提交吗?" }).then(() => {
        for (var j = 0; j < _this.voteSubject.length; j++) {
          for (var i = 0; i < _this.voteSubject[j].length; i++) {
            var item = _this.voteSubject[j][i];
            if (
              item.field_type != "section_break" &&
              item.required &&
              item.value.length <= 0
            ) {
              var message = "第" + (j + 1) + "页有必答题，请答完再提交";
              // var toastCenter = app.toast.create({
              //     text: message,
              //     position: 'center',
              //     closeTimeout: 2000
              // });
              // toastCenter.open();

              Toast(message);
              _this.voteSubjectPos = j;
              return;
            }
          }
        }

        var form = [];
        _this.voteSubject.forEach(function(item2, index2) {
          item2.forEach(function(item, index) {
            if (item.field_type == "checkboxes") {
              if (!!item.value) {
                var value = "",
                  code = ",";
                item.value.forEach(function(code_item) {
                  code += code_item + ",";
                  value += item.field_options.options[code_item].label + "/";
                });

                form.push({ name: item.field_name, value: value, code: code });
              }
            } else if (item.field_type == "radio") {
              var value = "";
              if (item.value >= 0) {
                value = item.field_options.options[parseInt(item.value)].label;
              }
              form.push({
                name: item.field_name,
                value: value,
                code: item.value
              });
            } else if (item.field_type == "section_break") {
            } else {
              form.push({ name: item.field_name, value: item.value, code: "" });
            }
          });
        });

        surveySubmit(this.surveyId, { value: JSON.stringify(form) })
          .then(res => {
            Toast("提交成功");
            wx.popPage();
          })
          .catch(err => {});
        // httpData(_this.url.detail+id,function s(result){
        //
        //     alert("提交成功，感谢您的参与");
        //     window.location.reload(1);
        //
        // },function e(){
        // },'POST',{content:JSON.stringify(form)},function b() {
        // },function c() {
        // });
      });
    }
  }
};
</script>

<style scoped>
.rich >>> p {
  font-size: 17px !important;
  line-height: 32px !important;
  text-indent: 0px !important;
  letter-spacing: 2px !important;
  overflow-y: hidden;
}

.rich >>> img {
  max-width: 100%;
  display: block;
}
.rich >>> section,
p {
  max-width: 100% !important;
  text-indent: 0px !important;
}
.rich >>> p img {
  /*display:block;*/
  /*width:100%;*/
  max-width: 100% !important;
  height: auto !important;
  margin-left: 0px !important;
  margin-right: 0px !important;
  padding-left: 0px !important;
  padding-right: 0px !important;
}
.rich >>> .rich_media_title {
  margin-bottom: 10px;
  line-height: 1.4;
  font-weight: 400;
  font-size: 24px;
}
.rich >>> .judgeFix {
  position: fixed !important;
  bottom: 0px;
  width: 100%;
  height: 45px;
  z-index: 10;
  background: #fff;
  border-top: solid 1px #eee;
}
.rich >>> .judge {
  border-top: solid 1px #eee;
  position: fixed;
  bottom: 45px;
  width: 100%;
  height: 120px;
  z-index: 10;
  background: #fff;
  padding-top: 10px;
}
.rich >>> .col-33 {
  height: 45px;
  padding-top: 10px;
}
.rich >>> textarea {
  border: solid 1px #eee !important;
  border-radius: 5px;
  width: 94% !important;
  margin-left: 3%;
  height: 70px;
  background: rgba(221, 221, 221, 0.2);
  padding: 2px;
}
.rich >>> .self {
  color: #007aff;
  font-size: 9px;
  margin-right: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-radius: 3px;
  border: solid 1px #007aff;
}
.rich >>> .flex-box-img {
  flex: 0 0 100px;
  width: 100px;
  height: 100px;
  overflow: hidden;
}
.rich >>> .flex-box-content {
  flex: 1;
  overflow: hidden;
  padding-bottom: 5px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-width: 0;
  margin-right: 3px;
}
.rich >>> .dotdot {
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  display: box;
  -webkit-box-orient: vertical;
  font-size: 16px;
}
.rich >>> .hot {
  color: #ff3b30;
  font-size: 9px;
  margin-right: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-radius: 3px;
  border: solid 1px #ff3b30;
}
.rich >>> .single {
  background: #fff;
  border-bottom: 1px solid rgba(221, 221, 221, 0.6);
  display: flex;
  margin-left: 10px;
  margin-right: 10px;
  padding-bottom: 10px;
  padding-top: 10px;
}
.rich >>> .single span {
  font-size: 12px;
  color: #666;
}
.rich >>> ul {
  margin: 10px;
  padding-left: 10px !important;
}

.input {
  width: 98%;
  height: 30px;
  padding: 1%;
  border-radius: 3px;
  border: solid 1px #eee !important;
}
.textarea {
  margin-top: 20px;
  border-radius: 5px;
}
.f-13 {
  font-size: 13px;
}

label,
.placeholder {
  font-size: 14px;
  color: #666;
  padding-left: 4px;
}
label input {
  margin-top: 1px;
}
/*自定义*/
input[type="radio"],
input[type="checkbox"] {
  margin-top: -2px !important;
  margin-right: 4px;
}
input {
  outline: none;
}
.radio,
.checkbox {
  width: 1rem;
  height: 1rem;
  background-color: #ffffff;
  border: solid 1px #dddddd;
  -webkit-border-radius: 0.6rem;
  border-radius: 0.6rem;
  font-size: 0.8rem;
  margin: 0;
  padding: 0;
  position: relative;
  display: inline-block;
  vertical-align: middle;
  cursor: default;
  -webkit-appearance: none; /**隐藏原生控件**/
}

.checkbox {
  border-radius: 0.1rem; /**复选框的圆角要小一些**/
}
/**选择后的样式**/
.radio:checked,
.checkbox:checked {
  background-color: #4ba8f6;
  border: solid 1px #00adc8;
  box-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);
  text-align: center;
  background-clip: padding-box;
}
/**选择后 里面小对勾样式**/
.radio:checked:before,
.checkbox:checked:before {
  content: "";
  width: 0.5rem;
  height: 0.3rem;
  border: 1px solid #ffffff;
  border-top: none;
  border-right: none;
  position: absolute;
  top: 50%;
  left: 50%;
  margin-left: -0.25rem;
  margin-top: -0.25rem;
  -webkit-transform: rotate(-45deg);
  transform: rotate(-45deg);
}
.input-text {
  font-size: 14px;
  text-indent: 1em;
  border-radius: 5px;
}
.single {
}
.changebox {
  border-radius: 5px;
  border: 1px solid #eee;
  padding: 10px 5px;
  font-size: 14px;
  margin-bottom: 5px;
}
.borderColor {
  border-color: #1499ed !important;
  box-shadow: 0px 0px 1px #eefdff;
  background-color: #ddeffd;
}
.textarea .placeholder {
  font-size: 14px;
}
.textarea {
  font-size: 14px;
  text-indent: 1em;
  padding: 4px auto;
}
h4 {
  font-size: 14px;
}
.fixedBottomButton {
  position: fixed;
  bottom: 0px;
  left: 0px;
  right: 0px;
  border-top: 1px solid #eee;
  background: #fff;
  z-index: 999999!important;
}
</style>