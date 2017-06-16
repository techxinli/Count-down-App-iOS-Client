//
//  TodayViewController.m
//  FocusWidget
//
//  Created by 李鑫 on 16/8/27.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.Giraffe"];
    NSDate *endData = [shared valueForKey:@"Widget"];
    NSLog(@"%@sadsa",endData);
    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
    
//
//    
    // Do any additional setup after loading the view from its nib.
}



- (void)viewWillAppear:(BOOL)animated{

    
    [super viewWillAppear:animated];
    
    [_timeLabel removeFromSuperview];
   
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2-50, self.view.frame.size.width, 100)];
    //_timeLabel.text = @"添加倒计时";
    _timeLabel.alpha = 1;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    //_timeLabel.backgroundColor = [UIColor whiteColor];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont fontWithName:@"GillSans-Light" size:65];
    [self.view addSubview:_timeLabel];
    
  

    if (__timer != nil) {
        
        dispatch_source_cancel(__timer);
        __timer = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    }

    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.Giraffe"];
    NSDate *endData = [shared valueForKey:@"Widget"];

    NSLog(@"%@ssssssssss",endData);
    if (endData == nil) {
        
        if (__timer != nil) {
            
            dispatch_source_cancel(__timer);
            __timer = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            
        }
        //_timeLabel.text = @"添加倒计时";
        
        
    }
    if (endData) {
        
        NSDate *startDate = [NSDate date];
        NSTimeInterval timeInterval =[endData timeIntervalSinceDate:startDate];
        NSLog(@"%f",timeInterval);
        
        if (timeInterval<=0.5) {
            
            if (__timer != nil) {
                
                dispatch_source_cancel(__timer);
                __timer = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
                
            }
            
            [shared setValue:nil forKey:@"Widget"];

            
        }
        
        else{
            
       
            if (__timer != nil) {
                
                dispatch_source_cancel(__timer);
                __timer = nil;
              
                
            }
            
            
            if (__timer==nil) {
                __block int timeout = timeInterval; //倒计时时间
                
                if (timeout!=0) {
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    __timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                   
                    
                    dispatch_source_set_timer(__timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                    dispatch_source_set_event_handler(__timer, ^{
                        if(timeout<=0.5){ //倒计时结束，关闭
                            dispatch_source_cancel(__timer);
                            __timer = nil;
                           
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                                                
                                
                            });
                            
                            [shared setValue:nil forKey:@"Widget"];

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
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{

    return UIEdgeInsetsMake(0.0, 0.0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
