import fly from "../../assets/common/Axios"
import { async } from "q";
//获取调查模板的详情
const gettemDetail = async (param) => {
  let res
  await fly.get('/api/work/investigation' + "/" + param).then(function (response) {
    res = response;

  })
  return res
}
//获取居住地址
const getAddressList = async (type, paramId) => {
  let res
  await fly.get('/api/work/address/' + type + "?id=" + paramId).then(function (response) {
    res = response;
  })
  return res
}
//根据身份证号获取个人信息
const getPersonInfo = async (param) => {
  let res
  await fly.get('/api/work/getPersonInfo', param).then(function (response) {
    res = response;
  })
  return res
}
//身份证回填
const personAddress = async (param) => {
  let res
  await fly.get('/api/work/getPersonAddress', {idcard:param}).then(function (response) {
    res = response;
  })
  return res
}
//提交填写的表单信息
const formInfo = async (id,formData,signData) => {
  let res
  await fly.post('/api/work/investigation' + "/" + id,{investData: JSON.stringify(formData),signData:JSON.stringify(signData)}).then(function (response) {
    res = response;
  })
  return res
}
//获取被调查人历史记录

const getInvestHistoryData = async (id) => {
  let res
  await fly.get('/api/work/investigationDataDetail/' + id).then(function (response) {
    res = response;
  })
  return res
}
//图片转化地址


export default {
  gettemDetail: gettemDetail,
  getAddressList: getAddressList,
  getPersonInfo:getPersonInfo,
  personAddress:personAddress,
  formInfo:formInfo,
  getInvestHistoryData:getInvestHistoryData,
  
}