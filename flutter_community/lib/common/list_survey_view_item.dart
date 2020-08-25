import 'package:flutter/material.dart';
import 'package:helloworld/components/survey_page_item.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/webview/webview_flutter.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/components/first_page_item.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/common/util.dart';

class ListSurveyViewItem extends StatefulWidget {
  final SurveyModel item;
  const ListSurveyViewItem({Key key,this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListSurveyViewItemState();

}

class _ListSurveyViewItemState extends State<ListSurveyViewItem> {

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
    return new GestureDetector(
        onTap: () {

          if(widget.item.voteType == '1'){
            NavigatorUtil.pushPage(context, WebScaffold(url:"/#/cms/survey?id="+widget.item.id,title:'问卷调查'),pageName: '问卷调查');
          }else{
            NavigatorUtil.pushPage(context, WebScaffold(url:"/#/cms/vote?id="+widget.item.id,title:'投票调查'),pageName: '投票调查');
          }
        },child:new Container(
          color: Colors.white,
          margin: EdgeInsets.only(bottom: 1.0),
          padding: EdgeInsets.all(10.0),
          child: new Column(
            children: <Widget>[
              SizedBox(height: 5.0,),
              new Row(children: <Widget>[
//                widget.item.voteType == '1'?Icon(Icons.show_chart,size: 20.0,color: Colors.green,):Icon(Icons.library_books,size: 20.0,
//                  color: Colors.green,),

                Container(
                margin: const EdgeInsets.only(left: 0, top: 0, right: 5, bottom: 0),
                  padding: EdgeInsets.only(left: 2,right: 2),
                  child: Text(
                    widget.item.voteType == '1'?'调查':'投票',
                    style: TextStyle(color: Colors.grey, fontSize: 10),maxLines: 1,overflow: TextOverflow.clip,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      border: Border.all(width: 1, color: Colors.grey)),
                ),

                Flexible(
                  child:
                    Text('${widget.item.title}',style: TextStyle(fontSize: Dimens.font_sp16),overflow:TextOverflow.ellipsis,maxLines:2)
                )
              ],),
              SizedBox(height: 15.0,),
              new Row(children: <Widget>[
//                Text(widget.item.voteType == '1'?'问卷调查':'投票调查',style: AppText.Info_Size_Medium_Green,),
//                SizedBox(width: 10),
                Text(widget.item.sysOrgCode_dictText,style: TextStyle(color: Colours.text_gray,fontSize: Dimens.font_sp13),),
                SizedBox(width: 10),
                Text('参与数 ${widget.item.participantCount}',style: AppText.Info_Size_Medium_Gray,),
                SizedBox(width: 8),
                Text('${widget.item.createDate}',style: AppText.Info_Size_Medium_Gray,),
              ],)
            ],
          ),
        ),
    );
  }
}
