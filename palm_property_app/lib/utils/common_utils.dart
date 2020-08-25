import 'package:estate/res/res_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CommonUtils {

  static Future showLoadingDialog(BuildContext context, {msg = '加载中'}) {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (contexts) {
          return new Material(
              color: Colors.transparent,
              child: WillPopScope(
                onWillPop: () => new Future.value(true),
                child: Center(
                  child: new SizedBox(
                    width: 180.0,
                    height: 180.0,
                    child:Container(
                      padding: new EdgeInsets.all(4.0),
                      decoration: ShapeDecoration(
                        color: Color(0xffffffff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                      ),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              child: SpinKitCircle(color: Colours.app_main,size: 60,)),
                          new Container(height: 10.0),
                          new Container(
                              child: Text(msg)),
                        ],
                      ),
                    )
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