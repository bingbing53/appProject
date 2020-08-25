
//获取链接里的值
function getUrlKey(name) {
    return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.href) || [, ""])[1].replace(/\+/g, '%20')) || null
}

//格式化图片地址
function formatPicture(url, size) {
    if (url == null || url.length <= 0 || url.startsWith("http")) {
        return "https://image.shequyijia.cn/xinyi/net/2018?src=" + url;
    }
    if (url) {
        if (size && size == 1) {
            // url =  url.replace('.png','Zoom.png').replace('.jpeg','Zoom.jpeg').replace('.jpg','Zoom.jpg')
            url = url.replace('.png', 'Zoom720.png').replace('.jpeg', 'Zoom720.jpeg').replace('.jpg', 'Zoom720.jpg')
        } else if (size && size == 3) {
            //不需要压缩
            url = url;
        } else {
            //默认
            url = url.replace('.png', 'Zoom.png').replace('.jpeg', 'Zoom.jpeg').replace('.jpg', 'Zoom.jpg')
            // url =  url.replace('.png','Zoom720.png').replace('.jpeg','Zoom720.jpeg').replace('.jpg','Zoom720.jpg')
        }
    }
    return "https://mongo.qicaidonghu.cn/pic/" + url;
    // return "https://image.shequyijia.cn/pic/" + url;
}
//距离格式化
function formatDistance(value) {
    if (value < 1) {
        value = value * 1000
        return value + '米'
    } else {
        return value + '公里'
    }
}
//判断代金券是否过期
function timeOVer(dataValue) {
    let timestamp = (new Date()).getTime();
    //传过来得日期转化为时间戳
    dataValue = new Date(dataValue).getTime()
    //比较
    if (dataValue < timestamp) {
        return 0
    }
}
function timeStampOVer(dataValue) {
    let timestamp = (new Date()).getTime();
    return dataValue < timestamp;
}
// 自定义标题 返回键
function onClickLeft() {
    // alert("点击了返回")
    wx.goBack()
}
/**
 * 返回文字描述的日期
 *
 * @param date
 * @return
 */
function getTimeFormatText(dateTimeStamp) {
    var dateTimeStamp2 = new Date(
        dateTimeStamp.replace(/-/g, "/")
    ).getTime();//转化为时间戳

    var result;
    var minute = 1000 * 60;      //把分，时，天，周，半个月，一个月用毫秒表示
    var hour = minute * 60;
    var day = hour * 24;
    var week = day * 7;
    var halfamonth = day * 15;
    var month = day * 30;
    var now = new Date().getTime();   //获取当前时间毫秒
    var diffValue = now - dateTimeStamp2;//时间差
    console.log(diffValue)
    if (diffValue < 0) {
        result = dateTimeStamp
        return result;
    } else {
        var minC = diffValue / minute;  //计算时间差的分，时，天，周，月
        var hourC = diffValue / hour;
        var dayC = diffValue / day;
        var weekC = diffValue / week;
        var monthC = diffValue / month;
        // console.log(monthC,weekC,dayC,hourC,minC)
        if (monthC >= 1) {
            result = " " + parseInt(monthC) + "月前"
        } else if (weekC >= 1 && weekC <= 5) {
            result = " " + parseInt(weekC) + "周前"
        } else if (dayC >= 1 && dayC <= 6) {
            result = " " + parseInt(dayC) + "天前"
        } else if (hourC >= 1 && hourC <= 23) {
            result = " " + parseInt(hourC) + "小时前"
        } else if (minC >= 1 && minC <= 59) {
            result = " " + parseInt(minC) + "分钟前"
        } else if (diffValue >= 0 && diffValue <= minute) {
            result = "刚刚"
        } else {
            var datetime = new Date();
            datetime.setTime(dateTimeStamp);
            var Nyear = datetime.getFullYear();
            var Nmonth = datetime.getMonth() + 1 < 10 ? "0" + (datetime.getMonth() + 1) : datetime.getMonth() + 1;
            var Ndate = datetime.getDate() < 10 ? "0" + datetime.getDate() : datetime.getDate();
            var Nhour = datetime.getHours() < 10 ? "0" + datetime.getHours() : datetime.getHours();
            var Nminute = datetime.getMinutes() < 10 ? "0" + datetime.getMinutes() : datetime.getMinutes();
            var Nsecond = datetime.getSeconds() < 10 ? "0" + datetime.getSeconds() : datetime.getSeconds();
            result = Nyear + "-" + Nmonth + "-" + Ndate
        }
        return result;
    }

}

//设置标题
function setTitle(title) {
    document.title = title;
}

//跳转登录或者完善信息页面
function jumpLogin(err) {
    if (err.status == 401) {
        wx.login(err.data);
    }
}

//身份证校验
var Wi = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1];    // 加权因子
var ValideCode = [1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2];            // 身份证验证位值.10代表X
function checkIdCard(idCard, flag) {
    idCard = idCard || '';
    flag = flag || 1;
    if (flag == 1 && idCard.indexOf("****") != -1) {
        return true;
    }
    idCard = trim(idCard.replace(/ /g, ""));               //去掉字符串头尾空格
    if (idCard.length == 15) {
        return isValidityBrithBy15IdCard(idCard);       //进行15位身份证的验证
    } else if (idCard.length == 18) {
        var a_idCard = idCard.split("");                // 得到身份证数组
        if (isValidityBrithBy18IdCard(idCard) && isTrueValidateCodeBy18IdCard(a_idCard)) {   //进行18位身份证的基本验证和第18位的验证
            return true;
        } else {
            return false;
        }
    } else {
        return false;
    }
}
/**
 * 判断身份证号码为18位时最后的验证位是否正确
 * @param a_idCard 身份证号码数组
 * @return
 */
function isTrueValidateCodeBy18IdCard(a_idCard) {
    var sum = 0;                             // 声明加权求和变量
    if (a_idCard[17].toLowerCase() == 'x') {
        a_idCard[17] = 10;                    // 将最后位为x的验证码替换为10方便后续操作
    }
    for (var i = 0; i < 17; i++) {
        sum += Wi[i] * a_idCard[i];            // 加权求和
    }
    var valCodePosition = sum % 11;                // 得到验证码所位置
    if (a_idCard[17] == ValideCode[valCodePosition]) {
        return true;
    } else {
        return false;
    }
}
/**
 * 验证18位数身份证号码中的生日是否是有效生日
 * @param idCard 18位书身份证字符串
 * @return
 */
function isValidityBrithBy18IdCard(idCard18) {
    var year = idCard18.substring(6, 10);
    var month = idCard18.substring(10, 12);
    var day = idCard18.substring(12, 14);
    var temp_date = new Date(year, parseFloat(month) - 1, parseFloat(day));
    // 这里用getFullYear()获取年份，避免千年虫问题
    if (temp_date.getFullYear() != parseFloat(year)
        || temp_date.getMonth() != parseFloat(month) - 1
        || temp_date.getDate() != parseFloat(day)) {
        return false;
    } else {
        return true;
    }
}
//去掉字符串头尾空格
function trim(str) {
    return str.replace(/(^\s*)|(\s*$)/g, "");
}

//添加*号
function plusXing(str, frontLen, endLen) {
    var len = str.length - frontLen - endLen;
    var xing = '';
    for (var i = 0; i < len; i++) {
        xing += '*';
    }
    return str.substring(0, frontLen) + xing + str.substring(str.length - endLen);
}
//根据id去重json数组
function uniqueArray(array, key) {
    var result = [array[0]];
    for (var i = 1; i < array.length; i++) {
        var item = array[i];
        var repeat = false;
        for (var j = 0; j < result.length; j++) {
            if (item[key] == result[j][key]) {
                repeat = true;
                break;
            }
        }
        if (!repeat) {
            result.push(item);
        }
    }
    return result;
}

export default {
    getUrlKey,
    formatPicture,
    getTimeFormatText,
    setTitle,
    jumpLogin,
    checkIdCard,
    plusXing,
    onClickLeft,
    formatDistance,
    timeOVer,
    timeStampOVer,
    uniqueArray
}