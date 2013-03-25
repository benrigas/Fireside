//
//  CampfireSoundLoader.h
//  Fireside
//
//  Created by Ben Rigas on 3/24/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CampfireSoundLoader : NSObject

+ (void) getSoundWithURL:(NSString*)urlString
                 success:(void (^)(NSString* localSoundFilePath))success
                 failure:(void (^)(NSError* error))failure;

+ (NSString *) URLEncodeString:(NSString *)str;

@end
