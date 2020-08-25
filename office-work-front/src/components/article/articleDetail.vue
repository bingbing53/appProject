<template>
  <div class="bgcw2">
    <div class="pd-15">
      <div class="mb-10 pr-10" v-show="article.articleType == 0">
      <h2 >{{article.articleTitle}}</h2>
      </div>
      <div class="c-999 f-12 mt-10 pt-10 record pl-10 pr-10 "  v-if="article.articleType == 0">
        <span>{{article.createDate}} </span> 
        <span>{{article.createBy}} </span> 
        <span v-if='article.hits != "" && article.hits != null'> 浏览数 {{article.hits}}</span>
        <span v-else> 浏览数 0 </span>
      </div>
      <!-- <div v-if="article.articleType == 1" class="pt-10 mt-10 hidden pd-10">
        <video controls="" :poster="article.imageArr"  x5-playsinline="" playsinline="" webkit-playsinline="" preload="metadata">
            <source :src="article.video"></source>
            您的浏览器不支持HTML5视频播放功能
        </video>
      </div> -->
      <div class="pt-10 mt-10 hidden" v-if="article.articleType == 0">
        <p class="litter f-16" v-html="article.content"></p>
      </div>
      <div class="mt-10 f-14" v-if="article.articleType == 1">
        <p class="mb-10 c-333">{{article.createBy}}</p>
        <p class="c-666 f-12 mb-10">{{article.createDate}} &nbsp; 
          <span v-if='article.hits != "" && article.hits != null'>浏览数 {{article.hits}}</span>
          <span v-else> 浏览数 0 </span>
        </p>
        <p class="f-16">{{article.articleDes}}</p>
      </div>

    </div>
    
    <div>
      <div class="bgcy"></div>
      <p class="mb-10 pl-10 pb-10 pt-10 read">
        <span class="blueLeftline f-b">I</span> 浏览统计
      </p>
      <div v-if="articleReadList.length > 0">
        <div class="read_box pt-10 pb-10 pl-10" v-for="(item,index) in articleReadList">
          <div class="read_img pt-5">
            <img :src="item.portrait" class="circleImage" />
          </div>
          <div class="read_text pl-10">
            <p class="mb-5">
              <span class="f-15 mr-5">{{item.realname}}</span>
              <van-tag plain size="mini" type="primary" v-if="item.is_read == 1" class="v_middle">已读</van-tag>
              <van-tag plain size="mini" v-if="item.is_read == 0" class="v_middle">未读</van-tag>
            </p>
            <p class="f-12 mt-8 c-999" v-if="item.read_time">阅读时间： {{item.read_time}}</p>
          </div>
        </div>
      </div>
      <div v-if="articleReadList.length <= 0" class="pb-30">
          <p class="noneHistory">暂无浏览记录</p>
      </div>
    </div>
  </div>
</template>
<script>
import articleDetail from "@/api/article/article";
export default {
  data() {
    return {
      articleListID: "",
      article: "",
      articleReadList: [],
      videoUrl:"",
    };
  },
  methods: {
    //获取文章详情数据
    async getDetail() {
      let res = await articleDetail.getarticleDetail(this.articleListID);
      res = JSON.parse(res);
      res.createDate = res.createDate.substring(0, 10);
       this.article = res;
     
      if(res.articleType == 0){
        // console.log(this.article.content);
          this.article.content = this.article.content.replace(
            /< img [^>]*src=['"]([^'"]+)[^>]*>/gi,
            function(match, capture) {
              return match.replace(
                new RegExp(/(src="http)/g),
                'data-src="https://image.shequyijia.cn/xinyi/net/2018?src=http'
              );
            }
          );

          this.article.content = this.article.content.replace(
            /< img [^>]*title=['"]([^'"]+)[^>]*>/gi,
            function(match, capture) {
              return match.replace(new RegExp(/(title="[a-z0-9A-z\.]*")/g), " ");
            }
          );

          this.article.content = this.article.content.replace(
            new RegExp(/(url\("http)/g),
            "url(&quot;https://image.shequyijia.cn/xinyi/net/2018?src=http"
          );
          this.article.content = this.article.content.replace(
            new RegExp(/(url\(http)/g),
            "url(https://image.shequyijia.cn/xinyi/net/2018?src=http"
          );
          this.article.content = this.article.content.replace(
            new RegExp(/(url\(&quot;http)/g),
            "url(&quot;https://image.shequyijia.cn/xinyi/net/2018?src=http"
          );
      }
      if(res.articleType == 1){
           let json = JSON.parse(res.images);
              res.video = this.common.showPicture(json.video,"",false);
              res.imageArr =  this.common.showPicture(json.img,"",false);
      }
    
      
      if (res) {
        this.getRead();
      }
    },
    async getRead() {
      let _this = this;
      let res = await articleDetail.getArticleRead(this.articleListID);
      res = JSON.parse(res);
      res.forEach(function(item, index) {
        if (item.read_time) {
          item.read_time = item.read_time.substring(0, 16);
        }
        if( item.portrait != null &&  item.portrait != '' && item.portrait != 'undifined'){
          if (item.portrait.substring(0, 4) != "http") {
              item.portrait = _this.common.showPicture(item.portrait);
            }
        }else{
          
        }
      
        _this.articleReadList.push(item);
      });
    }
  },
  mounted() {
    this.articleListID = this.$route.query.id;
    this.getDetail();
  }
};

</script>
<style scoped>

.record {
  text-indent: 0.2em;
}

.read_box {
  display: flex;
  justify-content: flex-start;
  align-items: flex-start;
  /* border-bottom: 8px solid #eee; */
}

.read_text {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  flex-direction: column;
}
.noneHistory{
  text-align: center;
  color:#999;
  line-height: 1;
}
.litter{
  letter-spacing: 0.55vw;
  line-height: 7.6vw!important;
  text-align: justify !important;
}
</style>


