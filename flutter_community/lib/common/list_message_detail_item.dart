import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/common/net_utils.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:convert';

class ListMessageDetailItem extends StatefulWidget {

  final Map item;

  const ListMessageDetailItem({Key key,this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListMessageDetailItemState();

}

class _ListMessageDetailItemState extends State<ListMessageDetailItem> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
//      onTap: () => _onTap(context, widget.item),
      child: Column(
        children: <Widget>[

          Container(
            margin: new EdgeInsets.only(top:10.0),
            child: Text('${widget.item['create_date']}',style: AppText.Info_Size_Medium_Gray,),
          ),
          Container(
              color: Colors.white,
              margin: new EdgeInsets.only(bottom: 10.0,left: 15.0,top: 5.0,right: 15.0),
              padding: new EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.item['title'],style: AppText.SubTitle_Size_Big,),
                  SizedBox(height: 5.0,),
                  Divider(height: 1.0,color: AppColor.borderColor,),
                  SizedBox(height: 5.0,),

                  new Html(data:'${widget.item['template']}',useRichText:true,
                      defaultTextStyle:
                      new TextStyle(fontFamily: '思源黑体',color:Colors.black87,fontSize: 13.0,height:0.3)),

                ],
              )
          ),
        ],
      )
    );
  }
}
