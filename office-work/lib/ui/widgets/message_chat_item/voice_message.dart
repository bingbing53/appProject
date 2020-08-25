
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/blocs/bloc_index.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

//图片消息
class VoiceMessage extends StatelessWidget{

  const VoiceMessage({Key key, this.model,this.bloc}) : super(key: key);
  final JMVoiceMessage model;
  final WorkBloc bloc;

  @override
  Widget build(BuildContext context) {
    String path = model.path;
    if(path == null || path == ''){
      bloc.downloadFile(model.id,JMMessageType.voice);
      return StreamBuilder(
          stream: bloc.downloadThumbImageStream,
          builder: (BuildContext context,
              AsyncSnapshot<Map> snapshot) {
            if(snapshot.data == null){
              return Icon(Icons.keyboard_voice);
            }else{
              print('${snapshot.data['messageId']}  ${model.id}');
              if(snapshot.data['messageId'] == model.id){
                return Text('这是语音');
              }
            }
          });
    }else {
      return Container(child:
      GestureDetector(
        child: Row(
            mainAxisAlignment:model.isSend ? MainAxisAlignment.end: MainAxisAlignment.start,
            children: model.isSend ?
            <Widget>[
              Text('${model.duration~/1}″ ',style: TextStyle(color: Colours.text_gray),),
              ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child:Container(
                    color: Colours.green_6a,
                    padding: EdgeInsets.only(left:6.0+model.duration*3,right: 6.0,top: 4.0,bottom: 4.0),
                    child:Icon(Icons.surround_sound,color: Colours.divider,),
                  )
              ),
            ]:
            <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child:Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left:6.0,right: 6.0+model.duration,top: 4.0,bottom: 4.0),
                    child:Icon(Icons.surround_sound,color: Colours.divider,),
                  )
              ),
              Text(' ${model.duration~/1}″',style: TextStyle(color: Colours.text_gray),),
            ]
        ),
        onTap: (){
//          path = 'https://mongo.qicaidonghu.cn/pic/sound/7/10/631e367e-631e-4d87-9cb4-cbbf3c5ea884_1564564016.wav';
          bloc.startPlayer(path);
        },
      )
      );
    }
  }
}