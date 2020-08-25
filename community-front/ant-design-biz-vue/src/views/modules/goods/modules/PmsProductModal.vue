<template>
  <a-modal
    :title="title"
    :width="800"
    :visible="visible"
    :confirmLoading="confirmLoading"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭">
    
    <a-spin :spinning="confirmLoading">
      <a-form :form="form">
      
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="brandId">
          <a-input placeholder="请输入brandId" v-decorator="['brandId', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="productCategoryId">
          <a-input placeholder="请输入productCategoryId" v-decorator="['productCategoryId', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="feightTemplateId">
          <a-input placeholder="请输入feightTemplateId" v-decorator="['feightTemplateId', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="productAttributeCategoryId">
          <a-input placeholder="请输入productAttributeCategoryId" v-decorator="['productAttributeCategoryId', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="name">
          <a-input placeholder="请输入name" v-decorator="['name', validatorRules.name ]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="pic">
          <a-input placeholder="请输入pic" v-decorator="['pic', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="货号">
          <a-input placeholder="请输入货号" v-decorator="['productSn', validatorRules.productSn ]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="删除状态：0->未删除；1->已删除">
          <a-input-number v-decorator="[ 'deleteStatus', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="上架状态：0->下架；1->上架">
          <a-input-number v-decorator="[ 'publishStatus', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="新品状态:0->不是新品；1->新品">
          <a-input-number v-decorator="[ 'newStatus', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="推荐状态；0->不推荐；1->推荐">
          <a-input-number v-decorator="[ 'recommandStatus', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="审核状态：0->未审核；1->审核通过">
          <a-input-number v-decorator="[ 'verifyStatus', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="排序">
          <a-input-number v-decorator="[ 'sort', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="销量">
          <a-input-number v-decorator="[ 'sale', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="price">
          <a-input-number v-decorator="[ 'price', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="促销价格">
          <a-input-number v-decorator="[ 'promotionPrice', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="赠送的成长值">
          <a-input-number v-decorator="[ 'giftGrowth', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="赠送的积分">
          <a-input-number v-decorator="[ 'giftPoint', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="限制使用的积分数">
          <a-input-number v-decorator="[ 'usePointLimit', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="副标题">
          <a-input placeholder="请输入副标题" v-decorator="['subTitle', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="商品描述">
          <a-input placeholder="请输入商品描述" v-decorator="['description', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="市场价">
          <a-input-number v-decorator="[ 'originalPrice', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="库存">
          <a-input-number v-decorator="[ 'stock', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="库存预警值">
          <a-input-number v-decorator="[ 'lowStock', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="单位">
          <a-input placeholder="请输入单位" v-decorator="['unit', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="商品重量，默认为克">
          <a-input-number v-decorator="[ 'weight', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="是否为预告商品：0->不是；1->是">
          <a-input-number v-decorator="[ 'previewStatus', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="以逗号分割的产品服务：1->无忧退货；2->快速退款；3->免费包邮">
          <a-input placeholder="请输入以逗号分割的产品服务：1->无忧退货；2->快速退款；3->免费包邮" v-decorator="['serviceIds', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="keywords">
          <a-input placeholder="请输入keywords" v-decorator="['keywords', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="note">
          <a-input placeholder="请输入note" v-decorator="['note', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="画册图片，连产品图片限制为5张，以逗号分割">
          <a-input placeholder="请输入画册图片，连产品图片限制为5张，以逗号分割" v-decorator="['albumPics', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="detailTitle">
          <a-input placeholder="请输入detailTitle" v-decorator="['detailTitle', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="detailDesc">
          <a-input placeholder="请输入detailDesc" v-decorator="['detailDesc', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="产品详情网页内容">
          <a-input placeholder="请输入产品详情网页内容" v-decorator="['detailHtml', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="移动端网页详情">
          <a-input placeholder="请输入移动端网页详情" v-decorator="['detailMobileHtml', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="促销开始时间">
          <a-date-picker showTime format='YYYY-MM-DD HH:mm:ss' v-decorator="[ 'promotionStartTime', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="促销结束时间">
          <a-date-picker showTime format='YYYY-MM-DD HH:mm:ss' v-decorator="[ 'promotionEndTime', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="活动限购数量">
          <a-input-number v-decorator="[ 'promotionPerLimit', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="促销类型：0->没有促销使用原价;1->使用促销价；2->使用会员价；3->使用阶梯价格；4->使用满减价格；5->限时购">
          <a-input-number v-decorator="[ 'promotionType', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="品牌名称">
          <a-input placeholder="请输入品牌名称" v-decorator="['brandName', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="商品分类名称">
          <a-input placeholder="请输入商品分类名称" v-decorator="['productCategoryName', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="所属部门">
          <a-input placeholder="请输入所属部门" v-decorator="['sysOrgCode', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="所属公司">
          <a-input placeholder="请输入所属公司" v-decorator="['sysCompanyCode', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="所属区域">
          <a-input placeholder="请输入所属区域" v-decorator="['areaCode', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="产品类别码">
          <a-input placeholder="请输入产品类别码" v-decorator="['productCategoryCode', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="公益价">
          <a-input-number v-decorator="[ 'coinPrice', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="消耗公益币数量">
          <a-input-number v-decorator="[ 'coin', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="自动下架时间">
          <a-date-picker showTime format='YYYY-MM-DD HH:mm:ss' v-decorator="[ 'autoUnpublishTime', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="商品好评率">
          <a-input-number v-decorator="[ 'goodReviewRatio', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="店铺经度">
          <a-input-number v-decorator="[ 'longitude', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="店铺维度">
          <a-input-number v-decorator="[ 'latitude', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="最低订购数量">
          <a-input-number v-decorator="[ 'minBuyQuantity', {}]" />
        </a-form-item>
		
      </a-form>
    </a-spin>
  </a-modal>
</template>

<script>
  import { httpAction } from '@/api/manage'
  import pick from 'lodash.pick'
  import moment from "moment"

  export default {
    name: "PmsProductModal",
    data () {
      return {
        title:"操作",
        visible: false,
        model: {},
        labelCol: {
          xs: { span: 24 },
          sm: { span: 5 },
        },
        wrapperCol: {
          xs: { span: 24 },
          sm: { span: 16 },
        },

        confirmLoading: false,
        form: this.$form.createForm(this),
        validatorRules:{
        name:{rules: [{ required: true, message: '请输入name!' }]},
        productSn:{rules: [{ required: true, message: '请输入货号!' }]},
        },
        url: {
          add: "/mall/pmsProduct/add",
          edit: "/mall/pmsProduct/edit",
        },
      }
    },
    created () {
    },
    methods: {
      add () {
        this.edit({});
      },
      edit (record) {
        this.form.resetFields();
        this.model = Object.assign({}, record);
        this.visible = true;
        this.$nextTick(() => {
          this.form.setFieldsValue(pick(this.model,'brandId','productCategoryId','feightTemplateId','productAttributeCategoryId','name','pic','productSn','deleteStatus','publishStatus','newStatus','recommandStatus','verifyStatus','sort','sale','price','promotionPrice','giftGrowth','giftPoint','usePointLimit','subTitle','description','originalPrice','stock','lowStock','unit','weight','previewStatus','serviceIds','keywords','note','albumPics','detailTitle','detailDesc','detailHtml','detailMobileHtml','promotionPerLimit','promotionType','brandName','productCategoryName','sysOrgCode','sysCompanyCode','areaCode','productCategoryCode','coinPrice','coin','goodReviewRatio','longitude','latitude','minBuyQuantity'))
		  //时间格式化
          this.form.setFieldsValue({promotionStartTime:this.model.promotionStartTime?moment(this.model.promotionStartTime):null})
          this.form.setFieldsValue({promotionEndTime:this.model.promotionEndTime?moment(this.model.promotionEndTime):null})
          this.form.setFieldsValue({autoUnpublishTime:this.model.autoUnpublishTime?moment(this.model.autoUnpublishTime):null})
        });

      },
      close () {
        this.$emit('close');
        this.visible = false;
      },
      handleOk () {
        const that = this;
        // 触发表单验证
        this.form.validateFields((err, values) => {
          if (!err) {
            that.confirmLoading = true;
            let httpurl = '';
            let method = '';
            if(!this.model.id){
              httpurl+=this.url.add;
              method = 'post';
            }else{
              httpurl+=this.url.edit;
               method = 'put';
            }
            let formData = Object.assign(this.model, values);
            //时间格式化
            formData.promotionStartTime = formData.promotionStartTime?formData.promotionStartTime.format('YYYY-MM-DD HH:mm:ss'):null;
            formData.promotionEndTime = formData.promotionEndTime?formData.promotionEndTime.format('YYYY-MM-DD HH:mm:ss'):null;
            formData.autoUnpublishTime = formData.autoUnpublishTime?formData.autoUnpublishTime.format('YYYY-MM-DD HH:mm:ss'):null;
            
            console.log(formData)
            httpAction(httpurl,formData,method).then((res)=>{
              if(res.success){
                that.$message.success(res.message);
                that.$emit('ok');
              }else{
                that.$message.warning(res.message);
              }
            }).finally(() => {
              that.confirmLoading = false;
              that.close();
            })



          }
        })
      },
      handleCancel () {
        this.close()
      },


    }
  }
</script>

<style lang="less" scoped>

</style>