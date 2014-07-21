//
//  SendEmailButton.m
//  THC
//
//  Created by Nicolas Melo on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "SendEmailButton.h"

@implementation SendEmailButton

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
    // Drawing code
    [self drawCanvas3WithFrame:rect];
}

- (void)drawCanvas3WithFrame: (CGRect)frame;
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* tHCOrange = [UIColor colorWithRed: 1 green: 0.455 blue: 0.184 alpha: 1];
    UIColor* shadow2Color = [UIColor colorWithRed: 0.725 green: 0.725 blue: 0.733 alpha: 1];
    
    //// Shadow Declarations
    UIColor* buttonShadow = shadow2Color;
    CGSize buttonShadowOffset = CGSizeMake(1.1, 1.1);
    CGFloat buttonShadowBlurRadius = 1;
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 2, CGRectGetMinY(frame) + 2, 316, 71)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, buttonShadowOffset, buttonShadowBlurRadius, [buttonShadow CGColor]);
    [tHCOrange setFill];
    [rectanglePath fill];
    
    ////// Rectangle Inner Shadow
    CGContextSaveGState(context);
    UIRectClip(rectanglePath.bounds);
    CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
    
    CGContextSetAlpha(context, CGColorGetAlpha([buttonShadow CGColor]));
    CGContextBeginTransparencyLayer(context, NULL);
    {
        UIColor* opaqueShadow = [buttonShadow colorWithAlphaComponent: 1];
        CGContextSetShadowWithColor(context, buttonShadowOffset, buttonShadowBlurRadius, [opaqueShadow CGColor]);
        CGContextSetBlendMode(context, kCGBlendModeSourceOut);
        CGContextBeginTransparencyLayer(context, NULL);
        
        [opaqueShadow setFill];
        [rectanglePath fill];
        
        CGContextEndTransparencyLayer(context);
    }
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    CGContextRestoreGState(context);
    
    
    
    //// Text Drawing
    CGRect textRect = CGRectMake(CGRectGetMinX(frame) + 132.3, CGRectGetMinY(frame) + 24.88, 55.39, 25.24);
    NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size: UIFont.buttonFontSize], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: textStyle};
    
    [@"Email\n" drawInRect: textRect withAttributes: textFontAttributes];
}

@end
