<template> 
  <div>
    <el-upload
      :action="actionUrl"
      accept=".png,.jpg,.jpeg,.bmp"
      list-type="picture-card"
      :file-list="fileList"
      :before-upload="beforeUpload"
      :http-request="httpRequest"
      :on-remove="handleRemove"
      :on-success="handleUploadSuccess"
      :on-preview="handlePreview"
      :limit="maxCount"
      :on-exceed="handleExceed"
    >
      <i class="el-icon-plus"></i>
    </el-upload>
    <el-dialog :visible.sync="dialogVisible">
      <img width="100%" :src="dialogImageUrl" alt="原图">
    </el-dialog>
  </div>
</template>
<script>
  import request from '@/utils/request'

  export default {
    name: 'multiUpload',
    props: {
      //图片属性数组
      value: Array,
      //最大上传图片数量
      maxCount: {
        type: Number,
        default: 5
      }
    },
    data() {
      return {
        dialogVisible: false,
        dialogImageUrl: null,
        actionUrl:process.env.SSO_PREFIX+'/sys/common/uploads?action=uploadimage',
      };
    },
    computed: {
      fileList() {
        let fileList = [];
        for(let i=0; i<this.value.length; i++){
          fileList.push({
            url: process.env.IMAGE_SERVER + this.value[i],
            halfBakedPath: this.value[i]
          });
        }
        return fileList;
      }
    },
    methods: {
      emitInput(fileList) {
        let value = [];
        for(let i=0; i<fileList.length; i++){
          value.push(fileList[i].halfBakedPath);
        }
        this.$emit('input', value)
      },
      handleRemove(file, fileList) {
        this.emitInput(fileList);
      },
      handlePreview(file) {
        console.log('handlePreview', file);
        this.dialogVisible = true;
        this.dialogImageUrl = file.url;
      },
      beforeUpload(file) {
        console.log('beforeUpload', file);
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
      },
      handleUploadSuccess(resp, file) {
        console.log('handleUploadSuccess', resp, file);
        this.fileList.push({
          url: resp.fullUrlPrefix + resp.url,
          halfBakedPath: resp.url
        });
        this.emitInput(this.fileList);
      },
      handleExceed(files, fileList) {
        this.$message({
          message: '最多只能上传'+this.maxCount+'张图片',
          type: 'warning',
          duration: 1000
        });
      },
    }
  }
</script>
<style>

</style>


