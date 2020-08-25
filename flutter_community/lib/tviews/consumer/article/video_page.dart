import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helloworld/components/first_page_item.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/tviews/webview/webview_flutter.dart';
import 'package:helloworld/components/disclaimer_msg.dart';
import 'package:helloworld/utils/utils.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:convert';

const int ThemeColor = 0xFFF5534B;
GlobalKey<DisclaimerMsgState> key;

class VideoDetailPage extends StatefulWidget {
  String id;
  var video;
  VideoDetailPage(this.id,this.video);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}
class _VideoDetailPageState extends State<VideoDetailPage> {

  var _videoPlayerController,_chewieController;

  @override
  void initState() {
    super.initState();

    var video = json.decode(widget.video);
    print(Api.formatPicture(video['video']));
    _videoPlayerController = new VideoPlayerController.network(Api.formatPicture(video['video']));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: false,
    );

  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('视频播放'),
          flexibleSpace: Image(
            image: AssetImage(Utils.getImgPath('home_top')),
            fit: BoxFit.cover,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new Chewie(
                  controller: _chewieController
              ),
            ),
            Expanded(
                child: WebViewFlutterPage(url:"/#/cms/articleDetail/${widget.id}/",showTitle: false)
            )
          ],
        )
    );
  }
}
