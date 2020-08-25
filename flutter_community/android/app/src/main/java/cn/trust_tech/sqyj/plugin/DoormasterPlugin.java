package cn.trust_tech.sqyj.plugin;

import android.app.Activity;
import android.content.Context;
import cn.trust_tech.sqyj.door.DeviceBean;
import cn.trust_tech.sqyj.door.DoormasterUtil;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.util.ArrayList;

/**
 * 蓝牙开门
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
            case "scanDevice":
                DoormasterUtil.scanDevice(mContext,mActivity,result);
                break;
            case "openDoor":
                DeviceBean dev = new DeviceBean();
                dev.setDevType(call.argument("devType"));
                dev.seteKey(call.argument("eKey").toString());
                dev.setDevSn(call.argument("devSn").toString());
                dev.setDevMac(call.argument("devMac").toString());
                dev.setOpenType(1);

                DoormasterUtil.openDoor(mContext,mActivity,dev,result);
                break;
            case "autoOpen":
                String auto = call.argument("auto").toString();
                int limit = call.argument("limit");
                String devList = call.argument("devList");
                DoormasterUtil.autoOpen(mContext,mActivity,auto,limit,devList,result);
                break;
            case "closeAutoOpen":
                DoormasterUtil.closeAutoOpen(mContext);
                result.success(true);
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
