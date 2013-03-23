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

@implementation CampfireMessageCell

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
    BOOL onlyLink = [CampfireMessageCell messageContainsOnlyImageLink:message.body];
    
    if (onlyLink) {
//        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 320, 100)];
//        imageView.tag = 3;
//        [self.contentView addSubview:imageView];
////        imageView.backgroundColor = [UIColor yellowColor];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [imageView setImageWithURL:[NSURL URLWithString:message.body]];
        
        OLImageView* imageView = [[OLImageView alloc] initWithFrame:CGRectMake(0, 40, 320, 100)];
        imageView.tag = 3;
        [self.contentView addSubview:imageView];
        //        imageView.backgroundColor = [UIColor yellowColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImageWithURL:[NSURL URLWithString:message.body]];
        
        //UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedImage:)];
        //[imageView addGestureRecognizer:tap];
    }
    else {
        textLabel.text = message.body;
    }
    
    UILabel* nameLabel = (UILabel*)[self viewWithTag:1];
    
    [[CampfireUserAPI sharedInstance] getUserWithId:message.userId success:^(CampfireUser *user) {
        nameLabel.text = user.name;
    } failure:^(NSError *error) {
        NSLog(@"error getting user name");
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
    
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber error:&error];
    
    NSArray* matches = [detector matchesInString:message options:NSMatchingAnchored|NSMatchingHitEnd range:NSMakeRange(0, message.length)];
    
    if ([matches count] > 0) {
        NSTextCheckingResult* result = [matches objectAtIndex:0];
        if (result.range.length == message.length) {
            onlyContainsLink = YES;
        }
    }
    
    return onlyContainsLink;
}

+ (CGFloat) heightForMessage:(CampfireMessage*)message {
    CGFloat height = 44;
    
    if ([self messageContainsOnlyImageLink:message.body]) {
        height = 140;
    }
    else {
        CGSize size = [message.body sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(320, 9999)];
        height += size.height;
    }
    
    return height;
}

@end
