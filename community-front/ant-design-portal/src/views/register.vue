<template>
  <div class="register_container">
    <a-steps :current="current" class="navBarWrap my_steps">
      <a-step v-for="item in steps" :key="item.title" :title="item.title" />
    </a-steps>
    <a-spin :spinning="confirmLoading">
      <a-form :form="form" style="width:100%;margin:30px auto">
        <div class="steps-content steps-content1" v-show="current == 0">
          <template>
            <h2 class="mb10 f18">登录信息</h2>
            <a-form-item label="用户名" :label-col="labelCol" :wrapper-col="wrapperCol">
              <a-input
                v-decorator="['usernames']"
                placeholder="请输入用户名"
                style="position:fixed;bottom:-99999px;"
              />
              <a-input
                v-decorator="[
          'username',
          { rules: [{ required: true, message: '请输入用户名' }] },
        ]"
                placeholder="请输入用户名"
                @blur="isduplicate('username')"
              />
            </a-form-item>
            <a-form-item label="邮箱" :label-col="labelCol" :wrapper-col="wrapperCol">
              <a-input
                v-decorator="[
          'email',
          { rules: [{ required: true, message: '请输入邮箱' }] },
        ]"
                placeholder="请输入邮箱"
                @blur="isduplicate('email')"
              />
              <p class="f10 bottom_gary">请输入正确邮箱地址，否则密码丢失或遗忘将无法找回</p>
            </a-form-item>
            <a-form-item label="密码" :label-col="labelCol" :wrapper-col="wrapperCol">
              <a-input type="password" placeholder="请输入密码" style="position:fixed;bottom:-99999px;" />
              <a-input
                v-decorator="[
          'password',
          { rules: [{ required: true, message: '请输入密码' }] },
        ]"
                type="password"
                placeholder="请输入密码"
              />
            </a-form-item>
            <a-form-item label="确认密码" :label-col="labelCol" :wrapper-col="wrapperCol">
              <a-input type="password" placeholder="请确认密码" style="position:fixed;bottom:-99999px;" />
              <a-input
                v-decorator="[
          'password2',
          { rules: [{ required: true, message: '请再次输入密码' }] },
        ]"
                type="password"
                placeholder="请再次输入密码"
                @blur="isPasswordSame"
              />
            </a-form-item>
          </template>
          <template>
            <h2 class="mb10 f18">用户信息</h2>
            <a-form-item label="姓名" :label-col="labelCol" :wrapper-col="wrapperCol">
              <a-input
                v-decorator="[
          'realname',
          { rules: [{ required: true, message: '请输入姓名' }] },
        ]"
                placeholder="请输入姓名"
              />
            </a-form-item>
            <a-form-item label="验证码" :label-col="labelCol" :wrapper-col="wrapperCol">
              <a-row>
                <a-col :span="16">
                  <a-input v-model="actionCode" placeholder="请输入验证码" />
                </a-col>
                <a-col :span="1"></a-col>
                <a-col :span="7">
                  <div class="verify_code" @click="getVerifityCode">
                    <img :src="captureUrl" alt />
                  </div>
                </a-col>
              </a-row>
            </a-form-item>
            <a-form-item label="手机号" :label-col="labelCol" :wrapper-col="wrapperCol">
              <a-row>
                <a-col :span="16">
                  <a-input
                    v-decorator="[
          'mobile',
          { rules: [{ required: true, message: '请输入手机号' }] },
        ]"
                    placeholder="请输入手机号"
                  />
                </a-col>
                <a-col :span="1"></a-col>
                <a-col :span="7">
                  <div class="btngetCode">
                    <a-button :disabled="btnDisabled" @click="checkCode">{{btnClick}}</a-button>
                  </div>
                </a-col>
              </a-row>
            </a-form-item>
            <a-form-item label="手机验证码" :label-col="labelCol" :wrapper-col="wrapperCol">
              <a-input
                v-decorator="[
          'verifyCode',
          { rules: [{ required: true, message: '请输入手机验证码' }] },
        ]"
                placeholder="请输入手机验证码"
              />
            </a-form-item>
          </template>
          <a-form-item>
            <div style="margin:0 auto">
             <a-button
                style="width:100px;margin-right:10px"
                v-if="current ==0"
                @click="backLogin"
              >取消</a-button>
              <a-button
                style="width:100px"
                v-if="current < steps.length - 1"
                type="primary"
                @click="next"
              >下一步</a-button>
            </div>
          </a-form-item>
        </div>
        <div class="steps-content" v-show="current == 1">
          <a-form-item label="选择省" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-select placeholder="选择省" @change="provinceHandleChange" style="width: 100%">
              <a-select-option
                v-for="item in provinceItems"
                :key="item.id"
                :value="item.id"
              >{{item.departName}}</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="选择市" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-select placeholder="选择市" @change="cityHandleChange" style="width: 100%">
              <a-select-option
                v-for="item in cityItems"
                :key="item.id"
                :value="item.id"
              >{{item.departName}}</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="选择街道" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-select placeholder="选择街道" @change="streetHandleChange" style="width: 100%">
              <a-select-option
                v-for="item in streetItems"
                :key="item.id"
                :value="item.id"
              >{{item.departName}}</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="选择社区" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-select placeholder="选择社区" @change="areaHandleChange" style="width: 100%">
              <a-select-option
                v-for="item in areaItems"
                :key="item.orgCode"
                :value="item.departName"
              >{{item.departName}}</a-select-option>
            </a-select>
            <p v-if="registerMessage != ''">{{registerMessage}}</p>
          </a-form-item>
          <a-form-item>
            <div style="margin:0 auto;">
              
              <a-button v-if="current>0" style="width:100px" @click="prev">上一步</a-button>
              <a-button
                style="width:100px;margin-left: 8px"
                v-if="current < steps.length - 1"
                type="primary"
                @click="next"
              >下一步</a-button>
            </div>
          </a-form-item>
        </div>
        <!-- <div class="steps-content" v-show="current == 2">
          <a-form-item>
            <baidu-map
              id="allmap"
              class="map"
              :center="center"
              :zoom="14"
              :scroll-wheel-zoom="true"
              :mapClick="false"
              @mousemove="syncPolyline"
              @click="paintPolyline"
              @dblclick="paintOK"
            >
              <bm-control class="my_search">
                <a-button type="primary" @click="beginMap('polyline')">开始绘制</a-button>
                <a-button type="danger" @click="finishMap">完成绘制</a-button>
                <label>
                  关键词：
                  <input v-model="keyword" />
                </label>
                <bm-navigation anchor="BMAP_ANCHOR_TOP_RIGHT"></bm-navigation>
                <bm-local-search
                  :panel="false"
                  :pageCapacity="5"
                  :keyword="keyword"
                  :auto-viewport="true"
                ></bm-local-search>
              </bm-control>
              <bm-polygon
                v-for="(path,index) in polyline.paths"
                :path="path"
                :key="index"
                stroke-color="red"
                :stroke-weight="2"
                fill-color="red"
                @mouseover="interLine"
              ></bm-polygon>
            </baidu-map>
          </a-form-item>
          <a-form-item>
            <div style="margin:0 auto;">
              <a-button v-if="current>0" style="width:100px" @click="prev">上一步</a-button>
              <a-button
                style="width:100px;margin-left: 8px"
                v-if="current < steps.length - 1"
                type="primary"
                @click="next"
              >下一步</a-button>
            </div>
          </a-form-item>
        </div>-->
        <div class="steps-content" v-if="current == 2">
          <div class="laststep">
            <h2>欢迎使用！</h2>
            <span>
              请
              <b>等待系统审核</b> ，系统审核通过后将通知联系人
            </span>
            <div class="laststep2">
              <p>欢迎 {{extra.toAddressName}} 入驻社区e家</p>
              <p>
                联系人：
                <span>{{lastStep().realname}}</span> 联系电话：
                <span>{{lastStep().mobile}}</span>
              </p>
            </div>
          </div>
          <div style="margin-bottom:24px">
            <a-button v-if="current>0" style="width:100px" @click="prev">上一步</a-button>
            <a-button type="primary" style="width:100px;margin-left: 8px" @click="formOK">完成注册</a-button>
          </div>
        </div>
      </a-form>
    </a-spin>
  </div>
</template>

<script>
export default {
  data() {
    return {
      confirmLoading: false,
      form: this.$form.createForm(this),
      polyline: {
        editing: false,
        paths: []
      },
      center: { lng: 116.404, lat: 39.915 },
      zoom: 3,
      location: "北京",
      keyword: "",
      labelCol: { span: 9 },
      wrapperCol: { span: 6 },
      actionCode: "",
      captureUrl: "",
      captureCode: "",
      btnClick: "获取验证码",
      timer: null,
      btnDisabled: false,
      current: 0,
      url:{
        next:"/next",
        isRegister:"/isRegister/",
        getArea:"/getArea?parentId=",
        capture:'/capture',
        sms:"/sms",
        duplicate:"/duplicate",
        register:"/register",
      },
      steps: [
        {
          title: "登录信息",
          content: "First-content"
        },
        {
          title: "选择街乡、居委会",
          content: "Second-content"
        },
        // {
        //   title: "辖区地理范围",
        //   content: "Last-content"
        // },
        {
          title: "完成",
          content: "Last-content"
        }
      ],
      provinceItems: [],
      cityItems: [],
      streetItems: [],
      areaItems: [],
      extra: {
        lonlat: "",
        toAddress: "",
        toAddressName: ""
      },
      isEquals: true, //密码两次输入相同为true,不同为false
      registerMessage: "",
      community:this.GLOBAL.casPrefixUrl + "/#/login?service=" +this.GLOBAL.comunity,
    };
  },
  methods: {
    backLogin(){
      let _this = this;
      this.$confirm({
        title: '确认取消注册流程吗？',
        okText: '确认',
        cancelText: '取消',
        onOk(){
          window.location.href = _this.community
        },
        onCancel(){

        }
      });
    },
    handler({ BMap, map }) {
      this.center.lng = 116.404;
      this.center.lat = 39.915;
      this.zoom = 15;
    },
    next() {
      if (this.current == 0) {
        this.isnext(this.current);
        // this.current++;
      } else if (this.current == 1) {
        if (this.extra.toAddress == "") {
          this.$message.error("请选择街乡，居委会");
          return;
        } else if (
          this.registerMessage == undefined ||
          this.registerMessage == ""
        ) {
          //未被占用
          this.current++;
        } else {
          //被占用
        }
      } else if (this.current == 2) {
        if (this.extra.lonlat != "") {
          this.current++;
        } else {
          this.$message.error("请在地图上标出辖区地理范围");
        }
      } else if (this.current == 3) {
        this.lastStep();
      } else {
        this.current++;
      }
    },
    prev() {
      this.current--;
    },
    //验证是否可以进行下一步 手机号和验证码
    isnext(step) {
      let res = this.form.getFieldsValue();
      if (step == 0 && res.username == undefined) {
        this.$message.error("请输入用户名");
        return;
      } else if (step == 0 && res.email == undefined) {
        this.$message.error("请输入邮箱");
        return;
      } else if (step == 0 && res.password == undefined) {
        this.$message.error("请输入密码");
        return;
      } else if (step == 0 && res.password2 == undefined) {
        this.$message.error("请确认密码");
        return;
      } else if (step == 0 && res.realname == undefined) {
        this.$message.error("请输入姓名");
        return;
      }
      let param = {
        params: {
          mobile: res.mobile,
          code: res.verifyCode
        }
      };
      this.$http.get(this.url.next, param).then(res => {
        if (!res.data.success) {
          this.$message.error(res.data.message);
        } else {
          this.current++;
        }
      });
    },
    lastStep() {
      let res = this.form.getFieldsValue();
      return res;
    },

    interLine(e) {
      document.getElementById("allmap").style.cursor = "pointer";
    },
    syncPolyline(e) {
      if (!this.polyline.editing) {
        return;
      }
      const { paths } = this.polyline;
      if (!paths.length) {
        return;
      }
      const path = paths[paths.length - 1];
      if (!path.length) {
        return;
      }
      if (path.length === 1) {
        path.push(e.point);
      }
      this.$set(path, path.length - 1, e.point);
    },
    beginMap(name) {
      this.polyline.paths = [];
      this[name].editing = true;
    },
    paintPolyline(e) {
      if (!this.polyline.editing) {
        return;
      }
      const { paths } = this.polyline;
      !paths.length && paths.push([]);
      paths[paths.length - 1].push(e.point);
    },
    finishMap() {
      let lonlats = "";
      for (let i in this.polyline.paths[0]) {
        lonlats +=
          this.polyline.paths[0][i].lng +
          "," +
          this.polyline.paths[0][i].lat +
          "|";
      }
      this.extra.lonlat = lonlats;
      this.$message.success("绘制完成,请点击下一步！");
    },
    paintOK() {
      this["polyline"].editing = false;
    },
    provinceHandleChange(value) {
      this.getAddressTree(value, 1);
    },
    cityHandleChange(value) {
      this.getAddressTree(value, 2);
    },
    streetHandleChange(value) {
      this.getAddressTree(value, 3);
    },
    areaHandleChange(value, code) {
      this.extra.toAddress = code.data.key;
      this.extra.toAddressName = value;
      this.committee(code.data.key);
    },
    //判断选择的社区是否被占用
    committee(code) {
      this.$http.get(this.url.isRegister + code).then(res => {
        if (!res.success) {
          // this.$message.error(res.message);
          this.registerMessage = res.message;
        }
      });
    },
    //获取社区地址
    getAddressTree(parentId, num) {
      if (parentId == undefined) {
        parentId = "";
      }
      this.$http.get(this.url.getArea + parentId).then(res => {
        if (num == 0) this.provinceItems = res.data.result;
        else if (num == 1) this.cityItems = res.data.result;
        else if (num == 2) this.streetItems = res.data.result;
        else if (num == 3) this.areaItems = res.data.result;
      });
    },
    //验证两次输入的密码是否一样
    isPasswordSame() {
      let res = this.form.getFieldsValue();
      if (res.password === res.password2) {
        //两次一样
        this.isEquals = true;
      } else {
        //两次不一样
        this.isEquals = false;
        this.$message.error("你两次输入的密码不一样，请重新输入");
        return;
      }
    },
    //获取验证码
    getVerifityCode() {
      this.$http.get(this.url.capture).then(res => {
        this.captureUrl = res.data.result.img;
        this.captureCode = res.data.result.code;
      });
    },
    //获取手机验证码前的校验  手机号 验证码  验证码code
    checkCode() {
      let res = this.form.getFieldsValue();
      if (!res.mobile || !this.actionCode || !this.captureCode) {
        this.$message.error("手机号或验证码错误");
        return;
      } else {
        this.getPhoneNum();
      }
    },
    //获取手机验证码
    getPhoneNum() {
      let res = this.form.getFieldsValue();
      let param = {
        params: {
          code: this.captureCode,
          mobile: res.mobile,
          verifyCode: this.actionCode,
          module: 0
        }
      };
      this.btnDisabled = true;
      this.$http.get(this.url.sms, param).then(res => {
        if (!res.data.success) {
          this.$message.error(res.data.message);
          this.btnDisabled = false;
        } else {
          const TIME_COUNT = 60;
          if (!this.timer) {
            this.btnClick = TIME_COUNT;
          }
          this.timer = setInterval(() => {
            if (this.btnClick > 0 && this.btnClick <= TIME_COUNT) {
              this.btnClick--;
              if (this.btnClick == 0) {
                this.btnClick = "获取验证码";
                this.btnDisabled = false;
              }
            } else {
              clearInterval(this.timer);
              this.timer = null;
            }
          }, 1000);
        }
      });
    },

    isduplicate(type) {
      let res = this.form.getFieldsValue();
      let value = "";
      if (type == "email") {
        res.email ? (value = res.email) : (value = "");
      } else if (type == "username") {
        res.username ? (value = res.username) : (value = "");
      }
      if (value == "" && type == "email") {
        this.$message.error("请输入邮箱");
        return;
      }
      if (value == "" && type == "username") {
        this.$message.error("请输入用户名");
        return;
      }
      let param = {
        params: {
          type: type,
          value: value
        }
      };
      this.$http.get(this.url.duplicate, param).then(res => {
        if (!res.data.success) {
          this.$message.error(res.data.message);
        }
      });
    },
    //提交表单
    formOK() {
      this.form.validateFields((err, values) => {
        let param = values;
        param.extra = {};
        param.extra = this.extra;
        param.departType = 0;
        param.address = param.extra.toAddress
        param.departName = param.extra.toAddressName
        delete param.extra.toAddressName;
        delete param.password2;
        delete param.usernames;
        if (this.isEquals == false) {
          this.$message.error("你两次输入的密码不一样，请重新输入");
          return;
        }
        // console.log(JSON.stringify(param));
        // return;
        this.$http.post(this.url.register, param).then(res => {
          if (res.data.success) {
            this.$message.success("提交成功");
            window.location.href = this.community;
          }
        });
      });
    }
  },
  mounted() {
    this.getVerifityCode();
    this.getAddressTree("", 0);
  }
};
</script>
<style scoped>
.steps-content {
  border: 1px dashed #e9e9e9;
  border-radius: 6px;
  background-color: #ffffff;
  min-height: 200px;
  text-align: center;
  padding-top: 20px;
  margin: 10px auto;
}
.steps-action {
  margin-top: 24px;
}
.register_container {
  padding: 20px;
  margin: 20px;
}
.map {
  height: 500px;
  width: 100%;
}
input[type="password"],
input[type="text"],
textarea {
  border: 1px solid #ccc !important;
  border-radius: 4px !important;
  padding-left: 10px !important;
}
.verify_code {
  margin: 0px;
  padding: 0px;
  height: 33px;
  cursor: pointer;
  width: 100%;
}
.verify_code img {
  height: 100%;
  width: 100%;
  vertical-align: top;
}
.btngetCode {
  height: 33px;
}
.btngetCode button {
  vertical-align: top;
}
.laststep {
  margin-bottom: 30px;
  padding-bottom: 30px;
}
.laststep h2 {
  font-size: 20px;
  margin-bottom: 10px;
  font-weight: bold;
}
.laststep .laststep2 {
  margin-top: 30px;
}
.laststep .laststep2 p {
  margin-bottom: 10px;
}
.steps-content1 .ant-form-item-required::before {
  content: "" !important;
}
.BMap_mask {
  cursor: crosshair !important;
}
</style>