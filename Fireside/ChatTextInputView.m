//
//  ChatTextInputView.m
//  Fireside
//
//  Created by Ben Rigas on 5/4/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "ChatTextInputView.h"

@implementation ChatTextInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 8,
                      bounds.size.width - 20, bounds.size.height - 16);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
