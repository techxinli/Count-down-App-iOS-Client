//
//  ViewController.h
//  Focus
//
//  Created by 李鑫 on 16/8/26.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXHRrettyRuler.h"
#import "AppStatus.h"



@interface ViewController : UIViewController

@property (nonatomic,strong) TXHRrettyRuler *ruler;

@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic) float isthat;

@property NSString *day;
@property NSString *hour;
@property NSString *minute;
@property NSString *second;
@property int seconds;

@property dispatch_source_t _timer;

@property(nonatomic,strong)NSTimer*countDownTimer;

- (void)time;

@end

