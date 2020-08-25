import 'package:dio/dio.dart';
import 'package:helloworld/event/event-bus.dart';
import 'package:helloworld/event/event-model.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/utils/util_index.dart';
import 'package:helloworld/utils/base_utils.dart';

var dio = new Dio();

class NetUtils {

  static const String Base_URL = Api.BASE_URL;
  static const String GET = 'GET';
  static const String POST = 'POST';
  static const String PUT = 'PUT';
  static const String DELETE = 'DELETE';

  static Future get2(String url,{Map<String,dynamic> params}) async{
     var response = await dio.get(url, queryParameters: params);
     return  response.data;
  }

  static Future post2(String url,Map<String,dynamic> params) async{
    var response = await dio.post(url, data: params);
    return response.data;
  }

  //get请求
  static Future get(String url, {Map<String, dynamic> params}) async{
    return _request(url, method: GET, params: params);
  }

  //post请求
  static Future post(String url, {Map<String, dynamic> params}) async{
    return _request(url, method: POST, params: params);
  }

  //put请求
  static Future put(String url, {Map<String, dynamic> params}) async{
    return _request(url, method: PUT, params: params);
  }

  // 请求部分
  static Future _request(String url, {String method, Map<String, dynamic> params}) async {
    String tokens = SpUtil.getString('X-AUTH-TOKEN',defValue: '');
    print('tokens:$tokens');
    //拦截，获取是否需要登录
    if(tokens == ''){
      if(method == GET) {
        for (var i = 0; i < Api.GETNeedLogin.length; i++) {
          if (url.startsWith(Api.GETNeedLogin[i].toString())) {
            print('GET 需要登录   $url');
            if (ApplicationEvent.event != null) {
              ApplicationEvent.event.fire(GotoLoginEvent(url));
            }
            return null;
          }
        }
      }else if(method == POST){
        for (var i = 0; i < Api.POSTNeedLogin.length; i++) {
          if (url.startsWith(Api.POSTNeedLogin[i].toString())) {
            print('POST 需要登录   $url');
            if (ApplicationEvent.event != null) {
              ApplicationEvent.event.fire(GotoLoginEvent(url));
            }
            return null;
          }
        }
      }
      for(var i = 0;i<Api.ReturnNullValue.length;i++){
        if(url.startsWith(Api.ReturnNullValue[i].toString())){
          return null;
        }
      }
    }

    print('-------------------------请求开始----------------------------');
    print('请求链接:$url');
    print('请求方式:$method');
    print('请求参数:$params');
    int statusCode;

    if(null == tokens || tokens.length == 0){
      tokens = "1";
    }

    var street = SpUtil.getString(SharedPreferencesKeys.sysOrgCode,defValue: '');
    if(street == null || street == ''){
      street = 'A01';
    }
    if(params == null)
      params = {};
    params['street'] = street;
    Response response;
    try {
      var contentType;
      if(!url.startsWith("community-")) {
        contentType = new ContentType(
            'application', 'x-www-form-urlencoded', charset: 'utf-8');
      }else{
        contentType = new ContentType(
            'application', 'json', charset: 'utf-8');
      }
      BaseOptions options= new BaseOptions(
          connectTimeout:15000,
          receiveTimeout:15000,
          baseUrl: Base_URL,
          contentType: contentType,//new ContentType('application', 'x-www-form-urlencoded',charset: 'utf-8'),
          headers: {'isapp':'1','X-AUTH-TOKEN':tokens,"X-SYS-ORGCODE":street,'street':street}
      );
      print('header---${options.headers}');
      Dio dio = new Dio(options);
      if (method == GET) {
        response = await dio.get(url,queryParameters: params);
      } else if(method == PUT){
        response = await dio.put(url,data: params);
      } else {
        response = await dio.post(url,data: params);
      }
      print(response.statusCode);
      try{
        return json.decode(response.toString());
      }catch(e){
        e.toString();
        return response;
      }
    } on DioError catch (e) {
      if(null == e.response){
        BaseUtils.showToast('未知错误，请稍候重试');
      }else{
        statusCode = e.response.statusCode;
        if(statusCode == 401){
          if (ApplicationEvent.event != null) {
            ApplicationEvent.event.fire(GotoLoginEvent(e.response.data));
          }
        }else{
          BaseUtils.showToast(e.response.data);
        }
      }
    }
    return null;
  }

  static Future uploadFile(List<File> file) async{
    int statusCode;
    Map<String,dynamic> _form = {
      "street":"A01"
    };

    for(var i = 0;i<file.length;i++){
      _form['file$i'] = new UploadFileInfo(file[i], "test$i.jpg");
    }

    FormData formData = new FormData.from(_form);
    Response response;
    try {
      String tokens = SpUtil.getString('X-AUTH-TOKEN',defValue: "1");
      var street = SpUtil.getString(SharedPreferencesKeys.sysOrgCode,defValue: "A01");
      BaseOptions options= new BaseOptions(
          connectTimeout:60000,
          receiveTimeout:60000,
          baseUrl: Base_URL,
//          contentType: new ContentType('application', 'x-www-form-urlencoded',charset: 'utf-8'),
          headers: {'isapp':'1','X-AUTH-TOKEN':tokens,'street':street}
      );

      Dio dio = new Dio(options);
      response = await dio.post("wechatComm/upload", data: formData);
      print(response);
      try{
        return json.decode(response.toString());
      }catch(e){
        e.toString();
        return response;
      }
    } on DioError catch(e){
      e.toString();
      if(null == e.response){
        BaseUtils.showToast('未知错误，请稍候重试');
      }else{
        statusCode = e.response.statusCode;
        BaseUtils.showToast(e.response.data);
      }
    }
    return null;
  }

  //处理异常
  static void _handError(Function errorCallback,String errorMsg) {
    if (errorCallback != null) {
      errorCallback(errorMsg);
    }
  }

}