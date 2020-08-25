import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/common/net_utils.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:helloworld/tviews/consumer/message/detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListMessageListItem extends StatefulWidget {

  final Map item;
  final callback;
  const ListMessageListItem({Key key,this.item,this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListMessageListItemState();

}

class _ListMessageListItemState extends State<ListMessageListItem> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var content = widget.item['content'];
    content = json.decode(content);

    return new GestureDetector(
      onTap: () => _onTap(),
      child: Container(
        color: Colors.white,
        margin: new EdgeInsets.only(bottom: 1.0),
        padding: new EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(right: 5.0),
                child:ClipRRect(
                    borderRadius: BorderRadius.circular(2.0),
                    child:new AspectRatio(
                          aspectRatio: 1 / 1,
                        child: new CachedNetworkImage(
//                            errorWidget:
//                            new Icon(
//                              Icons.account_box, color: Colors.black12,),
                            imageUrl: Api.formatPicture(widget.item['icon'], 480),
                            fit: BoxFit.cover
                        ),
                      ),
                  )
               ),
              flex: 1,
            ),

            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                        Expanded(
                          child: Text(widget.item['title'],style: AppText.SubTitle_Size_Big,),
                        ),
                        Expanded(
                          child: Text(widget.item['create_date'],style: AppText.Info_Size_Big_Gray,textAlign: TextAlign.right,),
                        )
                    ],
                  ),
                  SizedBox(height: 5.0,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('${content['first']}',style: AppText.Info_Size_Big_Gray,maxLines: 1,overflow: TextOverflow.fade,),
                      ),
                      Expanded(
                        child:widget.item['total'] > 0 ?Container(
                          height: 17.0,
                          alignment:Alignment.centerRight,
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Text('${widget.item['total']}',style:AppText.Info_Size_Small_White,textAlign: TextAlign.center,),
                          ),
                        ):Text('')
                      )
                    ],
                  )
                ],
              ),
              flex: 6,
            ),
          ],
        )
      ),
    );
  }

  _onTap(){
    widget.callback('1');
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
      return new MessageDetailPage(widget.item);
    }));
  }
}
