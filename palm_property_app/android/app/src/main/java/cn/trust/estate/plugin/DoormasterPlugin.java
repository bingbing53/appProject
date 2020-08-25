package cn.trust.estate.plugin;

import android.app.Activity;
import android.content.Context;

import java.util.ArrayList;

import cn.trust.estate.door.DeviceBean;
import cn.trust.estate.door.DoormasterUtil;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FluttertoastPlugin
 */
public class DoormasterPlugin implements MethodCallHandler {

    public static final String CHANNEL = "doormaster_plugin";

    private Context mContext;

    private static ArrayList<DeviceBean> devList = new ArrayList<DeviceBean>();

    private Activity mActivity;

    private DoormasterPlugin(Context context,Activity activity) {
        mContext = context;
        mActivity = activity;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
        channel.setMethodCallHandler(new DoormasterPlugin(registrar.context(),registrar.activity()));
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        switch (call.method) {
            case "showToast":
                DoormasterUtil.opendoor(mContext,mActivity,result);
                break;
            case "cancel":
                result.success(true);
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
