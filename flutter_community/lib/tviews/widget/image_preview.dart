import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drag_scale/core/drag_scale_widget.dart';
import 'package:helloworld/blocs/main_bloc.dart';
import 'package:helloworld/tviews/widget/widgets.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

//图片浏览
class ImagePreview extends StatelessWidget{

  const ImagePreview({Key key, this.netSrc,this.localSrc,this.bloc,this.msgId,this.msgServerId}) : super(key: key);

  final String netSrc;
  final String localSrc;
  final MainBloc bloc;
  final String msgId,msgServerId;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: GestureDetector(
          child: showContent(),
          onTap: (){
            Navigator.pop(context);
          },
        )
    );
  }

  Uint8List loadData(String imagePath) {
    File file = File(imagePath);
    Uint8List bytes = file.readAsBytesSync();
    return bytes;
  }

  Widget showContent(){
    if(bloc != null){
      if(Platform.isAndroid) {
        bloc.downloadFile(msgServerId, JMMessageType.image, origin: '1');
      }else{
        bloc.downloadFile(msgId, JMMessageType.image, origin: '1');
      }
      return new StreamBuilder(
          stream: bloc.downloadOriginImageStream,
          builder: (BuildContext context,
              AsyncSnapshot<Map> snapshot) {
            if(snapshot.data == null){
              return Container(
                child: ProgressView(),
              );
            }
            if(snapshot.data['messageId'].toString() == msgId) {
              return Container(
                  color: Colors.black,
                  child: Center(
                    child: DragScaleContainer(
                        doubleTapStillScale: true,
                        child: Image.file(File(snapshot.data['filePath']))
                    ),
                  )
              );
            }else{
              return Container(
                child: ProgressView(),
              );
            }
          }
      );
    }else{
      return Container(
          color: Colors.black,
          child: Center(
            child: DragScaleContainer(
              doubleTapStillScale: true,
              child: localSrc != null ?
              Image.file(File(localSrc)):
              new CachedNetworkImage(
                fit: BoxFit.fitWidth,
                imageUrl: netSrc,
              ),
            ),
          )
      );
    }
  }

}