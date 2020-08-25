import { callbackify } from "util";
import Exif from 'exif-js';

export default {
  showPicture: function (url, size, flag) {
    if (url.substring(-1, 4) != 'http') {
      size = 1;
      if (flag == false) {
        size = 0;
      }
    }

    if (size != undefined && size === 1) {
      if (url) {
        url = url.split(".")[0] + "Zoom." + url.split(".")[1];
        return !!url
          ? url.startsWith("http")
            ? url
            : "https://mongo.qicaidonghu.cn/pic/" + url
          // : "https://www.qicaidonghu.cn/pic/" + url
          : "";
      }

    }
    return !!url
      ? url.startsWith("http")
        ? url
        : "https://mongo.qicaidonghu.cn/pic/" + url
      // : "https://www.qicaidonghu.cn/pic/" + url

      : "";
  },
  //压缩图片
  reduceImage: function (file, callback) {
    let imgBase64 = '';
    let Orientation = null;

    Exif.getData(file.file, function () {
      Orientation = Exif.getTag(this, 'Orientation');

      // 创建Canvas对象(画布)
      let canvas = document.createElement('canvas')
      // 获取对应的CanvasRenderingContext2D对象(画笔)
      let context = canvas.getContext('2d')
      // 创建新的图片对象 
      let img = new Image()
      // 指定图片的DataURL(图片的base64编码数据)
      img.src = file.content
      // 监听浏览器加载图片完成，然后进行进行绘制

      img.onload = function () {
        // 指定canvas画布大小，该大小为最后生成图片的大小

        let width = this.width;
        let height = this.height;
        if (width < 600 || height < 600) {
          callback(file.content);
          return;
        }
        if (width > 4096 || height > 4096) {
          if (width > height) {
            width = 4096
            height = height / (width / 4096)
          } else if (width < height) {
            height = 4096
            width = width / (height / 4096)
          } else {
            height = 4096;
            width = 4096;
          }
        }
        canvas.width = width
        canvas.height = height
        /* drawImage画布绘制的方法。(0,0)表示以Canvas画布左上角为起点，400，300是将图片按给定的像素进行缩小。
        如果不指定缩小的像素图片将以图片原始大小进行绘制，图片像素如果大于画布将会从左上角开始按画布大小部分绘制图片，最后的图片就是张局部图。*/
        // context.drawImage(img, 0, 0, width, height);
        if (Orientation != "" && Orientation != 1 && Orientation != null && Orientation != 'undefined') {
          switch (Orientation) {
            case 6: //需要顺时针（向左）90度旋转
              context.rotate(90 * Math.PI / 180);
              context.drawImage(img, 0, -height, width, height);
              break;
            case 8: //需要逆时针（向右）90度旋转
              context.rotate(270 * Math.PI / 180);
              context.drawImage(img, i.width, 0, width, height);
              break;
            case 3: //需要180度旋转
              context.rotate(180 * Math.PI / 180);
              context.drawImage(img, width, height, width, height);
              break;
          }
        } else {
          context.drawImage(img, 0, 0, width, height);
        }
        // 将绘制完成的图片重新转化为base64编码，file.file.type为图片类型，0.92为默认压缩质量
        file.content = canvas.toDataURL(file.file.type, 0.6)
        // 最后将base64编码的图片保存到数组中，留待上传。
        imgBase64 = file.content;
        callback(imgBase64)
      }




    });


  },
  //旋转身份证拍照图片
  rotateImg: function (img, direction, canvas) {
    //最小与最大旋转方向，图片旋转4次后回到原方向 
    const min_step = 0;
    const max_step = 3;
    if (img == null) return;
    //img的高度和宽度不能在img元素隐藏后获取，否则会出错 
    let height = img.height;
    let width = img.width;
    let step = 2;
    if (step == null) {
      step = min_step;
    }
    if (direction == 'right') {
      step++;
      //旋转到原位置，即超过最大值 
      step > max_step && (step = min_step);
    } else {
      step--;
      step < min_step && (step = max_step);
    }
    //旋转角度以弧度值为参数 
    let degree = step * 90 * Math.PI / 180;
    let ctx = canvas.getContext('2d');
    switch (step) {
      case 0:
        canvas.width = width;
        canvas.height = height;
        ctx.drawImage(img, 0, 0);
        break;
      case 1:
        canvas.width = height;
        canvas.height = width;
        ctx.rotate(degree);
        ctx.drawImage(img, 0, -height);
        break;
      case 2:
        canvas.width = width;
        canvas.height = height;
        ctx.rotate(degree);
        ctx.drawImage(img, -width, -height);
        break;
      case 3:
        canvas.width = height;
        canvas.height = width;
        ctx.rotate(degree);
        ctx.drawImage(img, -width, 0);
        break;
    }
  },
  //获取token存放
  token: function (message) {
    window.localStorage.setItem("token_message", message);
  },
  removeClass: function (tagName, tagClass) {
    //tagName：标签；tagClass：类名
    let tagElements = document.getElementsByTagName(tagName);
    for (let m = 0; m < tagElements.length; m++) {
      if (tagElements[m].classList.contains(tagClass) == true) {
        tagElements[m].classList.remove(tagClass);//去除类名
      }
    }
  },
  //校验手机号
  checkPhone: function (phone, flag) {
    phone = phone || '';
    flag = flag || 1;
    if (flag == 1 && phone.indexOf('****') != -1)
      return true;
    var pattern = /^1[0-9]\d{9}$/;
    return pattern.test(phone);
  }

}
