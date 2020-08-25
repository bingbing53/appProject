import 'package:flutter/material.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/utils/util_index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/tviews/consumer/article/article_page.dart';
class ListFocusItem extends StatefulWidget {
  final Map item;
  const ListFocusItem({Key key,this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListFocusItemState();

}

class _ListFocusItemState extends State<ListFocusItem> {

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
    print(widget.item);
    return GestureDetector(
        onTap: (){
          gotoHomePage();
        },
        child: new Container(
          color: Colors.white,
          margin: EdgeInsets.only(bottom: 1.0),
          padding: EdgeInsets.all(5.0),
          child: ListTile(
                leading: Container(
                  height: 40,
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35.0),
                    child:new AspectRatio(
                      aspectRatio: 1 / 1,
                      child:new CachedNetworkImage(
                        imageUrl: Api.formatPicture(widget.item['logo']??''),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                title:Text('${widget.item['departName']}',style:TextStyle(fontSize: Dimens.font_sp16)),
                subtitle: Row(
                  children: <Widget>[
                    Flexible(child: Text('关注数 ${widget.item['focusCount']?? 1} | 文章数 ${widget.item['articleCount']?? 1} | 浏览数 ${widget.item['articleHistCount']?? 1}',style:TextStyle(fontSize: Dimens.font_sp13))),
                  ],
                ),
              )
        ),
    );
  }

  gotoHomePage(){
    Map<String, dynamic> param = new Map();
    param['sysOrgCode'] = widget.item['orgCode'];
    widget.item['sysOrgCode'] = widget.item['orgCode'];
    Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new Scaffold(
            appBar: AppBar(
              title: Text('主页'),
              flexibleSpace: Image(
                image: AssetImage(Utils.getImgPath('home_top')),
                fit: BoxFit.cover,
              ),
              backgroundColor: Colors.transparent,
            ),
            body: new ArticleListPage('-999',param: param,showHeader: '1',headerItem: widget.item,)),
        )
    );
  }
}
