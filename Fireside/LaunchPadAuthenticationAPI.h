//
//  CampfireAuthenticationAPI.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthAuthorization.h"
#import "LaunchPadAuthorization.h"

@interface LaunchPadAuthenticationAPI : NSObject

+ (NSURL*) urlForAuthorization;

+ (void) requestTokenWithVerificationCode:(NSString*)verificationCode
                                  success:(void (^)(OAuthAuthorization* authorization))success
                                  failure:(void (^)(NSError* error))failure;

+ (void) requestAuthorizationSuccess:(void (^)(LaunchPadAuthorization* authorization))success
                             failure:(void (^)(NSError* error))failure;

+ (void) requestTokenWithRefreshToken:(NSString*)refreshToken
                              success:(void (^)(OAuthAuthorization* authorization))success
                              failure:(void (^)(NSError* error))failure;

@end
