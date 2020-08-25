import fly from "../../assets/common/Axios"
//获取全部社工小组
const getWillCategrolyList = async (param) => {
    let res
    await fly.get('/api/work/groupList',{'code':param}).then(function (response) {
      res = response;
  
    })
    return res
  }
  //获取小组详情
  const showMyGroupCount = async (param) => {
    let res
    await fly.get('/api/work/v2/group',{'code':param}).then(function (response) {
      res = response;
     
  
    }).catch(function (error) {
      });
      return res
    
  }
  //检测是否有被调查数据
  const isDetail = async (param) => {
    let res
    await fly.get('/api/work/isAuth/' + param).then(function (response) {
      res = response;
    }).catch(function (error) {
      });
      return res
  }
  //获取民情民意调查列表
  const getpeopleDemoList = async (id,param) => {
    let res
    await fly.get('/api/work/willrecordList/'+id,{"pageNo":param}).then(function (response) {
      res = response;
    }).catch(function (error) {
      });
      return res
  }
    //获取入户调查列表
    const getpeopleInquire = async (id,param) => {
      let res
      await fly.get('/api/work/investigationDataList/'+id,{"pageNo":param}).then(function (response) {
        res = response;
      }).catch(function (error) {
        });
        return res
    }
    //创建小组
  const addGroup = async (param) => {
      let res
      await fly.post('/api/work/createGroup',param).then(function (response) {
        res = response;
      }).catch(function (error) {
        console.log(error);
        
        });
        return res
    }
    //修改小组
    const editGroup = async (param) => {
      let res
      await fly.post('/api/work/updateGroup',param).then(function (response) {
        res = response;
      }).catch(function (error) {
        console.log(error);
        
        });
        return res
    }
    //获取成员
    const addMemberList = async (param) => {
      let res
      await fly.get('/api/chat/list').then(function (response) {
        res = response;
      }).catch(function (error) {
        });
        return res
    }
    //添加小组成员
    const addMember = async (ids,code) => {
      let res
      await fly.post('/api/work/addGroupPerson',{"persons":ids,"code":code}).then(function (response) {
        res = response;
      }).catch(function (error) {
        });
        return res
    }
    //删除小组成员
    const delMember = async (id,param) => {
      let res
      await fly.post('/api/work/delGroupPerson',{"person":id,"code":param}).then(function (response) {
        res = response;
      }).catch(function (error) {
        console.log(error)
        });
        return res
    }
    //删除小组
    const delGroup = async (param) => {
      let res
      await fly.post('/api/work/deleteGroup',{"code":param}).then(function (response) {
        res = response;
      }).catch(function (error) {
        });
        return res
    }
    //责任范围
    const dutyArea = async (param) => {
      let res
      await fly.get('/api/work/buildingTree').then(function (response) {
        res = response;
      }).catch(function (error) {
        });
        return res
    }

  export default {
    getWillCategrolyList:getWillCategrolyList,
    showMyGroupCount:showMyGroupCount,
    isDetail:isDetail,
    getpeopleDemoList:getpeopleDemoList,
    getpeopleInquire:getpeopleInquire,
    addMemberList:addMemberList,
    addMember:addMember,
    delMember:delMember,
    addGroup:addGroup,
    editGroup:editGroup,
    delGroup:delGroup,
    dutyArea:dutyArea
    
  }