<template>
  <div style="margin-top: 50px">
    <el-form :model="value" ref="productAttrForm" label-width="120px" style="width: 720px" size="small">
      <el-form-item>
        <div slot="label">
          <span style="color: #f56c6c;margin-right: 4px;">*</span>商品种类
          <el-tooltip placement="top">
            <div slot="content">
              <p>请先选择“商品种类”！预约类商品可选择“分时段预约上门服务（小时）”，或“分时段预约上门服务（半小时）”。这2个均为系统内置的商品种类，如不满足需求，可仿造这2个新增自己的商品种类。由于实体商品的品类繁多，各商家的商品种类不尽相同，所以系统无内置的实体商品的商品种类，可按需求添加自己的商品种类（例如：男装、女装、上衣、裤子、鞋子等）。点击左侧导航栏的“商品”->“商品种类”即可跳转到新增页面。</p>
            </div>
            <i class="el-icon-info"></i>
          </el-tooltip>
        </div>
        <el-select v-model="value.productAttributeCategoryId"
                   placeholder="请选择商品种类"
                   @change="handleProductAttrChange">
          <el-option
            v-for="item in productAttributeCategoryOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <div slot="label">
          <span style="color: #f56c6c;margin-right: 4px;">*</span>商品规格
          <el-tooltip placement="top">
            <div slot="content">
              <p>选择“商品种类”后，“商品规格”自动带出！如系统内置的商品规则不符合要求，可新增自己的商品种类！</p>
              <p>点击“刷新列表”按钮即可重新生成sku列表。注意点击前，先勾选商品规格！每种商品规格至少勾选一项，否则无法生成sku列表！（例如：选择“分时段预约上门服务”后，自动带出“日期”、和“上门时间”这两种规格，首先增加日期（8位的日期，包含4位年份+2位月份+2位日子）选项，如20200224、20200225、20200226、20200227，然后勾选日期、和上门时间，最后点击刷新列表即可生成sku列表。）</p>
              <p>sku列表里的“销售价格”为sku真实价格，“商品库存”为sku真实库存，这2个均为必填！“可使用的公益币数量”如不填写，或填写为0，表示不允许使用公益币！</p>
            </div>
            <i class="el-icon-info"></i>
          </el-tooltip>
        </div>
        <el-card shadow="never" class="cardBg">
          <div v-for="(productAttr,idx) in selectProductAttr">
            {{productAttr.name}}：
            <el-checkbox-group v-if="productAttr.handAddStatus===0" v-model="selectProductAttr[idx].values">
              <el-checkbox v-for="item in getInputListArr(productAttr.inputList)" :label="item" :key="item"
                           class="littleMarginLeft"></el-checkbox>
            </el-checkbox-group>
            <div v-else>
              <el-checkbox-group v-model="selectProductAttr[idx].values">
                <div v-for="(item,index) in selectProductAttr[idx].options" style="display: inline-block"
                     class="littleMarginLeft">
                  <el-checkbox :label="item" :key="item"></el-checkbox>
                  <el-button type="text" class="littleMarginLeft" @click="handleRemoveProductAttrValue(idx,index)">删除
                  </el-button>
                </div>
              </el-checkbox-group>
              <el-input v-model="addProductAttrValue[idx]" style="width: 160px;margin-left: 10px" clearable></el-input>
              <el-button class="littleMarginLeft" @click="handleAddProductAttrValue(idx)">增加</el-button>
            </div>
          </div>
        </el-card>
        <el-table style="width: 100%;margin-top: 20px"
                  :data="value.skuStockList"
                  border>
          <el-table-column
            v-for="(item,index) in selectProductAttr"
            :label="item.name"
            :key="item.id"
            align="center">
            <template slot-scope="scope">
              {{getProductSkuSp(scope.row,index)}}
            </template>
          </el-table-column>
          <el-table-column label="* 销售价格（必填）" align="center">
            <template slot-scope="scope">
              <el-input v-model="scope.row.price"></el-input>
            </template>
          </el-table-column>
          <el-table-column
            label="可使用的公益币数量"
            align="center">
            <template slot-scope="scope">
              <el-input v-model="scope.row.coin"></el-input>
            </template>
          </el-table-column>
          <el-table-column
            label="* 商品库存（必填）"
            align="center">
            <template slot-scope="scope">
              <el-input v-model="scope.row.stock"></el-input>
            </template>
          </el-table-column>
          <!--
          <el-table-column
            label="库存预警值"
            width="80"
            align="center">
            <template slot-scope="scope">
              <el-input v-model="scope.row.lowStock"></el-input>
            </template>
          </el-table-column>
          -->
          <!--<el-table-column-->
            <!--label="SKU编号（自动生成，不需要填写）"-->
            <!--align="center">-->
            <!--<template slot-scope="scope">-->
              <!--<el-input v-model="scope.row.skuCode"></el-input>-->
            <!--</template>-->
          <!--</el-table-column>-->
          <el-table-column
            label="操作"
            align="center">
            <template slot-scope="scope">
              <el-button
                type="text"
                @click="handleRemoveProductSku(scope.$index, scope.row)">删除
              </el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-button
          type="primary"
          style="margin-top: 20px"
          @click="handleRefreshProductSkuList">刷新列表
        </el-button>
        <!--
        <el-button
          type="primary"
          style="margin-top: 20px"
          @click="handleSyncProductSkuPrice">同步价格
        </el-button>
        -->
      </el-form-item>

      <el-form-item v-if="productCategory">
        <div slot="label">
          <span style="color: #f56c6c;margin-right: 4px;">*</span>服务时间
          <el-tooltip placement="top">
            <div slot="content">
              <p>服务类商品，请选择可预约服务时间！</p>
            </div>
            <i class="el-icon-info"></i>
          </el-tooltip>
        </div>
        <el-card shadow="never" class="cardBg">
        <div>
          <el-checkbox-group v-model="selectOrderTime">
            <el-checkbox v-for="(item,index) in times" :label="index" :key="index" class="littleMarginLeft">{{item}}</el-checkbox>
          </el-checkbox-group>
          <!--<div v-else>-->
            <!--<el-checkbox-group v-model="selectProductAttr[idx].values">-->
              <!--<div v-for="(item,index) in selectProductAttr[idx].options" style="display: inline-block"-->
                   <!--class="littleMarginLeft">-->
                <!--<el-checkbox :label="item" :key="item"></el-checkbox>-->
                <!--<el-button type="text" class="littleMarginLeft" @click="handleRemoveProductAttrValue(idx,index)">删除-->
                <!--</el-button>-->
              <!--</div>-->
            <!--</el-checkbox-group>-->
          <!--</div>-->
        </div>
      </el-card>
      </el-form-item>

      <el-form-item label="属性图片：" v-if="hasAttrPic">
        <el-card shadow="never" class="cardBg">
          <div v-for="(item,index) in selectProductAttrPics">
            <span>{{item.name}}:</span>
            <single-upload v-model="item.pic"
                           style="width: 300px;display: inline-block;margin-left: 10px"></single-upload>
          </div>
        </el-card>
      </el-form-item>
      <!--<el-form-item label="商品参数：">-->
        <!--<el-card shadow="never" class="cardBg">-->
          <!--<div v-for="(item,index) in selectProductParam" :class="{littleMarginTop:index!==0}">-->
            <!--<div class="paramInputLabel">{{item.name}}:</div>-->
            <!--<el-select v-if="item.inputType===1" class="paramInput" v-model="selectProductParam[index].value">-->
              <!--<el-option-->
                <!--v-for="item in getParamInputList(item.inputList)"-->
                <!--:key="item"-->
                <!--:label="item"-->
                <!--:value="item">-->
              <!--</el-option>-->
            <!--</el-select>-->
            <!--<el-input v-else class="paramInput" v-model="selectProductParam[index].value"></el-input>-->
          <!--</div>-->
        <!--</el-card>-->
      <!--</el-form-item>-->

      <el-form-item>
        <div slot="label">
          <span style="color: #f56c6c;margin-right: 4px;">*</span>商品相册
          <el-tooltip placement="top">
            <div slot="content">
              <p>第一张图是商品主图，后四张图片为辅图，最多上传五张图片</p>
            </div>
            <i class="el-icon-info"></i>
          </el-tooltip>
        </div>
        <multi-upload v-model="selectProductPics" max-count="5"></multi-upload>
      </el-form-item>
      <el-form-item label="富文本详情页：">
        <el-tabs v-model="activeHtmlName" type="card">
          <!--
          <el-tab-pane label="电脑端详情" name="pc">
            <tinymce :width="595" :height="300" v-model="value.detailHtml"></tinymce>
          </el-tab-pane>
          -->
          <el-tab-pane label="移动端详情" name="mobile">
            <tinymce :width="595" :height="300" v-model="value.detailMobileHtml"></tinymce>
          </el-tab-pane>
        </el-tabs>
      </el-form-item>
      <el-form-item style="text-align: center">
        <el-button size="medium" @click="handlePrev">上一步，填写商品上架信息</el-button>
         <!--<el-button type="primary" size="medium" @click="handleNext">下一步，选择商品关联</el-button>-->
        <el-button type="primary" size="medium" @click="handleFinishCommit">完成，提交商品</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
  import {fetchList as fetchProductAttrCateList} from '@/api/productAttrCate'
  import {fetchList as fetchProductAttrList} from '@/api/productAttr'
  import SingleUpload from '@/components/Upload/singleUpload'
  import MultiUpload from '@/components/Upload/multiUpload'
  import Tinymce from '@/components/Tinymce'

  export default {
    name: "ProductAttrDetail",
    components: {SingleUpload, MultiUpload, Tinymce},
    props: {
      value: Object,
      isEdit: {
        type: Boolean,
        default: false
      }
    },
    data() {
      return {
        //编辑模式时是否初始化成功
        hasEditCreated:false,
        //商品属性分类下拉选项
        productAttributeCategoryOptions: [],
        //选中的商品属性
        selectProductAttr: [],
        //选中的商品参数
        selectProductParam: [],
        //选中的商品属性图片
        selectProductAttrPics: [],
        //选中的商品可预约时间
        selectOrderTime:[],
        //可手动添加的商品属性
        addProductAttrValue: [],
        //商品富文本详情激活类型
        activeHtmlName: 'mobile',
        rules: {
          productAttributeCategoryId : [{required: true, message: '请选择商品种类', trigger: 'blur'}],
          "value.skuStockList": [{required: true, message: 'sku列表不允许为空', trigger: 'blur'}],
          selectProductPics: [{required: true, message: '请上传图片到商品相册', trigger: 'blur'}]
        },
        times:[]
      }
    },
    computed: {
      //商品货架类别
      productCategory(){
        let productCategoryCode = this.value.productCategoryCode
        if(productCategoryCode.indexOf('G01') == 0){
          return true;
        }
        return false;
      },
      //是否有商品属性图片
      hasAttrPic() {
        if (this.selectProductAttrPics.length < 1) {
          return false;
        }
        return true;
      },
      //商品的编号
      productId(){
        return this.value.id;
      },
      //商品的主图和画册图片
      selectProductPics:{
        get:function () {
          let pics=[];
          if(this.value.pic===undefined||this.value.pic==null||this.value.pic===''){
            return pics;
          }
          pics.push(this.value.pic);
          if(this.value.albumPics===undefined||this.value.albumPics==null||this.value.albumPics===''){
            return pics;
          }
          let albumPics = this.value.albumPics.split(',');
          for(let i=0;i<albumPics.length;i++){
            pics.push(albumPics[i]);
          }
          return pics;
        },
        set:function (newValue) {
          if (newValue == null || newValue.length === 0) {
            this.value.pic = null;
            this.value.albumPics = null;
          } else {
            this.value.pic = newValue[0];
            this.value.albumPics = '';
            if (newValue.length > 1) {
              for (let i = 1; i < newValue.length; i++) {
                this.value.albumPics += newValue[i];
                if (i !== newValue.length - 1) {
                  this.value.albumPics += ',';
                }
              }
            }
          }
        }
      }
    },
    created() {
      this.getProductAttrCateList();
      let timeStr = "00:00,00:30,01:00,01:30,02:00,02:30,03:00,03:30,04:00,04:30,05:00,05:30,06:00,06:30,07:00,07:30,08:00,08:30,09:00,09:30,10:00,10:30,11:00,11:30,12:00,12:30,13:00,13:30,14:00,14:30,15:00,15:30,16:00,16:30,17:00,17:30,18:00,18:30,19:00,19:30,20:00,20:30,21:00,21:30,22:00,22:30,23:00,23:30";
      this.times = timeStr.split(',');
    },
    watch: {
      productId:function (newValue) {
        if(!this.isEdit)return;
        if(this.hasEditCreated)return;
        if(newValue===undefined||newValue==null||newValue===0)return;
        this.handleEditCreated();
      }
    },
    methods: {
      handleEditCreated() {
        //根据商品属性分类id获取属性和参数
        if(this.value.productAttributeCategoryId!=null){
          console.log('handleEditCreated, call handleProductAttrChange', this.value.productAttributeCategoryId);
          this.handleProductAttrChange(this.value.productAttributeCategoryId);
        }
        this.hasEditCreated=true;
        this.selectOrderTime = [];
        if(!!this.value.productAttributeValueList && this.value.productAttributeValueList.length > 0) {
          for(let i = 0;i<this.value.productAttributeValueList.length;i++){
            if(this.value.productAttributeValueList[i].productAttributeId == 1){
              this.selectOrderTime.push(Number(this.value.productAttributeValueList[i].value));
            }
          }
          console.log(this.selectOrderTime);
        }
      },
      getProductAttrCateList() {
        let param = {pageNum: 1, pageSize: 100};
        fetchProductAttrCateList(param).then(response => {
          this.productAttributeCategoryOptions = [];
          let list = response.data.list;
          for (let i = 0; i < list.length; i++) {
            this.productAttributeCategoryOptions.push({label: list[i].name, value: list[i].id});
          }
        });
      },
      getProductAttrList(type, cid) {
        console.log('before getProductAttrList', this.selectProductAttr);
        let param = {pageNum: 1, pageSize: 100, type: type};
        fetchProductAttrList(cid, param).then(response => {
          console.log('fetchProductAttrList', response);
          let list = response.data.list;
          if (type === 0) {
            this.selectProductAttr = [];
            console.log('getProductAttrList, type === 0', this.selectProductAttr);
            for (let i = 0; i < list.length; i++) {
              let options = [];
              let values = [];
              if (this.isEdit) {
                if (list[i].handAddStatus === 1) {
                  //编辑状态下获取手动添加编辑属性
                  options = this.getEditAttrOptions(list[i].id);
                }
                //编辑状态下获取选中属性
                values = this.getEditAttrValues(i);
                console.log('getProductAttrList, type === 0, isEdit', options, values);
              }
              this.selectProductAttr.push({
                id: list[i].id,
                name: list[i].name,
                handAddStatus: list[i].handAddStatus,
                inputList: list[i].inputList,
                values: values,
                options: options
              });
            }
            if(this.isEdit){
              //编辑模式下刷新商品属性图片
              this.refreshProductAttrPics();
            }
          } else {
            this.selectProductParam = [];
            console.log('getProductAttrList, !(type === 0)', this.selectProductAttr);
            for (let i = 0; i < list.length; i++) {
              let value=null;
              if(this.isEdit){
                //编辑模式下获取参数属性
                value= this.getEditParamValue(list[i].id);
                console.log('getProductAttrList, !(type === 0), isEdit', options, values);
              }
              this.selectProductParam.push({
                id: list[i].id,
                name: list[i].name,
                value: value,
                inputType: list[i].inputType,
                inputList: list[i].inputList
              });
            }
          }
        });
        console.log('after getProductAttrList', this.selectProductAttr);
      },
      //获取设置的可手动添加属性值
      getEditAttrOptions(id) {
        let options = [];
        for (let i = 0; i < this.value.productAttributeValueList.length; i++) {
          let attrValue = this.value.productAttributeValueList[i];
          if (attrValue.productAttributeId === id) {
            let strArr = attrValue.value.split(',');
            for (let j = 0; j < strArr.length; j++) {
              options.push(strArr[j]);
            }
            break;
          }
        }
        return options;
      },
      //获取选中的属性值
      getEditAttrValues(index) {
        let values = [];
        if (index === 0) {
          for (let i = 0; i < this.value.skuStockList.length; i++) {
            let sku = this.value.skuStockList[i];
            if (sku.sp1 != null && values.indexOf(sku.sp1) === -1) {
              values.push(sku.sp1);
            }
          }
        } else if (index === 1) {
          for (let i = 0; i < this.value.skuStockList.length; i++) {
            let sku = this.value.skuStockList[i];
            if (sku.sp2 != null && values.indexOf(sku.sp2) === -1) {
              values.push(sku.sp2);
            }
          }
        } else {
          for (let i = 0; i < this.value.skuStockList.length; i++) {
            let sku = this.value.skuStockList[i];
            if (sku.sp3 != null && values.indexOf(sku.sp3) === -1) {
              values.push(sku.sp3);
            }
          }
        }
        return values;
      },
      //获取属性的值
      getEditParamValue(id){
        for(let i=0;i<this.value.productAttributeValueList.length;i++){
          if(id===this.value.productAttributeValueList[i].productAttributeId){
            return this.value.productAttributeValueList[i].value;
          }
        }
      },
      handleProductAttrChange(value) {
        console.log('handleProductAttrChange', value);
        this.getProductAttrList(0, value);
        // this.getProductAttrList(1, value);
      },
      getInputListArr(inputList) {
        return inputList.split(',');
      },
      handleAddProductAttrValue(idx) {
        let options = this.selectProductAttr[idx].options;
        if (this.addProductAttrValue[idx] == null || this.addProductAttrValue[idx] == '') {
          this.$message({
            message: '属性值不能为空',
            type: 'warning',
            duration: 1000
          });
          return
        }
        if (options.indexOf(this.addProductAttrValue[idx]) !== -1) {
          this.$message({
            message: '属性值不能重复',
            type: 'warning',
            duration: 1000
          });
          return;
        }
        this.selectProductAttr[idx].options.push(this.addProductAttrValue[idx]);
        this.addProductAttrValue[idx] = null;
      },
      handleRemoveProductAttrValue(idx, index) {
        this.selectProductAttr[idx].options.splice(index, 1);
      },
      getProductSkuSp(row, index) {
        if (index === 0) {
          return row.sp1;
        } else if (index === 1) {
          return row.sp2;
        } else {
          return row.sp3;
        }
      },
      handleRefreshProductSkuList() {
        this.$confirm('刷新列表将导致sku信息重新生成，是否要刷新', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.refreshProductAttrPics();
          this.refreshProductSkuList();
        });
      },
      handleSyncProductSkuPrice(){
        this.$confirm('将同步第一个sku的价格到所有sku,是否继续', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          if(this.value.skuStockList!==null&&this.value.skuStockList.length>0){
            let price=this.value.skuStockList[0].price;
            for(let i=0;i<this.value.skuStockList.length;i++){
              this.value.skuStockList[i].price=price;
            }
          }
        });
      },
      refreshProductSkuList() {
        this.value.skuStockList = [];
        let skuList = this.value.skuStockList;
        //只有一个属性时
        if (this.selectProductAttr.length === 1) {
          let values = this.selectProductAttr[0].values;
          for (let i = 0; i < values.length; i++) {
            skuList.push({
              sp1: values[i]
            });
          }
        } else if (this.selectProductAttr.length === 2) {
          let values0 = this.selectProductAttr[0].values;
          let values1 = this.selectProductAttr[1].values;
          for (let i = 0; i < values0.length; i++) {
            if (values1.length === 0) {
              skuList.push({
                sp1: values0[i]
              });
              continue;
            }
            for (let j = 0; j < values1.length; j++) {
              skuList.push({
                sp1: values0[i],
                sp2: values1[j]
              });
            }
          }
        } else {
          let values0 = this.selectProductAttr[0].values;
          let values1 = this.selectProductAttr[1].values;
          let values2 = this.selectProductAttr[2].values;
          for (let i = 0; i < values0.length; i++) {
            if (values1.length === 0) {
              skuList.push({
                sp1: values0[i]
              });
              continue;
            }
            for (let j = 0; j < values1.length; j++) {
              if (values2.length === 0) {
                skuList.push({
                  sp1: values0[i],
                  sp2: values1[j]
                });
                continue;
              }
              for (let k = 0; k < values2.length; k++) {
                skuList.push({
                  sp1: values0[i],
                  sp2: values1[j],
                  sp3: values2[k]
                });
              }
            }
          }
        }
      },
      refreshProductAttrPics() {
        this.selectProductAttrPics = [];
        if (this.selectProductAttr.length >= 1) {
          let values = this.selectProductAttr[0].values;
          for (let i = 0; i < values.length; i++) {
            let pic=null;
            if(this.isEdit){
              //编辑状态下获取图片
              pic=this.getProductSkuPic(values[i]);
            }
            this.selectProductAttrPics.push({name: values[i], pic: pic})
          }
        }
      },
      //获取商品相关属性的图片
      getProductSkuPic(name){
        for(let i=0;i<this.value.skuStockList.length;i++){
          if(name===this.value.skuStockList[i].sp1){
            return this.value.skuStockList[i].pic;
          }
        }
        return null;
      },
      //合并商品属性
      mergeProductAttrValue() {
        this.value.productAttributeValueList = [];
        for (let i = 0; i < this.selectProductAttr.length; i++) {
          let attr = this.selectProductAttr[i];
          if (attr.handAddStatus === 1 && attr.options != null && attr.options.length > 0) {
            this.value.productAttributeValueList.push({
              productAttributeId: attr.id,
              value: this.getOptionStr(attr.options)
            });
          }
        }
        for (let i = 0; i < this.selectProductParam.length; i++) {
          let param = this.selectProductParam[i];
          this.value.productAttributeValueList.push({
            productAttributeId: param.id,
            value: param.value
          });
        }

        //可预约时间
        if(this.selectOrderTime.length > 0){
          this.selectOrderTime.sort(function(a,b){
            return a - b;
          })
          console.log(this.selectOrderTime);
          for(var i = 0;i<this.selectOrderTime.length;i++){
            this.value.productAttributeValueList.push({
              productAttributeId: '1',
              value: this.selectOrderTime[i]
            });
          }
        }
      },
      //合并商品属性图片
      mergeProductAttrPics() {
        for (let i = 0; i < this.selectProductAttrPics.length; i++) {
          for (let j = 0; j < this.value.skuStockList.length; j++) {
            if (this.value.skuStockList[j].sp1 === this.selectProductAttrPics[i].name) {
              this.value.skuStockList[j].pic = this.selectProductAttrPics[i].pic;
            }
          }
        }
      },
      getOptionStr(arr) {
        let str = '';
        for (let i = 0; i < arr.length; i++) {
          str += arr[i];
          if (i != arr.length - 1) {
            str += ',';
          }
        }
        return str;
      },
      handleRemoveProductSku(index, row) {
        let list = this.value.skuStockList;
        if (list.length === 1) {
          list.pop();
        } else {
          list.splice(index, 1);
        }
      },
      getParamInputList(inputList) {
        return inputList.split(',');
      },
      handlePrev() {
        this.$emit('prevStep')
      },
      handleNext() {
        this.mergeProductAttrValue();
        this.mergeProductAttrPics();
        this.$emit('nextStep')
      },
      handleFinishCommit(){
        //可预约时间
        this.mergeProductAttrValue();
        this.mergeProductAttrPics();
        this.$emit('finishCommit',this.isEdit);
      }
    }
  }
</script>

<style scoped>
  .littleMarginLeft {
    margin-left: 10px;
  }

  .littleMarginTop {
    margin-top: 10px;
  }

  .paramInput {
    width: 250px;
  }

  .paramInputLabel {
    display: inline-block;
    width: 100px;
    text-align: right;
    padding-right: 10px
  }

  .cardBg {
    background: #F8F9FC;
  }
</style>
