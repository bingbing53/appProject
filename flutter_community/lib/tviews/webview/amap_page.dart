import 'package:flutter/material.dart';
import 'package:helloworld/components/disclaimer_msg.dart';
//import 'package:flutter_map/flutter_map.dart';
//import 'package:latlong/latlong.dart';
GlobalKey<DisclaimerMsgState> key;

class AMapPage extends StatefulWidget {

  final String url,title;

  AMapPage(this.url,this.title);

  @override
  AMapPageState createState() => new AMapPageState();
}

class AMapPageState extends State<AMapPage>{

//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//  static LatLng london = LatLng(51.5, -0.09);
//  static LatLng paris = LatLng(48.8566, 2.3522);
//  static LatLng dublin = LatLng(53.3498, -6.2603);
//
//  MapController mapController;
//
//  @override
//  void initState() {
//    super.initState();
//    mapController = MapController();
//  }
//
//  @override
  Widget build(BuildContext context) {
  }
//    var markers = <Marker>[
//      Marker(
//        width: 40.0,
//        height: 40.0,
//        point: london,
//        builder: (ctx) => Container(
//          key: Key('blue'),
//          child: FlutterLogo(),
//        ),
//      ),
////      Marker(
////        width: 80.0,
////        height: 80.0,
////        point: dublin,
////        builder: (ctx) => Container(
////          child: FlutterLogo(
////            key: Key('green'),
////            colors: Colors.green,
////          ),
////        ),
////      ),
////      Marker(
////        width: 80.0,
////        height: 80.0,
////        point: paris,
////        builder: (ctx) => Container(
////          key: Key('purple'),
////          child: FlutterLogo(colors: Colors.purple),
////        ),
////      ),
//    ];
//
//    return Scaffold(
//      key: _scaffoldKey,
//      appBar: AppBar(title: Text('地图显示')),
////      drawer: buildDrawer(context, MapControllerPage.route),
//      body: Padding(
//        padding: EdgeInsets.all(0.0),
//        child: Column(
//          children: [
//            Flexible(
//              child: FlutterMap(
//                mapController: mapController,
//                options: MapOptions(
//                  center: LatLng(51.5, -0.09),
//                  zoom: 5.0,
//                  maxZoom: 5.0,
//                  minZoom: 3.0,
//                ),
//                layers: [
//                  TileLayerOptions(
//                      urlTemplate:
//                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                      subdomains: ['a', 'b', 'c']),
//                  MarkerLayerOptions(markers: markers)
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }

}


