
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:helloworld/blocs/bloc_index.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

//图片消息
class ImageMessage extends StatelessWidget{

  const ImageMessage({Key key, this.model,this.bloc}) : super(key: key);
  final JMImageMessage model;
  final MainBloc bloc;

  @override
  Widget build(BuildContext context) {
    String thumbPath = model.thumbPath;
    if(thumbPath == null || thumbPath == ''){
      bloc.downloadFile(model.id,JMMessageType.image);
      return StreamBuilder(
          stream: bloc.downloadThumbImageStream,
          builder: (BuildContext context,
              AsyncSnapshot<Map> snapshot) {
            if(snapshot.data == null){
              return Icon(Icons.cloud_done);
            }else{
              if(snapshot.data['messageId'] == model.id){
                return GestureDetector(
                  child:Image.file(File(snapshot.data['filePath']),width: 100.0,),
                  onTap: (){
                    print('图片地址2：$thumbPath');
                    NavigatorUtil.imagePreview(context,work:bloc,msgId: model.id,msgServerId:model.serverMessageId);
                  },
                );
//                return Image.file(File(snapshot.data['filePath']));
              }else{
                return Icon(Icons.cloud_done);
              }
            }
          });
    }else{
      return GestureDetector(
        child:Image.file(File(thumbPath),width: 100.0,),
        onTap: (){
          NavigatorUtil.imagePreview(context,work:bloc,msgId: model.id,msgServerId:model.serverMessageId);
        },
      );
    }
  }
}