package cn.trust.estate.door;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.intelligoo.sdk.AutoOpenService;
import com.intelligoo.sdk.LibDevModel;
import com.intelligoo.sdk.LibInterface;
import com.intelligoo.sdk.ScanCallBackSort;
import com.intelligoo.sdk.LibInterface.ManagerCallback;
import com.intelligoo.sdk.ScanCallback;
import com.xuexiang.xpush.XPush;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import cn.trust.estate.MainActivity;
import io.flutter.plugin.common.MethodChannel;

public class DoormasterUtil {

    private static ArrayList<DeviceBean> devList = new ArrayList<DeviceBean>();
    private static ArrayList<DeviceBean> permitedList = new ArrayList<DeviceBean>();

    private static Context mContext;

    private static Activity mActivity;

    private static MethodChannel.Result result;

    final static ManagerCallback callBack = new ManagerCallback(){
        @Override
        public void setResult(final int result, Bundle bundle)
        {

            if (result == 0x00) {
                Toast.makeText(mContext, "Success",
                        Toast.LENGTH_SHORT).show();
            } else {
                if (result == 48) {
                    Toast.makeText(mContext.getApplicationContext(), "Result Error Timer Out", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(mContext, "Failure:" + result,
                            Toast.LENGTH_SHORT).show();
                }
            }
        }
    };

    final static  ScanCallback oneKeyScanCallback = new ScanCallback()
    {

        @Override
        public void onScanResult(ArrayList<String> deviceList,
                                 ArrayList<Integer> rssi)
        {
            result.success(XPush.getPushToken());

            Log.d("scan",deviceList.size()+"");
            if(deviceList.size()==0){
                Toast.makeText(mContext, "Scan 0 device",
                        Toast.LENGTH_SHORT).show();
                return;
            }

            DeviceBean dev = new DeviceBean();
            dev.setDevType(20);
            dev.seteKey("84d9ff2721bc19c487df1682e0598447000000000000000000000011907172301000");
            dev.setDevSn("2359357579");
            dev.setDevMac("e3:8c:8c:a0:f0:8b");
            dev.setOpenType(1);

            LibDevModel libDev = getLibDev(dev);
            int ret = LibDevModel.openDoor(mActivity, libDev, callBack);

            Toast.makeText(mContext, "open door ret :" + ret,
                    Toast.LENGTH_SHORT).show();
        }

        @Override
        public void onScanResultAtOnce(final String devSn, int rssi) {
//            Toast.makeText(mContext, "once Scan 1 device",
//                    Toast.LENGTH_SHORT).show();
        }
    };

    public static void opendoor(Context context,Activity activity,final MethodChannel.Result results){
        mContext = context;
        mActivity = activity;
        result = results;
        Log.d("opendoor","开门");
        Log.d("token", XPush.getPushToken());
        Intent autoService = new Intent(mContext, AutoOpenService.class);

        //扫描设备
        int ret1 = LibDevModel.scanDevice(activity, true, 800, oneKeyScanCallback);
        Log.d("ret1",ret1+"");
//        if(true){
//            mContext.getApplicationContext().startService(autoService);
//
//            ScanCallBackSort scancallBack = new ScanCallBackSort() {
//
//                @Override
//                public void onScanResultAtOnce(String devSn, int rssi) {
//                    // TODO Auto-generated method stub
//                    Log.d("opendoor","扫描开门");
//                    Toast.makeText(mContext.getApplicationContext(), "正在扫描门", Toast.LENGTH_SHORT).show();
//                }
//
//                @Override
//                public void onScanResult(ArrayList<Map<String, Integer>> devSnRssiList) {
//                    // TODO Auto-generated method stub
//                    if (devList == null || devList.size() == 0)
//                    {
//                        Toast.makeText(mContext.getApplicationContext(), "No permitted device or haven't login", Toast.LENGTH_SHORT).show();
//                        return;
//                    }
//
//                    if (devSnRssiList == null || devSnRssiList.size() == 0) {
//                        Toast.makeText(mContext.getApplicationContext(), "No scan device", Toast.LENGTH_SHORT).show();
//                        return;
//                    }
//                    Map<String, DeviceBean> devDomMap = new HashMap<String, DeviceBean>();
//                    for (DeviceBean devBean : devList){
//                        devDomMap.put(devBean.getDevSn(), devBean);
//                    }
//
//                    int limit = -75; //限制信号值
//
//                    for(Map<String, Integer> devRssiDict : devSnRssiList)
//                    {
//                        for (String devSn : devRssiDict.keySet())
//                        {
//                            if (devDomMap.containsKey(devSn) && devRssiDict.get(devSn) >= limit)
//                            {
//                                DeviceBean devDom = devDomMap.get(devSn);
////                                pressed = true;
//                                LibDevModel libDev = getLibDev(devDom);
//                                int ret = LibDevModel.openDoor(mContext, libDev, callBack); //Open door
//                                if (ret != 0)
//                                {
////                                    pressed = false;
//                                    if (ret==-107) {
//                                    } else {
//                                        Toast.makeText(mContext.getApplicationContext(), "RET：" + ret, Toast.LENGTH_SHORT).show();
//                                    }
//                                    return;
//                                }
//                            }
//                        }
//
//
//                    }
//                }
//            };
//            AutoOpenService.startBackgroundModeWithBrightScreen( mActivity, scancallBack);
//        }
//        else{
//            mContext.getApplicationContext().stopService(autoService);
//        }
    }

    public static LibDevModel getLibDev(DeviceBean dev) {
        LibDevModel device = new LibDevModel();
        device.devSn = dev.getDevSn();
        device.devMac = dev.getDevMac();
        device.devType = dev.getDevType();
        device.eKey = dev.geteKey();
        device.endDate = dev.getEndDate();
        device.openType = dev.getOpenType();
        device.privilege = dev.getPrivilege();
        device.startDate = dev.getStartDate();
        device.useCount = dev.getUseCount();
        device.verified = dev.getVerified();
        device.cardno = "123";//卡号从服务器获取，此卡号为测试卡号
        return device;
    }

}
