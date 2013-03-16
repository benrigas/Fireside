//
//  FiresideSession.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "FiresideSession.h"

@implementation FiresideSession

//+ (id)sharedInstance
//{
//    static FiresideSession *__sharedInstance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        __sharedInstance = [[FiresideSession alloc] init];
//    });
//    
//    return __sharedInstance;
//}

- (void) saveSession {
    NSData* sessionData = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:sessionData forKey:@"sessionData"];
    [defaults synchronize];
}

+ (FiresideSession*) savedSession {
    FiresideSession* session = nil;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData* sessionData = [defaults objectForKey:@"sessionData"];
    
    if (sessionData) {
        session = [NSKeyedUnarchiver unarchiveObjectWithData:sessionData];
    }
    
    return session;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.oAuthAuthorization forKey:@"oAuthAuthorization"];
    [encoder encodeObject:self.launchPadAuthorization forKey:@"launchPadAuthorization"];
    [encoder encodeObject:self.currentLaunchPadAccount forKey:@"currentLaunchPadAccount"];
    [encoder encodeObject:self.lastRoom forKey:@"lastRoom"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.oAuthAuthorization = [decoder decodeObjectForKey:@"oAuthAuthorization"];
        self.launchPadAuthorization = [decoder decodeObjectForKey:@"launchPadAuthorization"];
        self.currentLaunchPadAccount = [decoder decodeObjectForKey:@"currentLaunchPadAccount"];
        self.lastRoom = [decoder decodeObjectForKey:@"lastRoom"];
    }
    return self;
}

@end
