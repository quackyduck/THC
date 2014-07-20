//
//  ContactInfoButton.m
//  THC
//
//  Created by Nicolas Melo on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ContactInfoButton.h"

@implementation ContactInfoButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawPhoneButtonCanvasWithFrame:rect];
}

- (void)drawPhoneButtonCanvasWithFrame: (CGRect)frame;
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color7 = [UIColor colorWithRed: 0.969 green: 0.969 blue: 0.969 alpha: 1];
    UIColor* color8 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.1];
    
    //// Shadow Declarations
    UIColor* shadow3 = [UIColor.blackColor colorWithAlphaComponent: 0.35];
    CGSize shadow3Offset = CGSizeMake(1.1, 1.1);
    CGFloat shadow3BlurRadius = 3;
    
    //// Image Declarations
    UIImage* btn_phone_normal2 = [UIImage imageNamed: @"btn_phone_normal"];
    
    
    //// Subframes
    CGRect group = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.01402 - 0.08) + 0.58, CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.00914 - 0) + 0.5, floor(CGRectGetWidth(frame) * 0.97639 - 0.08) - floor(CGRectGetWidth(frame) * 0.01402 - 0.08), floor(CGRectGetHeight(frame) * 0.95687 - 0) - floor(CGRectGetHeight(frame) * 0.00914 - 0));
    
    
    //// Group
    {
        //// Button Border Drawing
        UIBezierPath* buttonBorderPath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(group) + floor(CGRectGetWidth(group) * 0.00000 + 0.5), CGRectGetMinY(group) + floor(CGRectGetHeight(group) * 0.00000 + 0.5), floor(CGRectGetWidth(group) * 1.00000 + 0.5) - floor(CGRectGetWidth(group) * 0.00000 + 0.5), floor(CGRectGetHeight(group) * 1.00000 + 0.5) - floor(CGRectGetHeight(group) * 0.00000 + 0.5))];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow3Offset, shadow3BlurRadius, [shadow3 CGColor]);
        [color7 setFill];
        [buttonBorderPath fill];
        CGContextRestoreGState(context);
        
        [color8 setStroke];
        buttonBorderPath.lineWidth = 1;
        [buttonBorderPath stroke];
        
        
        //// Phone Image Drawing
        CGRect phoneImageRect = CGRectMake(CGRectGetMinX(group) + floor(CGRectGetWidth(group) * 0.43978 - 0.34) + 0.84, CGRectGetMinY(group) + floor(CGRectGetHeight(group) * 0.35676 + 0.03) + 0.47, floor(CGRectGetWidth(group) * 0.56782 - 0) - floor(CGRectGetWidth(group) * 0.43978 - 0.34) - 0.34, floor(CGRectGetHeight(group) * 0.64324 - 0.03) - floor(CGRectGetHeight(group) * 0.35676 + 0.03) + 0.06);
        UIBezierPath* phoneImagePath = [UIBezierPath bezierPathWithRect: phoneImageRect];
        CGContextSaveGState(context);
        [phoneImagePath addClip];
        [btn_phone_normal2 drawInRect: CGRectMake(floor(CGRectGetMinX(phoneImageRect) + 0.5), floor(CGRectGetMinY(phoneImageRect) - 76 + 0.5), btn_phone_normal2.size.width, btn_phone_normal2.size.height)];
        CGContextRestoreGState(context);
    }
}



@end
