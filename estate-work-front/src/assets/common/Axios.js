import fly from "flyio";
// import store from "../../store";
import { Toast } from 'vant';

let ajaxCount = 0;
const toastHide = () => {
  // setTimeout(() => {
    ajaxCount--;
    // if (ajaxCount === 0) {
    Toast.clear();
    // }
  // }, 100);
};
fly.config.baseURL = 'https://api.shequyijia.cn/community-cms';
fly.interceptors.request.use((request) => {
 
  // request.headers['Content-Type'] = "application/x-www-form-urlencoded";
  let data = '';
  if (request.method === 'POST') {
    Toast.loading({
      mask: true,
      duration:0,
      message: '加载中...'
  
    });
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

  const token = window.localStorage.getItem("token_message");
  // if (token != 'undefined' && token != 'null' && token != null) {
    //APP环境
    request.headers = {//设置请求头
      "X-AUTH-TOKEN": token,
      "Content-Type": "application/x-www-form-urlencoded"
      // "Content-Type": "application/x-www-form-urlencoded"
      // "Content-Type": "multipart/form-data;charset=utf-8",
    }
  // } else {
  //   //电脑环境
  //   request.headers = {//设置请求头
  //     "X-AUTH-TOKEN": 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1ODUzNjUzNzEsInVzZXJuYW1lIjoiYWRtaW4ifQ.xyB0P8yfWmloKiad5beX5_h6hiBaupq9Piz5CpIM4Qw',
  //     "Content-Type": "application/x-www-form-urlencoded"
  //     // "Content-Type": "multipart/form-data;charset=utf-8",
  //   }
  //
  // }
  return request;
})

fly.interceptors.response.use(
  (response) => {
    toastHide();
    return response.data;//请求成功之后将返回值返回
  }, (err) => {
    //请求出错，根据返回状态码判断出错原因;
    toastHide();

    if (err.status == 401) {
      //跳转登录页
     if( window.sessionStorage.getItem("reload") == '1'){
       
     }else{
        window.sessionStorage.setItem("reload",1)
        window.location.reload();
     }
    } else {
      try{
        if(!!err.response.data)
        Toast({
          message:err.response.data,
          position:"bottom"
        });
      }catch{

      }
    }
  }
)



export default fly;
