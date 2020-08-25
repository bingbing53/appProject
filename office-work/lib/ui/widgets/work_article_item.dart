import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/ui/pages/page_index.dart';

class WorkArticleItem extends StatelessWidget {
  const WorkArticleItem(this.model, {Key key, this.isHome}) : super(key: key);

  final WorkArticleModel model;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        NavigatorUtil.pushWeb(context,
            title: model.articleTitle, url: '', isHome: isHome);
      },
      child: model.articleType == '1'?buildVideo(context):buildArticle(context)
    );
  }

  Widget buildArticle(context){
    return GestureDetector(
      onTap: (){
        NavigatorUtil.pushWeb(context,
            title: model.articleTitle, url: WanAndroidApi.ARTICLE_DETAIL_PREFIX+model.id);
      },
      child: Container(
          height: 140.0,
          padding: EdgeInsets.all(16.0),
          child: new Row(
            children: <Widget>[
              new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        model.articleTitle,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.listTitle,
                      ),
                      Gaps.vGap10,
                      new Expanded(
                        flex: 1,
                        child: new Text(
                          '',
                          maxLines: 3,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.listContent,
                        ),
                      ),
                      Gaps.vGap5,
                      new Row(
                        children: <Widget>[
                          new Text(
                            model.departname,
                            style: TextStyles.listExtra,
                          ),
                          Gaps.hGap10,
                          new Text(
                            '浏览数 ${model.hits}',
                            style: TextStyles.listExtra,
                          ),
                          Gaps.hGap10,
                          new Text(
                            Utils.getTimeLineByDateTime(context, model.createDate),
                            style: TextStyles.listExtra,
                          ),
                        ],
                      )
                    ],
                  )),
              model.images.length > 0 ? new Container(
                width: 100,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 5.0),
                child: new CachedNetworkImage(
                  height: double.infinity,
                  fit: BoxFit.fitHeight,
                  imageUrl: model.images[0],
                  placeholder: (context, url) => new ProgressView(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ):SizedBox(height: 0,)
            ],
          ),
          decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border(
                  bottom: new BorderSide(width: 0.33, color: Colours.divider)))),
    );
  }

  Widget buildVideo(context){

    return GestureDetector(
      onTap: (){
        NavigatorUtil.pushPage(context,VideoPage(articleId: model.id,title:model.articleTitle),pageName: model.articleTitle);
      },
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              new Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 9 / 16,
                alignment: Alignment.center,
                child: new CachedNetworkImage(
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                  imageUrl: model.images[0],
//                  placeholder: (context, url) => new ProgressView(),
//                  errorWidget: (context, url, error) => new Icon(Icons.broken_image,color: Colors.grey,siz),
                ),
              ),
              Positioned(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.0),
//                  decoration: new BoxDecoration(
//                      gradient: const LinearGradient(
//                          begin: FractionalOffset(0.5, 0.5), end: FractionalOffset(1, 1),
//                          colors: [Colours.transparent_40, Colours.transparent_80]),
//                  ),
                  child: Text('${model.articleTitle}',maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15,color: Colors.white,letterSpacing: 1.7,fontWeight: FontWeight.bold),),
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.width * 9 / 32 - 20,
                  left: MediaQuery.of(context).size.width / 2 - 25,
                  child: Center(
                    child: Icon(Icons.play_arrow,color: Colors.white,size: 50,),
                  )
              )
            ],
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: new Row(
              children: <Widget>[
                new Text(
                  model.departname,
                  style: TextStyles.listExtra,
                ),
                Gaps.hGap10,
                new Text(
                  '浏览数 ${model.hits}',
                  style: TextStyles.listExtra,
                ),
                Gaps.hGap10,
                new Text(
                  Utils.getTimeLineByDateTime(context, model.createDate),
                  style: TextStyles.listExtra,
                ),
              ],
            )
          ),
          Divider(height: 1,color: Colours.divider,)
        ],
      ),
    );

//    return GestureDetector(
//      onTap: (){
//        NavigatorUtil.pushPage(context,VideoPage(articleId: model.id,title:model.articleTitle),pageName: model.articleTitle);
//      },
//      child: Container(
//          height: 140.0,
//          padding: EdgeInsets.all(16.0),
//          child: new Row(
//            children: <Widget>[
//              new Expanded(
//                  child: new Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      new Text(
//                        model.articleTitle,
//                        maxLines: 3,
//                        overflow: TextOverflow.ellipsis,
//                        style: TextStyles.listTitle,
//                      ),
//                      Gaps.vGap10,
//                      new Expanded(
//                        flex: 1,
//                        child: new Text(
//                          '',
//                          maxLines: 3,
//                          softWrap: true,
//                          overflow: TextOverflow.ellipsis,
//                          style: TextStyles.listContent,
//                        ),
//                      ),
//                      Gaps.vGap5,
//                      new Row(
//                        children: <Widget>[
//                          new Text(
//                            model.departname,
//                            style: TextStyles.listExtra,
//                          ),
//                          Gaps.hGap10,
//                          new Text(
//                            '浏览数 ${model.hits}',
//                            style: TextStyles.listExtra,
//                          ),
//                          Gaps.hGap10,
//                          new Text(
//                            Utils.getTimeLineByDateTime(context, model.createDate),
//                            style: TextStyles.listExtra,
//                          ),
//                        ],
//                      )
//                    ],
//                  )),
//              model.images.length > 0 ? new Container(
//                width: 100,
//                alignment: Alignment.center,
//                margin: EdgeInsets.only(left: 5.0),
//                child: new CachedNetworkImage(
//                  width: 100,
//                  height: 100,
//                  fit: BoxFit.fill,
//                  imageUrl: model.images[0],
//                  placeholder: (context, url) => new ProgressView(),
//                  errorWidget: (context, url, error) => new Icon(Icons.error),
//                ),
//              ):SizedBox(height: 0,)
//            ],
//          ),
//          decoration: new BoxDecoration(
//              color: Colors.white,
//              border: new Border(
//                  bottom: new BorderSide(width: 0.33, color: Colours.divider)))),
//    );
  }
}
