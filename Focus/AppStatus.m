//
//  AppStatus.m
//  Focus
//
//  Created by 李鑫 on 16/8/27.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "AppStatus.h"

static AppStatus *_instance = nil;

@implementation AppStatus

@synthesize ruler = ruler,_timeLabel = _timeLabel,_timer = _timer;



+(AppStatus*)shareInstance
{
    
    if (_instance == nil)
    {
        _instance = [[super alloc]init];
        
    }
    return _instance;
    
    
}

-(id)init
{
    if (self = [super init])
    {
        
        
        
    }
    
    return self;
    
    
    
}



@end
