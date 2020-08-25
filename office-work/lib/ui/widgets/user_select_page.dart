import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';

//选择联系人列表
class UserSelectPage extends StatefulWidget{
  final WorkBloc bloc;
  final List<ContactUserModel> selected;//这些默认选中
  final List<ContactUserModel> unShowList;//这些不显示
  final bool showMe;//是否显示我自己
  final callback;//回调函数
  final Color activeColor;
  final int maxSelect;

  const UserSelectPage({Key key, this.bloc,this.selected,this.unShowList,this.callback,this.activeColor,this.showMe,this.maxSelect}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserSelectPage();
  }
}

class _UserSelectPage extends State<UserSelectPage>{

  final int _suspensionHeight = 40;
  final int _itemHeight = 60;
  List<ContactUserModel> contactUsers = [];
  List<ContactUserModel> selectedUsers = [];
  //搜索的用户
  List<ContactUserModel> searchUsers = [];

  bool firstEntry = false;

  TextEditingController _controllerName = new TextEditingController();

  @override
  void initState() {
    contactUsers = [];
    searchUsers = [];
    firstEntry = true;
    selectedUsers = widget.selected;
    widget.bloc.getChatUserList().then((val){
      firstEntry = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('选择用户'),
          actions: <Widget>[
            /*contactUsers.length <= 0 ? IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              widget.bloc.getChatUserList();
            },
          ):*/IconButton(
              icon: Icon(Icons.sort),
              onPressed: (){
                Utils.changeChatUserSort();
                firstEntry = true;
                widget.bloc.getChatUserList();
              },
            ),
            FlatButton(
              child: Text('确认',style: TextStyle(fontSize:Dimens.font_sp18,color: /*selectedUsers.length > 0 ?*/ Colors.white/*:Colours.text_gray*/),),
              onPressed: () {
                widget.callback(selectedUsers);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Wrap(
                    children: buildSelectedPerson(),
                  ),
                ),

                Container(
                  child: TextField(
                    controller: _controllerName,
                    maxLines: 1,
                    autofocus: false,
                    style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
                    textInputAction: TextInputAction.done,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: "请输入姓名搜索",
                      hintStyle:TextStyle(fontSize: Dimens.font_sp16),
                    ),
                    maxLength: 10,
                    maxLengthEnforced: true,
                    onChanged: (val){
                      searchUserName(context,val);
                    },
                  ),
                ),
                SizedBox(height: 5,),
                Expanded(
                  flex: 1,
                  child:StreamBuilder(
                      stream:widget.bloc.contactUserListReposStream,
                      builder:(BuildContext context,
                          AsyncSnapshot<List<ContactUserModel>> snapshot) {
                        if(ObjectUtil.isNotEmpty(snapshot.data)){
                          contactUsers = snapshot.data;
                        }

                        if(!firstEntry && _controllerName.text.length > 0)
                          return buildContactUser(context, searchUsers);

                        return buildContactUser(context, snapshot.data);
                      }
                  ),
                )
              ],
            )
        )
    );
  }
  //构建选择用户
  List<Widget> buildSelectedPerson(){
    List<Widget> persons = [];
    if(ObjectUtil.isEmpty(selectedUsers)){
      persons.add(Container(height: 0,));
    }else{
      selectedUsers.asMap().forEach((index,item){
        persons.add(GestureDetector(
            onTap: (){
              removeUser(index);
            },
            child:Container(
                height: 60,
                width: 60,
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 23,
                  child:  item.portrait == null ?
                  Text(item.realname.length > 2 ? item.realname.substring(1,3):item.realname):
                  ClipOval(
                    child:CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: '${item.portrait}',
                    ),
                  ),
                )
            ))
        );
      });
    }
    return persons;
  }

  void searchUserName(BuildContext context,String name){
    searchUsers = [];
    for(var i = 0;i<contactUsers.length;i++){
      if(contactUsers[i].realname.contains(name)){
        searchUsers.add(contactUsers[i]);
      }
    }
    buildContactUser(context,searchUsers);

    setState(() {

    });
  }

  Widget buildContactUser(BuildContext context, List<ContactUserModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }

    if(firstEntry){
      for(var i = 0;i<list.length;i++){
        list[i].checked = false;
      }
    }
    List<ContactUserModel> temp = [];
    if(selectedUsers != null && selectedUsers.length > 0){
      //这些默认选中
      temp.addAll(list);
      for(var i = 0;i<selectedUsers.length;i++){
        if(firstEntry) {
          temp.asMap().forEach((index, item) {
            if (item.mobilePhone == selectedUsers[i].mobilePhone) {
              item.checked = true;
            }
          });
//          print(firstEntry);
        }
      }
    }else if(widget.unShowList != null && widget.unShowList.length > 0){
      temp.addAll(list);
      for(var i = 0;i<widget.unShowList.length;i++){
        temp.removeWhere((item) => widget.unShowList[i].mobilePhone == item.mobilePhone);
      }
    }else{
      temp.addAll(list);
    }
    if(!widget.showMe) {
      String mobile = SpUtil.getString(Constant.key_login_name);
      temp.removeWhere((item) => item.mobilePhone == mobile);
    }
    firstEntry = false;
    return Container(
        color: Colors.white,
        child: AzListView(
          data: temp,
          itemBuilder: (context, model) => _buildListItem(model,context),
          isUseRealIndex: true,
          itemHeight: _itemHeight,
          suspensionHeight: _suspensionHeight,
          onSusTagChanged: widget.bloc.susTagChanged,
        )
    );
  }

  Widget _buildSusWidget(String susTag) {
    return Container(
      height: _suspensionHeight.toDouble() / 2,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      color: Colours.gray_f0,
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
            fontSize: 12.0,
            color: Colours.text_normal
        ),
      ),
    );
  }

  Widget _buildListItem(ContactUserModel model,BuildContext context) {
    String susTag = model.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(model.tagSeparator),
        ),
        GestureDetector(
          child:
          Row(
            children: <Widget>[
              Container(
                  height: 65,
                  padding: EdgeInsets.only(left: 15.0,right: 20.0),
                  child: CircleAvatar(
                    radius: 23,
                    child:  ObjectUtil.isEmpty(model.portrait) ?
                    Text(model.realname.length > 2 ? model.realname.substring(1,3) : model.realname):
                    ClipOval(
                      child:CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: '${model.portrait}',
                        width: 46,
                        height: 46,
                      ),
                    ),
                  )
              ),
              Expanded(
                  child: GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
//                        Text('${model.realname}',style: TextStyle(fontSize: Dimens.font_sp16,color: model.browser != '1' ? Colors.grey:Colors.black),),
                        Row(
                          children: <Widget>[
                            Text('${model.realname} ',style: TextStyle(fontSize: Dimens.font_sp16,color: model.browser != '1' ? Colors.grey:Colors.black),),
                            Text('${ObjectUtil.isNotEmpty(model.officeName)?'${model.officeName}':''}',style: TextStyle(fontSize: Dimens.font_sp12,color:Colours.text_gray),)
                          ],
                        ),
                        SizedBox(height: 5.0,),
                        Text('${model.personType}  ${model.departname}',style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),),
                      ],
                    ),
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      setState(() {
                        model.checked = !model.checked;
                      });
                      onChange();
                    },
                  )
              ),
              Container(
                margin: EdgeInsets.only(right: Dimens.gap_dp20),
                child:Checkbox(
                    tristate:false,
                    value: model.checked,
                    activeColor:widget.activeColor??Colors.blueAccent,
                    onChanged: (bool bol) {
                      setState(() {
                        model.checked = bol;
                      });
                      onChange();
                    }
                ),
              )
            ],
          ),
        ),
        Divider(height: 1.0,color: Colours.gray_ce,)
      ],
    );
  }

  void removeUser(index){
    ContactUserModel contactUserModel = selectedUsers[index];
    for(var i = 0;i<contactUsers.length;i++){
      if(contactUsers[i].id == contactUserModel.id){
        setState((){
          contactUsers[i].checked = false;
        });
        break;
      }
    }
    selectedUsers.removeAt(index);
  }

  void onChange(){
    selectedUsers = [];
    for(var i = 0;i<contactUsers.length;i++){
      if(contactUsers[i].checked){
        selectedUsers.add(contactUsers[i]);
      }
    }
    if(widget.maxSelect != null && widget.maxSelect >= selectedUsers.length){
      Navigator.pop(context);
      widget.callback(selectedUsers);
    }
  }
}