<template>
  <a-modal
    :title="title"
    :width="1000"
    :visible="visible"
    :okButtonProps="{ props: {disabled: disableSubmit} }"
    :confirmLoading="confirmLoading"
    :maskClosable="false"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭"
  >
    <div>
      <a-steps :current="current">
        <a-step v-for="item in steps" :key="item.title" :title="item.title" />
      </a-steps>
      <div class="steps-content" v-show="steps[current].content == 'First-content'">
        <a-spin :spinning="confirmLoading" style="background:#fff;padding-top:10px">
          <a-form :form="form">
            <a-row>
              <a-col :span="12">
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="楼宇地址" hasFeedback>
                  <a-input placeholder="请输入楼宇地址，例如8号楼" v-decorator="['buildingAddress', {}]" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="楼院俗称" hasFeedback>
                  <a-input placeholder="请输入楼院俗称" v-decorator="['buildingName', {}]" />
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="房屋类型" hasFeedback>
                  <j-dict-select-tag  v-decorator="['roomType', {}]" :triggerChange="true" placeholder="请选择房屋类型"
                                      dictCode="room_type"/>
                </a-form-item>
                <a-form-item
                  :labelCol="labelCol"
                  :wrapperCol="wrapperCol"
                  label="建筑物用途"
                  hasFeedback
                >
                  <j-dict-select-tag  v-decorator="['buildingUse', {}]" :triggerChange="true" placeholder="请选择建筑物用途"
                                      dictCode="build_use"/>
                </a-form-item>
                <!--<a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="建造年份" hasFeedback>
                  <a-date-picker
                    showTime
                    format="YYYY"
                    v-decorator="[ 'fixedYear', {}]"
                  />
                </a-form-item>-->
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="建筑层数" hasFeedback>
                  <a-input-number v-decorator="[ 'upfloorNum', {}]" :min="0"/>
                </a-form-item>
                <a-form-item
                  :labelCol="labelCol"
                  :wrapperCol="wrapperCol"
                  label="地下建筑层数"
                  hasFeedback
                >
                  <a-input-number v-decorator="[ 'downfloorNum', {}]" :min="0"/>
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="建筑结构" hasFeedback>
                  <j-dict-select-tag  v-decorator="['buildingStruture', {}]" :triggerChange="true" placeholder="请选择建筑物结构"
                                      dictCode="stru_type"/>
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="楼院面积" hasFeedback>
                  <a-input-number v-decorator="[ 'buildingArea', {}]" :min="0"/>
                </a-form-item>
                <a-form-item
                  :labelCol="labelCol"
                  :wrapperCol="wrapperCol"
                  label="每单元每层户数"
                  hasFeedback
                >
                  <a-input-number v-decorator="[ 'floorHouesnum', {}]" :min="0"/>
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="间数" hasFeedback>
                  <a-input-number v-decorator="[ 'houseNum', {}]"  :min="0"/>
                </a-form-item>
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="单元数" hasFeedback>
                  <a-input-number v-decorator="[ 'unitnum', {}]" :min="0"/>
                </a-form-item>
                <!--<a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="经纬度" hasFeedback>-->
                  <!--<a-input placeholder="请输入经纬度" v-decorator="['lonlat', {}]" />-->
                <!--</a-form-item>-->
                <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="备注" hasFeedback>
                  <a-input placeholder="请输入备注" v-decorator="['remark', {}]" />
                </a-form-item>
              </a-col>
            </a-row>
          </a-form>
        </a-spin>
      </div>
      <!--<div class="steps-content" v-show="steps[current].content == 'Second-content'">-->
        <!--<div>-->
          <!--<baidu-map-->
            <!--class="map"-->
            <!--:center="center"-->
            <!--:zoom="14"-->
            <!--:scroll-wheel-zoom="true"-->
            <!--@click="paintPolyline"-->
          <!--&gt;-->
            <!--<bm-control>-->
              <!--<a-button type="primary" @click="beginMap()">开始描点</a-button>-->
              <!--<a-button type="danger" @click="finishMap()">完成绘制</a-button>-->
              <!--<label>-->
                <!--关键词：-->
                <!--<input v-model="keyword" />-->
              <!--</label>-->
              <!--<bm-navigation anchor="BMAP_ANCHOR_TOP_RIGHT"></bm-navigation>-->
              <!--<bm-local-search-->
                <!--:panel="true"-->
                <!--:pageCapacity="3"-->
                <!--:keyword="keyword"-->
                <!--:auto-viewport="true"-->
              <!--&gt;</bm-local-search>-->
            <!--</bm-control>-->
            <!--<bm-marker :position="my_position" :dragging="false"></bm-marker>-->
          <!--</baidu-map>-->
        <!--</div>-->
      <!--</div>-->
      <div
        class="steps-content"
        v-show="steps[current].content == 'Third-content'"
        style="background:#fff;padding-top:10px"
      >
        如本楼没有单元，请填写0、零单元
        <a-row>
          <a-col :span="2"></a-col>
          <a-col :span="20">
            <div style="padding:20px;">
              <a-row type="flex" style="margin-bottom:10px" :gutter="24">
                <a-col :span="8">单元编号</a-col>
                <a-col :span="8">单元俗称</a-col>
                <a-col :span="8">操作</a-col>
              </a-row>
              <a-row
                type="flex"
                style="margin-bottom:10px"
                :gutter="24"
                v-for="(item, index) in orderMainModel.unitsList"
                :key="index"
              >
                <a-col :span="8">
                  <a-form-item>
                    <a-input-number placeholder="单元编号" v-model="item.unitNo" :min="0"/>
                  </a-form-item>
                </a-col>
                <a-col :span="8">
                  <a-form-item>
                    <a-input placeholder="单元俗称，如门、单元" v-model="item.unitName" />
                  </a-form-item>
                </a-col>
                <a-col :span="8">
                  <a-form-item>
                    <a-button @click="addRowTicket" icon="plus"></a-button>&nbsp;
                    <a-button @click="delRowTicket(index)" icon="minus"></a-button>
                  </a-form-item>
                </a-col>
              </a-row>
            </div>
          </a-col>
          <a-col :span="2"></a-col>
        </a-row>
      </div>
      <div
        class="steps-content"
        v-show="steps[current].content == 'Last-content'"
        style="background:#fff;padding-top:10px"
      >
        <div class="step_last" v-if="show_villageName">所属小区： {{show_villageName}}</div>
        <div class="step_last" v-if="model.villageName">所属小区： {{model.villageName}}</div>
        <div class="step_last">楼院俗称： {{show_buildingName}}</div>

        <div class="step_last">
          单元：
          <span v-for="(item,index) in orderMainModel.unitsList">
            <a-tag color="green" v-if="item.unitName != ''">{{item.unitName}}</a-tag>
          </span>

        </div>
      </div>

      <div class="steps-action">
        <a-button v-if="current < steps.length - 1" type="primary" @click="next">下一步</a-button>
        <a-button
          v-if="current == steps.length - 1"
          type="primary"
          @click="$message.success('Processing complete!')"
        >完成</a-button>
        <a-button v-if="current>0" style="margin-left: 8px" @click="prev">上一步</a-button>
      </div>
    </div>
  </a-modal>
</template>

<script>
import { httpAction, getAction } from '@/api/manage'
import pick from 'lodash.pick'
import moment from 'moment'
import JDate from '@/components/jeecg/JDate'
export default {
  components: {
    JDate
  },
  name: 'BuildingModal',
  data() {
    return {
      current: 0,
      steps: [
        {
          title: '填写楼宇信息',
          content: 'First-content'
        },
        // {
        //   title: '标注楼宇位置',
        //   content: 'Second-content'
        // },
        {
          title: '填写楼宇单元数',
          content: 'Third-content'
        },
        {
          title: '完成',
          content: 'Last-content'
        }
      ],

      center: { lng: 116.404, lat: 39.915 },
      zoom: 3,
      my_position: {}, //地图上显示的位置
      isDraw: false,
      keyword: '',
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
      moment,
      format: 'YYYY-MM-DD HH:mm:ss',
      disableSubmit: false,
      villageId: '',
      hiding: false,
      confirmLoading: false,
      form: this.$form.createForm(this),
      validatorRules: {},
      url: {
        add: '/village/village/addBuilding',
        edit: '/village/village/editBuilding',
        buildingData: '/village/building/queryById'
      },
      orderMainModel: { unitsList: [{}] },
      show_buildingName: '',
      show_villageName: '' //新增时显示所属小区
    }
  },
  created() {},
  methods: {
    onChangeRadio(e) {
      // console.log('radio checked', e.target.value)
      this.unitType = e.target.value
    },
    next() {
      this.current++
      if (this.current == 2) {
        console.log(this.form.getFieldsValue());
        this.show_buildingName = this.form.getFieldsValue().buildingName
      }
    },
    prev() {
      this.current--
    },
    beginMap() {
      this.isDraw = true
      if (this.my_position) {
        this.my_position.lat = ''
        this.my_position.lng = ''
      }
    },
    finishMap() {
      let lonlats = ''
      lonlats = this.my_position.lng + ',' + this.my_position.lat
      // console.log(lonlats)
      this.form.setFieldsValue({
        lonlat: lonlats
      })
      this.isDraw = false
    },
    paintPolyline(e) {
      if (this.isDraw) this.my_position = e.point
      else this.my_position = ''
      console.log(JSON.stringify(this.my_position))
    },
    addRowTicket() {
      this.orderMainModel.unitsList.push({})
      console.log(this.orderMainModel.unitsList)
      this.$forceUpdate()
    },
    delRowTicket(index) {
      console.log(index)
      this.orderMainModel.unitsList.splice(index, 1)
      this.$forceUpdate()
    },
    add(villageId, my_selectionRows) {
      //取消选中
      if (this.my_position) {
        this.my_position.lat = ''
        this.my_position.lng = ''
      }
      this.current = 0
      if (my_selectionRows) {
        this.show_villageName = my_selectionRows[0].villageName
        if (my_selectionRows[0].lonlat) {
          this.center.lng = my_selectionRows[0].lonlat.split('|')[0].split(',')[0]
          this.center.lat = my_selectionRows[0].lonlat.split('|')[0].split(',')[1]
        }
      }
      if (villageId) {
        this.edit({ villageId }, '')
      } else {
        this.$message.warning('请选择一个小区')
      }
    },
    detail(record) {
      this.edit(record, 'd')
    },
    edit(record, v) {
      console.log(record)
      if (record && record.id) {
        //编辑
        console.log(record)
        this.getDetailBuildng(record)
      } else {
        //新增
        this.orderMainModel.unitsList = [{}]
      }

      this.current = 0
      if (v == 'e') {
        this.hiding = false
        this.disableSubmit = false
      } else if (v == 'd') {
        this.hiding = false
        this.disableSubmit = true
      } else {
        this.hiding = true
        this.disableSubmit = false
      }
      this.form.resetFields()
      this.villageId = record.villageId
      // if (!!record.lonlat) {
      //   this.center.lng = record.lonlat.split('|')[0].split(',')[0]
      //   this.center.lat = record.lonlat.split('|')[0].split(',')[1]
      // }

      this.visible = true
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
          formData.fixedYear = formData.fixedYear ? formData.fixedYear.format('YYYY-MM-DD HH:mm:ss') : null
          formData.units = this.orderMainModel.unitsList
          formData.villageId = this.villageId
          console.log('formData:' + JSON.stringify(formData))
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
    //获取详情数据
    getDetailBuildng(record) {
      getAction(this.url.buildingData, { id: record.id }).then(res => {
        // console.log(JSON.stringify(res))
        if (res.result.units.length > 0) this.orderMainModel.unitsList = res.result.units
        else this.orderMainModel.unitsList = [{}]
        // this.my_position.lng = res.result.lonlat.split(',')[0]
        // this.my_position.lat = res.result.lonlat.split(',')[1]
        // console.log( this.my_position)
        this.model = Object.assign({}, res.result)
        console.log(JSON.stringify(this.model))
        this.visible = true
        this.$nextTick(() => {
          this.form.setFieldsValue(
            pick(
              this.model,
              'villageName',
              'buildingAddress',
              'buildingName',
              'roomType',
              'buildingUse',
              'fixedYear',
              'upfloorNum',
              'downfloorNum',
              'buildingStruture',
              'buildingArea',
              'floorHouesnum',
              'houseNum',
              'unitnum',
              'isToilet',
              'isWaterDispart',
              'isAmmeterDispart',
              'lonlat',
              'remark',
              'updateName',
              'createName',
              'createBy',
              'sysOrgCode',
              'sysOrgName',
              'sysCompanyCode',
              'sysCompanyName',
              'areaCode',
              'areaName',
              'units'
            )
          )
          // 时间格式化
          this.form.setFieldsValue({ fixedYear: this.model.fixedYear ? moment(this.model.fixedYear) : null })
        })
      })
    }
  }
}
</script>

<style scoped>
.map {
  height: 500px;
  width: 100%;
}
.steps-content {
  margin-top: 16px;
  border: 1px dashed #e9e9e9;
  border-radius: 6px;
  background-color: #fafafa;
  min-height: 200px;
  text-align: center;
}

.steps-action {
  margin-top: 24px;
}
.ant-btn {
  padding: 0 10px;
  margin-left: 3px;
}
.ant-form-item-control {
  line-height: 0px;
}
/** 主表单行间距 */
.ant-form .ant-form-item {
  margin-bottom: 10px;
}
/** Tab页面行间距 */
.ant-tabs-content .ant-form-item {
  margin-bottom: 0px;
}
.step_last {
  margin-bottom: 20px;
}
</style>
