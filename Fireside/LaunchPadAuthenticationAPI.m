//
//  CampfireAuthenticationAPI.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

// TODO
// Refresh Token call when token expires (401?)
// see https://github.com/37signals/bcx-api/issues/32
// Handle 401 etc in general

#import "LaunchPadAuthenticationAPI.h"
#import "AFNetworking.h"
#import "OAuth2WebViewController.h"
#import "LaunchPadAPIClient.h"

#define kClientID @"d5e4ef385e3b57b795d2680044128eb9091bf8d0"
#define kClientSecret @"eafbfb62e40443b60105d2099ce372dbb134039a"
#define kRedirectURL @"https://wakkle.com/fireside/auth"

@implementation LaunchPadAuthenticationAPI

+ (NSURL*) urlForAuthorization {
    NSString* urlString = [NSString stringWithFormat:@"https://launchpad.37signals.com/authorization/new?type=web_server&client_id=%@&redirect_uri=%@", kClientID, kRedirectURL];
    NSURL* url = [NSURL URLWithString:urlString];
    
    return url;
}

+ (void) requestTokenWithVerificationCode:(NSString*)verificationCode success:(void (^)(OAuthAuthorization* authorization))success failure:(void (^)(NSError* error))failure {

    NSString* urlString = [NSString stringWithFormat:@"authorization/token"];
    NSDictionary* parameters = @{@"type": @"web_server",
                                 @"client_id": kClientID,
                                 @"redirect_uri": kRedirectURL,
                                 @"client_secret": kClientSecret,
                                 @"code": verificationCode
                                 };
    
    [[LaunchPadAPIClient sharedInstance] postPath:urlString parameters:parameters
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSError* error = nil;
                                              
                                              id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                                              
                                              if (!error) {
                                                  OAuthAuthorization* authorization = [[OAuthAuthorization alloc] initWithAttributes:json];
                                                  
                                                  NSLog(@"refresh_token = %@\nexpires_in = %@", authorization.refreshToken, authorization.expirationDate);
                                                  
                                                  if (success) {
                                                      success(authorization);
                                                  }
                                              }
                                              
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              if (failure) {
                                                  failure(error);
                                              }
                                          }];
}

+ (void) requestAuthorizationSuccess:(void (^)(LaunchPadAuthorization* authorization))success failure:(void (^)(NSError* error))failure {
    NSString* urlString = [NSString stringWithFormat:@"authorization.json"];

    [[LaunchPadAPIClient sharedInstance] getPath:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"success: %@", responseObject);
        LaunchPadAuthorization* auth = [[LaunchPadAuthorization alloc] initWithAttributes:responseObject];
        if (success) {
            success(auth);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
        NSLog(@"failure: %@", error);
    }];
}

+ (void) requestTokenWithRefreshToken:(NSString*)refreshToken
                              success:(void (^)(OAuthAuthorization* authorization))success
                              failure:(void (^)(NSError* error))failure {
    //type=refresh&client_id={0}&redirect_uri={1}&client_secret={2}&refresh_token={3}
    NSString* urlString = [NSString stringWithFormat:@"authorization/token"];
    NSDictionary* parameters = @{@"type": @"refresh",
                                 @"client_id": kClientID,
                                 @"redirect_uri": kRedirectURL,
                                 @"client_secret": kClientSecret,
                                 @"refresh_token": refreshToken
                                 };
    
    [[LaunchPadAPIClient sharedInstance] postPath:urlString parameters:parameters
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSError* error = nil;
                                              
                                              id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                                              
                                              if (!error) {
                                                  OAuthAuthorization* authorization = [[OAuthAuthorization alloc] initWithAttributes:json];
                                                                                                    
                                                  if (success) {
                                                      success(authorization);
                                                  }
                                              }
                                              
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              if (failure) {
                                                  failure(error);
                                              }
                                          }];
}

@end
