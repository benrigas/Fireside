//
//  CampfireTimestampMessageCell.m
//  Fireside
//
//  Created by Ben Rigas on 4/6/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireTimestampMessageCell.h"

@implementation CampfireTimestampMessageCell

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
    label.text = [NSString stringWithFormat:@"%@", [self formatTimestamp:message.createdAt]];
}

- (NSString*)formatTimestamp:(NSDate*)timestamp {
    NSString* formattedTimestamp = nil;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
//    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    formattedTimestamp = [formatter stringFromDate:timestamp];
    
    return formattedTimestamp;
}

+ (BOOL) messageContainsOnlyImageLink:(NSString*)message {
    return NO;
}

+ (CGFloat) heightForMessage:(CampfireMessage*)message {
    return 29;
}

@end
