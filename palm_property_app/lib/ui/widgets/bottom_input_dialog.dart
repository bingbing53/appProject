
import 'dart:async';
import 'dart:io';

import 'package:estate/common/component_index.dart';
import 'package:estate/data/protocol/estate_models.dart';
import 'package:estate/res/res_index.dart';
import 'package:estate/ui/dialog/simple_dialog.dart';
import 'package:estate/ui/widgets/widget_index.dart';
import 'package:flutter/material.dart';

/**
 * 底部弹出输入框
 */
class BottomInputDialog extends StatelessWidget {

  final FeedBackModel feedBackModel;

  const BottomInputDialog({Key key, this.feedBackModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controllerName = new TextEditingController();
    final WorkBloc bloc = BlocProvider.of<WorkBloc>(context);
    final EstateBloc estateBloc = BlocProvider.of<EstateBloc>(context);
    List<File> files = [];
    StreamController<List<File>> stream = new StreamController();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          Expanded(
              child: GestureDetector(
                child: Container(
                  color: Colors.black54,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
          ),
          Container(
            color: Colors.black54,
            child: Container(
                height: 350,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(12),topRight: Radius.circular(12))
                ),
                padding: EdgeInsets.all(Dimens.gap_dp20),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('回复',style: TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp16,fontWeight: FontWeight.bold)),
                        SizedBox(width: Dimens.gap_dp10),
                        Text(feedBackModel.userName,style: TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp16,color: Colours.text_gray),),
                        Expanded(
                          child: GestureDetector(
                            child: Text('发送',style:TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp16,color: Colours.app_main),textAlign: TextAlign.end,),
                            onTap: (){
                              if(_controllerName.text == '' || _controllerName.text == null){
                                Fluttertoast.showToast(msg: '请输入回复内容');
                                return;
                              }
                              Loading.show(text:'加载中');
                              estateBloc.feedBackUser(feedBackModel.id,_controllerName.text,files).then((value){
                                Loading.close();
                                Navigator.pop(context,1);
                              }).catchError((err){
                                Loading.close();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: Dimens.gap_dp10),
                    TextField(
                        controller: _controllerName,
                        maxLines: 4,
                        autofocus: true,
                        style: TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp16, color: Colors.grey[900]),
                        decoration:
                        InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                            focusedBorder:UnderlineInputBorder(borderSide: BorderSide.none),
                            fillColor: Colours.gray_f5,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(vertical: Dimens.gap_dp10,horizontal: Dimens.gap_dp5),
                            hintText: "请输入回复内容",
                            hintStyle:TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp16,color: Colours.text_gray)
                        )
                    ),
                    SizedBox(height: Dimens.gap_dp10),
                    MySeparator(height: 1,),
                    GestureDetector(
                        child: Container(
                          width: double.infinity,
                          child: Text('添加照片',textAlign: TextAlign.right,),
                        ),
                        onTap: () {
                          if(files.length >= 3){
                            Fluttertoast.showToast(msg: "最多添加三张照片");
                            return;
                          }
//                      Widget item = Container(
//                        child: Column(
//                          children: <Widget>[
//                            ListTile(
//                              leading: Icon(Icons.photo_camera),
//                              title: Text('拍照'),
//                              onTap: () {
//                                Navigator.pop(context);
//                                bloc.imagePickerImage(ImageSource.camera).then((file){
//                                  if(ObjectUtil.isNotEmpty(file)) {
//                                    files.add(file);
//                                    stream.sink.add(files);
//                                  }
//                                });
//                              },
//                            ),
//                            Divider(height: 1.0,),
//                            ListTile(
//                              leading: Icon(Icons.photo_library),
//                              title: Text('相册'),
//                              onTap: () {
//                                Navigator.pop(context);
                          bloc.imagePickerImage(ImageSource.gallery).then((file){
                            if(ObjectUtil.isNotEmpty(file)) {
                              files.add(file);
                              stream.sink.add(files);
                            }
                          });
//                              }
//                            )
//                          ],
//                        ),
//                      );
//                      SimpleDialogUtil.showModalBottom(context, item, '添加照片');
                        }
                    ),
                    new StreamBuilder(stream:stream.stream,builder: (BuildContext context, AsyncSnapshot<List<File>> snapshot) {
                      if(snapshot.data == null){
                        return Container();
                      }
                      return Row(
                          children: files.asMap().keys.map((pos){
                            return GestureDetector(
                              child: Stack(
                                children: <Widget>[
                                  Image(
                                    image: new FileImage(files[pos]),
                                    repeat: ImageRepeat.noRepeat,
                                    width: (MediaQuery.of(context).size.width - 40) / 3,
                                    height: 100.0,
                                    fit: BoxFit.fill,
                                  ),
                                  Positioned(
                                    width: (MediaQuery.of(context).size.width - 40) / 3,
                                    height: 100.0,
                                    child: Container(
                                      color: Colours.transparent_40,
                                    ),
                                  ),
                                  Positioned(
                                    child: GestureDetector(
                                      child: Icon(Icons.close,color: Colors.redAccent,),
                                      onTap: (){
                                        files.removeAt(pos);
                                        stream.sink.add(files);
                                      },
                                    ),
                                  )
                                ],
                              ),
                              onTap: (){

                              },
                            );
                          }).toList()
                      );
                    }),


//                  Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Container(
//                            margin: EdgeInsets.all(Dimens.gap_dp10),
//                            child:
//                            TextField(
//                                controller: _controllerName,
//                                maxLines: 4,
//                                autofocus: true,
//                                style: TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp16, color: Colors.grey[900]),
//                                decoration:
//                                InputDecoration(
//                                    border: OutlineInputBorder(
//                                        borderRadius: BorderRadius.circular(20),
//                                        borderSide: BorderSide.none),
//                                    focusedBorder:UnderlineInputBorder(borderSide: BorderSide.none),
//                                    fillColor: Colours.gray_f5,
//                                    filled: true,
//                                    contentPadding: EdgeInsets.symmetric(vertical: Dimens.gap_dp10,horizontal: Dimens.gap_dp5),
//                                    hintText: "请输入回复内容",
//                                    hintStyle:TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp16,color: Colours.text_gray)
//                                )
//                            ),
//                        ),
//                        flex: 4,
//                      ),
//                      Expanded(
//                        child: MaterialButton(
//                          color: Colours.app_main,
//                          shape: const RoundedRectangleBorder(
//                              side: BorderSide.none,
//                              borderRadius: BorderRadius.all(
//                                  Radius.circular(Dimens.gap_dp10))),
//                          child: Text('发送', style: TextStyle(fontFamily: 'PingFang',
//                              fontSize: Dimens.font_sp16, color: Colors.white),),
//                          onPressed: () {
//                            Navigator.pop(context,_controllerName.text);
//                          },
//                        ),
//                        flex: 1,
//                      )
//                    ],
//                  )
                  ],
                )
            )
          ),
        ],
      ),
    );
  }
}