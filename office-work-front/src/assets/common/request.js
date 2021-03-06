import axios from "axios";
axios.defaults.withCredentials = true;
// import store from "../../store";
import {
    Toast
} from "vant";
import Cookies from "js-cookie";
let ajaxCount = 0;
const toastHide = () => {
    // setTimeout(() => {
    ajaxCount--;
    // if (ajaxCount === 0) {
    Toast.clear();
    // }
    // }, 100);
};
// fly.config.baseURL = 'https://mongo.qicaidonghu.cn/server/rest';
Cookies
    .set
//   "X-AUTH-TOKEN",
//   "eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJkODc5YzZiOWYzMzE0NTEwYmVjMDM2MDEwNGJiMzI5NyIsInN1YiI6InNvbmdiaW5nIiwiaWF0IjoxNTk5MDE1Mzg4fQ.uQEzuG5QAPZIW8FyYcmCMkk8sNAJ3io1dR2d4KIio0Q"
();
console.log(Document, "dssdfdsf");
axios.interceptors.request.use((request) => {
    request.headers["Content-Type"] = "application/x-www-form-urlencoded";
    let data = "";
    if (request.method === "POST") {
        Toast.loading({
            mask: true,
            duration: 0,
            message: "加载中...",
        });
        for (let key in request.body) {
            if (data) {
                data += "&";
            }
            data += key + "=" + request.body[key];
        }
        request.body = data;
    } else {
        for (let key in request.body) {
            if (data) {
                data += "&";
            }
            data += key + "=" + request.body[key];
        }
        request.body = data;
    }
    request.timeout = 120000;

    const token = window.localStorage.getItem("token_message");
    // if (token != 'undefined' && token != 'null' && token != null) {
    //APP环境
    request.headers = {
        //设置请求头
        "X-AUTH-TOKEN": token,
        "Content-Type": "application/json",
        //电脑环境
        //设置请求头
        // "X-AUTH-TOKEN": "eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJkODc5YzZiOWYzMzE0NTEwYmVjMDM2MDEwNGJiMzI5NyIsInN1YiI6InNvbmdiaW5nIiwiaWF0IjoxNTk5NTMyNDQ4fQ.xxxXDg-_trs74ziFCp6iC0MPxlw9vdMLusUVejUgToE",
        // "Content-Type": "application/json",
    };

    // }
    return request;
});

axios.interceptors.response.use(
    (response) => {
        console.log(response, "response");
        toastHide();
        return response.data; //请求成功之后将返回值返回
    },
    (err) => {
        //请求出错，根据返回状态码判断出错原因;
        toastHide();
        console.log(err, "err");
        if (err.status == 401) {
            //跳转登录页
            if (window.sessionStorage.getItem("reload") == "1") {} else {
                window.sessionStorage.setItem("reload", 1);
                window.location.reload();
            }
        } else {
            try {
                if (!!err.response.data)
                    Toast({
                        message: err.response.data,
                        position: "bottom",
                    });
            } catch {}
        }
    }
);

export default axios;