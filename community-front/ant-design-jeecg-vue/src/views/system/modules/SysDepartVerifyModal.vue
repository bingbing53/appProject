<template>
  <a-drawer
    :title="title"
    :width="800"
    placement="right"
    :visible="visible"
    :closable="false"
    :confirmLoading="confirmLoading"
    @ok="handleOk"
    @close="handleCancel"
    cancelText="关闭"
  >
    <a-spin :spinning="confirmLoading">
      <a-form :form="form">
        <!-- <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="部门类型">
            <a-input
              placeholder="请输入部门类型"
              v-decorator="['departType', validatorRules.departType ]"
            />
        </a-form-item>-->
        <a-card title="登录信息">
          <a-row>
            <a-col :span="12">
              <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="登录名">
                <a-input placeholder="请输入登录名" v-decorator="['username', validatorRules.username ]" />
              </a-form-item>
              <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="真实姓名">
                <a-input
                  placeholder="请输入真实姓名"
                  v-decorator="['realname', validatorRules.realname ]"
                />
              </a-form-item>
            </a-col>
            <a-col :span="12">
              <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="手机号">
                <a-input placeholder="请输入手机号" v-decorator="['mobile', validatorRules.mobile ]" />
              </a-form-item>
              <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="邮箱">
                <a-input placeholder="请输入邮箱" v-decorator="['email', validatorRules.email ]" />
              </a-form-item>
            </a-col>
          </a-row>
        </a-card>
        <template v-if="model.departType == '物业'">
          <a-card title="公司信息" style="margin-top:20px;margin-bottom:20px">
            <a-row>
              <a-col :span="12">
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="公司简称">
                  <a-input placeholder="请输入公司简称" v-decorator="['departName', {}]" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="公司LOGO">
                  <img :src="getAvatarView(model.logo)" alt style="height:104px;max-width:300px" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属社区">
                  <div v-for="(item,index) in model.extras.village">
                    <span>{{item.orgName}}</span> ——
                    <span>{{item.name}}</span>
                  </div>
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="营业执照">
                  <img :src="getLienseView(model.licence)" alt style="height:104px;max-width:300px" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="地址">
                  <a-input placeholder="请输入地址" v-decorator="['address', {}]" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="联系电话">
                  <a-input placeholder="请输入联系电话" v-decorator="['contactPhone', {}]" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="公司全称">
                  <a-input placeholder="公司全称" v-model="model.extras.licence.name" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="统一社会信用代码">
                  <a-input placeholder="统一社会信用代码" v-model="model.extras.licence.reg_num" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="法人">
                  <a-input placeholder="法人" v-model="model.extras.licence.person" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="注册资本">
                  <a-input placeholder="注册资本" v-model="model.extras.licence.captial" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="注册地址">
                  <a-input placeholder="注册地址" v-model="model.extras.licence.address" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="经营范围">
                  <a-input placeholder="经营范围" v-model="model.extras.licence.business" />
                </a-form-item>
              </a-col>
            </a-row>
          </a-card>
        </template>
        <template v-if="model.departType == '街乡居委会'">
          <a-card title="街乡居委会信息" style="margin-top:20px;margin-bottom:20px">
            <a-row>
              <a-col :span="12">
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属社区">
                  <a-input
                    placeholder="请输入所属社区"
                    v-model="model.extras.toAddressName"
                    @click="showMap"
                  />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="辖区范围" :labelCol="labelCol" :wrapperCol="wrapperCol">
                  <a-input placeholder="点击查看地图" @click="showMap" />
                </a-form-item>
              </a-col>
            </a-row>
          </a-card>
        </template>
        <template v-if="model.departType == '商户'">
          <a-card title="商家信息" style="margin-top:20px;margin-bottom:20px">
            <a-row>
              <a-col :span="12">
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="公司简称">
                  <a-input placeholder="请输入公司简称" v-decorator="['departName', {}]" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="公司LOGO">
                  <img :src="getAvatarView(model.logo)" alt style="height:104px;max-width:300px" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属社区">
                  <div>{{model.extras.toAddress}}</div>
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="服务时间">
                  <div>
                    <span>{{model.extras.serveDate[0]}} 至</span>
                    <span>{{model.extras.serveDate[1]}}</span>
                  </div>
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="从事行业">
                  <j-dict-select-tag
                    placeholder="请输入从事行业"
                    v-model="model.extras.industry"
                    :triggerChange="true"
                    dictCode="industry"
                  />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="营业执照">
                  <img :src="getLienseView(model.licence)" alt style="height:104px;max-width:300px" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="地址">
                  <a-input placeholder="点击查看地图" v-decorator="['address', {}]" @click="showMap" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="联系电话">
                  <a-input placeholder="请输入联系电话" v-decorator="['contactPhone', {}]" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="公司全称">
                  <a-input placeholder="公司全称" v-model="model.extras.licence.name" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="统一社会信用代码">
                  <a-input placeholder="统一社会信用代码" v-model="model.extras.licence.reg_num" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="法人">
                  <a-input placeholder="法人" v-model="model.extras.licence.person" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="注册资本">
                  <a-input placeholder="注册资本" v-model="model.extras.licence.captial" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="注册地址">
                  <a-input placeholder="注册地址" v-model="model.extras.licence.address" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="经营范围">
                  <a-input placeholder="经营范围" v-model="model.extras.licence.business" />
                </a-form-item>
              </a-col>
            </a-row>
          </a-card>
        </template>
        <template v-if="model.departType == '社会组织'">
          <a-card title="社会组织信息" style="margin-top:20px;margin-bottom:20px">
            <a-row>
              <a-col :span="12">
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="组织LOGO">
                  <img :src="getAvatarView(model.logo)" alt style="height:104px;max-width:300px" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="组织名称">
                  <a-input placeholder="请输入组织名称" v-decorator="['departName', {}]" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="牵头人">
                  <a-input placeholder="请输入牵头人" v-model="model.extras.organiza_leader" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="地址">
                  <a-input placeholder="请输入地址" v-decorator="['address', {}]" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="组织形式">
                  <j-dict-select-tag
                    placeholder="请输入组织形式"
                    v-model="model.extras.organize_type"
                    :triggerChange="true"
                    dictCode="organize_type"
                  />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="成立方式">
                  <j-dict-select-tag
                    placeholder="请输入成立方式"
                    v-model="model.extras.setUP_type"
                    :triggerChange="true"
                    dictCode="setUP_type"
                  />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="工作内容">
                  <j-dict-select-tag
                    placeholder="请输入工作内容"
                    v-model="model.extras.work_content"
                    :triggerChange="true"
                    dictCode="work_content"
                  />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="工作内容补充">
                  <a-input placeholder="请输入工作内容补充" v-model="model.extras.work_contentMore" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="联系电话">
                  <a-input placeholder="请输入联系电话" v-decorator="['contactPhone', {}]" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属社区">
                  <a-input placeholder="请输入所属社区" v-model="model.extras.toAddress" />
                </a-form-item>
              </a-col>
            </a-row>
          </a-card>
        </template>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="状态">
          <a-input placeholder="请输入状态" v-decorator="['status', validatorRules.status ]" />
        </a-form-item>

        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="审核结论">
          <a-input placeholder="请输入审核结论" v-decorator="['reason', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol">
          <a-popconfirm
            title="审核是否通过?"
            @confirm="auditConfirm"
            @cancel="auditcancel"
            okText="是"
            cancelText="否"
          >
            <a-button>审核</a-button>
          </a-popconfirm>
        </a-form-item>
      </a-form>
    </a-spin>
    <a-modal title="审核不通过的原因" v-model="visibleView" @ok="viewHandleOk">
      <a-textarea :rows="4" placeholder="请输入不通过的原因" v-model="yourReason"></a-textarea>
    </a-modal>
    <a-modal width="800px" title="地图" @ok="onCloseMap" v-model="visibleMap">
      <baidu-map class="map" :center="center" :zoom="14" :scroll-wheel-zoom="true">
        <bm-navigation anchor="BMAP_ANCHOR_TOP_RIGHT"></bm-navigation>
        <bm-polygon
          v-for="(path,index) in polyline.paths"
          :path="path"
          :key="index"
          stroke-color="red"
          :stroke-weight="1"
          fill-color="red"
        ></bm-polygon>
      </baidu-map>
    </a-modal>
  </a-drawer>
</template>

<script>
import { httpAction, postAction } from '@/api/manage'
import pick from 'lodash.pick'
import moment from 'moment'

export default {
  name: 'SysDepartVerifyModal',
  data() {
    return {
      title: '详情',
      visible: false,
      visibleView: false,
      yourReason: '',
      model: {},
      labelCol: {
        xs: { span: 24 },
        sm: { span: 5 }
      },
      wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 }
      },

      confirmLoading: false,
      form: this.$form.createForm(this),
      validatorRules: {
        departType: { rules: [{ required: true, message: '请输入部门类型!' }] },
        username: { rules: [{ required: true, message: '请输入登录名!' }] },
        realname: { rules: [{ required: true, message: '请输入真实姓名!' }] },
        mobile: { rules: [{ required: true, message: '请输入手机号!' }] },
        email: { rules: [{ required: true, message: '请输入邮箱!' }] },
        status: { rules: [{ required: true, message: '请输入状态 0待审核->1审核通过->2审核不通过!' }] }
      },
      url: {
        add: '/system/sysDepartVerify/add',
        edit: '/system/sysDepartVerify/edit',
        audit: 'system/sysDepartVerify/verify',
        imgerver: window._CONFIG['domianURL'] + '/sys/common/view'
      },
      polyline: {
        editing: false,
        paths: []
      },
      center: { lng: 116.404, lat: 39.915 },
      zoom: 3,
      visibleMap: false
    }
  },
  created() {},
  methods: {
    getAvatarView() {
      return this.url.imgerver + '/' + this.model.logo
    },
    getLienseView() {
      return this.url.imgerver + '/' + this.model.licence
    },
    add() {
      this.edit({})
    },
    edit(record) {
      this.polyline.paths = []
      this.form.resetFields()
      this.model = Object.assign({}, record)
      this.model.extras = JSON.parse(this.model.extras)
      if (this.model.departType == '街乡居委会' || this.model.departType == '商户') {
        this.model.extras.lonlat = this.model.extras.lonlat.split('|')
        let arr = []
        this.model.extras.lonlat.forEach(function(item, index) {
          item = item.split('|')
          let json = {}
          item.forEach(function(items, indexs) {
            items = items.split(',')
            json.lng = items[0]
            json.lat = items[1]
          })
          arr.push(json)
        })
        this.polyline.paths.push(arr)
        this.center = this.polyline.paths[0][0]
      }
      this.visible = true
      this.$nextTick(() => {
        this.form.setFieldsValue(
          pick(
            this.model,
            'departType',
            'username',
            'realname',
            'mobile',
            'email',
            'departName',
            'logo',
            'licence',
            'address',
            'contactPhone',
            'extras',
            'status',
            'reason',
            'sysOrgCode'
          )
        )
        //时间格式化
      })
    },
    close() {
      this.$emit('close')
      this.visible = false
    },
    handleOk() {
      const that = this
      // 触发表单验证
      this.form.validateFields((err, values) => {
        if (!err) {
          that.confirmLoading = true
          let httpurl = ''
          let method = ''
          if (!this.model.id) {
            httpurl += this.url.add
            method = 'post'
          } else {
            httpurl += this.url.edit
            method = 'put'
          }
          let formData = Object.assign(this.model, values)
          //时间格式化

          console.log(formData)
          httpAction(httpurl, formData, method)
            .then(res => {
              if (res.success) {
                that.$message.success(res.message)
                that.$emit('ok')
              } else {
                that.$message.warning(res.message)
              }
            })
            .finally(() => {
              that.confirmLoading = false
              that.close()
            })
        }
      })
    },
    //不通过 ，写原因
    auditcancel() {
      this.visibleView = true
    },
    //审核通过
    auditConfirm() {
      this.reviewed(1)
    },
    //点击不通过的弹出框的确认按钮
    viewHandleOk() {
      this.visibleView = false
      this.reviewed(2)
    },
    //审核
    reviewed(status) {
      let that = this
      let param = {
        id: this.model.id,
        status: status,
        reason: this.yourReason
      }
      console.log(JSON.stringify(param))
      // return;
      postAction(this.url.audit, param)
        .then(res => {
          that.$message.success(res.message)
          that.visibleView = false
          this.visible = false
          this.$emit('load')
        })
        .catch(err => {
          that.$message.error('请求异常：' + err)
        })
    },
    handleCancel() {
      this.close()
    },
    showMap() {
      this.visibleMap = true
    },
    onCloseMap() {
      this.visibleMap = false
    }
  }
}
</script>

<style lang="less" scoped>
.map {
  height: 400px;
  width: 100%;
}
</style>