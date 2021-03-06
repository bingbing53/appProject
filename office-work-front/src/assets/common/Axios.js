import fly from "flyio";
// import store from "../../store";
import {
    Toast
} from "vant";

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
fly.interceptors.request.use((request) => {
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
        "Content-Type": "application/x-www-form-urlencoded",
        //电脑环境
        //设置请求头
        // "X-AUTH-TOKEN": "eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJkODc5YzZiOWYzMzE0NTEwYmVjMDM2MDEwNGJiMzI5NyIsInN1YiI6InNvbmdiaW5nIiwiaWF0IjoxNTk5NTMyNDQ4fQ.xxxXDg-_trs74ziFCp6iC0MPxlw9vdMLusUVejUgToE",
        // "Content-Type": "application/x-www-form-urlencoded",
    };

    // }
    return request;
});

fly.interceptors.response.use(
    (response) => {
        toastHide();
        return response.data; //请求成功之后将返回值返回
    },
    (err) => {
        //请求出错，根据返回状态码判断出错原因;
        toastHide();

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

export default fly;