import Vue from 'vue'
import axios from 'axios'
import { Message, MessageBox } from 'element-ui'
import store from '../store'
import { getToken } from '@/utils/auth'
import { ACCESS_TOKEN } from "@/store/mutation-types"

// 创建axios实例
const service = axios.create({
  baseURL: process.env.BASE_API, // api的base_url
  timeout: 15000 // 请求超时时间
})

// request拦截器
service.interceptors.request.use(config => {
  const token = Vue.ls.get(ACCESS_TOKEN)
  if (token) {
    config.headers['X-Access-Token'] = token // 让每个请求携带自定义token 请根据实际情况自行修改
  }
  if(config.method=='get'){
    if(config.url.indexOf("sys/dict/getDictItems")<0){
      config.params = {
        _t: Date.parse(new Date())/1000,
        ...config.params
      }
    }
  }
  return config
}, error => {
  // Do something with request error
  console.log(error) // for debug
  Promise.reject(error)
})

// respone拦截器
service.interceptors.response.use(
  response => {
  /**
  * code为非200是抛错 可结合自己业务进行修改
  */
    const res = response.data
    console.log(res);
    if (res.code !== 200 && !res.success) {
      // 401:未登录;
      if (res.code === 401||res.code === 403) {
        MessageBox.confirm('你已被登出，可以取消继续留在该页面，或者重新登录', '确定登出', {
          confirmButtonText: '重新登录',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          store.dispatch('FedLogOut').then(() => {
            location.reload()// 为了重新实例化vue-router对象 避免bug
          })
        })
      }
      if(res.code === 500){
        const token = Vue.ls.get(ACCESS_TOKEN)
        //notification.error({ message: '系统提示', description:'Token失效，请重新登录!',duration: 4})
        if(token && res.message=="Token失效，请重新登录"){
          // update-begin- --- author:scott ------ date:20190225 ---- for:Token失效采用弹框模式，不直接跳转----
          // store.dispatch('Logout').then(() => {
          //     window.location.reload()
          // })
          // Modal.error({
          //   title: '登录已过期',
          //   content: '很抱歉，登录已过期，请重新登录',
          //   okText: '重新登录',
          //   mask: false,
          //   onOk: () => {
              // store.dispatch('Logout').then(() => {
                Vue.ls.remove(ACCESS_TOKEN)
                window.location.reload()
              // })
          //   }
          // })
          // update-end- --- author:scott ------ date:20190225 ---- for:Token失效采用弹框模式，不直接跳转----
        }
        return response.data
      }
      return Promise.reject('error')
    } else {
      return response.data
    }
  },
  error => err(error)
)

const err = (error) => {
  console.log('error');
  if (error.response) {
    let data = error.response.data
    const token = Vue.ls.get(ACCESS_TOKEN)
    console.log("------异常响应------",token)
    console.log("------异常响应------",error.response.status)
    switch (error.response.status) {
      case 403:
        notification.error({ message: '系统提示', description: '拒绝访问',duration: 4})
        break
      case 500:
        //notification.error({ message: '系统提示', description:'Token失效，请重新登录!',duration: 4})
        if(token && data.message=="Token失效，请重新登录"){
          Vue.ls.remove(ACCESS_TOKEN)
          window.location.reload()
        }
        break
      case 404:
          notification.error({ message: '系统提示', description:'很抱歉，资源未找到!',duration: 4})
        break
      case 504:
        notification.error({ message: '系统提示', description: '网络超时'})
        break
      case 401:
        notification.error({ message: '系统提示', description:'未授权，请重新登录',duration: 4})
        if (token) {
          store.dispatch('Logout').then(() => {
            setTimeout(() => {
              window.location.reload()
            }, 1500)
          })
        }
        break
      default:
        notification.error({
          message: '系统提示',
          description: data.message,
          duration: 4
        })
        break
    }
  }
  return Promise.reject(error)
};


export default service
