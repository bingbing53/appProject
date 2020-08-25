<template>
  <a-drawer
    :title="title"
    :width="800"
    placement="right"
    :closable="false"
    @close="close"
    :visible="visible"
  >
    <a-spin :spinning="confirmLoading">
      <a-form :form="form">
        <template>
          <a-tabs defaultActiveKey="1" @tabClick="housetabClick" v-model="activeKey">
            <a-tab-pane key="1">
              <span slot="tab"><a-icon type="home" />房屋信息</span>
              <a-row>
                <a-col :span="12">
                    <a-form-item label="所属单元" :labelCol="labelCol" :wrapperCol="wrapperCol">
                      <a-row>
                        <a-col :span="18"><a-input placeholder="点击右侧按钮选择单元" v-model="unitValue" disabled></a-input></a-col>
                        <a-col :span="6"><a-button icon="search" @click="onSearch">选择</a-button></a-col>
                      </a-row>

                      <!--<a-input-search
                        placeholder="点击右侧按钮选择单元"
                        readonly="readonly"
                        v-model="unitValue"
                        @search="onSearch"
                      >
                        <a-button slot="enterButton" icon="search">选择</a-button>
                      </a-input-search>-->
                    </a-form-item>
                </a-col>
                <a-col :span="12">
                    <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="房号">
                      <a-input placeholder="请输入房号" v-decorator="['houseNumber', {}]" />
                    </a-form-item>
                </a-col>
                <a-col :span="12">
                  <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="户型">
                    <j-dict-select-tag  v-decorator="['buildingModel', {}]" :triggerChange="true" placeholder="请选择户型"
                                        dictCode="build_use"/>
                  </a-form-item>
                </a-col>
                <a-col :span="12">
                  <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="房屋用途">
                    <j-dict-select-tag  v-decorator="['houseUse', {}]" :triggerChange="true" placeholder="请选择房屋用途"
                                        dictCode="house_use"/>
                  </a-form-item>
                </a-col>
                <a-col :span="12">
                  <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="是否出租">
                    <j-dict-select-tag  v-decorator="['isRent', {}]" :triggerChange="true" placeholder="请选择是否出租"
                                        dictCode="yn"/>
                  </a-form-item>
                </a-col>
              <a-col :span="12">
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="居住类别">
                  <j-dict-select-tag  v-decorator="['liveType', {}]" :triggerChange="true" placeholder="请选择居住类别"
                                      dictCode="live_type"/>
                </a-form-item>
              </a-col>

              <a-divider orientation="left">
                产权人信息
              </a-divider>

              <a-col :span="12">
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="产权类别">
                  <j-dict-select-tag  v-decorator="['droitType', {}]" :triggerChange="true" placeholder="请选择产权类别"
                                      dictCode="droit_type"/>
                </a-form-item>
              </a-col>

              <a-col :span="12">
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="联系电话">
                  <a-input placeholder="请输入联系电话" v-decorator="['contactPhone', {}]" />
                </a-form-item>
              </a-col>

              <a-col :span="12">
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="产权人名称">
                  <a-input placeholder="请输入产权人名称" v-decorator="['houseOwnername', {}]" />
                </a-form-item>
              </a-col>

              <a-col :span="24">
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="备注">
                  <a-textarea :rows="3" placeholder="请输入备注" v-decorator="['remark', {}]" />
                </a-form-item>
              </a-col>
              </a-row>
            </a-tab-pane>
            <a-tab-pane key="3">
              <span slot="tab"><a-icon type="team" />同住人信息</span>

              <!-- 成员信息表格begin -->
              <div>
                <!--<div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
                  <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择
                  <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项
                  <a style="margin-left: 24px" @click="onClearSelected">清空</a>
                </div>-->

                <a-table
                  ref="table"
                  size="middle"
                  bordered
                  rowKey="id"
                  :columns="columns"
                  :dataSource="dataSource"
                  :loading="loading"
                >
                  <span slot="action" slot-scope="text, record">
                    <!-- <a @click="handleEdit(record)">编辑</a> -->

                    <!-- <a-divider type="vertical" /> -->

                    <a-popconfirm title="确定删除吗?" @confirm="() => my_handleDelete(record.id)">
                      <a>删除</a>
                    </a-popconfirm>

                  </span>
                </a-table>
              </div>
              <!-- 成员信息表格end -->
            </a-tab-pane>
          </a-tabs>
        </template>
      </a-form>
    </a-spin>
    <add-person ref="addPerson" @rowData="getrowData" @rowDataown="getownerInfo"></add-person>

    <address-window ref="addressWindow" @ok="modalFormOk"></address-window>
    <!--<a-button type="primary" @click="handleOk">确定</a-button>-->
    <!--<a-button type="primary" @click="handleCancel">取消</a-button>-->

    <div class="drawer-bootom-button">
      <a-button style="margin-right: .8rem" @click="handleCancel">取消</a-button>
      <a-button @click="handleOk" type="primary" :loading="confirmLoading">提交</a-button>
    </div>

  </a-drawer>
</template>

<script>
import { httpAction } from '@/api/manage'
import pick from 'lodash.pick'
import moment from 'moment'
import addressWindow from '../../village/modules/AddressTreeWindow' //引入选择单元弹窗组件
import addPerson from '../../person/AddPerson' //添加人员或业主的弹窗组件
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import { getAction } from '@/api/manage'

export default {
  name: 'ChoiseHouseModal',
  mixins: [JeecgListMixin],
  components: {
    addressWindow,
    addPerson
  },
  data() {
    return {
      activeKey:'1',
      ownerId: '',
      ownrerInfo: '',
      personIds: '', //选择后成员的id集合
      houseId: '',
      houseTab3: 'false',
      unitValue: '', //保存保存选择的单元
      title: '操作',
      visible: false,
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
      validatorRules: {},
      url: {
        add: '/village/house/add',
        edit: '/village/house/edit',
        // list: '/person/personInfo/list',
        list: '/village/house/queryHouseInfo',
        delete: '/person/personInfo/delete'
      },
      // 表头
      columns: [
        // {
        //   title: '#',
        //   dataIndex: '',
        //   key: 'rowIndex',
        //   width: 60,
        //   align: 'center',
        //   customRender: function(t, r, index) {
        //     return parseInt(index) + 1
        //   }
        // },
        {
          title: '姓名',
          align: 'center',
          width: 80,
          dataIndex: 'personName'
        },
        {
          title: '手机号',
          align: 'center',
          width: 100,
          dataIndex: 'mobilePhone'
        },
        {
          title: '证件号码',
          align: 'center',
          width: 80,
          dataIndex: 'idcard'
        },
        // {
        //   title: '性别',
        //   align: 'center',
        //   width: 80,
        //   dataIndex: 'sex'
        // },
        // {
        //   title: '籍贯',
        //   align: 'center',
        //   width: 80,
        //   dataIndex: 'nativePlace'
        // },
        {
          title: '操作',
          width: 80,
          dataIndex: 'action',
          align: 'center',
          scopedSlots: { customRender: 'action' }
        }
      ]
    }
  },
  created() {},
  methods: {
    getrowData(data, idArray) {
      //从子组件中获取选中人员的id,并放入this.dataSource中渲染当前表格
      console.log(this.dataSource)
      if (!this.dataSource) {
        this.dataSource = []
      }
      console.log(idArray)
      let that = this
      data.forEach((item, index) => {
        // that.dataSource && that.dataSource.push(item);
        if (JSON.stringify(that.dataSource).indexOf(item.id) == -1) {
          that.dataSource.push(item) // 进行动态的操作
        }
      })
      this.personIds = idArray.join(',')
    },
    getownerInfo(data, idArray) {
      console.log(data, idArray)
      this.ownrerInfo = data[0]
      this.ownerId = idArray[0]
    },
    housetabClick(e) {
      if (JSON.stringify(this.model) != '{}') {
        e == '3' && this.houseTab3 ? true : false
        this.filters = {}
        this.filters['houseId'] = this.houseId
        this.searchQuery(this.filters)
      }
    },
    onSearch() {
      this.$refs.addressWindow.add()
    },
    // gethouseInfo() {
    //   getAction(this.url.houseInfo, ).then(res => {
    //     console.log(JSON.stringify(res))
    //   })
    // },
    //点击添加成员按钮
    addPersons() {
      // this.loadData()
      // this.$refs.addPerson.addvisible = true;
      this.$refs.addPerson.add('any')
    },
    addowner() {
      //  this.$refs.addPerson.addvisible = true;
      this.$refs.addPerson.add(1)
    },
    //自定义前端删除添加的家庭成员
    my_handleDelete(id) {
      let that = this

      if (this.personIds && this.personIds.length > 0) {
        this.personIds = this.personIds.split(',')

        this.personIds = this.personIds.filter(function(s) {
          return s && s.trim()
        })
        console.log(this.personIds)
        this.personIds.forEach(function(item, index) {
          console.log(item.length)
          if (item == id || item.length < 1) {
            that.personIds.splice(index, 1)
          }
        })
      }
      this.personIds = this.personIds.join(',')
      console.log(this.personIds)
      if (this.dataSource && this.dataSource.length > 0) {
        this.dataSource.forEach(function(item, index) {
          if (item.id == id) {
            that.dataSource.splice(index, 1)
          }
        })
      }
    },
    add() {
      this.edit({})
    },
    edit(record) {
      this.personIds = '';
      this.dataSource = []
      this.ownrerInfo = ''
      this.activeKey = '1'

      if (JSON.stringify(record) == '{}') {
        console.log(this.dataSource)
        this.dataSource = []
      }
      this.form.resetFields()
      this.model = Object.assign({}, record)

      record.id ? (this.houseId = record.id) : ''
      record.unitName ? (this.unitValue = record.unitName) : ''
      record.unitId ? (this.model.unitId = record.unitId) : ''

      this.visible = true
      this.$nextTick(() => {
        this.form.setFieldsValue(
          pick(
            this.model,
            // 'buildingId',
            // 'villageId',
            // 'unitId',
            'unitName',
            'floorNo',
            'houseNumber',
            'buildingModel',
            'houseUse',
            'isRent',
            'droitType',
            'houseOwnername',
            'contactPhone',
            // 'tDPersoninfoId',
            'liveType',
            'remark',
            'ownerId',
            'personsIds'
            // 'createName',
            // 'updateName',
            // 'sysOrgCode',
            // 'sysOrgName',
            // 'sysCompanyCode',
            // 'sysCompanyName',
            // 'areaCode',
            // 'areaName'
          )
        )
        //时间格式化
        this.form.setFieldsValue({ createDate: this.model.createDate ? moment(this.model.createDate) : null })
        this.form.setFieldsValue({ updateDate: this.model.updateDate ? moment(this.model.updateDate) : null })
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
          formData.createDate = formData.createDate ? formData.createDate.format('YYYY-MM-DD HH:mm:ss') : null
          formData.updateDate = formData.updateDate ? formData.updateDate.format('YYYY-MM-DD HH:mm:ss') : null

          formData.personIds = this.personIds
          formData.ownerId = this.ownerId
          console.log(JSON.stringify(formData))
          // return
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
    handleCancel() {
      this.close()
    },
    modalFormOk(formData) {
      console.log(formData)
      this.unitValue = formData.keyName
      this.model.unitId = formData.keyValue
    }
  }
}
</script>

<style lang="less" scoped>
/** Button按钮间距 */
/*.ant-btn {*/
  /*margin-left: 30px;*/
  /*margin-bottom: 30px;*/
  /*float: right;*/
/*}*/
.ant-input-suffix {
  display: inline-block !important;
  height: 100% !important;
}
.owner_style {
  text-align: left;
  font-size: 14px;
}
.drawer-bootom-button {
  position: absolute;
  bottom: -8px;
  width: 100%;
  border-top: 1px solid #e8e8e8;
  padding: 10px 16px;
  text-align: right;
  left: 0;
  background: #fff;
  border-radius: 0 0 2px 2px;
}
</style>