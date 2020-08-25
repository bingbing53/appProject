import fly from "../../assets/common/Axios"

const getarticleDetail = async (param) => {
    let res
    await fly.get('/api/work/article/'+param).then(function (response) {
      res = response;
  
    })
    return res
  }
  const getArticleRead = async (param) => {
    let res
    await fly.get('/api/work/articleRead/'+param).then(function (response) {
      res = response;
  
    })
    return res
  }
export default {
    getarticleDetail:getarticleDetail,
    getArticleRead:getArticleRead
    
  }