<template>
  <div class="register_container estates_container">
    <a-steps :current="current" class="navBarWrap my_steps">
      <a-step v-for="item in steps" :key="item.title" :title="item.title" />
    </a-steps>
    <a-spin :spinning="confirmLoading">
      <a-form :form="form" style="width:100%;margin:0 auto">
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
          <a-form-item label="公司简称" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input
              v-decorator="[
          'departName',
          { rules: [{ required: true, message: '请输入公司简称' }] },
        ]"
              placeholder="请输入公司简称"
            />
          </a-form-item>
          <a-form-item label="公司LOGO" :label-col="labelCol" :wrapper-col="wrapperCol">
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
          <a-form-item label="服务电话" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input
              v-decorator="[
          'contactPhone',
          { rules: [{ required: true, message: '请输入服务电话' }] },
        ]"
              placeholder="请输入服务电话"
            />
          </a-form-item>
          <a-form-item label="经营位置" :label-col="labelCol" :wrapper-col="wrapperCol">
            <a-input
              v-model="mapLonlat"
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
            <p class="f10 bottom_gary" style="line-height:24px!important">请精确填写公司的经营位置及详细地址，该信息为公司的服务地址信息而非注册地址信息！</p>
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
          <a-row>
            <a-col :span="15" style="border-right:5px solid #eee">
              <div>
                <a-layout>
                  <a-layout-sider
                    style="max-height: 100%;overflow: scroll;background: #fff"
                    width="260"
                  >
                    <a-menu mode="inline" :style="bodyStyle" @select="menuSelect" theme="light">
                      <template v-for="item in areaList">
                        <a-sub-menu :key="item.orgCode">
                          <span slot="title">
                            <a-icon type="appstore" />
                            <span>{{item.title}}</span>
                          </span>
                          <template v-for="item2 in item.children">
                            <a-menu-item
                              v-if="!item2.children || item2.children.length == 0"
                              :key="item2.orgCode"
                            >{{item2.title}}</a-menu-item>
                            <a-sub-menu v-else :key="item2.orgCode">
                              <span slot="title">
                                <a-icon type="appstore" />
                                <span>{{item2.title}}</span>
                              </span>

                              <template v-for="item3 in item2.children">
                                <a-menu-item
                                  v-if="!item3.children || item3.children.length == 0"
                                  :key="item3.orgCode"
                                >{{item3.title}}</a-menu-item>
                                <a-sub-menu v-else :key="item3.orgCode">
                                  <span slot="title">
                                    <a-icon type="appstore" />
                                    <span>{{item3.title}}</span>
                                  </span>

                                  <template v-for="item4 in item3.children">
                                    <a-menu-item
                                      @click="clickItem(item4.title)"
                                      v-if="!item4.children || item4.children.length == 0"
                                      :key="item4.orgCode"
                                    >{{item4.title}}</a-menu-item>
                                    <a-sub-menu v-else :key="item4.orgCode">
                                      <span slot="title">
                                        <a-icon type="appstore" />
                                        <span>{{item4.title}}</span>
                                      </span>
                                      <template v-for="item5 in item4.children">
                                        <a-menu-item :key="item5.orgCode">{{item5.title}}</a-menu-item>
                                      </template>
                                    </a-sub-menu>
                                  </template>
                                </a-sub-menu>
                              </template>
                            </a-sub-menu>
                          </template>
                        </a-sub-menu>
                      </template>
                    </a-menu>
                  </a-layout-sider>
                  <a-layout>
                    <a-layout-content>
                      <a-card :bordered="false">
                        <a-table
                          bordered
                          :dataSource="dataSource"
                          :columns="columns"
                          :pagination="false"
                        >
                          <span slot="action" slot-scope="text, record">
                            <span v-if="record.checked">已添加</span>
                            <a v-if="!record.checked" @click="bindVillage(record)">点击添加</a>
                          </span>
                        </a-table>
                      </a-card>
                    </a-layout-content>
                  </a-layout>
                </a-layout>
              </div>
            </a-col>
            <a-col :span="9">
              <a-row>
                <!-- <a-col :span="2"></a-col> -->
                <a-col :span="24">
                  <div style="padding:10px;">
                    <a-row type="flex" style="margin-bottom:10px" :gutter="24">
                      <a-col :span="8">小区名称</a-col>
                      <a-col :span="8">所属社区</a-col>
                      <a-col :span="8">操作</a-col>
                    </a-row>
                    <a-row
                      type="flex"
                      style="margin-bottom:10px"
                      :gutter="24"
                      :key="index"
                      v-for="(item, index) in extra.village.slice(1)"
                    >
                      <a-col :span="8">
                        <a-form-item>
                          <a-input placeholder="小区名称" v-model="item.name" />
                        </a-form-item>
                      </a-col>
                      <a-col :span="8">
                        <a-form-item>
                          <a-input placeholder="所属社区" v-model="item.orgName" />
                        </a-form-item>
                      </a-col>
                      <a-col :span="8">
                        <!-- <a-button class="operate" @click="addRowTicket" icon="plus"></a-button> -->
                        <span class="operate" @click="delRowTicket(index)">删除</span>
                      </a-col>
                    </a-row>
                  </div>
                </a-col>
                <!-- <a-col :span="2"></a-col> -->
              </a-row>
            </a-col>
          </a-row>

          <a-form-item>
            <div style="margin:0 auto;">
              <a-button v-if="current ==0" style="width:100px" @click="prev">上一步</a-button>
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
              <h3 class="mb10">服务小区:</h3>
              <span
                v-for="(item,index) in extra.village"
                :key="index"
              >{{item.name}}, &nbsp;&nbsp;&nbsp;&nbsp;</span>
            </div>
          </div>
          <div style="margin-bottom:24px">
            <a-button v-if="current>0" style="width:100px" @click="prev">上一步</a-button>
            <a-button type="primary" style="width:100px;margin-left: 8px" @click="formOK">完成注册</a-button>
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
    <address-modal ref="AddressModal" v-on:getoption="getoptions"></address-modal>
  </div>
</template>
<script>
import AddressModal from "@/views/selectAddress";
export default {
  components: {
    AddressModal
  },
  data() {
    return {
      form: this.$form.createForm(this),
      confirmLoading: false,
      current: 0,
      labelCol: { span: 9 },
      wrapperCol: { span: 6 },
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
          title: "服务小区",
          content: "Last-content"
        },
        {
          title: "完成",
          content: "Last-content"
        }
      ],
      actionCode: "",
      license: true,
      isActive: false,
      extra: { village: [{}] },
      mapLonlat: "",
      houseIndex: 0,
      captureUrl: "",
      captureCode: "",
      btnClick: "获取验证码",
      timer: null,
      btnDisabled: false,
      uploadimageLoading: false,
      uploadavatarLoading: false,
      avatarUrl: "", //公司LOGO
      imageUrl: "", //营业执照图片
      avatarUrlUpload: "", //公司LOGO
      imageUrlUpload: "", //营业执照图片
      licence: {
        reg_num: "",
        person: "",
        captial: "",
        address: "",
        business: "",
        name: ""
      },
      community_index: 0,
      isEquals: true, //密码两次输入相同为true,不同为false
      bodyStyle: {
        padding: "0",
        height: window.innerHeight - 100 + "px"
      },
      visible: false,
      searchShow: true,
      center: { lng: 116.404, lat: 39.915 },
      zoom: 3,
      my_position: {}, //地图上显示的位置
      location: "北京",
      isDraw: false,
      keyword: "",

      url: {
        areaList: "/queryDepartTreeByDepartType",
        villageList: "/queryCommunityVillage/",
        next: "/next",
        capture: "/capture",
        sms: "/sms",
        duplicate: "/duplicate",
        register: "/register"
      },
      areaList: [],
      dataSource: [],
      nowSelectCode: "",
      nowSelectName: "",
      orgName: "",
      columns: [
        {
          title: "小区名称",
          align: "center",
          width: 30,
          dataIndex: "villageName"
        },
        {
          title: "操作",
          dataIndex: "action",
          align: "center",
          width: 20,
          scopedSlots: { customRender: "action" }
        }
      ],
      estate:
        this.GLOBAL.casPrefixUrl + "/#/login?service=" + this.GLOBAL.estate
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
          window.location.href = _this.estate
        },
        onCancel(){

        }
      });
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
      this.mapLonlat = lonlats;
      this.visible = false;
      this.$message.success("绘制完成！");
    },
    show_map() {
      this.visible = true;
    },
    onClose() {
      this.visible = false;
    },
    bindVillage(item) {
      // console.log(this.nowSelectName);
      item.checked = true;
      // console.log(JSON.stringify(item));
      // console.log(this.community_index);
      //  this.extra.village.push({"orgCode":this.nowSelectCode,"orgName":this.nowSelectName})
      // this.extra.village[this.community_index].orgCode = this.nowSelectCode;
      // this.extra.village[this.community_index].orgName = "aoq";//社区名字
      // this.extra.village[this.community_index].name = item.villageName;//社区名字
      this.extra.village.push({
        orgCode: this.nowSelectCode,
        orgName: this.orgName,
        name: item.villageName,
        id: item.id
      });
      //  this.extra.village.splice(0, 1);
      this.$forceUpdate();
      // console.log(this.extra);
      return;
      this.$message.success("添加成功");
      item.key = this.nowSelectCode;
      // this.menuSelect(item);
    },
    menuSelect(item) {
      // console.log(item);
      this.nowSelectCode = item.key;
      this.nowSelectName = item.departName;
      this.$http.get(this.url.villageList + item.key).then(res => {
        if (res.data.success) {
          this.dataSource = res.data.result;
        }
      });
    },
    getAreaList() {
      this.$http.get(this.url.areaList).then(res => {
        if (res.data.success) {
          this.areaList = res.data.result;
        }
        // console.log(this.areaList);
      });
    },
    clickItem(e) {
      this.orgName = e;
    },
    getoptions(name, code) {
      this.extra.village[this.community_index].orgCode = code;
      this.extra.village[this.community_index].orgName = name;
      this.$forceUpdate();
    },
    uploadAction: function() {
      return window._CONFIG["upload"] + "/upload?action=uploadimage&type=ocr";
    },
    uploadActionavatar: function() {
      return window._CONFIG["upload"] + "/upload?action=uploadimage";
    },
    getBase64(img, callback) {
      const reader = new FileReader();
      reader.addEventListener("load", () => callback(reader.result));
      reader.readAsDataURL(img);
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
    next() {
      if (this.current == 0) {
        this.isnext(this.current);
        // this.current++;
      } else if (this.current == 1) {
        this.estateStep();
        // this.current++;
        // this.getAreaList();
      } else if (this.current == 2) {
        // console.log(this.current);
        this.current++;
        // this.isViliageList();
      } else if (this.current == 3) {
        this.lastStep();
      } else {
        this.current++;
      }
    },
    prev() {
      this.current--;
    },
    estateStep() {
      let res = this.form.getFieldsValue();
      if (!res.departName || res.departName == undefined) {
        this.$message.error("请输入公司简称");
      } else if (!this.avatarUrlUpload) {
        this.$message.error("请设置公司LOGO");
      } else if (!res.contactPhone || res.contactPhone == undefined) {
        this.$message.error("请输入联系电话");
      } else if (
        !this.mapLonlat ||
        this.mapLonlat == undefined ||
        this.mapLonlat == ""
      ) {
        this.$message.error("请在地图上标出经营位置");
      } else if (!res.address || res.address == undefined) {
        this.$message.error("请输入详细地址");
      } else if (!this.imageUrlUpload) {
        this.$message.error("请上传营业执照");
      } else {
        this.current++;
      }
    },
    isViliageList() {
      let that = this;
      this.extra.village.forEach((item, index) => {
        if (item.orgName) {
          that.current++;
        } else {
          this.$message.error("请添加服务的小区");
        }
      });
    },
    //验证是否可以进行下一步
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
    //动态添加小区
    addRowTicket() {
      this.extra.village.push({});
      this.$forceUpdate();
    },
    //删除添加的小区
    delRowTicket(index) {
      this.extra.village.splice(index, 1);
      this.$forceUpdate();
    },
    select_community(index) {
      this.community_index = index;
      this.$refs.AddressModal.visible = true;
      this.$refs.AddressModal.getAddressTree("", 0);
    },
    sureArea() {
      this.visible = false;
    },
    //获取社区
    getAddressTree(parentId, num) {},
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
    //获取手机验证码
    getPhoneNum() {
      let res = this.form.getFieldsValue();
      let param = {
        params: {
          code: this.captureCode,
          mobile: res.mobile,
          verifyCode: this.actionCode,
          module: 1
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
        param.departType = 1;
        this.extra.village.splice(0, 1);
        // this.extra.village.forEach((item, index) => {
        //   delete item.name;
        //   delete item.orgName;
        // });
        param.extra.village = this.extra.village;
        param.extra.licence = this.licence;
        param.extra.lonlat = this.mapLonlat;
        param.logo = this.avatarUrlUpload;
        param.licence = this.imageUrlUpload;
        delete param.password2;
        delete param.usernames;
        // console.log(param);
        // return;
        this.$http.post(this.url.register, param).then(res => {
          if (res.data.success) {
            this.$message.success("提交成功");
            window.location.href = this.estate;
          }
        });
      });
    }
  },
  mounted() {
    this.getVerifityCode();
    this.getAreaList();
  }
};
</script>
<style>
.map {
  height: 700px;
  width: 100%;
}
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

.operate {
  width: 25%;
  display: inline-block;
  margin: 10px 10px;
}
.operate:hover {
  cursor: pointer;
  color: #f00;
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
.ant-upload.ant-upload-select-picture-card {
  width: 100% !important;
  height: 100% !important;
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
.estates_container .ant-steps-item-process .ant-steps-item-icon {
  background-color: #44b000 !important;
}
.estates_container .ant-steps-item-process .ant-steps-item-icon {
  border-color: #44b000 !important;
}
.estates_container .ant-steps-item-icon > .ant-steps-icon {
  color: #fff !important;
}
.estates_container
  .ant-steps-item-finish
  .ant-steps-item-icon
  > .ant-steps-icon {
  color: #44b000 !important;
}
.estates_container .ant-steps-item-finish .ant-steps-item-icon {
  border-color: #44b000 !important;
}
.estates_container .ant-btn-primary {
  background-color: #44b000 !important;
  border-color: #44b000 !important;
}
.steps-content1 .ant-form-item-required::before {
  content: "" !important;
}
</style>