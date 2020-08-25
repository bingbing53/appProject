<template>
  <a-modal title="点击选择正文图片" v-model="visible" width="800px">
    <template slot="footer">
      <a-button style="float:left" id="fileSelect" @click="openBrowse()">上传本地图片</a-button>
      <input type="file" id="fileElem" @change="changepic($event)" style="display:none" />
      <a-button @click="handleCancel">取消</a-button>
      <a-button type="primary" @click="handleOk">确定</a-button>
    </template>
    <div>
      <ul>
        <li
          v-for="(image,index) in imageArr"
          class="cover_inner"
          :data-index="index"
          @click="pickImg(image,index)"
          :class="image.checked == 1 ? 'addclass' : '' "
        >
          <p class="cover_p">
            <img :src="showPicture(image.url)" alt />
          </p>
        </li>
      </ul>
    </div>
  </a-modal>
</template>

<script>
export default {
  name: 'articleCover',
  data() {
    return {
      visible: false,
      CoverNum: '', //单图、三图
      content: '',
      imageArr: [], //编辑器中所有的图片数组
      checkedArr: [],
      isactive: -1
    }
  },
  methods: {
    showPicture(url){
      // if(url.indexOf('http') == 0)
      //   return 'https://image.shequyijia.cn/xinyi/net/2018?src='+url;
      // else
        return url
    },
    showModal() {
      this.visible = true
    },
    handleCancel() {
      this.visible = false
    },
    handleOk(e) {
      let that = this
      this.imageArr.forEach((img, idx) => {
        if (img.checked == 1) that.checkedArr.push(img)
      })
      // console.log(JSON.stringify(this.checkedArr))
      this.$emit('cover_ok', this.checkedArr)
      this.visible = false
    },
    getContent(content, CoverNum) {
      this.CoverNum = CoverNum
      this.checkedArr = []
      // console.log(JSON.stringify(this.imageArr))
      //保留编辑器中选中的图片
      for (let i = this.imageArr.length - 1; i >= 0; i--) {
        if (this.imageArr[i].checked == 0 && this.imageArr[i].type == 0) {
          this.imageArr.splice(i, 1)
        }
      }
      this.imageArr = this.imageArr.concat(this.recontent(content))
      // console.log(JSON.stringify(this.imageArr))
      // console.log(JSON.stringify(this.recontent(content)));
      //TODO 判断删除的是否是被选中的图片
      function unique(arr) {
        let result = []
        let obj = {}
        for (var i = 0; i < arr.length; i++) {
          if (!obj[arr[i].url]) {
            result.push(arr[i])
            obj[arr[i].url] = true
          }
        }
        return result
      }
      this.imageArr = unique(this.imageArr)
      // if(!!this.imageArr && this.imageArr.length > 0){
      //   this.imageArr.forEach(function (item) {
      //     item.url = 'https://image.shequyijia.cn/xinyi/net/2018?src='+item.url;
      //   })
      // }

      console.log(this.imageArr);
    },
    recontent(content) {
      if (
        content &&
        content.match(/src=['"]([^'"]+)[^>]*>/gi, '') != null &&
        content.match(/src=['"]([^'"]+)[^>]*>/gi, '') != 'null'
      ) {
        this.imageArr = content.match(/src=['"]([^'"]+)[^>]*>/gi, '')
        for (let i in this.imageArr) {
          let json = {
            url: '',
            base64:'',
            sourceUrl: '',
            checked: 0,
            type: 0
          }
          json.url = this.imageArr[i].match(/\bsrc\b\s*=\s*[\'\"]?([^\'\"]*)[\'\"]?/i)[1]
          if(json.url.startsWith(window._CONFIG['imageViewURL'])){
            json.url = json.url.replace(window._CONFIG['imageViewURL'],window.location.protocol+"//"+window.location.host+"/pic");
          }
          this.imageArr[i] = json
        }
        // console.log(JSON.stringify(this.imageArr))
      } else {
        this.imageArr = []
      }
      return this.imageArr
    },
    pickImg(item, index) {
      let that = this
      //单选
      if (this.CoverNum == 1) {
        this.imageArr.forEach((items, indexs) => {
          items.checked = 0
          let check = that.imageArr[index].checked
          that.imageArr[index].checked = 1
        })
        return
      }
      //三选
      if (this.CoverNum == 3) {
        if (this.imageArr[index].checked == 1) {
          this.imageArr[index].checked = 0
          return
        }
        let num = 0
        this.imageArr.forEach((img, idx) => {
          if (img.checked == 1) {
            num++
          }
        })
        if (num >= 3) {
          return
        }
        this.imageArr[index].checked = 1
      }
    },
    openBrowse() {
      var ie = navigator.appName == 'Microsoft Internet Explorer' ? true : false
      if (ie) {
        document.getElementById('fileElem').click()
      } else {
        var a = document.createEvent('MouseEvents')
        a.initEvent('click', true, true)
        document.getElementById('fileElem').dispatchEvent(a)
      }
    },
    changepic(event) {
      let files = event.target.files
      let newsrc = this.getObjectURL(files[0])
      let json = {
        url: newsrc,
        sourceUrl: '',
        checked: 0,
        type: 1
      }
      this.imageArr.push(json)
    },
    //建立一个可存取到该file的url
    getObjectURL(file) {
      let url = null
      // 下面函数执行的效果是一样的，只是需要针对不同的浏览器执行不同的 js 函数而已
      if (window.createObjectURL != undefined) {
        // basic
        url = window.createObjectURL(file)
      } else if (window.URL != undefined) {
        // mozilla(firefox)
        url = window.URL.createObjectURL(file)
      } else if (window.webkitURL != undefined) {
        // webkit or chrome
        url = window.webkitURL.createObjectURL(file)
      }
      return url
    },
    //去重数组保留未重复项
    array_diff(a, b) {
      for (var i = 0; i < b.length; i++) {
        for (var j = 0; j < a.length; j++) {
          if (a[j].url == b[i].url) {
            a.splice(j, 1)
            // j = j - 1
          }
        }
      }

      return a
    }
  }
}
</script>

<style lang="less" scoped>
.cover_inner {
  display: inline-block;
  width: 140px;
  height: 120px;
  list-style: none;
  border: 1px solid #e8e8e8;
  margin: 10px;
  cursor: pointer;
  .cover_p {
    width: 100%;
    height: 100%;
    position: relative;
    img {
      position: absolute;
      top: 0px;
      bottom: 0px;
      left: 0px;
      right: 0px;
      max-width: 100%;
      max-height: 100%;
      margin: auto;
    }
  }
}
.addclass {
  border: 1px solid #f40;
}
</style>