#import <Flutter/Flutter.h>

#import "DoormasterPlugin.h"
#import <DoorMasterSDK/DoorMasterSDK.h>
//#import "UIView+Toast.h"


static NSString *const CHANNEL_NAME = @"doormaster_plugin";

@interface DoormasterPlugin ()
@property(nonatomic, retain) FlutterMethodChannel *channel;
@property(nonatomic, retain) FlutterResult results;
@property (nonatomic,strong) UIAlertView *calibrationAlert;
@property(nonatomic,strong) NSMutableDictionary *tempDevDict;
@end

@implementation DoormasterPlugin {
    FlutterResult _result;
}

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:CHANNEL_NAME
                  binaryMessenger:[registrar messenger]];
    UIViewController *viewController =
            [UIApplication sharedApplication].delegate.window.rootViewController;
    DoormasterPlugin *instance = [[DoormasterPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
    
    [LibDevModel initBluetooth];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    self.results = result;
    if([@"scanDevice" isEqualToString:call.method]) {
        //扫描设备
//        scanDevice(call:call result:result);
        [self scanDevice:call result:result];
    } else if ([@"openDoor" isEqualToString:call.method]) {
        //开门
        int openType = 1;
        int devType = call.arguments[@"devType"];
        NSString *eKey = call.arguments[@"eKey"];
        NSString *devSn = call.arguments[@"devSn"];
        NSString *devMac = call.arguments[@"devMac"];
        
        LibDevModel* libDevModel = [[LibDevModel alloc] init];
        libDevModel.devSn = devSn;
        libDevModel.devMac = devMac;
        libDevModel.eKey = eKey;
        libDevModel.devType = devType;
        libDevModel.openMode = openType;
        
        [self openDoor:libDevModel];
        
    } else if([@"autoOpen" isEqualToString:call.method]) {
        //开启自动开门
        
        NSString *autoOpen = call.arguments[@"auto"];
        int limit = call.arguments[@"limit"];
        NSString *json = call.arguments[@"devList"];
        
        self.tempDevDict = [[NSMutableDictionary alloc] init];
//        LibDevModel* libDevModel = [[LibDevModel alloc] init];
//        libDevModel.devSn = @"2359357579";
//        libDevModel.devMac = @"e3:8c:8c:a0:f0:8b";
//        libDevModel.eKey = @"84d9ff2721bc19c487df1682e0598447000000000000000000000011907172301000";
//        libDevModel.devType = 20;
//        libDevModel.openMode = 1;
//
//        [self.tempDevDict setObject:libDevModel forKey:libDevModel.devSn];
        
        [self nearOpenSwitch:autoOpen:json:limit];
        
        result([NSNumber numberWithBool:true]);

    } else if([@"closeAutoOpen" isEqualToString:call.method]){
        //关闭自动开门
        [self stopAutoOpen];
        result([NSNumber numberWithBool:true]);
    } else {
        result(FlutterMethodNotImplemented);
    }
}


- (void) showMsg:(NSString *) msg
{
//    self.calibrationAlert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
//    [self.calibrationAlert show];
    NSLog(@"log----%s",msg);
}


// 扫描附近设备
// Scan Device
- (void) scanDevice:(FlutterMethodCall *)call
                               result:(FlutterResult)result{
    int ret = [LibDevModel scanDevice:1000];
    if (ret == 0){
        [self showMsg:@"Call the scanDevice interface successfully, wait for the onScanOver callback function result"]; // 调用扫描设备接口成功，请等待onScanOver回调函数结果
        NSLog(@"log----发送扫描成功");
    }
    else{
        [self showMsg:[NSString stringWithFormat:@"Scan device failure，ret=%d", ret]];
    }
    // Receive the result - the callback function
    [LibDevModel onScanOver:^(NSMutableDictionary *devDict) {
        NSLog(@"log----scanOver");
        [self onScanOver: devDict];
    }];
}
// scanDevice interface callback function
-(void) onScanOver:(NSMutableDictionary *)devDict
{
//    if (devDict.count == 0)
//    {
////        [self showMsg:@"There is no device around"]; // 周围没有设备
//        return;
//    }
//    NSString *scanDevStr = self.scanRetField.text;
//    for (NSString *devSn in devDict)
//    {
//        if ([scanDevStr isEqualToString:@""])
//        {
//            scanDevStr = [NSString stringWithFormat:@"devSn:%@,RSSI=%@", devSn, devDict[devSn]];
//        }
//        else
//        {
//            scanDevStr = [NSString stringWithFormat:@"%@; devSn:%@,RSSI=%@", scanDevStr, devSn, devDict[devSn]];
//        }
//    }
    NSLog(@"log----扫描完成--");
    NSMutableArray <NSString*> *arr = [NSMutableArray new];
    if(devDict.count > 0){
        for (NSString *devSn in devDict){
            [arr addObject:devSn];
        }
    }
    self.results(arr); // Show the scan device data
}

// Open door click
- (void)openDoor:(LibDevModel *) dev{
    @try{
        int ret = [LibDevModel openDoor:dev]; // E.g：Use openDoor interface
    //    int ret = [LibDevModel controlDevice:operateDev andOperation:0x00];  // E.g：Use controlDevice interface
        if (ret == 0)
        {
            // Receive the result - the callback function
            [LibDevModel onControlOver:^(int ret, NSMutableDictionary *msgDict) {
    //            [hud hide:YES afterDelay:0];
                [self onCommOver:ret andMsgDict:msgDict];
            }];
        }
        else
        {
    //        [hud hide:YES afterDelay:0];
            [self showMsg:[NSString stringWithFormat:@"Operation device failure，ret=%d", ret]];
        }

    }@catch (NSException *exception) {

    }
}

// controlDevice interface callback function
-(void) onCommOver:(int)ret andMsgDict:(NSMutableDictionary *)msgDict
{
    if (ret == 0)
    {
//        [self showMsg:@"Open door success"];
//        [self.view makeToast:@"nij"];
        
//        [[[UIApplication sharedApplication].windows lastObject] makeToast:@""
//                                                                 duration:3
//                                                                 position:CSToastPositionBottom
//                                                                    style:style
//         ];
        
    }
    else
    {
//        [self showMsg:[NSString stringWithFormat:@"Open door failure，ret=%d", ret]];
    }

    self.results([NSNumber numberWithInt:ret]);
}

// 扫描开门调用示例：1. 先扫描周围设备， 2. 找出信号值最强的设备， 3. 调用开门接口; 扫描+开门操作，需要一点时间，界面上最好限制用户连续点击操作：间隔2秒以上
// Scan the door to open the door to take the example: 1. Scanning the device around, 2. Find the equipment with the strongest signal value, 3. Call the door opening interface; scan + open the door operation, take a little time, the interface is best to limit the user to click operation: Interval of 2 seconds or more
//- (IBAction)shareOpenClick:(id)sender
//{
//    // 1. 获取扫描周围的设备结果
//    // 1. Gets the device results around the scan
//    int ret = [LibDevModel scanDevice:100];
//    if (ret == 1)
//    {
//        MBProgressHUD *hud = [MBProgressHUD showMessage:@"scaning..."];
//        // Receive the result - the callback function
//        [LibDevModel onScanOver:^(NSMutableDictionary *scanDevDict) {
//            // 2. 找出信号值最强的设备，信号值为负数
//            // 2. Locate the device with the highest signal value, and the signal value is negative
//            [hud hide:YES afterDelay:0];
//            if ([scanDevDict count] == 0)
//            {
//                [self showMsg:@"There is no device around"];
//                return;
//            }
//            [self openNearDeviceByScan:scanDevDict];
//        }];
//    }
//    else
//    {
//        [self showMsg:[NSString stringWithFormat:@"Scan device failure，ret=%d", ret]];
//    }
//}

/**
 * 靠近开门功能
 *
 * 二次开发注意：
 * 靠近开门实际为使用蓝牙后台模式，即APP启动后按Home键回到手机主界面，或者锁屏状态下，都可以正常使用手机蓝牙扫描开门，
 * 因此开启蓝牙后台模式后手机蓝牙将会被APP一直霸占，并增加一定的耗电量，大概会多占用百分之八，锁屏状态下会多节省一些耗电量，
 * 锁屏状态下：如果5分钟内周围完全没有一台我们我们的蓝牙设备（这个时间不太固定，仅参考），将会临时关闭靠近开门功能（节约资源），要重新开启需要手机亮屏。
 * 靠近开门间隔时间：5秒，即APP调用SDK做任意蓝牙操作（开门、扫描、设置参数等），都会等待操作结束后5秒才会继续执行靠近开门模式
 * 使用靠近开门，需要设置APP允许使用蓝牙后台模式，具体请看SDK文档中的截图说明
 *
 *
 * Near Open Function
 *
 * Secondary development attention:
 * Near open the door to use the Bluetooth background mode, that is, press the Home key to start the APP back to the phone's main interface, or lock screen, you can normally use the phone Bluetooth scanning to open the door.
 * So open the Bluetooth background mode after the phone will have been occupied by the Bluetooth and APP, and increase the power consumption, probably will occupy eight percent more lock screen state will save some more power consumption.
 * Lock screen state: If you do not have a Bluetooth device within 5 minutes (this time is not fixed, only reference), will be temporarily closed close to open the door function (save resources), to re-open the need for mobile phone screen.
 * Close to the door to open the interval: 5 seconds, that is, APP calls the SDK to do any Bluetooth operation (open the door, scan, set parameters, etc.), will wait until 5 seconds after the end of the operation will continue to close the door mode
 * Use near open the door, you need to set the APP to allow the use of Bluetooth background mode, see the specific SDK documentation in the screenshot description
 */
-(void) nearOpenSwitch:(NSString *) autoOpen:(NSString *) json:(int) limit{
    if ([autoOpen isEqualToString:@"1"]){
        NSArray* devArray = [self toArrayOrNSDictionary:json];
        NSLog(json);
        for(NSDictionary *dataDict in devArray){
            LibDevModel * devModel = [[LibDevModel alloc] init];
            devModel.devSn = [dataDict objectForKey:@"devSn"];
            devModel.devMac = [dataDict objectForKey:@"devMac"];
            devModel.devType = [dataDict objectForKey:@"devType"];
            devModel.openMode = 1;
            devModel.eKey = [dataDict objectForKey:@"ekey"];
            self.tempDevDict[devModel.devSn] = devModel;
//            NSLog(self.tempDevDict[devModel.devSn]);
        }

//        if (self.tempDevDict.count == 0)
//        {
//            [self showMsg:@"You do not have a testable device and can not test the proximity door function"]; // 您没有一台可测试设备，不能测试靠近开门功能
//            [self.nearOpenButton setOn:NO];
//            return;
//        }
        // Start near open function ---> Bluebooth background mode
        [LibDevModel startBackgroundMode]; // 调用SDK开启蓝牙后台模式，即使用靠近开门功能

        // 靠近开门使用蓝牙后台模式，苹果官方审核较严格，需要给用户一些提醒是否开启，Demo这里就不做“确定”，“取消”的弹出判断了
        // Use the Bluebooth background mode, you must give the user some hints --> Appstore auditing
//        [self showMsg:@"Already close to open mode. Note: open close to open the door, will always occupy the phone Bluetooth, and increase the number of power consumption"];  // 已打开靠近开门模式。注意：打开靠近开门功能，将会一直占用手机蓝牙，并增加一些耗电量.

        // 设置靠近开门回调函数，scanDevDict格式：{设备序列号：信号值}， 例如: {"123456": -70, "654321": -72}
        // Set close to the open callback function, scanDevDict format: {device serial number: signal value}, E.g: {"123456": -70, "654321": -72}
        [LibDevModel onBGScanOver:^(NSMutableDictionary *scanDevDict) {
//            if ([scanDevDict count] == 0)
//            {
//                return;
//            }
            // Identify the device with the strongest signal value, and the signal value is negative
            [self openNearDeviceByScan:scanDevDict:limit]; // 找出信号值最强的设备，信号值为负数
        }];
    }else{
        [LibDevModel stopBackgroundMode];
        [self showMsg:@"Closed near open mode"]; // 已关闭靠近开门模式
    }
}

-(void) stopAutoOpen{
    [LibDevModel stopBackgroundMode];
    [self showMsg:@"Closed near open mode"]; // 已关闭靠近开门模式
}

-(id)toArrayOrNSDictionary:(NSString *)jsonString{
    NSData* jsonData = [jsonString dataUsingEncoding:NSASCIIStringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}


// Open the near device
-(void)openNearDeviceByScan:(NSMutableDictionary *)scanDevDict:(int) limit{
    // Get the open device sn
    NSArray *rssiArray = [scanDevDict allValues];
    // Signal values are sorted in ascending order. Example: [-85, -73, -65]
    NSArray *rssiSortedArray= [rssiArray sortedArrayUsingSelector:@selector(compare:)]; // 信号值升序排序，示例:[-85, -73, -65]
    NSString *devSn = [self getOpenDevSn:rssiSortedArray andScanDict:scanDevDict:limit];
    NSLog(@"====Open devsn:%@", devSn);
    NSLog(@"====Open ",self.tempDevDict[@"2359357579"]);
    
    
    
    if (self.tempDevDict[devSn] != nil)
    {
        // Use SDK Open door
//        MBProgressHUD *hud = [MBProgressHUD showMessage:@"openning..."];
//        LibDevModel *devModel = self.tempDevDict[@"2359357579"];
    
//    LibDevModel* devModel = [[LibDevModel alloc] init];
//    devModel.devSn = @"2359357579";
//    devModel.devMac = @"e3:8c:8c:a0:f0:8b";
//    devModel.eKey = @"84d9ff2721bc19c487df1682e0598447000000000000000000000011907172301000";
//    devModel.devType = 20;
//    devModel.openMode = 1;

            @try{

            //        int ret = [LibDevModel controlDevice:devModel andOperation:0x00];  // E.g 1：Use controlDevice interface
                    int ret = [LibDevModel openDoor:self.tempDevDict[devSn]]; // E.g 2：Use openDoor interface

                    if (ret != 0)
                    {
            //            [hud hide:YES afterDelay:0];
            //            [self showMsg:[NSString stringWithFormat:@"Open Failure，reason ret=%d", ret]];
                        return;
                    }
                    // 接收开门结果--回调函数
                    // Receive the open result - the callback function
                    [LibDevModel onControlOver:^(int ret, NSMutableDictionary *msgDict) {
            //            [hud hide:YES afterDelay:0];
            //            [self showMsg:[NSString stringWithFormat:@"Device：%@ Open Success", devSn]];
                        [self onCommOver:ret andMsgDict:msgDict];
                    }];
            //    }


            }@catch (NSException *exception) {

            }
    }else{
//        [self showMsg:@"There are no devices within the permissions"];
        return;
    }
}

// 扫描回来的设备，取出权限内信号最强的设备序列号---参考
// Scan the equipment back, remove the signal within the authority of the strongest device serial number --- reference
-(NSString *)getOpenDevSn:(NSArray *)rssiArray andScanDict:(NSMutableDictionary *) scanDict:(int) limit{
    long maxIndex = rssiArray.count - 1;
    for (long i = maxIndex; i >=0; i--)
    {
        for (NSString *devSn in scanDict)
        {
            if (scanDict[devSn] == rssiArray[i])
            {
                // If you want to limit the distance, add rssi judgment
                if ([rssiArray[i] intValue] >= -75) // 如果需要判断开门距离，这里添加判断（rssi >= -65 近距离，rssi >= -75 中距离）
                {
                    // User must has the auth device
                    if (self.tempDevDict[devSn] != nil) // 用户需要有设备的权限
                    {
                        return devSn;
                    }
                }
            }
        }
    }
    return nil;
}

@end
