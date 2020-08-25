<template>
  <div class="register_container society_container">
    <a-steps :current="current" class="navBarWrap my_steps">
      <a-step v-for="item in steps" :key="item.title" :title="item.title" />
    </a-steps>
    <a-spin :spinning="confirmLoading">
      <a-form :form="form">
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
        <div class="steps-content steps-content1" v-show="current == 1">
          <a-form-item label="组织logo" :label-col="labelCol" :wrapper-col="wrapperCol">
            <div class="choise choise2">
              <template>
                <a-upload
                  listType="picture-card"
                  class="avatar-uploader"
                  :showUploadList="false"
                  :action="uploadActionavatar"
                  @change="handleChangeavatar"
                >
                  <img v-if="avatarUrl" :src="avatarUrl" alt="avatar" width="100%" height="100" />
                  <div v-else>
                    <a-icon :type="uploadavatarLoading ? 'uploadavatarLoading' : 'plus'" />
                    <div class="ant-upload-text">上传公司LOGO</div>
                  </div>
                </a-upload>
              </template>
            </div>
          </a-form-item>
          <a-form-item label="组织名称" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input
              a-input
              v-decorator="[
          'departName',
          { rules: [{ required: true, message: '请输入组织名称' }] },
        ]"
              placeholder="请输入组织名称"
            />
          </a-form-item>
          <a-form-item label="牵头人" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input v-model="extra.organiza_leader" placeholder="请输入牵头人" />
          </a-form-item>
          <a-form-item label="地址" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input
              v-decorator="[
          'address',
          { rules: [{ required: true, message: '请输入地址' }] },
        ]"
              placeholder="请输入地址"
            />
          </a-form-item>
          <a-form-item label="组织形式" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-select v-model="extra.organize_type" placeholder="请选择组织形式">
              <a-select-option
                v-for="(item,index) in organizationList"
                :key="index"
                :value="item.value"
              >{{item.title}}</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="成立方式" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-select v-model="extra.setUP_type" placeholder="请选择成立方式">
              <a-select-option
                v-for="(item,index) in set_typeList"
                :key="index"
                :value="item.value"
              >{{item.title}}</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="工作内容" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-select v-model="extra.work_content" placeholder="请选择工作内容">
              <a-select-option
                v-for="(item,index) in workContent"
                :key="index"
                :value="item.value"
              >{{item.title}}</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="工作内容进行补充说明" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input v-model="extra.work_contentMore" placeholder="工作内容进行补充说明" />
          </a-form-item>
          <a-form-item label="联系电话" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input
              v-decorator="[
          'contactPhone',
          { rules: [{ required: true, message: '请输入联系电话' }] },
        ]"
              placeholder="联系电话，多个联系电话用/隔开"
            />
          </a-form-item>
          <a-form-item>
            <div style="margin:0 auto">
              <a-button v-if="current>0" style="width:100px" @click="prev">上一步</a-button>
              <a-button
                style="margin-left: 8px;width:100px"
                v-if="current < steps.length - 1"
                type="primary"
                @click="next"
              >下一步</a-button>
            </div>
          </a-form-item>
        </div>
        <div class="steps-content steps-content1" v-show="current == 2">
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
          </a-form-item>
          <a-form-item>
            <div style="margin:0 auto">
              <a-button v-if="current>0" style="width:100px" @click="prev">上一步</a-button>
              <a-button
                style="margin-left: 8px;width:100px"
                v-if="current < steps.length - 1"
                type="primary"
                @click="next"
              >下一步</a-button>
            </div>
          </a-form-item>
        </div>
        <div class="steps-content steps-content1" v-show="current == 3">
          <div class="laststep">
            <h2>欢迎使用！</h2>
             <span>
              请
              <b>等待系统审核</b> ，系统审核通过后将通知联系人
            </span>
            <div class="laststep2">
              <p>欢迎社区社会组织 {{lastStep().departName}} 入驻社区E家</p>
              <p>
                联系人:
                <span>{{lastStep().realname}}</span> 联系电话:
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
      visible: false,
      form: this.$form.createForm(this),
      confirmLoading: false,
      current: 0,
      labelCol: { span: 9 },
      wrapperCol: { span: 6 },
      actionCode: "",
      captureUrl: "",
      captureCode: "",
      btnClick: "获取验证码",
      timer: null,
      btnDisabled: false,
      polyline: {
        editing: false,
        paths: []
      },
      center: { lng: 116.404, lat: 39.915 },
      zoom: 3,
      url:{
        next:"/next",
        capture:"/capture",
        sms:"/sms",
        duplicate:"/duplicate",
        register:"/register",
        getArea:"/getArea?parentId=",
        getDictItems:"/getDictItems/" ,
      },
      steps: [
        {
          title: "登录信息",
          content: "First-content"
        },
        {
          title: "组织信息",
          content: "Second-content"
        },
        {
          title: "所属社区",
          content: "Last-content"
        },
        {
          title: "完成",
          content: "Last-content"
        }
      ],
      extra: {
        organize_type: "",
        setUP_type: "",
        work_content: "",
        work_contentMore: "",
        organiza_leader: "",
        toAddress: "",
        toAddressName: ""
      },
      organizationList: [],
      set_typeList: [],
      workContent: [],
      license: true,
      provinceItems: [],
      cityItems: [],
      streetItems: [],
      areaItems: [],
      uploadavatarLoading: false,
      avatarUrl: "", //公司LOGO
      avatarUrlUpload: "", //公司LOGO
      isEquals: true, //密码两次输入相同为true,不同为false
      registerMessage: "",
      cms:this.GLOBAL.casPrefixUrl + "/#/login?service=" + this.GLOBAL.cms
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
          window.location.href = _this.cms
        },
        onCancel(){

        }
      });
    },
    uploadActionavatar: function() {
        return window._CONFIG['upload'] + "/upload?action=uploadimage";
    },
    next() {
      if (this.current == 0) {
        this.isnext(this.current);
        // this.current++;
        this.getdicData("work_content");
        this.getdicData("setUp_type");
        this.getdicData("organize_type");
      } else if (this.current == 1) {
        this.societyStep();
        // this.current++;
      } else if (this.current == 2) {
        if (!this.extra.toAddress) {
          this.$message.error("请选择所属社区");
        } else {
          this.current++;
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
    societyStep() {
      let res = this.form.getFieldsValue();
      if (!this.avatarUrlUpload) {
        this.$message.error("请设置组织LOGO");
      } else if (!res.departName || res.departName == undefined) {
        this.$message.error("请输入组织名称");
      } else if (
        !this.extra.organiza_leader ||
        this.extra.organiza_leader == undefined
      ) {
        this.$message.error("请输入牵头人");
      } else if (!res.address || res.address == undefined) {
        this.$message.error("请输入地址");
      } else if (
        !this.extra.organize_type ||
        this.extra.organize_type == undefined
      ) {
        this.$message.error("请选择组织形式");
      } else if (!this.extra.setUP_type || this.extra.setUP_type == undefined) {
        this.$message.error("请选择成立方式");
      } else if (
        !this.extra.work_content ||
        this.extra.work_content == undefined
      ) {
        this.$message.error("请选择工作内容");
      } else if (!res.contactPhone || res.contactPhone == undefined) {
        this.$message.error("请输入联系电话");
      } else {
        this.current++;
      }
    },
    lastStep() {
      let res = this.form.getFieldsValue();
      return res;
    },
    //验证是否可以进行下一步 手机号和验证码
    isnext(step) {
      let res = this.form.getFieldsValue();
      if(step == 0 && res.username == undefined){
          this.$message.error("请输入用户名");
          return
      }else if(step == 0 && res.email== undefined){
          this.$message.error("请输入邮箱");
          return
      }else if(step == 0 && res.password == undefined){
          this.$message.error("请输入密码");
          return
      }
      else if(step == 0 && res.password2 == undefined){
          this.$message.error("请确认密码");
          return
      }else if(step == 0 && res.realname == undefined){
          this.$message.error("请输入姓名");
          return
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
          module: 4
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
    getBase64(img, callback) {
      const reader = new FileReader();
      reader.addEventListener("load", () => callback(reader.result));
      reader.readAsDataURL(img);
    },
    handleChangeavatar(info) {
      if (info.file.status === "uploading") {
        this.uploadavatarLoading = true;
        return;
      }
      if (info.file.status === "done") {
        // Get this url from response in real world.
        this.getBase64(info.file.originFileObj, imageUrl => {
          this.avatarUrl = imageUrl;
          this.uploadavatarLoading = false;
        });
        let response = info.file.response;
        this.avatarUrlUpload = response.result.url;
      }
    },
    //提交表单
    formOK() {
      this.form.validateFields((err, values) => {
        let param = values;
        param.extra = {};
        param.extra = this.extra;
        param.departType = 4;
        param.logo = this.avatarUrlUpload;
        // delete param.extra.toAddressName;
        delete param.password2;
        delete param.usernames;
        this.$http.post(this.url.register, param).then(res => {
          if (res.data.success) {
            this.$message.success("提交成功");
            window.location.href = this.cms;
          }
        });
      });
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
    //获取字典表数据
    getdicData(value) {
      this.$http.get(this.url.getDictItems+ value).then(res => {
        if (value == "work_content") {
          this.workContent = res.data.result;
        } else if (value == "setUp_type") {
          this.set_typeList = res.data.result;
        } else if (value == "organize_type") {
          this.organizationList = res.data.result;
        }
      });
    }
  },
  mounted() {
    this.getAddressTree("", 0);
    this.getVerifityCode();
  }
};
</script>
<style>
.register_container {
  padding: 20px;
  margin: 20px;
}
.steps-content {
  border: 1px dashed #e9e9e9;
  border-radius: 6px;
  background-color: #ffffff;
  min-height: 200px;
  text-align: center;
  padding-top: 20px;
  margin: 10px auto;
}
input[type="password"],
input[type="text"],
textarea {
  border: 1px solid #ccc !important;
  border-radius: 4px !important;
  padding-left: 10px !important;
}
.map {
  height: 500px;
  width: 100%;
}
.choise {
  height: 300px;
  line-height: 300px;
  border: 1px solid #eee;
  padding: 10px;
}
.choise2 {
  width: 180px;
  height: 160px;
  line-height: 160px;
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
/* 改变按钮的颜色 */
.society_container .ant-steps-item-process .ant-steps-item-icon {
  background-color: #ffb000 !important;
}
.society_container .ant-steps-item-process .ant-steps-item-icon {
  border-color: #ffb000 !important;
}
.society_container .ant-steps-item-icon > .ant-steps-icon {
  color: #fff !important;
}
.society_container
  .ant-steps-item-finish
  .ant-steps-item-icon
  > .ant-steps-icon {
  color: #ffb000 !important;
}
.society_container .ant-steps-item-finish .ant-steps-item-icon {
  border-color: #ffb000 !important;
}
.society_container .ant-btn-primary {
  background-color: #ffb000 !important;
  border-color: #ffb000 !important;
}
.steps-content1 .ant-form-item-required::before {
  content: "" !important;
}
</style>