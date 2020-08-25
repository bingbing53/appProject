<template>
  <a-modal
    :title="title"
    :width="1000"
    style="top: 0px;"
    :visible="visible"
    :confirmLoading="confirmLoading"
    :maskClosable="false"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭"
  >
    <a-divider orientation="left" :dashed="true">业主个人基本信息</a-divider>

    <a-spin :spinning="confirmLoading">
      <a-form :form="form">
        <a-row>
          <a-col :span="8" style="text-align: center">
            <a-input
              placeholder="请输入居民头像"
              v-decorator="['headImage', {}]"
              style="visibility:hidden;display: none"
            />
            <div style="width: 100%;text-align: center;padding-left: 25%;">
              <a-upload
                name="avatar"
                list-type="picture-card"
                class="avatar-uploader"
                :action="uploadActionavatar"
                :show-upload-list="false"
                :before-upload="beforeUpload"
                @change="handleChange"
              >
                <!--<img v-if="personHeadImage" :src="personHeadImage" alt="avatar" />-->
                <a-avatar
                  v-if="personHeadImage"
                  :src="personHeadImage"
                  icon="user"
                  shape="square"
                  :size="150"
                  style="backgroundColor:#87d068"
                />
                <div v-else>
                  <a-icon :type="loading ? 'loading' : 'plus'" />
                  <div class="ant-upload-text">
                    选择照片
                  </div>
                </div>
              </a-upload>
            </div>
            <!--<a-avatar-->
              <!--:src="personHeadImage"-->
              <!--icon="user"-->
              <!--shape="square"-->
              <!--:size="150"-->
              <!--style="backgroundColor:#87d068"-->
            <!--/>-->
            <!--<div
                style="width:130px;height:150px;border:1px solid #eee;border-radius:5px;"
              >
                <img :src="personHeadImage" alt="头像" />
            </div>-->
            <div style="margin-top: 10px;">
              <a-button type="link" @click="toreadIDcard()" icon="idcard" size="small" :disabled="IDcardFlag">读取身份证信息</a-button>
            </div>
          </a-col>
          <a-col :span="8">
            <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="姓名">
              <a-input
                placeholder="请输入姓名"
                v-decorator="['personName', validatorRules.personName ]"
              />
            </a-form-item>
            <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="性别">
              <j-dict-select-tag
                v-decorator="['sex', validatorRules.sex]"
                :triggerChange="true"
                placeholder="请选择性别"
                dictCode="sex"
              />
            </a-form-item>
            <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="手机号">
              <a-input
                placeholder="请输入手机号"
                v-decorator="['mobilePhone', validatorRules.mobilePhone ]"
              />
            </a-form-item>
            <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="卡号">
              <a-input
                placeholder="请输入卡号"
                v-decorator="['cardNo', validatorRules.cardNo]"
              />
            </a-form-item>
          </a-col>
          <a-col :span="8">
            <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="证件号码">
              <a-input placeholder="请输入证件号码" v-decorator="['idcard', validatorRules.idcard]" />
            </a-form-item>
            <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="户籍">
              <a-input placeholder="请输入户籍" v-decorator="['nativePlace', {}]" />
            </a-form-item>
            <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="家庭关系">
              <j-dict-select-tag
                v-decorator="['hostRelat', validatorRules.hostRelat]"
                :triggerChange="true"
                placeholder="请选择家庭关系"
                dictCode="host_relat"
              />
            </a-form-item>
          </a-col>
          <a-col :span="8">
            <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="民族">
              <a-input placeholder="民族" v-decorator="['nationality', {}]" />
            </a-form-item>
          </a-col>
        </a-row>
      </a-form>
      <a-divider orientation="left" :dashed="true" style="margin-top: 30px;">业主居住房屋信息</a-divider>
      <!-- 表格 -->
      <template>
        <a-button
          type="primary"
          @click="addHouse"
          style="margin-bottom:10px;margin-left:0px;"
        >添加居住房屋</a-button>
        <div>
          <a-table
            ref="table"
            size="middle"
            bordered
            rowKey="id"
            :columns="columns"
            :dataSource="dataSources"
            :loading="loading"
          >
            <span
              slot="area"
              slot-scope="text, record"
            >{{record.villageName}} / {{record.buildingName}} / {{record.unitName}}</span>
            <span slot="action" slot-scope="text, record">
              <a-popconfirm title="确定删除吗?" @confirm="() => my_handleDelete(record.id)">
                <a>删除</a>
              </a-popconfirm>
            </span>
          </a-table>
        </div>
      </template>
      <!-- 表格 -->
      <personaddress-Modal ref="personaddressModal" @rowData="getrowData"></personaddress-Modal>
      <!-- 未读取到身份证信息的弹窗 -->
      <personDetail-Modal ref="personDetailModal"></personDetail-Modal>
    </a-spin>
  </a-modal>
</template>

<script>
import { httpAction, getAction, getActionID, postActionimg } from '@/api/manage'
import pick from 'lodash.pick'
import personaddressModal from './PersonaddressModal'
import personDetailModal from './PersonDetailModal'

function getBase64(img, callback) {
  const reader = new FileReader();
  reader.addEventListener('load', () => callback(reader.result));
  reader.readAsDataURL(img);
}
export default {
  name: 'PersonInfoModal',
  components: {
    personaddressModal,
    personDetailModal
  },
  data() {
    return {
      IDcardFlag: false,
      personHeadImage: '',
      title: '操作',
      visible: false,
      loading: false,
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
        personName: { rules: [{ required: true, message: '请输入姓名!' }] },
        sex: { rules: [{ required: true, message: '请选择性别!' }] },
        mobilePhone: {
          rules: [
            { required: true, message: '请输入手机号!' },
            {
              validator: this.validateMobilePhone
            }
          ]
        },
        cardNo: {
          rules: [
            {
              validator: this.validateCardNo
            }
          ]
        },
        idcard: {
          rules: [
            { required: true, message: '请输入证件号码!' },
            {
              validator: this.validateIdCard
            }
          ]
        }
      },
      url: {
        add: '/person/personInfo/add',
        edit: '/person/personInfo/edit',
        readID: 'ws://localhost:9000/', //http://localhost:24010/ZKIDROnline/ScanReadIdCardInfo?OP-DEV=1&CMD-URL=4&REPEAT=1',
        persinDetail: '/person/personInfo/detail?id=',
        imageuploads: window._CONFIG['ssoPrefixUrl'] + '/sys/common/uploads?action=uploadscrawl',
        checkOnlyPerson: '/person/personInfo/checkOnlyPerson'
      },
      // 表头
      columns: [
        {
          title: '地址',
          align: 'center',
          width: 100,
          dataIndex: 'area',
          scopedSlots: { customRender: 'area' }
        },
        {
          title: '房号',
          align: 'center',
          width: 80,
          dataIndex: 'houseNumber'
        },
        {
          title: '居住类型',
          align: 'center',
          width: 80,
          dataIndex: 'liveType_dictText'
        },
        {
          title: '操作',
          dataIndex: 'action',
          align: 'center',
          width: 100,
          scopedSlots: { customRender: 'action' }
        }
      ],
      /* table选中keys*/
      selectedRowKeys: [],
      /* table选中records*/
      selectionRows: [],
      dataSources: [],
      selectIds: '',
      uploadImage: ''
    }
  },
  created() {},
  methods: {
    uploadActionavatar: function() {
      return window._CONFIG['upload'] + "/upload?action=uploadimage";
    },
    handleChange(info) {
      if (info.file.status === 'uploading') {
        return;
      }
      // if (info.file.status === 'done') {
        // Get this url from response in real world.
        getBase64(info.file.originFileObj, imageUrl => {
          this.personHeadImage = imageUrl;
        });
      // }
    },
    beforeUpload(file) {
      const isJpgOrPng = file.type === 'image/jpeg' || file.type === 'image/png';
      if (!isJpgOrPng) {
        this.$message.error('只能上传jpg或png格式图片!');
      }
      const isLt2M = file.size / 1024 / 1024 < 2;
      if (!isLt2M) {
        this.$message.error('请选择低于5m的图片!');
      }
      return isJpgOrPng && isLt2M;;
    },
    validateMobilePhone(rule, value, callback) {
      if (new RegExp(/^1[3|4|5|6|7|8|9][0-9]\d{8}$/).test(value)) {
        var params = {
          id: this.model.id,
          mobilePhone: value
        }
        getAction(this.url.checkOnlyPerson, params).then(res => {
          if (res.success) {
            callback()
          } else {
            callback('手机号已存在!')
          }
        })
      } else {
        callback('请输入正确格式的手机号码!')
      }
    },
    validateCardNo(rule, value, callback) {
      if (!new RegExp(/^[0-9a-zA-Z][0-9a-zA-Z\_\|\-]*$/).test(value)) {
        callback('请输入正确格式的卡号!')
      }else{
        callback();
      }
    },
    validateIdCard(rule, value, callback) {
      var params = {
        id: this.model.id,
        idcard: value
      }
      getAction(this.url.checkOnlyPerson, params).then(res => {
        if (res.success) {
          callback()
        } else {
          callback('身份证已存在!')
        }
      })
    },
    toreadIDcard() {
      this.IDcardFlag = true;
      if (!window.WebSocket) {
        alert('该版本浏览器不支持读取身份证')
        return
      }

      console.log(this.model)

      let personJson = {
        personName: '',
        idcard: '',
        headImage: '',
        sex: '',
        nativePlace: '',
        nationality: '',
        familyAddress: '',
        nationality:''
      }

      let _this = this

      var websocket = new WebSocket('ws://127.0.0.1:9000/')
      websocket.onopen = function(evt) {
        //onOpen(evt)
        console.log(evt)
        websocket.send('<ReadIdCard>')
      }
      websocket.onclose = function(evt) {
        //onClose(evt)
        console.log(evt)
        _this.IDcardFlag = false;
      }
      websocket.onmessage = function(evt) {
        _this.IDcardFlag = false;
        var personStr = evt.data
        console.log(personStr)
        personStr = personStr.replace('<', '').replace('>', '')
        let personArr = personStr.split(',')
        if (personArr[0] != 0) {
          alert('读取失败')
          return
        }
        if (personArr[1] == '设备连接失败'){
          _this.$refs.personDetailModal.visible = true;
          _this.IDcardFlag = false;
          return;
        }

        personJson.personName = personArr[2]
        personJson.idcard = personArr[8]
        personJson.headImage = 'data:image/jpg;base64,' + personArr[12]
        personJson.sex = personArr[3] == '男' ? '0' : '1'
        personJson.familyAddress = personArr[7]
        personJson.nationality = personArr[4]
        personJson.nativePlace = personArr[7]
        _this.personHeadImage = 'data:image/jpg;base64,' + personArr[12]

        if (!!_this.model.id) {
          //编辑
          _this.form.setFieldsValue({
            personName: personJson.personName,
            idcard: personJson.idcard,
            headImage: personJson.headImage,
            sex: personJson.sex,
            nativePlace:personJson.nativePlace,
            nationality:personJson.nationality
          })
        } else {
          //新增
          _this.edit(personJson, 'add')
        }
        websocket.close()
      }
      websocket.onerror = function(evt) {
        websocket.close()
        _this.$refs.personDetailModal.visible = true;
        _this.IDcardFlag = false;
      }
    },
    getUploadsImageList(params) {
      let that = this
      postActionimg(this.url.imageuploads, params).then(res => {
        if (res.code == 200) {
          that.uploadImage = res.url
        }
      })
    },
    addHouse() {
      this.$refs.personaddressModal.add()
    },
    onSelectChange() {},
    my_handleDelete(id) {
      console.log(id)
      let that = this
      this.dataSources.forEach(function(item, index) {
        if (item.id == id) {
          that.dataSources.splice(index, 1)
        }
      })
    },
    getrowData(rows, keys) {
      let that = this
      rows.forEach(function(item, index) {
        that.dataSources.push(item)
      })
      console.log(JSON.stringify(that.dataSources))
    },
    add() {
      this.edit({})
      this.personHeadImage = ''
    },
    formatPicture(pic) {
      return window._CONFIG['imageViewURL'] + '/' + pic
    },
    edit(record, value) {
      console.log(record)
      if (JSON.stringify(record) != '{}' && value != 'add') {
        //编辑
        this.getPersonDetail(record.id)
      } else {
        //新增
        this.dataSources = []
        this.form.resetFields()
        this.model = Object.assign({}, record)

        this.visible = true
        this.$nextTick(() => {
          this.form.setFieldsValue(
            pick(
              this.model,
              'id',
              'personName',
              'mobilePhone',
              'cardNo',
              'usedName',
              'idcard',
              'headImage',
              'sex',
              'nativePlace',
              'nationality',
              'polity',
              'eduLevel',
              'familyAddress',
              'createName',
              'updateName',
              'sysOrgCode',
              'sysCompanyCode',
              'areaCode',
              'areaName',
              'hostRelat',
              'nationality'
            )
          )
          //时间格式化
        })
      }
    },
    //点击列表编辑按钮获取居民的详情信息
    getPersonDetail(id) {
      try {
        let that = this
        getAction(this.url.persinDetail + id)
          .then(res => {
            // res.result.houses.forEach((item, index) => {
            //   that.dataSources.push(item)
            // })
            that.dataSources = res.result.houses
            this.form.resetFields()
            that.model = Object.assign({}, res.result)
            that.visible = true

            if (!!this.model.headImage && !this.model.headImage.startsWith('data:image')) {
              this.personHeadImage = this.formatPicture(this.model.headImage)
            }

            that.$nextTick(() => {
              that.form.setFieldsValue(
                pick(
                  that.model,
                  'personName',
                  'mobilePhone',
                  'cardNo',
                  'usedName',
                  'idcard',
                  'headImage',
                  'sex',
                  'nativePlace',
                  'nationality',
                  'polity',
                  'eduLevel',
                  'familyAddress',
                  'createName',
                  'updateName',
                  'sysOrgCode',
                  'sysCompanyCode',
                  'areaCode',
                  'areaName',
                  'hostRelat',
                  'nationality'
                )
              )
              //时间格式化
            })
          })
          .catch(error => {
            console.log('获取居民详情信息失败:', error)
          })
      } catch (err) {
        console.log(err)
      }
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
          //
          that.selectIds = ''
          this.dataSources.forEach(function(item, index) {
            that.selectIds += item.id + ','
          })

          that.selectIds = that.selectIds.substring(0, that.selectIds.length - 1)
          formData.houseIds = that.selectIds
          delete formData.houses

          if (this.personHeadImage.startsWith('data:image')) {
            let imageJson = {}
            imageJson['upfile'] = this.personHeadImage
            this.getUploadsImageList(imageJson)
            //将base64添加上
            formData.base64Str = this.personHeadImage
          }
          setTimeout(function() {
            if (that.personHeadImage.startsWith('data:image')) {
              formData.headImage = that.uploadImage
            }

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
          }, 1200)
        }
      })
    },
    handleCancel() {
      this.close()
    }
  }
}
</script>

<style lang="less" scoped>
.ant-form-item {
  margin-bottom: 18px;
}
</style>