
import 'package:flutter/material.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/mall/mall_activity.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';

class _BizItem {
  String name, icon, code;
  Widget page;

  _BizItem(this.name, this.icon,this.code,this.page);
}

//第三部分 商盟首页
class ConsumerHomeBizPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    final itemNames1 = [
      _BizItem('保洁','home_part3_1','G01A01',null),
      _BizItem('维修','home_part3_2','G01A02',null),
      _BizItem('家电清洗','home_part3_3','G01A03',null),
      _BizItem('衣物养护','home_part3_4','G01A04',null),
    ];
    final itemNames2 = [
      _BizItem('保姆月嫂','home_part3_5','G01A05',null),
      _BizItem('教育','home_part3_6','G01A06',null),
      _BizItem('丽人','home_part3_7','G01A07',null),
      _BizItem('美食','home_part3_8','G01A08',null),
    ];

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(Dimens.gap_dp10),
      margin: EdgeInsets.only(top: Dimens.gap_dp10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('社区商圈',style: TextStyle(fontSize: Dimens.font_sp16),),
//              Expanded(
//                child: Text('商家入驻',style: TextStyle(color: Colours.text_gray,fontSize: Dimens.font_sp14),textAlign: TextAlign.end,),
//              )
            ],
          ),
          SizedBox(height: Dimens.gap_dp10,),
          Divider(color: Colours.divider),
          SizedBox(height: Dimens.gap_dp5,),

          Row(
            children:<Widget>[
              Expanded(
                  child:GestureDetector(
                    child: Image.asset(Utils.getImgPath('home_part3_01')),
                    onTap: (){
                      NavigatorUtil.pushPage(context,MallActivityPage(),pageName: '商家活动');
                    },
                  ),
                  flex:7
              ),
              SizedBox(width:5),
              Expanded(
                  child:GestureDetector(
                    child: Image.asset(Utils.getImgPath('home_part3_02')),
                    onTap: (){
                      NavigatorUtil.pushPage(context, WebScaffold(url:'/#/tradeArea/',title: '社区商城',hideTitleBar: true,),pageName: '社区商城',);
                    },
                  ),
                  flex:7
              ),
              SizedBox(width:5),
              Expanded(
                  child:GestureDetector(
                    child: Image.asset(Utils.getImgPath('home_part3_03')),
                    onTap: (){
                      NavigatorUtil.pushPage(context, WebScaffold(url:'/#/coinRules/',title: '做公益享优惠',hideTitleBar: false,),pageName: '做公益享优惠',);
                    },
                  ),
                  flex:3
              ),
            ]
          ),
          SizedBox(height: 30,),
          Column(
            children: <Widget>[
              Row(
                children: itemNames1.map((value){
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child:Column(
                        children: <Widget>[
                          Image.asset(Utils.getImgPath(value.icon),width: 40,),
                          SizedBox(height: Dimens.gap_dp5),
                          Text(value.name,style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),)
                        ],
                      ),
                      onTap: (){
//                          NavigatorUtil.pushPage(context, WebViewFlutterPage(url:'/#/goodsList/?code='+value.code,showTitle: true,search: true,),pageName: '商城');
                          NavigatorUtil.pushPage(context, WebScaffold(url:'/#/goodsList/?code='+value.code,title: value.name,hideTitleBar: true),pageName: '商城');
                      },
                    )
                  );
                }).toList(),
              ),
              SizedBox(height: Dimens.gap_dp15,),
              Row(
                children: itemNames2.map((value){
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        children: <Widget>[
                          Image.asset(Utils.getImgPath(value.icon),width: 40,),
                          SizedBox(height: Dimens.gap_dp5),
                          Text(value.name,style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),)
                        ],
                      ),
                      onTap: (){
                        NavigatorUtil.pushPage(context, WebScaffold(url:'/#/goodsList/?code='+value.code,title: value.name,hideTitleBar: true),pageName: '商城');
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          )
        ],
      ),
    );
  }
}