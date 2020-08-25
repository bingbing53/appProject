
import Vue from 'vue'
import Router from 'vue-router'

// import NProgress from 'nprogress' 
// import 'nprogress/nprogress.css'// nprogress样式文件

// 正常加载
// import Home from '../views/home'
// import About from '../views/About'

// 按需（懒）加载（vue实现）

//空页面
const License = () => import('./components/work/license')

//下载页面
const Download = () => import('./components/download/download')
//文章详情
const ArticleDetail = () => import('./components/article/articleDetail')
//民情民意
const Publicopinion = () => import('./components/PublicOpinion/PublicOpinion')
const Detailopinion = () => import('./components/PublicOpinion/opinionDetail')
//工作记录
const Workhistory = () => import('./components/work/workhistory')
const Torecord = () => import('./components/work/torecord')
const Worksort = () => import('./components/work/worksort')
const HisDetail = () => import('./components/work/hisDetail')
const Mycollect = () => import('./components/work/mycollect')
//调查模板
const Investsign = () => import('./components/invest/investsign')
const Invest = () => import('./components/invest/invest')
const Investdetail = () => import('./components/invest/investDetail')
const Selectaddress = () => import('./components/invest/selectAddress')
const Investhistory = () => import('./components/invest/investhistory')
//社工小组
const Group = () => import('./components/socialgroup/group')
const Groupdetail = () => import('./components/socialgroup/groupDetail')
const Collection = () => import('./components/socialgroup/mycollection')
const Addgroup = () => import('./components/socialgroup/addgroup')
const Addmember = () => import('./components/socialgroup/addmember')
const Privacy = () => import('./components/privacy')

const Text = () => import( /* webpackChunkName: "home" */ './components/text')

// 按需（懒）加载（webpack动态导入）  
// require.ensure() 是 webpack 特有的，已经被 import() 取代。大家理解其作用即可，参考issues —— https://github.com/wangyupo/vue-vuex-router/issues/1
// const Home = r => require.ensure([], () => r(require('../views/home')), 'home')
// const About = r => require.ensure([], () => r(require('../views/About')), 'about')

Vue.use(Router)

let base = `${process.env.BASE_URL}` // 动态获取二级目录

// Vue.prototype.AskToken = function(row){
//     AskToken.postMessage("JS调用了Flutter");
// }

const router = new Router({
    mode: 'hash',
    base: base,
    routes: [{
            path: '/',
            name: 'text',
            component: Text,
           
        },
       
        // {
        //     path: '/publicopinion',
        //     name: 'publicopinion',
        //     component: Publicopinion,
        //     meta: {
        //         title: '民情民意'
        //       }
        //
        // },
        // {
        //     path: '/detailopinion',
        //     name: 'Detailopinion',
        //     component: Detailopinion,
        //     meta: {
        //         title: '录入民意'
        //       }
        //
        // },
        // {
        //     path: '/license',
        //     name: 'license',
        //     component: License,
        //     meta:{
        //         title:'隐私政策',
        //         keepAlive: false
        //     }
        //
        // },
        // {
        //     path: '/workhistory',
        //     name: 'workhistory',
        //     component: Workhistory,
        //     meta:{
        //         title:'工作记录',
        //         keepAlive: true
        //     }
        //
        // },
        // {
        //     path: '/torecord',
        //     name: 'torecord',
        //     component: Torecord,
        //     meta:{
        //         title:'我要记录'
        //     }
        //
        // },
        // {
        //     path: '/worksort',
        //     name: 'worksort',
        //     component: Worksort
        //
        // },
        // {
        //     path: '/hisDetail',
        //     name: 'hisDetail',
        //     component: HisDetail,
        //     meta: {
        //         keepAlive: false, // 需要缓存
        //         title:"记录详情"
        //       }
        //
        //
        // },
        // {
        //     path: '/mycollect',
        //     name: 'mycollect',
        //     component: Mycollect,
        //     meta: {
        //         keepAlive: false, // 需要缓存
        //         title:"我的收藏"
        //       }
        //
        // },
        // {
        //     path: '/invest',
        //     name: 'invest',
        //     component: Invest,
        //     meta: {
        //         keepAlive: false, // 需要缓存
        //         title:"居民调查"
        //       }
        //
        //
        // },
        // {
        //     path: '/invest2',
        //     name: 'invest',
        //     component: Invest,
        //     meta: {
        //         keepAlive: false, // 需要缓存
        //         title:"家庭调查"
        //       }
        //
        //
        // },
        // {
        //     path: '/invest3',
        //     name: 'invest',
        //     component: Invest,
        //     meta: {
        //         keepAlive: false, // 需要缓存
        //         title:"房产调查"
        //       }
        //
        //
        // },
        // {
        //     path: '/investsign',
        //     name: 'investsign',
        //     component: Investsign,
        //     meta: {
        //         keepAlive: false // 需要缓存
        //       }
        //
        // },
        // {
        //     path: '/investhistory:uuid',
        //     name: 'investhistory',
        //     component: Investhistory,
        //     meta: {
        //         keepAlive: false // 需要缓存
        //       }
        //
        // },
        //  {
        //     path: '/investDetail:id',
        //     name: 'investdetail',
        //     component: Investdetail,
        //     meta: {
        //         keepAlive: false // 需要缓存
        //       }
        // },
        {
            path: '/articleDetail',
            name: 'articleDetail',
            component: ArticleDetail,
            meta: {
                keepAlive: false, // 需要缓存  
                title:'通知详情'
              }
        },
        {
            path: '/download',
            name: 'download',
            component: Download,
            meta: {
                keepAlive: false, // 需要缓存  
                title:'掌上物业app官方下载'
              }
        },
        {
            path: '/privacy',
            name: 'privacy',
            component: Privacy,
            meta: {
                keepAlive: false, // 需要缓存
                title:'隐私协议和政策'
            }
        },
        // {
        //     path: '/selectAddress',
        //     name: 'selectaddress',
        //     component: Selectaddress,
        //     meta: {
        //         keepAlive: false // 需要缓存
        //       }
        // },
        // {
        //     path: '/group',
        //     name: 'group',
        //     component: Group,
        //     meta: {
        //         keepAlive: false, // 需要缓存
        //         title:"我的小组"
        //       }
        // },
        // {
        //     path: '/groupdetail',
        //     name: 'groupdetail',
        //     component: Groupdetail,
        //     meta: {
        //         keepAlive: false, // 需要缓存
        //         title:"小组信息"
        //       }
        // },
        // {
        //     path: '/addgroup',
        //     name: 'addgroup',
        //     component: Addgroup,
        //     meta: {
        //         keepAlive: false, // 需要缓存
        //         title:"添加小组"
        //       }
        // },
        // {
        //     path: '/collection',
        //     name: 'collection',
        //     component: Collection,
        //     meta: {
        //         keepAlive: false, // 需要缓存
        //         title:"被调查记录"
        //       }
        // },
        // {
        //     path: '/addmember',
        //     name: 'addmember',
        //     component: Addmember,
        //     meta: {
        //         keepAlive: false, // 需要缓存
        //         title:"添加小组成员"
        //       }
        // },
        {
            path: '*',
            redirect: '/'
        }
       
    ],
    scrollBehavior(to, from, savedPosition) {
        // 从第二页返回首页时savedPosition为undefined
        if (savedPosition || typeof savedPosition === 'undefined') {
            // 只处理设置了路由元信息的组件
            from.meta.isKeepAlive = typeof from.meta.isKeepAlive === 'undefined' ? undefined : false
            to.meta.isKeepAlive = typeof to.meta.isKeepAlive === 'undefined' ? undefined : true
            if (savedPosition) {
            return savedPosition
            }
        } else {
            from.meta.isKeepAlive = typeof from.meta.isKeepAlive === 'undefined' ? undefined : true
            to.meta.isKeepAlive = typeof to.meta.isKeepAlive === 'undefined' ? undefined : false
        }
  
    }
});


router.beforeEach((to, from, next) => {
    // NProgress.start();
    // 通常权限控制就在这里
    // if (to.matched.some(record => record.meta.requireLogin)){  // 判断该路由是否需要登录权限
    
    //     if (sessionStorage.getItem('userInfo')) {  // 判断当前用户的登录信息loginInfo是否存在
    //       next();
    //     } else {
    //       next({
    //         path: '/'
    //       })
    //     }
    // }else{
  // 必须写next()哦，不然你的页面就会白白的，而且不报错，俗称"代码下毒"
  
  next();
        // }
});

// router.afterEach(() => {  
//     // 在即将进入新的页面组件前，关闭掉进度条
//     NProgress.done()
//  })
router.afterEach(route => {  // 从路由的元信息中获取 title 属性 
    if (route.meta.title) { 
        document.title = route.meta.title; 
        // 如果是 iOS 设备，则使用如下 hack 的写法实现页面标题的更新  
        if (navigator.userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/)) {   
            const hackIframe = document.createElement('iframe');    
            hackIframe.style.display = 'none';  
            hackIframe.src = '/static/html/fixIosTitle.html?r=' + Math.random(); 
            document.body.appendChild(hackIframe);   
            setTimeout(_ => {    
                document.body.removeChild(hackIframe)   
            }, 300)   
        }  
    }
    });


export default router;

