<template>
  <div class="upload-container">
    <el-button icon='el-icon-upload' size="mini" :style="{background:color,borderColor:color}"
               @click=" dialogVisible=true" type="primary">上传图片
    </el-button>
    <el-dialog append-to-body :visible.sync="dialogVisible">
      <el-upload class="editor-slide-upload"
          :action="actionUrl"
          :multiple="true"
          :file-list="fileList"
          :show-file-list="true"
          list-type="picture-card"
          :on-remove="handleRemove"
          :on-success="handleSuccess"
          :before-upload="beforeUpload"
          :http-request="httpRequest">
        <el-button size="small" type="primary">点击上传</el-button>
      </el-upload>
      <el-button @click="dialogVisible = false">取 消</el-button>
      <el-button type="primary" @click="handleSubmit">确 定</el-button>
    </el-dialog>
  </div>
</template>

<script>
  import request from '@/utils/request'

  export default {
    name: 'editorSlideUpload',
    props: {
      color: {
        type: String,
        default: '#1890ff'
      }
    },
    data() {
      return {
        dialogVisible: false,
        actionUrl:process.env.SSO_PREFIX+'/sys/common/uploads?action=uploadimage',
        listObj: {},
        fileList: []
      }
    },
    methods: {
      checkAllSuccess() {
        return Object.keys(this.listObj).every(item => this.listObj[item].hasSuccess)
      },
      handleSubmit() {
        const arr = Object.keys(this.listObj).map(v => this.listObj[v])
        if (!this.checkAllSuccess()) {
          this.$message('请等待所有图片上传成功 或 出现了网络问题，请刷新页面重新上传！')
          return
        }
        console.log(arr);
        this.$emit('successCBK', arr);
        this.listObj = {};
        this.fileList = [];
        this.dialogVisible = false;
      },
      handleSuccess(resp, file) {
        const uid = file.uid;
        const objKeyArr = Object.keys(this.listObj)
        for (let i = 0, len = objKeyArr.length; i < len; i++) {
          if (this.listObj[objKeyArr[i]].uid === uid) {
            this.listObj[objKeyArr[i]].url = resp.fullUrlPrefix + resp.url;
            this.listObj[objKeyArr[i]].hasSuccess = true;
            return
          }
        }
      },
      handleRemove(file) {
        const uid = file.uid;
        const objKeyArr = Object.keys(this.listObj);
        for (let i = 0, len = objKeyArr.length; i < len; i++) {
          if (this.listObj[objKeyArr[i]].uid === uid) {
            delete this.listObj[objKeyArr[i]];
            return
          }
        }
      },
      beforeUpload(file) {
        console.log('beforeUpload', file);
        const fileName = file.uid;
        this.listObj[fileName] = {
          hasSuccess: false,
          uid: file.uid,
          // width: this.width,
          // height: this.height,
        };
        return true;
      },
      httpRequest(content) {
        console.log('httpRequest', content);
        var form = new FormData();
        form.append("upfile", content.file);
        request.post(content.action, form)
        .then(resp => {
          if(resp.code != 200) {
            content.onError('文件上传失败, resp.code=' + resp.code);
          } else {
            content.onSuccess(resp, content.file);
          }
        }).catch(error => {
          content.onError('文件上传失败, error=' + error);
        });
      }
    }
  }
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
  .upload-container .editor-slide-upload{
    margin-bottom: 20px;
  }
</style>
