

import axios from "../assets/common/Axios";

//获取tabs 
const userInfo = async (params) => {
  return;
  let res = await axios({
    method: "get",
    url: '/userInfo',
    data: {...params}
  });
  let Obj = {}
  Obj.classSelected = res.classSelected ?res.classSelected :['0']
  Obj.courseSelected = res.courseSelected ?res.courseSelected :['0']
  Obj.schoolSelected = res.schoolSelected ?res.schoolSelected :['0']
  return Obj;
}


export default {
  userInfo: userInfo
}

