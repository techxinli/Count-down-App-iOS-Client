//
//  TodayViewController.h
//  FocusWidget
//
//  Created by 李鑫 on 16/8/27.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TodayViewController : UIViewController

@property (nonatomic,strong) UILabel *timeLabel;

//@property (nonatomic,strong) UIButton *one;
//@property (nonatomic,strong) UIButton *two;
//@property (nonatomic,strong) UIButton *three;
//@property (nonatomic,strong) UIButton *four;
//@property (nonatomic,strong) UIButton *five;



@property dispatch_source_t _timer;

@property NSString *day;
@property NSString *hour;
@property NSString *minute;
@property NSString *second;




@end
