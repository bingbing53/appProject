
import 'package:amap_base_location/amap_base_location.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/blocs/bloc_index.dart';
import 'package:helloworld/data/protocol/consumer_models.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/routers/application.dart';
import 'package:helloworld/routers/routers.dart';
import 'package:helloworld/tviews/h_main_page.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';
import 'package:permission_handler/permission_handler.dart';

/**
 * 选择社区
 */
class SelectPlacePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return SelectPlacePageState();
  }
}

class SelectPlacePageState extends State<SelectPlacePage> {
  final _amapLocation = AMapLocation();
  List<Location> _result = [];

  MainBloc _mainBloc;

  @override
  void initState() {
    super.initState();
    _mainBloc = BlocProvider.of<MainBloc>(context);
    getLocation();

    _mainBloc.getDepartAreaByParentId(level: 0);

    if(mounted) {
      String sysOrgCode = SpUtil.getString(
          SharedPreferencesKeys.sysOrgCode, defValue: '');
      if (sysOrgCode == '') {
        SpUtil.putString(SharedPreferencesKeys.sysOrgCode, 'A05A01A01A01');
        SpUtil.putString(SharedPreferencesKeys.streetValue, '果岭里社区');
        _mainBloc.getStaticInfo();
        _mainBloc.bindOrg('A05A01A01A01');
      }
    }
  }

  Future getLocation() async {
    await PermissionHandler().requestPermissions([PermissionGroup.location]);
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    if (permission == PermissionStatus.granted) {
      _amapLocation.init();
      final options = LocationClientOptions(
        isOnceLocation: true,
        locatingWithReGeocode: true,
      );

      _amapLocation.startLocate(options).map(_result.add).listen((_){
        if(_result.length > 0){
          _mainBloc.getDepartByLonlat(_result[0].longitude,_result[0].latitude,'0');
        }
      });

    } else {
      Fluttertoast.showToast(msg: '拒绝了获取您的位置');
    }
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(
        title: Text('社区选择'),
        flexibleSpace: Image(
        image: AssetImage(Utils.getImgPath('home_top')),
        fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,

      ),
      body:SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: Dimens.gap_dp10,right: Dimens.gap_dp10,top: Dimens.gap_dp15),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new StreamBuilder(
                    stream: _mainBloc.sysDepartListDataStream,
                    builder: (BuildContext context,  AsyncSnapshot<List> snapshot) {
                      print(snapshot.data );
                      if(snapshot.data == null){
                        return Container();
                      }
                      List<SysDepartModel> departModels = snapshot.data;
                      SysDepartModel model;
                      for(var i = 0;i<departModels.length;i++){
                        if(departModels[i].departTypeCategory == 6){
                          model = departModels[i];
                          break;
                        }
                      }
                      if(model != null) {
                        return GestureDetector(
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(bottom: Dimens.gap_dp10),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                    Icons.location_on, color: Colours.app_main),
                                Text('定位显示您在：'),
                                Text(model.departName ?? '')
                              ],
                            ),
                          ),
                          onTap: () {
                            SpUtil.putString(SharedPreferencesKeys.sysOrgCode,
                                model.orgCode);
                            SpUtil.putString(SharedPreferencesKeys.streetValue,
                                model.departName ?? '');
                            _mainBloc.getStaticInfo();
                            _mainBloc.bindOrg(model.orgCode);
                            Navigator.pop(context);
                          },
                        );
                      }else{
                        return SizedBox(height:0);
                      }
                    }),

                Divider(color: Colours.divider),
                new StreamBuilder(
                stream: _mainBloc.firstSelectDepartListDataStream,
                builder: (BuildContext context,  AsyncSnapshot<List> snapshot) {
                  if(snapshot.data == null)
                    return Container(height: 60);
                  return Wrap(
                    spacing: 2, //主轴上子控件的间距
                    runSpacing: 5, //交叉轴上子控件之间的间距
                    children: buildProvince(snapshot.data,0),
                  );
                }),
                Divider(color: Colours.divider),
                new StreamBuilder(
                    stream: _mainBloc.secondSelectDepartListDataStream,
                    builder: (BuildContext context,  AsyncSnapshot<List> snapshot) {
                      if(snapshot.data == null)
                        return Container(height: 60);
                      return Wrap(
                        spacing: 2, //主轴上子控件的间距
                        runSpacing: 5, //交叉轴上子控件之间的间距
                        children: buildProvince(snapshot.data,1),
                      );
                    }),
                Divider(color: Colours.divider),
                new StreamBuilder(
                    stream: _mainBloc.thirdSelectDepartListDataStream,
                    builder: (BuildContext context,  AsyncSnapshot<List> snapshot) {
                      if(snapshot.data == null)
                        return Container(height: 60);
                      return Wrap(
                        spacing: 2, //主轴上子控件的间距
                        runSpacing: 5, //交叉轴上子控件之间的间距
                        children: buildProvince(snapshot.data,2),
                      );
                    }),
                Divider(color: Colours.divider),
                new StreamBuilder(
                    stream: _mainBloc.forthSelectDepartListDataStream,
                    builder: (BuildContext context,  AsyncSnapshot<List> snapshot) {
                      if(snapshot.data == null)
                        return Container(height: 60);
                      return Wrap(
                        spacing: 2, //主轴上子控件的间距
                        runSpacing: 5, //交叉轴上子控件之间的间距
                        children: buildProvince(snapshot.data,3),
                      );
                    }),
              ],
            ),
          )
      )

      );
  }
  String firstSelectId = '',secondSelectId = '',thirdSelectId = '',forthSelectId = '';

  List<Widget> buildProvince(List<SysDepartModel> list,int level){
    return list.map((item){
      bool selected = false;
      if(item.id == firstSelectId && level == 0){
        selected = true;
      }else if(item.id == secondSelectId && level == 1){
        selected = true;
      }else if(item.id == thirdSelectId && level == 2){
        selected = true;
      }else if(item.id == forthSelectId && level == 3){
        selected = true;
      }
      return RoundButton(
        text: item.departName,
        style: TextStyle(fontFamily: 'PingFang',color: selected ? Colors.white:Colours.text_gray),
        bgColor: selected ? Colours.app_main : Colours.divider,
        margin: EdgeInsets.symmetric(horizontal: Dimens.gap_dp5, vertical: Dimens.gap_dp5),
        radius: Dimens.gap_dp5,
        height: 35.0,
        width: item.departName.length * Dimens.font_sp16 + 10,//(MediaQuery.of(context).size.width - 80) / 4,
        onPressed: () {
          if(level == 0) {
            firstSelectId = item.id;
          }else if(level == 1){
            secondSelectId = item.id;
          }else if(level == 2){
            thirdSelectId = item.id;
          }else if(level == 3){
            forthSelectId = item.id;
            SpUtil.putString(SharedPreferencesKeys.sysOrgCode, item.orgCode);
            SpUtil.putString(SharedPreferencesKeys.streetValue, item.departName);

            _mainBloc.bindOrg(item.orgCode);

            _mainBloc.getStaticInfo();

//            Navigator.of(context).push(ModalRoute.withName("/"));
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/", ModalRoute.withName("/"));

//            Navigator.pop(context);
            return;
          }
          _mainBloc.getDepartAreaByParentId(parentId: item.id,level: level + 1);
          setState(() {

          });
        },
      );
    }).toList();

  }

}




