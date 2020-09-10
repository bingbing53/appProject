import request from "../../assets/common/request";
// import fly from "../../assets/common/Axios"
// 获取我的提案
export function fetchMyList(query) {
  return request({
    url: "/api/proposal/mine/page",
    method: "get",
    params: query,
  });
}
// 获取楼院提案
export function fetchOrgList(query) {
  return request({
    url: "/api/proposal/org/page",
    method: "get",
    params: query,
  });
}
// 提案详情
export function getProposalList(query) {
  return request({
    url: "/api/proposal/" + query,
    method: "get",
    // params: query,
  });
}
// 新增提案
export function addProposal(data) {
  return request({
    url: "/api/proposal",
    method: "post",
    data,
  });
}
// 新增提案
export function deleteProposal(query) {
  return request({
    url: "/api/proposal/" + query,
    method: "delete",
  });
}
// 修改提案
export function editProposal(data) {
  return request({
    url: "/api/proposal/" + data.id,
    method: "put",
    data,
  });
}
//评论
export function voteProposal(id) {
  return request({
    url: "/api/proposalVote/" + id + "/page",
    method: "get",
  });
}
// 获取提案分类
export function getProposalType() {
  return request({
    url: "/api/dict/proposalType",
    method: "get",
    // params: query,
  });
}
//   模拟数据格式
//   {
//       title:"尽快尽快尽快将科技将尽快尽快",
//       content:"您好，这是本次小区改建的主要提案内容之一，你 积分的结合房价多少附近可兑换防静电带回家回到家， 第三方接电话度计划几点几分跨时代讲课的佳都科技近",
//       isPublicity: false,
//       isVote: false,
//       isOpinion: false,
//       canhuiren:"李丽丽",
//       jiyao:"您好，这是本次小区改建的主要提案内容之一，你 积分的结合房价多少附近可兑换防静电带回家回到家， 第三方接电话度计划几点几分跨时代讲课的佳都科技近",
//       zongpiaoshu:10,
//       zantongshu:10,
//       fanduishu:10,
//       issueList:[
//           {content:'这个提案太好了咱村可以实现么？',name:'张三',phone:'10213065120',address:'村一社区XX楼XX单元'}
//       ]

//   }
