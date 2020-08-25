
import 'package:estate/blocs/bloc_index.dart';
import 'package:estate/common/component_index.dart';
import 'package:flutter/material.dart';

class SysUserSelectPage extends StatelessWidget{

  final String labelId,orderId;

  const SysUserSelectPage({Key key, this.labelId,this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EstateBloc bloc = BlocProvider.of<EstateBloc>(context);
    RefreshController _controller = new RefreshController();
    bloc.getSysUserList();
    return Scaffold(
        appBar: AppBar(
        title: Text(IntlUtil.getString(context,labelId),),
      ),
      body: new StreamBuilder(
          stream: bloc.sysUserCodeStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<SysUserModel>> snapshot) {
            if(snapshot.data == null){
              return Container(height: 0);
            }
            int loadStatus = Utils.getLoadStatus(snapshot.hasError, snapshot.data);
            return new RefreshScaffold(
              labelId: labelId,
              loadStatus: loadStatus,
              controller: _controller,
              enablePullUp: false,
              onRefresh: ({bool isReload}) {
                return bloc.onRefresh(labelId: labelId);
              },
              child: new ListView(
                  padding: EdgeInsets.all(0),
                  children: snapshot.data.map((value) {
                    return GestureDetector(
                      child: buildUserWidget(context,value),
                      onTap: () async {
                        var valueFromSecondPage = await Navigator.push(context,PopRoute(child:
                            BlocProvider<EstateBloc>(
                            child: BottomScheduleDialog(sysUserModel: value),
                            bloc: new EstateBloc(),
                            ),
                          )
                        );

                        if(valueFromSecondPage == null) {
                          return;
                        }
                        DispatchReqModel dis = new DispatchReqModel();
                        dis.orderId = orderId;
                        dis.userId = value.id;
                        dis.times = valueFromSecondPage;

                        CommonUtils.showLoadingDialog(context);
                        bloc.dispatch(dis).then((v){
                            Navigator.pop(context);
                            Navigator.pop(context);
                        }).catchError((_){
                            Navigator.pop(context);
                        });
                      },
                    );
                  }).toList()
              ),
            );
          })
    );
  }

  Widget buildUserWidget(BuildContext context,SysUserModel user){
    return Container(
      padding: EdgeInsets.all(Dimens.gap_dp20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(user.realname),
              SizedBox(width: Dimens.gap_dp10,),
              GestureDetector(
                child: Text('${user.phone??''}',style: TextStyle(color: Colors.blueAccent),),
                onTap: (){
                  NavigatorUtil.diaMobile(user.phone);
                },
              )
            ],
          )
        ],
      ),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colours.divider))
      ),
    );
  }
}