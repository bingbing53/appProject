import { getAction,deleteAction,putAction,postAction} from './axios/manage.js'

//添加维修申请
const addRepair = (params)=>postAction("community-estate/api/portal/estate/saveOrder",params);
//获取维修申请列表
const repairList = (params)=>getAction("community-estate/api/portal/estate/orderList",params);
//维修详情
const repairDetail = (params)=>getAction("community-estate/api/portal/estate/orderDetail/"+params);
//维修评价
const repairRate = (id,params)=>putAction("community-estate/api/portal/estate/judge/"+id,params);
//取消预约
const cancelRepair = (id,params)=>putAction("community-estate/api/portal/estate/cancel/"+id,params);
//维修联系人
const repairContact = (id,params)=>getAction(`community-estate/api/portal/estate/contact/${id}`,params);
//获取我的物业信息
const myEstateDetail = (params)=>getAction("community-estate/api/portal/estate/dinfo",params);
//问题反馈类型
const reportType = (params)=>getAction("community-user/portal/getDictItems/"+params);
//添加报事
const addReport = (params)=>postAction("community-estate/api/portal/estate/saveFeedBack",params);
//获取维修申请列表
const reportList = (params)=>getAction("community-estate/api/portal/estate/feedBackList",params);
//维修详情
const reportDetail = (params)=>getAction("community-estate/api/portal/estate/feedBackDetail/"+params);

//开门权限申请
const applyDoorAuth = (params)=>getAction("community-estate/api/portal/estate/uploadVerifyInfo",params);

//身份证照片
const photo=(idcard,params)=>getAction(`community-estate/api/portal/estate/uploadVerifyInfo/${idcard}`,params);

//开门记录
const doorLog=(params)=>getAction("community-estate/api/portal/estate/openDoorLog",params);

//访客列表
const visitorList = (params) => getAction("community-estate/api/portal/estate/tempPwdList",params);
//访客详情
const visitorDetail = (id,params) => getAction(`community-estate/api/portal/estate/tempPwdUsed/${id}`,params);

//绑定物业
const bindEstate = (params) => postAction("community-estate/api/portal/estate/bindEstate",params);
//绑定小区
const bindVillage = (params) => postAction("community-estate/api/portal/estate/bindVillage",params);
//获取小区
const getVillage = (params) => getAction("community-estate/api/portal/estate/villages",params);
//获取楼宇
const getBuilding = (id,params) => getAction(`community-estate/api/portal/estate/getBuildingByVillage/${id}`,params);
export {
    addRepair,
    repairList,
    repairDetail,
    repairContact,
    repairRate,
    cancelRepair,
    myEstateDetail,

    reportType,
    addReport,
    reportList,
    reportDetail,
    applyDoorAuth,
    photo,
    doorLog,
    visitorList,
    visitorDetail,

    bindVillage,
    bindEstate,
    getVillage,
    getBuilding
};