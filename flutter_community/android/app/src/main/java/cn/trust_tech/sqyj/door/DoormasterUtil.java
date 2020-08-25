package cn.trust_tech.sqyj.door;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;
import com.intelligoo.sdk.AutoOpenService;
import com.intelligoo.sdk.LibDevModel;
import com.intelligoo.sdk.LibInterface.ManagerCallback;
import com.intelligoo.sdk.ScanCallBackSort;
import com.intelligoo.sdk.ScanCallback;
import io.flutter.plugin.common.MethodChannel;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class DoormasterUtil {

    private static ArrayList<DeviceBean> devList = new ArrayList<DeviceBean>();
    private static ArrayList<DeviceBean> permitedList = new ArrayList<DeviceBean>();

    private static Context mContext;

    private static Activity mActivity;

    private static MethodChannel.Result result;

    final static ManagerCallback callBack = new ManagerCallback(){
        @Override
        public void setResult(final int openResult, Bundle bundle) {
            if (openResult == 0x00) {
                Toast.makeText(mContext.getApplicationContext(), "门已开，请注意关门", Toast.LENGTH_SHORT).show();
            } else {
                if (openResult == 48) {
                    Toast.makeText(mContext.getApplicationContext(), "开门请求超时", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(mContext, "开门失败:" + openResult,
                            Toast.LENGTH_SHORT).show();
                }
            }
            result.success(openResult);
        }
    };

    final static ManagerCallback autoCallBack = new ManagerCallback(){
        @Override
        public void setResult(final int openResult, Bundle bundle) {
            if (openResult == 0x00) {
                Toast.makeText(mContext.getApplicationContext(), "门已开，请注意关门", Toast.LENGTH_SHORT).show();
            } else {
                if (openResult == 48) {
//                    Toast.makeText(mContext.getApplicationContext(), "开门请求超时", Toast.LENGTH_SHORT).show();
                } else {
//                    Toast.makeText(mContext, "开门失败:" + openResult,
//                            Toast.LENGTH_SHORT).show();
                }
            }
        }
    };

    final static ScanCallback oneKeyScanCallback = new ScanCallback()
    {
        @Override
        public void onScanResult(ArrayList<String> deviceList, ArrayList<Integer> rssi) {
            result.success(deviceList);
        }

        @Override
        public void onScanResultAtOnce(final String devSn, int rssi) {

        }
    };

    //开门
    public static void openDoor(Context context,Activity activity,DeviceBean dev,final MethodChannel.Result results){
        mContext = context;
        mActivity = activity;
        result = results;
        LibDevModel libDev = getLibDev(dev);
        try {
            int ret = LibDevModel.openDoor(mActivity, libDev, callBack);
        }catch (Exception e){

        }
    }

    //关闭自动开门
    public static void closeAutoOpen(Context context){
        mContext = context;
        Intent autoService = new Intent(mContext, AutoOpenService.class);
        mContext.getApplicationContext().stopService(autoService);
    }
    //开启自动开门
    public static void autoOpen(Context context,Activity activity,String auto,int limit,String json,final MethodChannel.Result results){
        JSONArray deviceArray = null;
        try {
            deviceArray = new JSONArray(json);
            if(deviceArray == null || deviceArray.length() <= 0){
                return;
            }

            for(int i = 0;i<deviceArray.length();i++){
                JSONObject jsonObject = deviceArray.getJSONObject(i);
                DeviceBean dev = new DeviceBean();
                dev.setDevType(jsonObject.getInt("devType"));
                dev.seteKey(jsonObject.getString("ekey"));
                dev.setDevSn(jsonObject.getString("devSn"));
                dev.setDevMac(jsonObject.getString("devMac"));
                dev.setOpenType(1);
                devList.add(dev);
            }

        } catch (JSONException e) {
            e.printStackTrace();
            return;
        }

        mContext = context;
        mActivity = activity;
        result = results;
        Intent autoService = new Intent(mContext, AutoOpenService.class);
        if(auto.equals("1")){
            mContext.getApplicationContext().startService(autoService);

            ScanCallBackSort scancallBack = new ScanCallBackSort() {

                @Override
                public void onScanResultAtOnce(String devSn, int rssi) {
                    // TODO Auto-generated method stub
                    Log.i("opendoor","扫描开门222");
                    Toast.makeText(mContext.getApplicationContext(), "正在扫描门", Toast.LENGTH_SHORT).show();
                }

                @Override
                public void onScanResult(ArrayList<Map<String, Integer>> devSnRssiList) {
                    // TODO Auto-generated method stub
                    Log.i("opendoor","扫描开门111");
                    if (devList == null || devList.size() == 0)
                    {
                        Toast.makeText(mContext.getApplicationContext(), "No permitted device or haven't login", Toast.LENGTH_SHORT).show();
                        return;
                    }

                    if (devSnRssiList == null || devSnRssiList.size() == 0) {
                        Toast.makeText(mContext.getApplicationContext(), "No scan device", Toast.LENGTH_SHORT).show();
                        return;
                    }
                    Map<String, DeviceBean> devDomMap = new HashMap<String, DeviceBean>();
                    for (DeviceBean devBean : devList){
                        devDomMap.put(devBean.getDevSn(), devBean);
                    }

//                    int limit = -75; //限制信号值
//                    int limit = -35; //限制信号值

                    for(Map<String, Integer> devRssiDict : devSnRssiList)
                    {
                        for (String devSn : devRssiDict.keySet())
                        {

//                            if(devDomMap.containsKey(devSn)){
//                                Toast.makeText(mContext.getApplicationContext(), "limit：" + devRssiDict.get(devSn), Toast.LENGTH_SHORT).show();
//                            }

                            if (devDomMap.containsKey(devSn) && devRssiDict.get(devSn) >= limit)
                            {
                                try {
                                    DeviceBean devDom = devDomMap.get(devSn);
//                                pressed = true;
                                    LibDevModel libDev = getLibDev(devDom);
                                    int ret = LibDevModel.openDoor(mContext, libDev, autoCallBack); //Open door
                                    if (ret != 0) {
//                                    pressed = false;
                                        if (ret == -107) {
                                        } else {
                                            Toast.makeText(mContext.getApplicationContext(), "RET：" + ret, Toast.LENGTH_SHORT).show();
                                        }
                                        return;
                                    }
                                }catch (Exception e){

                                }
                            }
                        }
                    }
                }
            };
            AutoOpenService.startBackgroundModeWithBrightScreen( mActivity, scancallBack);
        }
        else{
            mContext.getApplicationContext().stopService(autoService);
        }
    }

    //扫描设备
    public static void scanDevice(Context context,Activity activity,final MethodChannel.Result results){
        mContext = context;
        mActivity = activity;
        result = results;
        Log.i("opendoor","开门");
        //扫描设备
        int ret1 = LibDevModel.scanDevice(activity, true, 1200, oneKeyScanCallback);
        Log.i("ret1",ret1+"");

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
//        device.cardno = "123";//卡号从服务器获取，此卡号为测试卡号
        return device;
    }

}
