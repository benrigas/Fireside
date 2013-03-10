//
//  CampfireAccount.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "MMDataObject.h"

@interface CampfireAccount : MMDataObject

/*
 <account>
 <id type="integer">1</id>
 <name>Your Company</name>
 <subdomain>yourco</subdomain>
 <plan>premium</plan>
 <owner-id type="integer">#{user_id of account owner}</owner-id>
 <time-zone>America/Chicago</time-zone>
 <storage type="integer">17374444</storage>
 <created-at type="datetime">2011-01-12T15:00:00Z</created-at>
 <updated-at type="datetime">2011-01-12T15:00:00Z</updated-at>
 </account>
 */

@property (nonatomic, strong) NSNumber* id;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* subdomain;
@property (nonatomic, strong) NSString* plan;
@property (nonatomic, strong) NSNumber* ownerId;
@property (nonatomic, strong) NSString* timeZone;
@property (nonatomic, strong) NSNumber* storageType;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSDate* updatedAt;

@end
