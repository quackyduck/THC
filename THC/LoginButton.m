//
//  LoginButton.m
//  THC
//
//  Created by Nicolas Melo on 7/22/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "LoginButton.h"

@implementation LoginButton

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
    [self drawCanvas4WithFrame:rect];
}

- (void)drawCanvas4WithFrame: (CGRect)frame;
{
    //// Color Declarations
//    UIColor* tHCButtonGray = [UIColor colorWithRed: 0.965 green: 0.965 blue: 0.965 alpha: .85];
    UIColor* tHCOrange = [UIColor colorWithRed: 1 green: 0.455 blue: 0.184 alpha: 1];
    UIColor *tHCWhite = [UIColor whiteColor];
    UIColor *tHCButtonGray = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    UIColor *buttonColor = tHCButtonGray;
    
    if (self.enabled) {
        NSLog(@"Button should be white!");
        buttonColor = tHCWhite;
    }
    
    
    if (self.state == UIControlStateHighlighted) {
        tHCOrange = [tHCOrange colorWithAlphaComponent:0.5];
    }
    
    //// Subframes
    CGRect group = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.04741 + 0.01) + 0.49, CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.10016 + 0.5), floor(CGRectGetWidth(frame) * 0.93169 + 0.01) - floor(CGRectGetWidth(frame) * 0.04741 + 0.01), floor(CGRectGetHeight(frame) * 0.87145 + 0.5) - floor(CGRectGetHeight(frame) * 0.10016 + 0.5));
    
    
    //// Group
    {
        //// Button Outline Drawing
        UIBezierPath* buttonOutlinePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(group) + floor(CGRectGetWidth(group) * 0.00000 + 0.5), CGRectGetMinY(group) + floor(CGRectGetHeight(group) * 0.00000 + 0.5), floor(CGRectGetWidth(group) * 1.00000 + 0.5) - floor(CGRectGetWidth(group) * 0.00000 + 0.5), floor(CGRectGetHeight(group) * 1.00000 + 0.5) - floor(CGRectGetHeight(group) * 0.00000 + 0.5))];
        [tHCOrange setFill];
        [buttonOutlinePath fill];
        [buttonColor setStroke];
        buttonOutlinePath.lineWidth = 0.5;
        [buttonOutlinePath stroke];
        
        
        //// Login Drawing
        CGRect loginRect = CGRectMake(CGRectGetMinX(group) + floor(CGRectGetWidth(group) * 0.25536) + 0.5, CGRectGetMinY(group) + floor(CGRectGetHeight(group) * 0.28030) + 0.5, floor(CGRectGetWidth(group) * 0.74464) - floor(CGRectGetWidth(group) * 0.25536), floor(CGRectGetHeight(group) * 0.71970) - floor(CGRectGetHeight(group) * 0.28030));
        {
            NSString* textContent = @"Login";
            NSMutableParagraphStyle* loginStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            loginStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary* loginFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Light" size: UIFont.buttonFontSize], NSForegroundColorAttributeName: buttonColor, NSParagraphStyleAttributeName: loginStyle};
            
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
