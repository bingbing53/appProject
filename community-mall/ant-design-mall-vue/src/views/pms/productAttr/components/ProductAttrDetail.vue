<template>
  <el-card class="form-container" shadow="never">
    <el-form :model="productAttr" :rules="rules" ref="productAttrFrom" label-width="150px">
      <el-form-item label="属性名称：" prop="name">
        <el-input v-model="productAttr.name"></el-input>
      </el-form-item>
      <el-form-item label="商品种类：">
        <el-select v-model="productAttr.productAttributeCategoryId" placeholder="请选择">
          <el-option
            v-for="item in productAttrCateList"
            :key="item.id"
            :label="item.name"
            :value="item.id">
          </el-option>
        </el-select>
      </el-form-item>
      <!--
      <el-form-item label="分类筛选样式:">
        <el-radio-group v-model="productAttr.filterType">
          <el-radio :label="0">普通</el-radio>
          <el-radio :label="1">颜色</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="能否进行检索:">
        <el-radio-group v-model="productAttr.searchType">
          <el-radio :label="0">不需要检索</el-radio>
          <el-radio :label="1">关键字检索</el-radio>
          <el-radio :label="2">范围检索</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="商品属性关联:">
        <el-radio-group v-model="productAttr.relatedStatus">
          <el-radio :label="1">是</el-radio>
          <el-radio :label="0">否</el-radio>
        </el-radio-group>
      </el-form-item>
      -->
      <!--
      <el-form-item label="属性是否可选:">
        <el-radio-group v-model="productAttr.selectType">
          <el-radio :label="0">唯一</el-radio>
          <el-radio :label="1">单选</el-radio>
          <el-radio :label="2">复选</el-radio>
        </el-radio-group>
        <p>“属性是否可选”用来控制APP商品页的下单操作，本字段用来说明同一属性是否允许选择多个可选值。不需要修改，保持默认即可。</p>
      </el-form-item>
      -->
      <el-form-item label="属性值的录入方式:">
        <el-radio-group v-model="productAttr.inputType">
          <el-radio :label="0">手工录入</el-radio>
          <el-radio :label="1">从下面列表中选择</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="属性值可选值列表:">
        <el-input :autosize="true" type="textarea" v-model="inputListFormat"></el-input>
        <p>* 每个可选值独占一行！多个可选值之间，使用换行符分隔。例如：</p>
        <p style="line-height: 1px;">S</p>
        <p style="line-height: 1px;">M</p>
        <p style="line-height: 1px;">L</p>
        <p style="line-height: 1px;">XL</p>
        <p style="line-height: 1px;">XXL</p>
        <p>* 每行对应一个可选值。注意删除多余的空行！</p>
        <p>* 当录入方式为“从下面列表中选择”，且“是否支持手动新增”为否时生效！</p>
      </el-form-item>
      <!--<el-form-item label="是否支持手动新增:">-->
        <!--<el-radio-group v-model="productAttr.handAddStatus">-->
          <!--<el-radio :label="1">是</el-radio>-->
          <!--<el-radio :label="0">否</el-radio>-->
        <!--</el-radio-group>-->
        <!--<p>* 如果选“是”，在添加商品时，“属性值可选值列表”失效，必须手动新增可选值！</p>-->
        <!--<p>* 默认选“否”，表明不允许在添加商品时，手动新增可选值，只能从“属性值可选值列表”中勾选！</p>-->
        <!--<p>* 推荐保持默认！仅当确实需要手动新增可选值时，修改为“是”</p>-->
      <!--</el-form-item>-->
      <el-form-item label="排序属性：">
        <el-input v-model="productAttr.sort"></el-input>
        <p>数字大的属性排序在前，系统可为排序在前属性添加商品展示图片，例如衣服的颜色与尺码为是商品的两个属性，如将颜色排在前面，则可以对不同颜色的衣服增加商品图片，便于顾客购买， 而尺码属性则无法增加图片。</p>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit('productAttrFrom')">提交</el-button>
        <el-button  v-if="!isEdit" @click="resetForm('productAttrFrom')">重置</el-button>
        <p>* 点击“提交”按钮即保存成功，无需重复添加同一个属性！（为方便连续新增属性，默认不会自动关闭本页面！）</p>
      </el-form-item>
    </el-form>
  </el-card>
</template>

<script>
  import {fetchList} from '@/api/productAttrCate'
  import {createProductAttr,getProductAttr,updateProductAttr} from '@/api/productAttr'

  const defaultProductAttr = {
    filterType: 0,
    handAddStatus: 0,
    inputList: '',
    inputType: 0,
    name: '',
    productAttributeCategoryId: 0,
    relatedStatus: 0,
    searchType: 0,
    selectType: 0,
    sort: 0,
    type: 0
  };
  export default {
    name: "ProductAttrDetail",
    props: {
      isEdit: {
        type: Boolean,
        default: false
      }
    },
    data() {
      return {
        productAttr: Object.assign({}, defaultProductAttr),
        rules: {
          name: [
            {required: true, message: '请输入属性名称', trigger: 'blur'},
            {min: 2, max: 140, message: '长度在 2 到 140 个字符', trigger: 'blur'}
          ]
        },
        productAttrCateList: null,
        inputListFormat:null
      }
    },
    created() {
      if(this.isEdit){
        getProductAttr(this.$route.query.id).then(response => {
          this.productAttr = response.data;
          this.inputListFormat = this.productAttr.inputList.replace(/,/g,'\n');
        });
      }else{
        this.resetProductAttr();
      }
      this.getCateList();
    },
    watch:{
      inputListFormat: function (newValue, oldValue) {
        newValue = newValue.replace(/\n/g,',');
        this.productAttr.inputList = newValue;
      }
    },
    methods: {
      getCateList() {
        let listQuery = {pageNum: 1, pageSize: 100};
        fetchList(listQuery).then(response => {
          this.productAttrCateList = response.data.list;
        });
      },
      resetProductAttr() {
        this.productAttr = Object.assign({}, defaultProductAttr);
        this.productAttr.productAttributeCategoryId = Number(this.$route.query.cid);
        this.productAttr.type = Number(this.$route.query.type);
      },
      onSubmit(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$confirm('是否提交数据', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }).then(() => {
              if(this.isEdit){
                updateProductAttr(this.$route.query.id,this.productAttr).then(response=>{
                  this.$message({
                    message: '修改成功',
                    type: 'success',
                    duration: 1000
                  });
                  this.$router.back();
                });
              }else{
                createProductAttr(this.productAttr).then(response=>{
                  this.$message({
                    message: '提交成功',
                    type: 'success',
                    duration: 1000
                  });
                  this.resetForm('productAttrFrom');
                });
              }
            });

          } else {
            this.$message({
              message: '验证失败',
              type: 'error',
              duration: 1000
            });
            return false;
          }
        });
      },
      resetForm(formName) {
        this.$refs[formName].resetFields();
        this.resetProductAttr();
      }
    },
  }
</script>

<style scoped>

</style>
