
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/net/dio_util.dart';
import 'package:estate/utils/installapk_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DownloadNewVersion extends StatefulWidget{

  final VersionModel versionModel;

  const DownloadNewVersion({Key key, this.versionModel}) : super(key: key);

  @override
  DownloadNewVersionState createState() => DownloadNewVersionState();
}


class DownloadNewVersionState extends State<DownloadNewVersion> {

  double process = 0;

  CancelToken cancelToken;

  @override
  void initState() {
    download();
    cancelToken = new CancelToken();
    super.initState();
  }

  Future download() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var savePath = '$tempPath/download/';
    final savedDir = Directory(savePath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    var apkPath = '${savePath}${new DateTime.now().millisecondsSinceEpoch}.apk';

    DioUtil().download(widget.versionModel.url, apkPath, onProgress: (count, total) {
      process = count / total;
      if (count >= total) {
        Navigator.pop(context);
        InstallApkUtils.install(apkPath);
      }
      if(mounted) setState(() {});
    },cancelToken: cancelToken).catchError((_) {
      print(_.type);
      if(_.type == DioErrorType.CANCEL){
        Fluttertoast.showToast(msg: '${_.message}');
      }else{
        Fluttertoast.showToast(msg: '网络异常，请稍后重试');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            Expanded(
              child: new LinearProgressIndicator(
                backgroundColor: Colours.transparent_30,
                value: process,
                valueColor: new AlwaysStoppedAnimation<Color>(CupertinoColors.activeBlue),
              ),
            ),
            SizedBox(width:5),
            Text('${(process * 100).toInt()}%')
          ],
        ),
        SizedBox(height: 20,),
        Row(
          children: <Widget>[
            Expanded(
              child: FlatButton(onPressed: (){
                cancelToken.cancel('下载取消');
                Navigator.pop(context);
              }, child: Text('取消下载',style: TextStyle(fontSize: Dimens.font_sp14,color: CupertinoColors.activeBlue),)),
              flex: 1,
            ),
            Expanded(
              child: FlatButton(onPressed: (){
                Fluttertoast.showToast(msg: '后台下载中，请稍候');
                Navigator.of(context).pop();
              }, child: Text('后台下载',style: TextStyle(fontSize: Dimens.font_sp14,color: CupertinoColors.activeBlue,),)),
              flex: 1,
            ),
          ],
        )
      ],
    );
  }
}