import 'package:flutter/material.dart';
//颜色配置
class AppColor{
  static const int white = 0xFFFFFFFF;
  static const int mainTextColor = 0xFF121917;
  static const int subTextColor = 0xff959595;
  static const Color borderColor = Color(0xFFEFEFEF);

  static const int color333 = 0xFF333333;
  static const int color666 = 0xFF666666;
  static const int color999 = 0xFF999999;
}

//文本设置
class AppText{
  static const middleSize = 16.0;

  static const middleText = TextStyle(
    color: Color(AppColor.mainTextColor),
    fontSize: middleSize,
  );

  static const middleSubText = TextStyle(
    color: Color(AppColor.subTextColor),
    fontSize: middleSize,
  );

  static final TextStyle Title_Add_Person = new TextStyle(color:Colors.grey,fontSize:  22.0,fontWeight: FontWeight.w800);

  static final TextStyle Title_Big = new TextStyle(color:Colors.white,fontSize: 22.0);

  static final TextStyle Title_Size_Big = new TextStyle(color:Colors.black,fontSize: 18.0);
  static final TextStyle Title_Size_Big_Gray = new TextStyle(color:Colors.grey,fontSize: 18.0);
  static final TextStyle Title_Size_Big_White = new TextStyle(color:Colors.white,fontSize: 18.0);
  static final TextStyle Title_Size_Medium = new TextStyle(color:Colors.black,fontSize: 16.0);
  static final TextStyle Title_Size_Medium_Gray = new TextStyle(color:Colors.grey,fontSize: 16.0);
  static final TextStyle Title_Size_Medium_White = new TextStyle(color:Colors.white,fontSize: 16.0);
  static final TextStyle Title_Size_Medium_Blue = new TextStyle(color:Colors.blue,fontSize: 16.0);

  static final TextStyle SubTitle_Size_Big = new TextStyle(color:Colors.black,fontSize: 15.0);
  static final TextStyle SubTitle_Size_Big_Gray = new TextStyle(color:Colors.grey,fontSize: 15.0);
  static final TextStyle SubTitle_Size_Big_White = new TextStyle(color:Colors.white,fontSize: 15.0);
  static final TextStyle SubTitle_Size_Big_Red = new TextStyle(color:Colors.redAccent,fontSize: 15.0);
  static final TextStyle SubTitle_Size_Medium = new TextStyle(color:Colors.black,fontSize: 14.0);
  static final TextStyle SubTitle_Size_Medium_Gray = new TextStyle(color:Colors.grey,fontSize: 14.0);
  static final TextStyle SubTitle_Size_Medium_White = new TextStyle(color:Colors.white,fontSize: 14.0);

  static final TextStyle Info_Size_Big =  new TextStyle(color:Colors.black,fontSize: 13.0);
  static final TextStyle Info_Size_Big_Gray =  new TextStyle(color:Color.fromRGBO(102, 102, 102,1),fontSize: 13.0);
  static final TextStyle Info_Size_Big_Blue =  new TextStyle(color:Colors.blue,fontSize: 13.0);
  static final TextStyle Info_Size_Medium =  new TextStyle(color:Colors.black,fontSize: 12.0);
  static final TextStyle Info_Size_Medium_White = new TextStyle(color:Colors.white,fontSize: 12.0);
  static final TextStyle Info_Size_Medium_Gray =  new TextStyle(color:Colors.grey,fontSize: 12.0);
  static final TextStyle Info_Size_Medium_Green =  new TextStyle(color:Colors.green,fontSize: 12.0);
  static final TextStyle Info_Size_Small =  new TextStyle(color:Colors.black,fontSize: 11.0);
  static final TextStyle Info_Size_Small_Gray =  new TextStyle(color:Colors.grey,fontSize: 11.0);
  static final TextStyle Info_Size_Small_White =  new TextStyle(color:Colors.white,fontSize: 11.0);

}
class WidgetDemoColor {
  static const int fontColor = 0xFF607173;
  static const int iconColor = 0xFF607173;
  static const int borderColor = 0xFFEFEFEF;

}

class TextFiledDecoration {
  static final InputDecoration focusDecoration =
    InputDecoration(
      contentPadding: EdgeInsets.all(10.0),
      border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
  //            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
    )
  );
}

class TextFieldBorder{

//  static const b =  OutlineInputBorder(
//    borderRadius: BorderRadius.circular(15.0),
////            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
//  );
}
