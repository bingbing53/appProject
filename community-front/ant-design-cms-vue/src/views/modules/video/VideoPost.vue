<template>
  <div class="editContainer">
    <!-- 上传前区域 -->
    <div class="video_area" v-show="video_step.step_1">
      <div class="video_icon">
        <a-icon type="play-circle" style="font-size:30px;" />
      </div>
      <br />
      <div class="video_upload">
        <a-button type="primary" size="large" @click="handleUpload">上传视频</a-button>
        <input
          id="excel-upload-input"
          type="file"
          accept=".mp4"
          class="c-hide"
          @change="handkeFileChange($event)"
          multiple
          style="display:none"
        />
      </div>
    </div>
    <!-- 进度条区域 -->
    <div v-show="video_step.step_2">
      <a-row>
        <a-col :span="4"></a-col>
        <a-col :span="17" class="video_progress" :class="percent == 100 ? 'doneupload':'doupload'">
          <div class="video_del">
            <span v-show="percent == 100">上传成功</span>
            <span v-show="percent > 0 && percent < 100">正在上传中...</span>
            <a-tag color="red" class="del" v-show="percent == 100" @click="delVideo">删除</a-tag>
          </div>

          <a-progress :percent="percent"/>
        </a-col>
        <a-col :span="3"></a-col>
      </a-row>
    </div>
    <!-- 表单区域 -->
    <div v-show="video_step.step_2">
      <a-spin :spinning="confirmLoading">
        <a-form :form="form">
          <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="视频标题">
            <a-input placeholder="请输入视频标题" v-decorator="['articleTitle', {}]" />
          </a-form-item>
          <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="视频简介">
            <a-textarea placeholder="请输入视频简介" :rows="4" v-decorator="['articleDes', {}]" />
          </a-form-item>
          <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="视频封面">
            <a-row>
              <a-col :span="5">
                <!-- <div v-if="selectedCover" class="cover_image"> -->
                <div
                  v-if="selectedCover"
                  class="cover_image"
                  id="fileSelect"
                  @click="local_videoCover"
                >
                  <img v-if="selectedCover.substring(0,4) == 'blob'" :src="selectedCover" alt />
                  <img v-else :src="getImageView(selectedCover)" alt />
                </div>
                <div v-else class="article-cover-add">
                  <a-icon type="plus" />
                </div>
              </a-col>
              <a-col :span="19">
                <div class="video_covers">
                  <p style="margin:0px;padding:0px">
                    <span>在视频中选取封面</span>
                  </p>
                  <swiper :options="swiperOption" ref="mySwiper" class="my_swiper">
                    <!-- slides -->
                    <span class="do_span" v-if="postData && postData.poster && postData.poster.length == 0 && percent == 100">正在获取视频封面中...</span>

                    <swiper-slide v-else v-for="(item,index) in postData.poster" :key="index">
                      <div
                        @click="select_videoCover(item,index)"
                        v-bind:class="{ coverBorder:index==current}"
                      >
                        <img :src="getImageView(item)" alt />
                      </div>
                    </swiper-slide>
                    <!-- Optional controls -->
                    <div class="swiper-pagination" slot="pagination"></div>
                    <div class="swiper-button-prev" slot="button-prev"></div>
                    <div class="swiper-button-next" slot="button-next"></div>
                    <div class="swiper-scrollbar" slot="scrollbar"></div>
                  </swiper>
                </div>
              </a-col>
            </a-row>
          </a-form-item>
          <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="是否开放评论">
            <j-dict-select-tag
              v-decorator="['allowComment', {}]"
              :triggerChange="true"
              dictCode="yn"
              type="radio"
            />
          </a-form-item>

          <a-form-item :labelCol="labelCol" :wrapperCol="wrapperCol" label="接收对象">
            <j-dict-select-tag
              v-decorator="['toPosition', {}]"
              :triggerChange="true"
              placeholder="请选择接收对象"
              dictCode="art_where"
              @change="toPositionChange"
            />
          </a-form-item>
          <a-form-item v-show="multiUserShow" :labelCol="labelCol" :wrapperCol="wrapperCol" label="选择用户">
            <j-select-multi-user v-model="multiUser" placeholder="请选择用户" ref="multiSelect"></j-select-multi-user>
          </a-form-item>
          <a-form-item :wrapperCol="wrapperCol" class="bar_bottom">
            <a-button type="primary" html-type="submit" class="submit" @click="handleOk(1)">发布</a-button>
            <a-button type="primary" html-type="submit" class="submit" @click="handleOk(0)">存入草稿箱</a-button>
          </a-form-item>
        </a-form>
        <input type="file" id="fileElem" @change="changepic($event)" style="display:none" />
      </a-spin>
    </div>
  </div>
</template>
<script>
import { httpAction, postAction, postActionvideo, getAction, postActionimg } from '@/api/manage'
import pick from 'lodash.pick'
import moment from 'moment'
import 'swiper/dist/css/swiper.css'
import { swiper, swiperSlide } from 'vue-awesome-swiper'
import JSelectMultiUser from '@/components/jeecgbiz/JSelectMultiUser'

export default {
  name: 'videoPost',
  components: {
    swiper,
    swiperSlide,
    JSelectMultiUser
  },
  data() {
    return {
      swiperOption: {
        autoplay: 3000,
        effect: '',
        slidesPerView: 4, //页面分组显示，这里显示为3组
        spaceBetween: 30,
        navigation: {
          nextEl: '.swiper-button-next',
          prevEl: '.swiper-button-prev'
        },
        on: {
          slideChange() {
            if (this.isBeginning) {
              this.navigation.$prevEl.css('display', 'none')
            } else {
              this.navigation.$prevEl.css('display', 'block')
            }
          }
        }
      },
      percent: 0,
      video_step: {
        step_1: true,
        step_2: true,
        step_3: false
      },
      url: {
        detail: '/article/article/queryById',
        add: '/article/article/add',
        edit: '/article/article/edit',
        videouploads: window._CONFIG['ssoPrefixUrl'] + '/sys/common/uploads?action=uploadvideo',
        imageuploads: window._CONFIG['ssoPrefixUrl'] + '/sys/common/uploads?action=uploadscrawl',
        imgerver: window._CONFIG['imageViewURL'],
        covers: '/article/article/videoCover'
      },
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
      selectedCover: '', //被选中的视频封面
      postData: {
        poster:[]
      },
      duration:'',
      current: -1,
      queryID: '',
      multiUser:'',
      multiUserShow:false
    }
  },
  computed: {
    swiper() {
      return this.$refs.mySwiper.swiper
    }
  },
  mounted() {
    // current swiper instance
    // 然后你就可以使用当前上下文内的swiper对象去做你想做的事了
    console.log('this is current swiper instance object', this.swiper)
    this.swiper.slideTo(1, 1000, false)
    //获取编辑时候的视频ID
    console.log(this.$route.query.id)
    this.queryID = this.$route.query.id
    this.queryID && this.getDetailByID()
  },
  methods: {
    toPositionChange(data){
      if(data == '2'){
        this.multiUserShow = true;
      }else{
        this.multiUserShow = false;
      }
    },
    getImageView: function(image) {
      return this.url.imgerver + '/' + image
    },
    select_yn(e) {
      // console.log(e);
    },
    handleUpload() {
      document.getElementById('excel-upload-input').click()
    },
    handkeFileChange(event) {
      this.video_step.step_1 = false
      this.video_step.step_2 = true
      let value = event.target.files[0]
      let formDatas = this.form.getFieldsValue()
      console.log(value)
      this.form.setFieldsValue({ articleTitle: value.name, articleDes: value.name })
      if (value.size > 200 * 1024 * 1024) {
        alert('上传文件不能超过200M')
        return
      }
      //上传视频
      let that = this
      let formData = new FormData()
      formData.append('upfile', value)
      postActionvideo(this.url.videouploads, formData, this.uploadProcessCallback).then(res => {
        console.log(res)
        if (res.state == '200') {
          that.postData = res
          that.selectedCover = res.poster[0]
          that.duration = res.duration
        }else{
          that.duration = 99
        }
      })
    },
    uploadProcessCallback(percent) {
      percent = Number(percent.substring(0, percent.length - 1))
      if (percent == 100) {
      }
      this.percent = percent
    },
    local_videoCover() {
      var ie = navigator.appName == 'Microsoft Internet Explorer' ? true : false
      if (ie) {
        document.getElementById('fileElem').click()
      } else {
        var a = document.createEvent('MouseEvents')
        a.initEvent('click', true, true)
        document.getElementById('fileElem').dispatchEvent(a)
      }
    },
    changepic(event) {
      console.log(event)
      let files = event.target.files
      let newsrc = this.getObjectURL(files[0])
      // let json = {
      //   url: newsrc,
      //   sourceUrl: '',
      //   checked: 0,
      //   type: 1
      // }
      // console.log(newsrc)
      this.selectedCover = newsrc
    },
    //建立一个可存取到该file的url
    getObjectURL(file) {
      let url = null
      // 下面函数执行的效果是一样的，只是需要针对不同的浏览器执行不同的 js 函数而已
      if (window.createObjectURL != undefined) {
        // basic
        url = window.createObjectURL(file)
      } else if (window.URL != undefined) {
        // mozilla(firefox)
        url = window.URL.createObjectURL(file)
      } else if (window.webkitURL != undefined) {
        // webkit or chrome
        url = window.webkitURL.createObjectURL(file)
      }
      return url
    },
    //根据ID获取详情数据
    getDetailByID() {
      getAction(this.url.detail, { id: this.queryID }).then(res => {
        console.log(JSON.stringify(res))

        res.success && this.edit(res.result)
      })
    },
    add() {
      this.edit({'toPosition':'1','allowComment':'0','content':''})
    },
    edit(record) {
      this.getCovers(record.id)
      this.form.resetFields()
      if(!record.allowComment)
        record.allowComment = '0';
      if(!record.content)
        record.content = '';
      this.model = Object.assign({}, record)
      console.log(JSON.stringify(record))
      if (record) {
        this.percent = 100
        // this.getCovers(record.id);
        if (record.images) {
          record.images = JSON.parse(record.images)
          this.selectedCover = record.images.img 
          this.postData.url = record.images.video
          this.duration = record.images.duration
        }
        if(!!record.toPosition && record.toPosition == '2'){
          this.multiUserShow = true;
        }
      }

      this.$nextTick(() => {
        this.form.setFieldsValue(
          pick(
            this.model,
            'articleTitle',
            'categoryType',
            'link',
            'outside',
            // 'articleType',
            'imageType',
            'images',
            // 'status',
            'ontop',
            'content',
            'toPosition',
            'articleDes',
            'allowComment'
          )
        )
        //时间格式化
        this.form.setFieldsValue({ spireTime: this.model.spireTime ? moment(this.model.spireTime) : null })

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
    select_videoCover(item, index) {
      console.log(item)
      this.current = index
      this.selectedCover = item
    },
    //删除视频
    delVideo() {
      let that = this
      this.$confirm({
        title: '删除确认?',
        content: '删除的内容不可恢复，确认删除 ?',
        okText: '确认',
        okType: 'danger',
        cancelText: '取消',
        onOk() {
          that.video_step.step_1 = true
          that.video_step.step_2 = false
          that.video_step.step_3 = false
          that.postData = {}
          that.selectedCover = ''
        },
        onCancel() {}
      })
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
          // formData.content = this.postData.url
          status == 0 ? (formData.status = 0) : (formData.status = 1)
          formData.articleType = 1

          var persons = [];
          var selectUserList = this.$refs.multiSelect.selectList;
          if(selectUserList.length > 0){
            selectUserList.forEach(function(item){
              persons.push(item.id);
            });
            formData.persons = persons.join(',');
          }

          if (this.selectedCover.substring(0, 4) == 'blob') {
            let imageJson = {}
            this.getCoverCrop(this.selectedCover)
            setTimeout(function() {
              // console.log(that.selectedCover)
              imageJson['upfile'] = that.selectedCover
              that.getUploadsImageList(imageJson)
            }, 800)
          }
          // console.log(that.selectedCover)
          setTimeout(function() {
            formData.images = {
              img: that.selectedCover,
              video: that.postData.url,
              duration:that.duration
            }
            formData.images = JSON.stringify(formData.images)
            console.log(JSON.stringify(formData))
            // return
            httpAction(httpurl, formData, method)
              .then(res => {
                if (res.success) {
                  that.$message.success(res.message)
                  that.$emit('ok')

                  that.$router.replace({
                    path: '/modules/video/videoList',
                    name: 'modules-video-videoList'
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
    //上传图片
    getUploadsImageList(params) {
      let that = this
      postActionimg(this.url.imageuploads, params).then(res => {
        if (res.code == 200) {
          console.log(JSON.stringify(res))
          that.selectedCover = res.url
        }
      })
    },
    // 图片裁切
    getCoverCrop(url) {
      console.log(url)

      let that = this
      let image = new Image()
      image.src = url
      image.crossOrigin = 'anonymous'
      console.log(image)
      SmartCrop.crop(
        image,
        {
          width: 100,
          height: 100
        },
        function(result) {
          console.log(result)
          var quality = 0.6 //定义默认图片压缩后的质量（0~1）
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
          // newImageArr.push(dataURL)
          // console.log(dataURL)
          // return dataURL
          that.selectedCover = dataURL
        }
      )
    },
    //编辑时候获取封面图
    getCovers(id) {
      let that = this
      getAction(this.url.covers, { id: id }).then(res => {
        if (res.code == 200) {
          console.log(JSON.stringify(res))
          that.$nextTick(() => {
            that.postData.poster = res.result.images
            that.duration = res.result.duration
          })
        }
      })
    }
  }
}
</script>
<style scoped>
.editContainer {
  background: #fff;
  padding: 20px;
  margin: 0px 50px;
}
.video_area {
  margin: 0 auto;
  text-align: center;
}
.video_icon {
  width: 66px;
  height: 46px;
  display: inline-block;
  text-align: center;
  line-height: 46px;
  border: 4px solid rgba(0, 0, 0, 0.65);
  border-radius: 6px;
  padding: 3px;
}
.video_upload {
  width: 100px;
  height: 60px;
  display: inline-block;
  margin-top: 20px;
  text-align: center;
}
.article-cover-add {
  background: #fafafa;
  border-radius: 4px;
  width: 120px;
  height: 120px;
  display: inline-block;
  text-align: center;
  line-height: 120px;
  display: inline-block;
  vertical-align: middle;
  border: 1px solid #e8e8e8;
  cursor: pointer;
  font-size: 18px;
  color: #aaa;
  margin: 5px;
}
.video_covers {
  width: 100%;
  display: inline-block;
  height: 130px;
  vertical-align: middle;
  padding: 2px 10px;
  border: 1px solid #e6e8eb;
  background: #f8f8f8;
}
.video_covers .do_span {
  color: #666;
  font-size: 12px;
  margin: 0px;
  padding: 0px;
}

.my_swiper {
  height: 62%;
}
.my_swiper img {
  width: 100%;
}
.coverBorder {
  border: 1px solid #f00;
  border-radius: 2px;
}
.cover_image {
  display: inline-block;
  margin: 5px;
  width: 120px;
  height: 120px;
}
.cover_image img {
  width: 120px;
  height: 120px;
}
.swiper-container-horizontal > .swiper-scrollbar {
  height: 0px;
}
.bar_bottom {
  margin: 0 auto;
  text-align: center;
}
.bar_bottom .submit {
  margin: 10px;
}
.video_progress {
  /* background: rgba(9, 210, 116, 0.06); */

  padding: 20px 8px;
  border-radius: 2px;
  margin-bottom: 20px;
}
.doneupload {
  background: RGB(111, 196, 69, 0.06);
}
.doupload {
  background: RGB(89, 166, 204, 0.06);
}

.video_del .del {
  float: right;
}
</style>