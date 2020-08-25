<template>
  <div style="margin-top: 50px">
    <el-form :model="value" :rules="rules" ref="productInfoForm" label-width="120px" style="width: 600px" size="small">
      <el-form-item label="商品货架" prop="productCategoryCode">
        <el-cascader
          v-model="selectProductCateValue"
          :options="productCateOptions">
        </el-cascader>
      </el-form-item>
      <el-form-item label="商品名称" prop="name">
        <el-input v-model="value.name"></el-input>
      </el-form-item>
      <el-form-item label="简要说明" prop="subTitle">
        <el-input v-model="value.subTitle"></el-input>
      </el-form-item>
      <el-form-item label="商品品牌" prop="brandId">
        <el-select
          v-model="value.brandId"
          @change="handleBrandChange"
          placeholder="请选择品牌">
          <el-option
            v-for="item in brandOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="商品介绍">
        <el-input
          :autoSize="true"
          v-model="value.description"
          type="textarea"
          placeholder="请输入内容"></el-input>
      </el-form-item>
      <el-form-item label="商品货号">
        <el-input v-model="value.productSn"></el-input>
      </el-form-item>
      <el-form-item prop="price">
        <div slot="label"><span style="color: #f56c6c;margin-right: 4px;" slot="prop">*</span>商品售价
          <el-tooltip placement="top">
            <div slot="content">
              <p>“商品售价”是商品首页展示的商品价格，是首页展示的参考价，非真实价格。商品的真实价格因规格的不同而有所不同，sku价格为商品的真实价格！</p>
              <p>本价格不得低于sku最低价格，不得高于sku最高价格！对于虚标首页价格，误导消费者的商家，平台会定期核查，一经发现给予处罚。</p>
            </div>
            <i class="el-icon-info"></i>
          </el-tooltip>
        </div>
        <el-input v-model="value.price"></el-input>
      </el-form-item>
      <el-form-item>
        <div slot="label">可使用的公益币数量（个）
          <el-tooltip placement="top">
            <div slot="content">
              <p>“可使用的公益币数量”，同样用于首页展示，是首页展示的参考可使用的公益币数量，非真实的可使用的公益币数量。公益币是本平台的特色。本平台的商品有两种价格，普通价和公益价，公益价是使用公益币抵扣后的价格，公益币抵扣比率由平台统一设置。</p>
              <p>不得低于sku最少可使用的公益币数量，不得高于sku最多可使用的公益币数量！对于虚标首页可使用的公益币数量，误导消费者的商家，平台会定期核查，一经发现给予处罚。</p>
            </div>
            <i class="el-icon-info"></i>
          </el-tooltip>
        </div>
        <el-input-number v-model="value.coin" min="0"></el-input-number>
      </el-form-item>
      <!--<el-form-item>-->
        <!--<div slot="label">市场价（元）-->
          <!--<el-tooltip placement="top">-->
            <!--<div slot="content">-->
              <!--<p>“市场价”是市场参考价，用于商品首页展示的划线价（如无展示空间，则不展示）。一般低于“商品售价”和sku真实价，多用来向消费者传达物美价廉的商品优势。</p>-->
            <!--</div>-->
            <!--<i class="el-icon-info"></i>-->
          <!--</el-tooltip>-->
        <!--</div>-->
        <!--<el-input v-model="value.originalPrice"></el-input>-->
      <!--</el-form-item>-->
      <el-form-item>
        <div slot="label">商品库存
          <el-tooltip placement="top">
            <div slot="content">
              <p>“商品库存”，同样用于首页展示，非真实库存。sku库存为真实库存！</p>
            </div>
            <i class="el-icon-info"></i>
          </el-tooltip>
        </div>
        <el-input v-model="value.stock"></el-input>
      </el-form-item>
      <el-form-item label="计量单位">
        <el-input v-model="value.unit" placeholder="例如：个，件，箱"></el-input>
      </el-form-item>
      <el-form-item label="商品重量">
        <el-input v-model="value.weight" style="width: 300px"></el-input>
        <span style="margin-left: 20px">克</span>
      </el-form-item>
      <!--<el-form-item label="排序">-->
        <!--<el-input v-model="value.sort"></el-input>-->
      <!--</el-form-item>-->
      <el-form-item>
        <div slot="label">最低订购数量
          <el-tooltip placement="top">
            <div slot="content">
              <p>“最低订购数量”用来设置商品的最低订购数量（比如最低几小时起订、最低擦玻璃几平米起订）。默认为不限制。</p>
            </div>
            <i class="el-icon-info"></i>
          </el-tooltip>
        </div>
        <el-input v-model="value.minBuyQuantity"></el-input>
      </el-form-item>
      <el-form-item style="text-align: center">
        <el-button type="primary" size="medium" @click="handleNext('productInfoForm')">下一步，填写商品上架信息</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
  import {fetchListWithChildren} from '@/api/productCate'
  import {getOrderSetting} from '@/api/orderSetting'
  import {fetchList as fetchBrandList} from '@/api/brand'
  import {getProduct} from '@/api/product';

  export default {
    name: "ProductInfoDetail",
    props: {
      value: Object,
      isEdit: {
        type: Boolean,
        default: false
      }
    },
    data() {
      return {
        hasEditCreated:false,
        //选中商品货架的值
        selectProductCateValue: [],
        productCateOptions: [],
        brandOptions: [],
        orderSetting:{},
        rules: {
          name: [
            {required: true, message: '请输入商品名称', trigger: 'blur'},
            {min: 2, max: 140, message: '长度在 2 到 140 个字符', trigger: 'blur'}
          ],
          subTitle: [{required: true, message: '请输入商品副标题', trigger: 'blur'}],
          productCategoryCode: [{required: true, message: '请选择商品货架', trigger: 'blur'}],
          // brandId: [{required: true, message: '请选择商品品牌', trigger: 'blur'}],
          description: [{required: true, message: '请输入商品介绍', trigger: 'blur'}],
          requiredProp: [{required: true, message: '该项为必填项', trigger: 'blur'}],
          price: [{
            validator: (rule, value, callback) => {
              if(!!value) value = value.toString();
              if(!value || value.length <= 0){
                callback(new Error('金额不能为空'))
              }else if(value.split('.').length > 2){
                callback(new Error('输入正确格式的金额')) //防止输入多个小数点
              }else if(value == 0 || value == 0.0 || value == 0.00){
                callback(new Error('金额不能为0'))
              }else{
                value = Math.round(value * Math.pow(10,2)) / Math.pow(10,2) //四舍五入
                value = Number(value).toFixed(2); //不足补位
                if(value == 0 || value == 0.0 || value == 0.00)
                  value = 0.01;
                this.value.price = value;
                callback();
              }
            },
            trigger: 'blur'
          }]
        }
      };
    },
    created() {
      this.getProductCateList();
      this.getBrandList();
      this.queryCoinMoney();
    },
    computed:{
      //商品的编号
      productId(){
        return this.value.id;
      }
    },
    watch: {
      productId:function(newValue){
        if(!this.isEdit)return;
        if(this.hasEditCreated)return;
        if(newValue===undefined||newValue==null||newValue===0)return;
        this.handleEditCreated();
      },
      selectProductCateValue: function (newValue) {
        console.log('selectProductCateValue', newValue);
        if (newValue && newValue.length != 0) {
          this.value.productCategoryCode = newValue[newValue.length - 1];
          this.value.productCategoryName= this.getCateNameByCode(this.value.productCategoryCode);
        } else {
          this.value.productCategoryCode = null;
          this.value.productCategoryName = null;
        }
      }
    },
    methods: {
      queryCoinMoney(){
        getOrderSetting().then(response=>{
          this.orderSetting=response.data;
        })
      },
      //处理编辑逻辑
      async handleEditCreated(){
        if(this.value.productCategoryCode!=null){
          let codes = await this.getCascaderProductCateOptionsByCode(this.value.productCategoryCode);
          console.log('handleEditCreated', codes);
          this.selectProductCateValue.push(...codes);
        }
        this.hasEditCreated=true;
      },
      async getProductCateList() {
        let productCateOptions = await this.queryProductCateList(0);
        console.log('getProductCateList', productCateOptions);
        this.productCateOptions = productCateOptions;
      },
      async queryProductCateList(parentId) {
        const self = this;
        const response = await fetchListWithChildren({parentId: parentId});
        let list = response.data;
        let result = [];
        for (let i = 0; i < list.length; i++) {
          let children = [];
          if (list[i].children != null && list[i].children.length > 0) {
            for (let j = 0; j < list[i].children.length; j++) {
              let grandson = await self.queryProductCateList(list[i].children[j].id);
              if (grandson.length == 0) {
                children.push({label: list[i].children[j].name, value: list[i].children[j].code});
              } else {
                children.push({label: list[i].children[j].name, value: list[i].children[j].code, children: grandson});
              }
            }
          }
          if (children.length == 0) {
            result.push({label: list[i].name, value: list[i].code});
          } else {
            result.push({label: list[i].name, value: list[i].code, children: children});
          }
        }
        return result;
      },
      getBrandList() {
        fetchBrandList({pageNum: 1, pageSize: 100}).then(response => {
          this.brandOptions = [];
          let brandList = response.data.list;
          for (let i = 0; i < brandList.length; i++) {
            this.brandOptions.push({label: brandList[i].name, value: brandList[i].id});
          }
        });
      },
      getCateNameByCode(code){
        let name = this.queryCateNameByCode(code, this.productCateOptions);
        console.log('getCateNameByCode', code, name);
        return name;
      },
      queryCateNameByCode(code, cascaderOptions){
        for (let i = 0; i < cascaderOptions.length; i++) {
          let cur = cascaderOptions[i];
          if (cur.value === code) {
            return cur.label;
          }

          if (cur.children) {
            let name = this.queryCateNameByCode(code, cur.children);
            if (name) {
              return name;
            }
          }
        }
      },
      async getCascaderProductCateOptionsByCode(code){
        let productCateOptions = await this.queryProductCateList(0);
        console.log('getCascaderProductCateOptionsByCode', productCateOptions);
        this.productCateOptions = productCateOptions;
        let codes = this.queryCascaderProductCateOptionsByCode(code, this.productCateOptions);
        console.log('getCascaderProductCateOptionsByCode', code, codes);
        return codes;
      },
      queryCascaderProductCateOptionsByCode(code, cascaderOptions){
        let codes = [];
        for (let i = 0; i < cascaderOptions.length; i++) {
          let cur = cascaderOptions[i];
          if (cur.value === code) {
            codes.push(cur.value);
            return codes;
          }

          if (cur.children) {
            let childrenCodes = this.queryCascaderProductCateOptionsByCode(code, cur.children);
            if (childrenCodes.length != 0) {
              codes.push(cur.value);
              codes.push(...childrenCodes);
              return codes;
            }
          }
        }
        return codes;
      },
      handleNext(formName){
        this.$refs[formName].validate((valid) => {
          if (valid) {
            //检测公益币和售价设置
            if(!!this.value.coin && this.value.coin > 0){
              let coinMoney = this.orderSetting.coinMoney * this.value.coin;
              if(coinMoney >= this.value.price){
                this.$alert('可使用公益币数量的价格超过商品售价，请修改！', '提示', {
                  confirmButtonText: '确定',
                  type: 'warning'
                });
                return;
              }
            }

            this.$emit('nextStep');
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
      handleBrandChange(val) {
        let brandName = '';
        for (let i = 0; i < this.brandOptions.length; i++) {
          if (this.brandOptions[i].value === val) {
            brandName = this.brandOptions[i].label;
            break;
          }
        }
        this.value.brandName = brandName;
      }
    }
  }
</script>

<style scoped>
</style>
