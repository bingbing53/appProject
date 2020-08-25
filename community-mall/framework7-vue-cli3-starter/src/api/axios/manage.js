import { axios } from '../https'
//上传图片
export function postActionimg(url, parameter) {
    return axios({
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        url: url,
        method: 'post',
        data: parameter,
        transformRequest: [function (parameter) {
            let ret = ''
            for (let it in parameter) {
                ret += it + '=' + encodeURIComponent(parameter[it]);
            }
            return ret
        }],

    })

}
//post
export function postAction(url, parameter) {
    return axios({
        url: url,
        method: 'post',
        data: parameter
    })
}
//post method= {post | put}
export function httpAction(url, parameter, method) {
    return axios({
        url: url,
        method: method,
        data: parameter
    })
}

//put
export function putAction(url, parameter) {
    return axios({
        url: url,
        method: 'put',
        data: parameter
    })
}

//get
export function getAction(url, parameter) {
    return axios({
        url: url,
        method: 'get',
        params: parameter,

    })
}

//deleteAction
export function deleteAction(url, parameter) {
    return axios({
        url: url,
        method: 'delete',
        params: parameter
    })
}