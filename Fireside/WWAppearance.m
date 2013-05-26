//
//  WWAppearance.m
//  Fireside
//
//  Created by Ben Rigas on 4/21/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "WWAppearance.h"

@implementation WWAppearance

+ (UIImage*) navigationBarBackgroundImage {
    UIImage* image = nil;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 44), YES, 0.0f);
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 0.51 green: 0.706 blue: 0.824 alpha: 1];
    CGFloat fillColorRGBA[4];
    [fillColor getRed: &fillColorRGBA[0] green: &fillColorRGBA[1] blue: &fillColorRGBA[2] alpha: &fillColorRGBA[3]];
    
    UIColor* upperColor = [UIColor colorWithRed: (fillColorRGBA[0] * 0.8 + 0.2) green: (fillColorRGBA[1] * 0.8 + 0.2) blue: (fillColorRGBA[2] * 0.8 + 0.2) alpha: (fillColorRGBA[3] * 0.8 + 0.2)];
    
    //// NavigationBar Drawing
    UIBezierPath* navigationBarPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 320, 44) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: CGSizeMake(3, 3)];
    [navigationBarPath closePath];
    [upperColor setFill];
    [navigationBarPath fill];
    
    


    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*) barButtonItemBackgroundImage {
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 33), NO, 0.0f);

    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 0.608 green: 0.765 blue: 0.859 alpha: 0];
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.537];
    UIColor* gradientColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.432];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)gradientColor.CGColor,
                               (id)[UIColor colorWithRed: 0.804 green: 0.882 blue: 0.929 alpha: 0.216].CGColor,
                               (id)fillColor.CGColor, nil];
    CGFloat gradientLocations[] = {0.35, 1, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Shadow Declarations
    UIColor* outer = strokeColor;
    CGSize outerOffset = CGSizeMake(0.1, 1.1);
    CGFloat outerBlurRadius = 1;
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(2, 0, 16, 30) cornerRadius: 3];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, outerOffset, outerBlurRadius, outer.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(10, 0), CGPointMake(10, 30), 0);
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    


    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//    return image;
}

+ (UIImage*) toolbarBackgroundImage {
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 38), NO, 0.0f);

    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 0.608 green: 0.765 blue: 0.859 alpha: 1];
    CGFloat fillColorRGBA[4];
    [fillColor getRed: &fillColorRGBA[0] green: &fillColorRGBA[1] blue: &fillColorRGBA[2] alpha: &fillColorRGBA[3]];
    
    UIColor* upper = [UIColor colorWithRed: (fillColorRGBA[0] * 0.9 + 0.1) green: (fillColorRGBA[1] * 0.9 + 0.1) blue: (fillColorRGBA[2] * 0.9 + 0.1) alpha: (fillColorRGBA[3] * 0.9 + 0.1)];
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 320, 38)];
    [upper setFill];
    [rectanglePath fill];
    
    

    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*) textfieldBackgroundImage {
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(50, 32), NO, 0.0f);

    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.751];
    UIColor* color = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Shadow Declarations
    UIColor* shadow = strokeColor;
    CGSize shadowOffset = CGSizeMake(1.1, 1.1);
    CGFloat shadowBlurRadius = 3.5;
    
    //// Text Field Drawing
    UIBezierPath* textFieldPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(2, 2, 46, 28) cornerRadius: 3];
    [color setFill];
    [textFieldPath fill];
    
    ////// Text Field Inner Shadow
    CGRect textFieldBorderRect = CGRectInset([textFieldPath bounds], -shadowBlurRadius, -shadowBlurRadius);
    textFieldBorderRect = CGRectOffset(textFieldBorderRect, -shadowOffset.width, -shadowOffset.height);
    textFieldBorderRect = CGRectInset(CGRectUnion(textFieldBorderRect, [textFieldPath bounds]), -1, -1);
    
    UIBezierPath* textFieldNegativePath = [UIBezierPath bezierPathWithRect: textFieldBorderRect];
    [textFieldNegativePath appendPath: textFieldPath];
    textFieldNegativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = shadowOffset.width + round(textFieldBorderRect.size.width);
        CGFloat yOffset = shadowOffset.height;
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                    shadowBlurRadius,
                                    shadow.CGColor);
        
        [textFieldPath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(textFieldBorderRect.size.width), 0);
        [textFieldNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [textFieldNegativePath fill];
    }
    CGContextRestoreGState(context);
    
    
    



    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
}

+ (UIImage*) sendButtonBackgroundImage {
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 42), NO, 0.0f);

    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 0.608 green: 0.765 blue: 0.859 alpha: 0];
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.537];
    UIColor* gradientColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.432];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)gradientColor.CGColor,
                               (id)[UIColor colorWithRed: 0.804 green: 0.882 blue: 0.929 alpha: 0.216].CGColor,
                               (id)fillColor.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Shadow Declarations
    UIColor* outer = strokeColor;
    CGSize outerOffset = CGSizeMake(0.1, 1.1);
    CGFloat outerBlurRadius = 1;
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(2, 0, 16, 40) cornerRadius: 3];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, outerOffset, outerBlurRadius, outer.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(10, 0), CGPointMake(10, 40), 0);
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    

    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    
}

@end
