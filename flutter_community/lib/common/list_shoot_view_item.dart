import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/common/net_utils.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:helloworld/components/first_page_item.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/common/util.dart';
import 'package:helloworld/event/event-bus.dart';
import 'package:helloworld/event/event-model.dart';
import 'package:flutter_html/flutter_html.dart';
class ListShootViewItem extends StatefulWidget {
  final Map item;
  const ListShootViewItem({Key key,this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListShootViewItemState();

}

class _ListShootViewItemState extends State<ListShootViewItem> {

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

    return new Container(
          color: Colors.white,
          margin: EdgeInsets.only(bottom: 1.0),
          padding: EdgeInsets.all(10.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${widget.item['title']??''}',style: AppText.Title_Size_Big,),
              SizedBox(height: 10.0,),
              Text('${widget.item['content']??''}'),
              buildImages(),

              SizedBox(height: 10.0,),
              Text('反馈时间 ${widget.item['create_date']??''}',style: AppText.Info_Size_Medium_Gray,),

              feedBack()
            ],
          ),
        );
  }

  feedBack(){

    if(widget.item['feed_back'] != null && widget.item['feed_back'] != ''){

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15.0,),
          Text('社区回复：'),
          new Html(data:'${widget.item['feed_back']??''}',useRichText:true,
              defaultTextStyle:
              new TextStyle(fontFamily: '思源黑体',color:Colors.black,fontSize: 15.0)),
        ],
      );
    }
    return SizedBox(height: 0,);
  }

  buildImages(){
    var width = MediaQuery.of(context).size.width;
    var image = widget.item['image']??'';
    List<Widget> imageWidget = [];
    if(image != ''){
      try {
        var imageArr = json.decode(image);
        for (var i = 0; i < imageArr.length; i++) {
          imageWidget.add(new CachedNetworkImage(
              width: width/3 -10,
//              errorWidget:
//              new Icon(
//                  Icons.broken_image, color: Colors.black12),
              imageUrl: Api.formatPicture(imageArr[i], 480),
              fit: BoxFit.cover
          ),);
        }

        return Container(
          child: Align(
            alignment: Alignment.centerLeft,
            child: new Row(
              children: imageWidget,
            ),
          ),
        );
      }catch(e){

      }
    }
    return SizedBox(height: 0,);
  }
}
