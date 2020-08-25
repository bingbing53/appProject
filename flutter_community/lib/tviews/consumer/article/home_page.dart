import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helloworld/data/api/consumer_apis.dart';
import 'package:helloworld/data/net/dio_util.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/components/disclaimer_msg.dart';
import 'package:cached_network_image/cached_network_image.dart';

const int ThemeColor = 0xFFF5534B;
GlobalKey<DisclaimerMsgState> key;

class HomePage extends StatefulWidget{

  final Map item;
  HomePage(this.item);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  var collected = 0;
  var user = {};

  @override
  void initState() {
    super.initState();
    homeData();

    getCollected();
  }

  @override
  bool get wantKeepAlive => true;

  Future homeData() async{
    BaseResp baseResp = await DioUtil().request(Method.get, ConsumerApis.ARTICLE_USER_STATICS+widget.item['sysOrgCode']);
    if(baseResp.code == 200){
      user = baseResp.data['depart'];
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('user:$user');
    return new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                    decoration: new BoxDecoration(color: Colors.white),
                    padding: EdgeInsets.all(10.0),
                    child:
                    ListTile(
                      leading: Container(
                        height: 45,
                        width: 45,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35.0),
                          child:new AspectRatio(
                            aspectRatio: 1 / 1,
                            child:new CachedNetworkImage(
                              imageUrl: Api.formatPicture(user['logo']??''),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                      title: Text('${user['departName']??''}',style: TextStyle(fontSize: Dimens.font_sp16)),
                      subtitle: Row(
                        children: <Widget>[
                            Flexible(child: Text('关注数 ${user['focusCount']?? 1} | 文章数 ${user['articleCount']?? 1} | 浏览数 ${user['articleHistCount']?? 1}',style:TextStyle(fontSize: Dimens.font_sp13))),
                        ],
                      ),
                      trailing:buildLikeBtn()
//                          SizedBox(height: 25.0,),
////                          Text('文章总数 ${user['articleCount']['total']??0} 点赞总数 ${user['articleCount']['praise']??0} 阅读总数 ${user['articleCount']['hits']}',style: AppText.SubTitle_Size_Medium_Gray,),
//                          SizedBox(height: 10.0,),
//                          Divider(height: 1.0,color: AppColor.borderColor,),
//                          SizedBox(height: 10.0,),
//                        ])
                ),
                )
            ],);
  }

  //关注和取消关注
  Future collect() async{
    if(collected == 1) {
      BaseResp baseResp = await DioUtil().request(Method.delete, ConsumerApis.IS_FOCUSED+'3/'+widget.item['sysOrgCode']);
      if(baseResp.code == 200) {
        setState(() {
          collected = 0;
        });
        Fluttertoast.showToast(msg: '取消成功');
      }
    }else{
      BaseResp baseResp = await DioUtil().request(Method.post, ConsumerApis.IS_FOCUSED+'3/'+widget.item['sysOrgCode']);
      if(baseResp.code == 200) {
        setState(() {
          collected = 1;
        });
        Fluttertoast.showToast(msg: '关注成功');
      }
    }
  }

  var inited = 1;
  Widget buildLikeBtn(){
    if(inited == 0 && collected == 1){
      return GestureDetector(
        child:Container(
            padding: EdgeInsets.only(right: 17.0),
            child: Icon(Icons.favorite,color: Colors.red,size: 23,)
        ),
        onTap: (){
          collect();
        },
      );
    }
    inited = 1;
    return LikeButton(
        width: 56.0,
        duration: Duration(milliseconds: 500),
        onIconClicked:(val){
          collect();
        }
    );
  }

  //获取是否关注了
  Future getCollected() async{
    BaseResp baseResp = await DioUtil().request(Method.get, ConsumerApis.IS_FOCUSED+'3/'+widget.item['sysOrgCode']);
    if(baseResp.code == 200){
      setState((){
        collected = 1;
        inited = 0;
      });
    }
  }
}
