var wx = {
    //返回上一页
    scanSuccess:null,
    scanError:null,
    scanQRCode:function(data){
        try {
            scanQRCode.postMessage(JSON.stringify(data));
            function success(val) {
                if (data.success != null)
                    data.success(val);
            }
            function error(val) {
                if (data.error != null)
                    data.error(val);
            }
            scanSuccess = success;
            scanError = error;
        }catch (e) {

        }
    },
    //返回上一页
    goBack:function(msg){
        try {
            goBack.postMessage(msg);
        }catch (e) {

        }
    },
    //返回上一页
    diaMobile:function(msg){
        try {
            diaMobile.postMessage(msg);
        }catch (e) {

        }
    },
    //弹出提示内容
    toast:function(msg){
        try {
            toast.postMessage(msg);
        }catch (e) {
            alert(msg);
        }
    },
    //加载中...
    loading:function(msg){
        try {
            loading.postMessage(msg);
        }catch (e) {
            
        }
    },
    //取消加载
    closeLoading:function(msg){
        try {
            closeLoading.postMessage(msg);
        }catch (e) {
            
        }
    },
    //分享微信
    share:function(msg){
        try {
            share.postMessage(JSON.stringify(msg));
        }catch (e) {
            
        }
    },

    //上传身份证人像面
    uploadIDCardSuccess:null,
    uploadIDCardError:null,
    uploadIDCard:function(data){
        try{
            uploadIDCard.postMessage(JSON.stringify(data));
            function success(val){
                if(data.success!=null)
                  data.success(val);
            }
            function error(val){
                if(data.error!=null)
                    data.error(val);
            }
             uploadIDCardSuccess=success;
             uploadIDCardError=error;
         }catch(e){

         }
    },
      //上传身份证国徽面
    reverseIDCardSuccess:null,
    reverseIDCardError:null,
    reverseIDCard:function(data){
        try{
            reverseIDCard.postMessage(JSON.stringify(data));
            function success(val){
                if(data.success!=null)
                  data.success(val);
            }
            function error(val){
                if(data.error!=null)
                    data.error(val);
            }
             reverseIDCardSuccess=success;
             reverseIDCardError=error;
         }catch(e){

         }
    },

    //人脸识别
    IdentifyFaceSuccess:null,
    IdentifyFaceError:null,
    IdentifyFace:function(data){
        try{
            IdentifyFace.postMessage(JSON.stringify(data));
            function success(val){
                if(data.success!=null)
                  data.success(val);
            }
            function error(val){
                if(data.error!=null)
                    data.error(val);
            }
             IdentifyFaceSuccess=success;
             IdentifyFaceError=error;
         }catch(e){

         }
    },



    //选择图片回调
    //success 成功回调
    //error  失败回调
    //source gallery 相册 camera 相机
    choiseImageSuccess:null,
    choiseImageError:null,
    choiseImage:function(data){
        try {
            chooseImage.postMessage(JSON.stringify(data));

            function success(val) {
                if (data.success != null)
                    data.success(val);
            }

            function error(val) {
                if (data.error != null)
                    data.error(val);
            }

            choiseImageSuccess = success;
            choiseImageError = error;
        }catch (e) {
            
        }
    },
    //多选照片
    //success 成功回调
    //error 失败回调
    choiseMultiImageSuccess:null,
    choiseMultiImageError:null,
    choiseMultiImage:function(data){
        try {
            choiseMultiImage.postMessage(JSON.stringify(data));

            function success(val) {
                if (data.success != null)
                    data.success(val);
            }

            function error(val) {
                if (data.error != null)
                    data.error(val);
            }
            choiseMultiImageSuccess = success;
            choiseMultiImageError = error;
        }catch (e) {

        }
    },
    //获取地理位置信息
    geoLocationSuccess:null,
    geoLocationError:null,
    geoLocation:function(data){
        try {
            geoLocation.postMessage(JSON.stringify(data));

            function success(result) {
                if (data.success != null) {
                    data.success(result);
                }
            }

            function error(err) {
                if (data.error != null)
                    data.error(val);
            }

            geoLocationSuccess = success;
            geoLocationError = error;
        }catch (e) {
            
        }
    },
    //状态栏
    toolBar:function(data){
        try {
            toolBar.postMessage(JSON.stringify(data));
        }catch (e) {
            
        }
    },
    //支付
    // wx.pay({
    //
    // })
    //payment wxpay 微信支付 alipay 支付宝支付
    //orderId 订单编号
    //orderType 订单类型
    paySuccess:null,
    payError:null,
    pay:function(data){
        try {
            pay.postMessage(JSON.stringify(data));

            function success(result) {
                if (data.success != null) {
                    data.success(rersult);
                }
            }

            function error(err) {
                if (data.error != null) {
                    data.error(err);
                }
            }

            paySuccess = success;
            payError = error;
        }catch (e) {
            
        }
    },
    //打开聊天消息
    //username 对方的手机号
    //app   office 掌上办公  estate  物业
    contact:function(data){
        try {
            contact.postMessage(JSON.stringify(data));
        }catch (e) {
            
        }
    },
    //登录app
    login:function(data){
        try {
            login.postMessage(data);
        }catch (e) {
            
        }
    },
    //关闭webview
    popPage:function(msg = 0){
        try{
            navigatorpop.postMessage(msg);
        }catch (e) {

        }
    },
    //跳转原生app页面
    jumpPage:function(msg){
        try{
            jumpAppPage.postMessage(JSON.stringify(msg));
        }catch (e) {

        }
    },
    //替换原生app页面
    replacePage:function(msg){
        try{
            replaceAppPage.postMessage(JSON.stringify(msg));
        }catch(e){

        }
    },
    //搜索
    searchSuccess:null,
    search:function(data){
      try{
          // search.postMessage(JSON.stringify(data));
          function success(result) {
              if (data.success != null) {
                  data.success(result);
              }
          }
          searchSuccess = success;
      }catch (e) {

      }
    },
    //加载完成后回调
    init:function(success){
        success();
    }
}