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
    OLImageView* imageView = (OLImageView*)[self viewWithTag:3];
    if (imageView) {
        [imageView stopAnimating];
        [imageView removeFromSuperview];
        imageView = nil;
    }
    
//    UILabel* textLabel = (UILabel*)[self viewWithTag:2];
//    textLabel.text = nil;
    UIWebView* webView = (UIWebView*)[self viewWithTag:2];
    [webView stopLoading];
    [webView loadHTMLString:nil baseURL:nil];
//    self.contentView.backgroundColor = [UIColor orangeColor];
}

- (NSString*) emojify:(NSString*)messageText {
    NSString* emojifiedMessageText = nil;

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@":([a-z0-9\\+\\-_]+):"
                                                                           options:0
                                                                             error:NULL];
    emojifiedMessageText = [regex stringByReplacingMatchesInString:messageText options:0 range:NSMakeRange(0, [messageText length]) withTemplate:@"<img src=\"$1.png\" width=22 height=22/>"];

    return emojifiedMessageText;
}

- (void) displayMessage:(CampfireMessage *)message {
//    UILabel* textLabel = (UILabel*)[self viewWithTag:2];
    UIWebView* webView = (UIWebView*)[self viewWithTag:2];
    BOOL onlyLink = NO;
    NSString* messageText = nil;
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    CGFloat imageHeight = 100;
    
    if ([message.type isEqualToString:@"SoundMessage"]) {
        messageText = message.description;
        onlyLink = [CampfireMessageCell messageContainsOnlyImageLink:message.description];
        //[self playSoundForURL:message.url];
        imageHeight = 40;
    }
    else {
        messageText = message.body;
        onlyLink = [CampfireMessageCell messageContainsOnlyImageLink:message.body];
    }
    
    if (onlyLink) {
//        OLImageView* imageView = [[OLImageView alloc] initWithFrame:CGRectMake(0, 40, 320, imageHeight)];
//        imageView.tag = 3;
//        [self.contentView addSubview:imageView];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [imageView setImageWithURL:[NSURL URLWithString:messageText]];
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedImage:)];
//        [imageView addGestureRecognizer:tap];
        webView.delegate = self;
        webView.scrollView.scrollEnabled = NO;
        NSString* webHTML = [NSString stringWithFormat:@"<img src=\"%@\" style=\"max-height:%fpx;\"/>", messageText, imageHeight];
        webView.contentMode = UIViewContentModeLeft;
        [webView loadHTMLString:webHTML baseURL:baseURL];
    }
    else {
//        textLabel.text = messageText;
        webView.delegate = self;
        webView.scrollView.bounces = NO;
        webView.scrollView.scrollEnabled = NO;
        NSString* webHTML = [self htmlify:[self emojify:messageText]];
        [webView loadHTMLString:webHTML baseURL:baseURL];
//        webView.backgroundColor = [UIColor yellowColor];
    }
    
    UILabel* nameLabel = (UILabel*)[self viewWithTag:1];
    
    [[CampfireUserAPI sharedInstance] getUserWithId:message.userId success:^(CampfireUser *user) {
        nameLabel.text = user.name;
    } failure:^(NSError *error) {
        NSLog(@"error getting user name");
    }];
}

- (NSString*) htmlify:(NSString*)messageText {
    NSMutableString* htmlified = [[NSMutableString alloc] init];
    
    [htmlified appendFormat:@"<html>"];
    [htmlified appendFormat:@"<head><link rel=\'stylesheet\' id=\'message.css\' href=\'message.css\' type=\'text/css\' media=\'all\' /></head>"];
    [htmlified appendFormat:@"<p>%@</p></html>", messageText];
    return htmlified;
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
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
    CGFloat height = 32;
    
    if ([message.type isEqualToString:@"SoundMessage"]) {
        height = 80;
    }
    else if ([self messageContainsOnlyImageLink:message.body] || [self messageContainsOnlyImageLink:message.description]) {
        height = 140;
    }
    else {
        CGSize size = [message.body sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(320, 9999)];
        height += size.height;
    }
    
    return height;
}

@end
