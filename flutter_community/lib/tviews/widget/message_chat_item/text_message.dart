
import 'package:flutter/material.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

//文字消息
class TextMessage extends StatelessWidget{
  const TextMessage({Key key, this.model}) : super(key: key);
  final JMTextMessage model;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: model.isSend ? const EdgeInsets.only(top:5.0,left: 55):const EdgeInsets.only(top:5.0,right: 55),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child:Container(
              color: model.isSend ? Colours.green_6a:Colors.white,
              padding: EdgeInsets.only(top:6.0,bottom: 6.0,left: 10.0,right: 10.0),
              child:new Text(model.text??' ',textAlign: TextAlign.justify),
            )
        )
    );
  }
}