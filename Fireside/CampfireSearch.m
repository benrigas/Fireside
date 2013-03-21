//
//  CampfireSearch.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireSearch.h"

@implementation CampfireSearch

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.messages forKey:@"messages"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.messages = [decoder decodeObjectForKey:@"messages"];
    }
    return self;
}

@end
