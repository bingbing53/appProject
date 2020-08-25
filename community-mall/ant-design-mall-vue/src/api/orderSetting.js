import request from '@/utils/request'
export function getOrderSetting() {
  return request({
    url:'/orderSetting/query',
    method:'get',
  })
}

export function updateOrderSetting(id,data) {
  return request({
    url:'/orderSetting/update/'+id,
    method:'post',
    data:data
  })
}
