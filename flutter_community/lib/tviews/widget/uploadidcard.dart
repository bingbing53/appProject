import 'dart:async';
// base64库
//import 'dart:convert' as convert;
import 'dart:convert';
// 文件相关
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:helloworld/tviews/widget/mywebview.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:photo_manager/photo_manager.dart';

class uploadIDCard extends StatefulWidget {

  final String type;

  const uploadIDCard({Key key, this.type}) : super(key: key);

  @override
  _uploadIDCardState createState() {
    return _uploadIDCardState();
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

// ignore: camel_case_types
class _uploadIDCardState extends State<uploadIDCard> {
  CameraController controller;
  String videoPath;

  Future<bool> goBackPage() async{
    controller?.dispose();
    controller = null;
    Navigator.pop(context,'-1');
    return Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    getCameras(widget.type == 'face' ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: goBackPage,
        child: SafeArea(child: Scaffold(
            body: new Container(
              color: Colors.blueAccent,
              child:new Stack(children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: new Stack(children: <Widget>[
                    _cameraPreviewWidget(),//相机视图
                    _cameraFloatImage(),//悬浮的身份证框图
                  ]),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height / 7,
                  child: _takePictureLayout(),
                ),
                getPhotoPreview(),
              ]),
            )
          )
        )
    );
  }

 //拍照操作区域布局
  Widget _takePictureLayout(){
    return new Align(
        alignment: Alignment.bottomCenter,
        child: new Container(
          color: Colors.blueAccent,
          alignment: Alignment.center,
          child:  photoPath != null ? Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Text('取消',style: TextStyle(fontSize: Dimens.font_sp18,color: Colors.white),textAlign: TextAlign.center,),
                  onTap: (){
                    Navigator.pop(context,'-1');
                  },
                )
              ),
              Expanded(
                  child: GestureDetector(
                    child: Text('确定',style: TextStyle(fontSize: Dimens.font_sp20,color: Colors.white),textAlign: TextAlign.center,),
                    onTap: () async {
                      File compressedFile = await FlutterNativeImage.compressImage(photoPath, quality: 70, percentage: 60);
                      List<int> imageBytes = await compressedFile.readAsBytes();
                      Navigator.pop(context, base64Encode(imageBytes));
                    },
                  )
              ),
              Expanded(
                child: GestureDetector(
                  child:Text('重拍',style: TextStyle(fontSize: Dimens.font_sp18,color: Colors.white),textAlign: TextAlign.center),
                  onTap: (){
                    photoPath = null;
                    setState((){});
                  },
                )
              ),
            ],
          ):Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Text('关闭',style: TextStyle(fontSize: Dimens.font_sp16,color: Colors.white),textAlign: TextAlign.center),
                  onTap: (){
                    Navigator.pop(context,'-1');
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: new IconButton(
                  iconSize: 50.0,
                  onPressed: controller != null &&
                      controller.value.isInitialized &&
                      !controller.value.isRecordingVideo
                      ? onTakePictureButtonPressed
                      : null,
                  icon: Icon(
                    Icons.photo_camera,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: new SizedBox()
              )
            ],
          )
        ));
  }


  //悬浮的身份证框图
  Widget _cameraFloatImage(){
    String imageAsset = "";
    if(widget.type == 'face'){
      imageAsset = 'assets/images/bg_identify_head.png';
    }else if(widget.type == 'faceIdcard'){
      imageAsset = 'assets/images/bg_identify_idcard.png';
    }else if(widget.type == 'countryIdcard'){
      imageAsset = 'assets/images/bg_identify_qrcode.png';
    }
    return new Positioned(
        child: new Container(
          margin: const EdgeInsets.fromLTRB(50, 100, 50, 50),
          child:new Image.asset(imageAsset),
        )
    );
  }


  //相机视图
  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return new Container(
        width:double.infinity,
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      );
    }
  }

String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
void showInSnackBar(String message) {
//    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }


void onNewCameraSelected(CameraDescription cameraDescription) async {
  if (controller != null) {
    await controller.dispose();
  }
  controller = CameraController(cameraDescription, ResolutionPreset.high);
  // If the controller is updated then update the UI.
  controller.addListener(() {
    if (mounted) setState(() {});
    if (controller.value.hasError) {
      showInSnackBar('Camera error ${controller.value.errorDescription}');
    }
  });
  try {
    await controller.initialize();
  } on CameraException catch (e) {
    _showCameraException(e);
  }
  if (mounted) {
    setState(() {

    });
  }
}


//拍照按钮点击事件实现
  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) async {
      if (mounted) {
        if (filePath != null) {
          showInSnackBar('Picture saved to $filePath');
          photoPath = filePath;
          setState((){});
        }
      }
    });
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }


List<CameraDescription> cameras;

bool showProgressDialog = false;
bool restart = false;
var photoPath;

Future<String> getTempDir() async {
  var dir = await path_provider.getTemporaryDirectory();
  var targetPath = dir.absolute.path + "/temp.png";
  return targetPath;
}


  //图片预览布局
  Widget getPhotoPreview(){
    if( null != photoPath){
      return new Container(
        width:double.infinity,
        height: double.infinity,
        color: Colors.black,
        alignment: Alignment.center,
        child: new Stack(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: Image.file(
                File(photoPath)
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 7,
            child: _takePictureLayout(),
          ),
        ]),
      );
    }else{
      return Container(
      );
    }
  }

  Future<void> getCameras(int type) async {
    try {
      cameras = await availableCameras();
      if(cameras != null && !cameras.isEmpty){
        onNewCameraSelected(cameras[type]);
      }
    } on CameraException catch (e) {
      print(e.toString());
    }
  }
}




