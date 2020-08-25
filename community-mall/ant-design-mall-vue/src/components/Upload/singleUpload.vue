<template> 
  <div>
    <el-upload
      :action="actionUrl"
      list-type="picture"
      :multiple="false" :show-file-list="showFileList"
      :file-list="fileList"
      :before-upload="beforeUpload"
      :http-request="httpRequest"
      :on-remove="handleRemove"
      :on-success="handleUploadSuccess"
      :on-preview="handlePreview">
      <el-button size="small" type="primary">点击上传</el-button>
      <div slot="tip" class="el-upload__tip">只能上传jpg/png文件，且不超过10MB</div>
    </el-upload>
    <el-dialog :visible.sync="dialogVisible">
      <img width="100%" :src="fileList[0].url" alt="">
    </el-dialog>
  </div>
</template>
<script>
  import request from '@/utils/request'

  export default {
    name: 'singleUpload',
    props: {
      value: String
    },
    computed: {
      imageUrl() {
        return this.value;
      },
      imageName() {
        if (this.value != null && this.value !== '') {
          return this.value.substr(this.value.lastIndexOf("/") + 1);
        } else {
          return null;
        }
      },
      fileList() {
        return [{
          name: this.imageName,
          url: process.env.IMAGE_SERVER + this.imageUrl,
          halfBakedPath: this.imageUrl
        }]
      },
      showFileList: {
        get: function () {
          return this.value !== null && this.value !== ''&& this.value!==undefined;
        },
        set: function (newValue) {
        }
      }
    },
    data() {
      return {
        dialogVisible: false,
        actionUrl:process.env.SSO_PREFIX+'/sys/common/uploads?action=uploadimage',
      };
    },
    methods: {
      emitInput(val) {
        if(!!val && val.length > 0) {
          this.$emit('input', val[0].halfBakedPath)
        }else{
          this.emitInput('');
        }
      },
      handleRemove(file, fileList) {
        this.emitInput('');
      },
      handlePreview(file) {
        this.dialogVisible = true;
      },
      beforeUpload(file) {
        return true;
      },
      httpRequest(content) {
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
      },
      handleUploadSuccess(resp, file) {
        console.log('handleUploadSuccess', resp, file);
        this.showFileList = true;
        this.fileList.pop();
        this.fileList.push({
          name: file.name,
          url: process.env.IMAGE_SERVER + resp.url,
          halfBakedPath: resp.url
        });
        this.emitInput(this.fileList);
      }
    }
  }
</script>
<style>

</style>


