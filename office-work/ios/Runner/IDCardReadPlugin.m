//
//  IDCardReadPlugin.m
//  Runner
//
//  Created by 韩健春 on 2020/7/1.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//
#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import "id2ViewController.h"
#import "IDCardReadPlugin.h"


static NSString *const CHANNEL_NAME = @"idcard_plugin";

@interface IDCardReadPlugin()
@property(nonatomic,retain) FlutterMethodChannel *channel;
@property(nonatomic,retain) FlutterResult results;
@end

@implementation IDCardReadPlugin{
    FlutterResult _result;
//    comminterface *commi;
}
@synthesize sensor;
comminterface *commi;
@synthesize peripheralViewControllerArray;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:CHANNEL_NAME binaryMessenger:[registrar messenger]];
    
    UIViewController *viewController =
    [UIApplication sharedApplication].delegate.window.rootViewController;
    IDCardReadPlugin * instance = [[IDCardReadPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
    
    commi = [[comminterface alloc] init:self];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    self.results = result;
    if([@"init" isEqualToString:call.method]){
    
        sensor = [[SerialGATT alloc] init];
         [sensor Init];
         sensor.delegate = self;
         peripheralViewControllerArray = [[NSMutableArray alloc] init];
        
        [self showMsg:@"106"];
        [self actionChoise:106];
    } else if([@"connect" isEqualToString:call.method]){
        [self showMsg:@"105"];
        [self actionChoise:105];
    } else if([@"read" isEqualToString:call.method]){
        [self showMsg:@"101"];
        [self actionChoise:101];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void) showMsg:(NSString *) msg
{
    NSLog(@"log---%@",msg);
}

- (void) actionChoise:(int)code{
    bool bBtConnected;
//    id2ViewController *id2Vc ;
    switch (code) {
        case 101:
            if(!bHadSetController){
                return;
            }
            
            unsigned char idTxt[256];
            unsigned char idPic[4096];
            unsigned char idFp[1024];
            int nRet = getIdCardInfo((char *)&idTxt, (char *)&idPic, (char *)&idFp, 8);
            
            if(nRet != 0){
                [self showMsg:[NSString stringWithFormat:@"read---%ld",nRet]];
                NSDictionary *result = @{
                    @"code":@"6",
                    @"message":@"读取失败"
                };
                NSString *str = [self convertToJsonData:result];
                self.results(str);
            }else{
                NSString *name = [[NSString alloc]initWithBytes:&idTxt[0] length:30 encoding:NSUTF16LittleEndianStringEncoding];
                NSString *sex = [self GetSexFromCode:[[NSString alloc]initWithBytes:&idTxt[30] length:2 encoding:NSUTF16LittleEndianStringEncoding ]];
                NSString *nation = [self GetNationalFromCode:[[NSString alloc]initWithBytes:&idTxt[32] length:4 encoding:NSUTF16LittleEndianStringEncoding ]];
                NSString *year = [[NSString alloc]initWithBytes:&idTxt[36] length:8 encoding:NSUTF16LittleEndianStringEncoding ];
                NSString *month = [[NSString alloc]initWithBytes:&idTxt[44] length:4 encoding:NSUTF16LittleEndianStringEncoding ];
                NSString *day = [[NSString alloc]initWithBytes:&idTxt[48] length:4 encoding:NSUTF16LittleEndianStringEncoding ];
                NSString *address = [[NSString alloc]initWithBytes:&idTxt[52] length:70 encoding:NSUTF16LittleEndianStringEncoding ];
                NSString *idcard = [[NSString alloc]initWithBytes:&idTxt[122] length:36 encoding:NSUTF16LittleEndianStringEncoding ];
                NSString *lblDeviceid3 = [[NSString alloc]initWithBytes:&idTxt[158] length:30 encoding:NSUTF16LittleEndianStringEncoding ];
                NSString *yxqxqs =  [[NSString alloc]initWithBytes:&idTxt[188] length:16 encoding:NSUTF16LittleEndianStringEncoding ];
                   yxqxqs =  [yxqxqs stringByAppendingString:@"--"];
                NSString *yxqxjz =  [[NSString alloc]initWithBytes:&idTxt[204] length:16 encoding:NSUTF16LittleEndianStringEncoding ];
                NSString *yxqx = [yxqxqs stringByAppendingString:yxqxjz];
                
                char bmpBuff[40000];
                nRet= id2GetBmpBuff((Byte*)&idPic[0] ,(Byte*)&bmpBuff[0]);
                NSData * bmpData = [[NSData alloc]initWithBytes:bmpBuff length:38862];
                
                UIImage *zpImg=[UIImage imageWithData:bmpData];
                NSData *_data = UIImageJPEGRepresentation(zpImg, 1.0f);
                NSString *image = [self convertToBase64ImageStr:zpImg];
                
                NSString *strs = [_data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                [self showMsg:strs];
                
                [self showMsg:@"--------------------"];
                
                [self showMsg:image];
                [self showMsg:name];
                [self showMsg:sex];
                [self showMsg:nation];
                [self showMsg:year];
                [self showMsg:month];
                [self showMsg:day];
                [self showMsg:address];
                [self showMsg:idcard];
                [self showMsg:lblDeviceid3];
                [self showMsg:yxqxqs];
                [self showMsg:yxqxjz];
                [self showMsg:yxqx];
                [self showMsg:@"read success"];
                
                NSDictionary *dict = @{
                    @"name": name,
                    @"idcard": idcard,
                    @"sex": sex,
                    @"birthday": [[year stringByAppendingString:month] stringByAppendingString:day],
                    @"national": nation,
                    @"address": address,
                    @"startDate": @"",
                    @"endDate": @"",
                    @"issued": @"",
                    @"image":image
                };
                
                NSDictionary *result = @{
                    @"code":@"0",
                    @"message":@"读取成功",
                    @"data":dict
                };
                NSString *str = [self convertToJsonData:result];
                self.results(str);
            }
            
            break;
        case 105:
            
            //NSString *str = [NSString stringWithFormat:@"read---%@",self.peripheral.name];
            //[self showMsg:sensor.activePeripheral.name];
            
            //[NSThread sleepForTimeInterval:3.0];
            
            bBtConnected = [commi connectBt:sensor.activePeripheral];
            if(bBtConnected){
                [self showMsg:@"建立连接成功"];
              //  _lbeInfo.text = @"建立连接成功,请演示各模块功能";
              //  [self playSound:1];
                bHadSetController = true;
                self.results([NSNumber numberWithBool:true]);
            }else{
                
                bool isConnected = [commi getBtStatus];
                if(isConnected) [self showMsg:@"connected"];
                else [self showMsg:@"not connected"];
                
                [self showMsg:@"建立连接失败"];
              //  _lbeInfo.text = @"建立连接失败";
              //  [self playSound:2];
                self.results([NSNumber numberWithBool:false]);
            }
            break;
        case 106:
            if ([sensor activePeripheral]) {
                if (sensor.activePeripheral.state == CBPeripheralStateConnected) {
                    [sensor.manager cancelPeripheralConnection:sensor.activePeripheral];
                    sensor.activePeripheral = nil;
                }
            }

            if ([sensor peripherals]) {
                sensor.peripherals = nil;
                [peripheralViewControllerArray removeAllObjects];
//                [btTableView reloadData];
            }

            sensor.delegate = self;
//            [Scan setTitle:@"扫描中..." forState:UIControlStateNormal];
            [self showMsg:@"扫描中..."];
            [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanTimer) userInfo:nil repeats:NO];

//            [sensor ScanDeviceList :5];
            
//            int a = [sensor ScanDeviceList :5];
//            NSString *str = [NSString stringWithFormat:@"read---%ld",a];
//            [self showMsg:str];
            
            break;
    }
}

- (NSString *)convertToBase64ImageStr:(UIImage *)image{
    NSData *imageData = UIImageJPEGRepresentation(image,0.1);
    NSData * base64Data = [imageData base64EncodedDataWithOptions:0];
    NSString *base64Str = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    return base64Str;
}

- (void) scanTimer
{
    NSInteger a = [sensor ScanDeviceList :5];
    NSString *str = [NSString stringWithFormat:@"read---%ld",a];
    [self showMsg:str];
}

//scan device callback method
- (void) peripheralFound:(CBPeripheral *)peripheral
{
    [self showMsg:@"In peripheralFound..."];
//    NSString *str = [NSString stringWithFormat:@"read---%@",peripheral.name];
//    [self showMsg:str];
    
    if([peripheral.name hasPrefix:@"SS-"] || [peripheral.name hasPrefix:@"SYN"] || [peripheral.name hasPrefix:@"PSB"]){
        
        [sensor stopScan];
//        [self showMsg:@"In peripheralFound...1"];
//        [NSThread sleepForTimeInterval:10.0];
//        [self showMsg:@"In peripheralFound...3"];
        
//        id2ViewController *controller = [[id2ViewController alloc] init];
//        controller.gPeripheral = peripheral;
//        [commi connectBt:controller.gPeripheral];
        
//        [self.navigationController pushViewController:controller animated:YES];
        
        sensor.activePeripheral = peripheral;
//        bool bBtConnected = [commi connectBt:peripheral];
 //       if(bBtConnected)[self showMsg:@"success-----"];
//        else [self showMsg:@"error------"];
        self.results([NSNumber numberWithBool:true]);
    }
}

-(NSString *)GetSexFromCode:(NSString *) str
{
    NSString * sexStr = @"";
    NSInteger n =  [str intValue];
    switch (n) {
        case 1:
            return @"男";
        case 2:
            return @"女";
        default:
            return @"其他";
    }
    return sexStr;
}

-(NSString *)GetNationalFromCode:(NSString *) str
{
    NSString * nationalStr = @"";
    NSInteger n =  [str intValue];
    switch (n) {
        case 1:
            return @"汉族";
        case 2:
            return @"蒙古族";
        case 3:
            return @"回族";
        case 4:
            return @"藏族";
        case 5:
            return @"维吾尔族";
        case 6:
            return @"苗族";
        case 7:
            return @"彝族";
        case 8:
            return @"壮族";
        case 9:
            return @"布依族";
        case 10:
            return @"朝鲜族";
        case 11:
            return @"满族";
        case 12:
            return @"侗族";
        case 13:
            return @"瑶族";
        case 14:
            return @"白族";
        case 15:
            return @"土家族";
        case 16:
            return @"哈尼族";
        case 17:
            return @"哈萨克族";
        case 18:
            return @"傣族";
        case 19:
            return @"黎族";
        case 20:
            return @"傈僳族";
        case 21:
            return @"佤族";
        case 22:
            return @"畲族";
        case 23:
            return @"高山族";
        case 24:
            return @"拉祜族";
        case 25:
            return @"水族";
        case 26:
            return @"东乡族";
        case 27:
            return @"纳西族";
        case 28:
            return @"景颇族";
        case 29:
            return @"柯尔克孜族";
        case 30:
            return @"土族";
        case 31:
            return @"达斡尔族";
        case 32:
            return @"仫佬族";
        case 33:
            return @"羌族";
        case 34:
            return @"布朗族";
        case 35:
            return @"撒拉族";
        case 36:
            return @"毛难族";
        case 37:
            return @"仡佬族";
        case 38:
            return @"锡伯族";
        case 39:
            return @"阿昌族";
        case 40:
            return @"普米族";
        case 41:
            return @"塔吉克族";
        case 42:
            return @"怒族";
        case 43:
            return @"乌孜别克族";
        case 44:
            return @"俄罗斯族";
        case 45:
            return @"鄂温克族";
        case 46:
            return @"崩龙族";
        case 47:
            return @"保安族";
        case 48:
            return @"裕固族";
        case 49:
            return @"京族";
        case 50:
            return @"塔塔尔族";
        case 51:
            return @"独龙族";
        case 52:
            return @"鄂伦春族";
        case 53:
            return @"赫哲族";
        case 54:
            return @"门巴族";
        case 55:
            return @"珞巴族";
        case 56:
            return @"基诺族";
        default:
            return @"其他";
    }
    return nationalStr;
}

- (NSString*)convertToJsonData:(NSDictionary*)dict
{
    NSError*error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString*jsonString;
    if(!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格

    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}
@end
