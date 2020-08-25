import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/res/res_index.dart';
import 'package:flutter_wanandroid/utils/util_index.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key key,
    this.width,
    this.height = 50,
    this.margin,
    this.radius,
    this.bgColor,
    this.highlightColor,
    this.splashColor,
    this.child,
    this.text,
    this.style,
    this.onPressed,
  }) : super(key: key);

  final double width;
  final double height;

  /// Empty space to surround the [decoration] and [child].
  final EdgeInsetsGeometry margin;

  final double radius;
  final Color bgColor;
  final Color highlightColor;
  final Color splashColor;

  final Widget child;

  final String text;
  final TextStyle style;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Color _bgColor = bgColor ?? Theme.of(context).primaryColor;
    BorderRadius _borderRadius = BorderRadius.circular(radius ?? (height / 2));
    return new Container(
      width: width,
      height: height,
      margin: margin,
      child: new Material(
        borderRadius: _borderRadius,
        color: _bgColor,
        child: new InkWell(
          borderRadius: _borderRadius,
          onTap: () => onPressed(),
          child: child ??
              new Center(
                child: new Text(
                  text,
                  style:
                  style ?? new TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
        ),
      ),
    );
  }
}

class ProgressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new SizedBox(
        width: 24.0,
        height: 24.0,
        child: new CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}

class StatusViews extends StatelessWidget {
  const StatusViews(this.status, {Key key, this.onTap}) : super(key: key);
  final int status;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LoadStatus.fail:
        return new Container(
          width: double.infinity,
          child: new Material(
            color: Colors.white,
            child: new InkWell(
              onTap: () {
                onTap();
              },
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Image.asset(
                    Utils.getImgPath("ic_network_error"),
//                    package: BaseConstant.packageBase,
                    width: 100,
                    height: 100,
                  ),
                  Gaps.vGap10,
                  new Text(
                    "网络出问题了～ 请您查看网络设置",
                    style: TextStyles.listContent,
                  ),
                  Gaps.vGap5,
                  new Text(
                    "点击屏幕，重新加载",
                    style: TextStyles.listContent,
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      case LoadStatus.loading:
        return new Container(
          alignment: Alignment.center,
          color: Colours.gray_f0,
          child: new ProgressView(),
        );
        break;
      case LoadStatus.empty:
        return new Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 50.0),
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset(
                  Utils.getImgPath("ic_data_empty"),
//                  package: BaseConstant.packageBase,
                  width: 60,
                  height: 60,
                ),
                Gaps.vGap10,
                new Text(
                  "空空如也～",
                  style: TextStyles.listContent2,
                ),
              ],
            ),
          ),
        );
        break;
      default:
        return Container();
        break;
    }
  }
}