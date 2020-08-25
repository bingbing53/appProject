import fly from "../../assets/common/Axios"
//人口调查api
//获取小区列表 
const getVilliageList = async (param) => {
  let res
  await fly.get('/api/cube/villageList', {}).then(function (response) {
    res = response;
  })
  return res
}
//根据小区获取楼宇列表
const getBuildingList = async (id) => {
  let res
  await fly.get('/api/cube/buildingList', {
    'villageId': id
  }).then(function (response) {
    res = response;

  })
  return res
}

//根据楼宇获取单元和房屋
const getHousePersonList = async (id) => {
  let res
  await fly.get('/api/cube/housePersonList', {
    'buildingId': id
  }).then(function (response) {
    res = response;
  })
  return res
}

//根据房屋获取居住人
const getPersonList = async (id) => {
  let res
  await fly.get('/api/cube/personList', {
    'houseId': id
  }).then(function (response) {
    res = response;
  })
  return res
}

//根据房屋编号获取详情
const getHouseDetail = async (id) => {
  let res
  await fly.get('/api/cube/queryHouseInfoById', {
    'houseId': id
  }).then(function (response) {
    res = response;
  })
  return res
}

//根据房屋编号更新房屋
//参数：houseId（房屋编号）、houseArea（面积）、houseOwnername（产权人）、contactPhone（联系方式）、isRent（是否出租、0 否 1 是）
const postHouseDataByHouseId = async (data) => {
  let res
  await fly.post('/api/cube/updateHouse', data).then(function (response) {
    res = response;
  })
  return res
}

//删除居民居住房屋
//参数：personId（居民id）
const deleteHouseDataByPersonId = async (personId) => {
  let res
  await fly.post('/api/cube/delHousePerson',{
    personId: personId
  }).then(function (response) {
    res = response;
  })
  return res
}

//删除居民信息（物理删除）
//参数：personId（居民id）
const deletePersonDataByPersonId = async (personId) => {
  let res
  await fly.post('/api/cube/delPerson', {
    personId: personId
  }).then(function (response) {
    res = response;
  })
  return res
}

//更新居民信息
//参数：personId（居民id）、name（姓名）、sex（性别）、nationality（民族）、
//mobilePhone（手机号）、hostRelation（家庭关系）、rprDetailAddr（户籍地址）、
//presentDetailAddr1（现详细地址）、eduLevel（教育程度）、polity（政治面貌）
const postUpdatePersonInfo = async (data) => {
  let res
  await fly.post('/api/cube/updatePersoninfo', data).then(function (response) {
    res = response;
  })
  return res
}
//根据房屋获取居住人
//参数：keywords（关键词）
const getPersonData = async (keywords) => {
  let res
  await fly.get('/api/cube/searchByNameOrIdCard', {
    'keywords': keywords
  }).then(function (response) {
    res = response;
  })
  return res
}



export default {
  getVilliageList: getVilliageList,
  getBuildingList: getBuildingList,
  getHousePersonList: getHousePersonList,
  getPersonList: getPersonList,
  getHouseDetail: getHouseDetail,
  postHouseDataByHouseId: postHouseDataByHouseId,
  deleteHouseDataByPersonId: deleteHouseDataByPersonId,
  deletePersonDataByPersonId: deletePersonDataByPersonId,
  getPersonData: getPersonData,
  postUpdatePersonInfo: postUpdatePersonInfo
}