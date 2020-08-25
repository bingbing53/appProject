import 'package:flutter/widgets.dart';
import 'package:helloworld/res/res_index.dart';

class TextStyles {
  static TextStyle listTitle = TextStyle(
    fontSize: Dimens.font_sp16,
    color: Colours.text_dark,
    fontWeight: FontWeight.bold,
  );

  static TextStyle departName = TextStyle(
    fontSize: Dimens.font_sp18,
  );



  static TextStyle titleShow = TextStyle(
    fontSize: Dimens.font_sp18,
    color: Colours.text_dark,
    fontWeight: FontWeight.bold,
  );

  static TextStyle listContent = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.text_normal,
  );
  static TextStyle listExtra = TextStyle(
    fontSize: Dimens.font_sp12,
    color: Colours.text_gray,
  );

  static TextStyle listContent2 = TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.text_gray,
  );
}

class Decorations {
  static Decoration bottom = BoxDecoration(
      border: Border(bottom: BorderSide(width: 0.33, color: Colours.divider)));
}
/// 间隔
class Gaps {
  /// 水平间隔
  static Widget hGap5 = new SizedBox(width: Dimens.gap_dp5);
  static Widget hGap10 = new SizedBox(width: Dimens.gap_dp10);
  static Widget hGap15 = new SizedBox(width: Dimens.gap_dp15);

  /// 垂直间隔
  static Widget vGap5 = new SizedBox(height: Dimens.gap_dp5);
  static Widget vGap10 = new SizedBox(height: Dimens.gap_dp10);
  static Widget vGap15 = new SizedBox(height: Dimens.gap_dp15);
}

class GZXIcons {
  static const String FONT_FAMILY = 'taobaoIconFont';
  static const String WEIXIN_FONT_FAMILY = 'wxIconFont';

  static const String DEFAULT_USER_ICON = 'static/images/logo.png';
  static const String DEFAULT_IMAGE = 'static/images/default_img.png';
  static const String DEFAULT_REMOTE_PIC =
      'https://raw.githubusercontent.com/CarGuo/GSYGithubAppFlutter/master/static/images/logo.png';

  static const String tmall_easy_buy = 'static/images/tmall_easy_buy.png';
  static const String huangjiaju = 'static/images/可爱猫.jpeg';

  static const IconData home = const IconData(0xe6b8, fontFamily: GZXIcons.FONT_FAMILY);
  static const IconData home_active = const IconData(0xe652, fontFamily: GZXIcons.FONT_FAMILY);

  static const IconData we_tao = const IconData(0xe6f5, fontFamily: GZXIcons.FONT_FAMILY);
  static const IconData we_tao_fill = const IconData(0xe6f4, fontFamily: GZXIcons.FONT_FAMILY);

  static const IconData message = const IconData(0xe6bc, fontFamily: GZXIcons.FONT_FAMILY);
  static const IconData message_fill = const IconData(0xe779, fontFamily: GZXIcons.FONT_FAMILY);

  static const IconData cart = const IconData(0xe6af, fontFamily: GZXIcons.FONT_FAMILY);
  static const IconData cart_fill = const IconData(0xe6b9, fontFamily: GZXIcons.FONT_FAMILY);

  static const IconData my = const IconData(0xe78b, fontFamily: GZXIcons.FONT_FAMILY);
  static const IconData my_fill = const IconData(0xe78c, fontFamily: GZXIcons.FONT_FAMILY);

  static const IconData scan = const IconData(0xe672, fontFamily: FONT_FAMILY);
  static const IconData search_light = const IconData(0xe7da, fontFamily: FONT_FAMILY);
  static const IconData camera = const IconData(0xe665, fontFamily: FONT_FAMILY);
  static const IconData qr_code = const IconData(0xe6b0, fontFamily: FONT_FAMILY);
  static const IconData delete_light = const IconData(0xe7ed, fontFamily: FONT_FAMILY);
  static const IconData attention_light = const IconData(0xe7f4, fontFamily: FONT_FAMILY);
  static const IconData attention_forbid = const IconData(0xe7b2, fontFamily: FONT_FAMILY);
  static const IconData back_light = const IconData(0xe7e0, fontFamily: FONT_FAMILY);
  static const IconData video = const IconData(0xe7c8, fontFamily: FONT_FAMILY);
  static const IconData cascades = const IconData(0xe67c, fontFamily: FONT_FAMILY);
  static const IconData list = const IconData(0xe682, fontFamily: FONT_FAMILY);
  static const IconData filter = const IconData(0xe69c, fontFamily: FONT_FAMILY);
  static const IconData jump = const IconData(0xe670, fontFamily: FONT_FAMILY);
  static const IconData time = const IconData(0xe65f, fontFamily: FONT_FAMILY);
  static const IconData time_fill = const IconData(0xe65e, fontFamily: FONT_FAMILY);
  static const IconData add_light = const IconData(0xe7dc, fontFamily: FONT_FAMILY);

  static const IconData clear = const IconData(0xe601, fontFamily: FONT_FAMILY);
  static const IconData deliver_fill = const IconData(0xe7f6, fontFamily: FONT_FAMILY);
  static const IconData comment_light = const IconData(0xe7e3, fontFamily: FONT_FAMILY);
  static const IconData comment_fill_light = const IconData(0xe7e4, fontFamily: FONT_FAMILY);
  static const IconData notification = const IconData(0xe66b, fontFamily: FONT_FAMILY);
  static const IconData notification_fill = const IconData(0xe66a, fontFamily: FONT_FAMILY);

  static const IconData emoji = const IconData(0xe64a, fontFamily: FONT_FAMILY);
  static const IconData round_add = const IconData(0xe6d9, fontFamily: FONT_FAMILY);
  static const IconData round_add_light = const IconData(0xe7a7, fontFamily: FONT_FAMILY);

  static const IconData sound = const IconData(0xe77b, fontFamily: FONT_FAMILY);
  static const IconData sound_light = const IconData(0xe7a8, fontFamily: FONT_FAMILY);

  static const IconData emoji_light = const IconData(0xe7a1, fontFamily: FONT_FAMILY);
  static const IconData friend_settings_light = const IconData(0xe7fe, fontFamily: FONT_FAMILY);

  static const IconData shop = const IconData(0xe676, fontFamily: FONT_FAMILY);
  static const IconData shop_fill = const IconData(0xe697, fontFamily: FONT_FAMILY);
  static const IconData shop_light = const IconData(0xe7b8, fontFamily: FONT_FAMILY);
  static const IconData tmall = const IconData(0xe65a, fontFamily: FONT_FAMILY);

//  static const IconData message = const IconData(0xe779, fontFamily: FONT_FAMILY);
  static const IconData appreciate_light = const IconData(0xe7e1, fontFamily: FONT_FAMILY);
  static const IconData appreciate_fill_light = const IconData(0xe7e2, fontFamily: FONT_FAMILY);
  static const IconData people_list_light = const IconData(0xe7db, fontFamily: FONT_FAMILY);
}