package cn.trust.estate.plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;

import androidx.core.content.FileProvider;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.io.File;
import java.util.ArrayList;

/**
 * 安装Apk插件
 * FluttertoastPlugin
 */
public class InstallApkPlugin implements MethodCallHandler {

    public static final String CHANNEL = "install_apk";

    private Context mContext;

    private Activity mActivity;

    private InstallApkPlugin(Context context,Activity activity) {
        mContext = context;
        mActivity = activity;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
        channel.setMethodCallHandler(new InstallApkPlugin(registrar.context(),registrar.activity()));
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        switch (call.method) {
            case "install":
                String path = (String) call.arguments;
                File file = new File(path);
                installApk(file, mContext);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    /**
     * 安装APK
     *
     * @param apk
     * @param context
     */
    private void installApk(File apk, Context context) {
        Intent installApkIntent = new Intent();
        installApkIntent.setAction(Intent.ACTION_VIEW);
        installApkIntent.addCategory(Intent.CATEGORY_DEFAULT);
        installApkIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        Uri uri = null;
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.M) {
            uri = FileProvider.getUriForFile(context, context.getPackageName() + ".fileprovider", apk);
            installApkIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        } else {
            uri = Uri.fromFile(apk);
        }
        installApkIntent.setDataAndType(uri, "application/vnd.android.package-archive");

        if (context.getPackageManager().queryIntentActivities(installApkIntent, 0).size() > 0) {
            context.startActivity(installApkIntent);
        }
    }
}
