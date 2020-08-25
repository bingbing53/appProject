import { getAction,deleteAction,putAction,postAction,postActionimg} from './axios/manage.js'

//是否收藏
const isFocused = (type,id,params)=> getAction(`community-server/api/portal/behavior/collect/${type}/${id}`,params);
//添加收藏
const addFocus = (type,id,params)=> postAction(`community-server/api/portal/behavior/collect/${type}/${id}`,params);
//删除收藏
const delFocus = (type,id,params)=> deleteAction(`community-server/api/portal/behavior/collect/${type}/${id}`,params);

//是否点赞
const isPraised = (type,id,params)=> getAction(`community-server/api/portal/behavior/praise/${type}/${id}`,params);
//添加点赞
const addPraise = (type,id,second,params)=> postAction(`community-server/api/portal/behavior/praise/${type}/${id}/${second}`,params);
//取消点赞
const delPraise = (type,id,second,params)=> deleteAction(`community-server/api/portal/behavior/praise/${type}/${id}/${second}`,params);

//获取一级评论
const getComment = (type,id,params)=> getAction(`community-server/api/portal/behavior/comment/${type}/${id}/0`,params);
//获取二级评论
const getCommentSecond = (type,id,params)=> getAction(`community-server/api/portal/behavior/comment/${type}/${id}/1`,params);
//添加评论
const addComment = (type,id,params) => postAction(`community-server/api/portal/behavior/comment/${type}/${id}`,params);
//删除评论
const delComment = (id,params) => deleteAction(`community-server/api/portal/behavior/comment/${id}`,params);

//新增浏览
const addBrowse = (type,id,params)=> postAction(`community-server/api/portal/behavior/browse/${type}/${id}`,params);

//获取分类字典
const categoryList = (code,params)=>getAction(`community-user/api/common/category/${code}`);
//根据code获取字典
const dictCodeList = (code,params) => getAction(`community-user/api/common/getDictByCode/${code}`,params);

//上传图片
const uploadBase64Image =  (params) => postActionimg('community-user/api/common/upload?action=uploadscrawl', params);
//上传图片OCR识别
const uploadBase64OCRImage =  (params) => postActionimg('community-user/api/common/uploadOCR?action=uploadscrawl', params);
//提交app问题反馈
const reportQuestion = (params)=>postAction('community-server/api/portal/report',params);

export {
    isFocused,
    addFocus,
    delFocus,
    getComment,
    getCommentSecond,
    addComment,
    delComment,
    isPraised,
    addPraise,
    delPraise,
    addBrowse,
    categoryList,
    dictCodeList,
    uploadBase64Image,
    uploadBase64OCRImage,
    reportQuestion
};