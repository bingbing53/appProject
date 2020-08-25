import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CommonUtils {

  static Future<Null> showLoadingDialog(BuildContext context, {msg}) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (contexts) {
          return new Material(
              color: Colors.transparent,
              child: WillPopScope(
                onWillPop: () => new Future.value(false),
                child: Center(
                  child: new Container(
                    width: 200.0,
                    height: 200.0,
                    padding: new EdgeInsets.all(4.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      //用一个BoxDecoration装饰器提供背景图片
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                            child: SpinKitRotatingCircle()),
                        new Container(height: 10.0),
                        new Container(
                            child: Text(msg)),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  static showModalActionSheet(context,title,List<String> options,callback) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(title),
          children:
            options.asMap().keys.map((value) {
              return SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  callback(value);
                },
                child: Text(options[value],style: TextStyle(fontSize: 17),),
              );
            }).toList()
        );
      },
    );
  }

}