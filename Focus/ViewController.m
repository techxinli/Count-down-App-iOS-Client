//
//  ViewController.m
//  Focus
//
//  Created by 李鑫 on 16/8/26.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ViewController.h"




@interface ViewController () <TXHRrettyRulerDelegate>


@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden{
    
    return YES;
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    _ruler = [[TXHRrettyRuler alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/2-70, [UIScreen mainScreen].bounds.size.width - 20 * 2, 140)];
    _ruler.rulerDeletate = self;
    [_ruler showRulerScrollViewWithCount:600 average:[NSNumber numberWithFloat:0.1] currentValue:30.0f smallMode:YES];
    [self.view addSubview:_ruler];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2-50, self.view.frame.size.width, 100)];
    _timeLabel.text = @"00 : 20 : 13";
    _timeLabel.alpha = 0;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor darkGrayColor];
    _timeLabel.font = [UIFont fontWithName:@"GillSans-Light" size:65];
    [self.view addSubview:_timeLabel];
    //GillSans-Light
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
    [AppStatus shareInstance]._timeLabel = _timeLabel;
    [AppStatus shareInstance].ruler = _ruler;
    
    //启动倒计时后会每秒钟调用一次方法 countDownAction
    
    [self time];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user valueForKey:@"isopen"] == nil) {
        
    }
    
    
}

- (void)txhRrettyRuler:(TXHRulerScrollView *)rulerScrollView {
    
    _isthat = rulerScrollView.rulerValue;
    

}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
   [[UIApplication sharedApplication] cancelAllLocalNotifications];
   // Do any additional setup after loading the view, typically from a nib.
    
    //NSLog(@"%ld",_isthat*10);

    int time = (int)(_isthat*10);
    
    NSLog(@"%d",time);
    if(time<=100){
    _seconds = (time%10)*6 + ((time - time%10)/10)*60;
        
    }
    else if (time >100){
    _seconds = (time%10) * 6 + ((time%100 - time%10)/10) * 60 + ((time - time%100)/10)*60;
    ;
        
    }
    
    NSDate *endData = [NSDate dateWithTimeIntervalSinceNow:_seconds];
    // NSDate *now = [NSDate date];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:endData forKey:@"rulerValue"];
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.Giraffe"];
    [shared setValue:endData forKey:@"Widget"];
    [shared synchronize];
    
    if ([AppStatus shareInstance]._timer != nil) {
        dispatch_source_cancel([AppStatus shareInstance]._timer);
        [AppStatus shareInstance]._timer = nil;
        NSLog(@"sssssssssssssssssssssssssssss123");
    }

    
    if (__timer != nil) {
        
        dispatch_source_cancel(__timer);
        __timer = nil;
        [AppStatus shareInstance]._timer = __timer;
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    }
    
    if (_ruler.alpha == 1) {
        
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        NSDate *endData =  [user valueForKey:@"rulerValue"];
        if (_isthat == 30) {
            NSTimeInterval timeInterval = 1800;
            if (timeInterval<=0.5) {
                
                if (__timer != nil) {
                    
                    dispatch_source_cancel(__timer);
                    __timer = nil;
                    [AppStatus shareInstance]._timer = __timer;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                    
                }
                NSLog(@"1");
                [user setValue:nil forKey:@"rulerValue"];
                //[shared setValue:nil forKey:@"Widget"];
                _ruler.alpha = 1;
                _timeLabel.alpha = 0;

           
            }
            else{
                
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                if (notification) {
                    //NSLog(@">> 10s' local notification");
                    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:_seconds];
                    notification.timeZone = [NSTimeZone defaultTimeZone];
                    notification.alertTitle = @"提醒";
                    notification.alertBody = @"你的时间到啦";
                    //_notification.applicationIconBadgeNumber = 1;

                    notification.soundName = @"Bugu.caf";
                   
                    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"notification_1", @"id", nil];
                    notification.userInfo = infoDict;
                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                    
                }
                
                
                _ruler.alpha = 0;
                _timeLabel.alpha = 1;
                if (__timer != nil) {
                    
                    
                    dispatch_source_cancel(__timer);
                    __timer = nil;
                    [AppStatus shareInstance]._timer = __timer;
                    
                }

                
                if (__timer==nil) {
                    __block int timeout = timeInterval; //倒计时时间
                    
                    if (timeout!=0) {
                        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        __timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                        [AppStatus shareInstance]._timer = __timer;

                        dispatch_source_set_timer(__timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                        dispatch_source_set_event_handler(__timer, ^{
                            if(timeout<=0.5){ //倒计时结束，关闭
                                dispatch_source_cancel(__timer);
                                __timer = nil;
                                [AppStatus shareInstance]._timer = __timer;
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    _ruler.alpha = 1;
                                    _timeLabel.alpha = 0;
                                    
                                    
                                });
                                NSLog(@"2");

                                [user setValue:nil forKey:@"rulerValue"];
                                //[shared setValue:nil forKey:@"Widget"];

                            }else{
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
                                    
                                    _timeLabel.text = [NSString stringWithFormat:@"%@ : %@ : %@",_hour,_minute,_second];
                                    
                                    
                                });
                                timeout--;
                            }
                        });
                        dispatch_resume(__timer);
                    }
                }
                ////////////////////////////
                
            }
            
        }
        else{
            NSDate *startDate = [NSDate date];
            NSTimeInterval timeInterval =[endData timeIntervalSinceDate:startDate];
          
            if (timeInterval<=0.5) {
                
                if (__timer != nil) {
                    
                    dispatch_source_cancel(__timer);
                    __timer = nil;
                    [AppStatus shareInstance]._timer = __timer;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                    
                }
                
                _ruler.alpha = 1;
                _timeLabel.alpha = 0;
                NSLog(@"3");

                [user setValue:nil forKey:@"rulerValue"];
                //[shared setValue:nil forKey:@"Widget"];


                
            }
            
            else{
                
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                if (notification) {
                    //NSLog(@">> 10s' local notification");
                    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:_seconds];
                    notification.timeZone = [NSTimeZone defaultTimeZone];
                    notification.alertTitle = @"提醒";
                    notification.alertBody = @"你的时间到啦";
                    notification.alertAction = @"添加新的倒计时";
                    notification.soundName = @"Bugu.caf";
                    notification.applicationIconBadgeNumber = 1;
                    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"notification_1", @"id", nil];
                    notification.userInfo = infoDict;
                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                }
                
                
                _ruler.alpha = 0;
                _timeLabel.alpha = 1;
                
                if (__timer != nil) {
                    
                    dispatch_source_cancel(__timer);
                    __timer = nil;
                    [AppStatus shareInstance]._timer = __timer;
                    
                }

                
                if (__timer==nil) {
                    NSLog(@"213213123");
                    __block int timeout =timeInterval; //倒计时时间
                    
                    if (timeout!=0) {
                        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        __timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                        [AppStatus shareInstance]._timer = __timer;

                        dispatch_source_set_timer(__timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                        dispatch_source_set_event_handler(__timer, ^{
                            if(timeout<=0.5){ //倒计时结束，关闭
                                dispatch_source_cancel(__timer);
                                __timer = nil;
                                [AppStatus shareInstance]._timer = __timer;

                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    _ruler.alpha = 1;
                                    _timeLabel.alpha = 0;
                                    
                                    
                                });
                                NSLog(@"4");

                                [user setValue:nil forKey:@"rulerValue"];
                                //[shared setValue:nil forKey:@"Widget"];


                            }else{
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
                                    
                                    _timeLabel.text = [NSString stringWithFormat:@"%@ : %@ : %@",_hour,_minute,_second];
                                    
                                    
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
    
    
    else if (_ruler.alpha <= 0.001){
        
        _ruler.alpha = 1;
        _timeLabel.alpha = 0;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [user setValue:nil forKey:@"rulerValue"];
        [shared setValue:nil forKey:@"Widget"];


        if (__timer != nil) {
            
        dispatch_source_cancel(__timer);
        __timer = nil;
        [AppStatus shareInstance]._timer = __timer;

        dispatch_async(dispatch_get_main_queue(), ^{
        
        });
        }
    }
    
    NSLog(@"5");

       //[shared setValue:nil forKey:@"Widget"];



   
}


//实现倒计时动作
-(void)time{

    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDate *endData =  [user valueForKey:@"rulerValue"];

    if (__timer != nil) {
        
        dispatch_source_cancel(__timer);
        __timer = nil;
        [AppStatus shareInstance]._timer = __timer;
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    }

    
    if (endData == nil) {
        
        if (__timer != nil) {
            
            dispatch_source_cancel(__timer);
            __timer = nil;
            [AppStatus shareInstance]._timer = __timer;
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            
        }
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        _ruler.alpha = 1;
        _timeLabel.alpha = 0;
        

    }
    if (endData) {
        
        
        if ([AppStatus shareInstance]._timer != nil) {
            dispatch_source_cancel([AppStatus shareInstance]._timer);
            [AppStatus shareInstance]._timer = nil;
            
        }

        [AppStatus shareInstance]._timer = __timer;
        
        NSDate *startDate = [NSDate date];
        NSTimeInterval timeInterval =[endData timeIntervalSinceDate:startDate];
        NSLog(@"%f",timeInterval);
        
        if (timeInterval<=0.5) {
            
            if (__timer != nil) {
                
                dispatch_source_cancel(__timer);
                __timer = nil;
                [AppStatus shareInstance]._timer = __timer;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });

            }
            
            _ruler.alpha = 1;
            _timeLabel.alpha = 0;
            NSLog(@"6");

            [user setValue:nil forKey:@"rulerValue"];

           
           
        }
        
        else{
            
            _ruler.alpha = 0;
            _timeLabel.alpha = 1;
            
            if (__timer != nil) {
                
                dispatch_source_cancel(__timer);
                __timer = nil;
                [AppStatus shareInstance]._timer = __timer;
                
            }

            
            if (__timer==nil) {
                __block int timeout = timeInterval; //倒计时时间
                
                if (timeout!=0) {
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    __timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                    [AppStatus shareInstance]._timer = __timer;
                    
                    dispatch_source_set_timer(__timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                    dispatch_source_set_event_handler(__timer, ^{
                        if(timeout<=0.5){ //倒计时结束，关闭
                            dispatch_source_cancel(__timer);
                            __timer = nil;
                            [AppStatus shareInstance]._timer = __timer;
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                _ruler.alpha = 1;
                                _timeLabel.alpha = 0;
                                
                                
                            });
                            NSLog(@"7");

                            [user setValue:nil forKey:@"rulerValue"];
                          


                        }else{
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
                                
                                _timeLabel.text = [NSString stringWithFormat:@"%@ : %@ : %@",_hour,_minute,_second];
                                
                                
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
