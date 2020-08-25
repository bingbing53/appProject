import fly from "../../assets/common/Axios"
  //获取调查模板的内容
  const getInvestigation = async (param) => {
    let res
    await fly.get('/api/work/investigation',param).then(function (response) {
      res = response;
  
    })
    return res
  }
  //获取调查记录1：居民 2：家庭 3：房屋
  const getInvestigationDataList = async (type,param) => {
    let res
    await fly.get('/api/work/investigationData/'+type,param).then(function (response) {
      res = response;
  
    })
    return res
  }









export default {
    getInvestigation:getInvestigation,
    getInvestigationDataList:getInvestigationDataList
  }