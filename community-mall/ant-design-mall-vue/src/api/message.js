import request from '@/utils/request'
export function listCementByUser(params) {
  return request({
    url: process.env.SSO_PREFIX + '/sys/annountCement/listByUser',
    method:'get',
    params:params
  })
}

export function getMyAnnouncementSend(params) {
  return request({
    url: process.env.SSO_PREFIX + '/system/sysAnnouncementSend/getMyAnnouncementSend',
    method:'get',
    params:params
  })
}

export function readAllMsg(params) {
  return request({
    url: process.env.SSO_PREFIX + '/system/sysAnnouncementSend/readAll',
    method:'put',
    data:params
  })
}

export function editCementSend(params) {
  return request({
    url: process.env.SSO_PREFIX + '/system/sysAnnouncementSend/editByAnntIdAndUserId',
    method:'put',
    data:params
  })
}


