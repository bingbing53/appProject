
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/blocs/bloc_index.dart';
import 'package:flutter_wanandroid/res/res_index.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

//文字消息
class TextMessage extends StatelessWidget{
  const TextMessage({Key key, this.model,this.bloc}) : super(key: key);
  final JMTextMessage model;
  final WorkBloc bloc;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top:5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child:Container(
              color: model.isSend ? Colours.green_6a:Colors.white,
              padding: EdgeInsets.only(top:6.0,bottom: 6.0,left: 10.0,right: 10.0),
              child:new Text(model.text??' '),
            )
        )
    );
  }
}