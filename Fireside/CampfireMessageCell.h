//
//  CampfireMessageCell.h
//  Fireside
//
//  Created by Ben Rigas on 3/22/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CampfireMessage.h"

@interface CampfireMessageCell : UITableViewCell

- (void) displayMessage:(CampfireMessage*)message;

+ (CGFloat) heightForMessage:(CampfireMessage*)message;

@end
