import { getAction,deleteAction,putAction,postAction} from './axios/manage.js'

//添加随手拍
const addTakePicture = (params)=>postAction("community-server/api/portal/willRecord",params);
//随手拍列表
const takePictureList = (params)=>getAction("community-server/api/portal/willRecord",params);

//办事预约列表
const traderList = (params)=>getAction("community-server/api/portal/traderList",params);
//办事预约详情
const traderContent = (id,params)=>getAction(`community-server/api/portal/trader/${id}`,params);
//获取预约历史
const traderOrderList = (params)=>getAction(`community-server/api/portal/traderOrderList`,params);
//提交预约
const traderOrderSubmit = (id,params)=>postAction(`community-server/api/portal/order/${id}`,params);
//取消预约
const cancelTraderOrder = (id,params)=>deleteAction(`community-server/api/portal/traderOrder/${id}`,params);
//获取节假日
const holiday = (params)=>getAction(`community-server/api/portal/holiday`,params);

//认证信息
const certificate1 = (params)=>putAction(`community-server/api/portal/info`,params);
const getMineInfo = (params)=>getAction(`community-server/api/portal/info`,params);
const getMineDetailInfo = (params)=>getAction(`community-server/api/portal/detailInfo`,params);
const postMineDetailInfo = (params)=>postAction(`community-server/api/portal/detailInfo`,params);
//成为志愿者
const welfareUser = (params)=>postAction(`community-server/api/portal/joinWelfare`,params);

export {
    addTakePicture,
    takePictureList,

    traderList,
    traderContent,
    traderOrderList,
    traderOrderSubmit,
    cancelTraderOrder,
    holiday,

    certificate1,
    getMineInfo,
    welfareUser,
    getMineDetailInfo,
    postMineDetailInfo
};