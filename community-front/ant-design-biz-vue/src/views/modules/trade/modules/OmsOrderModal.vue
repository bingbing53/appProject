<template>
  <a-modal
    title="订单详情"
    :width="modelWidth"
    :visible="visible"
    :bodyStyle="bodyStyle"
    :confirmLoading="confirmLoading"
    style="top: 0px;"
    @ok="handleOk"
    @cancel="handleCancel"
    cancelText="关闭"
    :footer="null"
  >
    <a-spin :spinning="confirmLoading">
      <a-steps :current="formatStepStatus(model.status)" style="padding-left: 30px;padding-right: 30px;padding-top: 15px;">
        <a-step title="提交订单" :description="formatTime(model.createTime)"></a-step>
        <a-step title="支付订单" :description="formatTime(model.paymentTime)"></a-step>
        <a-step title="平台发货" :description="formatTime(model.deliveryTime)"></a-step>
        <a-step title="确认收货" :description="formatTime(model.receiveTime)"></a-step>
        <a-step title="完成评价" :description="formatTime(model.commentTime)"></a-step>
      </a-steps>
      <a-card style="margin-top: 15px">

        <div style="margin-bottom: 15px;color: green">当前订单状态：{{model.status | formatStatus}}</div>

        <a-card title="基本信息">
          <div class="table-layout">
            <a-row>
              <a-col :span="4" class="table-cell-title">订单编号</a-col>
              <a-col :span="4" class="table-cell-title">发货单流水号</a-col>
              <a-col :span="4" class="table-cell-title">用户</a-col>
              <a-col :span="4" class="table-cell-title">支付方式</a-col>
              <!--<a-col :span="4" class="table-cell-title">订单来源</a-col>-->
              <a-col :span="4" class="table-cell-title">订单类型</a-col>
              <a-col v-if="model.orderType == 1" :span="4" class="table-cell-title">预约时间</a-col>
            </a-row>
            <a-row>
              <a-col :span="4" class="table-cell">{{model.orderSn}}</a-col>
              <a-col :span="4" class="table-cell">暂无</a-col>
              <a-col :span="4" class="table-cell">{{model.userName}}</a-col>
              <a-col :span="4" class="table-cell">{{model.payType | formatPayType}}</a-col>
              <a-col :span="4" class="table-cell">{{model.orderType | formatOrderType}}</a-col>
              <a-col v-if="model.orderType == 1" :span="4" class="table-cell">{{model.appointTime}}</a-col>
            </a-row>
            <a-row style="margin-top: 15px;">
              <a-col :span="4" class="table-cell-title">配送方式</a-col>
              <a-col :span="4" class="table-cell-title">物流单号</a-col>
              <a-col :span="4" class="table-cell-title">自动确认收货时间</a-col>
              <!--<a-col :span="4" class="table-cell-title">订单可得优币</a-col>-->
              <!--<a-col :span="4" class="table-cell-title">订单可得成长值</a-col>-->
              <!--<a-col :span="4" class="table-cell-title">活动信息</a-col>-->
            </a-row>
            <a-row>
              <a-col :span="4" class="table-cell">{{model.deliveryCompany | formatNull}}</a-col>
              <a-col :span="4" class="table-cell">{{model.deliverySn | formatNull}}</a-col>
              <a-col :span="4" class="table-cell">{{model.autoConfirmDay}}天</a-col>
              <!--<a-col :span="4" class="table-cell">{{model.integration}}</a-col>-->
              <!--<a-col :span="4" class="table-cell">{{model.growth}}</a-col>-->
              <!--<a-col :span="4" class="table-cell">-->
                <!--&lt;!&ndash;<el-popover-->
                  <!--placement="top-start"-->
                  <!--title="活动信息"-->
                  <!--width="200"-->
                  <!--trigger="hover"-->
                  <!--:content="model.promotionInfo">-->
                  <!--&lt;!&ndash;<span slot="reference">{{model.promotionInfo | formatLongText}}</span>&ndash;&gt;-->
                <!--</el-popover>&ndash;&gt;-->
              <!--</a-col>-->
            </a-row>
          </div>
        </a-card>
        <a-card title="收货人信息" style="margin-top: 10px;">
          <div class="table-layout">
            <a-row>
              <a-col :span="6" class="table-cell-title">收货人</a-col>
              <a-col :span="6" class="table-cell-title">手机号码</a-col>
              <a-col :span="6" class="table-cell-title">邮政编码</a-col>
              <a-col :span="6" class="table-cell-title">收货地址</a-col>
            </a-row>
            <a-row>
              <a-col :span="6" class="table-cell">{{model.receiverName}}</a-col>
              <a-col :span="6" class="table-cell">{{model.receiverPhone}}</a-col>
              <a-col :span="6" class="table-cell">{{model.receiverPostCode}}</a-col>
              <a-col :span="6" class="table-cell">{{model | formatAddress}}</a-col>
            </a-row>
          </div>
        </a-card>

        <a-card title="商品信息" style="margin-top: 10px;">
          <a-table :dataSource="model.orderItemList" :columns="orderItemColumns" :pagination="false" bordered
                   ref="modelItemTable" style="width: 100%;margin-top: 10px">
            <template slot="productPic" slot-scope="text, record">
              <img :src="formatPicture(record.productPic)" style="height: 80px">
            </template>
            <template slot="productName" slot-scope="text, record">
              <p>{{record.productName}}</p>
              <p>品牌：{{record.productBrand}}</p>
            </template>
            <template slot="productPrice" slot-scope="scope, record">
              <p>价格：￥{{record.productPrice}}</p>
              <p>货号：{{record.productSn}}</p>
            </template>
            <template slot="productAttr" slot-scope="scope, record">
              {{record.productAttr | formatProductAttr}}
            </template>
            <template slot="productPriceTotal" slot-scope="scope, record">
              ￥{{record.productPrice*record.productQuantity}}
            </template>
          </a-table>
          <div style="float: right;margin: 20px">
            合计：<span class="color-danger">￥{{model.totalAmount}}</span>
          </div>
        </a-card>

        <a-card title="费用信息" style="margin-top: 10px;">
          <div class="table-layout">
            <a-row>
              <a-col :span="6" class="table-cell-title">商品合计</a-col>
              <a-col :span="6" class="table-cell-title">运费</a-col>
              <a-col :span="6" class="table-cell-title">优惠券</a-col>
              <a-col :span="6" class="table-cell-title">积分抵扣</a-col>
            </a-row>
            <a-row>
              <a-col :span="6" class="table-cell">￥{{model.totalAmount}}</a-col>
              <a-col :span="6" class="table-cell">￥{{model.freightAmount}}</a-col>
              <a-col :span="6" class="table-cell">-￥{{model.couponAmount}}</a-col>
              <a-col :span="6" class="table-cell">-￥{{model.integrationAmount}}</a-col>
            </a-row>
            <a-row style="margin-top: 20px;">
              <a-col :span="6" class="table-cell-title">活动优惠</a-col>
              <a-col :span="6" class="table-cell-title">折扣金额</a-col>
              <a-col :span="6" class="table-cell-title">订单总金额</a-col>
              <a-col :span="6" class="table-cell-title">应付款金额</a-col>
            </a-row>
            <a-row>
              <a-col :span="6" class="table-cell">-￥{{model.promotionAmount}}</a-col>
              <a-col :span="6" class="table-cell">-￥{{model.discountAmount}}</a-col>
              <a-col :span="6" class="table-cell">
                <span class="color-danger">￥{{model.totalAmount+model.freightAmount}}</span>
              </a-col>
              <a-col :span="6" class="table-cell">
                <span class="color-danger">￥{{model.payAmount+model.freightAmount-model.discountAmount}}</span>
              </a-col>
            </a-row>
          </div>
        </a-card>

        <a-card title="操作信息" style="margin-top: 10px;">
          <a-table :dataSource="model.historyList" :columns="hisotryItemColumns" :pagination="false" bordered
                   ref="modelItemTable" style="width: 100%;margin-top: 10px">
            <span slot="orderStatus" slot-scope="scope, record">
              {{record.orderStatus | formatStatus}}
            </span>
          </a-table>
        </a-card>
      </a-card>
    </a-spin>
  </a-modal>
</template>

<script>
  import { getAction } from '@/api/manage'
  import pick from 'lodash.pick'
  import moment from "moment"

  export default {
    name: "OmsmodelModal",
    data () {
      return {
        title:"操作",
        visible: false,
        bodyStyle:{
          padding: "0",
        },
        modelWidth:window.innerWidth - 100,
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
        url: {
          detail:'/mall/omsOrder/queryById'
        },
        hisotryItemColumns:[
          {
            title: '操作人',
            align:"center",
            dataIndex: 'operateMan',
          },
          {
            title: '操作时间',
            align:"center",
            dataIndex: 'createTime',
          },
          {
            title: '订单状态',
            align:"center",
            dataIndex: 'orderStatus',
            scopedSlots: { customRender: 'orderStatus' },
          },
          {
            title: '备注',
            align:"center",
            dataIndex: 'note',
          },
        ],
        orderItemColumns:[
          {
            title: '商品图片',
            align:"center",
            dataIndex: 'productPic',
            scopedSlots: { customRender: 'productPic' },
          },
          {
            title: '商品名称',
            align:"center",
            dataIndex: 'productName',
            scopedSlots: { customRender: 'productName' },
          },
          {
            title: '价格/货号',
            align:"center",
            dataIndex: 'productPrice',
            scopedSlots: { customRender: 'productPrice' },
          },
          {
            title: '属性',
            align:"center",
            dataIndex: 'productAttr',
            scopedSlots: { customRender: 'productAttr' },
          },
          {
            title: '数量',
            align:"center",
            dataIndex: 'productQuantity',
            scopedSlots: { customRender: 'productQuantity' },
          },
          {
            title: '小计',
            align:"center",
            scopedSlots: { customRender: 'productPriceTotal' },
          },
        ]
      }
    },
    created () {
    },
    methods: {
      formatPicture(pic){
        return window._CONFIG['imageViewURL']+'/'+pic;
      },
      add () {
        this.edit({});
      },
      edit (record) {
        this.visible = true;
        this.getDetailById(record);
      },
      //根据id获取订单详情
      getDetailById(record){
        getAction(this.url.detail,{'id':record.id}).then((res)=>{
          if(res.success){
            this.model = res.result;
          }
        })
      },
      close () {
        this.$emit('close');
        this.visible = false;
      },
      handleOk () {

      },
      handleCancel () {
        this.close()
      },
      formatStepStatus(value) {
        if (value === 1) {
          //待发货
          return 2;
        } else if (value === 2) {
          //已发货
          return 3;
        } else if (value === 3) {
          //已完成
          return 4;
        }else {
          //待付款、已关闭、无限订单
          return 1;
        }
      },
      formatTime(time) {
        if (time == null || time === '') {
          return '';
        }
        let date = new Date(time);
        // return formatDate(date, 'yyyy-MM-dd hh:mm:ss')
        return time;
      },
    },
    filters:{
      formatNull(value) {
        if(value===undefined||value===null||value===''){
          return '暂无';
        }else{
          return value;
        }
      },
      formatStatus(value) {
        if (value === 0) {
          return '待付款';
        } else if (value === 1) {
          return '待发货';
        } else if (value === 2) {
          return '已发货';
        } else if (value === 3) {
          return '待评价';
        } else if (value === 4) {
          return '已完成';
        } else if (value === 5) {
          return '退款中';
        } else if (value === 6) {
          return '已退款';
        } else if (value === 7) {
          return '已关闭';
        } else if (value === 8) {
          return '无效订单';
        } else {
          return '未知状态';
        }
      },
      formatPayStatus(value) {
        if (value === 0) {
          return '未支付';
        } else if(value===4){
          return '已退款';
        }else{
          return '已支付';
        }
      },
      formatDeliverStatus(value) {
        if (value === 0||value === 1) {
          return '未发货';
        } else {
          return '已发货';
        }
      },
      formatAddress(order) {
        let str = order.receiverProvince;
        if (order.receiverCity != null) {
          str += "  " + order.receiverCity;
        }
        str += "  " + order.receiverRegion;
        str += "  " + order.receiverDetailAddress;
        return str;
      },
      formatPayType(value) {
        if (value === 1) {
          return '支付宝';
        } else if (value === 2) {
          return '微信';
        } else {
          return '未支付';
        }
      },
      formatOrderType(value) {
        if (value === 1) {
          return '服务订单';
        } else {
          return '实物订单';
        }
      },
      formatProductAttr(value){
        if(value==null){
          return '';
        }else{
          let attr = JSON.parse(value);
          let result='';
          for(let i=0;i<attr.length;i++){
            result+=attr[i].key.replace(/（.*）/, '');
            result+="：";
            result+=attr[i].value;
            result+="；";
          }
          return result;
        }
      }
    }
  }
</script>

<style lang="less" scoped>

</style>