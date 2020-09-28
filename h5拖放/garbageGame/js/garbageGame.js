new Vue({
    el: '#app',
    data() {
        return {
            num: 1,
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
                    url: 'img/垃圾_slices/11.png'
                },
                {
                    label: 2,
                    url: 'img/垃圾_slices/25.png'
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
                    url: 'img/垃圾_slices/18.png'
                },
                {
                    label: 4,
                    url: 'img/垃圾_slices/8.png'
                },
                {
                    label: 3,
                    url: 'img/垃圾_slices/31.png'
                }
            ],
            // label: this.garbageImgList[0].label
        }
    },
    methods: {
        fn() {
            console.log("动画重复播放");
        },
        fnStart() {
            console.log("动画开始了");
        },
        fnEnd() {
            console.log("动画结束了");
            var oBox = document.querySelector('img');
            oBox.style.cssText = "top:0px;left:0px;";
        },
        // 渲染html
        renderImg() {
            $('#img').remove();
            var tmpl = `<img ref="img" src="${this.garbageImgList[this.num].url}" alt="" id="img">`
            $('.game-middle').prepend(tmpl);
        },
        goGamePage() {
            window.open('gamePage.html');
        },
        goGarbage(id) {
            let that = this;
            let label = id.currentTarget.id
            console.log(label)
            let msg = this.garbageImgList[0].label
            if (msg == label) {
                console.log("恭喜你答对了")
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
            } else {
                console.log("很遗憾，打错了")
            }
            // this.garbageImgList.splice(0, 1);
            // console.log(this.garbageImgList)

        }
    },
    watch: {
        // label
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