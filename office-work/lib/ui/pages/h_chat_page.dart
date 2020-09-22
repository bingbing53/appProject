import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/ui/pages/page_index.dart';
import 'package:flutter_wanandroid/ui/pages/rec_hot_page.dart';

bool isChatPageInit = false;

class ChatPage extends StatelessWidget {
  const ChatPage({Key key, this.labelId}) : super(key: key);

  final String labelId;

  final int _suspensionHeight = 40;
  final int _itemHeight = 60;

  Widget buildContactUser(
      BuildContext context, List<ContactUserModel> list, WorkBloc bloc) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    return Container(
        color: Colors.white,
        child: AzListView(
          data: list,
          itemBuilder: (context, model) => _buildListItem(model, context),
          isUseRealIndex: true,
          itemHeight: _itemHeight,
          suspensionHeight: _suspensionHeight,
          onSusTagChanged: bloc.susTagChanged,
          header: AzListViewHeader(
              height: 218,
              builder: (context) {
                return _buildHeader(context, bloc);
              }),
        ));
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
        style: TextStyle(fontSize: 12.0, color: Colours.text_normal),
      ),
    );
  }

  Widget _buildListItem(ContactUserModel model, BuildContext context) {
    String susTag = model.getSuspensionTag();
    model.portrait = WanAndroidApi.format(model.portrait, size: 1);
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(model.tagSeparator),
        ),
        GestureDetector(
          child: Row(
            children: <Widget>[
              Container(
                  height: 75,
                  padding: EdgeInsets.only(left: 15.0, right: 20.0),
                  child: CircleAvatar(
                    radius: 23,
                    child: ObjectUtil.isEmpty(model.portrait)
                        ? Text(
                            model.realname.length > 2
                                ? model.realname.substring(1, 3)
                                : model.realname,
                          )
                        : ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: '${model.portrait}',
                              height: 46,
                              width: 46,
//                            placeholder: (context, url) => new ProgressView(),
//                            errorWidget: (context, url, error) => new Icon(Icons.person,color: Colors.white,),
                            ),
                          ),
                  )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '${model.realname} ',
                        style: TextStyle(
                            fontSize: Dimens.font_sp16,
                            color: model.browser != '1'
                                ? Colors.grey
                                : Colors.black),
                      ),
                      Text(
                        '${ObjectUtil.isNotEmpty(model.officeName) ? '${model.officeName}' : ''}',
                        style: TextStyle(
                            fontSize: Dimens.font_sp12,
                            color: Colours.text_gray),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${model.personType}  ${model.departname}',
                    style: TextStyle(
                        fontSize: Dimens.font_sp12, color: Colours.text_gray),
                  ),
                ],
              ))
            ],
          ),
          onTap: () {
            NavigatorUtil.pushPage(
                context,
                ChatUserPage(
                  userModel: model,
                ),
                pageName: model.realname);
          },
          behavior: HitTestBehavior.translucent,
        ),
        Divider(
          height: 1.0,
          color: Colours.gray_ce,
        )
      ],
    );
  }

  Widget _buildHeader(context, bloc) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            NavigatorUtil.pushPage(
                context,
                MessagePage(
                  labelId: Ids.titleMessage,
                  showGroup: "1",
                ),
                pageName: '议事厅');
          },
          child: Row(
            children: <Widget>[
              Container(
                height: 65,
                padding: EdgeInsets.only(left: 15.0, right: 20.0),
                child: ClipOval(
                  child: Image.asset(
                    Utils.getImgPath('icon_group_list'),
                    width: 35,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '议事厅',
                  style: TextStyle(fontSize: Dimens.font_sp16),
                ),
              )
            ],
          ),
        ),
        Divider(
          height: 1,
          color: Colours.gray_ce,
        ),
        StreamBuilder(
            stream: bloc.moduleListReposStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<ModuleModel>> snapshot) {
              return buildGroup(context, snapshot.data);
            }),
        Container(
          height: 20.0,
          color: Colours.gray_f0,
        ),
        Row(
          children: <Widget>[
            Container(
              height: 65,
              padding: EdgeInsets.only(left: 15.0, right: 20.0),
              child: ClipOval(
                child: Image.asset(
                  Utils.getImgPath('icon_chat_jigou'),
                  width: 35,
                ),
              ),
            ),
            Expanded(
                child: GestureDetector(
                  child: Text(
                '组织机构',
                style: TextStyle(fontSize: Dimens.font_sp16),
              ),
              onTap: () {
                NavigatorUtil.pushPage(
                    context,
                    ChatGroupPage(
                      labelId: '',
                    ),
                    pageName: '组织机构');
              },
            ))
          ],
        ),
        Divider(
          height: 1.0,
          color: Colours.divider,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("ChatPage build......");
    final WorkBloc bloc = BlocProvider.of<WorkBloc>(context);
    if (!isChatPageInit) {
      bloc.getChatUserList();
      isChatPageInit = true;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("共商共治"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                Utils.changeChatUserSort();
                bloc.getChatUserList();
              },
            ),
            iconModule(bloc)
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: StreamBuilder(
                  stream: bloc.contactUserListReposStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ContactUserModel>> snapshot) {
                    if (snapshot.hasError) {
                      return new StatusViews(
                        LoadStatus.fail,
                        onTap: () {
                          LogUtil.e("ProgressViews onRefresh......");
                          bloc.getChatUserList();
                        },
                      );
                    } else {
                      return buildContactUser(context, snapshot.data, bloc);
                    }
                  }),
            )
          ],
        ));
  }

  //构建我的小组
  Widget buildGroup(context, list) {
    bool hasPermison = false;
    if (!ObjectUtil.isEmptyList(list)) {
      for (var i = 0; i < list.length; i++) {
        if (list[i].superCode == 'chat' && list[i].code == 'group') {
          hasPermison = true;
        }
      }
    }
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              height: 65,
              padding: EdgeInsets.only(left: 15.0, right: 20.0),
              child: ClipOval(
                child: Image.asset(
                  Utils.getImgPath('icon_chat_group'),
                  width: 35,
                ),
              ),
            ),
            Expanded(
                child: GestureDetector(
              child: Text(
                '我的小组',
                style: TextStyle(fontSize: Dimens.font_sp16),
              ),
              onTap: () {
                if (hasPermison) {
                  NavigatorUtil.pushWeb(context,
                      title: '我的小组', url: WanAndroidApi.MYGROUP);
                }
              },
            ))
          ],
        ),
        Divider(
          height: 1.0,
          color: Colours.divider,
        ),
      ],
    );
  }

  //添加功能模块
  Widget iconModule(bloc) {
    return StreamBuilder(
        stream: bloc.moduleListReposStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<ModuleModel>> snapshot) {
          return IconButton(
            icon: new Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              final result = await showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(1000.0, 80.0, 10.0, 0.0),
                  items: listenModule(snapshot.data));

              if (result == 'addGroup') {
                //新建群聊
                NavigatorUtil.pushPage(
                    context,
                    new BlocProvider<MissionBloc>(
                        child: new ChatCreateGroup(), bloc: new MissionBloc()),
                    pageName: Ids.titleChatMessage);
              } else if (result == 'invite') {
                NavigatorUtil.pushPage(context, new InvitePerson(),
                    pageName: Ids.titleInvitePerson);
              } else if (result == 'groupAdd') {
                //新建社工小组
                for (var i = 0; i < snapshot.data.length; i++) {
                  if (snapshot.data[i].superCode == 'chat' &&
                      snapshot.data[i].code == 'groupAdd') {
                    NavigatorUtil.pushWeb(context,
                        title: snapshot.data[i].showName,
                        url: snapshot.data[i].target);
                    break;
                  }
                }
              }
            },
          );
        });
  }

  List<PopupMenuItem> listenModule(list) {
    List<PopupMenuItem> item = [];
    item.add(
      new PopupMenuItem<String>(
          value: "addGroup",
          child: ListTile(
              contentPadding: EdgeInsets.all(0.0),
              dense: false,
              title: new Container(
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.business,
                      color: Colours.gray_66,
                      size: 22.0,
                    ),
                    Gaps.hGap10,
                    Text(
                      '新建议事厅',
                      style: TextStyles.listContent,
                    )
                  ],
                ),
              ))),
    );

    if (ObjectUtil.isEmpty(list)) {
      return item;
    }

//    if(!ObjectUtil.isEmpty(list)){
    for (var i = 0; i < list.length; i++) {
      if (list[i].superCode == 'chat' && list[i].code == 'groupAdd') {
        item.add(
          new PopupMenuItem<String>(
              value: "groupAdd",
              child: ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  dense: false,
                  title: new Container(
                    alignment: Alignment.center,
                    child: new Row(
                      children: <Widget>[
                        Icon(
                          Icons.people,
                          color: Colours.gray_66,
                          size: 22.0,
                        ),
                        Gaps.hGap10,
                        Text(
                          '新建小组',
                          style: TextStyles.listContent,
                        )
                      ],
                    ),
                  ))),
        );
      } else if (list[i].superCode == 'chat' && list[i].code == 'invite') {
        item.add(
          new PopupMenuItem<String>(
              value: "invite",
              child: ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  dense: false,
                  title: new Container(
                    alignment: Alignment.center,
                    child: new Row(
                      children: <Widget>[
                        Icon(
                          Icons.share,
                          color: Colours.gray_66,
                          size: 22.0,
                        ),
                        Gaps.hGap10,
                        Text(
                          '邀请居民',
                          style: TextStyles.listContent,
                        )
                      ],
                    ),
                  ))),
        );
      }
    }
//    }else{
//      item.add(
//        new PopupMenuItem<String>(
//            value: "invite",
//            child: ListTile(
//                contentPadding: EdgeInsets.all(0.0),
//                dense: false,
//                title: new Container(
//                  alignment: Alignment.center,
//                  child: new Row(
//                    children: <Widget>[
//                      Icon(
//                        Icons.share,
//                        color: Colours.gray_66,
//                        size: 22.0,
//                      ),
//                      Gaps.hGap10,
//                      Text(
//                        '邀请居民',
//                        style: TextStyles.listContent,
//                      )
//                    ],
//                  ),
//                ))),
//      );
//    }
    return item;
  }
}
