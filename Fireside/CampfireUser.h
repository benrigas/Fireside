//
//  CampfireUser.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "MMDataObject.h"

@interface CampfireUser : MMDataObject

/*
 <user>
 <id type="integer">1</id>
 <name>Jason Fried</name>
 <email-address>jason@37signals.com</email-address>
 <admin type="boolean">#{true || false}</admin>
 <created-at type="datetime">2009-11-20T16:41:39Z</created-at>
 <type>#{Member || Guest}</type>
 <avatar-url>https://asset0.37img.com/global/.../avatar.png</avatar-url>
 </user>
 */

@property (nonatomic, strong) NSNumber* id;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* emailAddress;
@property (nonatomic) BOOL admin;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* avatarUrl;

@end
