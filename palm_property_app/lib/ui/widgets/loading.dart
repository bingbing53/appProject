import 'package:estate/res/res_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Set dict = Set();
bool loadingStatus = false;
class Loading {
  static dynamic ctx;

  static void before(uri, text) {
    print(loadingStatus);
    print(dict);
    dict.add(uri); // 放入set变量中
    // 已有弹窗，则不再显示弹窗, dict.length >= 2 保证了有一个执行弹窗即可，
    if (loadingStatus == true || dict.length >= 2) {
      return ;
    }
    loadingStatus = true; // 修改状态
    // 请求前显示弹窗
    showDialog(
      context: ctx,
      builder: (context) {
        return Index(text: text);
      },
    );
  }

  static void complete(uri) {
    dict.remove(uri);
    // 所有接口接口返回并有弹窗
    if (dict.length == 0 && loadingStatus == true) {
      loadingStatus = false; // 修改状态
      // 完成后关闭loading窗口
      Navigator.of(ctx, rootNavigator: true).pop();
    }
  }

  static void show({String text = '加载中'}){
    loadingStatus = false;
    if (loadingStatus == true || dict.length >= 2) {
      return ;
    }
    loadingStatus = true; // 修改状态
    // 请求前显示弹窗
    showDialog(
      context: ctx,
      builder: (context) {
        return Index(text: text);
      },
    );
  }

  static void close(){
    if (loadingStatus == true) {
      loadingStatus = false; // 修改状态
      // 完成后关闭loading窗口
      Navigator.of(ctx, rootNavigator: true).pop();
    }
  }
}

// 弹窗内容
class Index extends StatelessWidget {
  final String text;

  Index({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // 设置透明背影
      body: Center(
        child: new Container(
          width: 200.0,
          height: 200.0,
          padding: new EdgeInsets.all(4.0),
          decoration: new BoxDecoration(
            color: Colors.black54,
            //用一个BoxDecoration装饰器提供背景图片
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                  child: SpinKitCircle(color: Colours.app_main,size: 60,)),
              new Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(text,style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }
}