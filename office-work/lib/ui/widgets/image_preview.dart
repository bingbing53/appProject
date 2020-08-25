import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drag_scale/flutter_drag_scale.dart';
import 'package:flutter_wanandroid/blocs/work_bloc.dart';
import 'package:flutter_wanandroid/ui/widgets/widgets.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

//图片浏览
class ImagePreview extends StatelessWidget{

  const ImagePreview({Key key, this.netSrc,this.localSrc,this.bloc,this.msgId,this.msgServerId}) : super(key: key);

  final String netSrc;
  final String localSrc;
  final WorkBloc bloc;
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
    print(bytes.length);
    return bytes;
  }

  Widget showContent(){
//    ImageProvider imageProvider = new MemoryImage(loadData('/storage/emulated/0/DCIM/Camera/IMG_20190906_123511.jpg'));
//    return Container(
//      height: 100,
//      width: 100,
//      decoration: BoxDecoration(
//          image: DecorationImage(
//            image: imageProvider,
//            fit: BoxFit.cover,
//          )),
//    );
    if(bloc != null){
      print(msgId);
      bloc.downloadFile(msgServerId, JMMessageType.image,origin:'1');
      return new StreamBuilder(
          stream: bloc.downloadOriginImageStream,
          builder: (BuildContext context,
              AsyncSnapshot<Map> snapshot) {
            if(snapshot.data == null){
              return Container(
                child: ProgressView(),
              );
            }
            print(snapshot.data);
            print(snapshot.data['messageId'].toString() == msgId);
            print(msgId);
            if(snapshot.data['messageId'].toString() == msgId) {
              print('你好：${snapshot.data}');
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