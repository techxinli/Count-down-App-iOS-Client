//
//  AppStatus.h
//  Focus
//
//  Created by 李鑫 on 16/8/27.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TXHRrettyRuler.h"

@interface AppStatus : NSObject
{
    
    UILabel *_timeLabel;
    TXHRrettyRuler *ruler;
    dispatch_source_t _timer;
   
    
}
@property (nonatomic,retain) UILabel *_timeLabel;
@property (nonatomic,strong) TXHRrettyRuler *ruler;
@property dispatch_source_t _timer;



+(AppStatus *)shareInstance;


@end
