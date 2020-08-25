
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/api/apis.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

//视频播放页面
class VideoPage extends StatefulWidget {

  final String title,articleId;

  const VideoPage({Key key,this.articleId,this.title}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new _VideoPagePage();
  }
}

class _VideoPagePage extends State<VideoPage>{

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
//  WorkArticleModel model;

  EstateBloc _workBloc;

  WorkArticleModel model;
  @override
  void initState() {
    super.initState();
    _workBloc = BlocProvider.of<EstateBloc>(context);
    _workBloc.getArticleVideoDetail(widget.articleId);
    //监听
    _workBloc.articleVideoReposStream.listen((val){
      if(ObjectUtil.isEmpty(model)){
        model = val;
        _videoPlayerController = VideoPlayerController.network(model.images[1]);
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          aspectRatio: 3 / 2,
          autoPlay: true,
          looping: false,
          // Try playing around with some of these other options:

          // showControls: false,
          // materialProgressColors: ChewieProgressColors(
          //   playedColor: Colors.red,
          //   handleColor: Colors.blue,
          //   backgroundColor: Colors.grey,
          //   bufferedColor: Colors.lightGreen,
          // ),
          // placeholder: Container(
          //   color: Colors.grey,
          // ),
          // autoInitialize: true,
        );

        _chewieController.addListener(listener);
        setState((){});
      }
    });
  }

  void listener() async{
    if(!_chewieController.isFullScreen){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]);
    }
  }

  @override
  void dispose() {
    _chewieController.removeListener(listener);
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.width / 3 * 2;
    print(widget.title);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ObjectUtil.isEmpty(model) ? Container(width: 0,):Column(
          children: <Widget>[
              Chewie(
                controller: _chewieController,
              ),
              Expanded(
                  child:WebWidgetUtils.getWebView(WanAndroidApi.ARTICLE_DETAIL_PREFIX+widget.articleId, height)
              ),
          ],
      )
    );
  }
}