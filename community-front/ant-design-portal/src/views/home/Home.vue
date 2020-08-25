<template>
  <div ref="viewBox">
    <home-header ref="header" :isdownload="0"></home-header>
    <div class="out_center">
      <div class="container">
        <div class="center_text" style="margin-top:6.6rem">
          <p class="f42 tc top_gray">共商共治、共融共享</p>
          <p class="under_text f18">按照您的单位性质，选择对应系统注册或登录</p>
        </div>
        <div class="center_image tc">
          <a-row class="list_image tc" type="flex" :justify="center">
            <a-col :xs="12" :sm="12" :md="12" :lg="6">
              <a :href="community">
                <div class="item_image">
                  <img src="@/assets/image/jiedao.png" alt />
                </div>
              </a>
            </a-col>
            <a-col :xs="12" :sm="12" :md="12" :lg="6">
              <a :href="estate">
                <div class="item_image">
                  <img src="@/assets/image/wuye.png" alt />
                </div>
              </a>
            </a-col>
            <a-col :xs="12" :sm="12" :md="12" :lg="6">
              <a :href="mall">
                <div class="item_image">
                  <img src="@/assets/image/shangjia.png" alt />
                </div>
              </a>
            </a-col>
            <a-col :xs="12" :sm="12" :md="12" :lg="6">
              <a :href="cms">
                <div class="item_image">
                  <img src="@/assets/image/zuzhi.png" alt />
                </div>
              </a>
            </a-col>
          </a-row>
        </div>
        <div class="center_function">
          <p class="f42 tc top_gray">功能概览</p>
          <div class="center_image center_image2 tc">
            <a-row class="list_image list_image2 tc">
              <a-col :xs="12" :sm="8" :md="8" :lg="6">
                <!-- <a href="#fangwu"> -->
                  <div class="item_container">
                    <div class="item_image">
                      <img src="@/assets/image/01.png" alt />
                    </div>
                    <p class="f16">房屋管理</p>
                  </div>
                <!-- </a> -->
              </a-col>
              <a-col :xs="12" :sm="8" :md="8" :lg="6">
                <div class="item_container">
                  <div class="item_image">
                    <img src="@/assets/image/02.png" alt />
                  </div>
                  <p class="f16">社工管理与考核</p>
                </div>
              </a-col>
              <a-col :xs="12" :sm="8" :md="8" :lg="6">
                <div class="item_container">
                  <div class="item_image">
                    <img src="@/assets/image/03.png" alt />
                  </div>
                  <p class="f16">物业管理</p>
                </div>
              </a-col>
              <a-col :xs="12" :sm="8" :md="8" :lg="6">
                <div class="item_container">
                  <div class="item_image">
                    <img src="@/assets/image/04.png" alt />
                  </div>
                  <p class="f16">部门协同</p>
                </div>
              </a-col>
              <a-col :xs="12" :sm="8" :md="8" :lg="6">
                <div class="item_container">
                  <div class="item_image">
                    <img src="@/assets/image/05.png" alt />
                  </div>
                  <p class="f16">日常办公</p>
                </div>
              </a-col>
              <a-col :xs="12" :sm="8" :md="8" :lg="6">
                <div class="item_container">
                  <div class="item_image">
                    <img src="@/assets/image/06.png" alt />
                  </div>
                  <p class="f16">居民办事预约</p>
                </div>
              </a-col>
              <a-col :xs="12" :sm="8" :md="8" :lg="6">
                <div class="item_container">
                  <div class="item_image">
                    <img src="@/assets/image/07.png" alt />
                  </div>
                  <p class="f16">物联设备</p>
                </div>
              </a-col>
              <a-col :xs="12" :sm="8" :md="8" :lg="6">
                <div class="item_container">
                  <div class="item_image">
                    <img src="@/assets/image/08.png" alt />
                  </div>
                  <p class="f16">社区商圈</p>
                </div>
              </a-col>
              <a-col :xs="12" :sm="8" :md="8" :lg="6">
                <!-- <a href="#renkou"> -->
                  <div class="item_container">
                    <div class="item_image">
                      <img src="@/assets/image/09.png" alt />
                    </div>
                    <p class="f16">人口管理</p>
                  </div>
                <!-- </a> -->
              </a-col>
              <a-col :xs="12" :sm="8" :md="8" :lg="6">
                <div class="item_container">
                  <div class="item_image">
                    <img src="@/assets/image/10.png" alt />
                  </div>
                  <p class="f16">信息发布</p>
                </div>
              </a-col>
              <a-col :xs="12" :sm="8" :md="8" :lg="6">
                <div class="item_container">
                  <div class="item_image">
                    <img src="@/assets/image/11.png" alt />
                  </div>
                  <p class="f16">权限管理</p>
                </div>
              </a-col>
              <a-col :xs="12" :sm="8" :md="8" :lg="6">
                <div class="item_container">
                  <div class="item_image">
                    <img src="@/assets/image/12.png" alt />
                  </div>
                  <p class="f16">任务管理</p>
                </div>
              </a-col>
            </a-row>
          </div>
        </div>
      </div>
      <home-footer></home-footer>
    </div>
    <div class="out_container" style="display:none">
      <div class="container">
        <div class="link">
          <div>
            <a-row class="pt110" id="renkou" type="flex" :justify="space_between">
              <a-col :xs="24" :sm="24" :md="24" :lg="12" :xl="12">
                <div class="bottom_left">
                  <h1 class="f32">人口管理</h1>
                  <ul class="f16 bottom_gary">
                    <li>常住人口、流动人口、老龄人口、育龄妇女、 儿童、特殊人群、志愿者等人口信息管理</li>
                    <li>家庭曾理、家庭成员关系、低保家庭、特困家庭管</li>
                    <li>地图检索房屋及房屋居住人口信息</li>
                  </ul>
                </div>
              </a-col>
              <a-col :xs="24" :sm="24" :md="24" :lg="12" :xl="8">
                <div class="tr pl10">
                  <video controls loop="loop" width="100%">
                    <source src="@/assets/image/video.mp4" type="video/mp4" />
                  </video>
                </div>
              </a-col>
            </a-row>
            <a-row class="pt110" id="fangwu" type="flex" :justify="space_between">
              <a-col :xs="24" :sm="24" :md="24" :lg="12" :xl="8">
                <div class="tl pr10">
                  <img src="@/assets/image/fangwu_big.png" alt width="100%" />
                </div>
              </a-col>
              <a-col :xs="24" :sm="24" :md="24" :lg="12" :xl="12">
                <div class="bottom_left">
                  <h1 class="f32">房屋管理</h1>
                  <ul class="f16 bottom_gary">
                    <li>常住人口、流动人口、老龄人口、育龄妇女、 儿童、特殊人群、志愿者等人口信息管理</li>
                    <li>家庭曾理、家庭成员关系、低保家庭、特困家庭管</li>
                    <li>地图检索房屋及房屋居住人口信息</li>
                  </ul>
                </div>
              </a-col>
            </a-row>
          </div>
        </div>
      </div>
      <div class="out_container b_top">
        <div class="container">
          <div class="bottom_help">
            <div class="bottom_button" @click="toTOp" style="display:none">
              <span>进入系统</span>
            </div>
            <div class="bottom_text" style="display:none">
              <p>
                <a href>下载</a>
              </p>
              <p>
                <a href>帮助</a>
              </p>
              <p>
                <a href>问题与讨论</a>
              </p>
              <p>
                <a href>联系我们</a>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// import downLoadPage from './downLoad'
import homeFooter from "./homeFooter";
import homeHeader from "./homeHeader";
export default {
  name: "home",
  components: {
    // downLoadPage,
    homeFooter,
    homeHeader
  },
  data() {
    return {
      center: "center",
      space_between: "space-between",
      isScroll: false,
      community:
        this.GLOBAL.casPrefixUrl + "/#/login?service=" + this.GLOBAL.comunity,
      estate:
        this.GLOBAL.casPrefixUrl + "/#/login?service=" + this.GLOBAL.estate,
      cms: this.GLOBAL.casPrefixUrl + "/#/login?service=" + this.GLOBAL.cms,
      mall: this.GLOBAL.casPrefixUrl + "/#/login?service=" + this.GLOBAL.mall
    };
  },
  mounted() {
  

    this.autoDivSize();
    window.addEventListener(
      "scroll",
      () => {
        let scrollTop =
          document.documentElement.scrollTop || document.body.scrollTop;
        if (scrollTop > 66) {
          this.isScroll = true;
        } else {
          this.isScroll = false;
        }
      },
      true
    );
  },
  methods: {
    toTOp() {
      document.body.scrollTop = 0;
    },
    autoDivSize() {
      let winWidth, winHeight;
      // 获取窗口宽度
      if (window.innerWidth) {
        winWidth = window.innerWidth;
        // console.log(winWidth+','+"oneW");
      } else if (document.body && document.body.clientWidth) {
        winWidth = document.body.clientWidth;
        // console.log(winWidth+','+"twoW");
      }
      // 获取窗口高度
      if (window.innerHeight) {
        winHeight = window.innerHeight;
        // console.log(winHeight+','+"oneH");
      } else if (document.body && document.body.clientHeight) {
        winHeight = document.body.clientHeight;
        // console.log(winHeight+','+"oneH");
      }
      // 通过深入 Document 内部对 body 进行检测，获取窗口大小
      if (
        document.documentElement &&
        document.documentElement.clientHeight &&
        document.documentElement.clientWidth
      ) {
        winHeight = document.documentElement.clientHeight;
        winWidth = document.documentElement.clientWidth;
        // console.log(winHeight+','+winWidth);
      }
      //DIV高度为浏览器窗口高度 的60%
      document.getElementById("test").style.height = winHeight * 0.9 + "px";
      // console.log(document.getElementById("test").style.height);
    }
  }
};
  window.οnresize = function() {
      // console.log(11111111);
    }; //浏览器窗口发生变化时同时变化DIV高度
</script>


<style scoped>
.center_text {
  padding-top: 68px;
}
.under_text {
  color: #b3b3b3;
  text-align: center;
}
.center_image {
  margin-top: 81px;
}
.center_image2 {
  margin-top: 60px;
}
.center_function {
  margin-top: 213px;
  /* display: none; */
}
.link {
  padding: 8.8rem 7.6rem 18.8rem 7.6rem;
  width: 100%;
}
.bottom_left {
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: space-around;
}
.bottom_left ul li {
  margin-top: 1.8rem;
}
.bottom_left ul li::before {
  content: "●";
  color: #fb3f35;
  font-size: 1.2rem;
  margin-right: 1.5rem;
}
.bottom_button {
  width: 17.86rem;
  height: 7.46rem;
  margin: 0 auto;
  line-height: 7.46rem;
  text-align: center;
  border: 1px solid #fd6b69;
  color: #fff;
  background-color: #fd6b69;
  font-size: 2rem;
  font-weight: bold;
  border-radius: 5rem;
  cursor: pointer;
}
.bottom_text {
  margin-top: 10rem;
  margin-bottom: 10rem;
  padding: 0rem 12rem;
  display: flex;
  justify-content: space-around;
  font-size: 1.8rem;
}
.bottom_text p .top_gray:hover {
  color: #d0121b !important;
  cursor: pointer;
}
</style>
