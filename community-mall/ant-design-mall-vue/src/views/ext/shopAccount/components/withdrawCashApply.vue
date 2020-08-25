<template> 
  <el-card class="form-container" shadow="never">
    <el-form :model="brand" :rules="rules" ref="brandFrom" label-width="150px">
      <el-form-item label="提现金额：" prop="amount">
        <el-input v-model="brand.amount"></el-input>
        <span>可提现金额：{{balance}}</span>
      </el-form-item>
      <el-form-item label="账户类别" prop="accountType">
        <el-radio-group v-model="brand.accountType" size="small" @change="accountTypeChange">
          <el-radio label="0" border>银行卡</el-radio>
          <el-radio label="1" border>支付宝</el-radio>
        </el-radio-group>
      </el-form-item>
      <template v-if="brand.accountType == '0'">
        <el-form-item label="银行卡号：" prop="bankAccount">
          <el-input v-model="brand.bankAccount"></el-input>
        </el-form-item>
        <el-form-item label="开户名：" prop="bankAccountName">
          <el-input v-model="brand.bankAccountName"></el-input>
        </el-form-item>
        <el-form-item label="开户行：" prop="bank">
          <el-input v-model="brand.bank"></el-input>
        </el-form-item>
      </template>
      <template v-if="brand.accountType == '1'">
        <el-form-item label="支付宝账户：" prop="bankAccount">
          <el-input v-model="brand.bankAccount"></el-input>
        </el-form-item>
        <el-form-item label="真实姓名：" prop="bankAccountName">
          <el-input v-model="brand.bankAccountName"></el-input>
        </el-form-item>
        <el-form-item label="手机号：" prop="bank">
          <el-input v-model="brand.bank"></el-input>
        </el-form-item>
      </template>
      <el-form-item>
        <el-button type="primary" @click="onSubmit('brandFrom')">提交</el-button>
        <el-button @click="resetForm('brandFrom')">重置</el-button>
      </el-form-item>
    </el-form>
  </el-card>
</template>
<script>
  import {createApply, shBalance} from '@/api/shopAccount'
  const defaultBrand={
      amount: 0.00,
      bankAccount: '',
      bankAccountName: '',
      bank: '',
      accountType:'0'
  };
  export default {
    name: 'WithdrawCashApply',
    components:{},
    data() {
      return {
        brand:Object.assign({}, defaultBrand),
        rules: {
            amount: [
              {required: true, message: '提现不能为空', trigger: 'blur'}
            ],
            accountType:[
              {required: true, message: '账户类别不能为空', trigger: 'blur'}
            ],
            bankAccount: [
                {required: true, message: '不能为空', trigger: 'blur'}
            ],
            bankAccountName: [
                {required: true, message: '不能为空', trigger: 'blur'}
            ],
            bank: [
                {required: true, message: '不能为空', trigger: 'blur'}
            ],
        },
        balance: 0.00
      }
    },
    created() {
        this.computedBalance();
    },
    methods: {
      accountTypeChange(value){

      },
      computedBalance() {
          shBalance().then(response => {
              this.balance = response.data.balance
          });
      },
      onSubmit(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$confirm('是否提交数据', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }).then(() => {
                createApply(this.brand).then(response => {
                  this.$refs[formName].resetFields();
                  this.brand = Object.assign({},defaultBrand);
                  this.$message({
                    message: '提交成功',
                    type: 'success',
                    duration:1000
                  });
                });
            });

          } else {
            this.$message({
              message: '验证失败',
              type: 'error',
              duration:1000
            });
            return false;
          }
        });
      },
      resetForm(formName) {
        this.$refs[formName].resetFields();
        this.brand = Object.assign({},defaultBrand);
      }
    }
  }
</script>
<style>
</style>


