<template>
  <a-card :bordered="false">

    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline">
        <a-row :gutter="24">
          <a-col :md="8" :sm="8">
            <a-form-item label="订单编号">
              <a-input placeholder="请输入订单编号" v-model="queryParam.orderSn"></a-input>
            </a-form-item>
          </a-col>
          <a-col :md="8" :sm="8">
              <a-form-item label="订单状态">
                <a-select placeholder="请选择订单状态"  v-model="queryParam.status">
                  <a-select-option value="0">待付款</a-select-option>
                  <a-select-option value="1">待发货</a-select-option>
                  <a-select-option value="2">已发货</a-select-option>
                  <a-select-option value="3">待评价</a-select-option>
                  <a-select-option value="4">已完成</a-select-option>
                  <a-select-option value="5">退款中</a-select-option>
                  <a-select-option value="6">已退款</a-select-option>
                  <a-select-option value="7">已关闭</a-select-option>
                  <a-select-option value="8">无效订单</a-select-option>
                </a-select>
              </a-form-item>
            </a-col>
            <a-col :md="8" :sm="8" >
              <span style="float: left;overflow: hidden;" class="table-page-search-submitButtons">
                <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
                <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
              </span>
            </a-col>
          </a-row>
          <!--<a-col :md="6" :sm="8">-->
            <!--<a-form-item label="用户帐号">-->
              <!--<a-form-item label="审核状态">-->
                <!--<a-select placeholder="请输入订单类型"  v-model="queryParam.verifyStatus">-->
                  <!--<a-select-option value="0">待审核</a-select-option>-->
                  <!--<a-select-option value="1">审核通过</a-select-option>-->
                  <!--<a-select-option value="2">审核不通过</a-select-option>-->
                <!--</a-select>-->
              <!--</a-form-item>-->
            <!--</a-form-item>-->
          <!--</a-col>-->
        </a-row>
      </a-form>
    </div>

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-dropdown v-if="selectedRowKeys.length > 0">
        <a-menu slot="overlay">
          <a-menu-item key="1" @click="batchDel"><a-icon type="delete"/>删除</a-menu-item>
        </a-menu>
        <a-button style="margin-left: 8px"> 批量操作 <a-icon type="down" /></a-button>
      </a-dropdown>
    </div>

    <!-- table区域-begin -->
    <div>
      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项
        <a style="margin-left: 24px" @click="onClearSelected">清空</a>
      </div>

      <a-table
        ref="table"
        size="small"
        bordered
        rowKey="id"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
        @change="handleTableChange">

        <span slot="orderSn" slot-scope="text, record">
          <a @click="handleEdit(record)">{{record.orderSn}}</a>
        </span>

        <span slot="payType" slot-scope="text, record">
          <a-tag v-if="record.payType == '0'">未支付</a-tag>
          <a-tag v-if="record.payType == '1'" color="blue">支付宝</a-tag>
          <a-tag v-if="record.payType == '2'" color="green">微信</a-tag>
        </span>
      </a-table>
    </div>
    <!-- table区域-end -->

    <!-- 表单区域 -->
    <omsOrder-modal ref="modalForm" @ok="modalFormOk"></omsOrder-modal>
  </a-card>
</template>

<script>
  import OmsOrderModal from './modules/OmsOrderModal'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'

  export default {
    name: "OmsOrderList",
    mixins:[JeecgListMixin],
    components: {
      OmsOrderModal
    },
    data () {
      return {
        description: '订单信息管理页面',
        // 表头
        columns: [
		   {
            title: '订单号',
            align:"center",
            dataIndex: 'orderSn',
            scopedSlots: { customRender: 'orderSn' },
           },
		   {
            title: '总金额',
            align:"center",
            dataIndex: 'totalAmount'
           },
		   {
            title: '应付金额',
            align:"center",
            dataIndex: 'payAmount'
           },
		   {
            title: '运费',
            align:"center",
            dataIndex: 'freightAmount'
           },
		   {
            title: '优惠券抵扣',
            align:"center",
            dataIndex: 'couponAmount'
           },
          {
            title: '公益币',
            align:"center",
            dataIndex: 'coin'
          },
		   {
            title: '支付方式',
            align:"center",
            dataIndex: 'payType',
            scopedSlots: { customRender: 'payType' },
           },
		   {
            title: '订单状态',
            align:"center",
            dataIndex: 'status',
            customRender:function (t,r,index) {
              // 订单状态：0->待付款；1->待发货；2->已发货；3->待评价；4->已完成；5->退款中；6->已退款；7->已关闭；8->无效订单
              if(r.status == '0'){
                return '待付款';
              }else if(r.status == '1'){
                return '待发货';
              }else if(r.status == '2'){
                return '已发货';
              } else if(r.status == '3'){
                return '待评价';
              } else if(r.status == '4'){
                return '已完成';
              } else if(r.status == '5'){
                return '退款中';
              } else if(r.status == '6'){
                return '已退款';
              } else if(r.status == '7'){
                return '已关闭';
              } else if(r.status == '8'){
                return '无效订单';
              }
             return '';
            }
           },
		   {
            title: '支付成功',
            align:"center",
            dataIndex: 'paySuccess',
           customRender:function (t,r,index) {
             if(r.paySuccess == '0'){
                return '否';
             }else if(r.paySuccess == '1'){
               return '是';
             }
           }
       },
		   {
            title: '支付时间',
            align:"center",
            dataIndex: 'paySuccessTime'
           },

          // {
          //   title: '操作',
          //   dataIndex: 'action',
          //   align:"center",
          //   scopedSlots: { customRender: 'action' },
          // }
        ],
		url: {
          list: "/mall/omsOrder/list",
          delete: "/mall/omsOrder/delete",
          deleteBatch: "/mall/omsOrder/deleteBatch",
          exportXlsUrl: "mall/omsOrder/exportXls",
          importExcelUrl: "mall/omsOrder/importExcel",
       },
    }
  },
  computed: {
    importExcelUrl: function(){
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
    }
  },
    methods: {
     
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less'
</style>