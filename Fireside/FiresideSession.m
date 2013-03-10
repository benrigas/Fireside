//
//  FiresideSession.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "FiresideSession.h"

@implementation FiresideSession

+ (id)sharedInstance
{
    static FiresideSession *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[FiresideSession alloc] init];
    });
    
    return __sharedInstance;
}

@end
