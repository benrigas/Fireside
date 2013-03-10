//
//  Authorization.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMDataObject.h"

@interface OAuthAuthorization : MMDataObject

@property (nonatomic, strong) NSString* accessToken;
@property (nonatomic, strong) NSString* refreshToken;
@property (nonatomic, strong) NSDate* expirationDate;

@end
