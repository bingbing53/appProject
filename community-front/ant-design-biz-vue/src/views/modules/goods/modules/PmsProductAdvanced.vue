<template>
  <a-modal
    title="商品审核"
    :width="modelWidth"
    :visible="visible"
    :bodyStyle="bodyStyle"
    :confirmLoading="confirmLoading"
    :maskClosable="false"
    style="top: 0px;"
    @cancel="handleCancel"
    :footer="null"
    cancelText="关闭">

      <page-layout :title="'店铺名称：'+ (depart.departName || '')" :logo="depart.logo">
        <detail-list slot="headerContent" size="small" :col="2" class="detail-layout">
          <detail-list-item term="店铺地址">{{depart.address}}</detail-list-item>
          <detail-list-item term="联系电话">{{depart.mobile}}</detail-list-item>
          <detail-list-item term="店铺描述">{{depart.memo}}</detail-list-item>
        </detail-list>
        <a-row slot="extra" class="status-list">
          <a-col :xs="12" :sm="12">
          </a-col>
          <a-col :xs="12" :sm="12">
            <div class="text">状态</div>
            <div class="heading" v-if="product.verifyStatus == '0'">待审核</div>
            <div class="heading" v-if="product.verifyStatus == '1'" style="color: #108ee9;">审核通过</div>
            <div class="heading" v-if="product.verifyStatus == '2'" style="color: #f50;">审核未通过</div>
          </a-col>
        </a-row>
        <!-- actions -->
        <template slot="action">
          <!--<a-button-group style="margin-right: 4px;">-->
            <!--<a-button>操作</a-button>-->
            <!--<a-button>操作</a-button>-->
          <!--</a-button-group>-->
          <a-button type="primary" @click="verify">审核商品</a-button>
        </template>

        <!--<a-card :bordered="false" title="流程进度">-->
          <!--<a-steps :direction="isMobile() && 'vertical' || 'horizontal'" :current="1" progressDot>-->
            <!--<a-step title="创建项目">-->
            <!--</a-step>-->
            <!--<a-step title="部门初审">-->
            <!--</a-step>-->
            <!--<a-step title="财务复核">-->
            <!--</a-step>-->
            <!--<a-step title="完成">-->
            <!--</a-step>-->
          <!--</a-steps>-->
        <!--</a-card>-->

        <a-card style="margin-top: 24px" :bordered="false" title="商品信息">
          <detail-list>
            <detail-list-item term="商品名称">{{product.name}}</detail-list-item>
            <detail-list-item term="商品编号">{{product.id}}</detail-list-item>
            <detail-list-item term="价格">现价：{{product.price}}<a-divider type="vertical" />原价：{{product.originalPrice}}</detail-list-item>
            <detail-list-item term="公益价">{{product.coinPrice}}元<a-divider type="vertical" />{{product.coin}}公益币</detail-list-item>
            <detail-list-item term="描述">{{product.description}}</detail-list-item>
          </detail-list>

          <a-tabs defaultActiveKey="1">
            <a-tab-pane tab="商品图片" key="1">
              <a-row :gutter="[24,16]">
                <a-col :span="4" v-for="item in product.albumPicArr">
                  <img :src="item" width="100%"/>
                </a-col>
              </a-row>
            </a-tab-pane>
            <a-tab-pane tab="详细信息" key="2">
                <div v-html="product.detailMobileHtml" style="width: 800px;"></div>
            </a-tab-pane>
            <a-tab-pane tab="SKU库存" key="3" forceRender>
              <a-card type="inner">
                <a-table
                  :columns="pmsSkuStockColumns"
                  :dataSource="pmsSkuStock"
                  :pagination="false"
                >
                  <span slot="sp1" slot-scope="text, record">
                    {{record.sp1}}
                    <a-divider type="vertical" />
                    {{record.sp2}}
                  </span>
                  <span slot="coinPrice" slot-scope="text, record">
                    {{record.coinPrice}}元
                    <a-divider type="vertical" />
                    {{record.coin}}公益币
                  </span>
                </a-table>
              </a-card>
            </a-tab-pane>
          </a-tabs>
        </a-card>
      </page-layout>

    <product-verify-modal ref="modalForm" @ok="modalFormOk"></product-verify-modal>

  </a-modal>
</template>

<script>
  import { mixinDevice } from '@/utils/mixin.js'
  import {getAction,postAction} from "@/api/manage";
  import PageLayout from '@/components/page/PageLayout'
  import ProductVerifyModal from './ProductVerifyModal'
  import DetailList from '@/components/tools/DetailList'

  const DetailListItem = DetailList.Item
  export default {
    name: "PmsProductAdvanced",
    components: {
      PageLayout,
      ProductVerifyModal,
      DetailList,
      DetailListItem
    },
    mixins: [mixinDevice],
    data () {
      return {
        visible: false,
        verifyVisible:false,
        bodyStyle:{
          padding: "0",
          height:(window.innerHeight-100)+"px"
        },
        modelWidth:window.innerWidth - 80,
        product: {},
        depart:{},
        pmsProductVertifyRecord:{},
        pmsSkuStock:[],
        pmsSkuStockColumns:[
          {
            title: 'SKU编码',
            dataIndex: 'skuCode',
            key: 'skuCode'
          },
          {
            title:'属性',
            dataIndex:'sp1',
            ky:'sp1',
            scopedSlots: { customRender: 'sp1' },
          },
          {
            title: '价格',
            dataIndex: 'price',
            key: 'price'
          },
          {
            title: '公益价',
            dataIndex: 'coinPrice',
            key: 'coinPrice',
            scopedSlots: { customRender: 'coinPrice' },
          },
          {
            title:'库存',
            dataIndex:'stock',
            ky:'stock'
          },
        ],
        labelCol: {
          xs: { span: 24 },
          sm: { span: 5 },
        },
        wrapperCol: {
          xs: { span: 24 },
          sm: { span: 16 },
        },
        confirmLoading: false,
        url:{
          detail:'/mall/pmsProduct/',
          imgServer:window._CONFIG['imageViewURL']+'/'
        }
      }
    },
    filters: {
      statusFilter(status) {
        const statusMap = {
          'agree': '成功',
          'reject': '驳回'
        }
        return statusMap[status]
      },
      statusTypeFilter(type) {
        const statusTypeMap = {
          'agree': 'success',
          'reject': 'error'
        }
        return statusTypeMap[type]
      }
    },
    methods:{
      modalFormOk(){
        this.detail({id:this.product.id});
        this.$emit('ok')
      },
      detail(record){
        getAction(this.url.detail+record.id).then(res=>{
            if(res.success){
              if(!!res.result.pmsProduct){
                this.product = res.result.pmsProduct;
                this.product.albumPicArr = [];
                if(!!this.product.pic) {
                  this.product.pic = this.showPicture(this.product.pic);
                  this.product.albumPicArr.push(this.product.pic);
                }
                if(this.product.albumPics){
                  let albumPics = this.product.albumPics.split(',');
                  for(var i = 0;i < albumPics.length;i++){
                    this.product.albumPicArr.push(this.showPicture(albumPics[i]));
                  }
                }
              }
              if(!!res.result.depart){
                this.depart = res.result.depart;
                if(!!this.depart.logo){
                  this.depart.logo = this.showPicture(this.depart.logo);
                }
              }
              if(!!res.result.pmsProductVertifyRecord) {
                this.pmsProductVertifyRecord = res.result.pmsProductVertifyRecord
              }
              if(!!res.result.pmsSkuStock){
                this.pmsSkuStock = res.result.pmsSkuStock;
              }
            }
        });
      },
      verify(){
        this.$refs.modalForm.open(this.product.id);
      },
      showPicture(url){
        return this.url.imgServer+url
      },
      edit (record) {
        this.visible = true;
        this.detail(record);
      },
      close() {
        this.$emit('close')
        this.visible = false
      },
      handleCancel() {
        this.close()
      }
    }
  }
</script>

<style lang="scss" scoped>

  .detail-layout {
    margin-left: 44px;
  }
  .text {
    color: rgba(0, 0, 0, .45);
  }

  .heading {
    color: rgba(0, 0, 0, .85);
    font-size: 20px;
  }

  .no-data {
    color: rgba(0, 0, 0, .25);
    text-align: center;
    line-height: 64px;
    font-size: 16px;

    i {
      font-size: 24px;
      margin-right: 16px;
      position: relative;
      top: 3px;
    }
  }

  .mobile {
    .detail-layout {
      margin-left: unset;
    }
    .text {

    }
    .status-list {
      text-align: left;
    }
  }
</style>