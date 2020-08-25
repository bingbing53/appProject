import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/common/net_utils.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/util_index.dart';
import 'package:qr_flutter/qr_flutter.dart';

/**
 * 二维码页面
 */
class QrCodePage extends StatefulWidget{

  final String data;

  const QrCodePage({Key key, this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new QrCodePageState();
  }

}

class QrCodePageState extends State<QrCodePage>{

  MainBloc _mainBloc;

  //获取qrcode
  Future _initQRCode() async{
    var result = _mainBloc.getMineQRCode();
    print(result);
    return result;
  }

  @override
  void initState() {
    _mainBloc = BlocProvider.of<MainBloc>(context);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 4 / 5;
    return Scaffold(
      appBar: AppBar(
        title: Text('我的二维码'),
      ),
      body: Center(
        child: new FutureBuilder(
          future: _initQRCode(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(ObjectUtil.isEmpty(snapshot.data)){
              return ProgressView();
            }
            print(snapshot.data);
            return QrImage(
              data: snapshot.data.toString(),
              version: QrVersions.auto,
              size: width,
              errorStateBuilder: (cxt, err) {
                return Container(
                  child: Center(
                    child: Text(
                      "二维码生成失败", textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            );
          },
        )
      )
    );
  }

}