import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/common/net_utils.dart';
import 'package:helloworld/utils/base_utils.dart';

class ListActivitySignUpItem extends StatefulWidget {
  final Map item;
  final String isSign,register;
  final double timeLong,defaultTimeLong;
  const ListActivitySignUpItem({Key key,this.item,this.isSign,this.timeLong,this.register,this.defaultTimeLong}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListActivitySignUpItemState(item);

}

class _ListActivitySignUpItemState extends State<ListActivitySignUpItem> {

  Map item;
  var timeLong = 0.0,isSign = '1',register = '2';

  _ListActivitySignUpItemState(this.item);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(widget.register == '2')
      timeLong = widget.defaultTimeLong??0;
    else
      timeLong = widget.item['timelong']??0;
    register = widget.register;
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
//      onTap: () => _onTap(context, widget.item),
      child: Container(
        color: Colors.white,
        margin: new EdgeInsets.only(bottom: 1.0),
        padding: new EdgeInsets.all(10.0),
        child: widget.isSign == '1' ? _signPerson():_normalPerson()
      ),
    );
  }

  Widget _normalPerson(){
    return new Row(
        children: <Widget>[
          ClipOval(
            child: new CachedNetworkImage(
              imageUrl: Api.formatPicture(widget.item['head_image']??''),
                fit: BoxFit.fitWidth,
              width:45.0,
              height: 45.0,
            ),
          ),
          Expanded(
            child: new Column(
              children: <Widget>[
                new Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 30.0),
                    child:Text(widget.item['realname']??'',style: AppText.SubTitle_Size_Big,)
                ),
                new Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 30.0),
                  child: new Row(
                    children: <Widget>[
                      Text('时长',style: AppText.Info_Size_Small_Gray,),
                      Text('  ${widget.item['timelong']}',style: AppText.Title_Size_Medium_Blue,),
                      Text('  |  '),
                      Text('积分  ',style: AppText.Info_Size_Small_Gray,),
                      Text('${widget.item['points']}',style: AppText.Title_Size_Medium_Blue,),
                    ],
                  ),
                )
              ],
            ),
            flex: 6,
          ),
        ]);
  }

  Widget _signPerson(){
    return new Row(
        children: <Widget>[
          ClipOval(
            child: new CachedNetworkImage(
                imageUrl: Api.formatPicture(widget.item['head_image']??''),
                fit: BoxFit.fitWidth,
                width:45.0,
                height: 45.0,
            ),
          ),
          Expanded(
            child: new Column(
              children: <Widget>[
                new Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 30.0),
                    child:new Row(children: <Widget>[
                      Text(widget.item['realname']??'',style: AppText.SubTitle_Size_Big,),
                      Text('  （'+(register == '2'?'未签到':(register == '1'?'已签到':'缺勤'))+'）',style: new TextStyle(fontFamily: '思源黑体',color:(register == '2'?Colors.grey:(register == '1'?Colors.green:Colors.red)),fontSize: 11.0),)
                    ],)
                ),
                new Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 30.0),
                  child: new Row(
                    children: <Widget>[
                      Text('时长 ',style: AppText.Info_Size_Small_Gray,),
                      new GestureDetector(
                        child: Icon(Icons.add,size: 18.0,color: Colors.green,),
                        onTap: (){
                          setState((){
                            timeLong ++;
                          });
                        },
                      ),

                      Text('  ${timeLong}小时  ',style: AppText.Title_Size_Medium_Blue,),
                      new GestureDetector(
                        child: Icon(Icons.remove,size: 18.0,color: Colors.redAccent,),
                        onTap: (){
                          setState((){
                            if(timeLong > 0)
                              timeLong --;
                          });
                        },
                      ),
                      /*Text('  |  '),
                      Text(' 积分 ',style: AppText.Info_Size_Small_Gray,),
                      Text('${widget.item['points']}',style: AppText.Title_Size_Medium_Blue,),*/
                    ],
                  ),
                )
              ],
            ),
            flex: 4,
          ),
          Expanded(
            child:  CupertinoSwitch(
                value: register == '1',
                onChanged: (bool value) {///点击切换开关的状态
                  _signIn(value?1:0);
                }///end onChanged
            )
          ),
//          Expanded(
//            child:new Row(
//              children: <Widget>[
//                Expanded(
//                  child:InkWell(
//                    child:  Text("到岗",style: AppText.SubTitle_Size_Big,textAlign: TextAlign.center),
//                    onTap: () {
//                      _signIn(1);
//                    },
//                  ),
//                  flex: 6,
//                ),
//                Expanded(
//                  child:Text(''),
//                  flex: 1,
//                ),
//                Expanded(
//                  child:InkWell(
//                    child:  Text("缺勤",style: AppText.SubTitle_Size_Big_Red,textAlign: TextAlign.center,),
//                    onTap: () {
//                      _signIn(0);
//                    },
//                  ),
//                  flex: 6,
//                )
//              ],
//            ),
//            flex: 4,
//          ),
        ]);
  }

  //签到
  Future _signIn(state) async{
    var _param;
    if(state == 0){
      _param = {'register':'0','timelong':0};
    }else{
      _param = {'register':'1','timelong':timeLong};
    }
    var response = await NetUtils.put(Api.ACTIVITY_SIGNIN+widget.item['id'],params: _param);

    if(response != null){
      BaseUtils.showToast("签到成功");
      setState((){
        register = '${state}';
        if(state == 0)
          timeLong = 0.0;
      });
    }
  }
}
