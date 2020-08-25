import fly from "../../assets/common/Axios"
//获取工作记录字典表
const getDictionary = async (param) => {
    let res
    await fly.get('/api/work/dictionary',{'name':param}).then(function (response) {
      res = response;
  
    })
    return res
  }
  //获取工作记录详情列表
const getWorkRecordList = async (type,pageNo,id) => {
    let res
    await fly.get('/api/work/workhistory/'+type,{'pageNo':pageNo,'id':id}).then(function (response) {
      res = response;
  
    })
    return res
  }
  //工作记录点赞
  const praiseSyns = async (param) => {
    let res
    await fly.post('/api/work/workhistoryPraise/'+param).then(function (response) {
      res = response;
  
    })
    return res
  }
  //工作记录收藏
  const collectSyns = async (param) => {
    let res
    await fly.post('/api/work/workhistoryCollect/'+param).then(function (response) {
      res = response;
  
    })
    return res
  }
  //获取我的收藏
  const getCollect = async (param) => {
    let res
    await fly.get('/api/work/getCollectWorkHistory',{'pageNo':param}).then(function (response) {
      res = response;
  
    })
    return res
  }
  //获取工作记录详情页面的详情
  const workIDdetail = async (id) => {
    let res
    await fly.get('/api/work/workDetail/'+id).then(function (response) {
      res = response;
  
    })
    return res
  }
  //获取工作记录的评论历史
  const workhistoryComment = async (id,param) => {
    let res
    await fly.get('/api/work/workhistoryComment/'+id,{pageNo:param}).then(function (response) {
      res = response;
  
    })
    return res
  }
  //提交工作记录的评论
  const submitJudge = async (id,param) => {
    let resform
    await fly.post('/api/work/workhistoryComment/'+id, {comment:param}).then(function (response) {
      resform = response;
  
    })
    return resform
  }
  //上传我的工作记录表单
  const submitForm = async (param) => {
    let resform
    await fly.post('/api/work/workhistory', param).then(function (response) {
      resform = response;
  
    })
    return resform
  }
  //删除我的工作记录
  const delWorkHistory = async (param) => {
    let res
    await fly.post('/api/work/delWorkHistory/'+param).then(function (response) {
      res = response;
    })
    return res
  }
  const getCommList = async (param) => {
    let res
    await fly.get('/api/work/address/'+0).then(function (response) {
      res = response;
    })
    return res
  }
  //吹哨，查看民意列表
  const opinionList = async (param) => {
    let res
    await fly.get('/api/work/willBlowList',{"pageNo":param}).then(function (response) {
      res = response;
    })
    return res
  }
  //获取关联的民意
  const relateOpinion = async (param) => {
    let res
    await fly.get('/api/work/willDetail/'+param).then(function (response) {
      res = response;
    })
    return res
  }

 
export default {
    getDictionary:getDictionary,
    getWorkRecordList:getWorkRecordList,
    submitForm:submitForm,
    praiseSyns:praiseSyns,
    collectSyns:collectSyns,
    workhistoryComment:workhistoryComment,
    submitJudge:submitJudge,
    delWorkHistory:delWorkHistory,
    getCollect:getCollect,
    getCommList:getCommList,
    workIDdetail:workIDdetail,
    opinionList:opinionList,
    relateOpinion:relateOpinion
    
  }