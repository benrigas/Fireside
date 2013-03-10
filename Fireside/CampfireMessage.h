//
//  CampfireMessage.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "MMDataObject.h"

@interface CampfireMessage : MMDataObject

/*
 <message>
 <id type="integer">1</id>
 <room-id type="integer">1</room-id>
 <user-id type="integer">2</user-id>
 <body>Hello Room</body>
 <created-at type="datetime">2009-11-22T23:46:58Z</created-at>
 <type>
 #{TextMessage || PasteMessage || SoundMessage || AdvertisementMessage ||
 AllowGuestsMessage || DisallowGuestsMessage || IdleMessage || KickMessage ||
 LeaveMessage || EnterMessage || SystemMessage || TimestampMessage ||
 TopicChangeMessage || UnidleMessage || LockMessage || UnlockMessage ||
 UploadMessage || ConferenceCreatedMessage || ConferenceFinishedMessage}
 </type>
 <starred>true</starred>
 </message>
 */

@property (nonatomic, strong) NSNumber* id;
@property (nonatomic, strong) NSNumber* roomId;
@property (nonatomic, strong) NSNumber* userId;
@property (nonatomic, strong) NSString* body;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSString* type; // maybe ENUM
@property (nonatomic, strong) NSNumber* starred;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSString* url;

@end
