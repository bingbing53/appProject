import 'dart:async';
import 'package:helloworld/common/sql.dart';

abstract class MessageInterface{
    int get id;
    //类目名称
    String get name;
    //描述
    String get desc;
    //第几级类目，默认 1
    int get depth;
    //父类目id，没有为 0
    int get parentId;
}

class Message implements MessageInterface {
  int id;
  String name;
  String desc;
  int depth;
  int parentId;

  Message({this.id, this.name, this.desc, this.depth, this.parentId});

  Message.fromJSON(Map json)
      : id = json['id'],
        name = json['name'],
        desc = json['desc'],
        depth = json['depth'],
        parentId = json['parentId'];

  String toString() {
    return '(Cat $name)';
  }

  Map toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'depth': depth,
      'parentId': parentId
    };
  }
  Map toSqlCondition() {
    Map _map = this.toMap();
    Map condition = {};
    _map.forEach((k, value) {

      if (value != null) {

        condition[k] = value;
      }
    });

    if (condition.isEmpty) {
      return {};
    }

    return condition;
  }
}


class MessageControlModel{
  final String table = 'message';
  Sql sql;
  MessageControlModel() {
    sql = Sql.setTable(table);
  }

  /// 获取一级类目
  Future<List> mainList() async{
    List listJson =  await sql.getByCondition(conditions: {'parentId': 0});
    List<Message> cats = listJson.map((json) {
        return new Message.fromJSON(json);
    }).toList();
    return cats;
  }

  // 获取Cat不同深度与parent的列表
  Future<List<Message>> getList([Message cat]) async{


    if (cat == null) {
      cat = new Message(depth: 1, parentId: 0);
    }
    // print("cat in getList ${cat.toMap()}");
    List listJson =  await sql.getByCondition(conditions: cat.toSqlCondition());
    List<Message> cats = listJson.map((json) {
      return new Message.fromJSON(json);
    }).toList();
    return cats;
  }

  // 通过name获取Cat对象信息
  Future<Message> getCatByName(String name) async {
    List json = await sql.getByCondition(conditions: {'name': name});
    if (json.isEmpty) {
      return null;
    }
    return new Message.fromJSON(json.first);
  }

}
