//
//  CampfireMessageCell.m
//  Fireside
//
//  Created by Ben Rigas on 3/22/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "CampfireMessageCell.h"
#import "UIImageView+AFNetworking.h"
#import "CampfireUserAPI.h"
#import "OLImageView.h"
#import <AVFoundation/AVFoundation.h>
#import "CampfireSoundLoader.h"

@implementation CampfireMessageCell
{
    AVAudioPlayer* player;
}

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

- (void) prepareForReuse {
    // remove any image views
    
    UIImageView* imageView = (UIImageView*)[self viewWithTag:3];
    if (imageView) {
        [imageView removeFromSuperview];
    }
    
    UILabel* textLabel = (UILabel*)[self viewWithTag:2];
    textLabel.text = nil;
//    self.contentView.backgroundColor = [UIColor orangeColor];
}

- (void) displayMessage:(CampfireMessage *)message {
    UILabel* textLabel = (UILabel*)[self viewWithTag:2];
    BOOL onlyLink = NO;
    NSString* messageText = nil;
    
    if ([message.type isEqualToString:@"SoundMessage"]) {
        messageText = message.description;
        onlyLink = [CampfireMessageCell messageContainsOnlyImageLink:message.description];
        [self playSoundForURL:message.url];
    }
    else {
        messageText = message.body;
        onlyLink = [CampfireMessageCell messageContainsOnlyImageLink:message.body];
    }
    
    if (onlyLink) {
        OLImageView* imageView = [[OLImageView alloc] initWithFrame:CGRectMake(0, 40, 320, 100)];
        imageView.tag = 3;
        [self.contentView addSubview:imageView];
//        imageView.backgroundColor = [UIColor yellowColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImageWithURL:[NSURL URLWithString:messageText]];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedImage:)];
        [imageView addGestureRecognizer:tap];
    }
    else {
        textLabel.text = messageText;
    }
    
    UILabel* nameLabel = (UILabel*)[self viewWithTag:1];
    
    [[CampfireUserAPI sharedInstance] getUserWithId:message.userId success:^(CampfireUser *user) {
        nameLabel.text = user.name;
    } failure:^(NSError *error) {
        NSLog(@"error getting user name");
    }];
}

- (void) playSoundForURL:(NSString*)urlString
{
    [CampfireSoundLoader getSoundWithURL:urlString success:^(NSString *localSoundFilePath) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL* localSoundFileURL = [NSURL fileURLWithPath:localSoundFilePath];
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:localSoundFileURL error:NULL];
            player.currentTime = 0;
            player.volume = 1.0f;
            [player play];
        });
    } failure:^(NSError *error) {
        NSLog(@"error playing file: %@", urlString);
    }];
}

- (void) tappedImage:(UIGestureRecognizer*)tapGesture {
    NSLog(@"tap");
    OLImageView* imageView = (OLImageView*)tapGesture.view;
    if (imageView.isAnimating) {
        [imageView stopAnimating];
    }
    else {
        [imageView startAnimating];
    }
}

+ (BOOL) messageContainsOnlyImageLink:(NSString*)message {
    BOOL onlyContainsLink = NO;
    
    if (message) {
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        
        NSArray* matches = [detector matchesInString:message options:NSMatchingAnchored|NSMatchingHitEnd range:NSMakeRange(0, message.length)];
        
        if ([matches count] > 0) {
            NSTextCheckingResult* result = [matches objectAtIndex:0];
            if (result.range.length == message.length) {
                onlyContainsLink = YES;
                //NSLog(@"ONLY LINK: %@", message);
            }
        }
    }
    return onlyContainsLink;
}

+ (CGFloat) heightForMessage:(CampfireMessage*)message {
    CGFloat height = 44;
    
    if ([self messageContainsOnlyImageLink:message.body] || [self messageContainsOnlyImageLink:message.description]) {
        height = 140;
    }
    else {
        CGSize size = [message.body sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(320, 9999)];
        height += size.height;
    }
    
    return height;
}

@end
