//
//  CampfireUpload.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "MMDataObject.h"

@interface CampfireUpload : MMDataObject

/*
 <upload>
 <id type="integer">1</id>
 <name>picture.jpg</name>
 <room-id type="integer">1</room-id>
 <user-id type="integer">1</user-id>
 <byte-size type="integer">10063</byte-size>
 <content-type>image/jpeg</content-type>
 <full-url>https://account.campfirenow.com/room/1/uploads/1/picture.jpg</full-url>
 <created-at type="datetime">2009-11-20T23:25:14Z</created-at>
 </upload>
 */

@property (nonatomic, strong) NSNumber* id;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSNumber* roomId;
@property (nonatomic, strong) NSNumber* userId;
@property (nonatomic, strong) NSNumber* byteSize;
@property (nonatomic, strong) NSString* contentType;
@property (nonatomic, strong) NSString* fullUrl;
@property (nonatomic, strong) NSDate* createdAt;

@end
