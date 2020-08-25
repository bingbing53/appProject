import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/net/dio_util.dart';
import 'package:estate/ui/pages/h_main_page.dart';
import 'package:estate/ui/pages/page_index.dart';
import 'package:estate/utils/chinese_cupertino_localizations.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

JmessageFlutter jmessage = new JmessageFlutter();

void main() async{

  _initFluwx();

  jmessage..setDebugMode(enable: true);
  jmessage.init(isOpenMessageRoaming: false, appkey: kMockAppkey,isProduction: true);
  jmessage.applyPushAuthority(
      new JMNotificationSettingsIOS(
          sound: true,
          alert: true,
          badge: true)
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_){
    runApp(BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: BlocProvider(child: MyApp(), bloc: WorkBloc(jmessages:jmessage)),
    ));
  });

  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

_initFluwx() async {
  await fluwx.registerWxApi(
      appId: "wx860945320e3cd006",
      doOnAndroid: true,
      doOnIOS: true);
//  var result = await fluwx.isWeChatInstalled();
}


class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Locale _locale;
  Color _themeColor = Colours.app_main;

  @override
  void initState() {
    super.initState();
    setLocalizedValues(localizedValues);
    _init();
    _initAsync();
    _initListener();
  }


  void _init() {
    DioUtil.openDebug();
    Options options = DioUtil.getDefOptions();
    options.baseUrl = Constant.server_address;
    HttpConfig config = new HttpConfig(options: options);
    DioUtil().setConfig(config);
  }

  var db;
  void _initAsync() async {
    await SpUtil.getInstance();
    if (!mounted) return;
    _loadLocale();
  }

  void _initListener() {
    final ApplicationBloc bloc = BlocProvider.of<ApplicationBloc>(context);
    bloc.appEventStream.listen((value) {
      if(value == Constant.type_sys_update) {
        _loadLocale();
      }else if(value == Constant.type_sys_login){
        //登录-
      }
    });
  }

  void _loadLocale() {
    setState(() {
      LanguageModel model =
      SpHelper.getObject<LanguageModel>(Constant.keyLanguage);
      if (model != null) {
        _locale = new Locale(model.languageCode, model.countryCode);
      } else {
        _locale = null;
      }

      String _colorKey = SpHelper.getThemeColor();
      if (themeColorMap[_colorKey] != null)
        _themeColor = themeColorMap[_colorKey];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Loading.ctx = context;

    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return getErrorWidget(context, errorDetails);
    };

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/MainPage': (ctx) => TabMainPage(),
      },
      home: new SplashPage(),
      theme:ThemeData/*.light().copyWith*/(
        appBarTheme: AppBarTheme(textTheme: TextTheme(title: TextStyle(color: Colors.white,fontSize: Dimens.font_sp20)),iconTheme: IconThemeData(color: Colors.white)),
        canvasColor : Color(0xfff6f6f6),//默认背景颜色
        bottomAppBarColor:Colors.white,
        primaryColor: _themeColor,
        accentColor: _themeColor,
        indicatorColor: Colors.white,
        fontFamily: 'PingFang',
        inputDecorationTheme: InputDecorationTheme(
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colours.divider,width: 1.0)),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colours.divider,width: 1.0)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent,width: 1.0)),
          counterStyle: TextStyle(fontSize: 0),
          hintStyle:TextStyle(color: Colours.text_gray),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
            subhead: ThemeData.light().textTheme.subhead
                .copyWith(textBaseline: TextBaseline.alphabetic)),
      ),
      locale: _locale,
      localizationsDelegates: [
        ChineseCupertinoLocalizations.delegate, // 自定义的delegate
        DefaultCupertinoLocalizations.delegate, // 目前只包含英文

        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        CustomLocalizations.delegate
      ],
      supportedLocales: CustomLocalizations.supportedLocales,
    );
  }

  Widget getErrorWidget(BuildContext context, FlutterErrorDetails error) {
    return SizedBox();
  }

}
