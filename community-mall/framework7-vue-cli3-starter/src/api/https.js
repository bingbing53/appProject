import axios from 'axios'

axios.defaults.timeout = 50000;                        //响应时间
axios.defaults.baseURL = 'https://api.dev.shequyijia.cn/';   //配置接口地址
// axios.defaults.baseURL = 'https://api.shequyijia.cn/';   //配置接口地址

axios.interceptors.request.use((request) => {
  if (request.headers['Content-Type'] == null || request.headers['Content-Type'].length <= 0) {
    request.headers['Content-Type'] = "application/json";
  }
  let data = '';
  if (request.method === 'POST') {
    for (let key in request.body) {
      if (data) {
        data += "&"
      }
      data += key + "=" + request.body[key]
    }
    request.body = data
  } else {
    for (let key in request.body) {
      if (data) {
        data += "&"
      }
      data += key + "=" + request.body[key]
    }
    request.body = data
  }
  request.timeout = 120000;

  const token = window.localStorage.getItem("token");
  const sysOrgCode = window.localStorage.getItem("sysOrgCode");
  if (token != 'undefined' && token != 'null' && token != null) {
    //APP环境
    request.headers['X-AUTH-TOKEN'] = token;
    request.headers['X-SYS-ORGCODE'] = sysOrgCode;
  } else {
    //电脑环境
    request.headers['X-AUTH-TOKEN'] = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1ODYzMzUxMjYsInVzZXJuYW1lIjoiMTk5MTk5Njc0MzYifQ.0jj7e2PEcXpTmTsUq_GkJmnAy9VIy_GVHhkv3iz_J8A";
    // request.headers['X-AUTH-TOKEN'] = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1ODkzNjMzNjIsInVzZXJuYW1lIjoiMTg1MTgyMTYyODIifQ.Zu__N-py9FeMAP5XRT6-mQM7k1ehUu8OJCy2-LjYaLM";
    request.headers['X-SYS-ORGCODE'] = "A05A01A01A01";
  }
  return request;
})

//返回状态判断(添加响应拦截器)
axios.interceptors.response.use((res) => {
  //对响应数据做些事
  if (res.data.code && res.data.code != 200) {
    wx.toast(res.data.message);
    return Promise.reject(res);
  }
  // if (!res.data.success) {
  //     return Promise.resolve(res);
  // }
  return res;
}, (error) => {
  console.log(error.response.status + " " + error.response.data);
  if (error.response.status == '401' && error.response.data == 'login') {
    // console.log("您尚未登录,请登录！")
    wx.toast('您尚未登录,请登录！');
  }
  return Promise.reject(error.response);
});
const service = axios
export {
  service as axios
}