//
//  CampfireUpload.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireUpload.h"

@implementation CampfireUpload

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.roomId forKey:@"roomId"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.byteSize forKey:@"byteSize"];
    [encoder encodeObject:self.contentType forKey:@"contentType"];
    [encoder encodeObject:self.fullUrl forKey:@"fullUrl"];
    [encoder encodeObject:self.createdAt forKey:@"createdAt"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.id = [decoder decodeObjectForKey:@"id"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.roomId = [decoder decodeObjectForKey:@"roomId"];
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.byteSize = [decoder decodeObjectForKey:@"byteSize"];
        self.contentType = [decoder decodeObjectForKey:@"contentType"];
        self.fullUrl = [decoder decodeObjectForKey:@"fullUrl"];
        self.createdAt = [decoder decodeObjectForKey:@"createdAt"];
    }
    return self;
}

@end
