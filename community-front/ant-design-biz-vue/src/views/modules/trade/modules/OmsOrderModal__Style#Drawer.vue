<template>
  <a-drawer
      :title="title"
      :width="800"
      placement="right"
      :closable="false"
      @close="close"
      :visible="visible"
  >

    <a-spin :spinning="confirmLoading">
      <a-form :form="form">
      
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="memberId">
          <a-input placeholder="请输入memberId" v-decorator="['memberId', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="couponId">
          <a-input placeholder="请输入couponId" v-decorator="['couponId', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="订单编号">
          <a-input placeholder="请输入订单编号" v-decorator="['orderSn', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="用户帐号">
          <a-input placeholder="请输入用户帐号" v-decorator="['memberUsername', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="订单总金额">
          <a-input-number v-decorator="[ 'totalAmount', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="应付金额（实际支付金额）">
          <a-input-number v-decorator="[ 'payAmount', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="运费金额">
          <a-input-number v-decorator="[ 'freightAmount', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="促销优化金额（促销价、满减、阶梯价）">
          <a-input-number v-decorator="[ 'promotionAmount', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="积分抵扣金额">
          <a-input-number v-decorator="[ 'integrationAmount', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="优惠券抵扣金额">
          <a-input-number v-decorator="[ 'couponAmount', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="管理员后台调整订单使用的折扣金额">
          <a-input-number v-decorator="[ 'discountAmount', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="支付方式：0->未支付；1->支付宝；2->微信">
          <a-input-number v-decorator="[ 'payType', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="订单来源：0->PC订单；1->app订单">
          <a-input-number v-decorator="[ 'sourceType', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="订单状态：0->待付款；1->待发货；2->已发货；3->已完成；4->已关闭；5->无效订单">
          <a-input-number v-decorator="[ 'status', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="订单类型：0->正常订单；1->秒杀订单">
          <a-input-number v-decorator="[ 'orderType', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="物流公司(配送方式)">
          <a-input placeholder="请输入物流公司(配送方式)" v-decorator="['deliveryCompany', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="物流单号">
          <a-input placeholder="请输入物流单号" v-decorator="['deliverySn', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="自动确认时间（天）">
          <a-input-number v-decorator="[ 'autoConfirmDay', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="可以获得的积分">
          <a-input-number v-decorator="[ 'integration', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="可以活动的成长值">
          <a-input-number v-decorator="[ 'growth', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="活动信息">
          <a-input placeholder="请输入活动信息" v-decorator="['promotionInfo', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="发票类型：0->不开发票；1->电子发票；2->纸质发票">
          <a-input-number v-decorator="[ 'billType', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="发票抬头">
          <a-input placeholder="请输入发票抬头" v-decorator="['billHeader', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="发票内容">
          <a-input placeholder="请输入发票内容" v-decorator="['billContent', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="收票人电话">
          <a-input placeholder="请输入收票人电话" v-decorator="['billReceiverPhone', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="收票人邮箱">
          <a-input placeholder="请输入收票人邮箱" v-decorator="['billReceiverEmail', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="收货人姓名">
          <a-input placeholder="请输入收货人姓名" v-decorator="['receiverName', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="收货人电话">
          <a-input placeholder="请输入收货人电话" v-decorator="['receiverPhone', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="收货人邮编">
          <a-input placeholder="请输入收货人邮编" v-decorator="['receiverPostCode', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="省份/直辖市">
          <a-input placeholder="请输入省份/直辖市" v-decorator="['receiverProvince', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="城市">
          <a-input placeholder="请输入城市" v-decorator="['receiverCity', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="区">
          <a-input placeholder="请输入区" v-decorator="['receiverRegion', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="详细地址">
          <a-input placeholder="请输入详细地址" v-decorator="['receiverDetailAddress', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="订单备注">
          <a-input placeholder="请输入订单备注" v-decorator="['note', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="确认收货状态：0->未确认；1->已确认">
          <a-input-number v-decorator="[ 'confirmStatus', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="删除状态：0->未删除；1->已删除">
          <a-input-number v-decorator="[ 'deleteStatus', validatorRules.deleteStatus ]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="下单时使用的积分">
          <a-input-number v-decorator="[ 'useIntegration', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="支付时间">
          <a-date-picker showTime format='YYYY-MM-DD HH:mm:ss' v-decorator="[ 'paymentTime', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="发货时间">
          <a-date-picker showTime format='YYYY-MM-DD HH:mm:ss' v-decorator="[ 'deliveryTime', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="确认收货时间">
          <a-date-picker showTime format='YYYY-MM-DD HH:mm:ss' v-decorator="[ 'receiveTime', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="评价时间">
          <a-date-picker showTime format='YYYY-MM-DD HH:mm:ss' v-decorator="[ 'commentTime', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="修改时间">
          <a-date-picker showTime format='YYYY-MM-DD HH:mm:ss' v-decorator="[ 'modifyTime', {}]" />
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
          label="支付成功（0否1是）">
          <a-input-number v-decorator="[ 'paySuccess', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="支付成功时间">
          <a-date-picker showTime format='YYYY-MM-DD HH:mm:ss' v-decorator="[ 'paySuccessTime', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="原始支付回调">
          <a-input placeholder="请输入原始支付回调" v-decorator="['payNotify', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="用户ID">
          <a-input placeholder="请输入用户ID" v-decorator="['userId', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="用户名称">
          <a-input placeholder="请输入用户名称" v-decorator="['userName', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="商品所属公司名称">
          <a-input placeholder="请输入商品所属公司名称" v-decorator="['sysCompanyName', {}]" />
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
          label="给商家留言">
          <a-input placeholder="请输入给商家留言" v-decorator="['buyerNote', {}]" />
        </a-form-item>
        <a-form-item
          :labelCol="labelCol"
          :wrapperCol="wrapperCol"
          label="couponHistoryId">
          <a-input placeholder="请输入couponHistoryId" v-decorator="['couponHistoryId', {}]" />
        </a-form-item>
		
      </a-form>
    </a-spin>
    <a-button type="primary" @click="handleOk">确定</a-button>
    <a-button type="primary" @click="handleCancel">取消</a-button>
  </a-drawer>
</template>

<script>
  import { httpAction } from '@/api/manage'
  import pick from 'lodash.pick'
  import moment from "moment"

  export default {
    name: "OmsOrderModal",
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
        deleteStatus:{rules: [{ required: true, message: '请输入删除状态：0->未删除；1->已删除!' }]},
        },
        url: {
          add: "/mall/omsOrder/add",
          edit: "/mall/omsOrder/edit",
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
          this.form.setFieldsValue(pick(this.model,'memberId','couponId','orderSn','memberUsername','totalAmount','payAmount','freightAmount','promotionAmount','integrationAmount','couponAmount','discountAmount','payType','sourceType','status','orderType','deliveryCompany','deliverySn','autoConfirmDay','integration','growth','promotionInfo','billType','billHeader','billContent','billReceiverPhone','billReceiverEmail','receiverName','receiverPhone','receiverPostCode','receiverProvince','receiverCity','receiverRegion','receiverDetailAddress','note','confirmStatus','deleteStatus','useIntegration','sysOrgCode','sysCompanyCode','areaCode','paySuccess','payNotify','userId','userName','sysCompanyName','coin','buyerNote','couponHistoryId'))
		  //时间格式化
          this.form.setFieldsValue({paymentTime:this.model.paymentTime?moment(this.model.paymentTime):null})
          this.form.setFieldsValue({deliveryTime:this.model.deliveryTime?moment(this.model.deliveryTime):null})
          this.form.setFieldsValue({receiveTime:this.model.receiveTime?moment(this.model.receiveTime):null})
          this.form.setFieldsValue({commentTime:this.model.commentTime?moment(this.model.commentTime):null})
          this.form.setFieldsValue({modifyTime:this.model.modifyTime?moment(this.model.modifyTime):null})
          this.form.setFieldsValue({paySuccessTime:this.model.paySuccessTime?moment(this.model.paySuccessTime):null})
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
            formData.paymentTime = formData.paymentTime?formData.paymentTime.format('YYYY-MM-DD HH:mm:ss'):null;
            formData.deliveryTime = formData.deliveryTime?formData.deliveryTime.format('YYYY-MM-DD HH:mm:ss'):null;
            formData.receiveTime = formData.receiveTime?formData.receiveTime.format('YYYY-MM-DD HH:mm:ss'):null;
            formData.commentTime = formData.commentTime?formData.commentTime.format('YYYY-MM-DD HH:mm:ss'):null;
            formData.modifyTime = formData.modifyTime?formData.modifyTime.format('YYYY-MM-DD HH:mm:ss'):null;
            formData.paySuccessTime = formData.paySuccessTime?formData.paySuccessTime.format('YYYY-MM-DD HH:mm:ss'):null;
            
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
/** Button按钮间距 */
  .ant-btn {
    margin-left: 30px;
    margin-bottom: 30px;
    float: right;
  }
</style>