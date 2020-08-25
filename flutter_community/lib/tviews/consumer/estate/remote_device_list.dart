
import 'package:flutter/material.dart';
import 'package:helloworld/blocs/bloc_index.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/data/protocol/consumer_models.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/util_index.dart';

//远程开门
class RemoteDeviceListPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    final MainBloc _mainBloc =  BlocProvider.of<MainBloc>(context);
    _mainBloc.getDeviceList();

    return Scaffold(
      appBar: AppBar(
        title: Text('远程开门'),
        flexibleSpace: Image(
          image: AssetImage(Utils.getImgPath('home_top')),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
      ),
      body:
      new ListView(
        children: <Widget>[
          StreamBuilder(
              stream: _mainBloc.deviceListDataStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<DeviceModel>> snapshot) {
                int loadStatus = Utils.getLoadStatus(snapshot.hasError, snapshot.data);
                if(loadStatus == LoadStatus.empty || snapshot.data == null){
                  return StatusViews(
                    loadStatus,
                    onTap: (){
                      _mainBloc.getDeviceList();
                    },
                  );
                }
                return buildList(snapshot.data,_mainBloc);
              }),
        ],
      ),
    );
  }

  Widget buildList(List<DeviceModel> list,MainBloc _mainBloc){
    return Container(
      color: Colors.white,
      child: Column(
        children: list.map((item){
          return ListTile(
            leading: Icon(Icons.lock_open,color: Colours.app_main),
            title: Text(item.name),
            onTap: () async {
              Loading.show(text:'开门中，请稍候...');
              _mainBloc.remoteOpenDoor(item.id).then((res){
                  Loading.close();
              }).catchError((err){
                  Loading.close();
              });
            },
          );
        }).toList(),
      ),
    );
  }

}