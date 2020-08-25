import fly from "../../assets/common/Axios"
//获取全部社区
const getAllcummunity = async () => {
  let res
  await fly.get('/api/work/address/0').then(function (response) {
    res = response;

  })
  return res
}
//获取民意分类列表
const getWillCategoryList = async () => {
  let res
  await fly.get('/api/work/willCategoryList').then(function (response) {
    res = response;

  })
  return res
}
//身份证验证**************************************************身份证验证*****************************************************
const Wi = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1]; // 加权因子
const ValideCode = [1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2]; // 身份证验证位值.10代表X
const checkIdCard = function (idCard) {
  if (idCard == undefined || idCard == null) return false;
  idCard = trim(idCard.replace(/ /g, "")); //去掉字符串头尾空格
  if (idCard.length == 15) {
    return isValidityBrithBy15IdCard(idCard); //进行15位身份证的验证
  } else if (idCard.length == 18) {
    var a_idCard = idCard.split(""); // 得到身份证数组
    if (isValidityBrithBy18IdCard(idCard) && isTrueValidateCodeBy18IdCard(a_idCard)) {
      //进行18位身份证的基本验证和第18位的验证
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
function isTrueValidateCodeBy18IdCard(a_idCard) {
  var sum = 0; // 声明加权求和变量
  if (a_idCard[17].toLowerCase() == 'x') {
    a_idCard[17] = 10; // 将最后位为x的验证码替换为10方便后续操作
  }
  for (var i = 0; i < 17; i++) {
    sum += Wi[i] * a_idCard[i]; // 加权求和
  }
  var valCodePosition = sum % 11; // 得到验证码所位置
  if (a_idCard[17] == ValideCode[valCodePosition]) {
    return true;
  } else {
    return false;
  }
}
//  验证18位数身份证号码中的生日是否是有效生日
//  @param idCard 18位书身份证字符串
//  @return
function isValidityBrithBy18IdCard(idCard18) {
  var year = idCard18.substring(6, 10);
  var month = idCard18.substring(10, 12);
  var day = idCard18.substring(12, 14);
  var temp_date = new Date(year, parseFloat(month) - 1, parseFloat(day));
  // 这里用getFullYear()获取年份，避免千年虫问题
  if (temp_date.getFullYear() != parseFloat(year) || temp_date.getMonth() != parseFloat(month) - 1 || temp_date.getDate() != parseFloat(day)) {
    return false;
  } else {
    return true;
  }
}
/**
 * 验证15位数身份证号码中的生日是否是有效生日
 * @param idCard15 15位书身份证字符串
 * @return
 */
function isValidityBrithBy15IdCard(idCard15) {
  var year = idCard15.substring(6, 8);
  var month = idCard15.substring(8, 10);
  var day = idCard15.substring(10, 12);
  var temp_date = new Date(year, parseFloat(month) - 1, parseFloat(day));
  // 对于老身份证中的你年龄则不需考虑千年虫问题而使用getYear()方法
  if (temp_date.getYear() != parseFloat(year) || temp_date.getMonth() != parseFloat(month) - 1 || temp_date.getDate() != parseFloat(day)) {
    return false;
  } else {
    return true;
  }
}
//去掉字符串头尾空格
function trim(str) {
  return str.replace(/(^\s*)|(\s*$)/g, "");
}
//身份证验证************************************************身份证验证*******************************************************
//上传图片
const uploadImage = async (imageList,code) => {
  // alert("imageList：" + imageList);
  let resform;
  const imageArr = {};
  if(code == 0){
  var url = '/api/work/cutIdCard'; //上传身份证，code毕传0
  }else{
  var url = '/api/wechatComm/upload';//上传图片，支持多张
  }
  for (let i in imageList) {
    imageArr['baseImage_' + i] = encodeURIComponent(imageList[i]);
  }
  // var form = new FormData(); // FormData 对象
  // form.append("file", imageList); // 文件对象


  await fly.post(url, imageArr).then(function (response) {
    resform = response;
  })
  return resform
}

//提交表单
const submitForm = async (param) => {
  let resform
  await fly.post('/api/work/saveWillRecord', param).then(function (response) {
    resform = response;

  })
  return resform
}
//根据身份证号搜索居民信息
const searchPersonID = async (param) => {
  let resIDinfo
  await fly.get('/api/work/getPersonInfo', param).then(function (response) {
    resIDinfo = response;
  })
  return resIDinfo
}
//获取民意记录列表
const HistoryRecordList = async (param) => {
  let resList
  await fly.get('/api/work/willrecord', {"pageNo":param}).then(function (response) {
    resList = response;
  })
  return resList
}
//获取全部的民意记录
const HistoryRecordListAll = async (param) => {
  let resList
  await fly.get('/api/work/v2/departWillrecord',param).then(function (response) {
    resList = response;
  })
  return resList
}
//回复民意
const callbackopinion= async (id,param) => {
  let resList
  await fly.post('/api/work/replyWill/'+id,{"content":param}).then(function (response) {
    resList = response;
  })
  return resList
}
//暂存民意
const storageopinion = async (id) => {
  let resList
  await fly.post('/api/work/cantSolve/'+id).then(function (response) {
    resList = response;
  })
  return resList
}
//取消暂存民意
const unstorageopinion = async (id) => {
  let resList
  await fly.post('/api/work/canSolve/'+id).then(function (response) {
    resList = response;
  })
  return resList
}
//作废民意
const deleopinion= async (id) => {
  let resList
  await fly.post('/api/work/cancelWillRecord/'+id).then(function (response) {
    resList = response;
  })
  return resList
}
//恢复民意 
const recoverOpinion= async (id) => {
  let resList
  await fly.post('/api/work/resumeWillRecord/'+id).then(function (response) {
    resList = response;
  })
  return resList
}

//删除我的民意
const delopinion = async (param) => {
  let resList
  await fly.post('/api/work/deleteWillRecord/'+param).then(function (response) {
    resList = response;
  })
  return resList
}
//获取我的民意详情
const getMyopinionDetail = async (param) => {
  let resList
  await fly.get('/api/work/getMineWillRecordDetail/'+param).then(function (response) {
    resList = response;
  })
  return resList
}


export default {
  getWillCategoryList: getWillCategoryList,
  submitForm: submitForm,
  searchPersonID: searchPersonID,
  uploadImage: uploadImage,
  checkIdCard: checkIdCard,
  storageopinion:storageopinion,
  unstorageopinion:unstorageopinion,
  HistoryRecordList: HistoryRecordList,
  HistoryRecordListAll:HistoryRecordListAll,
  delopinion:delopinion,
  getMyopinionDetail:getMyopinionDetail,
  callbackopinion:callbackopinion,
  deleopinion:deleopinion,
  recoverOpinion:recoverOpinion,
  getAllcummunity:getAllcummunity
}