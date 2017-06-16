//
//  AppDelegate.h
//  Focus
//
//  Created by 李鑫 on 16/8/26.
//  Copyright © 2016年 Alvin. All rights reserved.
//
//#import "TXHRrettyRuler.h"
#import <UIKit/UIKit.h>
#import "AppStatus.h"
#import "ViewController.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property NSString *day;
@property NSString *hour;
@property NSString *minute;
@property NSString *second;

@property dispatch_source_t _timer;

@property (nonatomic,strong) ViewController *Vc;


@end

