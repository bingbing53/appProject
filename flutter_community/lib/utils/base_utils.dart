import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helloworld/common/net_utils.dart';
import 'package:helloworld/event/event-bus.dart';
import 'package:helloworld/event/event-model.dart';
import 'package:helloworld/res/dimens.dart';
import 'package:helloworld/tviews/webview/webview_flutter.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';
import 'package:helloworld/utils/navigator_util.dart';
/**
 * 基础功能性组件
 */
class BaseUtils {

  static String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  /**
   * 扫描二维码
   */
  static scanQRResult(String result,BuildContext context){
      if(result.startsWith("http")){
          if(result.contains('rest/wechat/wechatRouter/pages/mine/signin')){
            Uri u = Uri.parse(result);
            String code = u.queryParameters['code'];
            NavigatorUtil.pushPage(context, WebScaffold(url: '/#/cms/activitySign?code=${Uri.encodeComponent(code)}',title: ''),pageName: '二维码');
          }else if(result.contains('shequyijia.cn')){
            NavigatorUtil.pushPage(context, WebScaffold(url: result,title: '',),pageName: '二维码');
          }else{
            Fluttertoast.showToast(msg: '无效的链接');
          }
      }
  }

  /**
   * 手机号格式
   */
  static bool isChinaPhoneLegal(String str) {
    return new RegExp(
        '^((11[0-9])|(12[0-9])|(13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-8])|(18[0-9])|(19[0-9]))\\d{8}\$')
        .hasMatch(str);
  }

  /**
   * 身份证校验
   */
  static bool isCardId(String cardId){
    if (cardId.length != 18) {
      return false; // 位数不够
    }
    // 身份证号码正则
    RegExp postalCode = new RegExp(r'^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|[Xx])$');
    // 通过验证，说明格式正确，但仍需计算准确性
    if (!postalCode.hasMatch(cardId)) {
      return false;
    }
    //将前17位加权因子保存在数组里
    final List idCardList = ["7", "9", "10", "5", "8", "4", "2", "1", "6", "3", "7", "9", "10", "5", "8", "4", "2"];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    final List idCardYArray = ['1','0','10','9','8','7','6','5','4','3','2'];
    // 前17位各自乖以加权因子后的总和
    int idCardWiSum = 0;

    for (int i = 0; i < 17; i ++) {
      int subStrIndex = int.parse(cardId.substring(i,i+1));
      int idCardWiIndex = int.parse(idCardList[i]);
      idCardWiSum += subStrIndex * idCardWiIndex;
    }
    // 计算出校验码所在数组的位置
    int idCardMod = idCardWiSum % 11;
    // 得到最后一位号码
    String idCardLast = cardId.substring(17,18);
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if (idCardMod == 2){
      if (idCardLast != 'x' && idCardLast != 'X'){
        return false;
      }
    }else{
      //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
      if (idCardLast != idCardYArray[idCardMod]){
        return false;
      }
    }
    return true;
  }


  /**
   * md5校验
   */
  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  /**
   * 校验参数
   */
  static bool checkParam(String data,String placeholder){
    if(data == null || data.trim().length <= 0){
        showToast(placeholder);
        return false;
    }
    return true;
  }

  /**
   * 弹出弱提示
   */
  static void showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
    );
  }

  static void showConfirm(BuildContext context,String text,confirm){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('提示信息'),
            content: Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(text, style: TextStyle(fontSize: Dimens.font_sp16),),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('取消'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: new Text('确认'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  confirm();
                },
              ),
            ],
          );
        }
    );

//    showDialog<void>(
//      context: context,
//      barrierDismissible: false, // user must tap button!
//        builder: (_) => new AlertDialog(
//            title: new Text("提示信息"),
//            content: new Text(text),
//            actions:<Widget>[
//              new FlatButton(child:new Text("取消",style: TextStyle(color: Colors.grey),), onPressed: (){
//                Navigator.of(context).pop();
//
//              },),
//              new FlatButton(child:new Text("确认"),
////                color: Theme.of(context).primaryColor,
//                onPressed: (){
//                Navigator.of(context).pop();
//                confirm();
//              },)
//            ]
//        ));
  }

  static parseColor(String color,{double opacity}) {
    String hex = color.replaceAll("#", "");
    if (hex.isEmpty) hex = "FF3030";
    if (hex.length == 3) {
      hex ='${hex.substring(0, 1)}${hex.substring(0, 1)}${hex.substring(1, 2)}${hex.substring(1, 2)}${hex.substring(2, 3)}${hex.substring(2, 3)}';
    }
    return Color(int.parse(hex, radix: 16)).withOpacity(opacity??1.0);
  }

  /**
   * 获取用户的登录状态
   */
  static Future getLoginState(BuildContext context,{login}) async{
    var reponse = await NetUtils.post('appUser/loginStatus');
    if(reponse != 1 && login == 1){
      if (ApplicationEvent.event != null) {
        ApplicationEvent.event.fire(GotoLoginEvent('login'));
      }
    }
    return reponse == 1;
//      Navigator.of(context).pushAndRemoveUntil(
//          new MaterialPageRoute(builder: (context) => new LoginPage()
//          ), (route) => route == null);
//    }
  }
}