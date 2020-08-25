import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/ui/pages/page_index.dart';
import 'package:flutter_wanandroid/ui/pages/rec_hot_page.dart';

//组织机构
class ChatGroupPage extends StatefulWidget {

  const ChatGroupPage({Key key, this.labelId}) : super(key: key);
  final String labelId;

  @override
  State<StatefulWidget> createState() {
    return _ChatGroupPageState();
  }

}

class _ChatGroupPageState extends State<ChatGroupPage>{

  final int _suspensionHeight = 40;
  final int _itemHeight = 60;
  List<DepartModel> allDepartData = [];

  List<DepartModel> selectedModel = [];

  WorkBloc bloc;
  @override
  void initState() {
    super.initState();

    selectedModel = [];
    allDepartData = [];

    bloc = BlocProvider.of<WorkBloc>(context);
    bloc.getChatGroupList();
  }

  Widget _buildListItem(ContactUserModel model) {
    if(model == null || model.id == null)
      return Container(height: 0);

    model.portrait = WanAndroidApi.format(model.portrait,size: 1);
    return Column(
        children: <Widget>[
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
                        Text(model.realname.substring(0,1)):
                        ClipOval(
                          child:CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: '${model.portrait}',
                          ),
                        ),
                      )
                  ),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${model.realname}',style: TextStyle(fontSize: Dimens.font_sp16),),
                          SizedBox(height: 5.0,),
                          Text('${model.personType}',style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),),
                        ],
                      )
                  )
                ],
              ),
            onTap: (){
                NavigatorUtil.pushPage(context, ChatUserPage(userModel: model,),pageName: model.realname);
            },
            behavior: HitTestBehavior.translucent,
          ),
          Divider(height: 1.0,color: Colours.gray_ce,)
        ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("组织机构"),
      ),
      body: ListView(
        children: <Widget>[
          buildTopBar(),
          StreamBuilder(
              stream:bloc.departReposStream,
              builder:(BuildContext context,
                  AsyncSnapshot<List<DepartModel>> snapshot) {
                allDepartData = snapshot.data;
                return buildDepart();
              }
          ),
          StreamBuilder(
              stream:bloc.groupUserListReposStream,
              builder:(BuildContext context,
                  AsyncSnapshot<List<ContactUserModel>> snapshot) {
                return buildPerson(snapshot.data);
              }
          ),
        ],
      )/*Column(
            children: <Widget>[

            ],
          )*/
    );
  }

  //组织机构
  Widget buildTopBar(){
    List<Widget> items = [];

    if(ObjectUtil.isEmptyList(selectedModel)){
      return Container(height: 0);
    }
    for(int i = 0;i < selectedModel.length;i++){
      items.add(
        GestureDetector(
          onTap: (){
            selectedModel = selectedModel.sublist(0,i+1);
            buildDepart();
            setState(() {
            });
          },
          child: Container(
            padding: EdgeInsets.only(top:10),
            child: Text('${selectedModel[i].departname} >',style: TextStyle(fontSize: Dimens.font_sp16),)
          )
        )
      );
    }
    return Container(
      height: 50.0,
      padding: EdgeInsets.only(left: 10.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items,
      )
    );
  }

  //构建部门
  Widget buildDepart(){
    bloc.getChatOrgUserList('');
    if(ObjectUtil.isEmptyList(allDepartData)){
      return Container(height: 0);
    }
    List<DepartModel> showDepart = [];
    if(selectedModel.length == 0){
      showDepart.add(allDepartData[0]);
      for(var i = 1;i<allDepartData.length;i++){
        if(allDepartData[i].len == allDepartData[0].len)
          showDepart.add(allDepartData[i]);
      }
    }else{
      DepartModel nowDepart = selectedModel[selectedModel.length - 1];
      for(var i = 1;i<allDepartData.length;i++){
        if(allDepartData[i].len == nowDepart.len + 3 && allDepartData[i].orgCode.startsWith(nowDepart.orgCode))
          showDepart.add(allDepartData[i]);
      }
      bloc.getChatOrgUserList(nowDepart.orgCode);
    }

    List<Widget> items = [];

    for(var i = 0;i<showDepart.length;i++){
      items.add(
        ListTile(
          leading: CircleAvatar(
            radius: 20,
            child:  (showDepart[i].logo??'') == '' ?
            Text(showDepart[i].departname.substring(0,2)):
            ClipOval(
              child:CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: '${showDepart[i].logo}',
              ),
            ),
          ),
          title: Text(showDepart[i].departname),
          trailing: Icon(Icons.chevron_right),
          onTap: (){
            selectedModel.add(showDepart[i]);
            buildDepart();
            setState(() {

            });
          },
        )
      );
      items.add(Divider(height: 1,));
    }

    return Container(
      color: Colors.white,
      child: Column(
          children: items,
      ),
    );
  }

  //构建用户
  Widget buildPerson(List<ContactUserModel> data){
    if(ObjectUtil.isEmptyList(data)){
      return Container(height: 0);
    }
    print(data.length);
    List<Widget> widgetList = [];
    data.forEach((model) => widgetList.add(_buildListItem(model)) );

    return Container(
      margin: EdgeInsets.only(top: 20.0,bottom: 10.0),
      color: Colors.white,
      child: Column(
        children: widgetList,
      ),
    );
  }
}
