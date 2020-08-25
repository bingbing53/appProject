<template>
  <div class="editContainer">
    <a-spin :spinning="confirmLoading">
      <a-form :form="form">
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="活动标题">
          <a-input placeholder="请输入活动标题" v-decorator="['title', validatorRules.title]"/>
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol">
          <span slot="label"><span style="color: #f5222d">*</span> 活动主题图</span>
          <a-upload
            name="avatar"
            listType="picture-card"
            class="avatar-uploader"
            :showUploadList="false"
            :action="uploadAction"
            :headers="headers"
            @change="handleChange"
          >
            <img v-if="picUrl" :src="picUrl" alt="avatar" style="max-height: 200px;"/>
            <div v-else>
              <a-icon :type="uploadLoading ? 'loading' : 'plus'" />
              <div class="ant-upload-text">上传图片</div>
            </div>
          </a-upload>
        </a-form-item>

        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="活动时间">
          <a-date-picker
            :disabledDate="disabledStartDate"
            showTime
            format="YYYY-MM-DD HH:mm"
            v-decorator="['startTime', validatorRules.startTime]"
            placeholder="开始时间"
            @openChange="handleStartOpenChange"
          />
          ~
          <a-date-picker
            :disabledDate="disabledEndDate"
            showTime
            format="YYYY-MM-DD HH:mm"
            placeholder="结束时间"
            v-decorator="['endTime', {}]"
            :open="endOpen"
            @openChange="handleEndOpenChange"
          />
        </a-form-item>

        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="活动地点">
          <a-button @click="showMap">地图选点</a-button>
          <a-input placeholder="详细地址" v-decorator="['location',validatorRules.location]" :min="0" style="width: 250px;margin-left: 10px;"/>
        </a-form-item>

        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="活动类型">
          <a-radio-group defaultValue="0" buttonStyle="solid" v-decorator="['activityCategory', validatorRules.activityCategory]">
            <a-radio-button value="0" @click="aCategoryChange('0')">普通活动</a-radio-button>
            <a-radio-button value="1" @click="aCategoryChange('1')">公益活动</a-radio-button>
          </a-radio-group>
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所需公益币" v-show="activityCategoryValue == '1'">
          <a-input-number placeholder="公益币" v-decorator="['points',{}]" :min="0" style="width: 150px"/>
          <a-tooltip style="margin-left: 10px">
            <template slot="title">
              填 “0” 表示不需要公益币，志愿者可直接参加
            </template>
            <a-icon type="info-circle" />
          </a-tooltip>
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="活动标签">
          <span style="font-size: 12px;color:#666;">系统标签：  </span>
          <template v-for="tag in categoryList">
            <a-checkable-tag
              :key="tag.value"
              :checked="activityTypeChecked == tag.value"
              @change="checked => handleActivityTypeChange(tag, checked)"
            >
              {{ tag.title }}
            </a-checkable-tag>
          </template>
          <div>
            <span style="font-size: 12px;color:#666;">自定义标签：  </span>
            <template v-for="(tag, index) in tags">
              <a-tooltip v-if="tag.length > 20" :key="tag" :title="tag">
                <a-tag :key="tag" :closable="true" @close="() => handleClose(tag)">
                  {{ `${tag.slice(0, 20)}...` }}
                </a-tag>
              </a-tooltip>
              <a-tag v-else :key="tag" :closable="true" @close="() => handleClose(tag)">
                {{ tag }}
              </a-tag>
            </template>
            <template v-if="tags.length <= 3">
              <a-input
                v-if="inputVisible"
                ref="input"
                type="text"
                size="small"
                :style="{ width: '78px' }"
                :value="inputValue"
                @change="handleInputChange"
                @blur="handleInputConfirm"
                maxlength="10"
              />
              <a-tag v-else @click="showInput" style="background: #fff; borderStyle: dashed;">
                <a-icon type="plus" /> 添加标签
              </a-tag>
            </template>
          </div>
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="活动联系人">
          <a-row>
            <a-col :span="12">
              <a-input placeholder="联系人" v-decorator="['contact',{}]" style="width: 200px"/>
            </a-col>
            <a-col :span="12">
              <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="联系电话">
                <a-input placeholder="联系电话" v-decorator="['contactMobile',{}]" style="width: 200px"/>
              </a-form-item>
            </a-col>
          </a-row>
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="限制报名人数">
            <a-input-number placeholder="限制报名人数" v-decorator="['limitNum',{}]" :min="0" style="width: 200px"/>
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="关联代金券">
          <a-select mode="multiple" placeholder="请选择代金券" v-decorator="['smsCoupon',{}]">
            <a-select-option :value="item.id" v-for="(item,index) in couponList">{{item.name}}</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="活动内容">
          <Myueditor ref="Myueditor"></Myueditor>
        </a-form-item>

        <a-form-item :wrapperCol="wrapperCol" class="mg-auto tc">
          <a-button type="primary" html-type="submit" class="mg-10" @click="handleOk(1)" :disabled="confirmLoading">提交审核</a-button>
          <a-button type="primary" html-type="submit" class="mg-10" @click="handleOk(0)" :disabled="confirmLoading">存入草稿箱</a-button>
          <a-button type="info" class="mg-10" @click="cancel()">关闭</a-button>
        </a-form-item>
      </a-form>
    </a-spin>

    <position-select ref="modalForm" @ok="modalFormOk"></position-select>

  </div>
</template>

<script>
  import { httpAction, postAction, postActionimg, getAction } from '@/api/manage'
  import pick from 'lodash.pick'
  import moment from 'moment'
  import Myueditor from '../article/modules/Myueditor'
  import Vue from 'vue'
  import { ACCESS_TOKEN } from '@/store/mutation-types'
  import PositionSelect from "./modules/PositionSelect";

  export default {
    name: 'ActivityPost',
    components: {
      PositionSelect,
      Myueditor,
    },
    data() {
      return {
        expand: false,
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
        queryID: '',
        confirmLoading: false,
        form: this.$form.createForm(this),
        validatorRules: {
          title: { rules: [{ required: true, message: '请输入活动标题' },{max:100,message:'长度不能超过100'},{min:2,message:'最少两个字符'}] },
          startTime: { rules: [{ required: true, message: '请选择活动时间' }] },
          activityCategory: { rules: [{ required: true, message: '请选择活动分类' }] },
          location: { rules: [{ required: true, message: '请输入详细地址' }] },
          categoryType: { rules: [{ required: true, message: '请选择所属栏目' }] },
          toPosition: { rules: [{ required: true, message: '请选择接收对象' }] },
        },
        url: {
          detail: '/cms/activity/queryById',
          add: '/cms/activity/add',
          edit: '/cms/activity/edit',
          imgerver: window._CONFIG['imageViewURL'],
          fileUpload: window._CONFIG['ssoPrefixUrl'] + '/sys/common/uploads?action=uploadimage',
          categoryType: '/cms/activity/activityType', //活动分类
          couponList:'/cms/activity/mallCoupon'//优惠卷列表
        },
        endOpen: false,
        uploadLoading:false,
        headers:{},
        picUrl:'',
        tags: [],
        inputVisible: false,
        inputValue: '',
        activityTypeChecked:'',
        //活动分类
        categoryList:[],
        position:{},
        activityCategoryValue:'',

        //代金券列表
        couponList:[]
      }
    },
    created() {
      this.add();
      const token = Vue.ls.get(ACCESS_TOKEN)
      this.headers = { 'X-Access-Token': token }
    },
    computed: {
      uploadAction: function() {
        return this.url.fileUpload
      }
    },
    methods: {
      cancel(){
        let that = this;
        this.$confirm({
          title: '关闭确认',
          content: '是否确认关闭，关闭后不会保存修改！',
          onOk() {
              that.$router.replace({
                path: '/modules/activity/activityList',
                name: 'modules-activity-activityList'
              });
          },
          onCancel() {},
        });
      },
      //活动种类改变
      aCategoryChange(value){
        this.activityCategoryValue = value;
      },
      //显示地图
      showMap(){
        this.$refs.modalForm.show({});
      },
      handleActivityTypeChange(tag,checked) {
        if(checked) {
          this.activityTypeChecked = tag.value;
        }
      },
      handleClose(removedTag) {
        const tags = this.tags.filter(tag => tag !== removedTag);
        console.log(tags);
        this.tags = tags;
      },
      showInput() {
        this.inputVisible = true;
        this.$nextTick(function() {
          this.$refs.input.focus();
        });
      },
      handleInputChange(e) {
        this.inputValue = e.target.value;
      },
      handleInputConfirm() {
        const inputValue = this.inputValue;
        let tags = this.tags;
        if (inputValue && tags.indexOf(inputValue) === -1) {
          tags = [...tags, inputValue];
        }
        Object.assign(this, {
          tags,
          inputVisible: false,
          inputValue: '',
        });
      },

      handleChange(info) {
        this.picUrl = ''
        if (info.file.status === 'uploading') {
          this.uploadLoading = true
          return
        }
        if (info.file.status === 'done') {
          var response = info.file.response
          this.uploadLoading = false
          if (response.code == 200) {
            this.model.posterUrl = response.url
            this.picUrl = this.url.imgerver+'/'+response.url
          } else {
            this.$message.warning(response.message)
          }
        }
      },
      //获取所属栏目数据
      getcategoryList() {
        getAction(this.url.categoryType).then(res => {
          this.categoryList = res.result
        })
      },
      //获取所属栏目数据
      getCouponList() {
        getAction(this.url.couponList).then(res => {
          this.couponList = res.result
        })
      },
      add() {
        this.edit({points:0,activityCategory:'0'})
      },
      edit(record) {
        this.form.resetFields()
        this.model = Object.assign({}, record)
        if(!!record.content) {
          this.$refs.Myueditor.content = record.content
        }
        if(!!record.posterUrl){
          this.picUrl = this.url.imgerver+'/'+record.posterUrl
        }
        if(!!record.activityType){
          this.activityTypeChecked = record.activityType;
        }
        if(!!record.activityCategory){
          this.activityCategoryValue = record.activityCategory
        }
        //经纬度
        if(!!record.lonlat){
          let lonlatArr = record.lonlat.split(',');
          if(!!lonlatArr && lonlatArr.length == 2){
            this.position = {
              lng:lonlatArr[0],
              lat:lonlatArr[1]
            }
          }
        }
        if(record.departType == '2' && !!record.summary){
          this.tags = record.summary.split(',')
        }
        this.visible = true
        this.$nextTick(() => {
          this.form.setFieldsValue(
            pick(
              this.model,
              'title',
              'content',
              'points',
              'contact',
              'contactMobile',
              'activityCategory',
              'posterUrl',
              'location',
              'limitNum',
              'smsCoupon'
            )
          )
          //时间格式化
          this.form.setFieldsValue({ startTime: this.model.startTime ? moment(this.model.startTime) : null})
          this.form.setFieldsValue({ endTime: this.model.endTime ? moment(this.model.endTime) : null})

          if(!!this.model.smsCoupon){
            this.form.setFieldsValue({smsCoupon:this.model.smsCoupon.split(',').map(Number)})
          }
        })
      },
      close() {
        this.$emit('close')
        this.visible = false
      },
      modalFormOk(position){
        this.position = position;
      },
      handleOk(status) {
        const that = this
        // 触发表单验证
        this.form.validateFields((err, values) => {
          if (!err) {

            if(this.activityTypeChecked == ''){
              this.$message.warning('请选择活动标签->系统标签');
              return ;
            }

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
            formData.startTime = formData.startTime ? formData.startTime.format('YYYY-MM-DD HH:mm:ss') : null
            formData.endTime = formData.endTime ? formData.endTime.format('YYYY-MM-DD HH:mm:ss') : null

            formData.verifyState = status;
            formData.activityType = this.activityTypeChecked;
            if(this.tags.length > 0)
              formData.summary = this.tags.join(',');
            if(!!this.position.lng){
              formData.lonlat = this.position.lng+","+this.position.lat
            }
            if(!!formData.smsCoupon){
              formData.smsCoupon = formData.smsCoupon.join(',');
            }

            this.$refs.Myueditor.content && (formData.content = this.$refs.Myueditor.content)
            //提交之前上传图片
            // for (let i in this.coverArray) {
            //   if(!!this.coverArray[i].sourceUrl && this.coverArray[i].url.indexOf(this.coverArray[i].sourceUrl) != -1){
            //     that.uploadImageArr.push(this.coverArray[i].sourceUrl)
            //   } else {
            //     let imageJson = {}
            //     if (!!this.coverArray[i].base64) {
            //       imageJson['upfile'] = this.coverArray[i].base64
            //     } else {
            //       imageJson['upfile'] = this.coverArray[i].url
            //     }
            //     this.getUploadsImageList(imageJson)
            //   }
            // }

            setTimeout(function() {
              httpAction(httpurl, formData, method)
                .then(res => {
                  if (res.success) {
                    that.$message.success(res.message)
                    that.$emit('ok')

                    that.$router.replace({
                      path: '/modules/activity/activityList',
                      name: 'modules-activity-activityList'
                    })

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
      },
      //上传图片
      getUploadsImageList(params) {
        let that = this
        postActionimg(this.url.imageuploads, params).then(res => {
          if (res.code == 200) {
            that.uploadImageArr.push(res.url)
          }
        })
      },
      //根据ID获取详情数据
      getDetailByID() {
        getAction(this.url.detail, { id: this.queryID }).then(res => {
          res.success && this.edit(res.result)
        })
      },
      disabledStartDate(startValue) {
        const endValue = this.form.getFieldValue('endTime');
        // if (!startValue || !endValue) {
          return startValue && startValue <= moment().endOf('day');
        // }
        // return startValue.valueOf() > endValue.valueOf();
      },
      disabledEndDate(endValue) {
        const startValue = this.form.getFieldValue('startTime');
        if (!endValue || !startValue) {
          return false;
        }
        return startValue.valueOf() >= endValue.valueOf();
      },
      handleStartOpenChange(open) {
        if (!open) {
          this.endOpen = true;
          this.form.setFieldsValue({'endTime':''});
        }
      },
      handleEndOpenChange(open) {
        this.endOpen = open;
      },
    },
    mounted() {
      this.queryID = this.$route.query.id
      this.queryID && this.getDetailByID()
      this.getcategoryList()
      this.getCouponList()
    },
    watch: {
      startValue(val) {
        console.log('startValue', val);
      },
      endValue(val) {
        console.log('endValue', val);
      },
    },
  }
</script>

<style lang="less" scoped>
  @import '~@assets/less/common.less';
  @import '~@assets/less/common_cms.less';
  .cover_add {
    // text-align: center;
    .article-cover-add {
      background: #fafafa;
      border-radius: 4px;
      width: 120px;
      height: 120px;
      text-align: center;
      line-height: 120px;
      display: inline-block;
      border: 1px solid #e8e8e8;
      cursor: pointer;
      font-size: 18px;
      color: #aaa;
      margin: 5px;
    }
    img {
      width: 120px;
      height: 120px;
    }
    .cover_3_image {
      display: inline-block;
      margin: 5px;
      width: 120px;
      height: 120px;
    }
    .cover_1_image {
      display: inline-block;
      width: 120px;
      height: 120px;
    }
  }
</style>