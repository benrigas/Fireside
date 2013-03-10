//
//  CampfireRoom.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "MMDataObject.h"

@interface CampfireRoom : MMDataObject

/*
 <room>
 <id type="integer">1</id>
 <name>North May St.</name>
 <topic>37signals HQ</topic>
 <membership-limit type="integer">60</membership-limit>
 <full type="boolean">false</full>
 <open-to-guests type="boolean">true</open-to-guests>
 <active-token-value>#{ 4c8fb -- requires open-to-guests is true}</active-token-value>
 <updated-at type="datetime">2009-11-17T19:41:38Z</updated-at>
 <created-at type="datetime">2009-11-17T19:41:38Z</created-at>
 <users type="array">
 ...
 </users>
 </room>
 */

@property (nonatomic, strong) NSNumber* id;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* topic;
@property (nonatomic, strong) NSNumber* membershipLimit;
@property (nonatomic, strong) NSNumber* full;
@property (nonatomic, strong) NSNumber* openToGuests;
@property (nonatomic, strong) NSString* activeTokenValue;
@property (nonatomic, strong) NSDate* updatedAt;
@property (nonatomic, strong) NSDate* createdAt;

@property (nonatomic, strong) NSMutableArray* users;

@end
