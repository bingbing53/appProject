<template>
  <el-dialog
    title="修改密码"
    :visible.sync="value"
    :show-close="false"
    width="40%"
    :close-on-click-modal="false"
    :onclose="handleClose">

    <el-form :model="form" label-width="150px" :rules="formRules" ref="form" size="mini">
      <el-form-item label="原密码" prop="oldpassword">
        <el-input type="password" v-model="form.oldpassword" auto-complete="off" placeholder="请输入原密码" maxlength="18"></el-input>
      </el-form-item>
      <el-form-item label="新密码" prop="password">
        <el-input type="password" v-model="form.password" maxlength="18" placeholder="请输入新密码"></el-input>
      </el-form-item>
      <el-form-item label="确认新密码" prop="confirmpassword">
        <el-input type="password" v-model="form.confirmpassword" auto-complete="off" placeholder="请确认新密码" maxlength="18"></el-input>
      </el-form-item>
    </el-form>

    <span slot="footer" class="dialog-footer">
      <el-button @click="handleClose">取 消</el-button>
      <el-button type="primary" @click="handleSubmit">确 定</el-button>
    </span>
  </el-dialog>
</template>

<script>
    import Vue from 'vue'
    import {USER_INFO} from '@/store/mutation-types'
    import { updatePwd,logout } from '@/api/sso_login'
    export default {
      name: "ChangePwd",
      data () {
        const minLength = (rule, value, callback) => {
          if (value.length < 6) {
            callback(new Error('密码最少6位'))
          } else {
            callback()
          }
        }
        const equpwd = (rule,value,callback) => {
          if (this.form.password != '' && this.form.confirmpassword != value) {
            callback(new Error('两次密码不一致'))
          } else {
            callback()
          }
        }
        return {
          userInfo: Vue.ls.get(USER_INFO),
          form: {
            oldpassword:'',
            newpassword:'',
            renewpassword:''
          },
          formRules: {
            oldpassword: [
              {required: true, message: '请输入原密码', trigger: 'blur'},
            ],
            password: [
              {required: true, message: '请输入新密码'},
              {required: true, trigger: 'blur', validator: minLength}
            ],
            confirmpassword: [
              {required: true, message: '请确认新密码'},
              {required: true, trigger: 'blur', validator: minLength},
              {required: true, trigger: 'blur', validator: equpwd}
            ],
          },
        }
      },
      props: {
        value:{
          type: Boolean,
          default:false
        }
      },
      methods: {
        handleSubmit(){
          this.form.username = this.userInfo.username;
          this.$confirm('确认重置密码吗？', '提示', {}).then(() => {
            updatePwd(this.form).then((res) => {
              console.log(res);
              if (res.success) {
                this.$message({
                  message: '密码修改成功，请重新登录',
                  type: 'success',
                  duration:1500
                });
                const self = this;
                logout().then(function() {
                  var sevice = "https://" + window.location.host;
                  var serviceUrl = encodeURIComponent(sevice);
                  window.location.href = process.env.CAS_PREFIXURL + "/cas/logout?service=" + serviceUrl;
                });
                this.value = false;
                this.$emit('ok',this.value);
              } else{
                this.$message({
                  message: res.message,
                  type: 'error',
                  duration:1500
                });
              }
            }).catch((err) => {

            })
          });
        },
        handleClose(){
          this.value = false;
          this.$emit('ok',this.value);
        }
      },
    }
</script>

<style scoped>

</style>
