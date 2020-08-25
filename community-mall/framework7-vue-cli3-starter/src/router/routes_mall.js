import HomePage from '../pages/home.vue';

import PayStyle from '../pages/mall/payStyle.vue';
import CommentList from '../pages/mall/commentList.vue';
import StoreInForm from '../pages/mall/storeInForm.vue';
import ToConfirmOrder from '../pages/mall/toConfirmOrder.vue';
import ToConfirmOrders from '../pages/mall/toConfirmOrder_s.vue';
import ReturnGoods from '../pages/mall/returnGoods.vue';
import MyStore from '../pages/mall/myStore.vue';
import AddressList from '../pages/mall/addressList.vue';
import AddAddress from '../pages/mall/addAddress.vue';
import Vouchers from '../pages/mall/vouchers.vue';
import TradeArea from '../pages/mall/tradeArea.vue';
import GoodsList from '../pages/mall/goodsList.vue';

import EnterStore from '../pages/mall/enterStore.vue';
import Volunteers from '../pages/mall/volunteers.vue';

import GoodsDetail from '../pages/mall/goodsDetail.vue'
import GoodsDetails from '../pages/mall/goodsDetail_s.vue'
import ShoppingCar from '../pages/mall/shoppingCar.vue'
import OrderList from '../pages/mall/orderList.vue'
import OrderDetail from '../pages/mall/orderDetail.vue'
import PhysicalGoods from '../pages/mall/physicalGoods.vue'

export default [
  {
    path: '/toConfirmOrder/forceClose/:id/:num/:date/:date_id/:areaCode/:coinNum/',
    component: ToConfirmOrder,
  },
  {
    path: '/toConfirmOrders/forceClose/',
    component: ToConfirmOrders,
  },

  {
    path: '/payStyle/forceClose/:price/:orderSn/:coin/',
    component: PayStyle,
  },
  {
    path: '/goodsList/',
    component: GoodsList,
  },
  {
    path: '/storeInForm/',
    component: StoreInForm,
  },
  {
    path: '/commentList/:id/',
    component: CommentList,
  },
  {
    path: '/physicalGoods/:code/',
    component: PhysicalGoods,
  },
  {
    path: '/returnGoods/',
    component: ReturnGoods,
  },
  {
    path: '/addressList/',
    component: AddressList,
  },
  {
    path: '/addAddress/:id/',
    component: AddAddress,
  },
  {
    path: '/myStore/',
    component: MyStore,
  },
  {
    path: '/vouchers/',
    component: Vouchers,
  },
  {
    path: '/tradeArea/',
    component: TradeArea,
  },
  {
    path: '/orderList/',
    component: OrderList,
  },
  {
    path: '/orderDetail/:id',
    component: OrderDetail,
  },
  {
    path: '/goodsDetail/:id/',
    component: GoodsDetail,
  },
  {
    path: '/goodsDetails/:id/',
    component: GoodsDetails,
  },
  {
    path: '/shoppingCar/',
    component: ShoppingCar,
  },
  {
    path: '/enter-store/:storeID/',
    // path: '/',
    component: EnterStore,
  },
  {
    path: '/volunteers/:storeId/',
    component: Volunteers,
  },
  {
    path: '/',
    component: HomePage,
  },
 
/*  {
    path: '(.*)',
    component: NotFoundPage,
  },*/
];
