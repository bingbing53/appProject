
export 'package:helloworld/utils/shared_preferences_keys.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 用来做shared_preferences的存储
class DialogUtil {

  static int color = 0xFFF5534B;

  static void showDialogWarning(String text,BuildContext context){
    if(null!=text&&""!=text){
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(text),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text('确定',style: new TextStyle(fontFamily: '思源黑体',color:Colors.white,fontSize: 16.0)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              )
          );
        },
      );
    }

  }
}