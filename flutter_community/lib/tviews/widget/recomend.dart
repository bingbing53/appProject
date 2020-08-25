import 'package:flutter/material.dart';
import 'package:helloworld/res/res_index.dart';

class RecomendListWidget extends StatelessWidget {
  final List items;
  final ValueChanged<dynamic> onItemTap;

  RecomendListWidget(this.items, {this.onItemTap});

  @override
  Widget build(BuildContext context) {
    var listView = ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 6),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int i) {

        var label = items[i]['indexType'],labelStr = '';
        if(label == 'pms') labelStr = '商品';
        else if(label == 'article') labelStr = '文章';
        else if(label == 'activity') labelStr = '活动';

        return InkWell(
          onTap: () => onItemTap(items[i]),
          child: Container(
//            color: Colors.white,
            height: 42,
//            width: double.infinity,
            // color: Colors.red,
            alignment: Alignment.centerLeft,
            // constraints: BoxConstraints(minWidth: double.infinity),
            child: Row(
              children: <Widget>[
                Container(
                  height: 16.0,
                  margin: new EdgeInsets.only(left: 4.0,right: 4),
                  padding: new EdgeInsets.only(left: 5.0,right: 5.0),
                  decoration: BoxDecoration(
                    color: Colours.app_main,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(labelStr,style: new TextStyle(color:Colors.white,fontSize: 11.0),),
                ),
                Expanded(
                  child: Text(
                    '${items[i]['name']}',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Icon(
                  GZXIcons.jump,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  width: 4,
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int i) {
        return Container(
          height: 1,
          color: Colors.grey[200],
        );
      },
    );

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            color: Colors.white),
//      color: Colors.red,
        child: listView);
  }
}
