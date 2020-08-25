import request from '@/utils/request'
export function fetchList(params) {
  return request({
    url:'/extShopAccountChangeHistory/queryListBySysCompanyCode',
    method:'get',
    params:params
  })
}

export function fetchDrawCashList(params) {
  return request({
    url:'/extShopAccountWithdrawCashHistory/queryList',
    method:'get',
    params:params
  })
}

export function createApply(data) {
  return request({
    url:'/extShopAccountWithdrawCashHistory/withdrawCashApply',
    method:'post',
    data:data
  })
}

export function shBalance(data) {
  return request({
    url:'/extShopAccount/queryDetail',
    method:'get',
    params:data
  })
}

export function isExistApply(data) {
  return request({
    url:'/extShopAccountWithdrawCashHistory/queryWithdrawCashBySysCompanyCode',
    method:'get',
    params:data
  })
}

export function updateApplyStatus(data) {
  return request({
    url: '/extShopAccountWithdrawCashHistory/withdrawCashOper',
    method: 'post',
    data: data
  })
}
