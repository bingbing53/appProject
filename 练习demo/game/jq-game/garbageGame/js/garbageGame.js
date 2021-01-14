var performAnimation = function () {
    // 动画结束事件监听 
    var oBox = document.querySelector('img');
    oBox.addEventListener("animationstart", fnStart, false);
    oBox.addEventListener("webkitAnimationStart", fnStart, false);
    oBox.addEventListener("animationend", fnEnd, false);
    oBox.addEventListener("webkitAnimationIteration", fn, false);
    oBox.addEventListener("animationiteration", fn, false);
    oBox.addEventListener("webkitAnimationEnd", fnEnd, false);

    function fn() {
        console.log("动画重复播放");
    }

    function fnStart() {
        console.log("动画开始了");
    }

    function fnEnd() {
        console.log("动画结束了");
        oBox.style.cssText = "top:0px;left:0px;";
    }
}
// 动画队列
// $('#1').click(function () {
//     var top = $(this).offset().top;
//     var left = $(this).offset().left;
//     $('#img').animate({
//         'top': top - $(this).height() / 2 + 'px',
//         'left': left - $(this).width() / 2 + 'px',
//         'width': '0.1%',
//         'height': '0.1%'
//     }, function () {
//         $('#img').css('display', 'none');
//         // $('#img').css('opacity', 0)
//     })
// })
//模拟数据var
var garbageImgList = [{
        label: 1,
        url: 'img/垃圾_slices/图层 1.png'
    },
    {
        label: 2,
        url: 'img/垃圾_slices/图层 12.png'
    },
    {
        label: 3,
        url: 'img/垃圾_slices/图层 3.png'
    },
    {
        label: 4,
        url: 'img/垃圾_slices/图层 18.png'
    },
    {
        label: 2,
        url: 'img/垃圾_slices/图层 25.png'
    },
    {
        label: 1,
        url: 'img/垃圾_slices/图层 26.png'
    },
    {
        label: 2,
        url: 'img/垃圾_slices/图层 7.png'
    },
    {
        label: 3,
        url: 'img/垃圾_slices/图层 8.png'
    },
    {
        label: 4,
        url: 'img/垃圾_slices/图层 19.png'
    },
    {
        label: 3,
        url: 'img/垃圾_slices/图层 10.png'
    }
];
$("#img").attr('src', garbageImgList[0].url);
// 点击垃圾桶
function goTrash() {
    garbageImgList.splice(0, 1);
    $("#img").attr('src', garbageImgList[0].url);
    console.log(11)
    $('#img').attr("style", "");
    console.log(22)
}