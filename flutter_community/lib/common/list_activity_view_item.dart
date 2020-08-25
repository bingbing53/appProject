import 'package:flutter/material.dart';
import 'package:helloworld/components/activity_page_item.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:helloworld/model/api.dart';

class ListActivityViewItem extends StatelessWidget {
  final ActivityPageItem item;
  const ListActivityViewItem({Key key,this.item}): super(key: key);

  void _launchURL(String url, BuildContext context) async {

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
  }

  @override
  Widget build(BuildContext context) {
    var title = item.title;
    if(title==null){
      title = '';
    }
    print('hot:${item.isHot}');
    if(item.is_small == '1') {//小图
      return new GestureDetector(
        onTap: () => _onTap(context, item),
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
                        child: Container(
                          padding: EdgeInsets.only(right: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: new FractionalOffset(0.0, 0.0),
                                child: new Text(title, style: TextStyle(fontSize: Dimens.font_sp16),
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              SizedBox(height: 15),
                              new Row(
                                children: <Widget>[
                                  Icon(Icons.business,size: 15.0,color: Colors.green,),
                                  SizedBox(width: 5),
                                  Flexible(
                                    child: Text(item.location == null?'':item.location,style:TextStyle(fontSize: Dimens.font_sp13),maxLines:1,overflow:TextOverflow.ellipsis,textAlign: TextAlign.left,),
                                  )
                                ],
                              ),
                              SizedBox(height: 5.0),
                              new Row(
                                children: <Widget>[
                                  Container(
                                    height: 16.0,
                                    margin: new EdgeInsets.only(left: 5.0),
                                    padding: new EdgeInsets.only(left: 5.0,right: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Text(item.activityTypeName,style: new TextStyle(color:Colors.white,fontSize: 11.0),),
                                  ),
                                  item.smsCoupon.length > 0 ? Container(
                                    height: 16.0,
                                    margin: new EdgeInsets.only(left: 5.0),
                                    padding: new EdgeInsets.only(left: 5.0,right: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Text('优惠券',style: new TextStyle(color:Colors.white,fontSize: 11.0),),
                                  ):Container(),
                                  new Container(
                                    height: 16.0,
                                    margin: new EdgeInsets.only(left: 5.0),
                                    padding: new EdgeInsets.only(left: 5.0,right: 5.0),
                                    decoration: BoxDecoration(
                                      color: item.isEnd == '1' ? Colors.grey:(item.isFull == '1' ?Colors.grey:Colors.green),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Text(item.isEnd == '1' ? '报名结束':(item.isFull == '1' ? '名额已满':'报名中'),style: new TextStyle(color:Colors.white,fontSize: 11.0)),
                                  ),
                                  item.isEnd == '0' && item.isHot == '1' ? new Container(
                                    height: 15.0,
                                    margin: new EdgeInsets.only(left: 5.0),
                                    padding: new EdgeInsets.only(left: 3.0,right: 3.0,top:1.0),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Text('火',style: new TextStyle(color:Colors.white,fontSize: 9.0),),
                                  ):SizedBox(height: 0,),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Text(item.commName??'',style:new TextStyle(color:Colors.blueAccent,fontSize: Dimens.font_sp13,),maxLines:2,overflow:TextOverflow.ellipsis,),
                            ],
                          ),
                        ),
                        flex: 7
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: new AspectRatio(
                          aspectRatio: 5 / 4,
                          child: new CachedNetworkImage(
//                              errorWidget: new Icon(Icons.broken_image, color: Colors.black12),
                              imageUrl: Api.formatPicture(item.poster_url, 480),
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
    }else{
      return new GestureDetector(
        onTap: () => _onTap(context, item),
        child: Container(
          color: Colors.white,
          margin: new EdgeInsets.only(bottom: 1.0),
          padding: new EdgeInsets.only(top:1.0,bottom: 10.0),
          child: new Column(
            children: <Widget>[
                new Stack(
                  children: <Widget>[
                      new AspectRatio(
                        aspectRatio: 16 / 9,
                        child: new CachedNetworkImage(
//                            errorWidget:
//                            new Icon(
//                                Icons.broken_image, color: Colors.black12),
                            imageUrl: Api.formatPicture(item.poster_url, 480),
                            fit: BoxFit.cover
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: (MediaQuery.of(context).size.width / 16) * 9,
                        decoration: BoxDecoration(color: Colours.transparent_30),
                      ),
                      new Positioned(
                          right: 0,
                          left: 0,
                          child:new Container(
                            padding: new EdgeInsets.only(top:5.0,left: 10.0,right: 10.0,bottom: 5.0),
                            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.black26,Colors.black12,Colors.black38])),
                            child:new Text(title,style: TextStyle(fontSize: Dimens.font_sp16,color: Colors.white),maxLines: 2, overflow: TextOverflow.ellipsis),
                          )
                      ),
                  ]),
                SizedBox(height: 10),
                new Container(
                  alignment:Alignment.topLeft,
                  padding: new EdgeInsets.only(left:10.0,right: 10.0,top:5.0),
                  child: new Column(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          Icon(Icons.business,size: 15.0,color: Colors.green,),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(item.location == null?'':item.location,style:TextStyle(fontSize: Dimens.font_sp13),maxLines: 1,overflow: TextOverflow.clip),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      new Row(
                        children: <Widget>[
                          Text(item.commName??'',style:new TextStyle(color:Colors.blueAccent,fontSize: Dimens.font_sp13)),
                          new Container(
                            height: 16.0,
                            margin: new EdgeInsets.only(left: 5.0),
                            padding: new EdgeInsets.only(left: 5.0,right: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(item.activityTypeName,style: new TextStyle(color:Colors.white,fontSize: 11.0),),
                          ),
                          new Container(
                            height: 16.0,
                            margin: new EdgeInsets.only(left: 5.0),
                            padding: new EdgeInsets.only(left: 5.0,right: 5.0),
                            decoration: BoxDecoration(
                              color: item.isEnd == '1' ? Colors.grey:(item.isFull == '1' ?Colors.grey:Colors.green),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(item.isEnd == '1' ? '报名结束':(item.isFull == '1' ? '名额已满':'报名中'),style: new TextStyle(color:Colors.white,fontSize: 11.0),),
                          ),
                          item.isEnd == '0' && item.isHot == '1' ? new Container(
                            height: 16.0,
                            margin: new EdgeInsets.only(left: 5.0),
                            padding: new EdgeInsets.only(left: 5.0,right: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text('火',style: new TextStyle(color:Colors.white,fontSize:11.0),),
                          ):SizedBox(height: 0,),
                        ],
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }
  }

  void _onTap(context,item){
    NavigatorUtil.pushPage(context, WebScaffold(url:"/#/cms/activityDetail/"+item.id+"/",title: '活动详情',),pageName: '活动');
  }

}
