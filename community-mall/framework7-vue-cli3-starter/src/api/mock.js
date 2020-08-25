import Mock from 'mockjs' // 引入mockjs
const Random = Mock.Random // Mock.Random 是一个工具类，用于生成各种随机数据
let data = [] // 用于接受生成数据的数组
let size = [
    '300x250', '250x250', '240x400', '336x280',
    '180x150', '720x300', '468x60', '234x60',
    '88x31', '120x90', '120x60', '120x240',
    '125x125', '728x90', '160x600', '120x600',
    '300x600'
] // 定义随机值
for (let i = 0; i < 10; i++) { // 可自定义生成的个数
    let template = {
        'Float': Random.float(0, 100, 0, 5), // 生成0到100之间的浮点数,小数点后尾数为0到5位
        'Date': Random.date(), // 生成一个随机日期,可加参数定义日期格式
        'Image': Random.image(Random.size, '#02adea', 'Hello'), // Random.size表示将从size数据中任选一个数据
        'Color': Random.color(), // 生成一个颜色随机值
        'Paragraph': Random.paragraph(2, 5), //生成2至5个句子的文本
        'Name': Random.name(), // 生成姓名
        'Url': Random.url(), // 生成web地址
        'Address': Random.province() // 生成地址
    }
    data.push(template)
}
//进店商品列表mock
let goodsList = {
    "total": 30,
    "size": 10,
    "current": 1,
    "pages": 1,
    "records": []
};
for (let j = 0; j < 30; j++) {
    let goods = {
        'title': '地板清洁养护家家洁保洁',
        'sold': 1000,
        'appraise': 95,
        'price': 100,
        'public_price': 80,
        'public_money': 2,
        'image': Random.image(Random.size, '#02adea', 'Hello')
    }
    goodsList.records.push(goods)
}
//进店活动列表mock
let activityList = {
    "total": 30,
    "size": 10,
    "current": 1,
    "pages": 1,
    "records": []
};
for (let j = 0; j < 30; j++) {
    let activity = {
        'title': '高思英语培训试听活动',
        'address': Random.province() + '朝阳区望京新路',
        'status': '进行中',
        'enter': Random.float(0, 100, 0, 5),
        'total': 100,
        'image': Random.image(Random.size, '#02adea', 'Hello')
    }
    activityList.records.push(activity)
}
//商品点击进入界面mock
//头部轮播图
let swiperData = {
    swiperList: [],
    des: '底板清洁养护可对底板，地砖进行深度养护，减少木垫板划痕'
}
for (let k = 0; k < 5; k++) {
    let swiper = {
        'title': '高思英语培训试听活动',
        'url': Random.image(Random.size, '#02adea', 'Hello')
    }
    swiperData.swiperList.push(swiper)
}
//中间 价格和说明
let goodsDetail = {
    'price': 100,
    'public_price': 80,
    'public_money': 2,
    'serve_data': '最近可约20:00',
    'serve_des': '商家在1小时内接单，修改订单需提前2小时通知'
}
//用户评论
let usersComment = [{
    "comment": 4,
    "content": "服务很满意",
    "url": 'https://placeimg.com/80/80/people/1',
    "name": "周杰伦",
    "date": "2019-12-13"

},
{
    "comment": 5,
    "content": "服务很满意,谢谢",
    "url": 'https://placeimg.com/80/80/people/2',
    "name": "彭于晏",
    "date": "2019-12-14"

},
{
    "comment": 5,
    "content": "国家公祭日是一个国家为纪念曾经发生过的重大民族灾难而设立的国家纪念活动，由国家权力机关决定。",
    "url": 'https://placeimg.com/80/80/people/3',
    "name": "胡歌",
    "date": "2019-12-14"

}
]
//人气
let popularity = [];
for (let j = 0; j < 30; j++) {
    let poplist = {
        'title': '高思英语培训试听活动',
        'ticket': 100,
        'time_limit': '购买500元可使用，还剩10天过期',
    }
    popularity.push(poplist)
}
Mock.mock('/popularity/index', 'post', popularity)
Mock.mock('/comment/index', 'post', usersComment)
Mock.mock('/activity/index', 'post', activityList)
Mock.mock('/swiper/index', 'post', swiperData)
Mock.mock('/goodsDes/index', 'post', goodsDetail)
Mock.mock('/goods/index', 'post', goodsList)
Mock.mock('/data/index', 'post', data) // 根据数据模板生成模拟数据


