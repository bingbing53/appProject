import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/res/res_index.dart';

enum ConfrimType{
  info,warning,error
}

class SimpleDialogUtil{

  static void alert(message){
    AlertDialog dialog = new AlertDialog(
      backgroundColor: Colours.transparent_80,
      content: new Text(
        message,
        style: new TextStyle(fontSize: 30.0, color: Colors.red),
      ),
    );
  }

  static void showDialogs(contexts,String title,String content){
    showDialog<void>(
      context: contexts,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void showModalBottom(context,widget,title){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return new Container(
            color: Colors.white,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(title,style: TextStyle(fontSize: Dimens.font_sp16),),
                ),

                widget
              ],
            )
          );
        }
    );
  }

  /**
   * 展示自定义的组件内容
   */
  static void confirmDialogCustomWidget(context,confirm,{String title = '提示',Widget content,String cancelText = '取消',String confirmText = '确认',ConfrimType confirmType = ConfrimType.info,cancel}){

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: content,
//            actions: <Widget>[
//              CupertinoDialogAction(
//                child: Text(cancelText),
//                onPressed: () {
//                  Navigator.pop(context);
//                  cancel();
//                },
//              ),
//              CupertinoDialogAction(
//                child: new Text(confirmText,style: TextStyle(color: confirmType == ConfrimType.warning ? Colors.redAccent:Colors.blueAccent),),
//                onPressed: () async {
//                  Navigator.of(context).pop();
//                  confirm();
//                },
//              ),
//            ],
          );
        }
    );
  }

  static void confirmDialog(context,confirm,{String title = '提示',String content,String cancelText = '取消',String confirmText = '确认',ConfrimType confirmType = ConfrimType.info,cancel}){

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(content, style: TextStyle(fontSize: Dimens.font_sp14),),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(cancelText),
                onPressed: () {
                  Navigator.pop(context);
                  cancel();
                },
              ),
              CupertinoDialogAction(
                child: new Text(confirmText,style: TextStyle(color: confirmType == ConfrimType.warning ? Colors.redAccent:Colors.blueAccent),),
                onPressed: () async {
                  Navigator.of(context).pop();
                  confirm();
                },
              ),
            ],
          );
        }
    );
    return;
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
            title: new Text(title),
            content: new Text(content),
            actions:<Widget>[
              new FlatButton(child:new Text(cancelText), onPressed: (){
                Navigator.of(context).pop();
                if(cancel != null)
                  cancel();
              },),
              new FlatButton(child:new Text(confirmText,style: TextStyle(color: confirmType == ConfrimType.warning ? Colors.redAccent:Colors.blueAccent),), onPressed: (){
                Navigator.of(context).pop();
                confirm();
              },)
            ]

        ));
  }

  static void createGroupDialog(context,confirm,title,confirmText,placeHolder){
    des='';
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
            title: new Text(title),
            content: createForm(placeHolder),
            actions:<Widget>[
              new FlatButton(child:new Text('取消'), onPressed: (){
                Navigator.of(context).pop();
              },),
              new FlatButton(child:new Text(confirmText), onPressed: (){
                if(des.trim() != ''){
                  Navigator.of(context).pop();
                  confirm(des);
                }else{
                  Fluttertoast.showToast(msg: placeHolder);
                }
              },)
            ]

        ));
  }

  static void confirmCustomDialog(context,confirm,title,widget){
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
//            backgroundColor: Colors.transparent,
            title: new Text(title,style: TextStyle(color: Colours.text_gray),),
            content: widget,
            actions:<Widget>[
              new FlatButton(child:new Text('取消'), onPressed: (){
                Navigator.of(context).pop();
              },),
              new FlatButton(child:new Text('确定'), onPressed: (){
                  Navigator.of(context).pop();
                  confirm();
              },)
            ]
        ));
  }

  static void confirmCustomDialogChoise(context,confirm,title,widget){
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
            backgroundColor: Colors.transparent,
            title: new Text(title,style: TextStyle(color: Colours.text_gray),),
            content: widget,
        ));
  }

  static String name='',des='';
  //创建一个表单，用于填入内容
  static Widget createForm(placeHolder){
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            TextField(
              maxLines: 2,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: placeHolder,
              ),
              autofocus: false,
              onChanged: (val){
                des = val;
              },
            ),
          ],
        ),
      )
    );
  }

  static void showNewVersionAppDialog(context,VersionModel version,{confirm}) async {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {

          return CupertinoAlertDialog(
            title: Text(version.title??'新版本升级'),
            content: Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(version.content,style: TextStyle(fontSize: Dimens.font_sp14),),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("稍后"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text("下载新版本"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  confirm();
                },
              ),
            ],
          );

          return AlertDialog(
            title: new Row(
              children: <Widget>[
                new Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                    child: new Text(version.title??'新版本升级',))
              ],
            ),
            content: Container(
              width: MediaQuery.of(context).size.width-40,
              child: new Text(version.content),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('稍候',style: TextStyle(color: Colours.text_gray),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('下载新版本'),
                onPressed: () async {
//                  NavigatorUtil.launchInBrowser(version.url, title: version.title);
                  Navigator.of(context).pop();
                  confirm();
                },
              )
            ],
          );
        });
  }

//  static void showNewVersionAppDialog(context,VersionModel version,{confirm}) async {
//    showDialog<void>(
//        context: context,
//        barrierDismissible: false,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            title: new Row(
//              children: <Widget>[
////                new Image.asset("images/ic_launcher_icon.png",
////                    height: 35.0, width: 35.0),
//                new Padding(
//                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
//                    child: new Text(version.title??'新版本升级',))
//              ],
//            ),
//            content: Container(
//              width: MediaQuery.of(context).size.width-40,
//              child: new Text(version.content),
//            ),
//            actions: <Widget>[
//              new FlatButton(
//                child: new Text('稍候',style: TextStyle(color: Colours.text_gray),),
//                onPressed: () {
//                  Navigator.of(context).pop();
//
//                  SpUtil.putString(version.version, '0');
//                },
//              ),
//              new FlatButton(
//                child: new Text('下载新版本'),
//                onPressed: () {
//                  NavigatorUtil.launchInBrowser(version.url, title: version.title);
//                  Navigator.of(context).pop();
//                  confirm();
//                },
//              )
//            ],
//          );
//        });
//  }

}