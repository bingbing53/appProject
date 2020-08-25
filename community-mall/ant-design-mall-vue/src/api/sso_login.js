import request from '@/utils/request'
//校验登录是否有效
export function validateLogin(params) {
  return request({
    url: process.env.SSO_PREFIX+'/cas/client/validateLogin',
    method: 'get',
    params: params
  })
}

//根据token获取权限列表
export function queryPermissionsByUser(params){
  return request({
    url: process.env.SSO_PREFIX+'/sys/permission/getUserPermissionByToken',
    method: 'get',
    params: params
  })
}

//登出
export function logout() {
  return request({
    url:process.env.SSO_PREFIX + '/sys/logout',
    method: 'post'
  })
}

//获取模块
export function permissionmenu(params){
  return request({
    url:process.env.SSO_PREFIX+'/system/sysModules/getUserModulesByToken',
    method: 'get',
    params:params
  })
}

//修改密码
export function updatePwd(data){
  return request({
    url:process.env.SSO_PREFIX+'/sys/user/updatePassword',
    method:'put',
    data:data
  })
}
