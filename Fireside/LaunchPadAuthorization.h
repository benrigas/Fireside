//
//  Authorization.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "MMDataObject.h"
#import "LaunchPadIdentity.h"

@interface LaunchPadAuthorization : MMDataObject

@property (nonatomic, strong) NSDate* expiresAt;
@property (nonatomic, strong) LaunchPadIdentity* identity;
@property (nonatomic, strong) NSArray* accounts;

@end
