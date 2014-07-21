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
    [self drawEmailButtonCanvasWithFrame:rect];
}

- (void)drawEmailButtonCanvasWithFrame: (CGRect)frame;
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
    UIImage* btn_email_normal = [UIImage imageNamed: @"btn_email_normal"];
    
    
    //// Subframes
    CGRect group = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.01217 + 0.34) + 0.16, CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.01153 + 0.08) + 0.42, floor(CGRectGetWidth(frame) * 0.97369 + 0.34) - floor(CGRectGetWidth(frame) * 0.01217 + 0.34), floor(CGRectGetHeight(frame) * 0.94760 + 0.08) - floor(CGRectGetHeight(frame) * 0.01153 + 0.08));
    
    
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
        
        [btn_email_normal drawInRect:CGRectMake((self.frame.size.width/2) - (btn_email_normal.size.width/2), (self.frame.size.height / 2) - (btn_email_normal.size.height / 2), btn_email_normal.size.width, btn_email_normal.size.height)];
        
//        [self.buttonImageNormal drawInRect:CGRectMake((self.frame.size.width/2) - (self.buttonImageNormal.size.width/2), (self.frame.size.height / 2) - (self.buttonImageNormal.size.height / 2), self.buttonImageNormal.size.width, self.buttonImageNormal.size.height)];
        
        
//        //// Email Image Drawing
//        CGRect emailImageRect = CGRectMake(CGRectGetMinX(group) + floor(CGRectGetWidth(group) * 0.43171 - 0.32) + 0.82, CGRectGetMinY(group) + floor(CGRectGetHeight(group) * 0.39203 - 0.47) + 0.97, floor(CGRectGetWidth(group) * 0.58300 - 0.19) - floor(CGRectGetWidth(group) * 0.43171 - 0.32) - 0.13, floor(CGRectGetHeight(group) * 0.60797 + 0.47) - floor(CGRectGetHeight(group) * 0.39203 - 0.47) - 0.94);
//        UIBezierPath* emailImagePath = [UIBezierPath bezierPathWithRect: emailImageRect];
//        CGContextSaveGState(context);
//        [emailImagePath addClip];
//        [btn_email_normal drawInRect: CGRectMake(floor(CGRectGetMinX(emailImageRect) + 0.5), floor(CGRectGetMinY(emailImageRect) - 79 + 0.5), btn_email_normal.size.width, btn_email_normal.size.height)];
//        CGContextRestoreGState(context);
    }
    
    
    
    
}

@end
