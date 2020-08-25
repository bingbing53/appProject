
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/data/net/dio_util.dart';
import 'package:helloworld/data/protocol/consumer_models.dart';
import 'package:helloworld/res/colors.dart';

import 'installapk_utils.dart';

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
      if(cancelToken.isCancelled){
        Fluttertoast.showToast(msg: '下载取消');
      }else {
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
                cancelToken.cancel();
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