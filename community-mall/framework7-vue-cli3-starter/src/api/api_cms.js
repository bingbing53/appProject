import { getAction,deleteAction,putAction,postAction} from './axios/manage.js'

//文章详情
const articleDetail = (articleId,params)=>getAction(`community-cms/api/portal/v1/article/detail/${articleId}`,params);
//文章推荐信息
const articleRecommend = (articleId,params)=>getAction(`community-cms/api/portal/v1/article/recommend/${articleId}`,params);
//文章创建者信息
const articleCreater = (articleId,params)=>getAction(`community-cms/api/portal/v1/article/createInfo/${articleId}`,params);
//收藏的文章列表
const articleCollectList = (type,params)=>getAction(`community-cms/api/portal/v1/article/behavior/${type}`,params);
//删除文章评论
const articleDelComment = (id)=>deleteAction(`community-cms/api/portal/v1/search/delReview/${id}`);

//活动详情
const activityDetail = (activityId,params) => getAction(`community-cms/api/portal/v1/activity/detail/${activityId}`,params);
//活动报名人列表
const activityRegisterList = (activityId,params) => getAction(`community-cms/api/portal/v1/activity/volunteerList/${activityId}`,params);
//报名参加活动
const activitySign = (activityId,params) => postAction(`community-cms/api/portal/v1/activity/sign/${activityId}`,params);
//检查是否可以报名参加活动
const checkActivitySign = (activityId,params) => postAction(`community-cms/api/portal/v1/activity/checkSign/${activityId}`,params);
//活动签到
const activityRegister = (activityId,welfareUserId,params)=>postAction(`community-cms/api/portal/v1/activity/signup/${activityId}/${welfareUserId}`,params);
//收藏的活动列表
const activityCollectList = (type,params)=>getAction(`community-cms/api/portal/v1/activity/behavior/${type}`,params)
//收藏的商品
const goodsCollectList = (params)=>getAction(`community-cms/api/portal/v1/search/mall/behavior/collect`,params)

//参与的活动历史
const activityHisList = (params)=>getAction(`community-cms/api/portal/v1/activity/activityHisList`,params);
//根据code获取活动详情
const getActivityCode = (params)=>getAction(`community-cms/api/portal/v1/activity/getActivityByCode`,params);
//根据code签到活动
const signActivityByCode = (params)=>postAction(`community-cms/api/portal/v1/activity/activityByCodeConfirm`,params)


//投票调查详情
const surveyDetail = (surveyId,params) => getAction(`community-cms/api/portal/v1/vote/detail/${surveyId}`,params);
const surveySubmit = (surveyId,params) => postAction(`community-cms/api/portal/v1/vote/detail/${surveyId}`,params);
const voteSubmit = (voteId,pos,params) => postAction(`community-cms/api/portal/v1/vote/praise/${voteId}/${pos}`,params);

//我的评论(商品，文章)
const commentType = (type,params)=>getAction(`community-cms/api/portal/v1/search/reviewList/${type}`,params);
const commentTypeGoods = (params)=>getAction(`community-mall/api/client/comment/queryListByUserId`,params);
const focusStore = (params)=>getAction(`community-server/api/portal/behavior/focusList`,params);

export {
    articleDetail,
    articleRecommend,
    articleCreater,
    articleCollectList,
    articleDelComment,

    activityDetail,
    activityRegisterList,
    activitySign,
    activityCollectList,
    goodsCollectList,
    activityHisList,
    getActivityCode,
    signActivityByCode,
    checkActivitySign,

    surveyDetail,
    surveySubmit,
    voteSubmit,
    activityRegister,

    commentType,
    commentTypeGoods,
    focusStore
};