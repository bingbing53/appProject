new Vue({
    el: '#app',
    data() {
        return {
            num:0,
            garbageImgList: [{
                    label: 1,
                    url: 'img/垃圾_slices/1.png'
                },
                {
                    label: 2,
                    url: 'img/垃圾_slices/2.png'
                },
                {
                    label: 3,
                    url: 'img/垃圾_slices/3.png'
                },
                {
                    label: 4,
                    url: 'img/垃圾_slices/4.png'
                },
                {
                    label: 2,
                    url: 'img/垃圾_slices/5.png'
                },
                {
                    label: 1,
                    url: 'img/垃圾_slices/6.png'
                },
                {
                    label: 2,
                    url: 'img/垃圾_slices/7.png'
                },
                {
                    label: 3,
                    url: 'img/垃圾_slices/8.png'
                },
                {
                    label: 4,
                    url: 'img/垃圾_slices/8.png'
                },
                {
                    label: 3,
                    url: 'img/垃圾_slices/图层 10.png'
                }
            ],
            // label: this.garbageImgList[0].label
            trueDialogMsg:false,
            flaseDialogMsg:false,
        }
    },
    methods: {
        goGamePage() {
            window.open('gamePage.html');
        },
        fn(){
            console.log("动画重复播放");
        },
        fnStart(){
            console.log("动画开始了");
        },
        fnEnd(){
            console.log("动画结束了");
            var oBox = document.querySelector('img');
            oBox.style.cssText = "top:0px;left:0px;";
        },
        // 渲染html
        renderImg(){
            $('#img').remove();
            var tmpl =`<img ref="img" src="${this.garbageImgList[this.num].url}" alt="${this.garbageImgList[this.num].label}" id="img">`
            $('.game-middle').prepend(tmpl);
        },
        //垃圾桶对应的飞入动画
        goGarbage(id) {
            let that = this;

            let label = id.currentTarget.id
            console.log(label,'垃圾桶id')

            let msg= $('#img').attr("alt")
            console.log(msg,'垃圾的id')
            
            if (msg == label) {
               //提示信息
                this.trueDialogMsg=true
                //定时器，1秒后消失
                setTimeout(() => { 
                    this.trueDialogMsg=false
                },500);
                if(label == 1){
                    var top = $('#1').offset().top;
                    var left = $('#1').offset().left;
                    $('#img').animate({
                        'top': top - $('#1').height() / 2 + 'px',
                        'left': left - $('#1').width() / 2 + 'px',
                        'width': '0.1%',
                        'height': '0.1%'
                    }, function () {
                        that.num++;
                        that.$nextTick(() => {
                            $('.imgcontent').empty();
                            that.renderImg()
                            console.log(that.garbageImgList[that.num].url)
                            that.$forceUpdate()
                        })                      
                        // $('#img').css('display', 'none');
                        // $('#img').css('opacity', 0)
                    })
                }else if(label == 2){
                    var top = $('#2').offset().top;
                    var left = $('#2').offset().left;
                    $('#img').animate({
                        'top': top - $('#2').height() / 2 + 'px',
                        'left': left - $('#2').width() / 2 + 'px',
                        'width': '0.1%',
                        'height': '0.1%'
                    }, function () {
                        that.num++;
                        that.$nextTick(() => {
                            $('.imgcontent').empty();
                            that.renderImg()
                            console.log(that.garbageImgList[that.num].url)
                            that.$forceUpdate()
                        })
                      
                        // $('#img').css('display', 'none');
                        // $('#img').css('opacity', 0)
                    })
                }else if(label == 3){
                    var top = $('#3').offset().top;
                    var left = $('#3').offset().left;
                    $('#img').animate({
                        'top': top - $('#3').height() / 2 + 'px',
                        'left': left - $('#3').width() / 2 + 'px',
                        'width': '0.1%',
                        'height': '0.1%'
                    }, function () {
                        that.num++;
                        that.$nextTick(() => {
                            $('.imgcontent').empty();
                            that.renderImg()
                            console.log(that.garbageImgList[that.num].url)
                            that.$forceUpdate()
                        })
                    })
                }else if(label == 4){
                    var top = $('#4').offset().top;
                    var left = $('#4').offset().left;
                    $('#img').animate({
                        'top': top - $('#4').height() / 2 + 'px',
                        'left': left - $('#4').width() / 2 + 'px',
                        'width': '0.1%',
                        'height': '0.1%'
                    }, function () {
                        that.num++;
                        that.$nextTick(() => {
                            $('.imgcontent').empty();
                            that.renderImg()
                            console.log(that.garbageImgList[that.num].url)
                            that.$forceUpdate()
                        })
                    })
                }
            } else {
                console.log("很遗憾，打错了")
                this.flaseDialogMsg=true
                setTimeout(() => { 
                    this.flaseDialogMsg=false                 
                },500);
                if(label == 1){
                    var top = $('#1').offset().top;
                    var left = $('#1').offset().left;
                    $('#img').animate({
                        'top': top - $('#1').height() / 2 + 'px',
                        'left': left - $('#1').width() / 2 + 'px',
                        'width': '0.1%',
                        'height': '0.1%'
                    }, function () {
                        that.num++;
                        that.$nextTick(() => {
                            $('.imgcontent').empty();
                            that.renderImg()
                            console.log(that.garbageImgList[that.num].url)
                            that.$forceUpdate()
                        }) 
                    })
                }else if(label == 2){
                    var top = $('#2').offset().top;
                    var left = $('#2').offset().left;
                    $('#img').animate({
                        'top': top - $('#2').height() / 2 + 'px',
                        'left': left - $('#2').width() / 2 + 'px',
                        'width': '0.1%',
                        'height': '0.1%'
                    }, function () {
                        that.num++;
                        that.$nextTick(() => {
                            $('.imgcontent').empty();
                            that.renderImg()
                            console.log(that.garbageImgList[that.num].url)
                            that.$forceUpdate()
                        })
                    })
                }else if(label == 3){
                    var top = $('#3').offset().top;
                    var left = $('#3').offset().left;
                    $('#img').animate({
                        'top': top - $('#3').height() / 2 + 'px',
                        'left': left - $('#3').width() / 2 + 'px',
                        'width': '0.1%',
                        'height': '0.1%'
                    }, function () {
                        that.num++;
                        that.$nextTick(() => {
                            $('.imgcontent').empty();
                            that.renderImg()
                            console.log(that.garbageImgList[that.num].url)
                            that.$forceUpdate()
                        })
                    })
                }else if(label == 4){
                    var top = $('#4').offset().top;
                    var left = $('#4').offset().left;
                    $('#img').animate({
                        'top': top - $('#4').height() / 2 + 'px',
                        'left': left - $('#4').width() / 2 + 'px',
                        'width': '0.1%',
                        'height': '0.1%'
                    }, function () {
                        that.num++;
                        that.$nextTick(() => {
                            $('.imgcontent').empty();
                            that.renderImg()
                            console.log(that.garbageImgList[that.num].url)
                            that.$forceUpdate()
                        })
                    })
                }
            }
        },
    },
    watch: {

    },
    mounted() {
        var oBox = document.querySelector('img');
        oBox.addEventListener("animationstart", this.fnStart, false);
        oBox.addEventListener("webkitAnimationStart", this.fnStart, false);
        oBox.addEventListener("animationend", this.fnEnd, false);
        oBox.addEventListener("webkitAnimationIteration", this.fn, false);
        oBox.addEventListener("animationiteration", this.fn, false);
        oBox.addEventListener("webkitAnimationEnd", this.fnEnd, false);
        console.log(this.garbageImgList[this.num].url)
    }
})
