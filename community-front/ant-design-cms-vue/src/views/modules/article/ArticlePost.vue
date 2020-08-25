<template>
  <div class="editContainer">
    <a-spin :spinning="confirmLoading">
      <a-form :form="form">
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="文章标题">
          <a-input placeholder="请输入文章标题" v-decorator="['articleTitle', validatorRules.articleTitle]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="文章内容">
          <Myueditor ref="Myueditor"></Myueditor>
        </a-form-item>

        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="所属栏目">
          <a-select placeholder="请选择所属栏目" v-decorator="['categoryType', validatorRules.categoryType]">
            <a-select-option :value="item.value" v-for="(item,index) in categoryList">{{item.title}}</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="封面" class="cover_add">
          <!-- <a-input placeholder="请输入图片类型" v-decorator="['aimageType', {}]" /> -->
          <!-- <a-radio-group @change="onChangeCover" v-model="coverImage">
            <a-radio :value="0">无图</a-radio>
            <a-radio :value="1">单图</a-radio>
            <a-radio :value="3">三图</a-radio>
          </a-radio-group>-->
          <j-dict-select-tag
            v-decorator="['aimageType', {}]"
            :triggerChange="true"
            type="radio"
            dictCode="aImageType"
            @change="onChangeCover"
          />

          <div class="cover_none" v-if="cover_none && !cover_one && !cover_three"></div>

          <div class="cover_one" v-else-if="!cover_none && cover_one && !cover_three">
            <div
              v-if="coverArray.length == 1"
              v-for="(item,index) in coverArray"
              :key="index"
              @click="select_cover_1"
              class="cover_1_image"
            >
              <img :src="item.url" alt />
            </div>
            <div v-if="coverArray.length == 0" class="article-cover-add" @click="select_cover_1">
              <a-icon type="plus" />
            </div>
            <div v-if="coverArray.length == 3" class="article-cover-add" @click="select_cover_1">
              <a-icon type="plus" />
            </div>
          </div>
          <div class="cover_three" v-else="!cover_none && !cover_one && cover_three">
            <template v-if="coverArray.length == 0">
              <div class="article-cover-add" @click="select_cover_3">
                <a-icon type="plus" />
              </div>
              <div class="article-cover-add" @click="select_cover_3">
                <a-icon type="plus" />
              </div>
              <div class="article-cover-add" @click="select_cover_3">
                <a-icon type="plus" />
              </div>
            </template>
            <template v-if="coverArray.length == 1">
              <div
                class="cover_3_image"
                v-for="(item,index) in coverArray"
                :key="index"
                @click="select_cover_3"
              >
                <img :src="item.url" alt />
              </div>
              <div class="article-cover-add" @click="select_cover_3">
                <a-icon type="plus" />
              </div>
              <div class="article-cover-add" @click="select_cover_3">
                <a-icon type="plus" />
              </div>
            </template>
            <template v-if="coverArray.length == 2">
              <div
                class="cover_3_image"
                v-for="(item,index) in coverArray"
                :key="index"
                @click="select_cover_3"
              >
                <img v-if="!!item.base64" :src="item.base64" alt />
                <img v-else :src="item.url" alt />
              </div>
              <div class="article-cover-add" @click="select_cover_3">
                <a-icon type="plus" />
              </div>
            </template>
            <template v-if="coverArray.length == 3">
              <div
                class="cover_3_image"
                v-for="(item,index) in coverArray"
                :key="index"
                @click="select_cover_3"
              >
                <img v-if="!!item.base64" :src="item.base64" alt />
                <img v-else :src="item.url" alt />
              </div>
            </template>
          </div>
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="接收对象">
          <j-dict-select-tag
            v-decorator="['toPosition', validatorRules.toPosition]"
            :triggerChange="true"
            placeholder="请选择接收对象"
            dictCode="art_where"
            @change="toPositionChange"
          />
        </a-form-item>

        <a-form-item v-show="multiUserShow" :labelCol="labelCol" :wrapperCol="wrapperCol" label="选择用户">
            <j-select-multi-user v-model="multiUser" placeholder="请选择用户" ref="multiSelect"></j-select-multi-user>
        </a-form-item>

        <div style="text-align: center;width: 100%;margin-bottom: 20px;">
          <a :style="{ fontSize: '12px'}" @click="expand = !expand">
            更多选项 <a-icon :type="expand ? 'up' : 'down'" />
          </a>
        </div>

        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="是否外部链接" v-show="expand">
          <j-dict-select-tag
            v-decorator="['outside', {}]"
            :triggerChange="true"
            type="radio"
            dictCode="yn"
            @change="changoutside"
          />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="文章链接" v-show="link_YN">
          <a-input placeholder="请输入文章链接" v-decorator="['link', {}]" />
        </a-form-item>
        <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="是否开放评论" v-show="expand">
          <j-dict-select-tag
            v-decorator="['allowComment', {}]"
            :triggerChange="true"
            type="radio"
            dictCode="yn"
          />
        </a-form-item>

        <!-- <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="资源链接">
          <a-input placeholder="请输入资源链接" v-decorator="['images', {}]" />
        </a-form-item>-->
        <!--<a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="是否置顶">-->
          <!--<j-dict-select-tag-->
            <!--v-decorator="['ontop', {}]"-->
            <!--:triggerChange="true"-->
            <!--placeholder="是否置顶"-->
            <!--dictCode="yn"-->
            <!--type="radio"-->
            <!--@change="changetop"-->
          <!--/>-->
        <!--</a-form-item>-->
        <!--<a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="置顶有效期" v-show="position_YN">-->
          <!--<a-date-picker showTime format="YYYY-MM-DD HH:mm:ss" v-decorator="[ 'spireTime', {}]" />-->
        <!--</a-form-item>-->
        <a-form-item :wrapperCol="wrapperCol" class="mg-auto tc">
          <a-button type="primary" html-type="submit" class="mg-10" @click="handleOk(1)" :disabled="confirmLoading">发布</a-button>
          <a-button type="primary" html-type="submit" class="mg-10" @click="handleOk(0)" :disabled="confirmLoading">存入草稿箱</a-button>
          <a-button type="primary" html-type="submit" class="mg-10" @click="topreView()">预览</a-button>
        </a-form-item>
      </a-form>
      <article-Cover ref="ArticleCover" @cover_ok="getResultCover"></article-Cover>
      <article-Preview ref="ArticlePreview"></article-Preview>
    </a-spin>
  </div>
</template>

<script>
import { httpAction, postAction, postActionimg, getAction } from '@/api/manage'
//  var SmartCrop = require ('../../../utils/smartcrop')
import pick from 'lodash.pick'
import moment from 'moment'
import Myueditor from '../article/modules/Myueditor'
import ArticleCover from './modules/ArticleCoverModal'
import ArticlePreview from './modules/ArticlePreviewModal'
import JSelectMultiUser from '@/components/jeecgbiz/JSelectMultiUser'

export default {
  name: 'ArticleEdit',
  components: {
    Myueditor,
    ArticleCover,
    ArticlePreview,
    JSelectMultiUser
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
      categoryList: [], //所属栏目
      validatorRules: {
        articleTitle: { rules: [{ required: true, message: '请输入文章标题' }] },
        categoryType: { rules: [{ required: true, message: '请选择所属栏目' }] },
        toPosition: { rules: [{ required: true, message: '请选择接收对象' }] },
      },
      url: {
        detail: '/article/article/queryById',
        add: '/article/article/add',
        edit: '/article/article/edit',
        imageuploads: window._CONFIG['ssoPrefixUrl'] + '/sys/common/uploads?action=uploadscrawl',
        imgerver: window._CONFIG['imageViewURL'],
        categoryType: 'article/article/articleType' //所属栏目
      },
      coverImage: 0,
      cover_three: false,
      cover_one: false,
      cover_none: true,
      coverArray: [],
      link_YN: false,
      position_YN:false,
      uploadImageArr: [],
      multiUser:'',
      multiUserShow:false
    }
  },
  created() {
    this.add();
  },
  methods: {
    toPositionChange(data){
      if(data == '2'){
        this.multiUserShow = true;
      }else{
        this.multiUserShow = false;
      }
    },
    changetop(e) {
      // console.log(e);
        if (e == '1') {
        this.position_YN = true
      } else {
        this.position_YN = false
      }
    },
    changoutside(e) {
      if (e == '1') {
        this.link_YN = true
      } else {
        this.link_YN = false
      }
    },
    onChangeCover(e) {
      // this.form.setFieldsValue({ aimageType: e.target.value })
      if (e == 0) {
        this.cover_none = true
        this.cover_one = false
        this.cover_three = false
      } else if (e == 1) {
        this.cover_none = false
        this.cover_one = true
        this.cover_three = false
      } else if (e == 3) {
        this.cover_none = false
        this.cover_one = false
        this.cover_three = true
      }
      // this.coverArray = []
    },
    select_cover_1() {
      this.$refs.ArticleCover.showModal()
      this.$refs.ArticleCover.getContent(this.$refs.Myueditor.content, 1)
    },
    select_cover_3() {
      this.$refs.ArticleCover.showModal()
      this.$refs.ArticleCover.getContent(this.$refs.Myueditor.content, 3)
    },
    //获取所属栏目数据
    getcategoryList() {
      getAction(this.url.categoryType).then(res => {
        console.log(res)
        this.categoryList = res.result
      })
    },
    add() {
      this.edit({outside:'0',allowComment:'0','aimageType':'0','ontop':'0','toPosition':'1'})
    },
    edit(record) {
      this.form.resetFields()
      this.model = Object.assign({}, record)
      if(!!record.content) {
          this.$refs.Myueditor.content = record.content
      }
      if(!!record.toPosition && record.toPosition == '2'){
        this.multiUserShow = true;
      }
      //封面回填
      if (record.aimageType && record.images) {
        if (record.aimageType == 1) {
          this.cover_none = false
          this.cover_one = true
          this.cover_three = false
        } else if (record.aimageType == 3) {
          this.cover_none = false
          this.cover_one = false
          this.cover_three = true
        } else {
          this.cover_none = true
          this.cover_one = false
          this.cover_three = false
        }

        record.images = record.images.split(',')
        for (let i in record.images) {
          let imageJson = {
            url: this.url.imgerver + '/' + record.images[i],
            sourceUrl: record.images[i],
            checked: 0,
            type: 0
          }
          this.coverArray[i] = imageJson
        }
      }
      this.visible = true
      this.$nextTick(() => {
        this.form.setFieldsValue(
          pick(
            this.model,
            'articleTitle',
            'categoryType',
            'link',
            'outside',
            'allowComment',
            // 'articleType',
            'aimageType',
            'images',
            // 'status',
            'ontop',
            'toPosition',
            'content'
          )
        )
        //时间格式化
        this.form.setFieldsValue({ spireTime: this.model.spireTime ? moment(this.model.spireTime) : null})

        if(!!record.toPosition && record.toPosition == '2' && !!record.persons){
          try {
            let persons = JSON.parse(record.persons);
            if(!!persons && persons.length > 0){
              this.$refs.multiSelect.selectList = persons;
            }
          }catch (e) {
          }
        }
      })
    },
    close() {
      this.$emit('close')
      this.visible = false
    },
    handleOk(status) {
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
          formData.spireTime = formData.spireTime ? formData.spireTime.format('YYYY-MM-DD HH:mm:ss') : null
          // console.log(this.$refs.Myueditor.content)
          formData.articleType = 0
          this.$refs.Myueditor.content && (formData.content = this.$refs.Myueditor.content)
          //提交之前上传图片
          for (let i in this.coverArray) {
            if(!!this.coverArray[i].sourceUrl && this.coverArray[i].url.indexOf(this.coverArray[i].sourceUrl) != -1){
              that.uploadImageArr.push(this.coverArray[i].sourceUrl)
            } else {
              let imageJson = {}
              if (!!this.coverArray[i].base64) {
                imageJson['upfile'] = this.coverArray[i].base64
              } else {
                imageJson['upfile'] = this.coverArray[i].url
              }
              this.getUploadsImageList(imageJson)
            }
          }

          var persons = [];
          var selectUserList = this.$refs.multiSelect.selectList;
          if(selectUserList.length > 0){
            selectUserList.forEach(function(item){
              persons.push(item.id);
            });
            formData.persons = persons.join(',');
          }

          setTimeout(function() {
            formData.images = that.uploadImageArr.join(',')
            status == 0 ? (formData.status = 0) : (formData.status = 1)
            console.log(formData)
            // return
            httpAction(httpurl, formData, method)
              .then(res => {
                if (res.success) {
                  that.$message.success(res.message)
                  that.$emit('ok')

                  that.$router.replace({
                    path: '/modules/article/articleList',
                    name: 'modules-article-articleList'
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
    
    getResultCover(data) {
      console.log(data)
      let that = this;
      that.coverArray = [];
      for (let i in data) {
        if(data[i].checked != 1)
          continue;
        let url = data[i].url
        let image = new Image()
        image.src = url
        image.crossOrigin = 'anonymous'
        console.log(image.src);
        var options = {
          width: 100,
          height: 100,
        }
        image.onload = function(){
          SmartCrop.crop(
            image, options,
            function(result) {
              var quality = 1 //定义默认图片压缩后的质量（0~1）
              var selectedCrop = result.topCrop
              var canvasimg = document.createElement('canvas')
              var ctx = canvasimg.getContext('2d')
              canvasimg.width = selectedCrop.width
              canvasimg.height = selectedCrop.height
              image.width = image.width
              image.height = image.height
              ctx.drawImage(
                image,
                selectedCrop.x,
                selectedCrop.y,
                selectedCrop.width,
                selectedCrop.height,
                0,
                0,
                selectedCrop.width,
                selectedCrop.height
              )
              var dataURL = canvasimg.toDataURL('image/jpeg', quality)
              data[i].base64 = dataURL
              that.coverArray.push(data[i]);
            }
          )
        }
      }
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
    //预览文章内容
    topreView() {
      this.$refs.ArticlePreview.visible = true
      let title = this.form.getFieldsValue().articleTitle;
      this.$refs.ArticlePreview.getContent(this.$refs.Myueditor.content, title)
    }
  },
  mounted() {
    this.queryID = this.$route.query.id
    this.queryID && this.getDetailByID()
    this.getcategoryList()
  }
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