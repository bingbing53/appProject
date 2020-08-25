import 'package:flutter/material.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/webview/webview_flutter.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/components/first_page_item.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/common/util.dart';
import 'package:helloworld/tviews/consumer/article/video_page.dart';

class ListArticleViewItem extends StatefulWidget {
  final FirstPageItem item;
  final List<dynamic> commList;
  const ListArticleViewItem({Key key,this.item,this.commList}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListArticleViewItemState();

}

class _ListArticleViewItemState extends State<ListArticleViewItem> {

  void _launchURL(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    var title = widget.item.article_title;

    var create_name = widget.item.departName??'';

    if(widget.item.article_type == '0') {
      var images = widget.item.images,image = [];
      if (images != null && images.length > 0) {
        image = images.split(',');
      }
      if (image.length == 1) {
        return new GestureDetector(
          onTap: () => _onTap(context, widget.item),
          child: Container(
            color: Colors.white,
            margin: new EdgeInsets.only(bottom: 1.0),
            padding: new EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                          child:Container(
                            padding: EdgeInsets.only(right: 5),
                            child: new Column(children: <Widget>[
                              Align(
                                alignment: new FractionalOffset(0.0, 0.0),
                                child: new Text(title??'', style: TextStyle(fontSize: Dimens.font_sp16),
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              SizedBox(height: 20.0,),
                              Align(
                                alignment: new FractionalOffset(0.0, 1.0),
                                child: new Text("${create_name}  浏览数 ${widget.item.hits}  " +
                                    Util.getTimeFormatText(widget.item.create_date),
                                    style: AppText.Info_Size_Medium_Gray),
                              ),
                            ],
                            ),
                          ),
                          flex: 7
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: new AspectRatio(
                            aspectRatio: 3 / 2,
                            child: new CachedNetworkImage(
//                                errorWidget:
//                                new Icon(
//                                    Icons.broken_image, color: Colors.black12),
                                imageUrl: Api.formatPicture(image[0]),
                                fit: BoxFit.cover
                            ),
                          ),
                        ),
                        flex: 3,
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        );
      } else if (image.length == 3) {
        return new GestureDetector(
            onTap: () => _onTap(context, widget.item),
            child:Container(
              color: Colors.white,
              margin: new EdgeInsets.only(bottom: 1.0),
              padding: new EdgeInsets.all(10.0),
              child: new Column(
                children: <Widget>[
                  Align(
                    alignment: new FractionalOffset(0.0, 0.0),
                    child: new Text(title??'', style: TextStyle(fontSize: Dimens.font_sp16),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.fade),
                  ),
                  SizedBox(height: 10),
                  new Container(
                    child: new Row(children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3.0),
                            child: new AspectRatio(
                              aspectRatio: 3 / 2,
                              child: new CachedNetworkImage(
//                                  errorWidget:
//                                  new Icon(
//                                      Icons.broken_image, color: Colors.black12),
                                  imageUrl: Api.formatPicture(image[0],480),
                                  fit: BoxFit.cover
                              ),
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3.0),
                            child: new AspectRatio(
                              aspectRatio: 3 / 2,
                              child: new CachedNetworkImage(
//                                  errorWidget:
//                                  new Icon(
//                                      Icons.broken_image, color: Colors.black12),
                                  imageUrl: Api.formatPicture(image[1],480),
                                  fit: BoxFit.cover
                              ),
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3.0),
                            child: new AspectRatio(
                              aspectRatio: 3 / 2,
                              child: new CachedNetworkImage(
//                                  errorWidget:
//                                  new Icon(
//                                      Icons.broken_image, color: Colors.black12),
                                  imageUrl: Api.formatPicture(image[2],480),
                                  fit: BoxFit.cover
                              ),
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                    ]),
                  ),
                  Align(
                    alignment: new FractionalOffset(0.0, 0.0),
                    child: new Text("${create_name} 浏览数 ${widget.item.hits}  " +
                        Util.getTimeFormatText(widget.item.create_date),
                        style: AppText.Info_Size_Medium_Gray,
                        textAlign: TextAlign.start),
                  ),
                ],
              ),
            )
        );
      } else {
        return new GestureDetector(
          onTap: () => _onTap(context, widget.item),
          child:Container(
            color: Colors.white,
            margin: new EdgeInsets.only(bottom: 1.0),
            padding: new EdgeInsets.all(10.0),
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(title, style: TextStyle(fontSize: Dimens.font_sp16)),
                  SizedBox(height: 20),
                  new Text("${create_name} 浏览数 ${widget.item.hits}  " +
                      Util.getTimeFormatText(widget.item.create_date),
                      style: AppText.Info_Size_Medium_Gray,
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        );
      }
    }else{
      //视频播放
      var video = json.decode(widget.item.images);
        return new GestureDetector(
          onTap: () {
            videoShow(context,widget.item);
//            _onTap(context,widget.item);
          },
          behavior: HitTestBehavior.translucent,
          child: new Column(children: <Widget>[
            new Stack(
              //指定未定位或部分定位widget的对齐方式
                alignment:Alignment.center,
                children: <Widget>[
                  new Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 9 / 16,
                    alignment: Alignment.center,
                    child: new CachedNetworkImage(
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fill,
                      imageUrl: Api.formatPicture(video['img']),
//                  placeholder: (context, url) => new ProgressView(),
//                  errorWidget: (context, url, error) => new Icon(Icons.broken_image,color: Colors.grey,siz),
                    ),
                  ),
                  new Positioned(
                    left:10.0,
                    top: 10.0,
                    child:new Text(title??'',style: TextStyle(fontSize: Dimens.font_sp16,color: Colors.white)),
                  ),
                  new Positioned(
                    top:MediaQuery.of(context).size.width * 9 / 32 - 20,
                    left: MediaQuery.of(context).size.width / 2 - 25,
                    child:new Icon(Icons.play_circle_filled,size:50.0, color: Colors.white),
                  ),
                ]
            ),
            new Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: new Text("${create_name}  浏览数 ${widget.item.hits}  " +
                    Util.getTimeFormatText(widget.item.create_date),
                    style: AppText.Info_Size_Medium_Gray),
              ),
            ),
//            Divider(height: 1.0,color: AppColor.borderColor,)
          ],)
        );
    }
  }

  //点击文章
  void _onTap(context,item){
    if(item.link != '' && item.link.length > 0){
      NavigatorUtil.launchInBrowser(item.link);
    }else {
      NavigatorUtil.pushPage(context,
          WebScaffold(url: "/#/cms/articleDetail/${item.id}/", title: '文章详情'),
          pageName: '文章');
    }
//    NavigatorUtil.pushPage(context, ArticleDetailPage(item:item),pageName: '文章详情');

  }

  //点击视频
  void videoShow(content,item){
    if(item.link != '' && item.link.length > 0){
      NavigatorUtil.launchInBrowser(item.link);
    }else {
      NavigatorUtil.pushPage(
          context, VideoDetailPage(item.id, widget.item.images),
          pageName: '文章详情');
    }
//      Navigator.of(context).push(new PageRouteBuilder(
//          opaque: false,
//          pageBuilder: (BuildContext context, _,__){
//            return new VideoDetailPage(widget.item,json.decode(widget.item.images));
//          },
//          transitionsBuilder: (_,Animation<double> animation,__,Widget child){
//            return new FadeTransition(
//              opacity: animation,
//              child: new SlideTransition(position: new Tween<Offset>(
//                begin: const Offset(1.0, 0.0),
//                end: Offset.zero,
//              ).animate(animation),child: child,
//              ),
//            ) ;
//          }
//      ));
  }

}
