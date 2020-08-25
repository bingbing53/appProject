package cn.trust.estate;

import cn.trust.estate.plugin.DoormasterPlugin;
import cn.trust.estate.plugin.XPushPlugin;
import cn.trust.estate.plugin.InstallApkPlugin;
import io.flutter.plugin.common.PluginRegistry;
import android.os.Bundle;

import com.xuexiang.xpush.XPush;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import me.leolin.shortcutbadger.ShortcutBadger;


public class MainActivity extends FlutterActivity {

  private  final String CHANNEL = "android/back/desktop";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    registerCustomPlugin(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                if (methodCall.method.equals("backDesktop")) {
                  result.success(true);
                  moveTaskToBack(false);
                }else if(methodCall.method.equals("setBadges")){
                    String badgeStr = methodCall.argument("badge");
                    int badge = Integer.valueOf(badgeStr);
                    if(badge <= 0) {
                        ShortcutBadger.removeCount(getApplicationContext());
                    }else{
                        ShortcutBadger.applyCount(getApplicationContext(), badge);
                    }
                }
              }
            }
    );
  }

  private void registerCustomPlugin(PluginRegistry registrar){
      DoormasterPlugin.registerWith(registrar.registrarFor(DoormasterPlugin.CHANNEL));
      XPushPlugin.registerWith(registrar.registrarFor(XPushPlugin.CHANNEL));
      InstallApkPlugin.registerWith(registrar.registrarFor(InstallApkPlugin.CHANNEL));
  }

}
