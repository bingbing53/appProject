<template>
  <div class="register_container business_container">
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
          <a-form-item label="公司logo" :label-col="labelCol" :wrapper-col="wrapperCol">
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
          <a-form-item label="公司简称" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input
              v-decorator="[
          'departName',
          { rules: [{ required: true, message: '请输入公司简称' }] },
        ]"
              placeholder="请输入公司简称"
            />
          </a-form-item>
          <a-form-item label="服务电话" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input
              v-decorator="[
          'contactPhone',
          { rules: [{ required: true, message: '请输入服务电话' }] },
        ]"
              placeholder="多个电话用\分开"
            />
          </a-form-item>
          <a-form-item label="经营位置" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input
              v-model="extra.lonlat"
              placeholder="请在地图上划出位置"
              :readOnly="true"
              @click="show_map"
            />
          </a-form-item>
          <a-form-item label="详细地址" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input
              v-decorator="[
          'address',
          { rules: [{ required: true, message: '请输入详细地址' }] },
        ]"
              placeholder="请输入详细地址"
            />
            <p
              class="f10 bottom_gary"
              style="line-height:24px!important"
            >请精确填写公司的经营位置及详细地址，该信息为公司的服务地址信息而非注册地址信息！</p>
          </a-form-item>
          <a-form-item label="服务时间" :label-col="labelCol" :wrapper-col="wrapperCol">
            <!-- <a-range-picker v-decorator="['serveDate']" show-time format="YYYY-MM-DD HH:mm:ss" /> -->
            <a-time-picker
              v-decorator="['serveDate1']"
              :defaultValue="moment('08:00', 'HH:mm')"
              format="HH:mm"
            />
            <span class="ml10 mr10">至</span>
            <a-time-picker
              v-decorator="['serveDate2']"
              :defaultValue="moment('18:00', 'HH:mm')"
              format="HH:mm"
            />
          </a-form-item>
          <a-form-item label="选择从事行业" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-select v-model="extra.industry" placeholder="请选择从事行业">
              <a-select-option
                v-for="(item,index) in workOwnType"
                :key="index"
                :value="item.value"
              >{{item.text}}</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="请上传营业执照" :label-col="labelCol" :wrapper-col="wrapperCol">
            <div>
              <div class="choise">
                <template>
                  <a-upload
                    listType="picture-card"
                    class="avatar-uploader"
                    :showUploadList="false"
                    :action="uploadAction"
                    @change="handleChange"
                  >
                    <img v-if="imageUrl" :src="imageUrl" alt="avatar" width="100%" height="260" />
                    <div v-else>
                      <a-icon :type="uploadimageLoading ? 'uploadimageLoading' : 'plus'" />
                      <div class="ant-upload-text">上传营业执照</div>
                    </div>
                  </a-upload>
                </template>
              </div>
            </div>
            <div class="warnings text-c f-14 pt-5" v-if="license == false">
              <span>
                <i class="icon-warning f-16 pr-10" style="color: orange"></i>识别失败，请上传有效的营业执照！
              </span>
            </div>
            <p>请核对营业执照信息</p>
          </a-form-item>
          <a-form-item label="公司全称" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input placeholder="公司全称" v-model="licence.name" />
          </a-form-item>
          <a-form-item label="社会组织信用代码" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input placeholder="社会组织信用代码" v-model="licence.reg_num" />
          </a-form-item>
          <a-form-item label="法人代表" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input placeholder="法人代表" v-model="licence.person" />
          </a-form-item>
          <a-form-item label="注册资金" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input placeholder="注册资金" v-model="licence.captial" />
          </a-form-item>
          <a-form-item label="注册地址" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input placeholder="注册地址" v-model="licence.address" />
          </a-form-item>
          <a-form-item label="营业范围" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input placeholder="营业范围" v-model="licence.business" />
          </a-form-item>
          <a-form-item>
            <div style="margin:0 auto;">
              <a-button v-if="current>0" style="width:100px" @click="prev">上一步</a-button>
              <a-button
                style="width:100px;margin-left: 8px;"
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
            <div style="margin:0 auto;">
              <a-button v-if="current>0" style="width:100px" @click="prev">上一步</a-button>
              <a-button
                style="width:100px;margin-left: 8px;"
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
              <p>欢迎 {{lastStep().departName}} 公司入驻 {{extra.toAddressName}} 社区</p>
              <p>
                联系人：
                <span>{{lastStep().realname}}</span> 联系电话：
                <span>{{lastStep().mobile}}</span>
              </p>
            </div>
          </div>
          <div style="margin-bottom:24px">
            <a-button v-if="current>0" style="width:100px" @click="prev">上一步</a-button>
            <a-button type="primary" style="margin-left: 8px;width:100px" @click="formOK">完成注册</a-button>
          </div>
        </div>
      </a-form>
    </a-spin>
    <a-drawer
      width="800px"
      title="地图"
      placement="right"
      :closable="false"
      @close="onClose"
      :visible="visible"
    >
      <div class="mb5 gray" style="margin-top:-10px">
        <p>地址信息地图描点步骤：</p>1、搜索地址信息；2、点击“开始绘制”，并在地图上选择合适位置描点；3、描点位置信息确认后，点击“完成绘制”
      </div>
      <baidu-map
        :mapClick="false"
        class="map"
        :center="center"
        :zoom="14"
        :scroll-wheel-zoom="true"
        @click="paintPolyline"
      >
        <bm-control class="my_search">
          <a-button type="primary" @click="beginMap('polyline')">开始绘制</a-button>
          <a-button type="danger" class="ml20" @click="finishMap">完成绘制</a-button>
          <label style="position:relative">
            <a-icon type="search" class="iconSearch" />
            <input
              v-model="keyword"
              @focus="searchShow = true"
              placeholder="关键词搜索"
              class="seachInput"
            />
          </label>
          <bm-navigation anchor="BMAP_ANCHOR_TOP_RIGHT"></bm-navigation>
          <bm-local-search
            :panel="searchShow"
            :pageCapacity="5"
            :keyword="keyword"
            :auto-viewport="true"
          ></bm-local-search>
        </bm-control>
        <bm-marker :position="my_position" :dragging="false"></bm-marker>
      </baidu-map>
    </a-drawer>
  </div>
</template>
<script>
import zhCN from "ant-design-vue/lib/locale-provider/zh_CN";
import moment from "moment";
import "moment/locale/zh-cn";
moment.locale("zh-cn");
export default {
  data() {
    return {
      zhCN,
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
      searchShow: true,
      center: { lng: 116.404, lat: 39.915 },
      zoom: 3,
      my_position: {}, //地图上显示的位置
      location: "北京",
      isDraw: false,
      keyword: "",
      url: {
        next: "/next",
        capture: "/capture",
        sms: "/sms",
        duplicate: "/duplicate",
        register: "/register",
        getArea: "/getArea?parentId=",
        getDictItems: "/getDictItems/industry"
      },
      steps: [
        {
          title: "登录信息",
          content: "First-content"
        },
        {
          title: "公司信息",
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
      organizationList: [
        {
          value: "01",
          label: "社团类组织"
        },
        {
          value: "02",
          label: "民办实体机构"
        }
      ],
      set_typeList: [
        {
          value: "01",
          label: "在民政部门正式登记"
        },
        {
          value: "02",
          label: "在街道（乡镇）备案"
        },
        {
          value: "03",
          label: "在社区居委会备案"
        },
        {
          value: "04",
          label: "未登记或备案"
        }
      ],

      license: true,
      isActive: false,
      provinceItems: [],
      cityItems: [],
      streetItems: [],
      areaItems: [],
      workOwnType: [],
      licence: {
        reg_num: "",
        person: "",
        captial: "",
        address: "",
        business: "",
        name: ""
      },
      uploadimageLoading: false,
      uploadavatarLoading: false,
      avatarUrl: "", //公司LOGO
      imageUrl: "", //营业执照图片
      avatarUrlUpload: "", //公司LOGO
      imageUrlUpload: "", //营业执照图片
      extra: {
        lonlat: "",
        toAddress: "",
        toAddressName: "",
        industry: "",
        serveDate1: "",
        serveDate2: "",
        serveDate: []
      },
      isEquals: true, //密码两次输入相同为true,不同为false
      mall: this.GLOBAL.casPrefixUrl + "/#/login?service=" + this.GLOBAL.mall
    };
  },
  methods: {
    moment,
    next() {
      if (this.current == 0) {
        this.isnext(this.current);
        // this.current++;
      } else if (this.current == 1) {
        this.companyStep();
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
    backLogin(){
      let _this = this;
      this.$confirm({
        title: '确认取消注册流程吗？',
        okText: '确认',
        cancelText: '取消',
        onOk(){
          window.location.href = _this.mall
        },
        onCancel(){

        }
      });
    },
    //点击下一步时候判断公司信息有没有填写
    companyStep() {
      let res = this.form.getFieldsValue();
      if (!this.avatarUrlUpload) {
        this.$message.error("请设置公司LOGO");
      } else if (!res.departName || res.departName == undefined) {
        this.$message.error("请输入公司简称");
      } else if (!res.contactPhone || res.contactPhone == undefined) {
        this.$message.error("请输入服务电话");
      } else if (!res.contactPhone || res.contactPhone == undefined) {
        this.$message.error("请输入服务电话");
      } else if (!this.extra.lonlat || this.extra.lonlat == undefined) {
        this.$message.error("请在地图上标出经营位置");
      } else if (!res.address || res.address == undefined) {
        this.$message.error("请输入详细地址");
      } else if (!this.extra.industry || this.extra.industry == undefined) {
        this.$message.error("请选择从事行业");
      } else if (!this.imageUrlUpload) {
        this.$message.error("请上传营业执照");
      } else {
        this.current++;
      }
    },
    lastStep() {
      let res = this.form.getFieldsValue();
      return res;
    },
    uploadAction: function() {
      return window._CONFIG["upload"] + "/upload?action=uploadimage&type=ocr";
    },
    uploadActionavatar: function() {
      return window._CONFIG["upload"] + "/upload?action=uploadimage";
    },

    beginMap(name) {
      this.isDraw = true;
      if (this.my_position) {
        this.my_position.lat = "";
        this.my_position.lng = "";
      }
    },
    paintPolyline(e) {
      this.searchShow = false;
      if (this.isDraw) this.my_position = e.point;
      else this.my_position = "";
    },
    finishMap() {
      let lonlats = "";
      lonlats = this.my_position.lng + "," + this.my_position.lat;
      this.isDraw = false;
      this.extra.lonlat = lonlats;
      this.visible = false;
      this.$message.success("绘制完成！");
    },

    show_map() {
      this.visible = true;
    },
    onClose() {
      this.visible = false;
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
    //获取验证码
    getVerifityCode() {
      this.$http.get(this.url.capture).then(res => {
        // console.log(res)
        // res = JSON.stringify(res)
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
          module: 2
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
        param.extra.serveDate = [];
        param.departType = 2;
        param.extra.serveDate2 = values.serveDate2;
        param.extra.serveDate1 = values.serveDate1;
        param.extra.serveDate1 = param.extra.serveDate1
          ? param.extra.serveDate1.format("HH:mm")
          : null;
        param.extra.serveDate2 = param.extra.serveDate2
          ? param.extra.serveDate2.format("HH:mm")
          : null;
        param.extra.serveDate.push(param.extra.serveDate1);
        param.extra.serveDate.push(param.extra.serveDate2);
        param.extra.licence = this.licence;
        param.logo = this.avatarUrlUpload;
        param.licence = this.imageUrlUpload;
        delete param.serveDate1;
        delete param.serveDate2;
        delete param.extra.serveDate1;
        delete param.extra.serveDate2;
        delete param.extra.toAddressName;
        delete param.password2;
        delete param.usernames;
        // console.log(JSON.stringify(param));
        // return;
        this.$http.post(this.url.register, param).then(res => {
          if (res.data.success) {
            this.$message.success("提交成功");
            window.location.href = this.mall;
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
    //选择从事行业数据
    getWorkType() {
      this.$http.get(this.url.getDictItems).then(res => {
        this.workOwnType = res.data.result;
      });
    },
    getBase64(img, callback) {
      const reader = new FileReader();
      reader.addEventListener("load", () => callback(reader.result));
      reader.readAsDataURL(img);
    },
    //营业执照
    handleChange(info) {
      if (info.file.status === "uploading") {
        this.uploadimageLoading = true;
        return;
      }
      if (info.file.status === "done") {
        // Get this url from response in real world.
        this.getBase64(info.file.originFileObj, imageUrl => {
          this.imageUrl = imageUrl;
          this.uploadimageLoading = false;
        });
        let response = info.file.response;
        response.result.ocr = JSON.parse(response.result.ocr);
        this.licence.reg_num = response.result.ocr.reg_num;
        this.licence.person = response.result.ocr.person;
        this.licence.captial = response.result.ocr.captial;
        this.licence.address = response.result.ocr.address;
        this.licence.business = response.result.ocr.business;
        this.licence.name = response.result.ocr.name;
        this.imageUrlUpload = response.result.url;
      }
    },
    //公司logo
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
    }
  },
  mounted() {
    this.getAddressTree("", 0);
    this.getWorkType();
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
  height: 700px;
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
.business_container .ant-steps-item-process .ant-steps-item-icon {
  background-color: #fe6a6a !important;
}
.business_container .ant-steps-item-process .ant-steps-item-icon {
  border-color: #fe6a6a !important;
}
.business_container .ant-steps-item-icon > .ant-steps-icon {
  color: #fff !important;
}
.business_container
  .ant-steps-item-finish
  .ant-steps-item-icon
  > .ant-steps-icon {
  color: #fe6a6a !important;
}
.business_container .ant-steps-item-finish .ant-steps-item-icon {
  border-color: #fe6a6a !important;
}
.business_container .ant-btn-primary {
  background-color: #fe6a6a !important;
  border-color: #fe6a6a !important;
}
.steps-content1 {
  margin-top: 40px;
}
</style>