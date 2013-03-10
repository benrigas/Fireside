//
//  Account.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "MMDataObject.h"

@interface LaunchPadAccount : MMDataObject

@property (nonatomic, strong) NSString* product;
@property (nonatomic, strong) NSNumber* id;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* href;

@end
