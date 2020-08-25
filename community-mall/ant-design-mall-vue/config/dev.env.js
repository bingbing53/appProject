'use strict'
const merge = require('webpack-merge')
const prodEnv = require('./prod.env')

// module.exports = merge(prodEnv, {
//   NODE_ENV: '"development"',
//   BASE_API: '"http://localhost:8085/mall"',
//   CAS_PREFIXURL: '"https://sso.dev.shequyijia.cn/cas"',
//   SSO_PREFIX: '"https://api.dev.shequyijia.cn/community-user"',
//   MODULE_CODE: '"mall"'
// })
module.exports = merge(prodEnv, {
  NODE_ENV: '"production"',
  BASE_API: '"https://api.dev.shequyijia.cn/community-mall"',
  CAS_PREFIXURL: '"https://sso.dev.shequyijia.cn"',
  SSO_PREFIX: '"https://api.dev.shequyijia.cn/community-user"',
  IMAGE_SERVER:'"https://mongo.qicaidonghu.cn/pic/"',
  MODULE_CODE: '"mall"'
})


// module.exports = {
//   NODE_ENV: '"production"',
//   BASE_API: '"https://api.shequyijia.cn/community-mall"',
//   CAS_PREFIXURL: '"https://sso.shequyijia.cn"',
//   SSO_PREFIX: '"https://api.shequyijia.cn/community-user"',
//   IMAGE_SERVER:'"https://image.shequyijia.cn/pic/"',
//   MODULE_CODE: '"mall"'
// }
