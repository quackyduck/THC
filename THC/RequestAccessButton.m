//
//  RequestAccessButton.m
//  THC
//
//  Created by Nicolas Melo on 7/22/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "RequestAccessButton.h"

@implementation RequestAccessButton

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
    [self drawCanvas5WithFrame:rect];
}

- (void)drawCanvas5WithFrame: (CGRect)frame;
{
    //// Color Declarations
    UIColor* tHCOrange = [UIColor colorWithRed: 1 green: 0.455 blue: 0.184 alpha: 1];
    UIColor *tHCWhite = [UIColor whiteColor];
    
    if (self.state == UIControlStateHighlighted) {
        tHCWhite = [tHCWhite colorWithAlphaComponent:0.5];
    }
    
    
    //// Subframes
    CGRect group = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.04741 + 0.01) + 0.49, CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.10016 + 0.5), floor(CGRectGetWidth(frame) * 0.93169 + 0.01) - floor(CGRectGetWidth(frame) * 0.04741 + 0.01), floor(CGRectGetHeight(frame) * 0.87145 + 0.5) - floor(CGRectGetHeight(frame) * 0.10016 + 0.5));
    
    
    //// Group
    {
        //// Button Outline Drawing
        UIBezierPath* buttonOutlinePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(group) + floor(CGRectGetWidth(group) * 0.00000 + 0.5), CGRectGetMinY(group) + floor(CGRectGetHeight(group) * 0.00000 + 0.5), floor(CGRectGetWidth(group) * 1.00000 + 0.5) - floor(CGRectGetWidth(group) * 0.00000 + 0.5), floor(CGRectGetHeight(group) * 1.00000 + 0.5) - floor(CGRectGetHeight(group) * 0.00000 + 0.5))];
        [tHCWhite setFill];
        [buttonOutlinePath fill];
        [tHCOrange setStroke];
        buttonOutlinePath.lineWidth = 0.5;
        [buttonOutlinePath stroke];
        
        
        //// Login Drawing
        CGRect loginRect = CGRectMake(CGRectGetMinX(group) + floor(CGRectGetWidth(group) * 0.17405 - 0.05) + 0.55, CGRectGetMinY(group) + floor(CGRectGetHeight(group) * 0.28865 + 0.45) + 0.05, floor(CGRectGetWidth(group) * 0.84958 - 0.45) - floor(CGRectGetWidth(group) * 0.17405 - 0.05) + 0.4, floor(CGRectGetHeight(group) * 0.71135 - 0.45) - floor(CGRectGetHeight(group) * 0.28865 + 0.45) + 0.9);
        {
            NSString* textContent = @"Request Access";
            NSMutableParagraphStyle* loginStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            loginStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary* loginFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Light" size: UIFont.buttonFontSize], NSForegroundColorAttributeName: tHCOrange, NSParagraphStyleAttributeName: loginStyle};
            
            [textContent drawInRect: CGRectOffset(loginRect, 0, (CGRectGetHeight(loginRect) - [textContent boundingRectWithSize: loginRect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: loginFontAttributes context: nil].size.height) / 2) withAttributes: loginFontAttributes];
        }
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
