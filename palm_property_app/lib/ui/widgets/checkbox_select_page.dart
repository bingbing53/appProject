import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drag_scale/flutter_drag_scale.dart';
import 'package:estate/blocs/work_bloc.dart';
import 'package:estate/ui/widgets/widgets.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

//图片浏览
class ChckBoxSelect extends StatelessWidget{

  const ChckBoxSelect({Key key,this.bloc}) : super(key: key);

  final WorkBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('nihao'),
    );
  }
}