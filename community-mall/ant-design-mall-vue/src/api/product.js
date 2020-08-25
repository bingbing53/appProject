import request from '@/utils/request'
export function fetchList(params) {
  return request({
    url:'/product/list',
    method:'get',
    params:params
  })
}

export function fetchSimpleList(params) {
  return request({
    url:'/product/simpleList',
    method:'get',
    params:params
  })
}

export function updateDeleteStatus(params) {
  return request({
    url:'/product/update/deleteStatus',
    method:'post',
    params:params
  })
}

export function updateNewStatus(params) {
  return request({
    url:'/product/update/newStatus',
    method:'post',
    params:params
  })
}

export function updateRecommendStatus(params) {
  return request({
    url:'/product/update/recommendStatus',
    method:'post',
    params:params
  })
}

export function updatePublishStatus(params) {
  return request({
    url:'/product/update/publishStatus',
    method:'post',
    params:params
  })
}

export function createProduct(data) {
  return request({
    url:'/product/create',
    method:'post',
    data:data
  })
}

export function updateProduct(id,data) {
  return request({
    url:'/product/update/'+id,
    method:'post',
    data:data
  })
}

export function getProduct(id) {
  return request({
    url:'/product/updateInfo/'+id,
    method:'get',
  })
}
//获取商品的审核信息
export function getProductVerify(id){
  return request({
    url:'/product/getVerifyRecord',
    method:'get',
    params:{'id':id}
  })
}

export function productVerify(id,verifyStatus){
  var ids = [];
  ids.push(id);
  let params = new URLSearchParams();
  params.append('ids', ids);
  params.append('verifyStatus', verifyStatus);
  params.append('detail','');
  return request({
    url:'/product/update/verifyStatus',
    method:'post',
    params:params
  })
}
