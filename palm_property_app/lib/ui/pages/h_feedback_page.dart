
import 'package:estate/common/component_index.dart';
import 'package:estate/ui/pages/page_index.dart';
import 'package:flutter/material.dart';

class FeedBackPage extends StatelessWidget {

  final String labelId;

  const FeedBackPage({Key key, this.labelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EstateBloc bloc = BlocProvider.of<EstateBloc>(context);
    RefreshController _controller = new RefreshController();
    bloc.getData(labelId: labelId,page: 1);
    try {
      bloc.homeEventStream.listen((event) {
        if (labelId == event.labelId) {
            _controller.sendBack(false, event.status);
        }
      });
    }catch(e){

    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('居民报事'),
        ),
        body: Container(
          child: new StreamBuilder(
              stream: bloc.feedBackCodeStream,
              builder:
                  (BuildContext context, AsyncSnapshot<List<FeedBackModel>> snapshot) {
                if(snapshot.data == null){
                  return Container(height: 0);
                }
                int loadStatus = Utils.getLoadStatus(snapshot.hasError, snapshot.data);
                return new RefreshScaffold(
                  labelId: labelId,
                  loadStatus: loadStatus,
                  controller: _controller,
                  enablePullUp: true,
                  onRefresh: ({bool isReload}) {
                    return bloc.onRefresh(labelId: labelId);
                  },
                  onLoadMore: (up){
                    print('loadMore');
                    return bloc.onLoadMore(labelId: labelId);
                  },
                  child: new ListView(
                      padding: EdgeInsets.all(0),
                      children: snapshot.data.map((value) {
                        return titleOrder(context,value,bloc);
                      }).toList()
                  ),
                );
              }),
        )
    );
  }

  //待接单
  Widget titleOrder(BuildContext context,FeedBackModel feedBack,EstateBloc bloc){
    return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top:Dimens.gap_dp15,left: Dimens.gap_dp15,right: Dimens.gap_dp15),
                padding: EdgeInsets.all(Dimens.gap_dp10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(8),topRight: Radius.circular(8))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.fiber_manual_record,color: Colors.blueAccent,size: Dimens.gap_dp16,),
                        SizedBox(width: Dimens.gap_dp5,),
                        Text(feedBack.feedTypeDictText,style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.bold)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: Dimens.gap_dp10,vertical: 0),
                          margin: EdgeInsets.only(left: 10, top: 0),
                          //设置 child 居中
                          alignment: Alignment(0, 0),
                          height: 18,
                          //边框设置
                          decoration: new BoxDecoration(
                            //背景
                            color: Colors.white,
                            //设置四周圆角 角度
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            //设置四周边框
                            border: new Border.all(width: 1, color: feedBack.isHandle == '1' ?Colours.app_main : Colors.redAccent),
                          ),
                          child: Text(feedBack.isHandle == '1'?'已回复':'未处理',style: TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp12,color: feedBack.isHandle == '1' ?Colours.app_main : Colors.redAccent),),
                        ),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(left: Dimens.gap_dp20,top: Dimens.gap_dp5,bottom: Dimens.gap_dp10),
                        child: Text(feedBack.content,style: TextStyle(fontFamily: 'PingFang',color: Colours.text_gray,fontSize: Dimens.font_sp14))
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.fiber_manual_record,color: Colors.orangeAccent,size: Dimens.gap_dp16,),
                                SizedBox(width: Dimens.gap_dp5,),
                                Text('${feedBack.userName??''}',style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Container(
                                margin: EdgeInsets.only(left: Dimens.gap_dp20,top: Dimens.gap_dp5),
                                child: Text(Utils.hideMobile('${feedBack.userMobile??''}'),style: TextStyle(fontFamily: 'PingFang',color: Colours.text_gray,fontSize: Dimens.font_sp14))
                            ),
                          ],
                        ),
                        ),
                      ],
                    ),

                    //详情
                    SizedBox(height: Dimens.gap_dp15),
                    feedBack.image.length > 0 ? Container(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: feedBack.image.asMap().keys.map((f){
                            return new GestureDetector(
                              onTap: (){
                                NavigatorUtil.pushPage(context, PreviewImagesWidget(feedBack.image,initialPage: f),pageName: 'preview');
                              },
                              child: Container(
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                width: (MediaQuery.of(context).size.width - 60) / 3,
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: ClipRRect(child:
                                CachedNetworkImage(
                                  height: 100,
                                  fit: BoxFit.cover,
                                  imageUrl:feedBack.image[f],
                                  placeholder: (context, url) => new ProgressView(),
                                  errorWidget: (context, url, error) => new Icon(Icons.error),
                                ),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                    ):SizedBox(height: 0,),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: Dimens.gap_dp15),
                child: Image.asset(Utils.getImgPath('line',format: 'jpg'),fit: BoxFit.fitWidth,width: double.infinity),
              ),

              Container(
                  margin: EdgeInsets.only(bottom: Dimens.gap_dp10,left: Dimens.gap_dp15,right:Dimens.gap_dp15),
                  padding: EdgeInsets.only(left:30,bottom:Dimens.gap_dp10,right:Dimens.gap_dp10,top: Dimens.gap_dp5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(bottomLeft:Radius.circular(8),bottomRight: Radius.circular(8))
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Text(Utils.timeShowFormat(feedBack.createTime),style:TextStyle(fontFamily: 'PingFang',color: Colours.text_gray,fontSize: Dimens.font_sp14)),
                          ],
                        ),
                        flex: 6,
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Text('回复',style:TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp14,fontWeight: FontWeight.bold),textAlign: TextAlign.end,),
                          onTap: () async {
                            final result = await Navigator.push(context,PopRoute(child:
                                BlocProvider<EstateBloc>(
                                  child: BottomInputDialog(feedBackModel: feedBack),
                                  bloc: new EstateBloc(),
                                ),
                              )
                            );

                            if(result == 1){
                              bloc.onRefresh(labelId: labelId);
                            }
                          },
                        ),
                        flex: 6,
                      )
                    ],
                  )
              ),
            ],
          ),

    );
  }
}
