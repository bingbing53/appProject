import ArticleDetail from '../pages/cms/articleDetail.vue';
import articleUserHome from '../pages/cms/articleUserHome.vue';
import TakePicture from '../pages/community/takePicture';
import takePictureList from '../pages/community/takePictureList';
import traderList from '../pages/community/traderList';
import traderDetail from '../pages/community/traderDetail';
import cert1 from '../pages/certificate/cert1';
import cert3 from '../pages/certificate/cert3';
import welfare from '../pages/certificate/welfare';
import activity from '../pages/cms/activity';
import activitySign from '../pages/cms/activitySign';
import surveyPage from '../pages/cms/surveyPage';
import votePage from '../pages/cms/votePage';
import traderOrder from '../pages/community/traderOrder';
import collect from '../pages/mine/collect';
import activityHistory from '../pages/mine/activityHistory';
import report from '../pages/settings/report';
import account from '../pages/settings/account';
import download from '../pages/download';
import privacy from '../pages/privacy';
import coinRules from '../pages/coin-rules';
import comment from '../pages/mine/commentPage';
import focus from '../pages/mine/focusPage';

export default [
    {
        path: '/cms/articleDetail/:id/',
        component: ArticleDetail,
    },
    {
        path: '/cms/articleUserHome',
        component: articleUserHome,
    },
    {
        path: '/community/takePicture/forceClose/',
        component: TakePicture,
    },
    {
        path: '/community/takePictureList',
        component: takePictureList,
    },
    {
        path: '/community/traderList',
        component: traderList,
    },
    {
        path: '/community/traderDetail/:traderId/',
        component: traderDetail,
    },
    {
        path: '/community/traderOrder/:traderId',
        component: traderOrder,
    },
    {
        path: '/certificate/cert1',
        component: cert1,
    },
    {
        path: '/certificate/cert3',
        component: cert3,
    },
    {
        path: '/certificate/welfare',
        component: welfare,
    },
    {
        path: '/cms/activityDetail/:id/',
        component: activity,
    },
    {
        path: '/cms/activitySign',
        component: activitySign,
    },
    {
        path: '/cms/survey',
        component: surveyPage,
    },
    {
        path: '/cms/vote',
        component: votePage,
    },
    {
        path:'/mine/collect',
        component:collect
    },
    {
        path: '/mine/activityHistory',
        component: activityHistory,
    },
    {
        path:'/report/',
        component:report
    },
    {
        path:'/account',
        component:account
    },
    {
        path:'/download',
        component:download
    },
    {
        path:'/privacy',
        component:privacy
    },
    {
        path:'/coinRules',
        component:coinRules
    },
    {
        path:'/comment',
        component:comment
    },
    {
        path:'/focus',
        component:focus
    }

];
