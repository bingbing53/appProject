import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/blocs/bloc_index.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/protocol/mission_models.dart';
import 'package:flutter_wanandroid/res/res_index.dart';

//新建任务
class MineInfoPage extends StatefulWidget{

  const MineInfoPage({Key key, this.labelId}) : super(key: key);

  final String labelId;

  @override
  State<StatefulWidget> createState() {
    return _MineInfoPageState();
  }
}

class _MineInfoPageState extends State<MineInfoPage>{
  WorkBloc workBloc;

  TextEditingController _controllerName = new TextEditingController();
  TextEditingController _controllerIdCard = new TextEditingController();
  TextEditingController _controllerPhone = new TextEditingController();
  TextEditingController _controllerAddress = new TextEditingController();
  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerDuty = new TextEditingController();
  TextEditingController _controllExperience= new TextEditingController();
  TextEditingController _controllStation= new TextEditingController();

  UserInfoModel _userInfoModel;
  DateTime _pickerBirthday;
  DateTime _pickerStartWorkDay;

  List<PickerItem> sexPickerItem = [];
  List<PickerItem> nationlPickerItem = [];
  List<PickerItem> eduLevelPickerItem = [];
  List<PickerItem> polityPickerItem = [];

  @override
  void initState() {
    super.initState();
    workBloc = BlocProvider.of<WorkBloc>(context);

    workBloc.getMineData();

    _userInfoModel = new UserInfoModel();

    workBloc.userinfoReposStream.listen((user){
      _userInfoModel = user;
      _controllerName.text = user.realname;
      _controllerIdCard.text = user.citizenNo;
      _controllerPhone.text = user.officePhone;
      _controllerAddress.text = user.address;
      _controllerEmail.text = user.email;
      _controllerDuty.text = user.memo;
      _controllExperience.text = user.workHistory;
      _controllStation.text = user.station;

      if(ObjectUtil.isNotEmpty(user.birthday)){
        _pickerBirthday = DateUtil.getDateTime(user.birthday);
      }
      if(ObjectUtil.isNotEmpty(user.startWork)){
        _pickerStartWorkDay = DateUtil.getDateTime(user.startWork);
      }

      workBloc.getDictionaryList("sex,national,edu_level,polity").then((result){
        List sex = result['sex'];
        for(var i = 0;i<sex.length;i++){
          sexPickerItem.add(PickerItem(text: Text('${sex[i]['typename']}'),value: '${jsonEncode(sex[i])}'));

          if(ObjectUtil.isNotEmpty(_userInfoModel.sex) && sex[i]['typecode'] == _userInfoModel.sex){
            setState(() {
              _userInfoModel.sexName = sex[i]['typename'];
            });
          }
        }

        List national = result['national'];
        for(var i = 0;i<national.length;i++){
          nationlPickerItem.add(PickerItem(text: Text('${national[i]['typename']}'),value: '${jsonEncode(national[i])}'));

          if(ObjectUtil.isNotEmpty(_userInfoModel.national) && national[i]['typecode'] == _userInfoModel.national){
            setState(() {
              _userInfoModel.nationalName = national[i]['typename'];
            });
          }
        }

        List edulevel = result['edu_level'];
        for(var i = 0;i<edulevel.length;i++){
          eduLevelPickerItem.add(PickerItem(text: Text('${edulevel[i]['typename']}'),value: '${jsonEncode(edulevel[i])}'));

          if(ObjectUtil.isNotEmpty(_userInfoModel.eduLevel) && edulevel[i]['typecode'] == _userInfoModel.eduLevel){
            setState((){
              _userInfoModel.eduLevelName = edulevel[i]['typename'];
            });
          }
        }

        List polity = result['polity'];
        for(var i = 0;i<polity.length;i++){
          polityPickerItem.add(PickerItem(text: Text('${polity[i]['typename']}'),value: '${jsonEncode(polity[i])}'));
          if(ObjectUtil.isNotEmpty(_userInfoModel.polity) && polity[i]['typecode'] == _userInfoModel.polity){
            setState((){
              _userInfoModel.polityName = polity[i]['typename'];
            });
          }
        }

        setState(() {});

      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的信息'),
        actions: <Widget>[
          FlatButton(onPressed: (){
            submitForm();
          }, child: Text('提交',style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp16),)
          )
        ],
      ),
      body: Container(
        child: Form(
          child: ListView(
            children:<Widget>[

              createName(),
              createSex(),
//              createIdCard(),
              createBirthday(),
              createNation(),
              createPolity(),
              SizedBox(height: 15.0,),
              createEdulevel(),
              SizedBox(height: 15.0,),
              createStation(),
              createStartWorkDay(),
              createPhone(),
              createAddress(),
              createEmail(),
              SizedBox(height: 15.0,),
              createDuty(),
              createExperience(),
            ],
          ),
        ),
      )
    );
  }

  //提交form表单
  void submitForm() async{

    _userInfoModel.realname = _controllerName.text;
    _userInfoModel.citizenNo = _controllerIdCard.text;
    _userInfoModel.officePhone = _controllerPhone.text;
    _userInfoModel.address =  _controllerAddress.text ;
    _userInfoModel.email = _controllerEmail.text;
    _userInfoModel.memo = _controllerDuty.text;
    _userInfoModel.workHistory = _controllExperience.text;
    _userInfoModel.station = _controllStation.text;

//    if(ObjectUtil.isNotEmpty(_userInfoModel.citizenNo) && !RegexUtil.isIDCard(_userInfoModel.citizenNo)){
//      Fluttertoast.showToast(msg:'请输入正确的身份证');
//      return;
//    }

    if(_userInfoModel.polity == 'null' || _userInfoModel.polity == null){
      _userInfoModel.polity = '';
    }

    if(ObjectUtil.isNotEmpty(_userInfoModel.email) && !RegexUtil.isEmail(_userInfoModel.email)){
      Fluttertoast.showToast(msg:'请输入正确的邮箱');
      return;
    }

    workBloc.updateMineInfo(context,_userInfoModel);

  }

  Widget createName(){
    return Container(
          color: Colors.white,
          padding: EdgeInsets.only(left:10.0,right: 10),
          child: Row(
            children: <Widget>[
              Container(child:Text('姓名'),width:80,alignment: Alignment.centerLeft,),
              Expanded(
                child: TextField(
                  controller: _controllerName,
                  maxLines: 1,
                  autofocus: false,
                  style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
                  textInputAction: TextInputAction.next,
                  decoration: new InputDecoration(
                      hintText: "请输入真实姓名",
                      hintStyle:TextStyle(fontSize: Dimens.font_sp16)
                  ),
                ),
              ),
            ],
          )
      );
  }

  Widget createSex(){
    return  Container(
        padding: EdgeInsets.all(10.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(child:Text('性别'),width:80,),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(padding:EdgeInsets.only(top: 5,bottom: 5),child: Text(ObjectUtil.isEmpty(_userInfoModel.sexName)?'点击选择性别':_userInfoModel.sexName),),
              onTap: (){
                Picker(
                    adapter: PickerDataAdapter(
                      data: sexPickerItem
                    ),
                    hideHeader: true,
                    title: Text("请选择性别"),
                    confirmText: '确认',
                    cancelText: '取消',
                    selectedTextStyle: TextStyle(color: Colors.blue),
                    onConfirm: (Picker picker, List value) {
                      if(ObjectUtil.isNotEmpty(picker.getSelectedValues()) && picker.getSelectedValues().length > 0){
                        _userInfoModel.sex = jsonDecode(picker.getSelectedValues()[0])['typecode'];
                        _userInfoModel.sexName = jsonDecode(picker.getSelectedValues()[0])['typename'];
                        setState((){});
                      }
                    }
                ).showDialog(context);
              },
            )
          ],
        )
    );
  }

  Widget createIdCard(){
    return Container(
                padding: EdgeInsets.only(left: 10.0,right: 10.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(width:80,child:Text('身份证'),),
            Expanded(
              child: TextField(
                controller: _controllerIdCard,
                maxLines: 1,
                autofocus: false,
                style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                    hintText: "请输入身份证",
                    hintStyle:TextStyle(fontSize: Dimens.font_sp16)
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget createBirthday(){
    return Container(
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Container(width:80,child:Text('出生日期')),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Container(padding:EdgeInsets.only(top: 5,bottom: 5),child: Text(ObjectUtil.isEmpty(_userInfoModel.birthday)?'点击选择出生日期':_userInfoModel.birthday),),
                onTap: (){
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      onChanged: (date) {
                      },
                      onConfirm: (date) {
                        _userInfoModel.birthday = DateUtil.getDateStrByDateTime(date,format: DateFormat.YEAR_MONTH_DAY);
                        _pickerBirthday = date;
                        setState((){});
                      },
                      currentTime: DateTime(2015),
                      locale: LocaleType.zh
                  );
                },
              )
            ],
          )
      );
  }

  Widget createNation(){
    return Container(
                padding: EdgeInsets.all(10.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(width:80,child:Text('民族')),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(padding:EdgeInsets.only(top: 5,bottom: 5),child: Text(ObjectUtil.isEmpty(_userInfoModel.nationalName)?'点击选择民族':_userInfoModel.nationalName),),
              onTap: (){
                Picker(
                    adapter: PickerDataAdapter(
                        data: nationlPickerItem
                    ),
                    hideHeader: true,
                    title: Text("请选择民族"),
                    confirmText: '确认',
                    cancelText: '取消',
                    selectedTextStyle: TextStyle(color: Colors.blue),
                    onConfirm: (Picker picker, List value) {
                      if(ObjectUtil.isNotEmpty(picker.getSelectedValues()) && picker.getSelectedValues().length > 0){
                        _userInfoModel.national = jsonDecode(picker.getSelectedValues()[0])['typecode'];
                        _userInfoModel.nationalName = jsonDecode(picker.getSelectedValues()[0])['typename'];
                        setState((){});
                      }
                    }
                ).showDialog(context);
              },
            ),
          ],
        )
    );
  }

  //创建政治面貌
  Widget createPolity(){
    return Container(
                padding: EdgeInsets.all(10.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(width:80,child:Text('政治面貌')),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(padding:EdgeInsets.only(top: 5,bottom: 5),child: Text(ObjectUtil.isEmpty(_userInfoModel.polityName)?'点击选择政治面貌':_userInfoModel.polityName),),
              onTap: (){
                Picker(
                    adapter: PickerDataAdapter(
                        data: polityPickerItem
                    ),
                    hideHeader: true,
                    title: Text("请选择政治面貌"),
                    confirmText: '确认',
                    cancelText: '取消',
                    selectedTextStyle: TextStyle(color: Colors.blue),
                    onConfirm: (Picker picker, List value) {
                      if(ObjectUtil.isNotEmpty(picker.getSelectedValues()) && picker.getSelectedValues().length > 0){
                        _userInfoModel.polity = jsonDecode(picker.getSelectedValues()[0])['typecode'];
                        _userInfoModel.polityName = jsonDecode(picker.getSelectedValues()[0])['typename'];
                        setState((){});
                      }
                    }
                ).showDialog(context);
              },
            )
          ],
        )
    );
  }

  Widget createEdulevel(){
    return Container(
                padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 10,bottom: 10.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(width:80,child:Text('教育程度')),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(padding:EdgeInsets.only(top: 5,bottom: 5),child: Text(ObjectUtil.isEmpty(_userInfoModel.eduLevelName)?'点击选择教育程度':_userInfoModel.eduLevelName),),
              onTap: (){
                Picker(
                    adapter: PickerDataAdapter(
                        data: eduLevelPickerItem
                    ),
                    hideHeader: true,
                    title: Text("请选择教育程度"),
                    confirmText: '确认',
                    cancelText: '取消',
                    selectedTextStyle: TextStyle(color: Colors.blue),
                    onConfirm: (Picker picker, List value) {
                      if(ObjectUtil.isNotEmpty(picker.getSelectedValues()) && picker.getSelectedValues().length > 0){
                        _userInfoModel.eduLevel = jsonDecode(picker.getSelectedValues()[0])['typecode'];
                        _userInfoModel.eduLevelName = jsonDecode(picker.getSelectedValues()[0])['typename'];
                        setState((){});
                      }
                    }
                ).showDialog(context);
              },
            )
          ],
        )
    );
  }

  Widget createPhone(){
    return  Container(
                padding: EdgeInsets.only(left: 10.0,right: 10.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(width:80,child:Text('办公座机')),
            Expanded(
              child: TextField(
                controller: _controllerPhone,
                maxLines: 1,
                autofocus: false,
                style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: new InputDecoration(
                    hintText: "请输入办公座机",
                    hintStyle:TextStyle(fontSize: Dimens.font_sp16)
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget createStation(){
    return  Container(
                padding: EdgeInsets.only(left: 10.0,right: 10.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(width:80,child:Text('工作岗位')),
            Expanded(
              child: TextField(
                controller: _controllStation,
                maxLines: 1,
                autofocus: false,
                style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: new InputDecoration(
                    hintText: "请输入工作岗位",
                    hintStyle:TextStyle(fontSize: Dimens.font_sp16)
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget createStartWorkDay(){
    return Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(width:80,child:Text('本社区工作时间')),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(padding:EdgeInsets.only(top: 5,bottom: 5),child: Text(ObjectUtil.isEmpty(_userInfoModel.startWork)?'点击选择本社区工作时间':_userInfoModel.startWork),),
              onTap: (){
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    onChanged: (date) {
                    },
                    onConfirm: (date) {
                      _userInfoModel.startWork = DateUtil.getDateStrByDateTime(date,format: DateFormat.YEAR_MONTH_DAY);
                      _pickerStartWorkDay = date;
                      setState((){});
                    },
                    currentTime: DateTime(1990),
                    locale: LocaleType.zh
                );
              },
            )
          ],
        )
    );
  }

  Widget createAddress(){
    return Container(
                padding: EdgeInsets.only(left: 10.0,right: 10.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(width:80,child:Text('联系地址')),
            Expanded(
              child: TextField(
                controller: _controllerAddress,
                maxLines: 2,
                autofocus: false,
                style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
                decoration: new InputDecoration(
                    hintText: "请输入联系地址",
                    hintStyle:TextStyle(fontSize: Dimens.font_sp16)
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget createEmail(){
    return Container(
                padding: EdgeInsets.only(left: 10.0,right: 10.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(width:80,child:Text('邮箱')),
            Expanded(
              child: TextField(
                controller: _controllerEmail,
                maxLines: 1,
                autofocus: false,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
                decoration: new InputDecoration(
                    hintText: "请输入邮箱",
                    hintStyle:TextStyle(fontSize: Dimens.font_sp16)
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget createDuty(){
    return Container(
      color: Colors.white,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(child:Text('岗位职责'),padding: EdgeInsets.only(left: 10.0,top: 10.0),),
            TextField(
              controller: _controllerDuty,
              maxLines: 5,
              autofocus: false,
              style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
              textInputAction: TextInputAction.next,
              decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(Dimens.gap_dp10),
                  hintText: "请输入岗位职责",
                  hintStyle:TextStyle(fontSize: Dimens.font_sp16)
              ),
            ),
          ]
      )
    );
  }

  Widget createExperience(){
    return  Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(child:Text('工作经历'),padding: EdgeInsets.only(left: 10.0,top: 10.0),),
            TextField(
              controller: _controllExperience,
              maxLines: 5,
              autofocus: false,
              style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
              textInputAction: TextInputAction.done,
              decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(Dimens.gap_dp10),
                  hintText: "请输入工作经历",
                  hintStyle:TextStyle(fontSize: Dimens.font_sp16)
              ),
            ),
          ],
        )
    );
  }

}