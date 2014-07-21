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
    
    if (self.state == UIControlStateHighlighted) {
        tHCOrange = [UIColor colorWithRed: 1 green: 0.455 blue: 0.184 alpha: .5f];
    }
    
    //// Shadow Declarations
    UIColor* buttonShadow = shadow2Color;
    CGSize buttonShadowOffset = CGSizeMake(1.1, 1.1);
    CGFloat buttonShadowBlurRadius = 1;
    
    
    //// Subframes
    CGRect group = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.00625 + 0.5), CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.02667 + 0.5), floor(CGRectGetWidth(frame) * 0.99375 + 0.5) - floor(CGRectGetWidth(frame) * 0.00625 + 0.5), floor(CGRectGetHeight(frame) * 0.97333 + 0.5) - floor(CGRectGetHeight(frame) * 0.02667 + 0.5));
    
    
    //// Group
    {
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(group) + floor(CGRectGetWidth(group) * 0.00000 + 0.5), CGRectGetMinY(group) + floor(CGRectGetHeight(group) * 0.00000 + 0.5), floor(CGRectGetWidth(group) * 1.00000 + 0.5) - floor(CGRectGetWidth(group) * 0.00000 + 0.5), floor(CGRectGetHeight(group) * 1.00000 + 0.5) - floor(CGRectGetHeight(group) * 0.00000 + 0.5))];
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
        CGRect textRect = CGRectMake(CGRectGetMinX(group) + floor(CGRectGetWidth(group) * 0.41236 + 0.2) + 0.3, CGRectGetMinY(group) + floor(CGRectGetHeight(group) * 0.32224 - 0.38) + 0.88, floor(CGRectGetWidth(group) * 0.58764 - 0.2) - floor(CGRectGetWidth(group) * 0.41236 + 0.2) + 0.39, floor(CGRectGetHeight(group) * 0.67776 + 0.38) - floor(CGRectGetHeight(group) * 0.32224 - 0.38) - 0.76);
        NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        textStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size: UIFont.buttonFontSize], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: textStyle};
        
        [@"Email\n" drawInRect: textRect withAttributes: textFontAttributes];
    }
}

-(void)setHighlighted:(BOOL)value {
    [super setHighlighted:value];
    [self setNeedsDisplay];
}

-(void)setSelected:(BOOL)value {
    [super setSelected:value];
    [self setNeedsDisplay];
}

-(void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self setNeedsDisplay];
}


@end
