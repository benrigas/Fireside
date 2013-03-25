//
//  CampfireSoundLoader.m
//  Fireside
//
//  Created by Ben Rigas on 3/24/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireSoundLoader.h"
#import "CampfireAPIClient.h"

@implementation CampfireSoundLoader

+ (NSString *) URLEncodeString:(NSString *) str
{
    
    NSMutableString *tempStr = [NSMutableString stringWithString:str];
    [tempStr replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];
    
    
    return [[NSString stringWithFormat:@"%@",tempStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (void) getSoundWithURL:(NSString*)urlString
                 success:(void (^)(NSString* localSoundFilePath))success
                 failure:(void (^)(NSError* error))failure {
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                               NSUserDomainMask, YES) objectAtIndex:0]
                          stringByAppendingPathComponent:url.lastPathComponent];
    
    //NSURL* localFileURL = [NSURL URLWithString:[CampfireSoundLoader URLEncodeString:filePath]];
    //NSLog(@"local url = %@", localFileURL);
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //NSLog(@"file already exists at %@", localFileURL);
        success(filePath);
    }
    else {
        //NSLog(@"fetching sound file %@", urlString);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *soundData = [NSData dataWithContentsOfURL:url];
            [soundData writeToFile:filePath atomically:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(filePath);
                //NSLog(@"done fetching file %@", urlString);
            });
        });
    }
}

@end
