//
//  CampfireEnterMessageCell.m
//  Fireside
//
//  Created by Ben Rigas on 4/13/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireEnterMessageCell.h"
#import "CampfireUserAPI.h"

@implementation CampfireEnterMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) displayMessage:(CampfireMessage *)message {
    UILabel* label = (UILabel*)[self viewWithTag:1];
    NSString* action = [self actionForMessage:message];

    [[CampfireUserAPI sharedInstance] getUserWithId:message.userId success:^(CampfireUser *user) {
        NSString* text = [NSString stringWithFormat:@"%@ has %@ the room", user.name, action];
        label.text = text;
    } failure:^(NSError *error) {
        NSLog(@"error getting user name");
    }];
}

- (NSString*) actionForMessage:(CampfireMessage*)message {
    NSString* action = [message.type isEqualToString:@"EnterMessage"] ? @"entered" : @"left";
    
    return action;
}

+ (BOOL) messageContainsOnlyImageLink:(NSString*)message {
    return NO;
}

+ (CGFloat) heightForMessage:(CampfireMessage*)message {
    return 29;
}

@end
