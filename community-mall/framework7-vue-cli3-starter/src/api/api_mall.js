import { getAction,deleteAction,putAction,postAction} from './axios/manage.js'
//查询我的店铺
const queryMystore = (params)=>getAction("community-mall/api/client/shop/queryMyShop",params);
//联系客服
const toService = (params)=>getAction("community-mall/api/client/shop/getCustomerPhone",params);
//我的店铺活动列表
const MystoreActivityList = (params)=>getAction("community-cms/api/portal/v1/activity/list",params);
//扫码获取活动列表
const scanActivityList = (params)=>getAction("community-cms/api/portal/v1/activity/getScanCodeResult",params);
//点击活动签到
const signInActivity = (params)=>getAction("community-cms/api/portal/v1/activity/consumeActivity",params);
//搜索志愿者信息
const volunteerInfo = (params)=>getAction("community-cms/api/portal/v1/activity/welfareUserInfo",params);
//查询店铺详情
const queryStoreDetail = (params)=>getAction("community-mall/api/client/shop/queryDetail",params);
//获取商品导航数据
const goodsType = (params)=>getAction("community-mall/api/client/category/queryAll",params);
//获取商品列表
// const goodsList = (params)=>getAction("community-mall/api/client/product/queryListByCategory",params);
const goodsList = (params)=>getAction("community-mall/api/client/esProduct/search",params);
//获取商品详情
const goodsDetail = (params)=>getAction("community-mall/api/client/product/queryDetail",params);
//商品SKU查询全部
const goodsDetailSku = (params)=>getAction("community-mall/api/client/productSku/queryAll",params);
//虚拟商品：获取服务商品的可预约时间
const goodsUseDate = (params)=>getAction("community-mall//api/client/productAttributeCategory/queryUsableTimeList",params);

//商品按店铺查询
const storeGoodsList = (params)=>getAction("community-mall/api/client/esProduct/search/queryListByShop",params);
//添加到购物车
const addToCart = (params)=>getAction("community-mall/api/client/cart/addToCart",params);
//购物车列表查询
const getCartList = (params)=>getAction("community-mall/api/client/cart/queryAll",params);
//购物车详情
const getCartDetail = (params)=>getAction("community-mall/api/client/cart/queryDetail",params);
//获取我的卡券
const myVouchers = (params)=>getAction("",params);
//获取商家卡券
const businessVouchers = (params)=>getAction("",params);
//获取全部代金券
const useVouchers = (params)=>getAction("community-mall/api/client/product/queryAllCoupon",params);
//单品直购获取可用代金券
const myuseVouchers = (params)=>getAction("community-mall/api/client/directBuy/queryAllUseableCouponList",params);
//领取代金券
const receiveVouchers = (params)=>getAction("community-mall/api/client/product/getCoupon",params);
//代金券领取历史记录
// const gotVouchers = (params)=>getAction("community-mall/api/client/myCoupon/queryList",params);
//个人中心查询代金券
const ownVouchers = (params)=>getAction("community-mall/api/client/myCoupon/queryList",params);
//查询我的公益币余额
const userCoin = (params)=>getAction("community-mall/api/client/coin/queryValidBalance",params);
//查询订单
const queryOrder = (params)=>getAction("community-mall/api/client/order/queryAll",params);
//查询订单详情
const queryOrderDetail = (params)=>getAction("community-mall/api/client/order/queryDetail",params);
//商品评价列表
const productCommuntList = (params)=>getAction("community-mall/api/client/comment/queryListByProduct",params);
//评价订单
const evalOrder = (params)=>getAction("community-mall/api/client/comment/add",params);
//取消订单
const cancelOrder = (params)=>getAction("community-mall/api/client/order/cancel",params);
//确认收货
const sureOrder = (params)=>getAction("community-mall/api/client/order/receive",params);
//生成订单
const genOrder = (params)=>getAction("community-mall/api/client/directBuy/genConfirmationForm",params);
//计算金额
const cAmount = (params)=>getAction("community-mall/api/client/directBuy/calcPayAmount",params);
//购物车计算总金额
const cAmountCar = (params)=>getAction("community-mall/api/client/cart/calcPayAmount",params);
//购物车查询可用的代金券
const useQuanCar = (params)=>getAction("community-mall/api/client/cart/queryAllUseableCouponList",params);
//购物车增加一件
const addCar = (params)=>getAction("community-mall/api/client/cartItem/increase",params);
//购物车减少一件
const cutCar = (params)=>getAction("community-mall/api/client/cartItem/decrease",params);
//购物车删除一件
const delCar = (params)=>getAction("community-mall/api/client/cartItem/delete",params);
//购物车提交订单
const sumitMyorderCar = (params)=>getAction("community-mall/api/client/cart/genOrder",params);
//提交订单
const sumitMyorder = (params)=>getAction("community-mall/api/client/directBuy/genOrder",params);
//获取默认地址
const defaultAddress = (params)=>getAction("",params);
//获取地址列表
const addressList = (params)=>getAction("community-mall/api/client/address/queryAll",params);
//提交新增地址
const addAddress = (params)=>getAction("community-mall/api/client/address/add",params);
//获取地址详情
const detailAddress = (params)=>getAction("community-mall/api/client/address/queryDetail",params);
//编辑地址
const editAddress = (params)=>getAction("community-mall/api/client/address/update",params);
//删除收货地址
const delAddress = (params)=>getAction("community-mall/api/client/address/delete",params);
//安全检查
const secureReport = (params)=>getAction("community-mall/api/client/politicalBusiness/secureReport",params);
//门前三清
const publicHealthReport = (params)=>getAction("community-mall/api/client/politicalBusiness/publicHealthReport",params);
//商品种类查询
const goodsTypes = (params)=>getAction("community-mall/api/client/productAttributeCategory/queryDetail",params);
export {
    queryMystore,
    toService,
    MystoreActivityList,
    scanActivityList,
    signInActivity,
    volunteerInfo,
    queryStoreDetail,
    goodsList,
    storeGoodsList,
    goodsDetail,
    goodsDetailSku,
    goodsUseDate,
    goodsType,
    cAmount,
    cutCar,
    addCar,
    delCar,
    cAmountCar,
    sumitMyorder,
    sumitMyorderCar,
    myVouchers,
    queryOrder,
    userCoin,
    queryOrderDetail,
    genOrder,
    evalOrder,
    cancelOrder,
    sureOrder,
    useVouchers,
    myuseVouchers,
    receiveVouchers,
    // gotVouchers,
    ownVouchers,
    businessVouchers,
    defaultAddress,
    addressList,
    addAddress,
    detailAddress,
    editAddress,
    delAddress,
    useQuanCar,
    productCommuntList,
    secureReport,
    publicHealthReport,
    goodsTypes,
    addToCart,
    getCartList,
    getCartDetail
}