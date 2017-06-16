//
//  AppDelegate.m
//  Focus
//
//  Created by 李鑫 on 16/8/26.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "AppDelegate.h"




@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    }
    


   
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _Vc = [[ViewController alloc]init];
    self.window.rootViewController = _Vc;
    [self.window makeKeyWindow];
    
    
       // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //NSLog(@"123213");
  
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDate *endData =  [user valueForKey:@"rulerValue"];
    //NSLog(@"%@",endData);


   
    if ([AppStatus shareInstance]._timeLabel && [AppStatus shareInstance]._timeLabel.alpha > 0.9999) {
     
        if ([AppStatus shareInstance]._timer != nil) {
            dispatch_source_cancel([AppStatus shareInstance]._timer);
            [AppStatus shareInstance]._timer = nil;
            NSLog(@"sssssssssssssssssssssssssssss123");
        }
        
        NSDate *startDate = [NSDate date];
        NSTimeInterval timeInterval =[endData timeIntervalSinceDate:startDate];
        NSLog(@"%f",timeInterval);
        if (timeInterval <= 0.5) {
            
            if (__timer != nil) {
                
            dispatch_source_cancel(__timer);
            __timer = nil;
            [AppStatus shareInstance]._timer = __timer;
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [AppStatus shareInstance].ruler.alpha = 1;
                [AppStatus shareInstance]._timeLabel.alpha = 0;
                
            });
            [user setValue:nil forKey:@"rulerValue"];
            NSLog(@"12314sadfa1231");

        }

        else{
            
            if (__timer != nil) {
                
                dispatch_source_cancel(__timer);
                __timer = nil;
                [AppStatus shareInstance]._timer = __timer;
                
            }

             NSLog(@"123nnnnnnn");
            [AppStatus shareInstance].ruler.alpha = 0;
            [AppStatus shareInstance]._timeLabel.alpha = 1;
            if (__timer==nil) {
                __block int timeout = timeInterval; //倒计时时间
                NSLog(@"%f",timeInterval);
                if (timeout!=0) {
                    
                     NSLog(@"123ssssss");
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    __timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                    [AppStatus shareInstance]._timer = __timer;
                    dispatch_source_set_timer(__timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                    dispatch_source_set_event_handler(__timer, ^{
                        if(timeout<=0.5){ //倒计时结束，关闭
                             NSLog(@"123wwwwww");
                            dispatch_source_cancel(__timer);
                            __timer = nil;
                            [AppStatus shareInstance]._timer = __timer;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                 [AppStatus shareInstance].ruler.alpha = 1;
                                [AppStatus shareInstance]._timeLabel.alpha = 0;
                                
                            });
                            [user setValue:nil forKey:@"rulerValue"];
                            NSLog(@"1231412213sadasda1231");


                        }else{
                            
                             NSLog(@"12,,,,,,,");
                            int days = (int)(timeout/(3600*24));
                            if (days==0) {
                                //detailCell.dayLabel.text = @"";
                            }
                            int hours = (int)((timeout-days*24*3600)/3600);
                            int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                            int second = timeout-days*24*3600-hours*3600-minute*60;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (days==0) {
                                    //detailCell.dayLabel.text = @"";
                                }else{
                                    //detailCell.dayLabel.text = [NSString stringWithFormat:@"%d天",days];
                                }
                                if (hours<10) {
                                    _hour = [NSString stringWithFormat:@"0%d",hours];
                                }else{
                                    _hour = [NSString stringWithFormat:@"%d",hours];
                                }
                                if (minute<10) {
                                    _minute = [NSString stringWithFormat:@"0%d",minute];
                                }else{
                                    _minute = [NSString stringWithFormat:@"%d",minute];
                                }
                                if (second<10) {
                                    _second = [NSString stringWithFormat:@"0%d",second];
                                }else{
                                    _second = [NSString stringWithFormat:@"%d",second];
                                }
                                
                                [AppStatus shareInstance]._timeLabel.text = [NSString stringWithFormat:@"%@ : %@ : %@",_hour,_minute,_second];
                                
                                
                            });
                            timeout--;
                        }
                    });
                    dispatch_resume(__timer);
                }
            }
            
        }
    
    
    }

}

- (void)application:(UIApplication *)application
performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
  completionHandler:(void(^)(BOOL succeeded))completionHandler{
    
    
    if([shortcutItem.type isEqualToString:@"-11.UITouchText.add"]){
        
        if ([AppStatus shareInstance]._timer != nil) {
            dispatch_source_cancel([AppStatus shareInstance]._timer);
            [AppStatus shareInstance]._timer = nil;
        }
       [[UIApplication sharedApplication] cancelAllLocalNotifications];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
       [user setValue:nil forKey:@"rulerValue"];
        [_Vc time];
//        NSLog(@"sads");
//        NSArray *arr = @[@"hello 3D Touch"];
//        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
//        //设置当前的VC 为rootVC
//        [self.window.rootViewController presentViewController:vc animated:YES completion:^{
//        }];
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{

    
   
    NSLog(@"1231");

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      
}



@end
