import 'package:flutter/material.dart';
import 'package:estate/common/component_index.dart';

import 'main_left_page.dart';

/**
 * 设备页面
 */
class DevicePage extends StatefulWidget {
  final String labelId;

  const DevicePage({Key key, this.labelId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DevicePageState();
  }

}

class _DevicePageState extends State<DevicePage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("DevicePage build......");
    final EstateBloc bloc = BlocProvider.of<EstateBloc>(context);
    bloc.getDeviceList();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("设备列表"),
//          actions: <Widget>[
//            GestureDetector(
//              child: Container(
//                padding: EdgeInsets.only(right: Dimens.gap_dp10),
//                child: Icon(Icons.settings,color: Colors.white),
//              ),
//              onTap: (){
//                NavigatorUtil.pushPage(context, MainLeftPage(),pageName: '我的');
//              },
//            ),
//          ],
      ),
      drawer: new Drawer(
         child: new MainLeftPage(),
      ),
      body: StreamBuilder(
                    stream:bloc.deviceCodeStream,
                    builder:(BuildContext context,
                          AsyncSnapshot<List<DeviceModel>> snapshot) {
                        if(snapshot.hasError){
                          return new StatusViews(
                            LoadStatus.fail,
                            onTap: () {
                              LogUtil.e("ProgressViews onRefresh......");
//                              bloc.getChatUserList();
                            },
                          );
                        }else {
                          if(snapshot.data == null || snapshot.data.length <= 0) {
                            return new StatusViews(
                              LoadStatus.empty,
                              onTap: () {
                                LogUtil.e("ProgressViews onRefresh......");
//                              bloc.getChatUserList();
                              },
                            );
                          }
                          return buildDeviceList(snapshot.data,bloc);
                        }
                      }
                   ),
    );
  }

  Widget buildDeviceList(List<DeviceModel> devices,EstateBloc bloc){

    return Column(
      children:
        devices.map((value) {
          return buildDeviceDetail(value,bloc);
        }).toList()
    );
  }

  Widget buildDeviceDetail(DeviceModel value,EstateBloc bloc){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MaterialButton(
              shape : const RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Text(value.name,style: TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp18),),
              onPressed: () {
                CommonUtils.showLoadingDialog(context,msg: '开门中');
                bloc.openDoor(value.id).then((_){
                  Navigator.pop(context);
                }).catchError((_){
                  Navigator.pop(context);
                });
              }
          ),
          Divider(height: 1.0,),
        ],
      )
    );
  }
}
