//
//  CreateReportButton.m
//  THC
//
//  Created by Nicolas Melo on 7/12/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "CreateReportButton.h"

@implementation CreateReportButton

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
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* tHCButtonGray = [UIColor colorWithRed: 0.965f green: 0.965f blue: 0.965f alpha: 1];
    UIColor* tHCOrange = [UIColor colorWithRed: 1 green: 0.455f blue: 0.184f alpha: 1];
    UIColor* buttonStrokeColor = [UIColor colorWithRed: 0.882f green: 0.886f blue: 0.89f alpha: 1];
    UIColor* shadow2Color = [UIColor colorWithRed: 0.725f green: 0.725f blue: 0.733f alpha: 1];
    
    //// Shadow Declarations
    UIColor* buttonShadow = shadow2Color;
    CGSize buttonShadowOffset = CGSizeMake(1.1f, 1.1f);
    CGFloat buttonShadowBlurRadius = 1;
    
    //// Image Declarations
    UIImage* btn_create_normal = [UIImage imageNamed: @"btn_create_normal"];
    
    
    if (self.state == UIControlStateHighlighted) {
        btn_create_normal = [UIImage imageNamed: @"btn_create_pressed"];
        tHCOrange = [UIColor colorWithRed: 1 green: 0.455f blue: 0.184f alpha: .5f];
    }
    
    //// Group
    {
        //// buttonOutline Drawing
        UIBezierPath* buttonOutlinePath = [UIBezierPath bezierPathWithRect: CGRectMake(rect.origin.x, rect.origin.y, 318, 48)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, buttonShadowOffset, buttonShadowBlurRadius, [buttonShadow CGColor]);
        [tHCButtonGray setFill];
        [buttonOutlinePath fill];
        CGContextRestoreGState(context);
        
        [buttonStrokeColor setStroke];
        buttonOutlinePath.lineWidth = 0.5;
        [buttonOutlinePath stroke];
        
        //// Group 2
        {
            //// newReportText Drawing
            CGRect newReportTextRect = CGRectMake(88.5f, 13.06f, 169, 22.38f);
            {
                NSString* textContent = @"Create New Report";
                NSMutableParagraphStyle* newReportTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
                newReportTextStyle.alignment = NSTextAlignmentCenter;
                
                NSDictionary* newReportTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Medium" size: UIFont.labelFontSize], NSForegroundColorAttributeName: tHCOrange, NSParagraphStyleAttributeName: newReportTextStyle};
                
                [textContent drawInRect: CGRectOffset(newReportTextRect, 0, (CGRectGetHeight(newReportTextRect) - [textContent boundingRectWithSize: newReportTextRect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: newReportTextFontAttributes context: nil].size.height) / 2) withAttributes: newReportTextFontAttributes];
            }
            
            
            //// image Drawing
            UIBezierPath* imagePath = [UIBezierPath bezierPathWithRect: CGRectMake(61, 10.75, 22, 27)];
            CGContextSaveGState(context);
            [imagePath addClip];
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextDrawTiledImage(context, CGRectMake(61, 17, btn_create_normal.size.width, btn_create_normal.size.height), btn_create_normal.CGImage);
            CGContextRestoreGState(context);
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
