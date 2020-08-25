import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';

//选择联系人列表
class WorkUserSelect extends StatefulWidget{
  final WorkBloc bloc;
  final List<String> selected;//不显示这些
  final List<String> showList;//只显示这些
  final List<String> unShowList;//只显示这些
  final callback;//回调函数
  final Color activeColor;

  const WorkUserSelect({Key key, this.bloc,this.selected,this.showList,this.callback,this.activeColor,this.unShowList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WorkUserSelectPage();
  }
}

class _WorkUserSelectPage extends State<WorkUserSelect>{

  final int _suspensionHeight = 40;
  final int _itemHeight = 60;
  List<ContactUserModel> contactUsers = [];
  List<ContactUserModel> selectedUsers = [];
  List<ContactUserModel> searchUsers = [];

  bool firstEntry = false;

  TextEditingController _controllerName = new TextEditingController();

  @override
  void initState() {
    firstEntry = true;
    contactUsers = [];
    searchUsers = [];

    widget.bloc.getChatUserList().then((val){
      firstEntry = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Container(
          child: Wrap(
            children: buildSelectedPerson(),
          ),
        ),

//        Divider(height: 1,),
//
//        ListTile(
//          title: Text('组织机构'),
//          trailing: Icon(Icons.chevron_right),
//          onTap: (){
//            NavigatorUtil.pushPage(context, GroupUserSelectPage(),pageName: "组织机构");
//          },
//        ),
        Container(
          child: TextField(
            controller: _controllerName,
            maxLines: 1,
            autofocus: false,
            style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
            textInputAction: TextInputAction.next,
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
    );
  }

  void searchUserName(BuildContext context,String name){
    searchUsers = [];
    for(var i = 0;i<contactUsers.length;i++){
      if(contactUsers[i].realname.contains(name)){
        searchUsers.add(contactUsers[i]);
      }
    }
    print(searchUsers.length);
    buildContactUser(context,searchUsers);

    setState(() {

    });
  }

  //构建选择用户
  List<Widget> buildSelectedPerson(){
    List<Widget> persons = [];
    if(ObjectUtil.isEmpty(selectedUsers)){
      persons.add(Container(height: 0,));
    }else{
      selectedUsers.asMap().forEach((index,item){
        persons.add(GestureDetector(
          child: Container(
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
          ),
          onTap: (){
            setState(() {
              item.checked = !item.checked;
            });
            onChange();
          },
        ),
        );
      });
    }
    return persons;
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
    firstEntry = false;

//    contactUsers = list;
    List<ContactUserModel> temp = [];
    //只显示这些
    if(widget.unShowList != null && widget.unShowList.length > 0){
      temp.addAll(list);
      for(var i = 0;i<widget.unShowList.length;i++){
        temp.removeWhere((item) => item.mobilePhone == widget.unShowList[i]);
      }
    }else if(widget.showList != null && widget.showList.length > 0){
      for(var i = 0;i<widget.showList.length;i++){
        for(var j = 0;j<list.length;j++){
          if(widget.showList[i] == list[j].mobilePhone){
            temp.add(list[j]);
          }
        }
      }
    }else if(contactUsers != null && contactUsers.length > 0){
      temp.addAll(list);
      for(var i = 0;i<contactUsers.length;i++){
        temp.removeWhere((item) => item.mobilePhone == contactUsers[i]);
      }
      for(var i = 0;i<selectedUsers.length;i++){
        temp.asMap().forEach((index, item) {
          if (item.mobilePhone == selectedUsers[i].mobilePhone) {
            item.checked = true;
          }
        });
      }
    }else{
      temp.addAll(list);
    }

    String mobile = SpUtil.getString(Constant.key_login_name);
    temp.removeWhere((item) => item.mobilePhone == mobile);

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
                    Text(model.realname.length > 2 ? model.realname.substring(1,3):model.realname):
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

  void onChange(){
    selectedUsers = [];
    for(var i = 0;i<contactUsers.length;i++){
      if(contactUsers[i].checked){
        selectedUsers.add(contactUsers[i]);
      }
    }
    widget.callback(selectedUsers);
  }
}